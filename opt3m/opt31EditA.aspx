<%@ Page Language="C#" CodePage="65001"%>

<%@ Register Src="~/commonForm/opt/BR_form.ascx" TagPrefix="uc1" TagName="BR_form" %>
<%@ Register Src="~/commonForm/opt/BR_formA.ascx" TagPrefix="uc1" TagName="BR_formA" %>


<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opt31";//程式檔名前綴
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected int HTProgRight = 0;

    protected string submitTask = "";
    protected string branch = "";
    protected string opt_sqlno = "";
    protected string case_no = "";
    
    protected string dmt_show_flag = "Y";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";
        case_no = Request["case_no"] ?? "";
        submitTask = Request["submitTask"] ?? "";

        if (submitTask == "ADD") HTProgCap += "‧<b style='color:Red'>新增</b>";
        
        Token myToken = new Token(prgid);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            QueryPageLayout();
            this.DataBind();
        }
    }
    
    
    private void QueryPageLayout() {
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
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.Snoopy.date.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.irene.form.js")%>"></script>
</head>

<body>
<table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td class="text9" nowrap="nowrap">&nbsp;【<%=prgid%><%=HTProgCap%>】
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

    <table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td>
            <uc1:BR_formA runat="server" ID="BR_formA" />
            <!--include file="../commonForm/opt/BR_formA.ascx"--><!--承辦內容-->
            <uc1:BR_form runat="server" ID="BR_form" />
            <!--include file="../commonForm/opt/BR_form.ascx"--><!--承辦內容-->
        </td>
    </tr>
    </table>
    <br />
    <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>
</form>

<table border="0" width="98%" cellspacing="0" cellpadding="0" >
<tr>
    <td align="center">
        <input type=button value ="新增分案" class="cbutton" onClick="formSearchSubmit('ADD')" id="btnsearchSubmit1">
        <input type=button value ="分　　案" class="cbutton" onClick="formSearchSubmit('U')" id="btnsearchSubmit2">
    </td>
</tr>
</table>

</body>
</html>

<script language="javascript" type="text/javascript">
    $(function () {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "0%,100%";
        }
        this_init();
    });

    var br_opt = {};
    //初始化
    function this_init() {
        settab("#br");
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").attr("checked",true);//☑測試

        //取得案件資料
        $.ajax({
            type: "get",
            url: getRootPath() + "/AJAX/OptData.aspx?branch=<%=branch%>&opt_sqlno=<%=opt_sqlno%>",
            async: false,
            cache: false,
            success: function (json) {
                if($("#chkTest").attr("checked"))toastr.info("<a href='" + this.url + "' target='_new'>Debug！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
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


        br_formA.init();
        br_form.init();

        $("input.dateField").datepick();

        //欄位控制
        $("#CTab td.tab[href='#dmt']").showFor(("<%#dmt_show_flag%>" == "Y"));
        $("#span_sopt_no").hideFor($("#submittask").val()=="ADD");//新增分案時不顯示案件編號
        $("#btnsearchSubmit1").showFor($("#submittask").val()=="ADD");//新增分案時顯示[新增分案]
        $("#btnsearchSubmit2").showFor($("#submittask").val()!="ADD");//分案時顯示[分　　案]
        $(".Lock").lock();
        $(".BRClass").unlock("<%#prgid%>"=="opt21");//分案作業要解鎖承辦內容
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
        var errFlag = false;

        errFlag = $("#Branch").chkRequire() || errFlag;
        errFlag = $("#Bseq").chkRequire() || errFlag;
        errFlag = $("#Bseq1").chkRequire() || errFlag;
        errFlag = $("#dfy_last_date").chkRequire() || errFlag;
        errFlag = $("#ctrl_date").chkRequire() || errFlag;
        errFlag = $("#pr_scode").chkRequire() || errFlag;
        errFlag = $("#Arcase").chkRequire() || errFlag;

        if (($("#Bseq").val()!=$("#oldBseq").val()
            ||$("#Bseq1").val()!=$("#oldBseq1").val()
            ||$("#Branch").val()!=$("#oldBranch").val())
            &&$("#oldBseq").val()!=""&&$("#oldBseq1").val()&&$("#oldBranch").val()
            ){
            alert("區所案件編號變動過，請按[確定]按鈕，重新抓取資料!!!");
            errFlag=true;
        }

        if (errFlag) {
		    alert("輸入的資料有誤,請檢查!!");
		    return false;
		}

        $("select,textarea,input").unlock();
        $("#btnsearchSubmit1,#btnsearchSubmit2").lock();
        reg.submittask.value = dowhat;
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.submit();
    }
</script>
