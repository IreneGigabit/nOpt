<%@ Page Language="C#" CodePage="65001"%>

<%@ Register Src="~/commonForm/chkTest.ascx" TagPrefix="uc1" TagName="chkTest" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opta12";//程式檔名前綴
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
        <td class="text9" nowrap="nowrap">&nbsp;【<%#prgid%> <%#HTProgCap%>】</td>
        <td class="FormLink" valign="top" align="right" nowrap="nowrap">
            <a class="imgQry" href="javascript:void(0);" >[查詢條件]</a>&nbsp;
		    <a class="imgRefresh" href="javascript:void(0);" >[重新整理]</a>
            <a class="imgAdd" href="optA12edit.aspx?submitTask=A&prgid=<%=prgid%>&prgname=<%#HTProgCap%>" target="Eblank">[新增]</a>
        </td>
    </tr>
    <tr>
        <td colspan="2"><hr class="style-one"/></td>
    </tr>
</table>

<form id="reg" name="reg" method="post" action="<%#HTProgPrefix%>List.aspx">
    <input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">

    <div id="id-div-slide">
        <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="90%" align="center">	
	    <tr>
	        <td class="lightbluetable" align="right" nowrap>
                北京案號 :
            </td>
                <td class="whitetablebg" align="left" nowrap>
                <Select name="qry_BJTbranch">
				    <option value="" selected>請選擇</option>
　                   <option value="BJT">BJT</option>
　                   <option value="BJTI">BJTI</option>
			    </Select>                                      
                -<INPUT TYPE=text NAME=qry_BJTSeq SIZE=5 MAXLENGTH=5  value="" />
                -<INPUT TYPE=text NAME=qry_BJTSeq1 SIZE=3 MAXLENGTH=3 value="" >
            </td>
            <td class="lightbluetable" align="right" nowrap>
                本所案號  :
            </td>
                <td class="whitetablebg" align="left" nowrap>
                <Select name="qry_branch">
				    <option value="" selected>請選擇</option>
　                   <option value="NT">NT</option>
　                   <option value="CT">CT</option>
　                   <option value="ST">ST</option>
　                   <option value="KT">KT</option>
　                   <option value="NTE">NTE</option>
　                   <option value="CTE">CTE</option>
　                   <option value="STE">STE</option>
　                   <option value="KTE">KTE</option>
			    </Select> 
                -<INPUT TYPE=text NAME="qry_BSeq" SIZE=5 MAXLENGTH=5  value="" />
                -<INPUT TYPE=text NAME="qry_BSeq1" SIZE=3 MAXLENGTH=3 value="" >
            </td>
	    </tr>
	    <tr>
		    <TD class=lightbluetable align=right nowrap>爭救案例流水號：</TD>
		    <TD class=whitetablebg align=left nowrap colspan="" >
			    <input type="text" name='qry_opt_no' value='' size="30" maxLength="30" >
		    </td>
		    <TD class=lightbluetable align=right nowrap>判決/決定文號：</TD>
		    <TD class=whitetablebg align=left nowrap>
			    <input type="text" name='qry_pr_no'  value='' size="30" maxLength="30" >
		    </td> 		
	    </tr>
	    <tr>
	        <td class="lightbluetable" align="right">判決/決定日期 :</td>
		    <td class="whitetablebg" align="left" colspan="3">
			    <input type="text" name="qry_pr_date_B" size="10" maxLength="10" class="dateField">
			    <input type="text" name="qry_pr_date_E" size="10" maxLength="10" class="dateField">
			    <label><INPUT type="checkbox" name="No_date" value="Y" checked>不指定</label>
            </td>
        </tr>	
	    <tr>		
		    <TD class=lightbluetable align=right nowrap>成立狀態：</TD>
		    <TD class=whitetablebg align=left nowrap >
			    <label><input type="radio" name='qry_opt_comfirm' value='1' >全部成立</label>
	            <label><input type="radio" name='qry_opt_comfirm' value='2' >部分成立</label>
	            <label><input type="radio" name='qry_opt_comfirm' value='3' >全部不成立</label>
	            <label><input type="radio" name='qry_opt_comfirm' checked value='' >不指定</label>
		    </td> 
		    <TD class=lightbluetable align=right nowrap>生效狀態：</TD>
		    <TD class=whitetablebg align=left nowrap>
			    <label><input type="radio" name='qry_opt_check' value='1' >確定已生效</label>
	            <label><input type="radio" name='qry_opt_check' value='2' >確定被推翻</label>
	            <label><input type="radio" name='qry_opt_check' value='3' >救濟中或尚未能確定</label>
	            <label><input type="radio" name='qry_opt_check' checked value='' >不指定</label>
		    </td>
	    </tr>
    </table>
    <table border="0" width="100%" cellspacing="0" cellpadding="0">
        <tr>
            <td width="100%" align="center">
            <input type="button" value="查　詢" class="cbutton" onClick="formSearchSubmit()">
            <input type="button" value="重　填" class="cbutton" onClick="resetForm()">
            </td>
        </tr>
    </table>
    <br>
    <!--label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label-->
    <uc1:chkTest runat="server" ID="chkTest" />
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
		<td class="lightbluetable" align="center" nowrap>北京案號</td>
		<td class="lightbluetable" align="center" nowrap>類別</td>
		<td class="lightbluetable" align="center" nowrap>商標圖樣</td>
		<td class="lightbluetable" align="center" nowrap>裁決要旨</td>
		<td class="lightbluetable" align="center" nowrap>條款成立狀態/<BR>裁決生效狀態</td>
		<td class="lightbluetable" align="center" nowrap>引用條文法規</td>
		<td class="lightbluetable" align="center" nowrap>判決/決定日期</td>
		<td class="lightbluetable" align="center" nowrap>作業</td>
        </tr>
	</thead>
	<tfoot style="display:none">
	    <tr class='{{tclass}}' id='tr_data_{{nRow}}'>
            <td nowrap align=left >{{BJTseq}}</td>
		    <td nowrap align=left title="{{opt_class_name}}" >{{opt_class}}</td>
		    <td nowrap align="left">
                <input type="hidden" id="opt_pic_path_{{nRow}}" value="{{opt_pic_path}}" />
               <span id="opt_pic_A_{{nRow}}" onclick="attach_click('{{nRow}}')" style="cursor: pointer;" onmouseover="this.style.color='red'" onmouseout="this.style.color='black'">
                   {{opt_pic}}<img src="../images/annex.gif" title="{{opt_pic_path}}" >
               </span>
               <span id="opt_pic_B_{{nRow}}">{{opt_pic}}</span>
		    </td>
		    <td nowrap align=left title="{{opt_point}}">{{opt_point}}</td>
            <td nowrap align=left >{{opt_comfirm_str}}/<br>{{opt_check_str}}</td>
		    <td nowrap align=left >{{law_detail_no}}</td>	
		    <td nowrap align=left >{{pr_date}}</td>	
		    <td nowrap align="center">
		        <a href="optA12edit.aspx?prgid=<%=prgid%>&submitTask=Q&opt_no={{opt_no}}&prgname=<%#HTProgCap%>" target="Eblank">[檢視]</a>
		        <a href="optA12edit.aspx?prgid=<%=prgid%>&submitTask=U&opt_no={{opt_no}}&prgname=<%#HTProgCap%>" target="Eblank">[維護]</a>
		    </td>
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

        $(".imgAdd").showFor((<%#HTProgRight%> & 4));//[新增]

        $("input.dateField").datepick();
        $(".Lock").lock();
        //$("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",false).triggerHandler("click");//☑測試
    });

    //[重填]
    function resetForm(){
        reg.reset();
    }

    //[查詢]
    function formSearchSubmit() {
        $("#dataList>thead tr .setOdr span").remove();
        $("#SetOrder").val("");

        goSearch();
    }

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

                        strLine1 = strLine1.replace(/{{BJTseq}}/g, item.fbjtseq);
                        strLine1 = strLine1.replace(/{{opt_class_name}}/g, item.opt_class_name);
                        strLine1 = strLine1.replace(/{{opt_class}}/g, item.opt_class);
                        strLine1 = strLine1.replace(/{{opt_pic_path}}/g, item.opt_pic_path);
                        strLine1 = strLine1.replace(/{{opt_pic}}/g, item.opt_pic);
                        strLine1 = strLine1.replace(/{{opt_point}}/g, item.opt_point.CutData(30));
                        strLine1 = strLine1.replace(/{{opt_comfirm_str}}/g, item.opt_comfirm_str);
                        strLine1 = strLine1.replace(/{{opt_check_str}}/g, item.opt_check_str);
                        strLine1 = strLine1.replace(/{{law_detail_no}}/g, item.law_detail_no);
                        strLine1 = strLine1.replace(/{{branch}}/g, item.branch);
                        strLine1 = strLine1.replace(/{{pr_date}}/g, dateReviver(item.pr_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{opt_no}}/g, item.opt_no);

                        $("#dataList>tbody").append(strLine1);
                        if(item.opt_pic_path!=""){
                            $("#opt_pic_A_"+nRow).show();
                            $("#opt_pic_B_"+nRow).hide();
                        }else{
                            $("#opt_pic_A_"+nRow).hide();
                            $("#opt_pic_B_"+nRow).show();
                        }
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
    function attach_click(pno){
        var url=$("#opt_pic_path_"+pno).val();
        window.open(url,"","width=1000 height=600 top=40 left=80 toolbar=no, menubar=yes, location=no, directories=no resizable=yes status=no scrollbars=yes");
    }
</script>
