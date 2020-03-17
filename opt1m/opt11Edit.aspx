<%@Page Language="C#" CodePage="65001"%>

<%@ Register Src="~/commonForm/dmt/cust_form.ascx" TagPrefix="uc1" TagName="cust_form" %>
<%@ Register Src="~/commonForm/dmt/attent_form.ascx" TagPrefix="uc1" TagName="attent_form" %>
<%@ Register Src="~/commonForm/dmt/apcust_re_form.ascx" TagPrefix="uc1" TagName="apcust_re_form" %>
<%@ Register Src="~/commonForm/dmt/case_form.ascx" TagPrefix="uc1" TagName="case_form" %>
<%@ Register Src="~/commonForm/dmt/dmt_form.ascx" TagPrefix="uc1" TagName="dmt_form" %>
<%@ Register Src="~/commonForm/dmt/brdmt_upload_Form.ascx" TagPrefix="uc1" TagName="brdmt_upload_Form" %>



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

        //交辦內容欄位畫面
        if (Request["arcase"] == "DO1") {
            tranHolder.Controls.Add(LoadControl("~/CommonForm/dmt/DO1_form.ascx"));//申請異議
        } else if (Request["arcase"] == "DI1") {
            tranHolder.Controls.Add(LoadControl("~/CommonForm/dmt/DI1_form.ascx"));//申請評定
        } else if (Request["arcase"] == "DR1") {
            tranHolder.Controls.Add(LoadControl("~/CommonForm/dmt/DR1_form.ascx"));//申請廢止
        } else if (Request["arcase"] == "DE1" || Request["arcase"] == "AD7") {
            tranHolder.Controls.Add(LoadControl("~/CommonForm/dmt/BC1_form.ascx"));//申請聽證(爭議案)
        } else if (Request["arcase"] == "DE2" || Request["arcase"] == "AD8") {
            tranHolder.Controls.Add(LoadControl("~/CommonForm/dmt/BC2_form.ascx"));//出席聽證(爭議案)
        } else {
            tranHolder.Controls.Add(LoadControl("~/CommonForm/dmt/BZZ1_form.ascx"));//無申請書之交辦內容案
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
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/toastr.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/util.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.irene.form.js")%>"></script>
</head>

<body>
<table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td class="text9" nowrap="nowrap">&nbsp;【<%=prgid%><%=HTProgCap%>】
            <font color="blue">區所案件編號：<span id="fseq"></span></font>
        </td>
        <td class="FormLink" valign="top" align="right" nowrap="nowrap">
            <a class="imgCls" href="javascript:void(0);" >[關閉視窗]</a>
        </td>
    </tr>
    <tr>
        <td colspan="2"><hr /></td>
    </tr>
</table>
<br>
<form id="reg" name="reg" method="post" action="<%=HTProgPrefix%>Update.aspx">
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
            <div class="tabCont" id="#tran">
                <asp:PlaceHolder ID="tranHolder" runat="server"></asp:PlaceHolder><!--交辦內容欄位畫面-->
                <uc1:brdmt_upload_Form runat="server" ID="brdmt_upload_Form" />
            </div>
        </td>
    </tr>
    </table>
</form>

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

        //取得案件資料
        $.ajax({
            type: "get",
            url: getRootPath() + "/AJAX/DmtData.aspx?branch=<%=branch%>&opt_sqlno=<%=opt_sqlno%>",
            async: false,
            cache: false,
            success: function (json) {
                toastr.info("<a href='" + this.url + "' target='_new'>Debug！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
                var JSONdata = $.parseJSON(json);
                if (JSONdata.length == 0) {
                    toastr.warning("無案件資料可載入！");
                    return false;
                }
                br_opt = JSONdata;
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>案件資料載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });

        $("#fseq").html(br_opt.opt[0].fseq);
        cust_form.init();//toastr.error("「案件客戶」載入失敗！<BR>請聯繫資訊人員！");
        attent_form.init();//toastr.error("「案件聯絡人」載入失敗！<BR>請聯繫資訊人員！");
        apcust_re_form.init();//toastr.error("「申請人」載入失敗！<BR>請聯繫資訊人員！");
        case_form.init();//toastr.error("「收費與接洽事項」載入失敗！<BR>請聯繫資訊人員！");
        dmt_form.init();//toastr.error("「案件主檔」資料載入失敗！<BR>請聯繫資訊人員！");
        tran_form.init();//toastr.error("「交辦內容」載入失敗！<BR>請聯繫資訊人員！");
        brupload_form.init();//toastr.error("「區所上傳文件」載入失敗！<BR>請聯繫資訊人員！");

        $("input.dateField").datepick();
        //欄位開關
        $(".Lock").lock();
        //$("#F_cust_area").unlock();
        //$("#PBranch,#PBseq,#PBseq1").unlock((<%#HTProgRight%> & 256));
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
</script>
