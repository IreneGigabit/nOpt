<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "Newtonsoft.Json"%>
<%@ Import Namespace = "Newtonsoft.Json.Linq"%>

<script runat="server">
    protected string HTProgCap = "出口爭救案系統-發文信函查詢";//HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;
    protected string DebugStr = "";

    protected string SQL = "";
    protected string json_data = "";
    protected string json = "";

    protected string source = "";
    protected string job_sqlno = "";
    protected string tfsend_no = "";
    protected string tlink = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        json = (Request["json"] ?? "").ToString().ToUpper();
        source = Request["source"] ?? "";
        job_sqlno = Request["job_sqlno"] ?? "";
        tfsend_no = Request["tfsend_no"] ?? "";

        tlink += "&prgid=" + prgid;
        tlink += "&source=" + source;
        tlink += "&job_sqlno=" + job_sqlno;
        tlink += "&tfsend_no=" + tfsend_no;
        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        DebugStr = myToken.DebugStr;
        if (HTProgRight >= 0) {
            if (json == "Y") QueryData();

            this.DataBind();
        }
    }

    private void QueryData() {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select *";
            SQL+= ",(select sc_name from sysctrl.dbo.scode s where s.scode = a.in_scode) as in_scode_name ";
            SQL += " from opt_email_log a where job_sqlno=" + job_sqlno;
            SQL += " order by email_sqlno ";
    
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            //處理分頁
            int nowPage = Convert.ToInt32(Request["GoPage"] ?? "1"); //第幾頁
            int PerPageSize = Convert.ToInt32(Request["PerPage"] ?? "10"); //每頁筆數
            Paging page = new Paging(nowPage, PerPageSize, string.Join(";", conn.exeSQL.ToArray()));
            page.GetPagedTable(dt);

            //分頁完再處理其他資料才不會虛耗資源
            for (int i = 0; i < page.pagedTable.Rows.Count; i++) {
            }

            var settings = new JsonSerializerSettings()
            {
                Formatting = Formatting.None,
                ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
                Converters = new List<JsonConverter> { new DBNullCreationConverter(), new TrimCreationConverter() }//dbnull轉空字串且trim掉
            };

            Response.Write(JsonConvert.SerializeObject(page, settings).ToUnicode());
            Response.End();
            //return JsonConvert.SerializeObject(dt, settings).ToUnicode().Replace("\\", "\\\\").Replace("\"", "\\\"");
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
</head>

<body>
<table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td class="text9" nowrap="nowrap">&nbsp;【<%=prgid%> <%=HTProgCap%>】</td>
        <td class="FormLink" valign="top" align="right" nowrap="nowrap">
            <%--<a class="imgCls" href="javascript:void(0);" >[關閉視窗]</a>--%>
        </td>
    </tr>
    <tr>
        <td colspan="2"><hr class="style-one"/></td>
    </tr>
</table>
<br>
<form id="reg" name="reg" method="post">
    <input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">
    <input type="hidden" id="source" name="source" value="<%=source%>">
    <input type="hidden" id="job_sqlno" name="job_sqlno" value="<%=job_sqlno%>">
    <input type="hidden" id="tfsend_no" name="tfsend_no" value="<%=tfsend_no%>">

    <%#DebugStr%>

    <div id="divPaging" style="display:none">
    <TABLE border=0 cellspacing=1 cellpadding=0 width="98%" align="center">
	    <tr>
		    <td colspan=2 align=center>
			    <font size="2" color="#3f8eba">
				    第<font color="red"><span id="NowPage"></span>/<span id="TotPage"></span></font>頁
				    | 資料共<font color="red"><span id="TotRec"></span></font>筆
				    | 跳至第
				    <select id="GoPage" name="GoPage" style="color:#FF0000"></select>
				    頁
				    <span id="PageUp">| <a href="javascript:void(0)" class="pgU" v1="">上一頁</a></span>
				    <span id="PageDown">| <a href="javascript:void(0)" class="pgD" v1="">下一頁</a></span>
				    | 每頁筆數:
				    <select id="PerPage" name="PerPage" style="color:#FF0000">
					    <option value="10" selected>10</option>
					    <option value="20">20</option>
					    <option value="30">30</option>
					    <option value="50">50</option>
				    </select>
                    <input type="hidden" name="SetOrder" id="SetOrder" />
			    </font>
		    </td>
	    </tr>
    </TABLE>
    </div>
</form>

<div align="center" id="noData" style="display:none">
	<font color="red">=== 查無發信資料 ===</font>
</div>

<table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="98%" align="center" id="dataList">
	<thead>
      <Tr>
		<TD class="lightbluetable" align="center">寄件日期</TD>
		<TD class="lightbluetable" align="center">寄件人員</TD>
		<TD class="lightbluetable" align="center">收件者</TD>
		<TD class="lightbluetable" align="center">EMail 主旨</TD>
		<TD class="lightbluetable" align="center">作業</TD>
      </tr>
	</thead>
	<tfoot style="display:none">
	  <tr class='{{tclass}}' id='tr_data_{{nRow}}'>
		<td nowrap>{{in_date}}</td>
		<td nowrap>{{in_scode_name}}</td>
		<td nowrap>{{to_email}}</td>
		<td nowrap>{{email_title}}</td>
		<td nowrap  align="center">
			<a href="opte23_mailpreview.aspx?submitTask=Q&opt_sqlno={{job_sqlno}}&email_sqlno={{email_sqlno}}<%#tlink%>&winact=1&FrameBlank=50" target="Eblank">[查詢]</a>
		</td>
      </tr>
	</tfoot>
	<tbody>
	</tbody>
</TABLE>
<br />
</body>
</html>

<script language="javascript" type="text/javascript">
    $(function () {
        this_init();
    });

    //初始化
    function this_init() {
        goSearch();
    }

    //執行查詢
    function goSearch() {
        $("#divPaging,#noData,#dataList").hide();
        $("#dataList>tbody tr").remove();
        nRow = 0;

        $.ajax({
            url: "mailopen.aspx?json=Y",
            type: "get",
            async: false,
            cache: false,
            data: $("#reg").serialize(),
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                if (JSONdata.totrow === undefined) {
                    toastr.error("資料載入失敗（" + JSONdata.msg + "）");
                    return false;
                }
                if ($("#chkTest").prop("checked")) toastr.info("<a href='" + this.url + "' target='_new'>Debug！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
                //////更新分頁變數
                var totRow = parseInt(JSONdata.totrow, 10);
                if (totRow > 0) {
                    $("#divPaging").show();
                    $("#dataList").show();
                } else {
                    $("#noData").show();
                }

                var nowPage = parseInt(JSONdata.nowpage, 10);
                var totPage = parseInt(JSONdata.totpage, 10);
                $("#NowPage").html(nowPage);
                $("#TotPage").html(totPage);
                $("#TotRec").html(totRow);
                var i = totPage + 1, option = new Array(i);
                while (--i) {
                    option[i] = ['<option value="' + i + '">' + i + '</option>'].join("");
                }
                $("#GoPage").replaceWith('<select id="GoPage" name="GoPage" style="color:#FF0000">' + option.join("") + '</select>');
                $("#GoPage").val(nowPage);
                nowPage > 1 ? $("#PageUp").show() : $("#PageUp").hide();
                nowPage < totPage ? $("#PageDown").show() : $("#PageDown").hide();
                $("a.pgU").attr("v1", nowPage - 1);
                $("a.pgD").attr("v1", nowPage + 1);
                //$("#id-div-slide").slideUp("fast");

                $.each(JSONdata.pagedtable, function (i, item) {
                    nRow++;
                    //複製一筆
                    $("#dataList>tfoot").each(function (i) {
                        var strLine1 = $(this).html().replace(/##/g, nRow);
                        var tclass = "";
                        if (nRow % 2 == 1) tclass = "sfont9"; else tclass = "lightbluetable3";
                        strLine1 = strLine1.replace(/{{tclass}}/g, tclass);
                        strLine1 = strLine1.replace(/{{nRow}}/g, nRow);

                        strLine1 = strLine1.replace(/{{in_date}}/g, dateReviver(item.in_date, "yyyy/M/d t HH:mm:ss"));
                        strLine1 = strLine1.replace(/{{in_scode_name}}/g, item.in_scode_name);
                        strLine1 = strLine1.replace(/{{to_email}}/g, item.to_email);
                        strLine1 = strLine1.replace(/{{email_title}}/g, item.email_title);
                        strLine1 = strLine1.replace(/{{job_sqlno}}/g, item.job_sqlno);
                        strLine1 = strLine1.replace(/{{email_sqlno}}/g, item.email_sqlno);

                        $("#dataList>tbody").append(strLine1);
                    });
                });
            },
            beforeSend: function (jqXHR, settings) {
                jqXHR.url = settings.url;
                //toastr.info("<a href='" + jqXHR.url + "' target='_new'>debug！\n" + jqXHR.url + "</a>");
            },
            error: function (jqXHR, textStatus, errorThrown) {
                toastr.error("<a href='" + jqXHR.url + "' target='_new'>資料擷取剖析錯誤！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
            }
        });
    };

    //每頁幾筆
    $("#PerPage").change(function (e) {
        goSearch();
    });
    //指定第幾頁
    $("#divPaging").on("change", "#GoPage", function (e) {
        goSearch();
    });
    //上下頁
    $(".pgU,.pgD").click(function (e) {
        $("#GoPage").val($(this).attr("v1"));
        goSearch();
    });
    //排序
    $(".setOdr").click(function (e) {
        $("#dataList>thead tr .setOdr span").remove();
        $(this).append("<span>▲</span>");
        $("#SetOrder").val($(this).attr("v1"));
        goSearch();
    });
    //關閉視窗
    $(".imgCls").click(function (e) {
        if (window.parent.tt !== undefined) {
            window.parent.tt.rows = "100%,0%";
        } else {
            window.close();
        }
    })

    //取回進度項目
    function getstep(pno){
        window.opener.reg.Bseq.value = $("#seq_" + pno).val();
        window.opener.reg.Bseq1.value = $("#seq1_" + pno).val();
        //window.opener.reg.btnBseq.click();
        window.opener.br_formA.loadDmt();
        //$('#Bseq', opener.document).val($("#seq_" + pno).val());
        //$('#Bseq1', opener.document).val($("#seq1_" + pno).val());
        //$('#btnBseq', opener.document).click();
        window.close();
    }
</script>
