<%@ Page Language="C#" CodePage="65001"%>

<%@ Register Src="~/commonForm/opte/BR_formA.ascx" TagPrefix="uc1" TagName="BR_formA" %>
<%@ Register Src="~/commonForm/opte/BR_form.ascx" TagPrefix="uc1" TagName="BR_form" %>



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

    protected string RLock = "true";//承辦內容的控制
    protected string CLock = "true";
    protected string QLock = "true";//工作資料的控制
    protected string QHide = "true";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";
        case_no = Request["case_no"] ?? "";
        todo_sqlno = Request["todo_sqlno"] ?? "";
        submitTask = Request["submitTask"] ?? "";

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            PageLayout();
            this.DataBind();
        }
    }

    private void PageLayout() {
        if (submitTask == "ADD") {
            HTProgCap += "‧<b style='color:Red'>新增</b>";
            RLock = "false";
            QLock = "false";
            QHide = "false";
        }else if (submitTask == "U") {
            RLock = "false";
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
    <br />
    <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>
</form>

<table border="0" width="98%" cellspacing="0" cellpadding="0" >
<tr id="tr_button1">
    <td align="center">
        <input type=button value ="新增分案" class="cbutton" onClick="formSearchSubmit('ADD')" id="btnsearchSubmit1">
        <input type=button value ="分　　案" class="cbutton" onClick="formSearchSubmit('U')" id="btnsearchSubmit2">
        <input type=button value ="刪除分案" class="cbutton" id="btnsearchSubmit3">
    </td>
</tr>
<tr id="tr_button2" style="display:none">
    <td align="center">
        <input type=button value="刪除" class="redbutton" id="btnDelSubmit">
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
            window.parent.tt.rows = "0%,100%";
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
        $("#span_sopt_no").hideFor($("#submittask").val()=="ADD");//新增分案時不顯示案件編號
        $("#btnsearchSubmit1").showFor($("#submittask").val()=="ADD");//新增分案時顯示[新增分案]
        $("#btnsearchSubmit2").showFor($("#submittask").val()=="U");//分案時顯示[分　　案]
        $("#btnsearchSubmit3").showFor($("#submittask").val()=="DEL");//刪除分案時顯示[刪除分案]
        $(".Lock").lock();
        $(".QLock").lock(<%#QLock%>);
        $(".QHide").hideFor(<%#QHide%>);
        $(".RLock").lock(<%#RLock%>);
        $(".CLock").lock(<%#CLock%>);

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
                if(br_opte.opte.length>0){
                    $("#sopt_no").html(br_opte.opte[0].opt_no);
                    $("#sseq").html(br_opte.opte[0].fseq);
                }
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>案件資料載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });


        br_formA.init();
        br_form.init();

        if ($("#submittask").val() != "ADD") {
            //br_formA.loadOpt();
            //br_form.loadOpt();
            //$("#btnBseq").click();
            $("#span_last_date0").showFor($("#span_last_date").html()!= "");
        } else {
            $("#Bseq1").val("_");
            $("#span_last_date0").hide();
        }
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

    //分　　案/新增分案
    function formSearchSubmit(dowhat) {
        if ($("#Branch").val()==""){
            alert("區所別未輸入！");
            $("#Branch").focus();
            return false;
        }

        if ($("#Bseq").val()==""){
            alert("區所編號未輸入！");
            $("#Bseq").focus();
            return false;
        }

        if ($("#Bseq１").val()==""){
            alert("區所編號副碼未輸入！");
            $("#Bseq１").focus();
            return false;
        }

        if (($("#Bseq").val()!=$("#oldBseq").val()
            ||$("#Bseq1").val()!=$("#oldBseq1").val()
            ||$("#Branch").val()!=$("#oldBranch").val())
            &&$("#oldBseq").val()!=""&&$("#oldBseq1").val()&&$("#oldBranch").val()
            ){
            alert("區所案件編號變動過，請按[確定]按鈕，重新抓取資料!!!");
            $("#btnBseq").focus();
            return false;
        }
        if ($("#dfy_last_date").val()==""){
            alert("請輸入法定期限！！");
            $("#dfy_last_date").focus();
            return false;
        }
        if ($("#ctrl_date").val()==""){
            alert("請輸入預計完成日期！！");
            $("#ctrl_date").focus();
            return false;
        }
        if ($("#pr_scode").val()==""){
            alert("請輸入承辦人員！！");
            $("#pr_scode").focus();
            return false;
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
        $("#btnsearchSubmit1,#btnsearchSubmit2").lock(!$("#chkTest").prop("checked"));
        reg.submittask.value = dowhat;
        reg.target = "ActFrame";
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.submit();
    }


    //刪除分案(1)
    $("#btnsearchSubmit3").click(function () {
        if (confirm("是否確定刪除分案？？")) {
            $("#tr_button1").hide();
            $("#tr_button2").show();
        }else{
            $("#tr_button1").show();
            $("#tr_button2").hide();
        }
    });

    //刪除分案(2)
    $("#btnDelSubmit").click(function () {
        $("select,textarea,input").unlock();
        reg.submittask.value = "DEL";
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.target = "ActFrame";
        reg.submit();
    });

    //取消
    $("#btnResetSubmit").click(function () {
        $("#tr_button1").show();
        $("#tr_button2").hide();
        $("#tr_button1 input:button").unlock();
    });

</script>
