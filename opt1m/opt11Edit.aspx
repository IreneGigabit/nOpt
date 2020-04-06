<%@ Page Language="C#" CodePage="65001"%>

<%@ Register Src="~/commonForm/opt/cust_form.ascx" TagPrefix="uc1" TagName="cust_form" %>
<%@ Register Src="~/commonForm/opt/attent_form.ascx" TagPrefix="uc1" TagName="attent_form" %>
<%@ Register Src="~/commonForm/opt/apcust_re_form.ascx" TagPrefix="uc1" TagName="apcust_re_form" %>
<%@ Register Src="~/commonForm/opt/case_form.ascx" TagPrefix="uc1" TagName="case_form" %>
<%@ Register Src="~/commonForm/opt/dmt_form.ascx" TagPrefix="uc1" TagName="dmt_form" %>
<%@ Register Src="~/commonForm/opt/brdmt_upload_Form.ascx" TagPrefix="uc1" TagName="brdmt_upload_Form" %>

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opt11";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string submitTask = "";
    protected string branch = "";
    protected string opt_sqlno = "";
    protected string case_no = "";

    protected string MLock = "true";//案件客戶,客件連絡人,申請人,收費與接洽事項,案件主檔的控制
    protected string QLock = "true";//收費與接洽事項的控制
    protected string QHide = "true";
    protected string PLock = "true";//交辦內容的控制
    protected string RLock = "true";//承辦內容的控制
    protected string P1Lock = "true";//控制show圖檔
    protected string dmt_show_flag = "Y";//控制顯示案件主檔頁籤

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        submitTask = Request["submitTask"] ?? "";
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";
        case_no = Request["case_no"] ?? "";

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            PageLayout();
            this.DataBind();
        }
    }



    private void PageLayout() {
        //決定要不要顯示案件主檔頁籤
        if (Request["arcase"] == "DO1" || Request["arcase"] == "DI1" || Request["arcase"] == "DR1") {
            dmt_show_flag = "N";
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
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.irene.form.js")%>"></script>
</head>
<body>
<table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td class="text9" nowrap="nowrap">&nbsp;【<%=prgid%><%=HTProgCap%>】
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
    <input type="hidden" name="case_no" value="<%=case_no%>">
	<input type="hidden" name="opt_sqlno" value="<%=opt_sqlno%>">
	<input type="hidden" name="submittask">
	<input type="hidden" name="prgid" value="<%=prgid%>">

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
        </td>
    </tr>
    </table>
    <br />
    <table id=tabreject class="bluetable" border="0" cellspacing="1" cellpadding="2" width="98%" style="display:none">
	    <Tr align="center">
	        <TD align="center" colspan="3" class=lightbluetable><font color=red>退&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;回&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;處&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;理</font></TD>
	    </tr>
	    <Tr>
		    <TD align=center class=lightbluetable width="18%"><font color="red">退回原因</font></TD>
		    <TD class=lightbluetable>
			    <textarea ROWS="5" style="width:82%" align="left" id=Preject_reason name=Preject_reason ></textarea>
		    </TD>
	    </tr>
    </table>
    <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>
</form>

<table border="0" width="98%" cellspacing="0" cellpadding="0" >
<tr id="tr_button1">
    <td align="center">
        <input type=button value ="收件確認" class="cbutton" id="btnsearchSubmit">
        <input type=button value ="退回區所" class="redbutton" id="btnback1Submit">
    </td>
</tr>
<tr id="tr_button2" style="display:none">
    <td align="center">
        <input type=button value ="退回" class="redbutton" id="btnbackSubmit">
        <input type=button value ="取消" class="c1button" id="btnresetSubmit">
    </td>
</tr>
</table>

</body>
</html>

<script language="javascript" type="text/javascript">
    $(function () {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "20%,80%";
        }
        this_init();
    });

    var br_opt = {};
    //初始化
    function this_init() {
        settab("#tran");
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",true);//☑測試
        $("input.dateField").datepick();
        //欄位控制
        $("#CTab td.tab[href='#dmt']").showFor(("<%#dmt_show_flag%>" == "Y"));
        $(".Lock").lock();
        $(".MLock").lock(<%#MLock%>);
        $(".QLock").lock(<%#QLock%>);
        $(".QHide").lock(<%#QHide%>);
        $(".PLock").lock(<%#PLock%>);
        $(".RLock").lock(<%#RLock%>);
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
            error: function () { 
                toastr.error("<a href='" + this.url + "' target='_new'>案件資料載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
            }
        });

        $("#sseq").html(br_opt.opt[0].fseq);
        cust_form.init();
        attent_form.init();
        apcust_re_form.init();
        case_form.init();
        dmt_form.init();
        tran_form.init();
        brupload_form.init();
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

    //收件確認
    $("#btnsearchSubmit").click(function () {
        $("#btnsearchSubmit,#btnback1Submit,#btnbackSubmit,#btnresetSubmit").lock();
        reg.submittask.value = "U";
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.submit();
    });

    //退回區所(1)
    $("#btnback1Submit").click(function () {
        if (confirm("是否確定退回區所重新交辦？？")) {
            $("#tr_button1").hide();
            $("#tr_button2,#tabreject").show();
        }else{
            $("#tr_button1").show();
            $("#tr_button2,#tabreject").hide();
        }
    });

    //退回(2)
    $("#btnbackSubmit").click(function () {
        if ($("#Preject_reason").val() == "") {
            alert("請輸入退回原因！");
            $("#Preject_reason").focus();
            return false;
        }
        $("#btnsearchSubmit,#btnback1Submit,#btnbackSubmit,#btnresetSubmit").lock();

        reg.submittask.value = "B";
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.submit();
    });

    //取消
    $("#btnresetSubmit").click(function () {
        $("#tr_button1").show();
        $("#tr_button2,#tabreject").hide();
        $("#btnsearchSubmit").unlock();
    });
</script>
