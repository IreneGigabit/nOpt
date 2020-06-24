<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Linq" %>
<%@ Register Src="~/commonForm/chkTest.ascx" TagPrefix="uc1" TagName="chkTest" %>


<script runat="server">
    protected string HTProgCap = "系統資料";//HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "Syscode";//HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;
    protected string Title = "";

    protected string submitTask = "";

    protected string ULock = "false";

    protected string SQL = "";
    protected Dictionary<string, object> RS = new Dictionary<string, object>();

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        submitTask = Request["submitTask"] ?? "";

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        Title = myToken.Title;
        chkTest.HTProgRight = HTProgRight;
        if (HTProgRight >= 0) {
            PageLayout();
            this.DataBind();
        }
    }

    private void PageLayout() {
        //欄位開關
        if (submitTask=="A") {
        }else if (submitTask=="U") {
            ULock = "true";
        }

        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            //SQL = "SELECT * FROM law_detail ";
            //SQL += " where law_sqlno='" + law_sqlno + "'";
            //DataTable dt = new DataTable();
            //conn.DataTable(SQL, dt);
            //RS = dt.ToDictionary().FirstOrDefault() ?? new Dictionary<string, object>();
        }
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
        <td class="text9" nowrap="nowrap">&nbsp;【<%=prgid%><%=Title%>】<span style="color:blue"><%=HTProgCap%></span>新增作業</td>
        </td>
        <td class="FormLink" valign="top" align="right" nowrap="nowrap">
            <a class="imgCls" href="javascript:void(0);" >[查詢]</a>
        </td>
    </tr>
    <tr>
        <td colspan="2"><hr class="style-one"/></td>
    </tr>
</table>
<br>
<form id="reg" name="reg" method="post">
	<input type="hidden" id="submittask" name="submittask" value="<%=submitTask%>">
	<input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">

    <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="80%" align="center">	
		<TR>
		  <TD class=lightbluetable align=right>網路作業代碼：</TD>
		  <TD class=whitetablebg><INPUT TYPE=text id=pfx_syscode NAME=pfx_syscode SIZE=10 MAXLENGTH=10 class="ULock"></TD>
		</TR>
		<TR>
		  <TD class=lightbluetable align=right>網路作業名稱(中)：</TD>
		  <TD class=whitetablebg><INPUT TYPE=text id=tfx_sysnameC NAME=tfx_sysnameC SIZE=30 MAXLENGTH=30></TD>
		</TR>
		<TR>
		  <TD class=lightbluetable align=right>網路作業名稱(英)：</TD>
		  <TD class=whitetablebg><INPUT TYPE=text id=tfx_sysnameE NAME=tfx_sysnameE SIZE=30 MAXLENGTH=50></TD>
		</TR>
		<TR>
		  <TD class=lightbluetable align=right>伺服器名稱：</TD>
		  <TD class=whitetablebg><INPUT TYPE=text id=tfx_sysserver NAME=tfx_sysserver SIZE=10 MAXLENGTH=10></TD>
		</TR>
		<TR>
		  <TD class=lightbluetable align=right>路徑：</TD>
		  <TD class=whitetablebg><INPUT TYPE=text id=tfx_syspath NAME=tfx_syspath SIZE=40 MAXLENGTH=40></TD>
		</TR>
		<TR>
		  <TD class=lightbluetable align=right>區所別：</TD>
		  <TD class=whitetablebg>
		  <SELECT id=tfx_DataBranch NAME=tfx_DataBranch></select>
		  </TD>
		</TR>
		<TR>
		  <TD class=lightbluetable align=right>分類代碼：</TD>
		  <TD class=whitetablebg>
		  <SELECT id=tfx_ClassCode NAME=tfx_ClassCode></SELECT>
		  <input type=button value="新增" onclick="newopen()" class=cbutton >
		  <input type=button value="重新整理"  class=cbutton id=button1 name=button1 onclick="getname()">
		  </TD>
		</TR>
		<TR>
		  <TD class=lightbluetable align=right>系統順序：</TD>
		  <TD class=whitetablebg><INPUT TYPE=text id=tfx_syssql NAME=tfx_syssql SIZE=2 MAXLENGTH=2></TD>
		</TR>
		<TR>
		  <TD class=lightbluetable align=right>協調人員：</TD>
		  <TD class=whitetablebg><INPUT TYPE=text id=tfx_corp_user NAME=tfx_corp_user SIZE=15 MAXLENGTH=30></TD>
		</TR>
		<TR>
		  <TD class=lightbluetable align=right>開發人員：</TD>
		  <TD class=whitetablebg><INPUT TYPE=text id=tfx_main_user NAME=tfx_main_user SIZE=15 MAXLENGTH=30></TD>
		</TR>
		<TR>
		  <TD class=lightbluetable align=right>使用人員：</TD>
		  <TD class=whitetablebg><INPUT TYPE=text id=tfx_sys_user NAME=tfx_sys_user SIZE=30 MAXLENGTH=60></TD>
		</TR>
		<TR>
		  <TD class=lightbluetable align=right>上線日期：</TD>
		  <TD class=whitetablebg><INPUT TYPE=text id=dfx_online_date NAME=dfx_online_date SIZE=10 class="dateField"></TD>
		</TR>
		<TR>
		  <TD class=lightbluetable align=right>開始日期：</TD>
		  <TD class=whitetablebg><INPUT TYPE=text id=dfx_beg_date NAME=dfx_beg_date SIZE=10 class="dateField"></TD>
		</TR>
		<TR>
		  <TD class=lightbluetable align=right>結束日期：</TD>
		  <TD class=whitetablebg><INPUT TYPE=text id=dfx_end_date NAME=dfx_end_date SIZE=10 class="dateField"></TD>
		</TR>
		<TR>
		  <TD class=lightbluetable align=right>系統說明：</TD>
		  <TD class=whitetablebg><textarea id=tfx_sysremark NAME=tfx_sysremark rows=6 cols=70></textarea></TD>
		</TR>
		<TR>
		  <TD class=lightbluetable align=right>備註：</TD>
		  <TD class=whitetablebg><INPUT TYPE=text id=tfx_mark NAME=tfx_mark SIZE=1 MAXLENGTH=1></TD>
		</TR>
    </TABLE>

    <!--label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label-->
    <uc1:chkTest runat="server" ID="chkTest" />
</form>

<table border="0" width="98%" cellspacing="0" cellpadding="0" >
<tr id="tr_button1">
    <td align="center">
        <input type=button value="新　增/修　改" class="cbutton" id="btnSubmit">
        <input type=button value="停  用" class="cbutton" id="btnDel">
        <input type=button value="重　填" class="cbutton" id="btnReset">
    </td>
</tr>
</table>

<iframe id="ActFrame" name="ActFrame" src="about:blank" width="100%" height="500" style="display:none"></iframe>
</body>
</html>

<script language="javascript" type="text/javascript">
    $(function () {
        $("#tfx_DataBranch").getOption({//區所別
            url: getRootPath() + "/ajax/JsonGetSqlDataCnn.aspx",
            data: { mg: "Y", sql: "select branch,branchname from branch_code order by branch" },
            valueFormat: "{branch}",
            textFormat: "{branch}_{branchname}"
        });

        getname();//分類代碼重新整理

        //$("#chkTest").click(function (e) {
        //    $("#ActFrame").showFor($(this).prop("checked"));
        //});

        this_init();
    });

    //初始化
    function this_init() {
        //$("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",false).triggerHandler("click");//☑測試
        $("input.dateField").datepick();
        //欄位控制
        $(".Lock").lock();
        $(".ULock").lock(<%#ULock%>);

        $("#btnSubmit,#btnDel,#btnReset").hide();

        if($("#submittask").val()=="Add"){
            if (window.parent.tt !== undefined) {
                window.parent.tt.rows = "0%,100%";
            }
            $("#tr_end_date").hide();
            $("#btnSubmit,#btnReset").show();
            $("#btnSubmit").val("新　增");
        }else if($("#submittask").val()=="U"){
            if (window.parent.tt !== undefined) {
                window.parent.tt.rows = "50%,50%";
            }
            $("#tr_end_date").hide();
            $("#btnSubmit,#btnReset").show();
            $("#btnSubmit").val("修　改");

            $("#edit_law_type").val("<%#RS.TryGet("law_type","")%>");
            $("#edit_law_no1").val("<%#RS.TryGet("law_no1","")%>");
            $("#edit_law_no2").val("<%#RS.TryGet("law_no2","")%>");
            $("#edit_law_no3").val("<%#RS.TryGet("law_no3","")%>");
            $("#O_edit_law_mark").val("<%#RS.TryGet("law_mark","").ToString().Trim()%>");
            $("#edit_law_mark").val("<%#RS.TryGet("law_mark","")%>");
            $("#edit_end_date").val("<%#Util.parseDBDate(RS.TryGet("end_mark","").ToString(),"yyyy/M/d")%>");
        }else if($("#submittask").val()=="D"){
            if (window.parent.tt !== undefined) {
                window.parent.tt.rows = "50%,50%";
            }
            $("#btnDel,#btnReset").show();

            $("#edit_law_type").val("<%#RS.TryGet("law_type","")%>");
            $("#edit_law_no1").val("<%#RS.TryGet("law_no1","")%>");
            $("#edit_law_no2").val("<%#RS.TryGet("law_no2","")%>");
            $("#edit_law_no3").val("<%#RS.TryGet("law_no3","")%>");
            $("#edit_law_mark").val("<%#RS.TryGet("law_mark","")%>");
            $("#edit_end_date").val((new Date()).format("yyyy/M/d"));
        }
    }

    //關閉視窗
    $(".imgCls").click(function (e) {
        if (window.parent.tt !== undefined) {
            window.parent.tt.rows = "100%,0%";
        } else {
            window.close();
        }
    })

    //新增/修改
    $("#btnSubmit").click(function () {
        if ($("#pfx_syscode").val() == "") {
            alert("請務必填寫「網路作業代碼」，不得為空白！");
            $("#pfx_syscode").focus();
            return false;
        }
        if ($("#tfx_sysnameC").val() == "") {
            alert("請務必填寫「網路作業名稱」，不得為空白！");
            $("#tfx_sysnameC").focus();
            return false;
        }
        if ($("#tfx_sysserver").val() == "") {
            alert("請務必填寫「伺服器名稱」，不得為空白！");
            $("#tfx_sysserver").focus();
            return false;
        }
        if ($("#tfx_syspath").val() == "") {
            alert("請務必填寫「路徑」，不得為空白！");
            $("#tfx_syspath").focus();
            return false;
        }
        if ($("#tfx_syspath").val().left(1) != "/") {
            alert("「路徑」輸入錯誤，請重新輸入！");
            $("#tfx_syspath").focus();
            return false;
        }

        $("select,textarea,input").unlock();
        $("#btnSubmit,#btnDel,#btnReset").lock(!$("#chkTest").prop("checked"));
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.target = "ActFrame";
        reg.submit();
    });

    //重置
    $("#btnReset").click(function () {
        reg.reset();
        this_init();
    });

    //分類代碼新增
    function newopen() {
        window.open("DataBranch_ADD.aspx?prgid=" + $("#prgid").val());
    }

    //分類代碼重新整理
    function getname() {
        $("#tfx_ClassCode").getOption({
            url: getRootPath() + "/ajax/JsonGetSqlDataCnn.aspx",
            data: { mg: "Y", sql: "select classcode,classnameC from sysclass where sysclass = 'system' order by classcode" },
            valueFormat: "{classcode}",
            textFormat: "{classcode}_{classnameC}"
        });
    }
</script>
