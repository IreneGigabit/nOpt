<%@ Page Language="C#" CodePage="65001"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "爭救案交辦品質評分表";//HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opt63";//程式檔名前綴
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
	                &nbsp;<label><input type="radio" name='qrybr_source' value='opt' >新增分案</label>
	                &nbsp;<label><input type="radio" name='qrybr_source' checked value='' >不指定</label>
               </td>
            </tr>  
	        <tr id="tr_qryinclude" style="display:none">
		        <td class="lightbluetable" align="right">包含項目 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
			        <input type="radio" value="N" name=qryinclude checked>不含附屬案性
			        <input type="radio" value="Y" name=qryinclude>只印附屬案性
			        <input type="radio" value="" name=qryinclude>全部
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
	        <tr id="tr_Bseq">
		        <td class="lightbluetable" align="right">區所編號 :</td>
		        <td class="whitetablebg" align="left">
			        <input type="text" id="qryBseq" name="qryBseq" size="5" maxLength="5">-<input type="text" id="qryBseq1" name="qryBseq1" size="1" maxLength="1">
		        </td> 
		        <td class="lightbluetable" align="right">客戶編號 :</td>
		        <td class="whitetablebg" align="left">
			        <input type="text" id="qrycust_seq" name="qrycust_seq" size="5">
		        </td> 
	        </tr>
            <tr id="tr_qryscode">
		        <td class="lightbluetable" align="right">營洽 :</td>
		        <td class="whitetablebg" align="left">
			        <span id="span_scode">
				        <Select id="qryin_scode" name="qryin_scode"></Select>
			        </span>	
		        </td>
		        <td class="lightbluetable" align="right">承辦人 :</td>
		        <td class="whitetablebg" align="left">
	                <select id="qryPR_SCODE" name="qryPR_SCODE"></select>
		        </td> 
	        </tr>	
	        <tr id="tr_month">
		        <td class="lightbluetable" align="right">判行日期 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
			        年度：
				        <select id="qryYear" name="qryYear"></select><br>
			        月份：
				        <input type="text" id="qrysMonth" name="qrysMonth" size="2" maxlength="2" value="1">月～
				        <input type="text" id="qryeMonth" name="qryeMonth" size="2" maxlength="2">月
		        </td>
	        </tr>
	        <tr id="tr_date">
		        <td class="lightbluetable" align="right">判行日期 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
		            <input type="text" id="qrysDATE" name="qrysDATE" size="10" maxLength="10" class="dateField">～
		            <input type="text" id="qryeDATE" name="qryeDATE" size="10" maxLength="10" class="dateField">
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
        $("#qryPR_SCODE").getOption({//承辦人
            url: getRootPath() + "/ajax/LookupDataCnn.aspx?type=GetPrScode&submitTask=U",
            valueFormat: "{scode}",
            textFormat: "{scode}--{sc_name}",
            showEmpty:false,
            firstOpt: "<option value=''>全部</option>"
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

        $("input[name='qryprint']").eq(0).prop("checked",true).triggerHandler("click");
        $("input[name='qryBranch'][value='']").prop("checked",true).triggerHandler("click");

        $("#qryYear").val((new Date()).format("yyyy"));
        $("#qryeMonth").val((new Date()).format("M"));
    }

    //[查詢]
    $("#btnSrch").click(function (e) {
        if ($("input[name='qryprint']:checked").val()=="1"){
            reg.action = "<%=HTProgPrefix%>_1list.aspx";
        }else if($("input[name='qryprint']:checked").val()=="2"){
            reg.action = "<%=HTProgPrefix%>_2list.aspx";
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
            $("#tr_Bseq,#tr_qryscode,#tr_date").hide();
            $("#tr_month").show();
        }else if($(this).val()=="2"){
            $("input[name='qSTAT_CODE']").prop("disabled",false);
            $("#tr_Bseq,#tr_qryscode,#tr_date").show();
            $("#tr_month").hide();
            $("input[name='qryBranch']:checked").triggerHandler("click");
        }
    });

    //區所
    $("input[name='qryBranch']").click(function () {
        var tbranch=$(this).val();
        $("#qryin_scode").getOption({//營洽
            url: getRootPath() + "/ajax/json_get_scode.aspx?branch="+tbranch,
            valueFormat: "{in_scode}",
            textFormat: "{in_scode}_{scode_name}",
            showEmpty:false,
            firstOpt: "<option value='' style='color:blue'>全部</option>"
        });
    });

    $("#qrysMonth,#qryeMonth").blur(function (e) {
        if (chkNum1($(this)[0], "月份")) return false;
        if(parseInt($("#qrysMonth").val())<1||parseInt($("#qrysMonth").val())>12){
            alert("月份請輸入介於1~12的數字!");
            $(this).focus();
            return false;
        }
    });
</script>
