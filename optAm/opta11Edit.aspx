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
            RS = dt.ToDictionary().FirstOrDefault() ?? new Dictionary<string, object>();
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
        <td class="text9" nowrap="nowrap">&nbsp;【<%=prgid%> <%=HTProgCap%>】
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
    <input type="text" id="law_sqlno" name="law_sqlno" value="<%=law_sqlno%>">
	<input type="text" id="submittask" name="submittask" value="<%=submitTask%>">
	<input type="text" id="prgid" name="prgid" value="<%=prgid%>">

    <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="70%" align="center">	
	    <tr>
		    <td class="lightbluetable" align="right">法條大項 :</td>
		    <td class="whitetablebg" align="left" colspan="5">
			    <Select id="edit_law_type" name="edit_law_type" class="QLock" ><%#qry_law_type%></Select>
		    </td> 
	    </tr>
	    <tr >
		    <td class=lightbluetable align=right nowrap>條文法規_條：</td>
		    <td class=whitetablebg > 
			    <input type="text" id='edit_law_no1' name='edit_law_no1'  value='' size="4" maxLength="4" class="QLock">			
		    </td>
		    <td class=lightbluetable align=right nowrap>條文法規_款：</td>
		    <td class=whitetablebg > 
			    <input type="text" id='edit_law_no2' name='edit_law_no2'  value='' size="4" maxLength="4" class="QLock">			
		    </td>
		    <td class=lightbluetable align=right nowrap>條文法規_項：</td>
		    <td class=whitetablebg > 
			    <input type="text" id='edit_law_no3' name='edit_law_no3'  value='' size="4" maxLength="4" class="QLock">			
		    </td>
	    </tr>   
	    <tr>		
		    <td class="lightbluetable" align="right">法條內文 :</td>
		    <td class="whitetablebg" align="left" colspan="5">
			    <input type=hidden id="O_edit_law_mark" name="O_edit_law_mark">
			    <textarea rows=6 cols=120 id="edit_law_mark" name="edit_law_mark" class="DLock"></textarea>
		    </td> 
	    </tr>
	    <tr id="tr_end_date">	
		    <td class="lightbluetable" align="right">停用日期 :</td>
		    <td class="whitetablebg" align="left" colspan="5">
			    <input type="text" id="edit_end_date" name="edit_end_date" size="10" maxLength="10" class="dateField" >
		    </td> 
	    </tr>		
    </table>

    <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>
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
        $("#chkTest").click(function (e) {
            $("#ActFrame").showFor($(this).prop("checked"));
        });

        this_init();
    });

    var br_opte = {};
    //初始化
    function this_init() {
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",true).triggerHandler("click");//☑測試
        $("input.dateField").datepick();
        //欄位控制
        $(".Lock").lock();
        $(".QLock").lock(<%#QLock%>);
        $(".DLock").lock(<%#DLock%>);

        $("#btnSubmit,#btnDel,#btnReset").hide();

        if($("#submittask").val()=="A"){
            if (!(window.parent.tt === undefined)) {
                window.parent.tt.rows = "0%,100%";
            }
            $("#tr_end_date").hide();
            $("#btnSubmit,#btnReset").show();
            $("#btnSubmit").val("新　增");
        }else if($("#submittask").val()=="U"){
            if (!(window.parent.tt === undefined)) {
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
            if (!(window.parent.tt === undefined)) {
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
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "100%,0%";
        } else {
            window.close();
        }
    })

    //新增/修改
    $("#btnSubmit").click(function () {
        if ($("#edit_law_type").val() == "") {
            alert("請選擇法條大項！");
            $("#edit_law_type").focus();
            return false;
        }
        if ($("#edit_law_no1").val() == "") {
            alert("請輸入條文法規_條！");
            $("#edit_law_no1").focus();
            return false;
        }
        if ($("#edit_law_no2").val() == "") {
            alert("請輸入條文法規_款！");
            $("#edit_law_no2").focus();
            return false;
        }
        if ($("#edit_law_no3").val() == "") {
            alert("請輸入條文法規_項！");
            $("#edit_law_no3").focus();
            return false;
        }
        if ($("#edit_law_mark").val() == "") {
            alert("請輸入法條內文！");
            $("#edit_law_mark").focus();
            return false;
        }
	
        if($("#submittask").val()=="A"){
            if(!Check_law()){
                alert("請輸入法條代碼重複，請重新輸入 ");
                return false;
            }
        }

        $("select,textarea,input").unlock();
        $("#btnSubmit,#btnDel,#btnReset").lock(!$("#chkTest").prop("checked"));
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.target = "ActFrame";
        reg.submit();
    });

    //刪除
    $("#btnDel").click(function () {
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

    function Check_law(){
        var rtn=false;

        var searchSql="SELECT count(*) as count from law_detail where 1=1 ";
        searchSql+= " AND law_type = '" + $("#edit_law_type").val() + "'" ;
        searchSql+= " AND law_no1 = '" + $("#edit_law_no1").val()+ "'" ;
        searchSql+= " AND law_no2 = '" + $("#edit_law_no2").val() + "'" ;
        searchSql+= " AND law_no3 = '" + $("#edit_law_no3").val() + "'";
        $.ajax({
            type: "get",
            url: getRootPath() + "/ajax/JsonGetSqlData.aspx",
            data: { sql:searchSql},
            async: false,
            cache: false,
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                if (JSONdata.length > 0) {
                    if(JSONdata[0].count==0){
                        rtn=true;
                    }
                }
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>檢查法條代碼失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });

        return rtn;
    }
</script>
