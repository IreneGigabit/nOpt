<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Collections.Generic"%>

<%@ Register Src="~/commonForm/opte/cust_form.ascx" TagPrefix="uc1" TagName="cust_form" %>
<%@ Register Src="~/commonForm/opte/attent_form.ascx" TagPrefix="uc1" TagName="attent_form" %>
<%@ Register Src="~/commonForm/opte/BrtAPcust_Form.ascx" TagPrefix="uc1" TagName="BrtAPcust_Form" %>
<%@ Register Src="~/commonForm/opte/case_extform.ascx" TagPrefix="uc1" TagName="case_extform" %>
<%@ Register Src="~/commonForm/opte/Ext_Form.ascx" TagPrefix="uc1" TagName="Ext_Form" %>
<%@ Register Src="~/commonForm/opte/E9ZForm.ascx" TagPrefix="uc1" TagName="E9ZForm" %>
<%@ Register Src="~/commonForm/opte/brext_upload_Form.ascx" TagPrefix="uc1" TagName="brext_upload_Form" %>
<%@ Register Src="~/commonForm/opte/BR_form.ascx" TagPrefix="uc1" TagName="BR_form" %>
<%@ Register Src="~/commonForm/chkTest.ascx" TagPrefix="uc1" TagName="chkTest" %>




<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opte21";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string submitTask = "";
    protected string branch = "";
    protected string opt_sqlno = "";
    protected string case_no = "";
    protected string todo_sqlno = "";

    protected string MLock = "true";//案件客戶,客件連絡人,申請人,收費與接洽事項,案件主檔的控制
    protected string QLock = "true";//收費與接洽事項的控制
    protected string QHide = "true";
    protected string PLock = "true";//交辦內容的控制
    protected string RLock = "true";//承辦內容_分案的控制
    protected string BLock = "true";//承辦內容_承辦的控制
    protected string ALock = "true";//承辦內容_判行的控制
    protected string P1Lock = "true";//控制show圖檔

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;
            
        submitTask = Request["submitTask"] ?? "";
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";
        case_no = Request["case_no"] ?? "";
        todo_sqlno = Request["todo_sqlno"] ?? "";

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        chkTest.HTProgRight = HTProgRight;
        if (HTProgRight >= 0) {
            PageLayout();
            this.DataBind();
        }
    }

    private void PageLayout() {
        if (prgid == "opte21") {
            RLock = "false";
        }
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
            <font color="blue">案件編號：<span id="sopt_no"></span></font>　　
            <font color="blue">區所案件編號：<span id="sseq"></span></font>
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
	<input type="hidden" id="todo_sqlno" name="todo_sqlno" value="<%=todo_sqlno%>">
	<input type="hidden" id="bstep_grade" name="bstep_grade">
	<input type="hidden" id="submittask" name="submittask">
	<input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">

    <table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td>
        <table border="0" cellspacing="0" cellpadding="0">
            <tr id="CTab">
                <td class="tab" href="#cust">案件客戶</td>
                <td class="tab" href="#attent">案件聯絡人</td>
                <td class="tab" href="#apcust_re">申請人</td>
                <td class="tab" href="#case">收費與接洽事項</td>
                <td class="tab" href="#ext">案件主檔</td>
                <td class="tab" href="#tran">交辦內容</td>
                <td class="tab" href="#br">承辦內容</td>
            </tr>
        </table>
        </td>
    </tr>
    <tr>
        <td>
            <div class="tabCont" id="#cust">
                <uc1:cust_form runat="server" ID="cust_form" />
                <!--include file="commonForm/opte/cust_form.ascx"--><!--案件客戶-->
            </div>
            <div class="tabCont" id="#attent">
                <uc1:attent_form runat="server" ID="attent_form" />
                <!--include file="commonForm/opte/attent_form.ascx"--><!--案件聯絡人-->
            </div>
            <div class="tabCont" id="#apcust_re">
                <uc1:BrtAPcust_Form runat="server" ID="BrtAPcust_Form" />
                <!--include file="commonForm/opte/BrtAPcust_Form.ascx"--><!--案件申請人-->
            </div>
            <div class="tabCont" id="#case">
                <uc1:case_extform runat="server" ID="case_extform" />
                <!--include file="commonForm/opte/case_extform.ascx"--><!--收費與接洽事項-->
            </div>
            <div class="tabCont" id="#ext">
                <uc1:Ext_Form runat="server" ID="Ext_Form" />
                <!--include file="commonForm/opte/ext_form.ascx"--><!--案件主檔-->
            </div>
            <div class="tabCont" id="#tran">
                <uc1:E9ZForm runat="server" id="E9ZForm" />
                <!--include file="commonForm/opte/E9ZForm.ascx"--><!--交辦內容欄位畫面-->
                <uc1:brext_upload_Form runat="server" ID="brext_upload_Form" />
                <!--include file="commonForm/opte/brext_upload_form.ascx"--><!--區所上傳欄位畫面-->
            </div>
            <div class="tabCont" id="#br">
                <uc1:BR_form runat="server" ID="BR_form" />
                <!--include file="../commonForm/opte/BR_form.ascx"--><!--分案內容-->
            </div>
        </td>
    </tr>
    </table>
    <br />
    <!--label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label-->
    <uc1:chkTest runat="server" ID="chkTest" />
</form>

<table border="0" width="98%" cellspacing="0" cellpadding="0" >
<tr>
    <td align="center">
        <input type=button value="分　　案" class="cbutton" id="btnsearchSubmit">
    </td>
</tr>
</table>

<iframe id="ActFrame" name="ActFrame" src="about:blank" width="100%" height="500" style="display:none"></iframe>
</body>
</html>

<script language="javascript" type="text/javascript">
    $(function () {
        if (window.parent.tt !== undefined) {
            window.parent.tt.rows = "20%,80%";
        }
        //$("#chkTest").click(function (e) {
        //    $("#ActFrame").showFor($(this).prop("checked"));
        //});

        this_init();
    });

    var br_opte = {};
    //初始化
    function this_init() {
        settab("#br");
        //$("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",false).triggerHandler("click");//☑測試
        $("input.dateField").datepick();
        //欄位控制
        $(".Lock").lock();
        $(".MLock").lock(<%#MLock%>);
        $(".QLock").lock(<%#QLock%>);
        $(".QHide").hideFor(<%#QHide%>);
        $(".PLock").lock(<%#PLock%>);
        $(".RLock").lock(<%#RLock%>);
        $(".BLock").lock(<%#BLock%>);
        $(".ALock").lock(<%#ALock%>);
        $(".P1Lock").lock(<%#P1Lock%>);

        //取得案件資料
        $.ajax({
            type: "get",
            url: getRootPath() + "/ajax/_OpteData.aspx?branch=<%=branch%>&opt_sqlno=<%=opt_sqlno%>",
            async: false,
            cache: false,
            success: function (json) {
                if($("#chkTest").prop("checked"))toastr.info("<a href='" + this.url + "' target='_new'>Debug！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
                var JSONdata = $.parseJSON(json);
                if (JSONdata.length == 0) {
                    toastr.warning("無案件資料可載入！");
                    return false;
                }
                br_opte = JSONdata;
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>案件資料載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });

        $("#sopt_no").html(br_opte.opte[0].opt_no);
        $("#sseq").html(br_opte.opte[0].fseq);
        $("#bstep_grade").html(br_opte.opte[0].bstep_grade);
        cust_form.init();
        attent_form.init();
        apcust_re_form.init();
        case_form.init();
        ext_form.init();
        e9z_form.init();
        brupload_form.init();
        br_form.init();
        br_form.loadOpt();

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
        if (window.parent.tt !== undefined) {
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
