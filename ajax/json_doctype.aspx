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

    protected string type = "";
    protected string send_way = "";

    protected void Page_Load(object sender, EventArgs e) {
        type = Request["type"] ?? "";
        send_way = Request["send_way"] ?? "";

        DataTable dt = new DataTable();
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            if (type == "opt") {
                SQL = "select cust_code,code_name,remark ";
                SQL += " from cust_code where code_type='Odoc_type' ";
                SQL += " order by sortfld";
            } else if (type == "opte") {
                SQL = "select cust_code,code_name,remark ";
                SQL += " from cust_code where code_type='Odoc_type' ";
                SQL += " and ref_code is null ";
                SQL += " order by sortfld";
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
