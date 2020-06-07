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

    protected string opt_no = "";

    protected void Page_Load(object sender, EventArgs e) {
        opt_no = Request["opt_no"];

        DataTable dt_law = GetLaw(opt_no);//案例資料
        DataTable dt_law_attach = GetLawAttach(opt_no);//附件資料

        var settings = new JsonSerializerSettings() {
            Formatting = Formatting.Indented,
            ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
            Converters = new List<JsonConverter> { new DBNullCreationConverter(),new TrimCreationConverter() }//dbnull轉空字串且trim掉
        };

        Response.Write("{");
        Response.Write("\"law\":" + JsonConvert.SerializeObject(dt_law, settings).ToUnicode() + "\n");
        Response.Write(",\"law_attach\":" + JsonConvert.SerializeObject(dt_law_attach, settings).ToUnicode() + "\n");
        Response.Write("}");

        //Response.Write(JsonConvert.SerializeObject(rtnStr, Formatting.Indented, new DBNullCreationConverter()).ToUnicode());
    }

    #region GetLaw 案例資料
    private DataTable GetLaw(string pOptNo) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "Select *,''fseq,''drfile from law_opt where opt_no='" + pOptNo + "' ";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region GetLawAttach
    private DataTable GetLawAttach(string pOptNo) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select * ";
            SQL += " from law_attach ";
            SQL += " where opt_no='" + pOptNo + "' ";
            SQL += " and (end_date is NULL or end_date = '') ";

            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion
</script>
