<%@Page Language="C#" CodePage="65001"%>

<%@ Register Src="~/commonForm/dmt/cust_form.ascx" TagPrefix="uc1" TagName="cust_form" %>
<%@ Register Src="~/commonForm/dmt/attent_form.ascx" TagPrefix="uc1" TagName="attent_form" %>
<%@ Register Src="~/commonForm/dmt/apcust_re_form.ascx" TagPrefix="uc1" TagName="apcust_re_form" %>
<%@ Register Src="~/commonForm/dmt/case_form.ascx" TagPrefix="uc1" TagName="case_form" %>
<%@ Register Src="~/commonForm/dmt/dmt_form.ascx" TagPrefix="uc1" TagName="dmt_form" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script runat="server">

    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opt11";//程式檔名前綴
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected int HTProgRight = 0;

    protected string StrQueryLink = "";
    protected string StrQueryBtn = "";

    protected string branch = "";
    protected string opt_sqlno = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";

        Token myToken = new Token(prgid);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            QueryPageLayout();
            this.DataBind();
        }
    }
    
    private void QueryPageLayout() {

        //if ((HTProgRight & 2) > 0) {
            StrQueryLink = "<input type=\"image\" id=\"imgSrch\" src=\"../icon/inquire_in.png\" title=\"查詢\" />&nbsp;";
            StrQueryBtn = "<input type=\"button\" id=\"btnSrch\" value =\"查詢\" class=\"cbutton\" />";
        //}
    }

</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=HTProgCap%></title>
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/inc/setstyle.css")%>" />
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/jquery.datepick.css")%>" />
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/toastr.css")%>" />
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery-1.12.4.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.datepick.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.datepick-zh-TW.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/toastr.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/util.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.irene.form.js")%>"></script>
</head>

<body>
<table cellspacing="1" cellpadding="0" width="98%" border="0" align="center">
    <tr>
        <td class="text9" nowrap="nowrap">&nbsp;【<%=prgid%><%=HTProgCap%>】
            <font color="blue">區所案件編號：<span id="fseq"></span></font>
        </td>
        <td class="FormLink" valign="top" align="right" nowrap="nowrap">
            <a class="imgCls" href="javascript:void(0);" >[關閉視窗]</a>&nbsp;        
        </td>
    </tr>
    <tr>
        <td colspan="2"><hr /></td>
    </tr>
</table>

<form id="reg" name="reg" method="post" action="<%=HTProgPrefix%>Update.aspx">
    <table cellspacing="1" cellpadding="0" width="98%" border="0" align="center">
    <tr><td>
    <table border="0" cellspacing="0" cellpadding="0">
        <tr id="CTab">
            <td class="tab" href="#cust">案件客戶</td>
            <td class="tab" href="#attent">案件聯絡人</td>
            <td class="tab" href="#apcust_re">申請人</td>
            <td class="tab" href="#case">收費與接洽事項</td>
            <td class="tab" href="#dmt">案件主檔</td>
            <td class="tab" href="#case_form">交辦內容</td>
        </tr>
    </table>
    </td></tr></table>
    <table border="0" width="98%" cellspacing="0" cellpadding="0" align="center">
        <tr>
            <td>
                <div class="tabCont" id="#cust">
                    <uc1:cust_form runat="server" ID="cust_form" />
                    <!--include file="../commonForm/dmt/cust_form.ascx"--><!--案件客戶-->
                </div>
                <div class="tabCont" id="#attent">
                    <uc1:attent_form runat="server" ID="attent_form" />
                    <!--include file="../commonForm/dmt/attent_form.ascx"--><!--案件聯絡人-->
                </div>
                <div class="tabCont" id="#apcust_re">
                    <uc1:apcust_re_form runat="server" id="apcust_re_form" />
                    <!--include file="../commonForm/dmt/apcust_re_form.ascx"--><!--案件申請人-->
                </div>
                <div class="tabCont" id="#case">
                    <uc1:case_form runat="server" ID="case_form" />
                    <!--include file="../commonForm/dmt/case_form.ascx"--><!--收費與接洽事項-->
                </div>
                <div class="tabCont" id="#dmt">
                    <uc1:dmt_form runat="server" ID="dmt_form" />
                    <!--include file="../commonForm/dmt/dmt_form.ascx"--><!--案件主檔-->
                </div>
                <div class="tabCont" id="#case_form">
                    <!--include file="../commonForm/dmt/case_form.ascx"--><!--交辦內容欄位畫面-->
                </div>
            </td>
        </tr>
    </table>
</form>

<script>
$(function () {
    if (!(window.parent.tt === undefined)) {
        window.parent.tt.rows = "20%,80%";
    }
    this_init();
});

//初始化
function this_init() {
    settab("#cust");
    //案號
    $.ajax({
        type: "get",
        url: getRootPath() + "/AJAX/DmtData.aspx?type=brcase&branch=<%=branch%>&opt_sqlno=<%=opt_sqlno%>",
        async: false,
        cache: false,
        success: function (json) {
            var JSONdata = $.parseJSON(json);
            if (JSONdata.length == 0) {
                toastr.warning("無案件資料可載入！");
                return false;
            }
            var j = JSONdata[0];
            $("#fseq").html(j.fseq);
        },
        error: function () { toastr.error("<a href='" + this.url + "' target='_new'>案件資料載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
    });

    cust.init();
    attent.init();
    apcust_re.init();
    case_form.init();
    dmt.init();

    //欄位開關
    $(".Lock").lock();
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
}).click();
</script>
