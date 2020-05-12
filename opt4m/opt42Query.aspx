<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data" %>
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
    
    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        step_date = (Request["step_date"] ?? "").Trim();
        rs_no = (Request["rs_no"] ?? "").Trim();

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            QueryPageLayout();
            this.DataBind();
        }
    }
    
    private void QueryPageLayout() {
        SetRprtKind();//報表種類
    }
    
    private void SetRprtKind(){
        DataTable dtRprtKind = new DataTable();
        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(false)) {
            string SQL = "select cust_code,code_name,mark1 from cust_code where code_type='rpt_GS_t' and cust_code<>'423' order by sortfld";
            conn.DataTable(SQL, dtRprtKind);
        }
        rprtRepeater.DataSource = dtRprtKind;
        rprtRepeater.DataBind();
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
    <input type="text" id="prgid" name="prgid" value="<%=prgid%>">
    <input type="text" id="cgrs" name="cgrs" value="<%=cgrs%>">
    <input type="text" id="haveword" name="haveword">
    <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="90%" align="center">	
	    <tr>
		    <TD class=lightbluetable align=right>報表種類：</TD>
		    <TD class=whitetablebg align=left colspan=3>
			    <input type="text" id=prtkind name=prtkind>
                <asp:Repeater id="rprtRepeater" runat="server">
			    <ItemTemplate>
                    <label><input type=radio name="rprtkind" value="<%#Eval("cust_code")%>" onclick="rprtkind_click('<%#Eval("cust_code")%>','<%#Eval("mark1")%>')"><%#Eval("code_name")%>&nbsp;</label>
                    <%#((Container.ItemIndex+1)%3)==0 ? "<br>":""%>
			    </ItemTemplate>
			    </asp:Repeater>
		    </td>
	    </tr>
	    <tr id="tr_send_dept">
		    <td class="lightbluetable" align="right">發文單位：</td>
		    <td class="whitetablebg" align="left" colspan=3>
			    <input type="radio" value="B" name="Send_dept">自行發文
			    <input type="radio" value="L" name="Send_dept">轉法律處發文
			    <input type="radio" value="" name="Send_dept">全部
		        <input type="text" id=qrySend_dept name=qrySend_dept>
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
        $("#qryBranch,#cust_area").getOption({//區所別
            url: getRootPath() + "/json/_GetSqlDataCnn.aspx",
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
        $("#sdate").val((new Date()).format("yyyy/M/d"));
        $("#edate").val((new Date()).format("yyyy/M/d"));
        getRsNo();
        $("input[name='Send_dept'][value='']").prop("checked",true).triggerHandler("click");//發文單位:全部
    }

    ///////////////////////////////////////////////
    //報表種類
    function rprtkind_click(prtkind,pword){
        $("#prtkind").val(prtkind);
        $("#haveword").val(pword);
        $("#sdate").val((new Date()).format("yyyy/M/d"));
        $("#edate").val((new Date()).format("yyyy/M/d"));
    }

    //發文單位
    $("input[name='Send_dept']").click(function () { 
        $("#qrySend_dept").val($(this).val());
        getRsNo();
    });

    //抓發文字號
    function getRsNo(){
        $.ajax({
            type: "get",
            url: getRootPath() + "/json/rs_no.aspx",
            data: { cgrs: $("#cgrs").val(), sdate: $("#sdate").val(), edate: $("#edate").val(), send_dept: $("#qrySend_dept").val() },
            async: false,
            cache: false,
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                if (JSONdata.length == 0) {
                    $("#srs_no").val("");
                    $("#ers_no").val("");
                } else {
                    $("#srs_no").val(JSONdata[0].minrs_no);
                    $("#ers_no").val(JSONdata[0].maxrs_no);
                }
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>發文字號載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });
    }

    $("#sdate,#edate").blur(function (e) {
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

        if($("#haveword").val()=="Y"){
            reg.target = "ActFrame";
        }else{
            reg.target = "_Blank";
        }
        //421:官方發文明細、422:官方發文規費明細、423:官發收入明細、424:官方發文回條
        reg.action = "opt" + $("#prtkind").val() + "Print.aspx";
        reg.submit();
    });

    //重填
    $("#btnReset").click(function (e) {
        reg.reset();
        this_init();
    });

    //契約書後補通知區所mail簽核
    function tobrbutton_email(nRow,fseq,case_no,last_date,appl_name,gs_date,opt_sqlno,branch){
        var StrToList=$("#mailto"+nRow).val();
        var CCtoList=$("#mailcc"+nRow).val();
	
        var tsubject = "國內所爭救案系統－官發待契約書後補通知（區所編號： " + fseq + " ）";
	
        var tbody = "致: 國內所 程序、承辦" + "%0A%0A";
        tbody += "【通 知 日 期 】: "+(new Date()).format("yyyy/M/d");
        tbody += "%0A【區所編號】:" + fseq + "，交辦單號："+ case_no +"，法定期限："+ last_date+ "，預計發文日期："+ gs_date  ;
        tbody += "%0A【案件名稱】:" + appl_name;
        tbody += "%0A 請儘速後補契約書，以俾爭議組發文，如無法及時完成後補，請進行mail簽核作業，經主管同意後由資訊部開放可先官發。";
	
        
        ActFrame.location.href= "mailto:"+ StrToList +"?subject="+tsubject+"&cc= "+CCtoList+"&body="+tbody;
    }
</script>
