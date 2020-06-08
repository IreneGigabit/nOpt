<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Collections.Generic"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opt42";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string cgrs = "GS";
    protected string step_date = "";
    protected string rs_no = "";
    protected string emg_scode = "";
    protected string emg_agscode = "";
    
    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        step_date = (Request["step_date"] ?? "").Trim();
        rs_no = (Request["rs_no"] ?? "").Trim();
        emg_scode = Funcs.GetRoleScode(Sys.GetSession("syscode"), Sys.GetSession("dept"), "mg_pror");//總管處程序人員-正本
        emg_agscode = Funcs.GetRoleScode(Sys.GetSession("syscode"), Sys.GetSession("dept"), "mg_prorm");//總管處程序人員-副本

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
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.Snoopy.date.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/client_chk.js")%>"></script>
</head>

<body>
<table cellspacing="1" cellpadding="0" width="98%" border="0" align="center">
    <tr>
        <td class="text9" nowrap="nowrap">&nbsp;【<%#prgid%> <%#HTProgCap%>‧<b style="color:Red">未發文清單</b>】</td>
        <td class="FormLink" valign="top" align="right" nowrap="nowrap">
		    <a class="imgRefresh" href="javascript:void(0);" >[重新整理]</a>
        </td>
    </tr>
    <tr>
        <td colspan="2"><hr class="style-one"/></td>
    </tr>
</table>

<form id="reg" name="reg" method="post" action="">
    <input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">
    <input type="hidden" id="cgrs" name="cgrs" value="<%=cgrs%>">
    <input type="hidden" id="haveword" name="haveword">
    <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="90%" align="center">	
	    <tr>
		    <TD class=lightbluetable align=right>報表種類：</TD>
		    <TD class=whitetablebg align=left colspan=3>
			    <input type="hidden" id=prtkind name=prtkind>
                <span id="spanRprtKind"></span>
		    </td>
	    </tr>
	    <tr id="tr_send_dept">
		    <td class="lightbluetable" align="right">發文單位：</td>
		    <td class="whitetablebg" align="left" colspan=3>
			    <input type="radio" value="B" name="Send_dept">自行發文
			    <input type="radio" value="L" name="Send_dept">轉法律處發文
			    <input type="radio" value="" name="Send_dept">全部
		        <input type="hidden" id=qrySend_dept name=qrySend_dept>
		    </td>
	    </tr>
	    <tr id="tr_send_way">
		    <td class="lightbluetable" align="right">發文方式：</td>
		    <td class="whitetablebg" align="left" colspan=3>
			    <input type="hidden" id="hsend_way" name="hsend_way" value="">
			    <input type="radio" name="send_way" id="send_wayM" value="M"><label for="send_wayM">非電子送件</label>
			    <input type="radio" name="send_way" id="send_wayE" value="E"><label for="send_wayE">電子送件</label>
			    <span id="span_Email_msg" style="display:none"><font color=darkred>【請先點「列印」產生各項報表檔案，再點Email通知總管處(電子送件)】</font></span>
			    <input type="radio" name="send_way" id="send_wayAll" value=""><label for="send_wayAll">全部</label>
		    </td>
	    </tr>
	    <tr id="tr_date">
		    <td class="lightbluetable" align="right">發文日期：</td>
		    <td class="whitetablebg" align="left" colspan=3>
			    <input type="text" id="sdate" name="sdate" size="10" maxlength=10 class="dateField">
			    <input type="text" id="edate" name="edate" size="10" maxlength=10 class="dateField">
		    </td>
	    </tr>
	    <tr id="tr_rs_no">
		    <td class="lightbluetable" align="right">發文字號：</td>
		    <td class="whitetablebg" align="left" colspan=3>
			    <input type="text" id="srs_no" name="srs_no" size="11" maxlength=10>～
			    <input type="text" id="ers_no" name="ers_no" size="11" maxlength=10>
			    <input type="hidden" id="rs_count" name="rs_count">
		    </td>
	    </tr>
	    <tr>
		    <td class="lightbluetable" align="right">區所案件編號：</td>
		    <td class="whitetablebg" align="left">
			    <Select name="qryBranch" id="qryBranch" ></Select>
			    <input type="text" id="sseq" name="sseq" size="6" maxlength=6>～
			    <input type="text" id="eseq" name="eseq" size="6" maxlength=6>
		    </td>
		    <td class="lightbluetable" align="right">客戶編號：</td>
		    <td class="whitetablebg" align="left">
			    <Select name="cust_area" id="cust_area"></Select>
			    <input type="text" id="scust_seq" name="scust_seq" size="6" maxlength=6>～
			    <input type="text" id="ecust_seq" name="ecust_seq" size="6" maxlength=6>
		    </td>
	    </tr>
    </table>

    <br>
    <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>
    <table id="btnTable" border="0" width="98%" cellspacing="0" cellpadding="0" align="center">
	    <tr>
        <td align="center">
			<input type="button" value="列　印" class="cbutton" id="btnSubmit" name="btnSubmit">
			<span id="span_gs_email" style="display:none">
			    <br><br>
			    發文日期：<input type="text" id="gs_date" name="gs_date" size="10" maxlength=10 class="dateField">
			    <input onClick="formEmail()" id="buttonE" name="buttonE" type="button" value="官方發文Email通知總管處(電子送件)" class="cbutton">
			</span>

			<input type="button" value="重　填" class="cbutton" id="btnReset" name="btnReset">
	    </td>
	    </tr>
    </table>

    </form>

    <iframe id="ActFrame" name="ActFrame" src="about:blank" width="100%" height="500" style="display:none"></iframe>
</body>
</html>


<script language="javascript" type="text/javascript">
    $(function () {
        $("#spanRprtKind").getRadio({//報表種類
            url: getRootPath() + "/ajax/JsonGetSqlData.aspx",
            data:{sql:"select cust_code,code_name,mark1 from cust_code where code_type='rpt_GS_t' and cust_code<>'423' order by sortfld"},
            objName: "rprtkind",
            valueFormat: "{cust_code}",
            textFormat: "{code_name}",
            attrFormat: " onclick=\"rprtkind_click('{cust_code}','{mark1}')\"",
            mod:3
        });

        $("#qryBranch,#cust_area").getOption({//區所別
            url: getRootPath() + "/ajax/JsonGetSqlDataCnn.aspx",
            data:{sql:"select branch,branchname from branch_code where mark='Y' and branch<>'J' order by sort"},
            valueFormat: "{branch}",
            textFormat: "{branch}_{branchname}"
        });

        $("input.dateField").datepick();
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",false).triggerHandler("click");//☑測試
        $("#chkTest").click(function (e) {
            $("#ActFrame").showFor($(this).prop("checked"));
        });
       
        $("#btnTable").showFor((<%#HTProgRight%> & 32)); //列印/重填

        this_init();
    });

    function this_init(){
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "100%,0%";
        }
        $("#sdate").val((new Date()).format("yyyy/M/d"));
        $("#edate").val((new Date()).format("yyyy/M/d"));
        $("#gs_date").val($("#edate").val());
        getRsNo();
        $("input[name='Send_dept'][value='']").prop("checked",true).triggerHandler("click");//發文單位:全部
    }

    ///////////////////////////////////////////////
    //報表種類
    function rprtkind_click(prtkind,pword){
        $("#prtkind").val(prtkind);
        $("#haveword").val(pword);

        if($("#sdate").val()=="") $("#sdate").val((new Date()).format("yyyy/M/d"));
        if($("#edate").val()=="") $("#edate").val((new Date()).format("yyyy/M/d"));
    }

    //發文單位
    $("input[name='Send_dept']").click(function () { 
        $("#qrySend_dept").val($(this).val());
        getRsNo();
    });

    //發文方式
    $("input[name='send_way']").click(function () {
        $("#hsend_way").val($(this).val());
        if($("#hsend_way").val()=="E"||$("#hsend_way").val()=="EA"){
            $("#span_Email_msg,#span_gs_email").show();
        }else{
            $("#span_Email_msg,#span_gs_email").hide();
        }$("#span_Email_msg,#span_gs_email").show();
        getRsNo();
    });

    //抓發文字號
    function getRsNo(){
        $.ajax({
            type: "get",
            url: getRootPath() + "/ajax/json_rs_no.aspx",
            data: { cgrs: $("#cgrs").val(), sdate: $("#sdate").val(), edate: $("#edate").val(), send_dept: $("#qrySend_dept").val() },
            async: false,
            cache: false,
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                if (JSONdata.length == 0) {
                    $("#srs_no").val("");
                    $("#ers_no").val("");
                    $("#rs_count").val("0");
                } else {
                    $("#srs_no").val(JSONdata[0].minrs_no);
                    $("#ers_no").val(JSONdata[0].maxrs_no);
                    $("#rs_count").val(JSONdata[0].cc);
                }
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>發文字號載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });
    }

    $("#sdate").blur(function (e) {
        getRsNo();
    });
    $("#edate").blur(function (e) {
        $("#gs_date").val($("#edate").val());
        getRsNo();
    });

    $("#sseq").blur(function (e) {
        chkNum1($(this)[0], "區所案件編號");
    });
    $("#eseq").blur(function (e) {
        chkNum1($(this)[0], "區所案件編號");
    });

    $("#scust_seq").blur(function (e) {
        chkNum1($(this)[0], "客戶編號");
    });
    $("#ecust_seq").blur(function (e) {
        chkNum1($(this)[0], "客戶編號");
    });

    $("#qryBranch").change(function (e) {
        if($(this).val()!=$("#cust_area").val()){
            $("#cust_area").val($(this).val());
        }
    });
    $("#cust_area").change(function (e) {
        if($(this).val()!=$("#qryBranch").val()){
            $("#qryBranch").val($(this).val());
        }
    });

    //列印
    $("#btnSubmit").click(function (e) {
        if ($("#prtkind").val()==""){
            alert("報表種類必須選擇!!!");
            return false;
        }
        if ($("#cgrs").val()=="GS"){
            if (!chkRadio("send_way","發文方式"))return false;
        }
        if ($("#srs_no").val()=="" && $("#ers_no").val()==""){
            getRsNo();
        }
        if ($("#srs_no").val()!="" && $("#ers_no").val()!=""){
            if ($("#srs_no").val()>$("#srs_no").val()){
                alert("起始發文字號不可大於終止發文字號!!!");
                return false;
            }
        }
        if (chkNum($("#sseq").val(),"本所編號起始號")) return false;
        if (chkNum($("#eseq").val(),"本所編號迄止號")) return false;
        if ($("#sseq").val()!="" && $("#eseq").val()!=""){
            if (parseInt($("#sseq").val(), 10)>parseInt($("#eseq").val(), 10)){
                alert("起始發文字號不可大於終止發文字號!!!");
                return false;
            }
        }
        if (chkNum($("#scust_seq").val(),"客戶編號起始號")) return false;
        if (chkNum($("#ecust_seq").val(),"客戶編號迄止號")) return false;
        if ($("#scust_seq").val()!="" && $("#ecust_seq").val()!=""){
            if (parseInt($("#scust_seq").val(), 10)>parseInt($("#ecust_seq").val(), 10)){
                alert("起始客戶編號不可大於終止客戶編號!!!");
                return false;
            }
        }

        //421:官方發文明細、422:官方發文規費明細、423:官發收入明細、424:官方發文回條
        if($("#haveword").val()=="Y"){
            reg.target = "ActFrame";
            reg.action = "opt" + $("#prtkind").val() + "Print.aspx";
            reg.submit();
        }else{
            //var url="opt"  + $("#prtkind").val() + "Print.asp?sdate="&reg.sdate.value&"&edate="&reg.edate.value&"&srs_no="&reg.srs_no.value&"&ers_no="&reg.ers_no.value&"&sseq="&reg.sseq.value&"&eseq="&reg.eseq.value&"&scust_seq="&reg.scust_seq.value&"&ecust_seq="&reg.ecust_seq.value&"&sctrl_date="&reg.sctrl_date.value&"&ectrl_date="&reg.ectrl_date.value&"&qrysend_dept="&reg.qrysend_dept.value;
            var url="opt"  + $("#prtkind").val() + "Print.aspx";
            if($("#hsend_way").val()=="E"||$("#hsend_way").val()=="EA")
                url="opt"  + $("#prtkind").val() + "Print_word.aspx";
            url+="?"+$("#reg").serialize();
            window.open(url,"myWindowOne1", "width=750px, height=550px, top=10, left=10, toolbar=no, menubar=no, location=no, directories=no, status=no, scrollbars=yes,titlebar=no");
        }
    });

    //重填
    $("#btnReset").click(function (e) {
        reg.reset();
        this_init();
    });
    
    function formEmail(){
        <%
        string tsubject = "";//主旨
        string strto = "";//收件者
        string strcc = "";//副本
        string strbcc = "";//密件副本
        string Sender=Sys.GetSession("scode");//寄件者
        if (Sys.Host=="web08") {
            strto = "m802;m1583;";
            strcc="";
            strbcc = "";
            tsubject = "測試-";
        } else if (Sys.Host == "web10") {
            strto = Sys.GetSession("scode") + ";";
            strcc = "";
            strbcc = "m1583;";
            tsubject = "測試-";
        } else {
            strto = emg_scode + ";";
            strcc = emg_agscode + ";";//2016/4/19修改
            strbcc = "m1583;";
        }
        tsubject += "國內商標爭救案件管理網路作業系統─每日官發發文明細通知";
        %>
        var tsubject="<%=tsubject%>";//主旨
        var strto = "<%=strto%>";//收件者
        var strcc = "<%=strcc%>";//副本
        var strbcc = "<%=strbcc%>";//密件副本
        var host=window.location.hostname;

        //511:官方發文明細、512:官方發文規費明細、514:官方發文回條 是否已產生
        //GSE-514T-20120106.doc、GSE-511T-20120106.doc、GSE-512T-20120106.doc
        var attach_path = "reportword/";
        var tdate=(new Date($("#gs_date").val())).format("yyyyMMdd");

        var attach_name = "GS"+$("#hsend_way").val()+"-514T-"+tdate+".docx,GS"+$("#hsend_way").val()+"-511T-"+tdate+".docx,GS"+$("#hsend_way").val()+"-512T-"+tdate+".docx";
        var arug = "cgrs="+$("#cgrs").val()+"&attach_path="+ attach_path +"&attach_name="+ attach_name;
        arug +="&msg="+escape("官方發文回條,官方發文明細,官方發文規費明細");

        var rtnmsg="";
        //檢查檔案是否存在
        $.ajax({
            type: "get",
            url: getRootPath() + "/ajax/json_chkFile.aspx?"+arug,
            async: false,
            cache: false,
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                $.each(JSONdata, function (i, item) {
                    if(item.msg!="") rtnmsg+=item.msg+"\n\n";
                });
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>檔案檢查失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });
        if(rtnmsg!="")alert(rtnmsg);

        //Mail To 總收發文
        if ($("#hsend_way").val()=="E"){
            tsubject+= "【電子送件】";
        }else if ($("#hsend_way").val()=="EA"){
            tsubject+="【註冊費電子送件】";
        }

        var tbody = "致：總管處-總務部-程序組";
        tbody += "%0A";
        tbody += "%0A【通 知 日 期】："+(new Date()).format("yyyy/M/d");
        tbody += "%0A【發 文 日 期】："+$("#gs_date").val();
        tbody += "%0A";
        tbody += "%0A◎請至總收發網路系統→商標收發文→商標區所發文送件確認作業。";
        tbody += "%0A";
        tbody += "%0A附件如下：";
        tbody += "%0A%0A官方發文明細 http://"+host+"/nopt/reportword/GS"+$("#hsend_way").val()+"-511T-"+tdate+".docx";
        if(rtnmsg.indexOf("官方發文明細檔案尚未產生")>-1){
            tbody += " (本次發文未產生) ";
        }
        tbody += "%0A%0A官方發文規費明細 http://"+host+"/nopt/reportword/GS"+$("#hsend_way").val()+"-512T-"+tdate+".docx";
        if(rtnmsg.indexOf("官方發文規費明細檔案尚未產生")>-1){
            tbody += " (本次發文未產生) ";
        }
        tbody+= "%0A%0A官方發文回條 http://"+host+"/nopt/reportword/GS"+$("#hsend_way").val()+"-514T-"+tdate+".docx";
        if(rtnmsg.indexOf("官方發文回條檔案尚未產生")>-1){
            tbody += " (本次發文未產生) ";
        }

        ActFrame.location.href= "mailto:"+ strto +"?subject="+tsubject+"&body="+tbody+ "&cc=" + strcc;//+"&bcc="+ strbcc;
    }
</script>
