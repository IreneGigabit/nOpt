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
    protected string rs_class = "";
    protected string submittask = "";

    protected void Page_Load(object sender, EventArgs e) {
        branch = Request["branch"]??"K";
        strConnB = Conn.OptB(branch);
        cgrs = Request["cgrs"] ?? "";
        rs_class = Request["rs_class"] ?? "";
        submittask = Request["submittask"] ?? "";

        DataTable dt = new DataTable();
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "select * from code_br ";
            SQL += "where dept='" + Sys.GetSession("dept") + "' and mark='B' ";
            if (cgrs != "") {
                SQL += " and " + cgrs + "='Y' ";
            }
            if (rs_class != "") {
                SQL += " and rs_class='" + rs_class + "' ";
            }
            SQL += " and (end_date is null or end_date = '' or end_date > getdate()) ";
            SQL += " ORDER BY rs_code";

            connB.DataTable(SQL, dt);
        }
        
        var settings = new JsonSerializerSettings() {
            Formatting = Formatting.Indented,
            ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
            Converters = new List<JsonConverter> { new DBNullCreationConverter() }//dbnull轉空字串
        };

        Response.Write(JsonConvert.SerializeObject(dt, settings).ToUnicode());
    }
</script>
