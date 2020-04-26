<%@ Page Language="C#" CodePage="65001"%>

<%@ Register Src="~/commonForm/opt/cust_form.ascx" TagPrefix="uc1" TagName="cust_form" %>
<%@ Register Src="~/commonForm/opt/attent_form.ascx" TagPrefix="uc1" TagName="attent_form" %>
<%@ Register Src="~/commonForm/opt/apcust_re_form.ascx" TagPrefix="uc1" TagName="apcust_re_form" %>
<%@ Register Src="~/commonForm/opt/case_form.ascx" TagPrefix="uc1" TagName="case_form" %>
<%@ Register Src="~/commonForm/opt/dmt_form.ascx" TagPrefix="uc1" TagName="dmt_form" %>
<%@ Register Src="~/commonForm/opt/brdmt_upload_Form.ascx" TagPrefix="uc1" TagName="brdmt_upload_Form" %>
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
    protected string SLock = "true";//承辦內容_發文的控制
    protected string SELock = "true";
    protected string ALock = "true";//承辦內容_判行的控制
    protected string P1Lock = "true";//控制show圖檔
    protected string dmt_show_flag = "Y";//控制顯示案件主檔頁籤
    protected string show_qu_form = "Y";//控制顯示品質評分欄位
    protected string show_ap_form = "Y";//控制顯示判行內容欄位

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
        //決定要不要顯示案件主檔畫面
        if (",DO1,DI1,DR1,".IndexOf(","+Request["arcase"]+",")>-1) {
            dmt_show_flag = "N";
        }
        
        //品質評分欄位要不要show的flag
        using (DBHelper conn = new DBHelper(Conn.OptK, false).Debug(Request["chkTest"] == "TEST")) {
            string SQL = "select ref_code from cust_code where code_type='T92' and cust_code='" + Request["arcase"] + "'";
            object objResult = conn.ExecuteScalar(SQL);
            string ref_code = (objResult != DBNull.Value && objResult != null) ? objResult.ToString().Trim() : "";
            if (ref_code != "V")
                show_qu_form = "Y";
        }
        
        //交辦內容欄位畫面
        if (Request["arcase"] == "DO1") {
            tranHolder.Controls.Add(LoadControl("~/CommonForm/opt/DO1_form.ascx"));//申請異議
        } else if (Request["arcase"] == "DI1") {
            tranHolder.Controls.Add(LoadControl("~/CommonForm/opt/DI1_form.ascx"));//申請評定
        } else if (Request["arcase"] == "DR1") {
            tranHolder.Controls.Add(LoadControl("~/CommonForm/opt/DR1_form.ascx"));//申請廢止
        } else if (Request["arcase"] == "DE1" || Request["arcase"] == "AD7") {
            tranHolder.Controls.Add(LoadControl("~/CommonForm/opt/BC1_form.ascx"));//申請聽證(爭議案)
        } else if (Request["arcase"] == "DE2" || Request["arcase"] == "AD8") {
            tranHolder.Controls.Add(LoadControl("~/CommonForm/opt/BC2_form.ascx"));//出席聽證(爭議案)
        } else {
            tranHolder.Controls.Add(LoadControl("~/CommonForm/opt/BZZ1_form.ascx"));//無申請書之交辦內容案
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
            <font color="blue">案件編號：<span id="sopt_no"></span></font>　　
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
	<input type="hidden" id="dmt_show_flag" name="dmt_show_flag" value="<%=dmt_show_flag%>">
	<input type="hidden" id="show_qu_form" name="show_qu_form" value="<%=show_qu_form%>">

    <table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td>
        <table border="0" cellspacing="0" cellpadding="0">
            <tr id="CTab">
                <td class="tab" href="#cust">案件客戶</td>
                <td class="tab" href="#attent">案件聯絡人</td>
                <td class="tab" href="#apcust_re">申請人</td>
                <td class="tab" href="#case">收費與接洽事項</td>
                <td class="tab" href="#dmt">案件主檔</td>
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
                <!--include file="../commonForm/opt/cust_form.ascx"--><!--案件客戶-->
            </div>
            <div class="tabCont" id="#attent">
                <uc1:attent_form runat="server" ID="attent_form" />
                <!--include file="../commonForm/opt/attent_form.ascx"--><!--案件聯絡人-->
            </div>
            <div class="tabCont" id="#apcust_re">
                <uc1:apcust_re_form runat="server" id="apcust_re_form" />
                <!--include file="../commonForm/opt/apcust_re_form.ascx"--><!--案件申請人-->
            </div>
            <div class="tabCont" id="#case">
                <uc1:case_form runat="server" ID="case_form" />
                <!--include file="../commonForm/opt/case_form.ascx"--><!--收費與接洽事項-->
            </div>
            <div class="tabCont" id="#dmt">
                <uc1:dmt_form runat="server" ID="dmt_form" />
                <!--include file="../commonForm/opt/dmt_form.ascx"--><!--案件主檔-->
            </div>
            <div class="tabCont" id="#tran">
                <asp:PlaceHolder ID="tranHolder" runat="server"></asp:PlaceHolder><!--交辦內容欄位畫面-->
                <uc1:brdmt_upload_Form runat="server" ID="brdmt_upload_Form" />
            </div>
            <div class="tabCont" id="#br">
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
            </div>
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
    if (!(window.parent.tt === undefined)) {
        window.parent.tt.rows = "20%,80%";
    }

    $("#chkTest").click(function (e) {
        $("#ActFrame").showFor($(this).prop("checked"));
    });

    $(document).ajaxStart(function () { $.maskStart("資料載入中"); });
    $(document).ajaxStop(function () { $.maskStop(); });

    $(function () {
        this_init();
    });

    var br_opt = {};
    //初始化
    function this_init() {
        settab("#br");
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",true).triggerHandler("click");//☑測試
        $("input.dateField").datepick();
        //欄位控制
        $("#CTab td.tab[href='#dmt']").showFor(("<%#dmt_show_flag%>" == "Y"));
        $("#tr_Popt_show1").showFor(("<%#dmt_show_flag%>" != "Y"));
        $("#tr_button1,#tr_button2").showFor($("#submittask").val()!="Q");//按鈕
        $("#tabreject,#tr_button2").hide();//退回視窗//退回視窗&按鈕
        $(".Lock").lock();
        $(".MLock").lock(<%#MLock%>);
        $(".QLock").lock(<%#QLock%>);
        $(".QHide").lock(<%#QHide%>);
        $(".PLock").lock(<%#PLock%>);
        $(".RLock").lock(<%#RLock%>);
        $(".BLock").lock(<%#BLock%>);
        $(".SLock").lock(<%#SLock%>);
        $(".SELock").lock(<%#SELock%>);
        $(".ALock").lock(<%#ALock%>);
        $(".P1Lock").lock(<%#P1Lock%>);

        //取得案件資料
        $.ajax({
            type: "get",
            url: getRootPath() + "/AJAX/OptData.aspx?branch=<%=branch%>&opt_sqlno=<%=opt_sqlno%>",
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
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>案件資料載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });

        $("#sopt_no").html(br_opt.opt[0].opt_no);
        cust_form.init();
        attent_form.init();
        apcust_re_form.init();
        case_form.init();
        dmt_form.init();
        tran_form.init();
        brupload_form.init();
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
        settab("#br");

        if($("#code_br_agt_no").val()!=""&&$("#Pagt_no").val()!=""){
            if($("#code_br_agt_no").val()!=$("#Pagt_no").val()){
                var msg="交辦時出名代理人("+$("#Pagt_no").val()+"_" +$( "#Pagt_no option:selected" ).text()+ ")與官發出名代理人("+$("#code_br_agt_no").val()+"_"+$("#code_br_agt_nonm").val()+")不同，是否確認結辦？";
                if(!confirm(msg)) return false;
            }
            $("#rs_agt_no").val($("#Pagt_no").val());
        }else{
            if($("#Pagt_no").val()!=""){
                $("#rs_agt_no").val($("#Pagt_no").val());
            }else{
                $("#rs_agt_no").val($("#code_br_agt_no").val());
            }
        }

        if($("input[name='score_flag']:eq(0)").prop("checked")){
            if ($("#Score").val()==""){
                alert("請輸入接洽得分！");
                $("#Score").focus();
                return false;
            }
        }

        if ($("#opt_Remark").val()==""){
            alert("請輸入案件缺失及評語！");
            $("#opt_Remark").focus();
            return false;
        }

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

    //退回承辦(1)
    $("#btnBack1Submit").click(function () {
        if (confirm("是否確定退回重新承辦？？")) {
            $("#tr_button1,#tabAP").hide();
            $("#tr_button2,#tabreject").show();
        }else{
            $("#tr_button1,#tabAP").show();
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
        $("#btnBackSubmit,#btnResetSubmit").lock(!$("#chkTest").prop("checked"));

        reg.submittask.value = "B";
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.target = "ActFrame";
        reg.submit();
    });

    //取消
    $("#btnResetSubmit").click(function () {
        $("#tr_button1,#tabAP").show();
        $("#tr_button2,#tabreject").hide();
        $("#tr_button1 input:button").unlock();
    });
</script>
