<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Collections.Generic"%>

<%@ Register Src="~/commonForm/opte/cust_form.ascx" TagPrefix="uc1" TagName="cust_form" %>
<%@ Register Src="~/commonForm/opte/attent_form.ascx" TagPrefix="uc1" TagName="attent_form" %>
<%@ Register Src="~/commonForm/opte/BrtAPcust_Form.ascx" TagPrefix="uc1" TagName="BrtAPcust_Form" %>
<%@ Register Src="~/commonForm/opte/case_extform.ascx" TagPrefix="uc1" TagName="case_extform" %>
<%@ Register Src="~/commonForm/opte/Ext_Form.ascx" TagPrefix="uc1" TagName="Ext_Form" %>
<%@ Register Src="~/commonForm/opte/E9ZForm.ascx" TagPrefix="uc1" TagName="E9ZForm" %>
<%@ Register Src="~/commonForm/opte/brext_upload_Form.ascx" TagPrefix="uc1" TagName="brext_upload_Form" %>


<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opte11";//程式檔名前綴
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
    protected string RLock = "true";//承辦內容的控制
    protected string P1Lock = "true";//控制show圖檔

    public string xx = "xx";
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
        if (HTProgRight >= 0) {
            PageLayout();
            this.DataBind();
        }
    }

    private void PageLayout() {
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
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/client_chk.js")%>"></script>
</head>
<body>
<table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td class="text9" nowrap="nowrap">&nbsp;【<%=prgid%> <%=HTProgCap%>】
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
    <input type="text" id="case_no" name="case_no" value="<%=case_no%>">
	<input type="text" id="opt_sqlno" name="opt_sqlno" value="<%=opt_sqlno%>">
	<input type="text" id="todo_sqlno" name="todo_sqlno" value="<%=todo_sqlno%>">
	<input type="text" id="bstep_grade" name="bstep_grade">
	<input type="text" id="submittask" name="submittask">
	<input type="text" id="prgid" name="prgid" value="<%=prgid%>">

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
			    <textarea ROWS="5" style="width:82%" id=Preject_reason name=Preject_reason ></textarea>
		    </TD>
	    </tr>
    </table>
    <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>
</form>

<table border="0" width="98%" cellspacing="0" cellpadding="0" >
<tr id="tr_button1">
    <td align="center">
        <input type=button value="收件確認" class="cbutton" id="btnsearchSubmit">
        <input type=button value="退回區所" class="redbutton" id="btnback1Submit">
        <input type=button value="通知區所修正資料" id="tobrbutton"  name="tobrbutton" class="c1button" onClick="tobrbutton_email()" >
    </td>
</tr>
<tr id="tr_button2" style="display:none">
    <td align="center">
        <input type=button value="退回" class="redbutton" id="btnbackSubmit">
        <input type=button value="取消" class="c1button" id="btnresetSubmit">
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
        this_init();
    });

    $("#chkTest").click(function (e) {
        $("#ActFrame").showFor($(this).prop("checked"));
    });

    var br_opte = {};
    //初始化
    function this_init() {
        settab("#tran");
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",true).triggerHandler("click");//☑測試
        $("input.dateField").datepick();
        //欄位控制
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
            error: function () { 
                toastr.error("<a href='" + this.url + "' target='_new'>案件資料載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
            }
        });

        $("#sseq").html(br_opte.opte[0].fseq);
        $("#bstep_grade").html(br_opte.opte[0].bstep_grade);
        cust_form.init();
        attent_form.init();
        apcust_re_form.init();
        case_form.init();
        ext_form.init();
        e9z_form.init();
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
        reg.target = "ActFrame";
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
        reg.target = "ActFrame";
        reg.submit();
    });

    //取消
    $("#btnresetSubmit").click(function () {
        $("#tr_button1").show();
        $("#tr_button2,#tabreject").hide();
        $("#btnsearchSubmit").unlock();
    });

    //資料有誤通知區所修正
    function tobrbutton_email(tcgrs){
        <%
        List<string> strTo = new List<string>();////收件者
        List<string> strCC = new List<string>();//副本
        string Sender=Sys.GetSession("scode");//寄件者
        string branch_name=Sys.bName(branch);//區所名稱
        switch (Sys.Host) {
            case "web08":
                strTo.Add(Session["scode"] + "@saint-island.com.tw");
                break;
            case "web10":
                strTo.Add(Session["scode"] + "@saint-island.com.tw");
                break;
            default:
                ////通知區所承辦、程序
                using (DBHelper conn = new DBHelper(Conn.OptK, false).Debug(Request["chkTest"] == "TEST")) {
                    string SQL = "select in_scode from todo_opte where sqlno='" + todo_sqlno + "' ";
                    object objResult0 = conn.ExecuteScalar(SQL);
                    if(objResult0 != DBNull.Value && objResult0 != null){
                        strTo.Add(objResult0.ToString() + "@saint-island.com.tw");
                    }

                    SQL = "select scode from sysctrl.dbo.scode_group where grpclass='" + branch + "' and grpid='T220' and grptype='F'";
                    object objResult1 = conn.ExecuteScalar(SQL);
                    if(objResult1 != DBNull.Value && objResult1 != null){
                        strTo.Add(objResult1.ToString() + "@saint-island.com.tw");
                    }
                }
                break;
        }
        strCC.Add("m802@saint-island.com.tw");
        %>

        var StrToList="<%=string.Join(";", strTo.ToArray())%>";  //收件者
        var CCtoList="<%=string.Join(";", strCC.ToArray())%>";  //副本
        tsubject = "出口爭救案系統－資料修正通知（區所編號: "+br_opte.opte[0].fseq+" ）";

        var tbody = "致: <%=branch_name%> 程序、承辦%0A%0A";
        tbody += "【通 知 日 期 】: "+(new Date()).format("yyyy/M/d");
        tbody += "%0A【區所編號】:"+br_opte.opte[0].fseq+"，交辦單號：<%=case_no%> ";
        tbody += "%0A 檢核資料有誤 ，煩請確認，如有資料修正，請更正後通知。";
        tbody += "%0A【檢核項目】";
        tbody += "%0A法定期限";
        tbody += "%0A上傳文件";
	
        ActFrame.location.href= "mailto:"+ StrToList +"?subject="+tsubject+"&cc= "+CCtoList+"&body="+tbody;
    }
</script>
