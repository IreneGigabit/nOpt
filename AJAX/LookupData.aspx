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
    protected string opt_sqlno = "";
    protected string type = "";

    protected void Page_Load(object sender, EventArgs e) {
        submitTask = Request["submitTask"] ?? "Q";
        type = (Request["type"] ?? "").ToString().ToLower();
        opt_sqlno = (Request["opt_sqlno"] ?? "");
        DataTable rtn = new DataTable();

        if (type == "getoptattach") rtn = GetOptAttach();//上傳檔案

        var settings = new JsonSerializerSettings() {
            Formatting = Formatting.Indented,
            ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
                Converters = new List<JsonConverter> { new DBNullCreationConverter(), new TrimCreationConverter() }//dbnull轉空字串且trim掉
        };
        Response.Write(JsonConvert.SerializeObject(rtn, settings).ToUnicode());
    }

    protected DataTable GetOptAttach() {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select * ";
            SQL += ",(Select sc_name from sysctrl.dbo.scode where scode=add_scode) as add_scodenm ";
            SQL += " from attach_opt ";
            SQL += " where opt_sqlno='" + opt_sqlno + "' and attach_flag<>'D' ";
            SQL += " order by opt_sqlno,attach_no ";

            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
</script>
