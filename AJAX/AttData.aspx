<%@ Page Language="C#" CodePage="65001" AutoEventWireup="true"  %>
<%@ Import Namespace="System.Data" %>
<%@Import Namespace = "System.Text"%>
<%@Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.IO"%>
<%@ Import Namespace = "System.Linq"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Web.Script.Serialization"%>
<%@ Import Namespace = "Newtonsoft.Json"%>
<%@ Import Namespace = "Newtonsoft.Json.Linq"%>

<script runat="server">
    protected string SQL = "";
    protected string strConnB = "";
    protected string cust_area = "";
    protected string cust_seq = "";
    protected string att_sql = "";

    protected void Page_Load(object sender, EventArgs e) {
        if (Request["branch"] == "N") strConnB = Conn.OptBN;
        if (Request["branch"] == "C") strConnB = Conn.OptBC;
        if (Request["branch"] == "S") strConnB = Conn.OptBS;
        if (Request["branch"] == "K") strConnB = Conn.OptBK;

        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "Select * from vbr_opt where opt_sqlno='" + Request["opt_sqlno"] + "' ";
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    cust_area = dr.SafeRead("cust_area", "");
                    cust_seq = dr.SafeRead("cust_seq", "");
                    att_sql = dr.SafeRead("att_sql", "");
                }
            }
        }

        if (Request["type"] == "brattlist") {
            Response.Write(JsonConvert.SerializeObject(GetBRAttAll(), Formatting.Indented, new DBNullCreationConverter()));
        }
        if (Request["type"] == "bratt") {
            Response.Write(JsonConvert.SerializeObject(GetBRAtt(att_sql), Formatting.Indented, new DBNullCreationConverter()));
        }
    }

    private DataTable GetBRAttAll() {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "Select *,''deptnm,''magnm ";
            SQL += "from custz_att ";
            SQL += "where cust_area='" + cust_area + "' ";
            SQL += "and cust_seq='" + cust_seq + "' ";
            DataTable dt = new DataTable();
            connB.DataTable(SQL, dt);

            for (int i = 0; i < dt.Rows.Count; i++) {
                if (dt.Rows[i].SafeRead("dept", "").Trim() == "T")
                    dt.Rows[i]["deptnm"] = "商標";
                else if (dt.Rows[i].SafeRead("dept", "").Trim() == "P")
                    dt.Rows[i]["deptnm"] = "專利";

                if (dt.Rows[i].SafeRead("att_mag", "").Trim() == "Y")
                    dt.Rows[i]["magnm"] = "需要";
                else
                    dt.Rows[i]["magnm"] = "不需要";
            }

            return dt;
        }
    }

    private DataTable GetBRAtt(string patt_sql) {
        DataTable oTable = GetBRAttAll();
        DataTable nTable = oTable.Select("att_sql='" + patt_sql + "'").CopyToDataTable();
        return nTable;
    }
</script>
