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

    protected void Page_Load(object sender, EventArgs e) {
        strConnB = Conn.OptB(Request["branch"]);
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

            var settings = new JsonSerializerSettings() {
                Formatting = Formatting.Indented,
                ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
                Converters = new List<JsonConverter> { new DBNullCreationConverter() }//dbnull轉空字串
            };
            Response.Write(JsonConvert.SerializeObject(dt, settings).ToUnicode());
        }
    }
</script>
