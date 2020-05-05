<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Linq" %>
<%@ Register Src="~/opte2m/opte23_email_form.ascx" TagPrefix="uc1" TagName="opte23_email_form" %>


<script runat="server">
    protected string HTProgCap = "交辦北京承辦作業(Email預覽)";//功能名稱
    protected string HTProgPrefix = "opte23";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string SQL = "";
    protected Dictionary<string, object> SvrVal = new Dictionary<string, object>();
    
    protected string submitTask = "";
    protected string mail_status = "";
    protected string opt_sqlno = "";
    protected string email_sqlno = "";
    protected string tf_code = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;
            
        submitTask = Request["submitTask"] ?? "";
        mail_status = Request["mail_status"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";
        email_sqlno = Request["email_sqlno"] ?? "";
        tf_code = Request["tf_code"] ?? "";

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            PageLayout();
            this.DataBind();
        }
    }

    private void PageLayout() {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select a.opt_no,a.branch,a.bseq,a.bseq1,a.country,a.ext_seq,a.ext_seq1,a.your_no,a.appl_name,a.apply_no";
            SQL += ",a.issue_no,a.class,a.arcase_name,a.ctrl_date,a.last_date,a.remarkb,a.pr_rs_code_name";
            SQL += " from vbr_opte a  ";
            SQL += " where a.opt_sqlno='" +opt_sqlno+ "'";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);
            SvrVal = dt.ToDictionary().FirstOrDefault();
            opte23_email_form.SvrVal = SvrVal;

            //foreach (KeyValuePair<string, object> p in SvrVal) {
            //    Response.Write(string.Format("{0}:{1}<br>", p.Key, p.Value));
            //}
            //Response.Write("<HR>");
        }
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
<meta http-equiv="x-ua-compatible" content="IE=10">
<title><%=HTProgCap%></title>
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/inc/setstyle.css")%>" />
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/lib/jquery.datepick.css")%>" />
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/lib/toastr.css")%>" />
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery-1.12.4.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery.datepick.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery.datepick-zh-TW.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/toastr.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/util.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.Snoopy.date.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.irene.form.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/client_chk.js")%>"></script>
</head>
<body>
<table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td class="text9" nowrap="nowrap">&nbsp;【<%=prgid%> <%=HTProgCap%>】</td>
        <td class="FormLink" valign="top" align="right" nowrap="nowrap">
            <a class="imgCls" href="javascript:void(0);" >[關閉視窗]</a>
        </td>
    </tr>
    <tr>
        <td colspan="2"><hr class="style-one"/></td>
    </tr>
</table>
<br>
<form id="reg" name="reg" method="post">
	<input type="text" id="prgid" name="prgid" value="<%=prgid%>">
    <INPUT TYPE="text" id="submittask" name="submittask" value="<%=submitTask%>">
    <INPUT TYPE="text" id="mail_status" name="mail_status" value="<%=mail_status%>">
    <INPUT TYPE="text" id="log_flag" name="log_flag" value="%=log_flag%>">

    <table cellspacing="1" cellpadding="0" width="98%" border="0">
	<tr>
        <td>
            <uc1:opte23_email_form runat="server" ID="opte23_email_form" />
            <!--include file="opte23_email_form.ascx"--><!--email預覽畫面-->
        </td>
    </tr>
    </table>
    <br />
    <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>
</form>

<table id="tblBtn" border="0" width="100%" cellspacing="0" cellpadding="0">
	<tr>
		<td width="100%" align="center">
			<span id="span_btn1">
				<input type=button name="button3" value=" 暫 存 郵 件 " class="c1button" onClick="formSaveSubmit">
				<input type=button name="button1" value=" 傳 送 郵 件 " class="cbutton" onClick="formAddSubmit">
				<input type=button name="button2" value=" 重 填 " class="cbutton" onClick="formReset">
			</span>
			<span id="span_btn2">
				<input type=button name="button4" value=" 刪 除 暫 存 郵 件 " class="redbutton" onClick="formDelSubmit">
			</span>
		</td>
	</tr>
</table>

<iframe id="ActFrame" name="ActFrame" src="about:blank" width="100%" height="500" style="display:none"></iframe>
</body>
</html>

<script language="javascript" type="text/javascript">
    $(function () {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "25%,75%";
        }
        $("#chkTest").click(function (e) {
            $("#ActFrame").showFor($(this).prop("checked"));
        });

        this_init();
    });

    //初始化
    function this_init() {
        $("#span_btn1,#span_btn2").hide();

        if (($("#submittask").val()=="A" && <%#HTProgRight%> & 4)
            ||($("#submittask").val()=="U" && <%#HTProgRight%> & 8))
            $("#span_btn1").show();

        if ($("#mail_status").val()=="draft" && <%#HTProgRight%> & 16)
            $("#span_btn2").show();
    }

    //關閉視窗
    $(".imgCls").click(function (e) {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "100%,0%";
        } else {
            window.close();
        }
    })

    //分　　案
    $("#btnsearchSubmit").click(function () {
        if ($("#ctrl_date").val()==""){
            alert("請輸入預計完成日期！！");
            $("#ctrl_date").focus();
            return false;
        }
        //'承辦單位為專案室才需檢查承辦人員，因北京聖島需分案通知後才會知道承辦人員
        if ($("#pr_branch").val()=="B"){
            if ($("#pr_scode").val()==""){
                alert("請輸入承辦人員！！");
                $("#pr_scode").focus();
                return false;
            }
        }
        if ($("#pr_rs_class").val()==""){
            alert("請輸入承辦案性之「結構分類」！");
            $("#pr_rs_class").focus();
            return false;
        }
        if ($("#pr_rs_code").val()==""){
            alert("請輸入承辦案性之「案性」！");
            $("#pr_rs_code").focus();
            return false;
        }

        $("select,textarea,input").unlock();
        $("#btnsearchSubmit").lock(!$("#chkTest").prop("checked"));
        reg.submittask.value = "U";
        reg.target = "ActFrame";
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.submit();
    });
</script>
