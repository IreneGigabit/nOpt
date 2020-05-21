<%@ Page Language="C#" CodePage="65001"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "出口爭救案承辦工作量統計表";//HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opte65";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string PrScode_html = "";
    protected string BJPrScode_html = "";
    
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
        PrScode_html = Funcs.GetPrTermALL("").Option("{scode}", "{scode}_{sc_name}").Replace("\n", "");
        BJPrScode_html = Funcs.GetBJPrTermALL("").Option("{scode}", "{scode}_{sc_name}").Replace("\n", "");//顯示"請選擇"
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
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
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.Snoopy.date.js")%>"></script>
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

<form id="reg" name="reg" method="post">
    <input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">
    <input type="hidden" id="qrySTAT_CODE" name="qrySTAT_CODE" value="YY;YZ;">
    <div id="id-div-slide">
        <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="75%" align="center">	
 	        <tr>
		        <td class="lightbluetable" align="right">報表種類 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
			        <label><input type="radio" value="1" name=qryprint>統計表</label>
			        <label><input type="radio" value="2" name=qryprint>明細表</label>
		        </td> 
	        </tr>
           <tr >
	            <td class=lightbluetable align=right nowrap>交辦來源：</td>
	            <td class=whitetablebg colspan=3> 
	                <label><input type="radio" name='qrybr_source' value='br' >區所交辦</label>
	                &nbsp;<label><input type="radio" name='qrybr_source' value='opte' >新增分案</label>
	                &nbsp;<label><input type="radio" name='qrybr_source' checked value='' >不指定</label>
               </td>
            </tr>  
            <tr >
	            <td class=lightbluetable align=right nowrap>區所：</td>
	            <td class=whitetablebg colspan=3> 
			        <label><input type="radio" value="N" name=qryBranch>台北</label>
			        <label><input type="radio" value="C" name=qryBranch>台中</label>
			        <label><input type="radio" value="S" name=qryBranch>台南</label>
			        <label><input type="radio" value="K" name=qryBranch>高雄</label>
			        <label><input type="radio" value="" name=qryBranch checked>全部</label>
               </td>
            </tr>
	        <tr id="tr_Bseq" style="display:none">
		        <td class="lightbluetable" align="right">區所編號 :</td>
		        <td class="whitetablebg" align="left">
			        <input type="text" id="qryBseq" name="qryBseq" size="5" maxlength="5">-
			        <input type="text" id="qryBseq1" name="qryBseq1" size="1" maxlength="1">
		        </td> 
		        <td class="lightbluetable" align="right">客戶編號 :</td>
		        <td class="whitetablebg" align="left">
			        <input type="text" id="qrycust_area" name="qrycust_area" size="1" maxLength="1">-
			        <input type="text" id="qrycust_seq" name="qrycust_seq" size="5" maxlength="5">
		        </td> 
	        </tr>
	        <tr id="tr_yourno" style="display:none">
		        <TD class=lightbluetable align=right nowrap>對方號：</TD>
		        <TD class=whitetablebg align=left>
		            <input type="hidden" id='qryKINDno' name='qryKINDno' value='your_no'>
			        <input type="text" id="qryno" name="qryno" size="12" maxlength="10">
		        </td>
		        <TD class=lightbluetable align=right nowrap>國外所案件編號：</TD>
		        <TD class=whitetablebg align=left nowrap >
			        TE-
			        <input type="text" id="qryext_seq" name="qryext_seq" size="5" maxlength="5">-
			        <input type="text" id="qryext_seq1" name="qryext_seq1" size="1" maxlength="1">
		        </td>
            </tr>
            <tr id="tr_qryscode" style="display:none">
		        <td class="lightbluetable" align="right">營洽 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
			        <span id="span_scode">
				        <Select id="qryin_scode" name="qryin_scode"></Select>
			        </span>	
		        </td>
	        </tr>	
            <tr  id='tr_prscode'>
	            <td class=lightbluetable align=right nowrap>承辦單位別：</td>
	            <td class=whitetablebg> 
	                 <Select id="qrypr_branch" name="qrypr_branch" class="QLock"></Select>
	            </td>
	            <td class=lightbluetable align=right nowrap>承辦人：</td>
	            <td class=whitetablebg> 
	                <select id="qryPR_SCODE" name="qryPR_SCODE"></select>
	            </td>
            </tr>
	        <tr id='spKINDDATE'>
		        <td class="lightbluetable" align="right">日期種類 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
			        <label><input type="radio" value="BCase_date" name=qryKinddate checked>交辦日期</label>
			        <label><input type="radio" value="BPR_DATE" name=qryKinddate>承辦完成日</label>
		        </td> 
	        </tr>
	        <tr id="tr_month">
		        <td class="lightbluetable" align="right">日期範圍 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
				        <select id="qryYear" name="qryYear"></select>年/
				        <input type="text" id="qrysMonth" name="qrysMonth" size="2" maxlength="2" value="1">月～
				        <input type="text" id="qryeMonth" name="qryeMonth" size="2" maxlength="2">月&nbsp;&nbsp;&nbsp;&nbsp;
                    <label><input type="checkbox" name="qryend_flag" value="Y" checked>不含離職人員</label>
		        </td>
	        </tr>
            <tr id="tr_date">
		        <td class="lightbluetable" align="right">日期範圍 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
		            <input type="text" id="qrysDATE" name="qrysDATE" size="10" maxLength="10" class="dateField">～
		            <input type="text" id="qryeDATE" name="qryeDATE" size="10" maxLength="10" class="dateField">
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
        $("#qrypr_branch").getOption({//承辦單位別
            url: getRootPath() + "/ajax/JsonGetSqlData.aspx",
            data:{sql:"select cust_code,code_name from cust_code where code_type='OEBranch' order by sortfld"},
            valueFormat: "{cust_code}",
            textFormat: "{code_name}"
        });

        //年度
        var qryYear="";
        for(var j = 2000; j<=2060;j++){
            qryYear+='<option value="' + j + '">' + j + '</option>'
        }
        $("#qryYear").replaceWith('<select id="qryYear" name="qryYear">' + qryYear + '</select>');

        $("input.dateField").datepick();
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",false).triggerHandler("click");//☑測試

        $("#tabBtn").showFor((<%#HTProgRight%> & 2)).find("input").prop("checked",true);//[查詢][重填]

        this_init();
    });

    function this_init(){
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "100%,0%";
        }

        $("#qrypr_branch").trigger("change");
        $("input[name='qryprint']").eq(0).prop("checked",true).triggerHandler("click");
        $("input[name='qryBranch'][value='']").prop("checked",true).triggerHandler("click");
        $("#qrysDATE").val((new Date()).format("yyyy/M/1"));
        $("#qryeDATE").val((new Date()).format("yyyy/M/d"));

        $("#qryYear").val((new Date()).format("yyyy"));
        $("#qryeMonth").val((new Date()).format("M"));
    }

    //[查詢]
    $("#btnSrch").click(function (e) {
        if($("#qrycust_seq").val()!=""||$("#qryBseq").val()!=""){
            if($("input[name='qryBranch']:checked").val()==""){
                alert("請選擇區所!");
                return false;
            }
        }

        if ($("input[name='qryprint']:checked").val()=="1"){
            reg.action = "<%=HTProgPrefix%>_1list.aspx";
        }else if($("input[name='qryprint']:checked").val()=="2"){
            reg.action = "opte62_list.aspx";
        }
        //reg.target = "Eblank";
        reg.submit();
    });

    //[重填]
    $("#btnRest").click(function (e) {
        reg.reset();
    });

    //////////////////////
    //報表種類
    $("input[name='qryprint']").click(function () {
        if($(this).val()=="1"){
            $("#tr_Bseq,#tr_yourno,#tr_date").hide();
            $("#tr_month").show();
        }else if($(this).val()=="2"){
            $("#tr_Bseq,#tr_yourno,#tr_date").show();
            $("#tr_month").hide();
            $("input[name='qryBranch']:checked").triggerHandler("click");
        }
    });

    $("#qryBSeq").blur(function (e) {
        if (chkNum1($(this)[0], "區所編號")) return false;
    });

    $("#qrycust_area").blur(function (e) {
        var a=$(this).val().toUpperCase();
        if (a!=$("input[name='qryBranch']:checked").val()) {
            alert("區所錯誤");
            $(this).focus();
            return false;
        }
    });

    $("#qrycust_seq").blur(function (e) {
        if (chkNum1($(this)[0], "客戶編號")) return false;
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

    //區所
    $("input[name='qryBranch']").click(function () {
        var tbranch=$(this).val();
        $("#qrycust_area").val(tbranch);
        //$("#qryin_scode").getOption({//營洽
        //    url: getRootPath() + "/ajax/json_get_scode.aspx?branch="+tbranch,
        //    valueFormat: "{in_scode}",
        //    textFormat: "{in_scode}_{scode_name}",
        //    showEmpty:false,
        //    firstOpt: "<option value='' style='color:blue'>全部</option>"
        //});
    });

    $("#qrysMonth,#qryeMonth").blur(function (e) {
        if (chkNum1($(this)[0], "月份")) return false;
        if(parseInt($("#qrysMonth").val())<1||parseInt($("#qrysMonth").val())>12){
            alert("月份請輸入介於1~12的數字!");
            $(this).focus();
            return false;
        }
    });

    //承辦單位別
    $("#qrypr_branch").change(function (e) {
        $("#qryPR_SCODE").empty();
        if($(this).val()=="BJ"){
            $("#qryPR_SCODE").append("<option value='' style=\"color:blue\">全部</option><%#BJPrScode_html%>");
        }else{
            $("#qryPR_SCODE").append("<option value='' style=\"color:blue\">全部</option><%#PrScode_html%>");
        }
    });
</script>
