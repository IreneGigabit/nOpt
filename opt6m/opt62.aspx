<%@ Page Language="C#" CodePage="65001"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "爭救案案件查詢";//HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opt62";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;
    protected string DebugStr = "";
 
    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        DebugStr = myToken.DebugStr;
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
            <tr >
	            <td class=lightbluetable align=right nowrap>交辦來源：</td>
	            <td class=whitetablebg colspan=3> 
	            &nbsp;<label><input type="radio" name='qrybr_source' value='br' >區所交辦</label>
	            &nbsp;<label><input type="radio" name='qrybr_source' value='opt' >新增分案</label>
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
		            <TD class=lightbluetable align=right nowrap>申請人名稱：</TD>
		            <TD class=whitetablebg align=left>
			            <input type="text" id="qryap_cname"  name="qryap_cname" size="30" maxlength="30">
		            </td>
            </tr>
            <tr>
	            <td class=lightbluetable align=right nowrap>承辦人：</td>
	            <td class=whitetablebg> 
	                <select id="qryPR_SCODE" name="qryPR_SCODE"></select>
	            </td>
	            <td class=lightbluetable align=right nowrap>案性：</td>
	            <td class=whitetablebg> 
	                <select id="qryARCASE" name="qryARCASE"></select>
	            </td>
            </tr>         
            <tr  id='spKINDDATE'>
	            <td class=lightbluetable align=right nowrap>日期種類：</td>
	            <td class=whitetablebg colspan=3> 
	                &nbsp;<label><input type="radio" name='qryKINDDATE' checked  value='CONFIRM_DATE'>收文日期</label>
	                &nbsp;<label><input type="radio" name='qryKINDDATE' value='BPR_DATE'>承辦完成日</label>
	                &nbsp;<label><input type="radio" name='qryKINDDATE' value='AP_DATE'>判行日期</label>
                    &nbsp;<label><input type="radio" name='qryKINDDATE' value='GS_DATE'>預計發文日</label>
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
                    &nbsp;<label><input type="checkbox" name="qSTAT_CODE" value='YS'>已發文</label>
                    <input type="hidden" id="qrySTAT_CODE" name="qrySTAT_CODE" value="">
                </td>
            </tr>         
        </table>
        <br>
        <%#DebugStr%>
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

        $("#qryPR_SCODE").getOption({//承辦人
            url: getRootPath() + "/ajax/LookupDataCnn.aspx?type=GetPrScode&submitTask=U",
            valueFormat: "{scode}",
            textFormat: "{scode}_{sc_name}",
            showEmpty:false,
            firstOpt: "<option value=''>全部</option>"
        });

        $("#qryARCASE").getOption({//案性
            url: getRootPath() + "/ajax/JsonGetSqlData.aspx",
            data: { sql: "select cust_code,code_name from cust_code where code_type='T92' order by form_name" },
            valueFormat: "{cust_code}",
            textFormat: "{cust_code}-{code_name}",
            showEmpty:false,
            firstOpt: "<option value=''>全部</option>"
        });

        $("input.dateField").datepick();

        $("#tabBtn").showFor((<%#HTProgRight%> & 6)).find("input").prop("checked",true);//[查詢][重填]

        this_init();
    });

    function this_init(){
        if (window.parent.tt !== undefined) {
            window.parent.tt.rows = "100%,0%";
        }

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

        if ($("#qryCust_seq").val()!="" && $("#qryCust_area").val()==""){
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
  
    $("#qryBranch").change(function (e) {
        $("#qrycust_area").prop('selectedIndex', $(this).prop('selectedIndex'));
    });

    $("#qrycust_area").change(function (e) {
        $("#qryBranch").prop('selectedIndex', $(this).prop('selectedIndex'));
    });

    $("#qryBSeq").blur(function (e) {
        chkNum1($(this)[0], "區所案件編號");
    });

    $("#qrycust_seq").blur(function (e) {
        chkNum1($(this)[0], "客戶編號");
    });
</script>
