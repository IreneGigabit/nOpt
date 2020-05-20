<%@ Page Language="C#" CodePage="65001"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "出口爭救案案件查詢";//HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opte62";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string PrScode_html = "";
    protected string BJPrScode_html = "";
    protected string pr_rs_type = "";

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
        pr_rs_type = Funcs.GetBJRsType();

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

<form id="reg" name="reg" method="post" action="<%#HTProgPrefix%>List.aspx">
    <input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">

    <div id="id-div-slide">
        <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="75%" align="center">	
            <tr >
	            <td class=lightbluetable align=right nowrap>交辦來源：</td>
	            <td class=whitetablebg colspan=3> 
	            &nbsp;<label><input type="radio" name='qrybr_source' value='br' >區所交辦</label>
	            &nbsp;<label><input type="radio" name='qrybr_source' value='opte' >新增分案</label>
	            &nbsp;<label><input type="radio" name='qrybr_source' checked value='' >不指定</label>
               </td>
            </tr>  
	        <tr>
		        <TD class=lightbluetable align=right>區所案件編號：</TD>
		        <TD class=whitetablebg align=left>
			        <Select id="qryBranch" name="qryBranch"></Select>-
			        <input type="text" id="qryBseq" name="qryBseq" size="5" maxlength="5">-
			        <input type="text" id="qryBseq1" name="qryBseq1" size="1" maxlength="1">
		        </td>
		        <TD class=lightbluetable align=right>客戶編號：</TD>
		        <TD class=whitetablebg align=left>
			        <Select id="qrycust_area" name="qrycust_area"></Select>-
			        <input type="text" id="qrycust_seq" name="qrycust_seq" size="5" maxlength="5">
		        </td>
	        </tr>
            <tr>
		        <TD class=lightbluetable align=right nowrap>案件編號：</TD>
		        <TD class=whitetablebg align=left>
			        <input type="text" id="qryopt_no" name="qryopt_no" size="12" maxlength="10">
		        </td>
		        <TD class=lightbluetable align=right nowrap>國外所案件編號：</TD>
		        <TD class=whitetablebg align=left nowrap >
			        TE-
			        <input type="text" id="qryext_seq" name="qryext_seq" size="5" maxlength="5">-
			        <input type="text" id="qryext_seq1" name="qryext_seq1" size="1" maxlength="1">
		        </td>
	        </tr>
            <tr>
		        <TD class=lightbluetable align=right nowrap>案件名稱：</TD>
		        <TD class=whitetablebg align=left colspan=3>
			        <input type="text" id="qryappl_name" name="qryappl_name" size="50" maxlength="50">
		        </td>
            </tr>
            <tr>
		        <TD class=lightbluetable align=right nowrap>申請人名稱：</TD>
		        <TD class=whitetablebg align=left colspan=3>
			        <input type="text" id="qryap_cname"  name="qryap_cname" size="30" maxlength="30">
		        </td>
            </tr>
            <tr  id='spPR_SCODE'>
	            <td class=lightbluetable align=right nowrap>承辦單位別：</td>
	            <td class=whitetablebg> 
	                 <Select id="qrypr_branch" name="qrypr_branch" class="QLock"></Select>
	            </td>
	            <td class=lightbluetable align=right nowrap>承辦人：</td>
	            <td class=whitetablebg> 
	                <select id="qryPR_SCODE" name="qryPR_SCODE"></select>
	            </td>
            </tr>
            <tr>
	            <td class=lightbluetable align=right nowrap>承辦案性：</td>
	            <td class=whitetablebg colspan="3"> 
                    結構分類：
                    <select name="qrypr_rs_class" id="qrypr_rs_class"></select>
                    <select id=qrypr_rs_code NAME=qrypr_rs_code></select>
                    <input type="hidden" id="pr_rs_type" name="pr_rs_type" value="<%#pr_rs_type %>">
	            </td>
            </tr>
            <tr>
                <td class=lightbluetable align=right nowrap>文號種類：</td>
                <td class=whitetablebg colspan=3>
                    &nbsp;<label><input type="radio" name='qryKINDno' value='your_no'>對方號</label>
                    &nbsp;<label><input type="radio" name='qryKINDno' value='apply_no'>申請號</label>
                    &nbsp;<label><input type="radio" name='qryKINDno' value='issue_no'>註冊號</label>
                </td>
            </tr>
            <tr id='trno' style="display:none">
                <TD class=lightbluetable align=right nowrap>文號：</TD>
                <td class=whitetablebg align="left" colspan=3>
                    <input type="text" id="qryno" name="qryno" size="20" maxLength="30">
                </td>
            </tr>
            <tr  id='spKINDDATE'>
	            <td class=lightbluetable align=right nowrap>日期種類：</td>
	            <td class=whitetablebg colspan=3> 
	                &nbsp;<label><input type="radio" name='qryKINDDATE' checked  value='CONFIRM_DATE'>收文日期</label>
	                &nbsp;<label><input type="radio" name='qryKINDDATE' value='BPR_DATE'>承辦完成日</label>
	                &nbsp;<label><input type="radio" name='qryKINDDATE' value='AP_DATE'>判行日期</label>
                    &nbsp;<label><input type="radio" name='qryKINDDATE' value='last_DATE'>法定期限</label>
	            </td>
            </tr>         
            <tr  id='spdate'>
	            <TD class=lightbluetable  align=right nowrap>日期範圍：</TD>
	            <td class=whitetablebg align="left" colspan=3>
		            <input type="text" id="qrysDATE" name="qrysDATE" size="10" maxLength="10" class="dateField">～
		            <input type="text" id="qryeDATE" name="qryeDATE" size="10" maxLength="10" class="dateField">
		            <label><input type="checkbox" id="qrydtDATE" name="qrydtDATE" value="N">不指定</label>
	            </td>
            </tr>         
            <tr  id='spstat_code'>
                <td class=lightbluetable align=right nowrap>承辦狀態：</td>
                <td class=whitetablebg colspan=3> 
                    &nbsp;<label><input type="radio" name="qrySTAT_kind" value='' checked>不指定</label>
                    &nbsp;<label><input type="radio" name="qrySTAT_kind" value='Yes'>指定</label>
                    &nbsp;<label><input type="checkbox" name="qSTAT_CODE" value='RR'>尚未分案</label>
                    &nbsp;<label><input type="checkbox" name="qSTAT_CODE" value='NN'>承辦中</label>
                    &nbsp;<label><input type="checkbox" name="qSTAT_CODE" value='NY'>承辦完成</label>
                    &nbsp;<label><input type="checkbox" name="qSTAT_CODE" value='YY'>判行完成</label>
                    &nbsp;<label><input type="checkbox" name="qSTAT_CODE" value='YZ'>已回稿確認</label>
                    <input type="hidden" id="qrySTAT_CODE" name="qrySTAT_CODE" value="">
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
        $("#qryBranch,#qrycust_area").getOption({//區所別
            url: getRootPath() + "/ajax/JsonGetSqlDataCnn.aspx",
            data:{sql:"select branch,branchname from branch_code where mark='Y' and branch<>'J' order by sort"},
            valueFormat: "{branch}",
            textFormat: "{branch}_{branchname}"
        });
        $("#qrypr_branch").getOption({//承辦單位別
            url: getRootPath() + "/ajax/JsonGetSqlData.aspx",
            data:{sql:"select cust_code,code_name from cust_code where code_type='OEBranch' order by sortfld"},
            valueFormat: "{cust_code}",
            textFormat: "{code_name}"
        });

        $("#qrypr_rs_class").getOption({//案性
            url: getRootPath() + "/ajax/JsonGetSqlData.aspx",
            data: { sql: "select cust_code,code_name from cust_code where code_type='"+$("#pr_rs_type").val()+"' order by sortfld" },
            valueFormat: "{cust_code}",
            textFormat: "{cust_code}_{code_name}"
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

        $("#qrypr_branch").trigger("change");
        $("#qrypr_rs_class").triggerHandler("change");//依結構分類帶案性代碼

        $("#qrysDATE").val((new Date()).format("yyyy/M/1"));
        $("#qryeDATE").val((new Date()).format("yyyy/M/d"));
        $("input[name='qrySTAT_kind'][value='']").prop("checked",true).triggerHandler("click");//承辦狀態:不指定
    }

    //[查詢]
    $("#btnSrch").click(function (e) {
        if ($("#qryBseq").val()!="" && $("#qryBranch").val()==""){
            alert("請輸入區所別!!!");
            $("#qryBranch").focus();
            return false;
        }

        if ($("#qrycust_seq").val()!="" && $("#qrycust_seq").val()==""){
            alert("請輸入客戶區所別!");
            $("#qryCust_area").focus();
            return false;
        }

        if($("input[name='qrySTAT_kind']:eq(1)").prop("checked")){
            if($("input[name='qSTAT_CODE']:checked").length==0){
                alert("請輸入查詢狀態!");
                $("input[name='qSTAT_CODE']:eq(0)").focus();
                return false;
            }
            //串接狀態
            $("#qrySTAT_CODE").val(getValueStr("input[name='qSTAT_CODE']:checked", ";")+";");
        }else{
            $("#qrySTAT_CODE").val("");
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
    //承辦單位別
    $("#qrypr_branch").change(function (e) {
        $("#qryPR_SCODE").empty();
        if($(this).val()=="BJ"){
            $("#qryPR_SCODE").append("<option value='' style=\"color:blue\">全部</option><%#BJPrScode_html%>");
        }else{
            $("#qryPR_SCODE").append("<option value='' style=\"color:blue\">全部</option><%#PrScode_html%>");
        }
    });
    $("input[name='qryKINDno']").click(function () {
        $("#trno").show();
    });

    //依結構分類帶案性
    $("#qrypr_rs_class").change(function () {
        $("#qrypr_rs_code").getOption({//案性
            url: getRootPath() + "/ajax/json_bjtrs_code.aspx?rs_type=" + $("#pr_rs_type").val() + "&rs_class=" + $("#qrypr_rs_class").val(),
            valueFormat: "{cust_code}",
            textFormat: "{cust_code}_{code_name}",
            attrFormat: "val1='{form_name}'"
        });
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
    //承辦狀態
    $("input[name='qrySTAT_kind']").click(function () {
        if($(this).val()==""){
            $("input[name='qSTAT_CODE']").prop("checked",false).prop("disabled",true);
        }else{
            $("input[name='qSTAT_CODE']").prop("disabled",false);
        }
    });

    $("#qryBSeq").blur(function (e) {
        chkNum1($(this)[0], "區所案件編號");
    });

    $("#qrycust_seq").blur(function (e) {
        chkNum1($(this)[0], "客戶編號");
    });
  
    $("#qryBranch").change(function (e) {
        $("#qrycust_area").prop('selectedIndex', $(this).prop('selectedIndex'));
    });

    $("#qrycust_area").change(function (e) {
        $("#qryBranch").prop('selectedIndex', $(this).prop('selectedIndex'));
    });
</script>
