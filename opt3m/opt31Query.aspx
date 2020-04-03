<%@ Page Language="C#" CodePage="65001"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opt31";//程式檔名前綴
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected int HTProgRight = 0;

    protected string qryPr_scode = "";
    
    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        Token myToken = new Token(prgid);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            QueryPageLayout();
            this.DataBind();
        }
    }
    
    private void QueryPageLayout() {
        if((HTProgRight & 128)!=0){
            qryPr_scode="";
        } else{
            qryPr_scode = Sys.GetSession("scode");
        }
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
</head>

<body>
<table cellspacing="1" cellpadding="0" width="98%" border="0" align="center">
    <tr>
        <td class="text9" nowrap="nowrap">&nbsp;【<%#prgid%><%#HTProgCap%>‧<b style="color:Red">尚未結辦清單</b>】</td>
        <td class="FormLink" valign="top" align="right" nowrap="nowrap">
            <!--<a class="imgQry" href="javascript:void(0);" >[查詢條件]</a>&nbsp;-->
		    <a class="imgRefresh" href="javascript:void(0);" >[重新整理]</a>
        </td>
    </tr>
    <tr>
        <td colspan="2"><hr class="style-one"/></td>
    </tr>
</table>

<form id="reg" name="reg" method="post" action="<%#HTProgPrefix%>List.aspx">
    <input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">

    <div id="id-div-slide">
        <table border="0" cellspacing="1" cellpadding="2" width="98%" align="center">
        <tr>
	        <td class="text9">
		        ◎承辦人員:<Select id="qryPr_scode" name="qryPr_scode"></Select>	
	        </td>
	        <td class="text9">
		        ◎案件編號:
			        <input type="text" name="qryopt_no" id="qryopt_no" size="10" maxLength="10">
	        </td>
	        <td class="text9">
		        ◎區所案件編號:
			    <Select id="qryBranch" name="qryBranch"></Select>
			    <input type="text" name="qryBSeq" id="qryBSeq" size="5" maxLength="5">-<input type="text" name="qryBSeq1" id="qryBSeq1" size="1" maxLength="1">
	        </td>
	        <td class="text9">
		        ◎排序: <select id="qryOrder" name="qryOrder">
			            <option value="">請選擇</option>
			            <option value="confirm_date" selected>收文日期</option>
			            <option value="in_date desc">分案日期</option>
			            <option value="ctrl_date">承辦期限</option>
			            <option value="last_date">法定期限</option>
			            <option value="opt_no">案件編號</option>
			        </select>
	        </td>
	        <td class="text9">
		        <input type="button" id="btnSrch" value ="查詢" class="cbutton" />
	        </td>
        </tr>	
        </table>
    </div>
    <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>

    <div id="divPaging" style="display:none">
    <TABLE border=0 cellspacing=1 cellpadding=0 width="98%" align="center">
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
	    <td class="lightbluetable" nowrap align="center">案件編號</td>
	    <td class="lightbluetable" nowrap align="center">區所案件編號</td>
	    <td class="lightbluetable" nowrap align="center">申請人</td> 
	    <td class="lightbluetable" nowrap align="center">案件名稱</td> 
	    <td class="lightbluetable" nowrap align="center">案性</td> 
	    <td class="lightbluetable" nowrap align="center">分案日期</td> 
	    <td class="lightbluetable" nowrap align="center">承辦人</td> 
	    <td class="lightbluetable" nowrap align="center">收文日期</td>
	    <td class="lightbluetable" nowrap align="center">承辦期限</td> 
	    <td class="lightbluetable" nowrap align="center">法定期限</td>
	    <td class="lightbluetable" nowrap align="center">作業</td>
     </tr>
	</thead>
	<tfoot style="display:none">
	<tr class='{{tclass}}' id='tr_data_{{nRow}}'>
		<td align="center">
            <span id="todoBack_{{nRow}}">
                <a href="../opt3m/opt31todo.aspx?Case_no={{Case_no}}&Branch={{Branch}}&prgid=<%=prgid%>&opt_sqlno={{opt_sqlno}}&fseq={{fseq}}&scode_name={{scode_name}}" title="查詢退回紀錄" target="Eblank">
                    <img src="../images/alarm.gif" style="cursor:pointer" align="absmiddle" border="0">
                </a>
            </span>{{opt_no}}
		</td>
		<td align="center">{{fseq}}</td>
		<td>{{ap_cname}}</td>
		<td>{{appl_name}}</td>
		<td nowrap>{{arcase_name}}</td>
		<td align="center">{{opt_in_date}}</td>
		<td align="center">{{pr_scode_name}}</td>
		<td align="center">{{confirm_date}}</td>
		<td align="center">{{ctrl_date}}</td>
		<td align="center">{{last_date}}</td>
		<td align="center" nowrap>
            <span id="tr_edit_{{nRow}}">
			    <a href="<%#HTProgPrefix%>Edit.aspx?opt_sqlno={{opt_sqlno}}&opt_no={{opt_no}}&branch={{Branch}}&case_no={{Case_no}}&arcase={{arcase}}&prgid=opt31" target="Eblank">[承辦]</a><br>
			    <a href="<%#HTProgPrefix%>Edit.aspx?opt_sqlno={{opt_sqlno}}&opt_no={{opt_no}}&branch={{Branch}}&case_no={{Case_no}}&arcase={{arcase}}&prgid=opt31_1&End_flag=Y" target="Eblank">[結辦]</a><br>
			    <a href="<%#HTProgPrefix%>Edit.aspx?opt_sqlno={{opt_sqlno}}&opt_no={{opt_no}}&branch={{Branch}}&case_no={{Case_no}}&arcase={{arcase}}&prgid=opt31&Back_flag=B" target="Eblank">[退回]</a>
            </span>
            <span id="tr_editA_{{nRow}}">
			    <a href="<%#HTProgPrefix%>EditA.aspx?opt_sqlno={{opt_sqlno}}&opt_no={{opt_no}}&branch={{Branch}}&arcase={{arcase}}&prgid=opt31" target="Eblank">[承辦]</a><br>
			    <a href="<%#HTProgPrefix%>EditA.aspx?opt_sqlno={{opt_sqlno}}&opt_no={{opt_no}}&branch={{Branch}}&arcase={{arcase}}&prgid=opt31_1&End_flag=Y" target="Eblank">[結辦]</a><br>
			    <a href="<%#HTProgPrefix%>EditA.aspx?opt_sqlno={{opt_sqlno}}&opt_no={{opt_no}}&branch={{Branch}}&arcase={{arcase}}&prgid=opt31&Back_flag=B" target="Eblank">[退回]</a>
            </span>
		</td>
	</tr>
	</tfoot>
	<tbody>
	</tbody>
</TABLE>
<br>
備註:<br>
1.案件編號前的「<img src="../images/alarm.gif" style="cursor:pointer" align="absmiddle"  border="0" WIDTH="14" HEIGHT="11">」表示被<font color="red">退回</font>狀態，可按下該圖示查詢相關退回紀錄

</body>
</html>


<script language="javascript" type="text/javascript">
    $(document).ajaxStart(function () { $.maskStart("資料載入中"); });
    $(document).ajaxStop(function () { $.maskStop(); });

    $("#qryPr_scode").getOption({//爭議組承辦人員
        url: "../ajax/LookupDataCnn.aspx?type=GetPrScode",
        valueFormat: "{scode}",
        textFormat: "{scode}_{sc_name}"
    })

    $("#qryBranch").getOption({//區所別
        url: "../ajax/_GetSqlDataCnn.aspx",
        data:{sql:"select branch,branchname from branch_code where mark='Y' and branch<>'J' order by sort"},
        valueFormat: "{branch}",
        textFormat: "{branch}_{branchname}"
    });

    $(function () {
        $("input.dateField").datepick();
        //get_ajax_selection("select branch,branchname from branch_code where mark='Y' and branch<>'J' order by sort")
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",true);//☑測試

        $("#btnSrch").click();
    });

    //[查詢]
    $("#btnSrch").click(function (e) {
        $("#dataList>thead tr .setOdr span").remove();
        $("#SetOrder").val("");

        goSearch();
    });

    //執行查詢
    function goSearch() {
        window.parent.tt.rows = '100%,0%';
        $("#divPaging,#noData,#dataList").hide();
        $("#dataList>tbody tr").remove();
        nRow = 0;

        $.ajax({
            url: "<%#HTProgPrefix%>List.aspx",
            type: "get",
            async: false,
            cache: false,
            data: $("#reg").serialize(),
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                if (!JSONdata.totrow) {
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

                        strLine1 = strLine1.replace(/{{opt_no}}/g, item.opt_no);
                        strLine1 = strLine1.replace(/{{fseq}}/g, item.fseq);
                        strLine1 = strLine1.replace(/{{ap_cname}}/g, item.optap_cname);
                        strLine1 = strLine1.replace(/{{appl_name}}/g, item.appl_name);
                        strLine1 = strLine1.replace(/{{arcase_name}}/g, item.arcase_name);
                        strLine1 = strLine1.replace(/{{opt_in_date}}/g, dateReviver(item.opt_in_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{pr_scode_name}}/g, item.pr_scode_name);
                        strLine1 = strLine1.replace(/{{confirm_date}}/g, dateReviver(item.confirm_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{ctrl_date}}/g, dateReviver(item.ctrl_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{last_date}}/g, dateReviver(item.last_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{opt_sqlno}}/g, item.opt_sqlno);
                        strLine1 = strLine1.replace(/{{Case_no}}/g, item.case_no);
                        strLine1 = strLine1.replace(/{{Branch}}/g, item.branch);
                        strLine1 = strLine1.replace(/{{arcase}}/g, item.arcase);
                        strLine1 = strLine1.replace(/{{scode_name}}/g, item.scode_name);

                        $("#dataList>tbody").append(strLine1);
                        $("#todoBack_" + nRow).showFor(item.bstat_code.Right(1) == "X");
                        $("#tr_edit_"+nRow).showFor(item.case_no!="");
                        $("#tr_editA_" + nRow).showFor(item.case_no == "");
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
</script>
