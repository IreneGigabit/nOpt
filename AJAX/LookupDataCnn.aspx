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
        submitTask = Request["submitTask"] ?? "A";
        type = (Request["type"] ?? "").ToString().ToLower();

        //抓取爭議組承辦人員
        if (type == "getprscode") GetPrTermALL();
    }

    protected void GetPrTermALL() {
        using (DBHelper cnn = new DBHelper(Conn.Sysctrl, false)) {
            SQL = "select c.scode,c.sc_name from grpid as a ";
            SQL += " inner join scode_group as b on a.grpclass=b.grpclass and a.grpid=b.grpid ";
            SQL += " inner join scode as c on b.scode=c.scode ";
            SQL += " where a.grpclass='B' and a.grpid='T100'";
            if (submitTask == "A") {
                SQL += "and (c.end_date is null or c.end_date>=getdate()) ";
            }
            DataTable dt = new DataTable();
            cnn.DataTable(SQL, dt);

            var settings = new JsonSerializerSettings()
            {
                Formatting = Formatting.Indented,
                ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
                Converters = new List<JsonConverter> { new DBNullCreationConverter() }//dbnull轉空字串
            };
            Response.Write(JsonConvert.SerializeObject(dt, settings).ToUnicode());
        }
    }
</script>
