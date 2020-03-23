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
    protected string rs_code = "";
    protected string submittask = "";

    protected void Page_Load(object sender, EventArgs e) {
        branch = Request["branch"]??"K";
        strConnB = Conn.OptB(branch);
        cgrs = Request["cgrs"] ?? "";
        rs_class = Request["rs_class"] ?? "";
        rs_code = Request["rs_code"] ?? "";
        submittask = Request["submittask"] ?? "";

        DataTable dt = new DataTable();
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "select distinct(act_code),act_code_name,rs_class,act_sort ";
            SQL += "from vcode_act ";
            SQL += " where dept='" + Sys.GetSession("dept") + "' ";
            SQL += " and cg='" + cgrs.Left(1) + "' and rs='" + cgrs.Right(1) + "' and " + cgrs + "='Y' ";
            SQL += " and (end_date is null or end_date = '' or end_date > getdate()) ";
            if (rs_class != "") {
                SQL += " and rs_class='" + rs_class + "' ";
            }
            if (rs_code != "") {
                SQL += " and rs_code='" + rs_code + "'";
            }
            SQL += " ORDER BY act_sort";

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
