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

    protected string branch = "";
    protected string cgrs = "";
    protected string RS_type = "";
    protected string RS_class = "";
    protected string RS_code = "";

    protected void Page_Load(object sender, EventArgs e) {
        branch = Request["branch"]??"K";
        cgrs = Request["cgrs"]??"";
        RS_type = Request["RS_type"]??"";
        RS_class = Request["RS_class"] ?? "";
        RS_code = Request["RS_code"] ?? "";

        strConnB = Conn.OptB(branch);
        DataTable dt = new DataTable();
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "Select remark,''agt_name ";
            SQL += ",(SELECT agt_name1 FROM agt where agt_no=c.remark) as agt_name1 ";
            SQL += ",(SELECT agt_name2 FROM agt where agt_no=c.remark) as agt_name2 ";
            SQL += ",(SELECT agt_name3 FROM agt where agt_no=c.remark) as agt_name3 ";
            SQL += " from code_br c where gs='Y' ";
            SQL += " and (end_date is null or end_date = '' or end_date > getdate())";
            SQL += " and rs_type='" + RS_type + "'";

            connB.DataTable(SQL, dt);
            
            for (int i = 0; i < dt.Rows.Count; i++) {
                dt.Rows[i]["agt_name"] = dt.Rows[i].SafeRead("agt_name1", "");
                dt.Rows[i]["agt_name"] += (dt.Rows[i].SafeRead("agt_name2", "") == "" ? "" : "＆" + dt.Rows[i].SafeRead("agt_name2", ""));
                dt.Rows[i]["agt_name"] += (dt.Rows[i].SafeRead("agt_name3", "") == "" ? "" : "＆" + dt.Rows[i].SafeRead("agt_name3", ""));
            }
        }
        
        var settings = new JsonSerializerSettings() {
            Formatting = Formatting.Indented,
            ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
            Converters = new List<JsonConverter> { new DBNullCreationConverter() }//dbnull轉空字串
        };

        Response.Write(JsonConvert.SerializeObject(dt, settings).ToUnicode());
    }
</script>
