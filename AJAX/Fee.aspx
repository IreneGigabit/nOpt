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
    protected string country = "";
    protected string ar_form = "";
    protected string service_type = "";
    protected string ttype = "";
    protected string case_date = "";
    protected string submittask = "";

    protected void Page_Load(object sender, EventArgs e) {
        branch = Request["branch"]??"K";
        country = Request["country"]??"";
        ar_form = Request["ar_form"]??"";
        strConnB = Conn.OptB(branch);
        service_type = Request["Service"] ?? "";
        ttype = Request["type"] ?? "";
        case_date = Request["case_date"] ?? "";
        submittask = Request["submittask"] ?? "";
        
        DataTable dt = new DataTable();
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            string SQL = "select cust_code from cust_code where code_type='Trs_type'";
            object objResult = connB.ExecuteScalar(SQL);
            string code_type = (objResult == DBNull.Value || objResult == null ? "T92" : objResult.ToString());
            
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
