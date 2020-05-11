<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Linq" %>

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opta11";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string submitTask = "";
    protected string law_sqlno = "";
    protected string qry_law_type = "";
    
    protected string QLock = "true";
    protected string DLock = "true";

    protected string SQL = "";
    protected Dictionary<string, object> RS = new Dictionary<string, object>();
    
    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;
            
        submitTask = Request["submitTask"] ?? "";
        law_sqlno = Request["law_sqlno"] ?? "";

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            PageLayout();
            this.DataBind();
        }
    }

    private void PageLayout() {
        //欄位開關
        if (submitTask=="A") {
            QLock = "false";
            DLock = "false";
        }else if (submitTask=="U") {
            QLock = "true";
            DLock = "false";
        }

        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            qry_law_type = SHtml.Option(conn, "SELECT cust_code,code_name from Cust_code where Code_type = 'law_type' order by sortfld", "{cust_code}", "{cust_code}_{code_name}");

            
            SQL = "SELECT * FROM law_detail ";
            SQL += " where law_sqlno='" + law_sqlno + "'";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);
            RS = dt.ToDictionary().FirstOrDefault();
        }
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
    <input type="text" id="law_sqlno" name="case_no" value="<%=law_sqlno%>">
	<input type="text" id="submittask" name="submittask" value="<%=submitTask%>">
	<input type="text" id="prgid" name="prgid" value="<%=prgid%>">

    <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="70%" align="center">	
	    <tr>
		    <td class="lightbluetable" align="right">法條大項 :</td>
		    <td class="whitetablebg" align="left" colspan="5">
			    <Select name="edit_law_type" class="QLock" ><%#qry_law_type%></Select>
		    </td> 
	    </tr>
	    <tr >
		    <td class=lightbluetable align=right nowrap>條文法規_條：</td>
		    <td class=whitetablebg > 
			    <input type="input" name='edit_law_no1'  value='' size="4" maxLength="4" class="QLock">			
		    </td>
		    <td class=lightbluetable align=right nowrap>條文法規_款：</td>
		    <td class=whitetablebg > 
			    <input type="input" name='edit_law_no2'  value='' size="4" maxLength="4" class="QLock">			
		    </td>
		    <td class=lightbluetable align=right nowrap>條文法規_項：</td>
		    <td class=whitetablebg > 
			    <input type="input" name='edit_law_no3'  value='' size="4" maxLength="4" class="QLock">			
		    </td>
	    </tr>   
	    <tr>		
		    <td class="lightbluetable" align="right">法條內文 :</td>
		    <td class="whitetablebg" align="left" colspan="5">						
			    <input type=hidden name="O_edit_law_mark" value="<%#RS.TryGet("law_mark","").ToString().Trim()%>">
			    <textarea rows=6 cols=120 name="edit_law_mark" class="DLock"></textarea>
		    </td> 
	    </tr>
	    <tr id="tr_end_date">	
		    <td class="lightbluetable" align="right">停用日期 :</td>
		    <td class="whitetablebg" align="left" colspan="5">
			    <input type="text" name="edit_end_date" size="10" maxLength="10" class="dateField" >
		    </td> 
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
        $("#chkTest").click(function (e) {
            $("#ActFrame").showFor($(this).prop("checked"));
        });

        this_init();
    });

    var br_opte = {};
    //初始化
    function this_init() {
        settab("#tran");
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",true).triggerHandler("click");//☑測試
        $("input.dateField").datepick();
        //欄位控制
        $(".Lock").lock();
        $(".QLock").lock(<%#QLock%>);
        $(".DLock").lock(<%#DLock%>);


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
        $("select,textarea,input").unlock();
        $("#btnsearchSubmit,#btnback1Submit,#btnbackSubmit,#btnresetSubmit").lock(!$("#chkTest").prop("checked"));
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

        $("select,textarea,input").unlock();
        $("#btnsearchSubmit,#btnback1Submit,#btnbackSubmit,#btnresetSubmit").lock(!$("#chkTest").prop("checked"));
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
</script>
