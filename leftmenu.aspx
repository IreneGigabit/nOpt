<%@ Page Language="C#" Inherits="PageBase" %>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Data"  %>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "Newtonsoft.Json"%>
<%@ Import Namespace = "Newtonsoft.Json.Linq"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string SQL = "";
    protected string json = "";
    
    protected string StrUser = "";
    protected string tdate = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
		Response.CacheControl = "Private";
		Response.AddHeader("Pragma", "no-cache");
		Response.Expires = -1;

        StrUser = Sys.GetSession("sc_name");
        tdate = Request["tdate"]??"";

        if (json == "Y") {
            DataTable dt_opt = QueryOptData();

            var settings = new JsonSerializerSettings()
            {
                Formatting = Formatting.None,
                ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
                Converters = new List<JsonConverter> { new DBNullCreationConverter(), new TrimCreationConverter() }//dbnull轉空字串且trim掉
            };

            Response.Write("{");
            Response.Write("\"vopt\":" + JsonConvert.SerializeObject(dt_opt, settings).ToUnicode() + "\n");
            //Response.Write(",\"vopte\":" + JsonConvert.SerializeObject(dt_cust, settings).ToUnicode() + "\n");
            Response.Write("}");

            Response.End();
            //return JsonConvert.SerializeObject(dt, settings).ToUnicode().Replace("\\", "\\\\").Replace("\"", "\\\"");
        }

		this.DataBind();
	}

    private DataTable QueryOptData() {
        using (DBHelper cnn = new DBHelper(Conn.ODBCDSN, false)) {
            DataTable dt = new DataTable();
            SQL = "select rights ";
            SQL += "from sysctrl.dbo.vrights ";
            SQL += "where branch='" + Session["SeBranch"] + "'";
            SQL += " and dept='" + Session["Dept"] + "'";
            SQL += " and syscode='" + Session["Syscode"] + "'";
            SQL += " and LoginGrp='" + Session["LoginGrp"] + "'";
            SQL += " and scode='" + Session["scode"] + "'";
            SQL += " and apcode='opt62'";
            SQL += " and beg_date<='" + DateTime.Today.ToShortDateString() + " 00:00:00'";
            SQL += " and (end_date>='" + DateTime.Today.ToShortDateString() + " 23:59:59' or end_date is null)";
            using (SqlDataReader dr = cnn.ExecuteReader(SQL)) {
                if (dr.HasRows) {
                    SQL = "select * from vbr_opte a ";
                    SQL += " where last_date <= '" + Util.parsedate(tdate) + &dateadd("d", 10, tdate) & "' and (Bstat_code <>'YY' and Bstat_code<>'YZ') and confirm_date is not null";
                    SQL += " and Bmark='N' ";
                    SQL += " order by a.last_date,a.Bseq,a.Bseq1";
                }
            }
            
            return dt;
        }
    }
</script>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf8" />
    <title>今日工作清單</title>
    <link href="inc/setstyle.css" rel="stylesheet" />
    <script type="text/javascript" src="js/lib/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="js/lib/toastr.min.js"></script>
    <script type="text/javascript" src="js/util.js"></script>
</head>
<body style="margin:0px 0px 0px 0px;background:url('images/back02.gif');">
    <form method="post" id="reg" name="reg" target="_top">
    <table style="font-size:16px" >
    <tr>
	    <td colspan=2 align=center><img src="images/hi11.gif"></td></tr>	
    <tr>
    <tr>
        <td width=20%></td>
	    <td valign=buttom><font color=darkblue><%#StrUser%> 您好,</td>
    </tr>
    </table>
    <table border=0 align=center bgcolor=AliceBlue cellspacing=3 cellpadding=0>
    <tr align=center>
	    <td align=center>
	       <img id="prevdate" src="images\arrow_left1.gif" style="cursor:pointer" align="absmiddle">
	       <font size=2 color=darkblue>今天是&nbsp;
           <img id="nextdate" src="images\arrow_right1.gif" style="cursor:pointer" align="absmiddle">
	    </td>
    </tr>
    <tr>
	    <td align=center>
            <font size=2 color=darkblue>&nbsp;
            <input id="tdate" name="tdate" size=10 onblur="chk_date(reg.tdate)">&nbsp;
        </td>
    </tr>
    </table>
        <input type="hidden" name="syscode" value="<%=Request["syscode"]%>">
        <input type="hidden" name="tfx_scode" value="<%=Session["Scode"]%>">
        <input type="hidden" name="tfx_sys_password" value="" />
        <input type="hidden" name="sys_pwd" value="<%=Session["SeSysPwd"]%>">
        <input type="hidden" name="toppage" value="<%=Session["SeTopPage"]%>">
        <input type="hidden" name="ctrlleft" value="<%=Request["ctrlleft"]%>">
        <input type="hidden" name="ctrltab" value="<%=Request["ctrltab"]%>">
        <input type="hidden" name="ctrlhomelist" value="<%=Request["ctrlhomelist"]%>">
        <input type="hidden" name="ctrlhomelistshow" value="<%=Request["ctrlhomelistshow"]%>">
    </form>
</body>
</html>


<script type="text/javascript" language="javascript">
    $(function () {
        init();
    });

    function init() {
        $("#tdate").val((new Date()).format("yyyy/M/d"));
    }
</script>
