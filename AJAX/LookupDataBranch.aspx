<%@ Page Language="C#" CodePage="65001" AutoEventWireup="true"  %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Text"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.IO"%>
<%@ Import Namespace = "System.Linq"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Web.Script.Serialization"%>
<%@ Import Namespace = "Newtonsoft.Json"%>
<%@ Import Namespace = "Newtonsoft.Json.Linq"%>

<script runat="server">
    protected string SQL = "";
    protected string strConnB = "";
    protected string type = "";

    protected void Page_Load(object sender, EventArgs e) {
        strConnB = Conn.OptB(Request["branch"]??"K");
        type = (Request["type"] ?? "").ToString().ToLower();
        DataTable rtn = new DataTable();

        if (type == "getagtdata") rtn = GetAgtData();//代理人清單
        if (type == "getarcasedata") rtn = GetArcaseList();//交辦案性
        
        var settings = new JsonSerializerSettings()
        {
            Formatting = Formatting.Indented,
            ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
            Converters = new List<JsonConverter> { new DBNullCreationConverter() }//dbnull轉空字串
        };
        Response.Write(JsonConvert.SerializeObject(rtn, settings).ToUnicode());
    }

    protected DataTable GetAgtData() {
        using (DBHelper conn = new DBHelper(strConnB, false)) {
            SQL = "SELECT agt_no,''agt_name,''strcomp_name,agt_name1,agt_name2,agt_name3,treceipt ";
            SQL += ",(select form_name from cust_code where code_type='company' and cust_code=agt.treceipt) as comp_name ";
            SQL += "FROM agt ";
            SQL += "ORDER BY agt_no";

            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            for (int i = 0; i < dt.Rows.Count; i++) {
                dt.Rows[i]["agt_name"] = dt.Rows[i].SafeRead("agt_name1", "");
                dt.Rows[i]["agt_name"] += (dt.Rows[i].SafeRead("agt_name2", "") == "" ? "" : "&" + dt.Rows[i].SafeRead("agt_name2", ""));
                dt.Rows[i]["agt_name"] += (dt.Rows[i].SafeRead("agt_name3", "") == "" ? "" : "&" + dt.Rows[i].SafeRead("agt_name3", ""));

                dt.Rows[i]["strcomp_name"] = (dt.Rows[i].SafeRead("comp_name", "") == "" ? "" : "(" + dt.Rows[i].SafeRead("comp_name", "") + ")");
            }
            return dt;
        }
    }

    protected DataTable GetArcaseList() {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
			SQL = "SELECT a.rs_type,a.rs_class,a.rs_code,a.prt_code,a.rs_detail,a.remark ";
			SQL += " ,(select code_name from cust_code where code_type=a.rs_type and cust_code=a.rs_class) as rs_codenm ";
			SQL += " FROM code_br a ";
			SQL += " join code_act as b on a.sqlno = b.sqlno ";
			SQL += " WHERE b.spe_ctrl like '%,OPT,%' ";
			SQL += " and getdate() >= beg_date ";
			SQL += " ORDER BY rs_code ";

            DataTable dt = new DataTable();
            connB.DataTable(SQL, dt);
            
            return dt;
        }
    }
</script>
