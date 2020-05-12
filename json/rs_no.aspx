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
    protected string step_date = "";
    protected string sdate = "";
    protected string edate = "";
    protected string send_dept = "";

    protected void Page_Load(object sender, EventArgs e) {
        branch = Request["branch"] ?? "";
        cgrs = (Request["cgrs"] ?? "").ToUpper();
        step_date = Request["step_date"] ?? "";
        sdate = Request["sdate"] ?? "";
        edate = Request["edate"] ?? "";
        send_dept = Request["send_dept"] ?? "";

        DataTable dt = new DataTable();
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            if (cgrs=="GS"){
	            SQL = "select min(rs_no) as minrs_no,max(rs_no) as maxrs_no from br_opt";
	            SQL+= " where (rs_no is not null) and left(rs_no,1)='B'";
            }else{
	            SQL = "select min(rs_no) as minrs_no,max(rs_no) as maxrs_no from step_dmt";
                SQL += " where branch='" + branch + "'";
                SQL += " and cg='" + cgrs.Left(1) + "' ";
                SQL += " and rs='" + cgrs.Mid(1,1) + "'";
            }

            if (step_date != "") {
                SQL += " and step_date='" + step_date + "' ";
            }
            if (sdate != "") {
                SQL += " and GS_date>='" + sdate + "' ";
            }
            if (edate != "") {
                SQL += " and GS_date<='" + edate + "' ";
            }
            if (send_dept != "") {
                SQL += " and send_dept='" + send_dept + "' ";
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
