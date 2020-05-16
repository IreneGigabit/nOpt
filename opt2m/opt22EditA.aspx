<%@ Page Language="C#" CodePage="65001"%>

<%@ Register Src="~/commonForm/opt/BR_formA.ascx" TagPrefix="uc1" TagName="BR_formA" %>
<%@ Register Src="~/commonForm/opt/BR_form.ascx" TagPrefix="uc1" TagName="BR_form" %>
<%@ Register Src="~/commonForm/opt/Back_form.ascx" TagPrefix="uc1" TagName="Back_form" %>
<%@ Register Src="~/commonForm/opt/PR_form.ascx" TagPrefix="uc1" TagName="PR_form" %>
<%@ Register Src="~/commonForm/opt/Send_form.ascx" TagPrefix="uc1" TagName="Send_form" %>
<%@ Register Src="~/commonForm/opt/upload_Form.ascx" TagPrefix="uc1" TagName="upload_Form" %>
<%@ Register Src="~/commonForm/opt/Qu_form.ascx" TagPrefix="uc1" TagName="Qu_form" %>
<%@ Register Src="~/commonForm/opt/AP_form.ascx" TagPrefix="uc1" TagName="AP_form" %>


<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opt22";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string submitTask = "";
    protected string branch = "";
    protected string opt_sqlno = "";
    protected string opt_no = "";
    protected string case_no = "";

    protected string MLock = "true";//案件客戶,客件連絡人,申請人,收費與接洽事項,案件主檔的控制
    protected string QLock = "true";//收費與接洽事項的控制
    protected string QHide = "true";
    protected string PLock = "true";//交辦內容的控制
    protected string RLock = "true";//承辦內容_分案的控制
    protected string BLock = "true";//承辦內容_承辦的控制
    protected string CLock = "true";//承辦內容_承辦的控制
    protected string SLock = "true";//承辦內容_發文的控制
    protected string SELock = "true";
    protected string ALock = "true";//承辦內容_判行的控制
    protected string P1Lock = "true";//控制show圖檔
    protected string show_qu_form = "N";//控制顯示品質評分欄位
    protected string show_ap_form = "N";//控制顯示判行內容欄位

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        submitTask = Request["submitTask"] ?? "";
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";
        opt_no = Request["opt_no"] ?? "";
        case_no = Request["case_no"] ?? "";
        
        if (prgid == "opt22") {
            HTProgCap = "爭救案判行作業";
            SLock = "false";
            ALock = "false";
        } else {
            HTProgCap = "爭救案內容查詢";
            submitTask = "Q";
        }
        if (submitTask != "Q") {
            if ((HTProgRight & 64) > 0 || (HTProgRight & 256) > 0) {
                SELock = "false";
            }
        }

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            PageLayout();
            this.DataBind();
        }
    }

    private void PageLayout() {
        //品質評分欄位要不要show的flag
        using (DBHelper conn = new DBHelper(Conn.OptK, false).Debug(Request["chkTest"] == "TEST")) {
            string SQL = "select ref_code from cust_code where code_type='T92' and cust_code='" + Request["arcase"] + "'";
            object objResult = conn.ExecuteScalar(SQL);
            string ref_code = (objResult != DBNull.Value && objResult != null) ? objResult.ToString().Trim() : "";
            if (ref_code != "V")
                show_qu_form = "Y";
        }
    }

</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
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
        <td class="text9" nowrap="nowrap">&nbsp;【<%=prgid%> <%=HTProgCap%>】
            <span id="span_sopt_no" style="color:blue">案件編號：<span id="sopt_no"></span></span>
        </td>
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
    <input type="hidden" id="case_no" name="case_no" value="<%=case_no%>">
	<input type="hidden" id="opt_sqlno" name="opt_sqlno" value="<%=opt_sqlno%>">
	<input type="hidden" id="submittask" name="submittask" value="<%=submitTask%>">
	<input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">
	<input type="hidden" id="show_qu_form" name="show_qu_form">
	<input type="hidden" id="progid" name="progid">

    <table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td>
            <uc1:BR_formA runat="server" ID="BR_formA" />
            <!--include file="../commonForm/opt/BR_formA.ascx"--><!--工作資料-->
            <uc1:BR_form runat="server" ID="BR_form" />
            <!--include file="../commonForm/opt/BR_form.ascx"--><!--分案設定-->
            <uc1:PR_form runat="server" ID="PR_form" />
            <!--include file="../commonForm/opt/PR_form.ascx"--><!--承辦內容-->
            <uc1:Send_form runat="server" id="Send_form" />
            <!--include file="../commonForm/opt/Send_form.ascx"--><!--發文資料-->
            <uc1:upload_Form runat="server" ID="upload_Form" />
            <!--include file="../commonForm/opt/upload_form.ascx"--><!--承辦附件資料-->
            <uc1:Qu_form runat="server" ID="Qu_form" />
            <!--include file="../commonForm/opt/Qu_form.ascx"--><!--品質評分-->
            <uc1:AP_form runat="server" ID="AP_form" />
            <!--include file="../commonForm/opt/AP_form.ascx"--><!--判行資料-->
            <uc1:Back_form runat="server" ID="Back_form" />
            <!--include file="../commonForm/opt/Back_form.ascx"--><!--退回處理-->
        </td>
    </tr>
    </table>
    <br />
    <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>
</form>

<table border="0" width="98%" cellspacing="0" cellpadding="0">
<tr id="tr_button1">
    <td width="100%" align="center">
		<input type=button value="判行" class="cbutton" onClick="formSaveSubmit('U')" id="btnSaveSubmit">
		<input type=button value="退回承辦" class="redbutton" id="btnBack1Submit">
    </td>
</tr>
<tr id="tr_button2" style="display:none">
    <td align="center">
        <input type=button value="退回" class="redbutton" id="btnBackSubmit">
        <input type=button value="取消" class="c1button" id="btnResetSubmit">
    </td>
</tr>
</table>

<iframe id="ActFrame" name="ActFrame" src="about:blank" width="100%" height="500" style="display:none"></iframe>
</body>
</html>

<script language="javascript" type="text/javascript">
    $(function () {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "20%,80%";
        }
        $("#chkTest").click(function (e) {
            $("#ActFrame").showFor($(this).prop("checked"));
        });

        this_init();
    });

    var br_opt = {};
    //初始化
    function this_init() {
        settab("#br");
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",true).triggerHandler("click");//☑測試
        $("input.dateField").datepick();
        //欄位控制
        $("#tr_Popt_show1").show();
        $("#tr_button1,#tr_button2").showFor($("#submittask").val()!="Q");//按鈕
        $("#tabreject,#tr_button2").hide();//退回視窗//退回視窗&按鈕

        $(".Lock").lock();
        $(".MLock").lock(<%#MLock%>);
        $(".QLock").lock(<%#QLock%>);
        $(".QHide").hideFor(<%#QHide%>);
        $(".PLock").lock(<%#PLock%>);
        $(".RLock").lock(<%#RLock%>);
        $(".BLock").lock(<%#BLock%>);
        $(".CLock").lock(<%#CLock%>);
        $(".SLock").lock(<%#SLock%>);
        $(".SELock").lock(<%#SELock%>);
        $(".ALock").lock(<%#ALock%>);
        $(".P1Lock").lock(<%#P1Lock%>);

        //取得案件資料
        $.ajax({
            type: "get",
            url: getRootPath() + "/ajax/_OptData.aspx?branch=<%=branch%>&opt_sqlno=<%=opt_sqlno%>",
            async: false,
            cache: false,
            success: function (json) {
                if($("#chkTest").prop("checked"))toastr.info("<a href='" + this.url + "' target='_new'>Debug！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
                var JSONdata = $.parseJSON(json);
                if (JSONdata.length == 0) {
                    toastr.warning("無案件資料可載入！");
                    return false;
                }
                br_opt = JSONdata;
                if(br_opt.opt.length>0){
                    $("#sopt_no").html(br_opt.opt[0].opt_no);
                    $("#sseq").html(br_opt.opt[0].fseq);
                }
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>案件資料載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });


        $("#sopt_no").html(br_opt.opt[0].opt_no);
        br_formA.init();
        br_form.init();
        back_form.init();
        pr_form.init();
        send_form.init();
        upload_form.init();
        qu_form.init();
        ap_form.init();
    }

    // 切換頁籤
    $("#CTab td.tab").click(function (e) {
        settab($(this).attr('href'));
    });
    function settab(k) {
        $("#CTab td.tab").removeClass("seltab").addClass("notab");
        $("#CTab td.tab[href='" + k + "']").addClass("seltab").removeClass("notab");
        $("div.tabCont").hide();
        $("div.tabCont[id='" + k + "']").show();
    }

    //關閉視窗
    $(".imgCls").click(function (e) {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "100%,0%";
        } else {
            window.close();
        }
    })

    //判行
    function formSaveSubmit(dowhat){
        $("#rs_agt_no").val($("#code_br_agt_no").val());

        if ($("#PRY_hour").val()==""||$("#PRY_hour").val()=="0"){
            if(!confirm("是否確定不輸入核准時數？？")) {
                $("#PRY_hour").focus();
                return false;
            }
        }

        if ($("#AP_hour").val()==""||$("#AP_hour").val()=="0"){
            if(!confirm("是否確定不輸入判行核稿時數？？")) {
                $("#AP_hour").focus();
                return false;
            }
        }
        
        $("select,textarea,input").unlock();
        $("#tr_button1 input:button").lock(!$("#chkTest").prop("checked"));
        reg.submittask.value = dowhat;
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.target = "ActFrame";
        reg.submit();
    }

    //退回分案(1)
    $("#btnBack1Submit").click(function () {
        if (confirm("是否確定退回重新承辦？？")) {
            $("#tr_button1,#tabQu,#tabAP").hide();
            $("#tr_button2,#tabreject").show();
        }else{
            $("#tr_button1,#tabQu,#tabAP").show();
            $("#tr_button2,#tabreject").hide();
        }
    });

    //退回(2)
    $("#btnBackSubmit").click(function () {
        if ($("#Preject_reason").val() == "") {
            alert("請輸入退回原因！");
            $("#Preject_reason").focus();
            return false;
        }
        
        $("select,textarea,input").unlock();
        $("#btnBackSubmit,#btnResetSubmit").lock(!$("#chkTest").prop("checked"));
        reg.submittask.value = "B";
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.target = "ActFrame";
        reg.submit();
    });

    //取消
    $("#btnResetSubmit").click(function () {
        $("#tr_button1,#tabQu,#tabAP").show();
        $("#tr_button2,#tabreject").hide();
        $("#tr_button1 input:button").unlock();
    });
</script>
