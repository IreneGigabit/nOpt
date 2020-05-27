<%@ Page Language="C#" CodePage="65001"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "爭救案案件查詢";//HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opt61";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;
    
    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        Token myToken = new Token(HTProgCode);
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
<title><%#HTProgCap%></title>
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
<table cellspacing="1" cellpadding="0" width="98%" border="0" align="center">
    <tr>
        <td class="text9" nowrap="nowrap">&nbsp;【<%#prgid%> <%#HTProgCap%>】</td>
        <td class="FormLink" valign="top" align="right" nowrap="nowrap">
        </td>
    </tr>
    <tr>
        <td colspan="2"><hr class="style-one"/></td>
    </tr>
</table>

<form id="reg" name="reg" method="post" action="<%#HTProgPrefix%>List.aspx">
    <input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">

    <div id="id-div-slide">
        <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="75%" align="center">	
	        <tr>
		        <td class="lightbluetable" align="right">承辦案性 :</td>
		        <td class="whitetablebg" align="left">
                    <select id="qryArcase" name="qryArcase"></select>
		        </td> 
	        </tr>
            <tr>
	            <td class=lightbluetable align=right nowrap>承&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;辦：</td>
	            <td class=whitetablebg> 
	                <select id="qryPR_SCODE" name="qryPR_SCODE"></select>
	            </td>
	        </tr>
	        <tr>
		        <td class="lightbluetable" align="right">列印選擇 :</td>
		        <td class="whitetablebg" align="left">
		            <label><input type="radio" name="qrynew" value="N" checked>尚未列印</label>
		            <label><input type="radio" name="qrynew" value="P">已列印</label>
		            <label><input type="radio" name="qrynew" value="">不設定</label>
		        </td>
	        </tr>
	        <tr>
		        <td class="lightbluetable" align="right">序號選擇 :</td>
		        <td class="whitetablebg" align="left">
			        <label><input type="radio" name="qryno_type" value="opt_no" checked>案件編號</label>
 			        <label><input type="radio" name="qryno_type" value="Bseq_no" />區所案件編號</label>
 		        </td>
	        </tr>
	        <tr id=sin_no1 style="display:">
		        <td class="lightbluetable" align="right">案件編號 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
                    <input type="text" id="qrySopt_no" name="qrySopt_no" size="11" maxlength="10">～<input type="text" id="qryEopt_no" name="qryEopt_no" size="11" maxlength="10">
		        </td>
	        </tr>
	        <tr id=sin_no2 style="display:none">
		        <td class="lightbluetable" align="right">區所案件編號 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
			        <Select id="qryBranch" name="qryBranch"></Select>
			        <input type="text" id="qryBSeq" name="qryBSeq" size="5" maxLength="5">-<input type="text" id="qryBSeq1" name="qryBSeq1" size="1" maxLength="1">
		        </td>
	        </tr>
	        <tr>
		        <td class="lightbluetable" align="right">分案日期 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
		        <input type="text" id="qrySin_date" name="qrySin_date" size="10" maxLength="10">～
		        <input type="text" id="qryEin_date" name="qryEin_date" size="10" maxLength="10">
		        <label><input type="checkbox" id=qrydtDATE name=qrydtDATE value="N">不指定</label>
		        </td>
	        </tr>
        </table>
        <br>
        <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>
        <table id="tabBtn" border="0" width="100%" cellspacing="0" cellpadding="0" align="center">
	        <tr><td width="100%" align="center">
			    <input type="button" value="查　詢" class="cbutton" id="btnSrch" name="btnSrch">
			    <input type="button" value="重　填" class="cbutton" id="btnRest" name="btnRest">
	        </td></tr>
        </table>
    </div>
</form>

</body>
</html>


<script language="javascript" type="text/javascript">
    $(function () {
        $("#qryArcase").getOption({//承辦案性
            url: getRootPath() + "/ajax/JsonGetSqlData.aspx",
            data:{sql:"select RS_code, RS_detail from code_br (dept = 'T') AND (cr = 'Y') And no_code='N'  and mark='B' and prt_code is not null order by rs_class"},
            valueFormat: "{RS_code}",
            textFormat: "{RS_code}---{RS_detail}"
        });

        $("#qryPR_SCODE").getOption({//承辦人
            url: getRootPath() + "/ajax/LookupDataCnn.aspx?type=GetPrScode&submitTask=U",
            valueFormat: "{scode}",
            textFormat: "{scode}-{sc_name}",
        });

        $("#qryBranch").getOption({//區所別
            url: getRootPath() + "/ajax/JsonGetSqlDataCnn.aspx",
            data:{sql:"select branch,branchname from branch_code where mark='Y' and branch<>'J' order by sort"},
            valueFormat: "{branch}",
            textFormat: "{branch}_{branchname}"
        });

        $("input.dateField").datepick();
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",false).triggerHandler("click");//☑測試

        $("#tabBtn").showFor((<%#HTProgRight%> & 6)).find("input").prop("checked",true);//[查詢][重填]

        this_init();
    });

    function this_init(){
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "100%,0%";
        }

        $("#qrySin_date").val((new Date()).format("yyyy/M/1"));
        $("#qryEin_date").val((new Date()).format("yyyy/M/d"));
        $("input[name='qryno_type']").triggerHandler("click");//序號選擇:案件編號
    }

    //[查詢]
    $("#btnSrch").click(function (e) {
        if($("input[name='qryno_type']:checked").val()=="Bseq_no"){
            if ($("#qryBranch").val()==""){
                alert("請輸入區所別!!!");
                $("#qryBranch").focus();
                return false;
            }

            if ($("#qryBSeq").val()==""){
                alert("請輸入區所案件編號!!!");
                $("#qryBSeq").focus();
                return false;
            }
        }else if($("input[name='qryno_type']:checked").val()=="opt_no"){
            if ($("#qrySopt_no").val()!=""){
                if(!isNumeric($("#qrySopt_no").val())){
                    alert("案件編號(起)錯誤,請重新輸入!!!");
                    $("#qrySopt_no").focus();
                    return false;
                }
            }
            if ($("#qryEopt_no").val()!=""){
                if(!isNumeric($("#qryEopt_no").val())){
                    alert("案件編號(迄)錯誤,請重新輸入!!!");
                    $("#qryEopt_no").focus();
                    return false;
                }
            }
            if ($("#qrySopt_no").val()!="" &&$("#qryEopt_no").val()!="" ){
                if($("#qrySopt_no").val()>$("#qryEopt_no").val()){
                    alert("案件編號(起),不得大於案件編號(迄)");
                    return false;
                }
            }
        }

        reg.action = "<%=HTProgPrefix%>_list.aspx";
        //reg.target = "Eblank";
        reg.submit();
    });

    //[重填]
    $("#btnRest").click(function (e) {
        reg.reset();
    });

    //////////////////////
    //序號選擇
    $("input[name='qryno_type']").click(function () {
        $("#sin_no1,#sin_no2").hide();
        if($(this).val()=="opt_no"){
            $("#sin_no1").show();
            $("#qryBSeq1").val("");
        }else{
            $("#sin_no2").show();
            $("#qryBSeq1").val("_");
        }
    });

    //日期不指定
    $("#qrydtDATE").click(function () {
        if($(this).prop("checked")){
            $("#qrysDATE").val("");
            $("#qryeDATE").val("");
        }else{
            $("#qrysDATE").val((new Date()).format("yyyy/M/1"));
            $("#qryeDATE").val((new Date()).format("yyyy/M/d"));
        }
    }); 
  
    $("#qrySin_date,#qryEin_date").blur(function (e) {
        ChkDate($(this)[0]);
    });

    $("#qryBSeq").blur(function (e) {
        chkNum1($(this)[0], "區所案件編號");
    });

    $("#qrySopt_no,#qryEopt_no").blur(function (e) {
        chkNum1($(this)[0], "案件編號");
    });
</script>
