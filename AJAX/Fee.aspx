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
    protected string arcase = "";
    protected string mark = "";

    protected void Page_Load(object sender, EventArgs e) {
        branch = Request["branch"]??"K";
        country = Request["country"]??"";
        ar_form = Request["ar_form"]??"";
        strConnB = Conn.OptB(branch);
        service_type = Request["Service"] ?? "";
        ttype = Request["type"] ?? "";
        case_date = Request["case_date"] ?? "";
        submittask = Request["submittask"] ?? "";
        arcase = Request["arcase"] ?? "";
        mark = Request["mark"] ?? "";

        DataTable rtn = new DataTable();

        if (country == "" || country == "T") {
            rtn = GetFee_T();//國內案
        } else {
            rtn = GetFee_TE();//出口案
        }
        
        var settings = new JsonSerializerSettings() {
            Formatting = Formatting.Indented,
            ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
            Converters = new List<JsonConverter> { new DBNullCreationConverter() }//dbnull轉空字串
        };

        Response.Write(JsonConvert.SerializeObject(rtn, settings).ToUnicode());
    }

    protected DataTable GetFee_T() {
        using (DBHelper conn = new DBHelper(strConnB, false)) {
            SQL = "select cust_code from cust_code where code_type='Trs_type'";
            object objResult = conn.ExecuteScalar(SQL);
            string code_type = (objResult == DBNull.Value || objResult == null ? "T92" : objResult.ToString());

            string[] Arcase_all = arcase.Split('&');
            string tmpArcase = Arcase_all[0];

            if (ttype == "Arcase") {
                SQL = "select * from code_br ";
                SQL += "where rs_class='" + ar_form + "' and rs_code like '" + tmpArcase + "%' ";
                SQL += "and getdate() >= beg_date and end_date is null AND no_code='N' and rs_type='" + code_type + "' ";
                SQL += "and mark=" + (mark == "" ? "null" : "'" + mark + "'") + " ";
            } else if (ttype == "Fee") {
                SQL = "select * from case_fee ";
                SQL += "where dept='T' and country='" + country + "' and rs_code='" + tmpArcase + "' ";
                SQL += "and (" + (case_date == "" ? "getdate()" : "'" + case_date + "'") + " between beg_date and end_date) ";
            }
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);
            return dt;
        }
    }

    protected DataTable GetFee_TE() {
        using (DBHelper conn = new DBHelper(strConnB, false)) {
            switch (ttype) {
                case "Arcase":
                    SQL = "select * from code_brt ";
                    SQL += "where rs_class='" + ar_form + "' and left(rs_code,3)='" + arcase + "' ";
                    SQL += "and Mark = 'A' and dept='TE' and getdate() >= beg_date and end_date is null";
                    break;
                case "Fee":
                    SQL = "select * from case_fee ";
                    SQL += "where dept='T' and country='" + country + "' and rs_code='" + arcase + "' ";
                    SQL += "and getdate() between beg_date and end_date";
                    break;
            }
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);
            return dt;
        }
    }
</script>
