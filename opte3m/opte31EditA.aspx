<%@ Page Language="C#" CodePage="65001"%>

<%@ Register Src="~/commonForm/opte/BR_formA.ascx" TagPrefix="uc1" TagName="BR_formA" %>
<%@ Register Src="~/commonForm/opte/BR_form.ascx" TagPrefix="uc1" TagName="BR_form" %>



<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opte31";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string opt_job_scode1 = "", opt_job_scode2 = "";

    protected string submitTask = "";
    protected string branch = "";
    protected string opt_sqlno = "";
    protected string opt_no = "";
    protected string case_no = "";
    protected string todo_sqlno = "";
    protected string Back_flag = "";//退回flag
    protected string End_flag = "";//結辦flag

    protected string MLock = "true";//案件客戶,客件連絡人,申請人,收費與接洽事項,案件主檔的控制
    protected string QLock = "true";//收費與接洽事項的控制
    protected string QHide = "true";
    protected string PLock = "true";//交辦內容的控制
    protected string PHide = "true";//交辦內容的控制
    protected string RLock = "true";//承辦內容_分案的控制
    protected string BLock = "true";//承辦內容_承辦的控制
    protected string CLock = "true";//承辦內容_承辦的控制
    protected string SLock = "true";//承辦內容_發文的控制
    protected string SELock = "true";
    protected string ALock = "true";//承辦內容_判行的控制
    protected string P1Lock = "true";//控制show圖檔

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        submitTask = Request["submitTask"] ?? "";
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";
        opt_no = Request["opt_no"] ?? "";
        case_no = Request["case_no"] ?? "";
        todo_sqlno = Request["todo_sqlno"] ?? "";
        Back_flag = Request["Back_flag"] ?? "N";//退回flag(B)
        End_flag = Request["End_flag"] ?? "N";//結辦flag(Y)

        if (prgid == "opte31") {
            HTProgCap = "出口爭救案承辦內容維護";
            End_flag = "N";
        } else if (prgid == "opte31_1") {
            HTProgCap = "出口爭救案結辦作業";
            HTProgCode = "opte31";
            End_flag = "Y";
        } else {
            HTProgCap = "出口爭救案承辦內容查詢";
            submitTask = "Q";
        }

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            PageLayout();
            this.DataBind();
        }
    }

    private void PageLayout() {
        using (DBHelper cnn = new DBHelper(Conn.Sysctrl).Debug(false)) {
            string sql = "select DISTINCT C.scode,D.sc_name from scode_roles As C " +
                        "LEFT JOIN scode AS D ON D.scode = C.scode " +
                        "Where C.branch = 'B' And C.syscode = 'OPT' And C.roles = 'Assist' And C.prgid = 'opte31' " +
                        "Order By C.scode ";
            opt_job_scode1 = SHtml.Option(cnn, sql, "{scode}", "{sc_name}", false);

            sql = "select DISTINCT C.scode,D.sc_name from scode_roles As C " +
                        "LEFT JOIN scode AS D ON D.scode = C.scode " +
                        "Where C.branch = 'B' And C.syscode = 'OPT' And C.roles = 'Manager' And C.prgid = 'opte31' " +
                        "Order By C.scode ";
            opt_job_scode2 = SHtml.Option(cnn, sql, "{scode}", "{sc_name}", false);
        }

        //欄位開關
        if (prgid.IndexOf("opte31") > -1) {
            if (Back_flag != "B") {//不是退回
                PLock = "false";
                PHide = "false";
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
            <a id="btnEnd" href="opte31EditA.aspx?prgid=opte31_1&opt_sqlno=<%=opt_sqlno%>&opt_no=<%#opt_no%>&todo_sqlno=<%#todo_sqlno%>&branch=<%#branch%>">[結辦處理]</a>
            <a class="imgCls" href="javascript:void(0);" >[返回清單]</a>
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
	<input type="text" id="submittask" name="submittask" value="<%=submitTask%>">
	<input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">

    <table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td>
            <uc1:BR_formA runat="server" ID="BR_formA" />
            <!--include file="../commonForm/opte/BR_formA.ascx"--><!--承辦內容-->
            <uc1:BR_form runat="server" ID="BR_form" />
            <!--include file="../commonForm/opte/BR_form.ascx"--><!--分案內容-->
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
    <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>
</form>

<table border="0" width="98%" cellspacing="0" cellpadding="0" >
<tr id="tr_button1">
    <td width="100%" align="center">
		<input type=button value="編修存檔" class="cbutton" onClick="formSaveSubmit('U','opt31')" id="btnSaveSubmit">
		<input type=button value="結辦" class="cbutton" onClick="formEndSubmit('U')" id="btnEndSubmit">
		<input type=button value="退回分案" class="redbutton" id="btnBack1Submit">
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
    $(document).ajaxStart(function () { $.maskStart("資料載入中"); });
    $(document).ajaxStop(function () { $.maskStop(); });

    if (!(window.parent.tt === undefined)) {
        window.parent.tt.rows = "0%,100%";
    }

    $("#chkTest").click(function (e) {
        $("#ActFrame").showFor($(this).prop("checked"));
    });

    $(function () {
        this_init();
    });

    var br_opte = {};
    //初始化
    function this_init() {
        settab("#br");
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",true).triggerHandler("click");//☑測試
        $("input.dateField").datepick();
        //欄位控制
        $(".Lock").lock();
        $(".MLock").lock(<%#MLock%>);
        $(".QLock").lock(<%#QLock%>);
        $(".QHide").lock(<%#QHide%>);
        $(".PLock").lock(<%#PLock%>);
        $(".PHide").lock(<%#PHide%>);
        $(".RLock").lock(<%#RLock%>);
        $(".BLock").lock(<%#BLock%>);
        $(".SLock").lock(<%#SLock%>);
        $(".SELock").lock(<%#SELock%>);
        $(".ALock").lock(<%#ALock%>);
        $(".P1Lock").lock(<%#P1Lock%>);
        $("#btnSaveSubmit").showFor($("#prgid").val()=="opte31");//[編修存檔]
        $("#btnEndSubmit").showFor($("#prgid").val()=="opte31_1");//[結辦]
        $("#btnEnd").showFor($("#Back_flag").val() != "B"&&$("#prgid").val()!="opte31_1");//[結辦處理]
        $("#tabjob").showFor($("#End_flag").val() == "Y");//結辦顯示簽核欄位

        if($("#Back_flag").val() == "B"){
            settab("#br");
            $("#tabreject,#tr_button2").show();//退回視窗&按鈕
            $("#tabPR,#tabSend,#tr_button1").hide();//承辦內容/發文視窗/承辦&結辦按鈕
        }else{
            $("#tabreject,#tr_button2").hide();//退回視窗//退回視窗&按鈕
            $("#tabPR,#tabSend,#tr_button1").show();//承辦內容/發文視窗/承辦&結辦按鈕
        }

        //取得案件資料
        $.ajax({
            type: "get",
            url: getRootPath() + "/AJAX/OpteData.aspx?branch=<%=branch%>&opt_sqlno=<%=opt_sqlno%>",
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


        br_formA.init();
        br_form.init();
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

    //編修存檔/[結辦處理]
    function formSaveSubmit(dowhat,opt_prgid){
        $("select,textarea,input").unlock();
        $("#tr_button1 input:button").lock(!$("#chkTest").prop("checked"));
        reg.submittask.value = dowhat;
        reg.progid.value=opt_prgid;
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.target = "ActFrame";
        reg.submit();
    }

    //結辦
    function formEndSubmit(dowhat){
        if ($("#Pr_hour").val()==""||$("#Pr_hour").val()=="0"){
            if(!confirm("是否確定不輸入承辦時數？")) {
                $("#Pr_hour").focus();
                return false;
            }
        }

        var fld = $("#opt_uploadfield").val();
        if(parseInt($("#" + fld + "_filenum").val(), 10)==0){
            if(!confirm("無上傳檔案，是否確定結辦？？")) {
                return false;
            }
        }

        reg.prgid.value="opte31";
        $("select,textarea,input").unlock();
        $("#tr_button1 input:button").lock(!$("#chkTest").prop("checked"));
        reg.submittask.value = dowhat;
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
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
            $("#btnBackSubmit,#btnResetSubmit").lock(!$("#chkTest").prop("checked"));

            reg.submittask.value = "B";
            reg.action = "<%=HTProgPrefix%>_Update.aspx";
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
