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


    protected void Page_Load(object sender, EventArgs e) {
        DataTable dt = new DataTable();
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "SELECT b.Code_name,law_no1,law_no2,law_no3,law_mark,law_sqlno,''law_text ";
            SQL += "from law_detail a ";
            SQL += "left join Cust_code b ON a.law_type = b.Cust_code ";
            SQL += "where 1=1 and( a.end_date is null or a.end_date = '' )";
            conn.DataTable(SQL, dt);

            for (int i = 0; i < dt.Rows.Count; i++) {
                dt.Rows[i]["law_text"] += (dt.Rows[i].SafeRead("Code_name", "") == "" ? "" : dt.Rows[i].SafeRead("Code_name", "") + "_");
                dt.Rows[i]["law_text"] += (dt.Rows[i].SafeRead("law_no1", "") == "" ? "" : dt.Rows[i].SafeRead("law_no1", "") + "條");
                dt.Rows[i]["law_text"] += (dt.Rows[i].SafeRead("law_no2", "") == "" ? "" : dt.Rows[i].SafeRead("law_no2", "") + "款");
                dt.Rows[i]["law_text"] += (dt.Rows[i].SafeRead("law_no3", "") == "" ? "" : dt.Rows[i].SafeRead("law_no3", "") + "項");
            }
        }

        var settings = new JsonSerializerSettings() {
            Formatting = Formatting.Indented,
            ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
            Converters = new List<JsonConverter> { new DBNullCreationConverter(), new TrimCreationConverter() }//dbnull轉空字串且trim掉
        };

        Response.Write(JsonConvert.SerializeObject(dt, settings).ToUnicode());
    }
</script>
