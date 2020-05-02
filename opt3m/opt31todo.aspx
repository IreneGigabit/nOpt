<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "Newtonsoft.Json"%>
<%@ Import Namespace = "Newtonsoft.Json.Linq"%>

<script runat="server">
    protected string HTProgCap = "爭救案進度查詢";//HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opt31";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string SQL = "";

    protected string opt_sqlno = "";
    protected string case_no = "";
    protected string branch = "";
    protected string fseq = "";
    protected string scode_name = "";
    protected string json_data = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        opt_sqlno = Request["opt_sqlno"] ?? "";
        case_no = Request["case_no"] ?? "";
        branch = Request["branch"] ?? "";
        fseq = Request["fseq"] ?? "";
        scode_name = Request["scode_name"] ?? "";

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            json_data = QueryData();
            this.DataBind();
        }
    }
    
    private string QueryData() {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select * ";
            SQL += ",(select code_name from cust_code  where code_type='ODowhat' and cust_code = a.dowhat) as dowhat_nm ";
            SQL += ",(SELECT sc_name FROM sysctrl.dbo.scode WHERE scode = a.approve_scode) AS approve_scode_nm ";
            SQL += ",(select code_name from cust_code  where code_type='OJOB_STAT' and cust_code = a.job_status) as job_status_nm ";
            SQL += " from todo_opt as a ";
            SQL += " where opt_sqlno =  '" + opt_sqlno + "' ";
            SQL += " and branch =  '" + branch + "' ";
            SQL += " order by resp_date desc";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);
            
            var settings = new JsonSerializerSettings()
            {
                Formatting = Formatting.None,
                ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
                Converters = new List<JsonConverter> { new DBNullCreationConverter(), new TrimCreationConverter() }//dbnull轉空字串且trim掉
            };

            return JsonConvert.SerializeObject(dt, settings).ToUnicode().Replace("\\", "\\\\").Replace("\"", "\\\"");
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
</head>

<body>
<table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td class="text9" nowrap="nowrap">&nbsp;【<%=prgid%> <%=HTProgCap%>】</td>
        <td class="FormLink" valign="top" align="right" nowrap="nowrap">
            <a class="imgCls" href="javascript:void(0);" >[關閉視窗]</a>
        </td>
    </tr>
    <tr>
        <td colspan="2"><hr class="style-one"/></td>
    </tr>
</table>
<table align=center style="color:blue" class="bluetable1">
    <TR>
	    <TD>營洽人員:<font color="red"><%=scode_name%></font></TD>
	    <TD>本所編號:<font color="red"><%=fseq%></font></TD>
	    <TD>交辦序號:<font color="red"><%=case_no%></font></TD>
    </TR>
</table>
<br>
<form id="reg" name="reg" method="post">
    <input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">
</form>

<div align="center" id="noData" style="display:none">
	<font color="red">=== 目前無資料 ===</font>
</div>

<table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="98%" align="center" id="dataList">
	<thead>
      <Tr>
	    <td class="lightbluetable" nowrap align="center">序號</td>
	    <td class="lightbluetable" nowrap align="center">分派日期</td>
	    <td class="lightbluetable" nowrap align="center">簽核人員</td> 
	    <td class="lightbluetable" nowrap align="center">完成日期</td> 
	    <td class="lightbluetable" nowrap align="center">簽核狀態</td>
	    <td class="lightbluetable" nowrap align="center">簽核說明</td>
      </tr>
	</thead>
	<tfoot style="display:none">
	  <tr class='{{tclass}}' id='tr_data_{{nRow}}'>
	    <td nowrap align="center">{{nRow}}</td>
	    <td nowrap align="center">{{in_date}}</td>
		<td nowrap>{{approve_scode_nm}}</td>
		<td nowrap>{{resp_date}}</td>
		<td nowrap>{{dowhat_nm}}-{{job_status_nm}}</td>
		<td>{{approve_desc}}</td>
      </tr>
	</tfoot>
	<tbody>
	</tbody>
</TABLE>

</body>
</html>

<script language="javascript" type="text/javascript">
    $(function () {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "*,2*";
        }
        this_init();
    });

    //初始化
    function this_init() {
        var JSONdata = $.parseJSON("<%#json_data%>");
        $("#noData").showFor(JSONdata.length == 0);

        $("#dataList>tbody").empty();
        $.each(JSONdata, function (i, item) {
            var nRow = i + 1;
            //複製一筆
            $("#dataList>tfoot").each(function (idx) {
                var strLine1 = $(this).html().replace(/##/g, nRow);
                var tclass = "";
                if (nRow % 2 == 1) tclass = "sfont9"; else tclass = "lightbluetable3";
                strLine1 = strLine1.replace(/{{tclass}}/g, tclass);
                strLine1 = strLine1.replace(/{{nRow}}/g, nRow);

                strLine1 = strLine1.replace(/{{in_date}}/g, dateReviver(item.in_date, "yyyy/M/d hh:mm:ss"));
                strLine1 = strLine1.replace(/{{approve_scode_nm}}/g, item.approve_scode_nm);
                strLine1 = strLine1.replace(/{{resp_date}}/g, dateReviver(item.resp_date, "yyyy/M/d hh:mm:ss"));
                strLine1 = strLine1.replace(/{{dowhat_nm}}/g, item.dowhat_nm);
                strLine1 = strLine1.replace(/{{job_status_nm}}/g, item.job_status_nm);
                strLine1 = strLine1.replace(/{{approve_desc}}/g, item.approve_desc);

                $("#dataList>tbody").append(strLine1);
            });
        });
    }

    //關閉視窗
    $(".imgCls").click(function (e) {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "100%,0%";
        } else {
            window.close();
        }
    })
</script>
