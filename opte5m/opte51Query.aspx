<%@ Page Language="C#" CodePage="65001"%>

<%@ Register Src="~/commonForm/chkTest.ascx" TagPrefix="uc1" TagName="chkTest" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opte51";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        chkTest.HTProgRight = HTProgRight;
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
        <td class="text9" nowrap="nowrap">&nbsp;【<%#prgid%> <%#HTProgCap%>‧<b style="color:Red">未確認清單</b>】</td>
        <td class="FormLink" valign="top" align="right" nowrap="nowrap">
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
		        ◎案件編號:
			        <input type="text" name="qryopt_no" id="qryopt_no" size="11" maxLength="10">
	        </td>
	        <td class="text9">
		        ◎區所案件編號:
			    <Select id="qryBranch" name="qryBranch"></Select>
			    <input type="text" name="qryBSeq" id="qryBSeq" size="5" maxLength="5">-<input type="text" name="qryBSeq1" id="qryBSeq1" size="1" maxLength="1">
	        </td>
	        <td class="text9">
		        ◎交辦註銷日期:
                <input type="text" name="qryinput_dateS" id="qryinput_dateS" class="dateField" value="" size="10" /> ~
                <input type="text" name="qryinput_dateE" id="qryinput_dateE" class="dateField" value="" size="10" />
	        </td>
	        <td class="text9">
		        <input type="button" id="btnSrch" value ="查詢" class="cbutton" />
	        </td>
        </tr>	
        </table>
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

    <div align="center" id="noData" style="display:none">
	    <font color="red">=== 目前無資料 ===</font>
    </div>

    <input type="hidden" id="count" name="count">
    <input type="hidden" id="submittask" name="submittask">
    <table style="display:none" border="0" class="bluetable" cellspacing="1" cellpadding="2" width="98%" align="center" id="dataList">
	    <thead>
          <Tr>
	        <td class="lightbluetable" nowrap align="center"></td>
	        <td class="lightbluetable" nowrap align="center">案件編號</td>
	        <td class="lightbluetable" nowrap align="center">區所案件編號</td>
	        <td class="lightbluetable" nowrap align="center">洽案營洽</td>
	        <td class="lightbluetable" nowrap align="center">申請人</td> 
	        <td class="lightbluetable" nowrap align="center">案件名稱</td> 
	        <td class="lightbluetable" nowrap align="center">承辦人</td> 
	        <td class="lightbluetable" nowrap align="center">法定期限</td>
	        <td class="lightbluetable" nowrap align="center">判行日期</td> 
	        <td class="lightbluetable" nowrap align="center">交辦註銷日期</td>
         </tr>
	    </thead>
	    <tfoot style="display:none">
	    <tr class='{{tclass}}' id='tr_data_{{nRow}}'>
            <td align="center" rowspan="2"><input type=checkbox id="BT" name="B{{nRow}}" value="Y"></td>
		    <td align="center"><a href='{{urlasp}}' target='Eblank'>{{opt_no}}</a></td>
		    <td align="center"><a href='{{urlasp}}' target='Eblank'>{{fseq}}</a> </td>
		    <td><a href='{{urlasp}}' target='Eblank'>{{in_scode}}</a></td>
		    <td><a href='{{urlasp}}' target='Eblank'>{{optap_cname}}</a></td>
		    <td><a href='{{urlasp}}' target='Eblank'>{{appl_name}}</a></td>
		    <td align="center"><a href='{{urlasp}}' target='Eblank'>{{pr_scode_name}}</a></td>
		    <td align="center"><a href='{{urlasp}}' target='Eblank'>{{ctrl_date}}</a></td>
		    <td align="center"><a href='{{urlasp}}' target='Eblank'>{{ap_date}}</a></td>
		    <td align="center"><a href='{{urlasp}}' target='Eblank'>{{input_date}}</a>
		        <input type="hidden" id="branch{{nRow}}" name="branch{{nRow}}" value="{{branch}}">
		        <input type="hidden" id="bseq{{nRow}}" name="bseq{{nRow}}" value="{{bseq}}">
		        <input type="hidden" id="bseq1_{{nRow}}" name="bseq1_{{nRow}}" value="{{bseq1}}">
		        <input type="hidden" id="opt_sqlno{{nRow}}" name="opt_sqlno{{nRow}}">
		        <input type="hidden" id="sqlno{{nRow}}" name="sqlno{{nRow}}" value="{{opt_sqlno}}">
		        <input type="hidden" id="input_scode{{nRow}}" name="input_scode{{nRow}}" value="{{input_scode}}">
		        <input type="hidden" id="Pin_scode{{nRow}}" name="Pin_scode{{nRow}}" value="{{in_scode}}">
		        <input type="hidden" id="in_scode{{nRow}}" name="in_scode{{nRow}}" value="">
		        <input type="hidden" id="case_no{{nRow}}" name="case_no{{nRow}}" value="{{case_no}}">
		        <input type="hidden" id="cancel_sqlno{{nRow}}" name="cancel_sqlno{{nRow}}" value="{{cancel_sqlno}}">
		        <input type="hidden" id="todo_sqlno{{nRow}}" name="todo_sqlno{{nRow}}" value="{{todo_sqlno}}">
		    </td>
	    </tr>
	    <tr>
		    <td class="whitetablebg" align="right">註銷原因：</td>
		    <td class="whitetablebg" align="left" colspan="8">{{creason}}</td>
	    </tr>
	    </tfoot>
	    <tbody>
	    </tbody>
    </TABLE>
    <br>
    <!--label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label-->
    <uc1:chkTest runat="server" ID="chkTest" />
    <table border="0" width="98%" cellspacing="0" cellpadding="0" align="center">
        <tr>
            <td width="100%" align="center">     
		        <input type=button value="專案室抽件確認" class="cbutton" id="btnSubmit" name="btnSubmit">
            </td>
        </tr>
    </table>
    </form>

    <iframe id="ActFrame" name="ActFrame" src="about:blank" width="100%" height="500" style="display:none"></iframe>
</body>
</html>


<script language="javascript" type="text/javascript">
    $(function () {
        $("#qryBranch").getOption({//區所別
            url: getRootPath() + "/ajax/JsonGetSqlDataCnn.aspx",
            data:{sql:"select branch,branchname from branch_code where mark='Y' and branch<>'J' order by sort"},
            valueFormat: "{branch}",
            textFormat: "{branch}_{branchname}"
        });

        $("input.dateField").datepick();
        //$("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",false).triggerHandler("click");//☑測試
        //$("#chkTest").click(function (e) {
        //    $("#ActFrame").showFor($(this).prop("checked"));
        //});

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
                //$("#id-div-slide").slideUp("fast");

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
                        strLine1 = strLine1.replace(/{{in_scode}}/g, item.in_scode);
                        strLine1 = strLine1.replace(/{{optap_cname}}/g, item.optap_cname);
                        strLine1 = strLine1.replace(/{{appl_name}}/g, item.appl_name);
                        strLine1 = strLine1.replace(/{{arcase_name}}/g, item.arcase_name);
                        strLine1 = strLine1.replace(/{{ctrl_date}}/g, dateReviver(item.ctrl_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{pr_scode_name}}/g, item.pr_scode_name);
                        strLine1 = strLine1.replace(/{{last_date}}/g, dateReviver(item.last_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{ap_date}}/g, dateReviver(item.ap_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{input_date}}/g, dateReviver(item.input_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{input_scode}}/g, "");
                        strLine1 = strLine1.replace(/{{in_scode}}/g, item.in_scode);
                        strLine1 = strLine1.replace(/{{opt_sqlno}}/g, item.opt_sqlno);
                        strLine1 = strLine1.replace(/{{case_no}}/g, item.case_no);
                        strLine1 = strLine1.replace(/{{branch}}/g, item.branch);
                        strLine1 = strLine1.replace(/{{bseq}}/g, item.bseq);
                        strLine1 = strLine1.replace(/{{bseq1}}/g, item.bseq1);
                        strLine1 = strLine1.replace(/{{arcase}}/g, item.arcase);
                        strLine1 = strLine1.replace(/{{creason}}/g, item.creason);
                        strLine1 = strLine1.replace(/{{cancel_sqlno}}/g, item.cancel_sqlno);
                        strLine1 = strLine1.replace(/{{todo_sqlno}}/g, item.todo_sqlno);

                        var urlasp="";
                        urlasp="../opte2m/opte22Edit.aspx?opt_sqlno="+item.opt_sqlno+"&opt_no="+item.opt_no+"&branch="+item.branch+"&case_no="+item.case_no+"&arcase="+item.arcase+"&prgid="+$("#prgid").val()+"&Submittask=Q"
                        strLine1 = strLine1.replace(/{{urlasp}}/g, urlasp);

                        $("#dataList>tbody").append(strLine1);
                        $("#maialIcon" + nRow).showFor(item.contract_flag=="Y");
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

    //發文確認
    $("#btnSubmit").click(function (e) {
        var errMsg = "";
        
        var check=$("input[id='BT']:checked").length;
        if (check==0){
            errMsg+="尚未選定!!\n";
        }

        if (errMsg!="") {
            alert(errMsg);
            return false;
        }

        for(var i=1;i<=parseInt($("#count").val(), 10);i++){
            if($("input[name='B"+i+"']").prop("checked")==true){
                $("#opt_sqlno"+i).val($("#sqlno"+i).val());
            }else{
                $("#opt_sqlno"+i).val("");
            }
        }
        $("btnSubmit").lock(!$("#chkTest").prop("checked"));
        reg.submittask.value="U";
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.target = "ActFrame";
        reg.submit();
    });

    $("#qryopt_no").blur(function (e) {
        chkNum1($(this)[0], "案件編號");
    });

    $("#qryBSeq").blur(function (e) {
        chkNum1($(this)[0], "區所案件編號");
    });

    $("#qryinput_dateS").blur(function (e) {
        ChkDate($("#qryinput_dateS")[0]);
    });
    $("#qryinput_dateE").blur(function (e) {
        ChkDate($("#qryinput_dateE")[0]);
    });

</script>
