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
    protected string submitTask = "";
    protected string type = "";

    protected void Page_Load(object sender, EventArgs e) {
        submitTask = Request["submitTask"] ?? "Q";
        type = (Request["type"] ?? "").ToString().ToLower();
        DataTable rtn = new DataTable();

        if (type == "getprscode") {
            string pr_branch=(Request["pr_branch"] ?? "").ToString().ToUpper();
            if (pr_branch == "" || pr_branch == "B") {
                //抓取爭議組承辦人員
                rtn = Funcs.GetPrTermALL(submitTask);
            } else {
                //抓北京聖島承辦人員
                rtn = Funcs.GetBJPrTermALL(submitTask);
            }
        }
        
        var settings = new JsonSerializerSettings() {
            Formatting = Formatting.Indented,
            ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
                Converters = new List<JsonConverter> { new DBNullCreationConverter(), new TrimCreationConverter() }//dbnull轉空字串且trim掉
        };
        Response.Write(JsonConvert.SerializeObject(rtn, settings).ToUnicode());
    }
</script>
