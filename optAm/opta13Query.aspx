<%@ Page Language="C#" CodePage="65001"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opta13";//程式檔名前綴
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
            <a class="imgQry" href="javascript:void(0);" >[查詢條件]</a>&nbsp;
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
        <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="90%" align="center">	
	    <tr>
		    <TD class=lightbluetable align=right nowrap>爭救案例流水號：</TD>
		    <TD class=whitetablebg align=left nowrap colspan="" >
			    <input type="text" name='qry_opt_no' value='' size="30" maxLength="30" >
		    </td>
		    <td class="lightbluetable" align="right">類別 :</td>
		    <td class="whitetablebg" align="left">
			    <input type="text" name='qry_opt_class' value='' size="30" maxLength="30" >
		    </td>
	    </tr>
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
		    <TD class=lightbluetable align=right nowrap>判決/決定文號：</TD>
		    <TD class=whitetablebg align=left nowrap colspan=3 >
			    <input type="text" name='qry_pr_no'  value='' size="30" maxLength="30" >
		    </td> 		
	    </tr>	 		
	    <tr>		
		    <TD class=lightbluetable align=right nowrap>成立狀態：</TD>
		    <TD class=whitetablebg align=left nowrap >
			    <input type="radio" name='qry_opt_comfirm' value='1' >全部成立
	            <input type="radio" name='qry_opt_comfirm' value='2' >部分成立
	            <input type="radio" name='qry_opt_comfirm' value='3' >全部不成立
	            <input type="radio" name='qry_opt_comfirm' checked value='' >不指定
		    </td> 
		    <TD class=lightbluetable align=right nowrap>生效狀態：</TD>
		    <TD class=whitetablebg align=left nowrap>
			    <input type="radio" name='qry_opt_check' value='1' >確定已生效
	            <input type="radio" name='qry_opt_check' value='2' >確定被推翻
	            <input type="radio" name='qry_opt_check' value='3' >救濟中或尚未能確定
	            <input type="radio" name='qry_opt_check' checked value='' >不指定
		    </td>
	    </tr>
	    <tr>
	        <td class="lightbluetable" align="right">判決/決定日期 :</td>
		    <td class="whitetablebg" align="left" colspan="3">
			    <input type="text" name="qry_pr_date_B" size="10" maxLength="10" class="dateField">
			    <input type="text" name="qry_pr_date_E" size="10" maxLength="10" class="dateField">
			    <INPUT type="checkbox" name="No_date" value="Y" checked>不指定
            </td>
        </tr>	
	    <tr>
            <td class=lightbluetable width="17%" align="right">全文檢索欄位 : </td>
            <td class=whitetablebg colspan="3">
		        <INPUT type="checkbox" name="qry_opt_pic" value="Y">商標名稱
		        <INPUT type="checkbox" name="qry_cust_name" value="Y">客戶名稱
		        <INPUT type="checkbox" name="qry_opt_class_name" value="Y">商品
		        <INPUT type="checkbox" name="qry_opt_point" value="Y">判決要旨
		        <INPUT type="checkbox" name="qry_opt_mark" value="Y">關鍵字
            </td>
        </tr>
        <tr>
            <td class=whitetablebg align="center" colspan="4">
	    	    <table border=0 class=bluetable cellspacing=1 cellpadding=2 width="100%" id="tbwordA">
                    <thead>
	    	            <tr>
	    	              <td class=lightbluetable align="center" width="50%">
	    	                  [<input type=button value="條件新增" class="greenbutton" onclick="f_col('Add','in')">]
	    	                  [<input type=button value="條件減少" class="greenbutton" onclick="f_col('Del','in')">]
	    	              </td>
	    	              <td class=lightbluetable align="center">
	    	                  <strong><font color="green">包 含 條 件 輸 入</font></strong>
	    	               </td>
	    	            </tr>
                    </thead>
                    <tfoot style="display:none;">
                        <tr id="law_##">
                            <td class=lightbluetable align="center" style="color:green" id="td_wordA_##">
                                {{lawOR}}包含條件##
                            </td>
                            <td class=whitetablebg align="left">&nbsp;
                            內容:<input type=text size=10 name="f_wordA_##_1">
                            AND <input type=text size=10 name="f_wordA_##_2">
                            AND <input type=text size=10 name="f_wordA_##_3">
                            </td>
                        </tr>
                    </tfoot>
                    <tbody></tbody>
	    	    </table>
	        </td>
        </tr>
        <tr>
            <td class=whitetablebg align="center" colspan="4">
	    	    <table border=0 class=bluetable cellspacing=1 cellpadding=2 width="100%" id="tbwordB">
                    <thead>
	    	            <tr>
	    	              <td class=lightbluetable align="center" width="50%">
	    	                  [<input type=button value="條件新增" class="bluebutton" onclick="f_col('Add','not')">]
	    	                  [<input type=button value="條件減少" class="bluebutton" onclick="f_col('Del','not')">]
	    	              </td>
	    	              <td class=lightbluetable align="center">
	    	                  <strong><font color="red">不 包 含 條 件 輸 入</font></strong>
	    	              </td>
	    	            </tr>
                    </thead>
                    <tfoot style="display:none;">
                        <tr id="lawNot_##">
                            <td class=lightbluetable align="center" style="color:red" id="td_wordB_##">
                                {{lawOR}}不包含條件##
                            </td>
                            <td class=whitetablebg align="left">&nbsp;
                            內容:<input type=text size=10 name="f_wordB_##_1">
                            AND <input type=text size=10 name="f_wordB_##_2">
                            AND <input type=text size=10 name="f_wordB_##_3">
                            </td>
                        </tr>
                    </tfoot>
                    <tbody></tbody>
	    	    </table>
	        </td>
        </tr>
        <tr>
            <td class=whitetablebg align="center" colspan="4">
   	            <input type=hidden id=class_num name=class_num value=0><!--進度筆數-->
                <TABLE id=data_law border=0 class="bluetable"  cellspacing=1 cellpadding=2 width="100%">
                    <thead>
	                    <TR class=whitetablebg align=center>
		                    <TD colspan=2 align=right>
		        	          <input type=button value="增加法條搜尋" class="cbutton" id=Class_Add_button_law name=Class_Add_button_law>
		        	          <input type=button value="減少法條搜尋" class="cbutton" id=Class_Del_button_law name=Class_Del_button_law>
		                    </TD>
	                    </TR>
	                    <TR align=center class=lightbluetable>
		                    <TD width="25%"></TD><TD>相關法條檢索</TD>
	                    </TR>
                    </thead>
                    <tfoot style="display:none">
	                    <TR class=whitetablebg>
		                    <TD align="center">
		        	            <input type=text name='class_num_##' class="Lock" size=20 value='{{lawOR}}包含條件##.' style="text-align:right">
		                    </TD>
		                    <TD>
                                內容 ：<select id="law_type1_##" name="law_type1_##"></select>
                                AND ：<select id="law_type2_##" name="law_type2_##"></select>
                                AND ：<select id="law_type3_##" name="law_type3_##"></select>
		                    </TD>
	                    </TR>
                    </tfoot>
                    <tbody></tbody>
                </TABLE>
            </td>
        </tr>
    </table>
    <table border="0" width="100%" cellspacing="0" cellpadding="0">
        <tr>
            <td width="100%" align="center">
            <input type=text id="law_count" name="law_count" value="0">
	        <input type=text id="law_CNot" name="law_CNot" value="0">
            <input type="button" value="查　詢" class="cbutton" onClick="formSearchSubmit()">
            <input type="button" value="重　填" class="cbutton" onClick="resetForm()">
            </td>
        </tr>
    </table>

    </div>

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
		<td class="lightbluetable"nowrap>北京案號</td>
		<td class="lightbluetable"nowrap>類別</td>
		<td class="lightbluetable"nowrap>商標圖樣</td>
		<td class="lightbluetable"nowrap>裁決要旨</td>
		<td class="lightbluetable"nowrap>條款成立狀態/<BR>裁決生效狀態</td>
		<td class="lightbluetable"nowrap>引用條文法規</td>
		<td class="lightbluetable"nowrap>判決/決定日期</td>
		<td class="lightbluetable" nowrap>作業</td>
        </tr>
	</thead>
	<tfoot style="display:none">
	    <tr class='{{tclass}}' id='tr_data_{{nRow}}'>
            <td nowrap align=left >{{BJTseq}}</td>				
		    <td nowrap align=left title="{{opt_class_name}}" >{{opt_clas}}</td>
		    <td nowrap align="left" onclick="attach_click('{{opt_pic_path}}')" style="cursor: pointer;" onmouseover="this.style.color='red'" onmouseout="this.style.color='black'">
                {{opt_pic")}}<img src="../images/annex.gif" title="{{opt_pic_path}}" >
		    </td>
		    <td nowrap align=left title="{{opt_point}}">{{opt_point}}</td>
            <td nowrap align=left >{{opt_comfirm_string}}/<br>{{opt_check_string}}</td>
		    <td nowrap align=left >{{law_detail_no}}</td>	
		    <td nowrap align=left >{{pr_date}}</td>	
		    <td nowrap>
		        <a href="optA12edit.aspx?prgid=<%=prgid%>&submitTask=Q&opt_no={{opt_no}}>" target="Eblank">[檢視]</a>
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
        $("select[name='law_type1_##'],select[name='law_type2_##'],select[name='law_type3_##']").getOption({//法條搜尋內容
            url: getRootPath() + "/json/Law.aspx",
            data:{},
            valueFormat: "{law_sqlno}",
            textFormat: "{law_text}"
        });

        $("#Class_Add_button_law").click();
        //預設10個條件
        tbword_init();

        $("input.dateField").datepick();
        $(".Lock").lock();
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",false).triggerHandler("click");//☑測試
    });

    //[重填]
    function resetForm(){
        reg.reset();
        $("#law_count").val(tcount);
        $("#law_CNot").val(tcountn);
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
            type: "post",
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
                        strLine1 = strLine1.replace(/{{opt_sqlno}}/g, item.opt_sqlno);
                        strLine1 = strLine1.replace(/{{attach_sqlno}}/g, item.attach_sqlno);
                        strLine1 = strLine1.replace(/{{email_cnt}}/g, item.email_cnt);
                        strLine1 = strLine1.replace(/{{email_sqlno}}/g, item.email_sqlno);
                        strLine1 = strLine1.replace(/{{maxemail_sqlno}}/g, item.maxemail_sqlno);
                        strLine1 = strLine1.replace(/{{task}}/g, item.task);
                        strLine1 = strLine1.replace(/{{mail_status}}/g, item.mail_status);

                        strLine1 = strLine1.replace(/{{branch}}/g, item.branch);
                        strLine1 = strLine1.replace(/{{bseq}}/g, item.bseq);
                        strLine1 = strLine1.replace(/{{bseq1}}/g, item.bseq1);
                        strLine1 = strLine1.replace(/{{fseq}}/g, item.fseq);
                        strLine1 = strLine1.replace(/{{fext_seq}}/g, item.fseq);
                        strLine1 = strLine1.replace(/{{case_no}}/g, item.case_no);
                        strLine1 = strLine1.replace(/{{arcase}}/g, item.arcase);
                        strLine1 = strLine1.replace(/{{your_no}}/g, item.your_no);
                        strLine1 = strLine1.replace(/{{fext_seq}}/g, item.fext_seq);
                        strLine1 = strLine1.replace(/{{appl_name}}/g, item.appl_name);
                        strLine1 = strLine1.replace(/{{pr_rs_code_name}}/g, item.pr_rs_code_name);
                        strLine1 = strLine1.replace(/{{opt_in_date}}/g, dateReviver(item.opt_in_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{pr_scode_name}}/g, item.pr_scode_name);
                        strLine1 = strLine1.replace(/{{confirm_date}}/g, dateReviver(item.confirm_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{ctrl_date}}/g, dateReviver(item.ctrl_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{last_date}}/g, dateReviver(item.last_date, "yyyy/M/d"));
                        //strLine1 = strLine1.replace(/{{urlmail}}/g, item.urlmail);
                        strLine1 = strLine1.replace(/{{todoname}}/g, item.todoname);

                        $("#dataList>tbody").append(strLine1);
                        $("#tr_edit_"+nRow).showFor(item.br_source=="br");
                        $("#tr_editA_" + nRow).showFor(item.br_source == "opte");
                        $("#recopy_flag").val(item.recopy_flag);
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

    var tcount=2;				//包含的條件列表最少二個
    var tcountn=2;				//不包含的條件列表最少二個
    var Maxfcount=10;	        //可用條件數

    function tbword_init(){
        for(var nRow=1;nRow<=Maxfcount;nRow++){
            var copyStr = "";
            $("#tbwordA>tfoot").each(function (i) {
                copyStr += $(this).html().replace(/##/g, nRow);
                if(nRow>1){
                    copyStr=copyStr.replace(/{{lawOR}}/g, "<font color='#000000'>(</font>OR<font color='#000000'>)</font> ");
                }else{
                    copyStr=copyStr.replace(/{{lawOR}}/g, "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
                }
            });
            $("#tbwordA>tbody").append(copyStr);
            if(nRow>tcount){
                $("#law_"+nRow).hide();
            }

            copyStr = "";
            $("#tbwordB>tfoot").each(function (i) {
                copyStr += $(this).html().replace(/##/g, nRow);
                if(nRow>1){
                    copyStr=copyStr.replace(/{{lawOR}}/g, "<font color='#000000'>(</font>OR<font color='#000000'>)</font> ");
                }else{
                    copyStr=copyStr.replace(/{{lawOR}}/g, "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
                }
            });
            $("#tbwordB>tbody").append(copyStr);

            if(nRow>tcountn){
                $("#lawNot_"+nRow).hide();
            }
        }
        $("#law_count").val(tcount);
        $("#law_CNot").val(tcountn);
    }

    //設定畫面是否顯示f_col(包含(Add)或不包含(Del)欄位,增加(in)或減少(not))   
    function f_col(x,y){
        if (x=="Add"){
            if (y=="in"){//包含條件增加
                if (tcount >= Maxfcount){
                    alert("條件超過10筆!");
                    return false;
                }
                tcount+=1;
                $("#law_"+tcount).show();
            }else if (y=="not"){//包含條件減少
                if (tcountn >= Maxfcount){
                    alert("條件超過10筆!");
                    return false;
                }
                tcountn+=1;
                $("#lawNot_"+tcountn).show();
            }
        }else if( x=="Del"){
            if (y == "in"){//包含條件滅少
                if (tcount <= 0 ){
                    alert("條件少於0筆!");
                    return false;
                }
                $("#law_"+tcount).hide();
                $("input",$("#law_"+tcount)).val("");
                tcount-=1;
            }else if (y=="not"){//不包含條件減少
                if (tcountn <= 0 ){
                    alert("條件少於0筆!");
                    return false;
                }
                $("#lawNot_"+tcountn).hide();
                $("input",$("#lawNot_"+tcountn)).val("");
                tcountn-=1;
            }
        }
        $("#law_count").val(tcount);
        $("#law_CNot").val(tcountn);
    }

    //增加一筆法條搜尋
    $("#Class_Add_button_law").click(function () { 
        var nRow = parseInt($("#class_num").val(), 10) + 1;
        //複製樣板
        var copyStr = "";
        $("#data_law>tfoot tr").each(function (i) {
            copyStr += "<tr name='tr_law_"+nRow+"' class=whitetablebg>" + $(this).html().replace(/##/g, nRow) + "</tr>";
            if(nRow>1){
                copyStr=copyStr.replace(/{{lawOR}}/g, "( OR ) ");
            }else{
                copyStr=copyStr.replace(/{{lawOR}}/g, "");
            }
        });
        $("#data_law>tbody").append(copyStr);
        $("#class_num").val(nRow);
    });

    //減少一筆法條搜尋
    $("#Class_Del_button_law").click(function () {
        var nRow = parseInt($("#class_num").val(), 10);
        $("tr[name='tr_law_" + nRow+"']").remove();
        $("#class_num").val(Math.max(0, nRow - 1));
    });
</script>
