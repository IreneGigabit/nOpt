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
    protected string rs_type = "";
    protected string rs_code = "";
    protected string submittask = "";

    protected void Page_Load(object sender, EventArgs e) {
        rs_type = Request["rs_type"] ?? "";
        rs_code = Request["rs_code"] ?? "";
        submittask = Request["submittask"] ?? "";

        DataTable dt = new DataTable();
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "SELECT distinct form_name as rs_class";
            SQL += ",(select code_name from cust_code where code_type='" + rs_type + "' and cust_code=a.form_name) as rs_class_name ";
            SQL += " FROM  cust_code as a ";
            SQL += " WHERE code_type='bjtrs_code'";
            SQL += " and ref_code='" + rs_type + "' ";
            SQL += " and (end_date is null or end_date='' or end_date >=getdate()) ";
            if (rs_code != "") {
                SQL += " and cust_code in ('" + rs_code.Replace("'", "','") + "')";
            }
            conn.DataTable(SQL, dt);
        }
        
        var settings = new JsonSerializerSettings() {
            Formatting = Formatting.Indented,
            ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
                Converters = new List<JsonConverter> { new DBNullCreationConverter(), new TrimCreationConverter() }//dbnull轉空字串且trim掉
        };

        Response.Write(JsonConvert.SerializeObject(dt, settings).ToUnicode());
    }
</script>
