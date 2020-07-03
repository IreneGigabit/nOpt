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
    protected string HTProgPrefix = "opt31";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;
    protected string DebugStr = "";
    protected string StrFormBtnTop = "";
    protected string StrFormBtn = "";

    protected string opt_job_scode1 = "",opt_job_scode2 = "";

    protected string btnEnd = "";

    protected string submitTask = "";
    protected string branch = "";
    protected string opt_sqlno = "";
    protected string opt_no = "";
    protected string case_no = "";
    protected string Back_flag = "";//退回flag
    protected string End_flag = "";//結辦flag

    protected string MLock = "true";//案件客戶,客件連絡人,申請人,收費與接洽事項,案件主檔的控制
    protected string QLock = "true";//收費與接洽事項的控制
    protected string QHide = "true";
    protected string PLock = "true";//交辦內容的控制
    protected string RLock = "true";//承辦內容_分案的控制
    protected string BLock = "true";//承辦內容_承辦的控制
    protected string CLock = "true";//承辦內容_承辦的控制
    protected string SLock = "true";//承辦內容_發文的控制
    protected string SELock = "true";//有權限才可修改
    protected string ALock = "true";//承辦內容_判行的控制
    protected string P1Lock = "true";//控制show圖檔
    protected string show_qu_form = "N";//控制顯示品質評分欄位
    protected string show_ap_form = "N";//控制顯示判行內容欄位
    protected string sameap_flag = "N";//判行和承辦人員是否為同一人

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        submitTask = Request["submitTask"] ?? "";
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";
        opt_no = Request["opt_no"] ?? "";
        case_no = Request["case_no"] ?? "";
        Back_flag = Request["Back_flag"] ?? "N";//退回flag(B)
        End_flag = Request["End_flag"] ?? "N";//結辦flag(Y)

        //欄位開關
        if (prgid == "opt31") {
            HTProgCap = "爭救案承辦內容維護";
        } else if (prgid == "opt31_1") {
            HTProgCap = "爭救案結辦作業";
            HTProgCode = "opt31";
            End_flag = "Y";
        } else {
            HTProgCap = "爭救案承辦內容查詢";
            submitTask = "Q";
        }

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        DebugStr = myToken.DebugStr;
        if (HTProgRight >= 0) {
            PageLayout();
            this.DataBind();
        }
    }

    private void PageLayout() {
        using (DBHelper cnn = new DBHelper(Conn.Sysctrl).Debug(false)) {
            string sql = "select DISTINCT C.scode,D.sc_name from scode_roles As C " +
                        "LEFT JOIN scode AS D ON D.scode = C.scode " +
                        "Where C.branch = 'B' And C.syscode = 'OPT' And C.roles = 'Assist' And C.prgid = 'opt31' " +
                        "Order By C.scode ";
            opt_job_scode1 = SHtml.Option(cnn, sql, "{scode}", "{sc_name}", false);

            sql = "select DISTINCT C.scode,D.sc_name from scode_roles As C " +
                        "LEFT JOIN scode AS D ON D.scode = C.scode " +
                        "Where C.branch = 'B' And C.syscode = 'OPT' And C.roles = 'Manager' And C.prgid = 'opt31' " +
                        "Order By C.scode ";
            opt_job_scode2 = SHtml.Option(cnn, sql, "{scode}", "{sc_name}", false);
        }

        //判行內容/品質評分欄位要不要顯示
        if (End_flag == "Y") {
            string dojob_scode = "";
            using (DBHelper cnn = new DBHelper(Conn.Sysctrl, false).Debug(Request["chkTest"] == "TEST")) {
                string SQL = "select DISTINCT C.scode from scode_roles As C " +
                "LEFT JOIN scode AS D ON D.scode = C.scode " +
                "Where C.branch = 'B' And C.syscode = 'OPT' And C.roles = 'Assist' " +
                "And C.prgid = 'opt31' " +
                "Order By C.scode ";
                object objResult = cnn.ExecuteScalar(SQL);
                dojob_scode = (objResult != DBNull.Value && objResult != null) ? objResult.ToString().Trim().ToLower() : "";
            }
            //當為結案時,如果承辦人如為林雪貞
            //則結辦後即可執行發文作業,
            //所以判行須輸入的資料要出來
            if (Sys.GetSession("scode").ToLower() == dojob_scode) {
                //判行內容欄位要不要show的flag
                show_ap_form = "Y";
                //判行和承辦人員是否為同一人
                sameap_flag = "Y";
                //品質評分欄位要不要show的flag
                using (DBHelper conn = new DBHelper(Conn.OptK, false).Debug(Request["chkTest"] == "TEST")) {
                    string SQL = "select ref_code from cust_code where code_type='T92' and cust_code='" + Request["arcase"] + "'";
                    object objResult = conn.ExecuteScalar(SQL);
                    string ref_code = (objResult != DBNull.Value && objResult != null) ? objResult.ToString().Trim() : "";
                    if (ref_code != "V")
                        show_qu_form = "Y";
                }
            }
        }

        if ((Request["homelist"] ?? "") == "homelist") {
        } else {
            if ((Request["SubmitTask"] ?? "") == "Q") {
                StrFormBtnTop += "<a class=\"imgCls\" href=\"javascript:void(0);\" >[關閉視窗]</a>";
            } else {
                if (prgid == "opt31_1") {
                } else {
                    if (Back_flag != "B") {
                        //StrFormBtnTop += "<a id=\"btnEnd\" href=\"javascript:void(0);\" onclick=\"formSaveSubmit('U','opt31_1')\" >[結辦處理]</a>";
                        StrFormBtnTop += "<a id=\"btnEnd\" href=\"opt31EditA.aspx?prgid=opt31_1&opt_sqlno=" + opt_sqlno + "&opt_no=" + opt_no + "&branch=" + branch + "\">[結辦處理]</a>";
                   }
                }
                StrFormBtnTop += "<a class=\"imgCls\" href=\"javascript:void(0);\" >[返回清單]</a>";
            }
        }

        //欄位開關
        if (prgid.IndexOf("opt31") > -1) {
            if (Back_flag != "B") {//不是退回
                PLock = "false";
                BLock = "false";
                SLock = "false";
                ALock = "false";
            }
        }
        if (submitTask != "Q") {
            if ((HTProgRight & 64) > 0 || (HTProgRight & 256) > 0) {
                SELock = "false";
            }
        }

        if (prgid == "opt31" || prgid == "opt31_1") {
            if (prgid == "opt31") {
                StrFormBtn += "<input type=button value=\"編修存檔\" class=\"cbutton\" onClick=\"formSaveSubmit('U','opt31')\" id=\"btnSaveSubmit\">";
            } else if (prgid == "opt31_1") {
                StrFormBtn += " <input type=button value=\"結辦\" class=\"cbutton\" onClick=\"formEndSubmit('U')\" id=\"btnEndSubmit\">";
            }
            StrFormBtn += " <input type=button value=\"退回分案\" class=\"redbutton\" id=\"btnBack1Submit\">";
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
        <td class="text9" nowrap="nowrap">&nbsp;【<%=HTProgCode%><%=HTProgCap%>】
            <span id="span_sopt_no" style="color:blue">案件編號：<span id="sopt_no"></span></span>
            <input type=button value ="區所案件資料複製" class="cbutton" id="branchCopy" onClick="GetBranchData()">
        </td>
        <td class="FormLink" valign="top" align="right" nowrap="nowrap">
            <%#StrFormBtnTop%>
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
    <input type="hidden" id="Back_flag" name="Back_flag" value="<%=Back_flag%>">
    <input type="hidden" id="End_flag" name="End_flag" value="<%=End_flag%>">
	<input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">
	<input type="hidden" id="show_qu_form" name="show_qu_form" value="<%=show_qu_form%>">
	<input type="hidden" id="sameap_flag" name="sameap_flag" value="<%=sameap_flag%>">
	<input type="hidden" id="progid" name="progid">

    <table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td>
            <uc1:BR_formA runat="server" ID="BR_formA" />
            <!--include file="../commonForm/opt/BR_formA.ascx"--><!--工作資料-->
            <uc1:BR_form runat="server" ID="BR_form" />
            <!--include file="../commonForm/opt/BR_form.ascx"--><!--分案設定-->
            <uc1:Back_form runat="server" ID="Back_form" />
            <!--include file="../commonForm/opt/Back_form.ascx"--><!--退回處理-->
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
        </td>
    </tr>
    </table>
	<table id='tabjob' border="0" width="98%" cellspacing="0" cellpadding="0">
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr >
			<td align="right">
				<label for="ap_type1"><input type="radio" value="1" name="ap_type" id="ap_type1" checked >正常簽核：</label>
				<select id='job_scode1' name='job_scode1' ><%#opt_job_scode1%></select>
				&nbsp;&nbsp;&nbsp;				
			</td>
			<td align="left"> 
				<label for="ap_type2"><input type="radio" value="2" name="ap_type" id="ap_type2" >例外簽核：</label>
				<select id='job_scode2' name='job_scode2' disabled ><%#opt_job_scode2%></select>
			</td>
		</tr>
	</table>
    <br />
    <%#DebugStr%>
</form>

<table border="0" width="98%" cellspacing="0" cellpadding="0">
<tr id="tr_button1">
    <td width="100%" align="center">
        <%#StrFormBtn%>
		<!--<input type=button value="編修存檔" class="cbutton" onClick="formSaveSubmit('U','opt31')" id="btnSaveSubmit">
		<input type=button value="結辦" class="cbutton" onClick="formEndSubmit('U')" id="btnEndSubmit">
		<input type=button value="退回分案" class="redbutton" id="btnBack1Submit">-->
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
        if (window.parent.tt !== undefined) {
            if ($("#submittask").val() == "Q")
                window.parent.tt.rows = "20%,80%";
            else
                window.parent.tt.rows = "0%,100%";
        }
        this_init();
    });

    var br_opt = {};
    //初始化
    function this_init() {
        settab("#br");
        $("input.dateField").datepick();
        //欄位控制
        $("#tabQu").showFor($("#End_flag").val() == "Y");//結辦顯示品質評分
        $("#tabAP").showFor($("#End_flag").val() == "Y" && ("<%#show_ap_form%>" == "Y"));//結辦時承辦&判行人同一個
        $("#tabjob").showFor($("#End_flag").val() == "Y");//結辦顯示簽核欄位
        $("#tr_Popt_show1").show();

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
        //$("#btnSaveSubmit").showFor($("#prgid").val()=="opt31");//[編修存檔]
        //$("#btnEndSubmit").showFor($("#prgid").val()=="opt31_1");//[結辦]
        $("#btnEnd").showFor($("#Back_flag").val() != "B"&&$("#prgid").val()!="opt31_1");//[結辦處理]
        $("#branchCopy").hideFor($("#Back_flag").val() == "B"||$("#submittask").val() == "Q");//[區所案件資料複製]

        if($("#Back_flag").val() == "B"){
            settab("#br");
            $("#tabreject,#tr_button2").show();//退回視窗&按鈕
            $("#tabPR,#tabSend,#tr_button1").hide();//承辦內容/發文視窗/承辦&結辦按鈕
        }else{
            $("#tabreject,#tr_button2").hide();//退回視窗//退回視窗&按鈕
            $("#tabPR,#tabSend,#tr_button1").show();//承辦內容/發文視窗/承辦&結辦按鈕
        }

        if ($("#sameap_flag").val()=="Y"){
            $("#btnSaveSubmit,#btnEndSubmit").val("結辦暨判行");
        }

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
        if (window.parent.tt !== undefined) {
            window.parent.tt.rows = "100%,0%";
        } else {
            window.close();
        }
    })

    //區所案件資料複製
    function GetBranchData(){
        var tlink = "opt31_GetCase.aspx?prgid="+$("#prgid").val();
        tlink += "&qBranch="+$("#Branch").val()+"&qseq="+$("#Bseq").val()+"&qseq1="+$("#Bseq1").val();
        tlink += "&qopt_sqlno=" +$("#opt_sqlno").val()+ "&qopt_no=" +$("#opt_no").val();
        tlink += "&qBr=Y";
        window.open(tlink,"win_opt31", "width=600 height=300 top=140 left=220 toolbar=no, menubar=no, location=no, directories=no resizable=yes status=no scrollbars=yes");
    }

    //編修存檔/列印/[結辦處理]
    function formSaveSubmit(dowhat,opt_prgid){
        $("select,textarea,input,span").unlock();
        $("#tr_button1 input:button").lock(!$("#chkTest").prop("checked"));

        if ($("#send_way").val()==""){
            alert("無發文方式,請退回重新分案！！");
            $("#send_way").focus();
            return false;
        }
        if ($("#receipt_type").val()==""){
            alert("無官發收據種類,請退回重新分案！！");
            $("#receipt_type").focus();
            return false;
        }
        if ($("#receipt_title").val()==""){
            alert("無收據抬頭,請退回重新分案！");
            $("#receipt_title").focus();
            return false;
        }

        reg.submittask.value = dowhat;
        reg.progid.value=opt_prgid;
        reg.action = "<%=HTProgPrefix%>_UpdateA.aspx";
        reg.target = "ActFrame";
        reg.submit();
    }

    //結辦
    function formEndSubmit(dowhat){
        $("#rs_agt_no").val($("#code_br_agt_no").val());

        if($("input[name='score_flag']:eq(0)").prop("checked")){
            if ($("#Score").val()==""){
                alert("請輸入接洽得分！");
                $("#Score").focus();
                return false;
            }
        }

        if ($("#Pr_hour").val()==""||$("#Pr_hour").val()=="0"){
            if(!confirm("是否確定不輸入承辦時數？")) {
                $("#Pr_hour").focus();
                return false;
            }
        }
        if($("input[name='send_dept']:checked").length==0){
            alert("請輸入發文單位！");
            $("input[name='send_dept']")[0].focus();
            return false;
        }
        if ($("#GS_date").val()==""){
            alert("請輸入發文日期！");
            $("#GS_date").focus();
            return false;
        }
        if ($("#mp_date").val()==""){
            alert("請輸入總收發文日期！！");
            $("#mp_date").focus();
            return false;
        }
        if ($("#send_cl").val()==""){
            alert("請輸入發文對象！！");
            $("#send_cl").focus();
            return false;
        }
        if ($("#send_sel").val()==""){
            alert("請輸入官方號碼！！");
            $("#send_sel").focus();
            return false;
        }
        if ($("#rs_class").val()==""){
            alert("請輸入發文代碼之結構分類！！");
            $("#rs_class").focus();
            return false;
        }
        if ($("#rs_code").val()==""){
            alert("請輸入發文代碼之案性！！");
            $("#rs_code").focus();
            return false;
        }
        if ($("#act_code").val()==""){
            alert("請輸入發文代碼之處理事項！！");
            $("#act_code").focus();
            return false;
        }
        if ($("#rs_detail").val()==""){
            alert("請輸入發文內容！！");
            $("#rs_detail").focus();
            return false;
        }
        if ($("#Send_Fees").val()==""){
            alert("請輸入規費支出！！");
            $("#Send_Fees").focus();
            return false;
        }
        if ($("#send_way").val()==""){
            alert("無發文方式,請退回重新分案！！");
            $("#send_way").focus();
            return false;
        }
        if ($("#receipt_type").val()==""){
            alert("無官發收據種類,請退回重新分案！！");
            $("#receipt_type").focus();
            return false;
        }
        if ($("#receipt_title").val()==""){
            alert("無收據抬頭,請退回重新分案！");
            $("#receipt_title").focus();
            return false;
        }
        if ($("#sameap_flag").val()=="Y"){
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
        }
        
        reg.prgid.value="opt31";
        $("select,textarea,input,span").unlock();
        $("#tr_button1 input:button").lock(!$("#chkTest").prop("checked"));
        reg.submittask.value = dowhat;
        reg.action = "<%=HTProgPrefix%>_UpdateA.aspx";
        reg.target = "ActFrame";
        reg.submit();
    }

    //退回分案(1)
    $("#btnBack1Submit").click(function () {
        settab("#br");

        if (confirm("是否確定退回重新分案？？")) {
            $("#tr_button1,#tabpr,#tabSend").hide();
            $("#tr_button2,#tabreject").show();
        }else{
            $("#tr_button1,#tabpr,#tabSend").show();
            $("#tr_button2,#tabreject").hide();
        }
    });

    //退回(2)
    $("#btnBackSubmit").click(function () {
        var doback=true;
        if ($("#Back_flag").val() == "B"){
            doback=confirm("是否確定退回重新分案？？");
        }

        if (doback){
            if ($("#Preject_reason").val() == "") {
                alert("請輸入退回原因！");
                $("#Preject_reason").focus();
                return false;
            }

            $("select,textarea,input,span").unlock();
            $("#btnBackSubmit,#btnResetSubmit").lock(!$("#chkTest").prop("checked"));
            reg.submittask.value = "B";
            reg.action = "<%=HTProgPrefix%>_UpdateA.aspx";
            reg.target = "ActFrame";
            reg.submit();
        }
    });

    //取消
    $("#btnResetSubmit").click(function () {
        if($("#Back_flag").val() != "B"){//不是退回作業才開關
            $("#tabPR,#tabSend,#tr_button1").show();
            $("#tr_button2,#tabreject").hide();
        }
        $("#tr_button1 input:button").unlock();
    });

    //簽核人員
    $("input[name='ap_type']").click(function () {
        if($("input[name='ap_type']:checked").val()=="1"){
            $("#job_scode1").unlock();
            $("#job_scode2").lock();
        }else{
            $("#job_scode1").lock();
            $("#job_scode2").unlock();
        }
    });
</script>
