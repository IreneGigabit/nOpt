<%@ Page Language="C#"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "代理人維護";
    private string HTProgCode = "opt11";
    protected string HTProgPrefix = "Agent";
    private int HTProgAcs = 2;
    private int HTProgRight = 0;

    protected string StrQueryLink = "";
    protected string StrAddLink = "";
    protected string StrQueryBtn = "";

    protected string AreaType = "";
    

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;


        Token myToken = new Token(HTProgCode);

        QueryPageLayout();
        this.DataBind();
    }

    private void QueryPageLayout() {
        StrQueryLink = "<input type=\"image\" id=\"imgSrch\" src=\"../icon/inquire_in.png\" title=\"送出查詢\" />&nbsp;";
        StrQueryBtn = "<input type=\"button\" id=\"btnSrch\" value =\"送出查詢\" class=\"cbutton\" />";

        //if ((HTProgRight & 4) > 0)
        //    StrAddLink = "<input type=\"image\" id=\"imgAdd\" src=\"../icon/new.png\" title=\"新增\" />&nbsp;";
    }

</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="x-ua-compatible" content="IE=10">
<title><%#HTProgCap%></title>
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/inc/setstyle.css")%>" />
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/lib/jquery.datepick.css")%>" />
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/lib/toastr.css")%>" />
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery-1.12.4.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery.datepick.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery.datepick-zh-TW.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/toastr.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/util.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.Snoopy.date.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.irene.paging.test.js")%>"></script>
</head>


<body>
<%=Request.ServerVariables["HTTP_HOST"]%>
<%=System.Net.Dns.GetHostName()%>
<table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td width="100%" class="text9" nowrap="nowrap">&nbsp;【<%#HTProgCode%><%#HTProgCap%>‧<b style="color:Red">查詢</b>】</td>
        <td class="FormLink" valign="top" align="right" nowrap="nowrap">
            <a class="imgQry" href="javascript:void(0);" >[查詢條件]</a>&nbsp;
		    <a class="imgRefresh" href="javascript:void(0);" >[重新整理]</a>
        </td>
    </tr>
    <tr>
        <td width="100%" colspan="2"><hr class="style-one"/></td>
    </tr>
</table>

<form id="reg" name="reg" method="post" action="<%#HTProgPrefix%>List.aspx">
<div id="id-div-slide">
    <input type="hidden" name="submitTask" value=""/>
    <input type="hidden" name="dfz_b_a_end_date" value="<%#String.Format("{0:yyyy/M/d}", DateTime.Today)%>" />
    <table border="0" class="bluetable" cellspacing="1" width="70%" align="center">
        <tr>
            <td class="lightbluetable" align="right">報表種類：</td>
            <td class="whitetablebg" align="left" colspan="3">
                <label><input type="radio" name="rpt_type" value="scode" checked/>scode</label>
                <label><input type="radio" name="rpt_type" value="vbr_opt"/>vbr_opt</label>
            </td>
        </tr>
        <tr>
            <td class="lightbluetable" align="right"><span class="span_agent">代理人</span>編號：</td>
            <td class="whitetablebg" align="left">
                <input type="text" name="qagent_no" id="qagent_no" value="" size="10" maxlength="4"/> - 
                <input type="text" name="qagent_no1" id="qagent_no1" value="" size="5" maxlength="1"/>
            </td>
            <td class="lightbluetable" align="right"><span class="span_agent">代理人</span>名稱：</td>
            <td class="whitetablebg" align="left">
                <input type="text" name="qagent_na" id="qagent_na" value="" size="35" maxlength="30"/>
            </td> 
        </tr>
        <tr>
            <td class="lightbluetable" align="right">聯絡人名稱：</td>
            <td class="whitetablebg" align="left" colspan="3">
                <input type="text" name="qatt_name" id="qatt_name" value="" size="35" maxlength="30"/>
            </td>
        </tr>
        <tr>
            <td class="lightbluetable" align="right">種類：</td>
            <td class="whitetablebg" align="left" >
                <div id="div_Agent_Type" >
                </div>
            </td>
            <td class="lightbluetable" align="right"><span class="span_agent">代理人</span>名稱(中)：</td>
            <td class="whitetablebg" align="left" >
                <input type="text" name="qagent_nac" id="qagent_nac" value="" size="35" maxlength="30"/>
            </td>
        </tr>
        <tr>
            <td class="lightbluetable" align="right"><span class="span_agent">代理人</span>地址：</td>
            <td class="whitetablebg" align="left" colspan="3">
                <input type="text" name="qaddr" id="qaddr" value="" size="70" maxlength="70"/>
            </td>
        </tr>
        <tr>
            <td class="lightbluetable" align="right">電話：</td>
            <td class="whitetablebg" align="left" >
                <input type="text" name="qtel_ccode" id="qtel_ccode" value="" size="5" maxlength="3"/> - 
                <input type="text" name="qtel_no" id="qtel_no" value="" size="20" maxlength="20"/>
            </td>
                <td class="lightbluetable" align="right">國別：</td>
            <td class="whitetablebg" align="left" >
                <select id="qagcountry" name="qagcountry" >
                    <option value='' style='color:blue' selected>請選擇</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="lightbluetable" align="right">傳真：</td>
            <td class="whitetablebg" align="left" >
                <input type="text" name="qfax_ccode1" value="" size="5" maxlength="3"/> - 
                <input type="text" name="qfax_no1" value="" size="20" maxlength="20"/>
            </td>
                <td class="lightbluetable" align="right">行動電話：</td>
            <td class="whitetablebg" align="left" >
                <input type="text" name="qmobile" value="" size="30" maxlength="30"/>
            </td>
        </tr>
        <tr>
            <td class="lightbluetable" align="right">電子郵件：</td>
            <td class="whitetablebg" align="left" >
                <input type="text" name="qe_mail" value="" size="30" maxlength="50"/>
            </td>
                <td class="lightbluetable" align="right">網址：</td>
            <td class="whitetablebg" align="left" >
                <input type="text" name="qweb_site" size="30" maxlength="50"/>
            </td>
        </tr>
        <tr>
            <td class="lightbluetable" align="right">折扣：</td>
            <td class="whitetablebg" align="left" >
                <input type="text" id="qdiscount" name="qdiscount" size="5" maxlength="5" onkeypress="return chkNum(event, this);"/>
            </td>
                <td class="lightbluetable" align="right">建檔日期：</td>
            <td class="whitetablebg" align="left" >
                <input type="text" name="qsin_date" id="qsin_date" class="dateField" value="" size="10" /> ~
                <input type="text" name="qein_date" id="qein_date"  class="dateField" value="" size="10" />
            </td>
        </tr>
        <tr>
            <td class="lightbluetable" align="right">電子請款：</td>
            <td class="whitetablebg" align="left" colspan="3">
                <input type="radio" id="qe_payway_Y" name="qe_payway" value="Y" />是
                <input type="radio" id="qe_payway_N" name="qe_payway" value="N" />否
            </td>
        </tr>
        <tr>
            <td class="lightbluetable" align="right">使用狀況：</td>
            <td class="whitetablebg" align="left" colspan="3">
                <input type="radio" id="qhave_source_Y" name="qhave_source" value="Y" />已停用
                <input type="radio" id="qhave_source_N" name="qhave_source" value="N"  />使用中
                <input type="radio" id="qhave_source" name="qhave_source" value="0" checked/>不指定
                <span style="margin-left:15px;">(以有無輸入停用日期為基準)</span>
            </td>
        </tr>
    </table>
    <br />
    <table border="0" width="100%" cellspacing="0" cellpadding="0" align="center">
        <tr>
            <td width="100%" align="center">
                <%#StrQueryBtn%>
                <input type="button" id="btnRst" value ="重　填" class="cbutton"/>
            </td>
        </tr>
    </table>
</div>
<label id="labTest"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>

<div id="divPaging2"></div>
</form>

<TABLE style="display:none" border=0 class=bluetable cellspacing=1 cellpadding=2 width="85%" align="center" id="dataList">
	<thead>
	<tr align="center" class="lightbluetable">
		<td align="center" class="lightbluetable" nowrap="nowrap"><u class="setOdr" v1="scode">薪號代碼</u></td>
        <td align="center" class="lightbluetable" nowrap="nowrap"><u class="setOdr" v1="sc_name">人員中文名稱</u></td>                                
        <td align="center" class="lightbluetable" nowrap="nowrap">人員英文名稱</td>
        <td align="center" class="lightbluetable" nowrap="nowrap">內部Mail帳號</td>                                
        <td align="center" class="lightbluetable" nowrap="nowrap">有效起始日期</td>
        <td align="center" class="lightbluetable" nowrap="nowrap">有效結束日期</td>
        <td align="center" class="lightbluetable" nowrap="nowrap">最近拜訪日期</td>
	</tr>
	</thead>
	<tfoot style="display:none">
	<tr align='center' class='{{tclass}}' id='tr_data_{{nRow}}'>
		<td nowrap>{{scode}}</td>
		<td>{{sc_name}}</td>
		<td>{{se_name}}</td>
		<td nowrap>{{email}}</td>
		<td nowrap>{{beg_date}}</td>
		<td>{{end_date}}</td>
		<td>{{lastvisit}}</td>
	</tr>
	</tfoot>
	<tbody>
	</tbody>
</TABLE>

<table style="display:none" border="0" class="bluetable" cellspacing="1" cellpadding="2" width="98%" align="center" id="dataList1">
	<thead>
      <Tr>
	    <td class="lightbluetable" nowrap align="center"><u class="setOdr" v1="bseq,bseq1">區所案件編號</u></td>
	    <td class="lightbluetable" nowrap align="center">營洽</td>
	    <td class="lightbluetable" nowrap align="center">申請人</td>
	    <td class="lightbluetable" nowrap align="center">案件名稱</td> 
	    <td class="lightbluetable" nowrap align="center">案性</td> 
	    <td class="lightbluetable" nowrap align="center">法定期限</td>
	    <td class="lightbluetable" nowrap align="center">作業</td>
      </tr>
	</thead>
	<tfoot style="display:none">
	<tr class='{{tclass}}' id='tr_data_{{nRow}}'>
		<td align="center">{{fseq}}</td>
		<td align="center">{{scode_name}}</td>
		<td align=left>{{ap_cname}}</td>
		<td nowrap>{{appl_name}}</td>
		<td nowrap>{{arcase_name}}</td>
		<td align="center">{{last_date}}</td>
		<td align="center">
            <a href="<%#HTProgPrefix%>Edit.aspx?opt_sqlno={{opt_sqlno}}&Case_no={{Case_no}}&Branch={{Branch}}&arcase={{arcase}}&prgname=<%#HTProgCap%>" target="Eblank">[確認]</a>
		</td>
	</tr>
	</tfoot>
	<tbody>
	</tbody>
</TABLE>

</body>
</html>



<script type="text/javascript" language="javascript">
    $(function () {
        $("input.dateField").datepick();
        $("#imgCls").click(function (e) { window.parent.tt.rows = "100%,0%"; }).click();

        $("#qagent_no").blur(function (e) {
            $("#qagent_no").val($("#qagent_no").val().toUpperCase());
        });

        $("#qagent_no1").blur(function (e) {
            $("#qagent_no1").val($("#qagent_no1").val().toUpperCase());
        });
    });

    //查詢條件
    $(".imgQry").click(function (e) {
        $("#id-div-slide").slideToggle("fast");
    });

    //重新整理
    $(".imgRefresh").click(function (e) {
        if ($("input[name='rpt_type']:checked").val() == "scode") {
            goSearch2();
        } else if ($("input[name='rpt_type']:checked").val() == "vbr_opt") {
            goSearch1();
        }
    });

    //[重填]
    $("#btnRst").click(function (e) {
        $("#reg")[0].reset();
    });

    //排序
    $(".setOdr").click(function (e) {
        $("#dataList>thead tr .setOdr span").remove();
        $(this).append("<span>▲</span>");
        $("#SetOrder", $("#divPaging2")).val($(this).attr("v1"));
        $("#GoPage", $("#divPaging2")).val("1");

        if ($("input[name='rpt_type']:checked").val() == "scode") {
            goSearch2();
        } else if ($("input[name='rpt_type']:checked").val() == "vbr_opt") {
            goSearch1();
        }
    });

    //[查詢]
    $("#btnSrch").click(function (e) {
        sObj = $("#qsin_date");
        if ($(sObj).val() != "" && $.isNDate($(sObj).val())) {
            alert("「建檔日期起日」務必填寫正確日期！");
            $(sObj).focus();
            return false;
        }
        sObj = $("#qein_date");
        if ($(sObj).val() != "" && $.isNDate($(sObj).val())) {
            alert("「建檔日期迄日」務必填寫正確日期！");
            $(sObj).focus();
            return false;
        }

        if ((Date.parse($("#qsin_date").val())).valueOf() > (Date.parse($("#qein_date").val())).valueOf()) {
            alert("建檔日期起始日不可大於迄止日!!!");
            return false;
        }

        $("#SetOrder", $("#divPaging2")).val("");
        $("#GoPage", $("#divPaging2")).val("1");
        $("#dataList,#dataList1").hide();

        if ($("input[name='rpt_type']:checked").val() == "scode") {
            $("#dataList>thead tr .setOdr span").remove();
            goSearch2();
        } else if ($("input[name='rpt_type']:checked").val() == "vbr_opt") {
            $("#dataList1>thead tr .setOdr span").remove();
            goSearch1();
        }
    });

    //執行查詢scode
    function goSearch2() {
        if (window.parent.tt !== undefined) {
            window.parent.tt.rows = "100%,0%";
        }

        $("#dataList").hide();
        $("#dataList>tbody tr").remove();
        nRow = 0;

        $.ajax({
            url: "AgentList.aspx",
            type: "get",
            async: false,
            data: $("#reg").serialize(),
            cache: false,
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                $("#divPaging2").paging({ callSearch: goSearch2, data: JSONdata });
                $("#id-div-slide").slideUp("fast");
                if (JSONdata.totrow === undefined) {
                    toastr.error("資料載入失敗（" + JSONdata.msg + "）");
                    return false;
                }
                if ($("#chkTest").prop("checked")) toastr.info("<a href='" + this.url + "' target='_new'>Debug！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
                $.each(JSONdata.pagedtable, function (i, item) {
                    nRow++;
                    //複製一筆
                    $("#dataList>tfoot").each(function (i) {
                        var strLine1 = $(this).html().replace(/##/g, nRow);
                        var tclass = "";
                        if (nRow % 2 == 1) tclass = "sfont9"; else tclass = "lightbluetable3";
                        strLine1 = strLine1.replace(/{{tclass}}/g, tclass);
                        strLine1 = strLine1.replace(/{{nRow}}/g, nRow);

                        strLine1 = strLine1.replace(/{{scode}}/g, item.scode);
                        strLine1 = strLine1.replace(/{{sc_name}}/g, item.sc_name);
                        strLine1 = strLine1.replace(/{{se_name}}/g, item.se_name);
                        strLine1 = strLine1.replace(/{{email}}/g, item.email);
                        strLine1 = strLine1.replace(/{{beg_date}}/g, dateReviver(item.beg_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{end_date}}/g, dateReviver(item.end_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{lastvisit}}/g, dateReviver(item.lastvisit, "yyyy/M/d"));

                        $("#dataList>tbody").append(strLine1);
                    });
                });
            },
            beforeSend: function (jqXHR, settings) {
                jqXHR.url = settings.url;
            },
            error: function (jqXHR, textStatus, errorThrown) {
                toastr.error("<a href='" + jqXHR.url + "' target='_new'>資料擷取剖析錯誤！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
            }
        });

        if (nRow > 0) {
            $("#dataList").show();
        }
    };

    //執行查詢vbr_opt
    function goSearch1() {
        if (window.parent.tt !== undefined) {
            window.parent.tt.rows = "100%,0%";
        }

        $("#dataList1").hide();
        $("#dataList1>tbody tr").remove();
        nRow = 0;

        $.ajax({
            url: "opt11List.aspx",
            type: "get",
            async: false,
            data: $("#reg").serialize(),
            cache: false,
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                $("#divPaging2").paging({ callSearch: goSearch1, data: JSONdata });
                $("#id-div-slide").slideUp("fast");
                if (JSONdata.totrow === undefined) {
                    toastr.error("資料載入失敗（" + JSONdata.msg + "）");
                    return false;
                }
                if ($("#chkTest").prop("checked")) toastr.info("<a href='" + this.url + "' target='_new'>Debug！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
                $.each(JSONdata.pagedtable, function (i, item) {
                    nRow++;
                    //複製一筆
                    $("#dataList1>tfoot").each(function (i) {
                        var strLine1 = $(this).html().replace(/##/g, nRow);
                        var tclass = "";
                        if (nRow % 2 == 1) tclass = "sfont9"; else tclass = "lightbluetable3";
                        strLine1 = strLine1.replace(/{{tclass}}/g, tclass);
                        strLine1 = strLine1.replace(/{{nRow}}/g, nRow);

                        strLine1 = strLine1.replace(/{{fseq}}/g, item.fseq);
                        strLine1 = strLine1.replace(/{{scode_name}}/g, item.scode_name);
                        strLine1 = strLine1.replace(/{{ap_cname}}/g, item.ap_cname);
                        strLine1 = strLine1.replace(/{{appl_name}}/g, item.appl_name);
                        strLine1 = strLine1.replace(/{{arcase_name}}/g, item.arcase_name);
                        strLine1 = strLine1.replace(/{{last_date}}/g, dateReviver(item.last_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{opt_sqlno}}/g, item.opt_sqlno);
                        strLine1 = strLine1.replace(/{{Case_no}}/g, item.case_no);
                        strLine1 = strLine1.replace(/{{Branch}}/g, item.branch);
                        strLine1 = strLine1.replace(/{{arcase}}/g, item.arcase);

                        $("#dataList1>tbody").append(strLine1);
                    });
                });
            },
            beforeSend: function (jqXHR, settings) {
                jqXHR.url = settings.url;
            },
            error: function (jqXHR, textStatus, errorThrown) {
                toastr.error("<a href='" + jqXHR.url + "' target='_new'>資料擷取剖析錯誤！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
            }
        });

        if (nRow > 0) {
            $("#dataList1").show();
        }
    };

    function chkNum(e, obj) {
        if (e.keyCode == 46) {
            if (obj.value.indexOf(".", 0) > 0) {
                return false;
            }
        }
        else {
            var key = window.event ? e.keyCode : e.which;
            var keychar = String.fromCharCode(key);
            reg = /\d|\./;
            return reg.test(keychar);
        }
    }

    $("#div_Agent_Type").on("click", "input:radio", function () {
        var value = $(this).val();
        var text = $.trim($('[name="qAgent_Type"]:checked').next("label").text());
        var title = "";
        switch (value) {
            case "Z":
                title = "";
                break;
            default:
                title = text;
                break;
        }
        $("span.span_agent").text(title);
    });
</script>
