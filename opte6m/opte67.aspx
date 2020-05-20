<%@ Page Language="C#" CodePage="65001"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "出口爭救到期案件查詢";//HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opte67";//程式檔名前綴
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

<form id="reg" name="reg" method="post" action="<%#HTProgPrefix%>List.aspx">
    <input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">
    <input type="hidden" id="submittask" name="submittask" value="Q"> 
    <div id="id-div-slide">
        <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="75%" align="center">	
            <tr >
	            <td class=lightbluetable align=right nowrap>交辦來源：</td>
	            <td class=whitetablebg colspan=3> 
	                <label><input type="radio" name='qrybr_source' value='br' >區所交辦</label>
	                &nbsp;<label><input type="radio" name='qrybr_source' value='opte' >新增分案</label>
	                &nbsp;<label><input type="radio" name='qrybr_source' checked value='' >不指定</label>
               </td>
            </tr>  
            <tr >
	            <td class=lightbluetable align=right nowrap>區所別：</td>
	            <td class=whitetablebg colspan=3> 
	                <label><input type="radio" name="qryBranch" value="" checked>全部</label>
                    <span id="spanBranch"></span>
               </td>
            </tr>  
            <tr  id='spKINDDATE'>
	            <td class=lightbluetable align=right nowrap>日期種類：</td>
	            <td class=whitetablebg colspan=3> 
	                <label><input type="radio" name='qryKINDDATE' value='confirm_date'>收文日期</label>
	                &nbsp;<label><input type="radio" name='qryKINDDATE' value='ctrl_date'>承辦期限</label>
                    &nbsp;<label><input type="radio" name='qryKINDDATE' value='last_date' checked>法定期限</label>
	            </td>
            </tr>
            <tr  id='spdate'>
	            <TD class=lightbluetable align=right nowrap>抓取天數：</TD>
	            <td class=whitetablebg align="left" colspan=3>前<input type="text" id="qryDay" name="qryDay" size="2" maxLength="2">天
	            </td>
            </tr>
            <tr  id='spstat_code'>
                <td class=lightbluetable align=right nowrap>排序方式：</td>
                <td class=whitetablebg colspan=3> 
	                <Select id="qryOrder" name="qryOrder">
		            <option value="confirm_date">收文日期
		            <option value="ctrl_date">承辦期限
		            <option value="last_date" selected>法定期限
	                </Select>
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
        $("#spanBranch").getRadio({//區所別
            url: getRootPath() + "/ajax/JsonGetSqlDataCnn.aspx",
            data:{sql:"select branch,branchname from branch_code where mark='Y' and branch<>'J' order by sort"},
            objName: "qryBranch",
            valueFormat: "{branch}",
            textFormat: "{branchname}"
        });
        $("input.dateField").datepick();
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",false).triggerHandler("click");//☑測試

        $("#tabBtn").showFor((<%#HTProgRight%> & 2)).find("input").prop("checked",true);//[查詢][重填]

        this_init();
    });

    function this_init(){
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "100%,0%";
        }

        $("#qryDay").val("10");
    }

    //[查詢]
    $("#btnSrch").click(function (e) {
        if ($("#qryDay").val()==""){
            alert("請輸入抓取天數!!!");
            $("#qryDay").focus();
            return false;
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
</script>
