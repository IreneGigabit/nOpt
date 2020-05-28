<%@ Page Language="C#" CodePage="65001"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opt61";//程式檔名前綴
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
            <a class="imgQry" href="javascript:void(0);" >[查詢條件]</a>&nbsp;
		    <a class="imgRefresh" href="javascript:void(0);" >[重新整理]</a>
        </td>
    </tr>
    <tr>
        <td colspan="2"><hr class="style-one"/></td>
    </tr>
</table>

<form id="reg" name="reg" method="post" action="<%#HTProgPrefix%>_list.aspx">
    <input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">

    <div id="id-div-slide">
        <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="75%" align="center">	
	        <tr>
		        <td class="lightbluetable" align="right">承辦案性 :</td>
		        <td class="whitetablebg" align="left">
                    <select id="qryArcase" name="qryArcase"></select>
		        </td> 
	        </tr>
            <tr>
	            <td class=lightbluetable align=right nowrap>承&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;辦：</td>
	            <td class=whitetablebg> 
	                <select id="qryPR_SCODE" name="qryPR_SCODE"></select>
	            </td>
	        </tr>
	        <tr>
		        <td class="lightbluetable" align="right">列印選擇 :</td>
		        <td class="whitetablebg" align="left">
		            <label><input type="radio" name="qrynew" value="N" checked>尚未列印</label>
		            <label><input type="radio" name="qrynew" value="P">已列印</label>
		            <label><input type="radio" name="qrynew" value="">不設定</label>
		        </td>
	        </tr>
	        <tr>
		        <td class="lightbluetable" align="right">序號選擇 :</td>
		        <td class="whitetablebg" align="left">
			        <label><input type="radio" name="qryno_type" value="opt_no" checked>案件編號</label>
 			        <label><input type="radio" name="qryno_type" value="Bseq_no" />區所案件編號</label>
 		        </td>
	        </tr>
	        <tr id=sin_no1 style="display:">
		        <td class="lightbluetable" align="right">案件編號 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
                    <input type="text" id="qrySopt_no" name="qrySopt_no" size="11" maxlength="10">～<input type="text" id="qryEopt_no" name="qryEopt_no" size="11" maxlength="10">
		        </td>
	        </tr>
	        <tr id=sin_no2 style="display:none">
		        <td class="lightbluetable" align="right">區所案件編號 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
			        <Select id="qryBranch" name="qryBranch"></Select>
			        <input type="text" id="qryBSeq" name="qryBSeq" size="5" maxLength="5">-<input type="text" id="qryBSeq1" name="qryBSeq1" size="1" maxLength="1">
		        </td>
	        </tr>
	        <tr>
		        <td class="lightbluetable" align="right">分案日期 :</td>
		        <td class="whitetablebg" align="left" colspan="3">
		        <input type="text" id="qrySin_date" name="qrySin_date" size="10" maxLength="10">～
		        <input type="text" id="qryEin_date" name="qryEin_date" size="10" maxLength="10">
		        <label><input type="checkbox" id=qrydtDATE name=qrydtDATE value="N">不指定</label>
		        </td>
	        </tr>
        </table>
        <table id="tabBtn" border="0" width="100%" cellspacing="0" cellpadding="0" align="center">
	        <tr><td width="100%" align="center">
			    <input type="button" value="查　詢" class="cbutton" id="btnSrch" name="btnSrch">
			    <input type="button" value="重　填" class="cbutton" id="btnRest" name="btnRest">
	        </td></tr>
        </table>
        <br>
        <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>
    </div>

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
	<font color="red">=== 目前無資料 ===</font>
</div>

<table style="display:none" border="0" class="bluetable" cellspacing="1" cellpadding="2" width="98%" align="center" id="dataList">
	<thead>
      <Tr>
	    <td class="lightbluetable" nowrap align="center">作業</td>
	    <td class="lightbluetable" nowrap align="center">案件編號</td>
	    <td class="lightbluetable" nowrap align="center">區所案件編號</td>
	    <td class="lightbluetable" nowrap align="center">申請人</td> 
	    <td class="lightbluetable" nowrap align="center">案件名稱</td> 
	    <td class="lightbluetable" nowrap align="center">案性</td> 
	    <td class="lightbluetable" nowrap align="center">分案日期</td> 
     </tr>
	</thead>
	<tfoot style="display:none">
	<tr class='{{tclass}}' id='tr_data_{{nRow}}'>
		<td align="center" nowrap>
            <span id="tr_rpt_{{nRow}}">
			    <a href="../opt_print/Print_{{reportp}}.aspx?opt_sqlno={{opt_sqlno}}&opt_no={{opt_no}}&branch={{Branch}}&case_no={{Case_no}}&arcase={{arcase}}&prgid={{prgid}}" target="Eblank">[列印]</a>
            </span>
		</td>
		<td align="center"><a href='{{urlasp}}' target='Eblank'>{{opt_no}}</a></td>
		<td align="center"><a href='{{urlasp}}' target='Eblank'>{{fseq}}</a></td>
		<td align="center"><a href='{{urlasp}}' target='Eblank'>{{ap_cname}}</a></td>
		<td align="center"><a href='{{urlasp}}' target='Eblank'>{{appl_name}}</a></td>
		<td align="center"><a href='{{urlasp}}' target='Eblank'>{{arcase_name}}</a></td>
		<td align="center"><a href='{{urlasp}}' target='Eblank'>{{opt_in_date}}</a></td>
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
            window.parent.tt.rows = "100%,0%";
        }

        $("#qryArcase").getOption({//承辦案性
            url: getRootPath() + "/ajax/JsonGetSqlDataBranch.aspx",
            data:{branch:"K",sql:"select RS_code, RS_detail from code_br where (dept = 'T') AND (cr = 'Y') And no_code='N' and mark='B' and prt_code is not null order by rs_class"},
            valueFormat: "{RS_code}",
            textFormat: "{RS_code}---{RS_detail}"
        });

        $("#qryPR_SCODE").getOption({//承辦
            url: getRootPath() + "/ajax/LookupDataCnn.aspx?type=GetPrScode&submitTask=U",
            valueFormat: "{scode}",
            textFormat: "{scode}-{sc_name}",
        });

        $("#qryBranch").getOption({//區所別
            url: getRootPath() + "/ajax/JsonGetSqlDataCnn.aspx",
            data:{sql:"select branch,branchname from branch_code where mark='Y' and branch<>'J' order by sort"},
            valueFormat: "{branch}",
            textFormat: "{branch}_{branchname}"
        });

        $("input.dateField").datepick();
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",false).triggerHandler("click");//☑測試

        $("#tabBtn").showFor((<%#HTProgRight%> & 6)).find("input").prop("checked",true);//[查詢][重填]

        this_init();
    });

    function this_init(){
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "100%,0%";
        }

        $("#qrySin_date").val((new Date()).format("yyyy/M/1"));
        $("#qryEin_date").val((new Date()).format("yyyy/M/d"));
        $("input[name='qryno_type']").triggerHandler("click");//序號選擇:案件編號
    }

    //[查詢]
    $("#btnSrch").click(function (e) {
        if($("input[name='qryno_type']:checked").val()=="Bseq_no"){
            if ($("#qryBranch").val()==""){
                alert("請輸入區所別!!!");
                $("#qryBranch").focus();
                return false;
            }

            if ($("#qryBSeq").val()==""){
                alert("請輸入區所案件編號!!!");
                $("#qryBSeq").focus();
                return false;
            }
        }else if($("input[name='qryno_type']:checked").val()=="opt_no"){
            if ($("#qrySopt_no").val()!=""){
                if(!isNumeric($("#qrySopt_no").val())){
                    alert("案件編號(起)錯誤,請重新輸入!!!");
                    $("#qrySopt_no").focus();
                    return false;
                }
            }
            if ($("#qryEopt_no").val()!=""){
                if(!isNumeric($("#qryEopt_no").val())){
                    alert("案件編號(迄)錯誤,請重新輸入!!!");
                    $("#qryEopt_no").focus();
                    return false;
                }
            }
            if ($("#qrySopt_no").val()!="" &&$("#qryEopt_no").val()!="" ){
                if($("#qrySopt_no").val()>$("#qryEopt_no").val()){
                    alert("案件編號(起),不得大於案件編號(迄)");
                    return false;
                }
            }
        }

        $("#GoPage").val("1");
        goSearch();
    });

    //[重填]
    $("#btnRest").click(function (e) {
        reg.reset();
        this_init();
    });

    //執行查詢
    function goSearch() {
        window.parent.tt.rows = '100%,0%';
        $("#divPaging,#noData,#dataList").hide();
        $("#dataList>tbody tr").remove();
        nRow = 0;
        $.ajax({
            url: "<%#HTProgPrefix%>_list.aspx",
            type: "get",
            async: false,
            cache: false,
            data: $("#reg").serialize(),
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                if (JSONdata.totrow===undefined) {
                    toastr.error("資料載入失敗（" + JSONdata.msg + "）");
                    return false;
                }
                if($("#chkTest").prop("checked"))toastr.info("<a href='" + this.url + "' target='_new'>Debug！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
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
                $("#id-div-slide").slideUp("fast");

                $("#count").val(JSONdata.pagedtable.length);
                $.each(JSONdata.pagedtable, function (i, item) {
                    nRow++;
                    //複製一筆
                    $("#dataList>tfoot").each(function (i) {
                        var strLine1 = $(this).html().replace(/##/g, nRow);
                        var tclass = "";
                        if (nRow % 2 == 1) tclass = "sfont9"; else tclass = "lightbluetable3";
                        strLine1 = strLine1.replace(/{{tclass}}/g, tclass);
                        strLine1 = strLine1.replace(/{{nRow}}/g, nRow);

                        strLine1 = strLine1.replace(/{{opt_no}}/g, item.opt_no);
                        strLine1 = strLine1.replace(/{{fseq}}/g, item.fseq);
                        strLine1 = strLine1.replace(/{{ap_cname}}/g, item.optap_cname);
                        strLine1 = strLine1.replace(/{{appl_name}}/g, item.appl_name);
                        strLine1 = strLine1.replace(/{{arcase_name}}/g, item.arcase_name);
                        strLine1 = strLine1.replace(/{{opt_in_date}}/g, dateReviver(item.opt_in_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{opt_sqlno}}/g, item.opt_sqlno);
                        strLine1 = strLine1.replace(/{{Case_no}}/g, item.case_no);
                        strLine1 = strLine1.replace(/{{Branch}}/g, item.branch);
                        strLine1 = strLine1.replace(/{{arcase}}/g, item.arcase);
                        strLine1 = strLine1.replace(/{{reportp}}/g, item.reportp);
                        strLine1 = strLine1.replace(/{{prgid}}/g, $("#prgid").val());

                        var urlasp="";
                        if(item.case_no!=""){
                            urlasp="../opt3m/opt31Edit.aspx?opt_sqlno="+item.opt_sqlno+"&opt_no="+item.opt_no+"&branch="+item.branch+"&case_no="+item.case_no+"&arcase="+item.arcase+"&prgid="+$("#prgid").val()+"&Submittask=Q"
                        }else{
                            urlasp="../opt3m/opt31EditA.aspx?opt_sqlno="+item.opt_sqlno+"&opt_no="+item.opt_no+"&branch="+item.branch+"&arcase="+item.arcase+"&prgid="+$("#prgid").val()+"&Submittask=Q"
                        }
                        strLine1 = strLine1.replace(/{{urlasp}}/g, urlasp);

                        $("#dataList>tbody").append(strLine1);
                        $("#tr_rpt_"+nRow).showFor(item.reportp!="");
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
    //重新整理
    $(".imgRefresh").click(function (e) {
        goSearch();
    });
    //查詢條件
    $(".imgQry").click(function (e) { $("#id-div-slide").slideToggle("fast"); });
    //關閉視窗
    $(".imgCls").click(function (e) {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "100%,0%";
        } else {
            window.close();
        }
    });

    //////////////////////
    //序號選擇
    $("input[name='qryno_type']").click(function () {
        $("#sin_no1,#sin_no2").hide();
        if($(this).val()=="opt_no"){
            $("#sin_no1").show();
            $("#qryBSeq1").val("");
        }else{
            $("#sin_no2").show();
            $("#qryBSeq1").val("_");
        }
    });

    //日期不指定
    $("#qrydtDATE").click(function () {
        if($(this).prop("checked")){
            $("#qrySin_date").val("");
            $("#qryEin_date").val("");
        }else{
            $("#qrySin_date").val((new Date()).format("yyyy/M/1"));
            $("#qryEin_date").val((new Date()).format("yyyy/M/d"));
        }
    }); 
  
    $("#qrySin_date,#qryEin_date").blur(function (e) {
        ChkDate($(this)[0]);
    });

    $("#qryBSeq").blur(function (e) {
        chkNum1($(this)[0], "區所案件編號");
    });

    $("#qrySopt_no,#qryEopt_no").blur(function (e) {
        chkNum1($(this)[0], "案件編號");
    });
</script>
