<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
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
    protected Dictionary<string, object> vbr_opte = new Dictionary<string, object>();
    
    protected string submitTask = "";
    protected string mail_status = "";
    protected string opt_sqlno = "";
    protected string email_sqlno = "";
    protected string tf_code = "";
    protected string log_flag = "";

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
            SQL += " where a.opt_sqlno='" + opt_sqlno + "'";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);
            vbr_opte = dt.ToDictionary().FirstOrDefault();
            opte23_email_form.RS = vbr_opte;

            //foreach (KeyValuePair<string, object> p in SvrVal) {
            //    Response.Write(string.Format("{0}:{1}<br>", p.Key, p.Value));
            //}
            //Response.Write("<HR>");

            SQL = "select att_name,to_email,email_title,content,from_email,log_flag ";
            SQL += "from opt_email_log ";
            SQL += "where email_sqlno=" + email_sqlno;
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    //收件者email
                    opte23_email_form.att_email = dr.SafeRead("to_email", "").Trim();
                    //收件者姓名
                    opte23_email_form.att_name = dr.SafeRead("att_name", "").Trim();
                    //Email主旨
                    opte23_email_form.tf_subject = dr.SafeRead("email_title", "").Trim();
                    //Email內容
                    opte23_email_form.tf_content = dr.SafeRead("content", "").Trim();
                    //寄件者Email
                    opte23_email_form.from_email = dr.SafeRead("from_email", "").Trim();
                    log_flag = dr.SafeRead("log_flag", "").Trim();
                } else {
                    dr.Close();
                    //抓取定稿內容,2015/4/15因張總經理改為楊總經理，於tfcode_opt增加tf_att_name收件者姓名，日後只要修改定稿即可
                    SQL = "select tf_title as tf_subject,tf_content,tf_email,tf_class,tf_att_name ";
                    SQL += "from tfcode_opt ";
                    SQL += "where tf_code='" + tf_code + "'";
                    using (SqlDataReader dr1 = conn.ExecuteReader(SQL)) {
                        if (dr1.Read()) {
                            //收件者email
                            opte23_email_form.att_email = dr1.SafeRead("tf_email", "").Trim();
                            //收件者姓名
                            opte23_email_form.att_name = dr1.SafeRead("tf_att_name", "").Trim();
                            //Email主旨
                            opte23_email_form.tf_subject = dr1.SafeRead("tf_subject", "").Trim();
                            //Email內容
                            opte23_email_form.tf_content = dr1.SafeRead("tf_content", "").Trim();
                            //寄件者Email
                            opte23_email_form.from_email = "siiplo@mail.saint-island.com.tw";
                            opte23_email_form.tf_class = dr1.SafeRead("tf_class", "").Trim();
                        }
                    }
                }
            }

            //設定收件者
            switch (Sys.Host) {
                case "web08":
                    opte23_email_form.att_email = "wixigag567@jupiterm.com";
                    opte23_email_form.bcc_email = Session["scode"] + "@saint-island.com.tw";
                    break;
                case "web10":
                    opte23_email_form.att_email = Session["scode"] + "@saint-island.com.tw";
                    opte23_email_form.bcc_email = "m802@saint-island.com.tw";
                    break;
                default:
                    if (Sys.GetSession("scode") == "m1583") {
                        opte23_email_form.att_email = "wixigag567@jupiterm.com";
                        opte23_email_form.bcc_email = "m1583@saint-island.com.tw";
                    } else {
                        List<string> bcc_email = new List<string>();
                        bcc_email.Add(Session["scode"] + "@saint-island.com.tw");
                            
                        //抓取密件副本收件者
                        SQL = "select cust_code from cust_code where code_type='oebcc_bj' and end_date is null order by sortfld ";
                        using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                            while (dr.Read()) {
                                bcc_email.Add(dr.SafeRead("cust_code", "").Trim() + "@saint-island.com.tw");
                            }
                        }
                        bcc_email.Add("sib_sendk@saint-island.com.tw");

                        //先Distinct再轉成字串
                        opte23_email_form.bcc_email = string.Join(";", bcc_email.Distinct().ToArray());
                    }
                    break;
            }
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
<script type="text/javascript" src="<%=Page.ResolveUrl("~/ckeditor/ckeditor.js")%>"></script>
</head>
<body>
<table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td class="text9" nowrap="nowrap">&nbsp;【<%=prgid%> <%=HTProgCap%>】</td>
        <td class="FormLink" valign="top" align="right" nowrap="nowrap">
            <%--<a class="imgCls" href="javascript:void(0);" >[關閉視窗]</a>--%>
        </td>
    </tr>
    <tr>
        <td colspan="2"><hr class="style-one"/></td>
    </tr>
</table>
<br>
<form id="reg" name="reg" method="post">
	<input type="hidden" id="prgid" name="prgid" value="<%#prgid%>">
    <INPUT TYPE="hidden" id="submittask" name="submittask" value="<%#submitTask%>">
    <INPUT TYPE="hidden" id="mail_status" name="mail_status" value="<%#mail_status%>">
    <INPUT TYPE="hidden" id="log_flag" name="log_flag" value="<%#log_flag%>">

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
				<input type=button name="button3" value=" 暫 存 郵 件 " class="c1button" onClick="formSaveSubmit()">
				<input type=button name="button1" value=" 傳 送 郵 件 " class="cbutton" onClick="formAddSubmit()">
				<input type=button name="button2" value=" 重 填 " class="cbutton" onClick="formReset()">
			</span>
			<span id="span_btn2">
				<input type=button name="button4" value=" 刪 除 暫 存 郵 件 " class="redbutton" onClick="formDelSubmit()">
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
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",true).triggerHandler("click");//☑測試
        
        $(".Lock").lock();
        $("#span_btn1,#span_btn2").hide();

        if (($("#submittask").val()=="A" && <%#HTProgRight%> & 4)
            ||($("#submittask").val()=="U" && <%#HTProgRight%> & 8))
            $("#span_btn1").show();

        if ($("#mail_status").val()=="draft" && <%#HTProgRight%> & 16)
            $("#span_btn2").show();

        $("#work_scode").val("<%#Session["scode"]%>");

        email_form.init();

        CKEDITOR.replace('tf_content', { height: 600,width: '100%' });
    }

    //關閉視窗
    $(".imgCls").click(function (e) {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "100%,0%";
        } else {
            window.close();
        }
    })

    //暫存郵件
    function formSaveSubmit(){
        if(confirm("注意！\n你確定先暫存郵件嗎？")){
            $("select,textarea,input").unlock();
            reg.action = "opte23_mailsave.aspx";
            reg.target = "ActFrame";
            reg.submit();
        }
    }

    //刪除暫存郵件
    function formDelSubmit(){
        if(confirm("注意！\n你確定刪除嗎？")){
            reg.submittask.value="D";
            reg.action = "opte23_mailsave.aspx";
            reg.target = "ActFrame";
            reg.submit();
        }
    }

    //傳送郵件
    function formAddSubmit(){
        if($("#att_email").val()==""){
            alert("收件者Email必須輸入!!");
            return false;
        }

        if($("#tf_content").val()==""){
            alert("信函內容必須輸入!!");
            return false;
        }
        
        if(email_form.get_file_size()) return false;
        
        if(confirm("注意！\n你確定寄送此封Email嗎？")){
            $("select,textarea,input").unlock();
            reg.action = "opte23_mailsend.aspx";
            reg.target = "ActFrame";
            reg.submit();
        }
    }
</script>
