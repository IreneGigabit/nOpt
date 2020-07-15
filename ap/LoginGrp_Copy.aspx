<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Linq" %>

<script runat="server">
    protected string HTProgCap = "複製權限群組";//HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "LoginGrp";//HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;
    protected string DebugStr = "";
    protected string Title = "";
    protected string StrFormBtn = "";

    protected string submitTask = "";
    protected string syscode = "";
    protected string LoginGrp = "";

    protected string ULock = "false";

    protected string SQL = "";
    protected Dictionary<string, object> RS = new Dictionary<string, object>();

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        submitTask = Request["submitTask"] ?? "";
        syscode = Request["syscode"] ?? "";
        LoginGrp = Request["LoginGrp"] ?? "";

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        Title = myToken.Title;
        DebugStr = myToken.DebugStr;
        if (HTProgRight >= 0) {
            PageLayout();
            QueryData();
            this.DataBind();
        }
    }

    private void PageLayout() {
        //欄位開關
        if (submitTask == "A") {
        } else if (submitTask == "U") {
            ULock = "true";
        }

        using (DBHelper conn = new DBHelper(Conn.ODBCDSN, false)) {
            SQL = "SELECT * FROM LoginGrp WHERE SYScode='" + syscode + "' And LoginGrp = '" + LoginGrp + "'";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);
            RS = dt.ToDictionary().FirstOrDefault() ?? new Dictionary<string, object>();
        }

        if ((HTProgRight & 4) > 0) {
            StrFormBtn += "<input type=button value=\"複製存檔\" class=\"cbutton\" id=\"btnSubmit\">\n";
            StrFormBtn += "<input type=button value=\"重　填\" class=\"cbutton\" id=\"btnReset\">\n";
        }
    }
    
    private void QueryData() {
        using (DBHelper cnn = new DBHelper(Conn.ODBCDSN, false).Debug(Request["chkTest"] == "TEST")) {
            SQL = "SELECT * ";
            SQL += "FROM logingrp A ";
            SQL += "WHERE a.syscode = '" + syscode + "' ";
            SQL += " order by A.LoginGrp";
            DataTable dt = new DataTable();
            cnn.DataTable(SQL, dt);

            dataRepeater.DataSource = dt;
            dataRepeater.DataBind();
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
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.Snoopy.date.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/client_chk.js")%>"></script>
</head>
<body>
<table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td class="text9" nowrap="nowrap">&nbsp;【<%=prgid%><%=Title%>】<span style="color:blue"><%=HTProgCap%></span>
        </td>
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
	<input type="hidden" id="submittask" name="submittask" value="<%=submitTask%>">
	<input type="hidden" id="task" name="task" value="">
	<input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">
	<input type="hidden" id="syscode" name="syscode" value="<%=syscode%>">
	<input type="hidden" id="LoginGrp" name="LoginGrp" value="<%=LoginGrp%>">

    <table align="center" border="0" cellspacing="1" cellpadding="3" width="40%" class="bluetable">
        <tr>    
            <td align="center" class="lightbluetable" width="30%">權限來源</td>
            <td class="whitetablebg">
                <Select id=tfx_source name=tfx_source></Select>
            </td>
        </tr>
    </table>

    <asp:Repeater id="dataRepeater" runat="server">
<HeaderTemplate>
    <table style="display:<%#page.totRow==0?"none":""%>" border="0" class="bluetable" cellspacing="1" cellpadding="2" width="98%" align="center" id="dataList">
	    <thead>
            <Tr>
	            <td align=center class=lightbluetable>群組代碼</td>
	            <td align=center class=lightbluetable>群組名稱</td>
	            <td align=center class=lightbluetable>備註說明</td>
	            <td align=center class=lightbluetable>作業</td>	
            </tr>
	    </thead>
	    <tbody>
</HeaderTemplate>
			<ItemTemplate>
 		        <tr class="<%#(Container.ItemIndex+1)%2== 1 ?"sfont9":"lightbluetable3"%>">
                    <TD class=whitetablebg><p align=center><%#Eval("LoginGrp")%></TD>	
                    <TD class=whitetablebg><p align=center><%#Eval("GrpName")%></TD>
                    <TD class=whitetablebg><p align=center><%#Eval("Remark")%></TD>
                    <TD class=whitetablebg><p align=center>
                        <a href="LoginGrp_Edit.aspx?prgid=<%#prgid%>&Syscode=<%#Eval("Syscode")%>&LoginGrp=<%#Eval("LoginGrp")%>&submitTask=U" target="Eblank">[編修群組]</a>
                        <a href="EditLoginGrpAP.aspx?prgid=<%#prgid%>&Syscode=<%#Eval("Syscode")%>&GrpID=<%#Eval("LoginGrp")%>&GrpName=<%#Eval("GrpName")%>" target="Eblank">[編修權限]</a>
                        <a href="sys14_List.aspx?prgid=<%#prgid%>&Syscode=<%#Eval("Syscode")%>&LoginGrp=<%#Eval("LoginGrp")%>">[查詢使用者]</a>
                        <a href="LoginGrp_Copy.aspx?prgid=<%#prgid%>&Syscode=<%#Eval("Syscode")%>&LoginGrp=<%#Eval("LoginGrp")%>" target="Eblank">[權限複製]</a>
                    </TD>
				</tr>
			</ItemTemplate>
<FooterTemplate>
	    </tbody>
    </table>
    <br />
</FooterTemplate>
</asp:Repeater>

    <%#DebugStr%>
</form>

<table border="0" width="98%" cellspacing="0" cellpadding="0" >
<tr id="tr_button1">
    <td align="center">
        <%#StrFormBtn%>
    </td>
</tr>
</table>

<iframe id="ActFrame" name="ActFrame" src="about:blank" width="100%" height="500" style="display:none"></iframe>
</body>
</html>

<script language="javascript" type="text/javascript">
    $(function () {
        if (window.parent.tt !== undefined) {
            window.parent.tt.rows = "0%,100%";
        }

        this_init();
    });

    //初始化
    function this_init() {
        $("input.dateField").datepick();
        //欄位控制
        $(".Lock").lock();
        $(".ULock").lock(<%#ULock%>);

        $("#tfx_source").getOption({//權限來源
            url: getRootPath() + "/ajax/JsonGetSqlDataCnn.aspx",
            data: { mg: "Y", sql: "select LoginGrp,GrpName from logingrp where SYScode = '" + $("#syscode").val() + "' order by LoginGrp" },
            valueFormat: "{LoginGrp}",
            textFormat: "{LoginGrp}_{GrpName}"
        });

        $("#tfx_source").val($("#LoginGrp").val());
    }

    //關閉視窗
    $(".imgCls,#btnClose").click(function (e) {
        if (window.parent.tt !== undefined) {
            if (window.parent.Etop.goSearch !== undefined) {
                window.parent.Etop.goSearch();
            } else {
                window.parent.tt.rows = "100%,0%";
            }
        } else {
            window.close();
        }
    })

    //新增/修改
    $("#btnSubmit").click(function () {
        if ($("#pfx_Syscode").val() == "") {
            alert("請務必填寫「網路作業系統代碼」，不得為空白！");
            $("#pfx_Syscode").focus();
            return false;
        }
        if ($("#pfx_LoginGrp").val() == "") {
            alert("請務必填寫「登錄群組代碼」，不得為空白！");
            $("#pfx_LoginGrp").focus();
            return false;
        }
        if ($("#tfx_GrpName").val() == "") {
            alert("請務必填寫「群組名稱」，不得為空白！");
            $("#tfx_GrpName").focus();
            return false;
        }
        if ($("#tfx_GrpType").val() == "") {
            alert("請務必填寫「群組種類」，不得為空白！");
            $("#tfx_GrpType").focus();
            return false;
        }
        if ($("#dfx_beg_date").val() == "") {
            alert("請務必填寫「有效起始日期」，不得為空白！");
            $("#dfx_beg_date").focus();
            return false;
        }
        ChkDate($("#dfx_beg_date")[0]);
        ChkDate($("#dfx_end_date")[0]);

        if (!chkSEDate($("#dfx_beg_date").val(), $("#dfx_end_date").val(), "有效日期")) {
            $("#dfx_end_date").focus();
            return false;
        }

        $("select,textarea,input,span").unlock();
        $("#btnSubmit,#btnDel,#btnReset").lock(!$("#chkTest").prop("checked"));
        $("#task").val($("#submittask").val());
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.target = "ActFrame";
        reg.submit();
    });

    //刪除
    $("#btnDel").click(function () {
        if (confirm("注意！\n\n　你確定刪除資料嗎？")) {
            $("select,textarea,input,span").unlock();
            $("#btnSubmit,#btnDel,#btnReset").lock(!$("#chkTest").prop("checked"));
            $("#task").val("D");
            reg.action = "<%=HTProgPrefix%>_Update.aspx";
            reg.target = "ActFrame";
            reg.submit();
        }
    });

    //重置
    $("#btnReset").click(function () {
        reg.reset();
        this_init();
    });
</script>
