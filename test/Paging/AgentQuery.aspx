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
<title><%#HTProgCap%></title>
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/inc/setstyle.css")%>" />
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/jquery.datepick.css")%>" />
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery-1.12.4.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.datepick.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.datepick-zh-TW.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.Snoopy.date.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.irene.paging.js")%>"></script>
</head>


<body>
    <%=Request.ServerVariables["HTTP_HOST"]%>
    <%=System.Net.Dns.GetHostName()%>
<table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        
        <td width="100%" class="text9" nowrap="nowrap">&nbsp;【<%#HTProgCode%><%#HTProgCap%>‧<b style="color:Red">查詢</b>】</td>
        <td class="FormLink" valign="top" align="right" nowrap="nowrap">
            <a id="imgQry" href="javascript:void(0);" >[查詢條件]</a>&nbsp;        
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


<div id="divPaging" style="display:none">
<TABLE border=0 cellspacing=1 cellpadding=0 width="85%" align="center">
	<tr>
		<td valign="top" align="right" nowrap="nowrap">
			<a id="imgRefresh" href="javascript:void(0);" >[重新整理]</a>
			<HR color=#000080 SIZE=1 noShade>
		</td>
	</tr>
	<tr>
		<td colspan=2 align=center class=whitetablebg>
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
					<option value="40">40</option>
				</select>
                <input type="hidden" name="SetOrder" id="SetOrder" />
			</font>
		</td>
	</tr>
</TABLE>
</div>
</form>

<div id="divPaging2"></div>
<div id="divPaging3"></div>

<TABLE style="display:none" border=0 class=greentable cellspacing=1 cellpadding=2 width="85%" align="center" id="dataList">
	<thead>
	<tr align="center" class="lightbluetable">
		<td align="center" class="lightbluetable" nowrap="nowrap"><u class="setOdr" v1="agent_no">代理人編號</u></td>
        <td align="center" class="lightbluetable" nowrap="nowrap"><u class="setOdr" v1="agent_na1">名稱</u></td>                                
        <td align="center" class="lightbluetable" nowrap="nowrap">種類</td>
        <td align="center" class="lightbluetable" nowrap="nowrap">國別</td>                                
        <td align="center" class="lightbluetable" nowrap="nowrap">傳真</td>
        <td align="center" class="lightbluetable" nowrap="nowrap">電子郵件</td>
        <td align="center" class="lightbluetable" nowrap="nowrap">聯絡人</td>
        <td align="center" class="lightbluetable" nowrap="nowrap">作業</td>
	</tr>
	</thead>
	<tfoot style="display:none">
	<tr align='center' class='{{tclass}}' id='tr_data_{{nRow}}'>
		<td nowrap>{{scode}}</td>
		<td>{{sc_name}}</td>
		<td>{{se_name}}</td>
		<td nowrap>{{Email}}</td>
		<td nowrap>{{lfax_no}}</td>
		<td>{{le_mail}}</td>
		<td></td>
        <td></td>
	</tr>
	</tfoot>
	<tbody>
	</tbody>
</TABLE>

<div align="center" id="noData" style="display:none">
	<font color="red">=== 目前無資料 ===</font>
</div>
</body>
</html>



<script type="text/javascript" language="javascript">
    //執行查詢
    function goSearch2() {

        $("#divPaging,#noData,#dataList").hide();
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
                $("#divPaging2").paging({ submitForm: "#reg", callback: goSearch2, data: JSONdata });
                $("#divPaging3").paging({ submitForm: "#reg", callback: goSearch2, data: JSONdata });

                $.each(JSONdata.pagedTable, function (i, item) {
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
                        strLine1 = strLine1.replace(/{{Email}}/g, item.Email);
                        //alert(strLine1); // DEBUG AJAX 

                        $("#dataList>tbody").append(strLine1);
                    });
                });
            },
            beforeSend: function (jqXHR, settings) {
                jqXHR.url = settings.url;
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert("\n資料擷取剖析錯誤 !\n" + jqXHR.url);
            }
        });
    };

    //執行查詢
    function goSearch() {

        $("#divPaging,#noData,#dataList").hide();
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
                $("#divPaging2").paging({ submitForm: "#reg", callback:goSearch2, data: JSONdata });
                $("#divPaging3").paging({ submitForm: "#reg", callback: goSearch2, data: JSONdata });

                //////更新分頁變數
                var totRow = parseInt(JSONdata.totRow, 10);
                if (totRow > 0) {
                    $("#divPaging").show();
                    $("#dataList").show();
                } else {
                    $("#noData").show();
                }

                var nowPage = parseInt(JSONdata.nowPage);
                var totPage = parseInt(JSONdata.totPage);
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
                $("#id-div-slide").slideUp("fast");

                $.each(JSONdata.pagedTable, function (i, item) {
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
                        strLine1 = strLine1.replace(/{{Email}}/g, item.Email);
                        //alert(strLine1); // DEBUG AJAX 

                        $("#dataList>tbody").append(strLine1);
                    });
                });
            },
            beforeSend: function (jqXHR, settings) {
                jqXHR.url = settings.url;
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert("\n資料擷取剖析錯誤 !\n" + jqXHR.url);
            }
        });
    };
  
    $(function () {
        $("input.dateField").datepick();
        $("#imgCls").click(function (e) { window.parent.tt.rows = "100%,0%"; }).click();
       



        $("#qagent_no").blur(function (e) {
            $("#qagent_no").val($("#qagent_no").val().toUpperCase());
        });

        $("#qagent_no1").blur(function (e) {
            $("#qagent_no1").val($("#qagent_no1").val().toUpperCase());
        });


        $("#btnRst").click(function (e) {

            $("#reg")[0].reset();
        });
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

            $("#dataList>thead tr .setOdr span").remove();
            $("#SetOrder").val("");

            goSearch();
        });

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
            $(this).append( "<span>▲</span>" );
            $("#SetOrder").val($(this).attr("v1"));
            goSearch();
        });
        //重新整理
        $("#imgRefresh").click(function (e) {
            goSearch();
        });
        //查詢條件
        $("#imgQry").click(function (e) {
            $("#id-div-slide").slideToggle("fast");
        });
        //////////////////////

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


    });
</script>
