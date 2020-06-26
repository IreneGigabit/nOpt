<%@ Page Language="C#" CodePage="65001"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "出口爭救案性統計表";//HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opte64";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;
    protected string DebugStr = "";

    protected string PrScode_html = "";
    protected string BJPrScode_html = "";

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
        PrScode_html = Funcs.GetPrTermALL("").Option("{scode}", "{scode}_{sc_name}").Replace("\n", "");
        BJPrScode_html = Funcs.GetBJPrTermALL("").Option("{scode}", "{scode}_{sc_name}").Replace("\n", "");//顯示"請選擇"
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
    <div id="id-div-slide">
        <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="75%" align="center">	
 	        <tr>
		        <td class="lightbluetable" align="right">報表種類 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
			        <label><input type="radio" value="T" name=qryprint>統計表</label>
			        <label><input type="radio" value="D" name=qryprint>明細表</label>
			        <label><input type="radio" value="B" name=qryprint>同期比較表</label>
		        </td> 
	        </tr>
            <tr >
	            <td class=lightbluetable align=right nowrap>交辦來源：</td>
	            <td class=whitetablebg colspan="3"> 
	                <label><input type="radio" name='qrybr_source' value='br' >區所交辦</label>
	                &nbsp;<label><input type="radio" name='qrybr_source' value='opte' >新增分案</label>
	                &nbsp;<label><input type="radio" name='qrybr_source' checked value='' >不指定</label>
               </td>
            </tr>  
	        <tr id="tr_qrykind">
		        <td class="lightbluetable" align="right">統計依據 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
			        <label><input type="radio" value="rs_class" name=qrykind checked>類別</label>
			        <label><input type="radio" value="rs_code" name=qrykind >案性</label>
			        <label><input type="radio" value="month" name=qrykind >月份</label>
		        </td> 
	        </tr>
	        <tr id="tr_class">
		        <td class="lightbluetable" align="right">統計類別 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
                    <span id="spanclass"></span>
			        <br><label><input type="checkbox" id=qryPClassA name=qryPClassA value="1">全部</label>
			        <input type="hidden" id="qryClass" name="qryClass">
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
		        <td class="lightbluetable" align="right">區所案件編號 :</td>
		        <td class="whitetablebg" align="left" colspan=3>
			        <input type="text" id="qryBseq" name="qryBseq" size="5" maxLength="5">-<input type="text" id="qryBseq1" name="qryBseq1" size="1" maxLength="1">
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
		        <td class="lightbluetable" align="right">承辦狀態 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
			        <label><input type="radio" value="NN" name=qryStatus>承辦中</label>
			        <label><input type="radio" value="Y" name=qryStatus>判行完成</label>
			        <label><input type="radio" value="" name=qryStatus checked>全部</label>
		        </td> 
	        </tr>
	        <tr>
		        <td class="lightbluetable" align="right">日期種類 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
			        <label><input type="radio" value="Confirm_date" name=qryKinddate checked>收文日期</label>
			        <label><input type="radio" value="ap_date" name=qryKinddate>判行日期</label>
		        </td> 
	        </tr>
	        <tr id="tr_date">
		        <td class="lightbluetable" align="right">日期範圍 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
		            <input type="text" id="qrysDATE" name="qrysDATE" size="10" maxLength="10" class="dateField">～
		            <input type="text" id="qryeDATE" name="qryeDATE" size="10" maxLength="10" class="dateField">
		        </td> 
	        </tr>
	        <tr id="tr_month" style="display:none">
		        <td class="lightbluetable" align="right">日期範圍 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
			        年度：
				        <select id="qryYear" name="qryYear"></select><br>
			        月份：
				        <input type="text" id="qrysMonth" name="qrysMonth" size="2" maxlength="2" value="1">月～
				        <input type="text" id="qryeMonth" name="qryeMonth" size="2" maxlength="2">月
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
        $("#spanclass").getCheckbox({//統計類別
            url: getRootPath() + "/ajax/JsonGetSqlData.aspx",
            data:{sql:"Select * from cust_code where code_type='bjt96' order by cust_code"},
            objName: "qryPClass",
            valueFormat: "{cust_code}",
            textFormat: "{code_name}&nbsp;&nbsp;",
            mod:3
        });

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

        $("#tabBtn").showFor((<%#HTProgRight%> & 2)).find("input").prop("checked",true);//[查詢][重填]

        this_init();
    });

    function this_init(){
        if (window.parent.tt !== undefined) {
            window.parent.tt.rows = "100%,0%";
        }

        $("#qrypr_branch").trigger("change");
        $("input[name='qryprint']").eq(0).prop("checked",true).triggerHandler("click");
        //$("#qrysDATE").val($.DateAdd("M","-1",new Date().format("yyyy/M/1")));//上個月一號
        //$("#qryeDATE").val($.DateAdd("d","-1",new Date().format("yyyy/M/1")));//上個月最後一天
        $("#qrysDATE").val($.DateAdd("M","-1",new Date().format("yyyy/M/1")).format("yyyy/M/d"));//上個月一號
        $("#qryeDATE").val($.DateAdd("d","-1",new Date().format("yyyy/M/1")).format("yyyy/M/d"));//上個月最後一天

        $("#qryYear").val((new Date()).format("yyyy"));
        $("#qryeMonth").val((new Date()).format("M"));
    }

    //[查詢]
    $("#btnSrch").click(function (e) {
        if($("input[name='qrykind']:checked").length==0){
            alert("請選擇統計依據!");
            $("input[name='qrykind']").eq(0).focus();
            return false;
        }
        if($("input[name='qryKinddate']:checked").val()=="Confirm_date"
            &&($("input[name='qrykind']:checked").val()=="rs_class"
            ||$("input[name='qrykind']:checked").val()=="rs_code")
            ){
            if($("#qrysDATE").val()==""||$("#qryeDATE").val()==""){
                alert("日期範圍不可為空白!");
                $("#qrysDATE").focus();
                return false;
            }
        }
        if($("input[name='qrykind']:checked").val()=="month"){
            if($("qryYear").val()==""){
                alert("年度不可空白!");
                $("#qryYear").focus();
                return false;
            }
            if($("qrysMonth").val()==""){
                alert("月份(起)不可空白!");
                $("#qrysMonth").focus();
                return false;
            }
            if($("qryeMonth").val()==""){
                alert("月份(迄)不可空白!");
                $("#qryeMonth").focus();
                return false;
            }
        }
        if($("input[name='qryprint']:checked").val()=="D"){//明細表
            if($("#qryBseq").val()!=""){
                if($("input[name='qryBranch']:checked").val()==""){
                    alert("請輸入區所別!");
                    $("input[name='qryBranch']").eq(0).focus();
                    return false;
                }
            }
            $("input[name='qrykind']").prop("checked",false);
        }else{
            if($("input[name='qryPClass']:checked").length==0){
                alert("請勾選欲統計之類別!!");
                return false;
            }
        }
        //串接統計類別
        $("#qryClass").val(getValueStr("input[name='qryPClass']:checked", ";")+";");

        if ($("input[name='qryprint']:checked").val()=="T"){
            reg.action = "<%=HTProgPrefix%>_1list.aspx";
        }else if($("input[name='qryprint']:checked").val()=="D"){
            reg.action = "<%=HTProgPrefix%>_3list.aspx";
        }else if($("input[name='qryprint']:checked").val()=="B"){
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
    //承辦單位別
    $("#qrypr_branch").change(function (e) {
        $("#qryPR_SCODE").empty();
        if($(this).val()=="BJ"){
            $("#qryPR_SCODE").append("<option value='' style=\"color:blue\">全部</option><%#BJPrScode_html%>");
        }else{
            $("#qryPR_SCODE").append("<option value='' style=\"color:blue\">全部</option><%#PrScode_html%>");
        }
    });

    //承辦狀態
    $("input[name='qryStatus']").click(function () {
        if($(this).val()=="NN"){//承辦中
            $("input[name='qryKinddate']").eq(0).prop("checked",true);//收文日期
            $("input[name='qryKinddate']").eq(1).prop("disabled",true);//判行日期
        }else{
            $("input[name='qryKinddate']").eq(1).prop("disabled",false);//判行日期
        }
    });

    //報表種類
    $("input[name='qryprint']").click(function () {
        if($(this).val()=="D"){//明細表
            $("#tr_qrykind").hide();
            $("#tr_Bseq").show();
            $("input[name='qryBranch']").eq(0).prop("checked",true);
            $("input[name='qrykind']").eq(0).prop("checked",true);
        }else{
            $("#tr_qrykind").show();
            $("#tr_Bseq").hide();
        }
        $("input[name='qrykind']:checked").triggerHandler("click");//統計依據
    });

    //統計依據
    $("input[name='qrykind']").click(function () {
        if($("input[name='qryprint']:checked").val()=="D"){//明細表
            $("#tr_class").hide();
        }else{
            $("#tr_class").show();
        }
        if($(this).val()=="month"){//統計依據-月份
            $("#tr_month").show();
            $("#tr_date").hide();
        }else{
            $("#tr_month").hide();
            $("#tr_date").show();
        }
    });

    $("#qryBSeq").blur(function (e) {
        if (chkNum1($(this)[0], "區所案件編號")) return false;

        if($("input[name='qryBranch']:checked").val()==""){
            alert("請輸入區所別!");
            $("input[name='qryBranch']").eq(0).focus();
        }
    });

    //統計類別全選
    $("#qryPClassA").click(function () {
        $("input[name='qryPClass']").prop("checked",$(this).prop("checked"));
    });

    $("#qrysMonth,#qryeMonth").blur(function (e) {
        if (chkNum1($(this)[0], "月份")) return false;
        if(parseInt($("#qrysMonth").val())<1||parseInt($("#qrysMonth").val())>12){
            alert("月份請輸入介於1~12的數字!");
            $(this).focus();
            return false;
        }
    });

    $("#qrysDATE,#qryeDATE").blur(function (e) {
        ChkDate($(this)[0]);
    });
</script>
