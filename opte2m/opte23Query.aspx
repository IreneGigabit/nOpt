<%@ Page Language="C#" CodePage="65001"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opte23";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;
    protected string tf_code_html = "", BJPrScode_html="";

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
        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(false)) {
            tf_code_html = SHtml.Option(conn, "select tf_code,tf_name from tfcode_opt where tf_class='BJ' and (end_date is null or end_date>getdate()) order by tf_code", "{tf_code}", "{tf_name}");
            BJPrScode_html = Funcs.GetBJPrTermALL("A").Option("{scode}", "{scode}_{sc_name}");
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
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/client_chk.js")%>"></script>
</head>

<body>
<table cellspacing="1" cellpadding="0" width="98%" border="0" align="center">
    <tr>
        <td class="text9" nowrap="nowrap">&nbsp;【<%#prgid%> <%#HTProgCap%>‧<b style="color:Red">尚未分案通知</b>】</td>
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
	        <td class="text9" colspan="2">
		        ◎作業選項:
                <label><input type="radio" name="qrytodo" value="send" checked>尚未寄出確認</label>
		         <label><input type="radio" name="qrytodo" value="update">已寄出補入承辦</label>
	        </td>
        </tr>
        <tr>
	        <td class="text9">
		        ◎案件編號:<input type="text" name="qryOpt_no" id="qryOpt_no" size="11" maxLength="10">
	        </td>
	        <td class="text9">
		        ◎區所案件編號:
			    <Select id="qryBranch" name="qryBranch"></Select>
			    <input type="text" name="qryBSeq" id="qryBSeq" size="5" maxLength="5">-<input type="text" name="qryBSeq1" id="qryBSeq1" size="1" maxLength="1">
	        </td>
	        <td class="text9">
		        ◎對方號:<input type=text id="qryyour_no" name="qryyour_no" size=20>
	        </td>
	        <td class="text9">
		        ◎排序: <select id="qryOrder" name="qryOrder">
			        <option value="" selected>請選擇</option>
			        <option value="a.confirm_date">收文日期</option>
			        <option value="a.opt_in_date">分案日期</option>
			        <option value="a.ctrl_date">承辦期限</option>
			        <option value="a.last_date">法定期限</option>
			        <option value="a.opt_no">案件編號</option>
			        </select>
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

    <input type="hidden" id="submittask" name="submittask">
    <table style="display:none" border="0" class="bluetable" cellspacing="1" cellpadding="2" width="98%" align="center" id="dataList">
	    <thead>
          <Tr>
            <td class="lightbluetable" nowrap align="center" style="cursor: pointer;" Onclick="checkall()">
			    <span id="chk_text">全選</span>
			    <input type="hidden" id="chk_flag" name="chk_flag" value=""><!--記載下次狀態為「全選」或「全不選」-->
	        </td>
	        <td  class="lightbluetable" nowrap align="center">案件編號</td>
	        <td  class="lightbluetable" nowrap align="center">區所案件編號</td>
	        <td  class="lightbluetable" nowrap align="center">對方號</td>
	        <td  class="lightbluetable" nowrap align="center">國外所案號</td>
	        <td  class="lightbluetable" nowrap align="center">案件名稱</td> 
	        <td  class="lightbluetable" nowrap align="center">案性</td> 
	        <td  class="lightbluetable" nowrap align="center">分案日期</td> 
	        <td  class="lightbluetable" nowrap align="center">承辦人</td> 
	        <td  class="lightbluetable" nowrap align="center">收文日期</td>
	        <td  class="lightbluetable" nowrap align="center">承辦期限</td> 
	        <td  class="lightbluetable" nowrap align="center">法定期限</td>
	        <td  class="lightbluetable" nowrap align="center">作業</td>
         </tr>
	    </thead>
	    <tfoot style="display:none">
	        <tr class='{{tclass}}' id='tr_data_{{nRow}}'>
		        <td class="whitetablebg" align="center">
                    <input type=checkbox id="ckbox_{{nRow}}" name="ckbox_{{nRow}}" onclick="chkclick('{{nRow}}')">
                    <input type="hidden" id="email_cnt_{{nRow}}" name="email_cnt_{{nRow}}" value="{{email_cnt}}">
		            <input type="hidden" id="opt_no_{{nRow}}" name="opt_no_{{nRow}}" value="{{opt_no}}">
		            <input type="hidden" id="opt_sqlno_{{nRow}}" name="opt_sqlno_{{nRow}}" value="{{opt_sqlno}}">
		            <input type="hidden" id="branch_{{nRow}}" name="branch_{{nRow}}" value="{{branch}}">
                    <input type="hidden" id="email_sqlno_{{nRow}}" name="email_sqlno_{{nRow}}" value="{{email_sqlno}}">
                    <input type="hidden" id="maxemail_sqlno_{{nRow}}" name="maxemail_sqlno_{{nRow}}" value="{{maxemail_sqlno}}">
                    <input type="hidden" id="task_{{nRow}}" name="task_{{nRow}}" value="{{task}}">
                    <input type="hidden" id="mail_status_{{nRow}}" name="mail_status_{{nRow}}" value="{{mail_status}}">
		        </td>

		        <td class="whitetablebg" align="center">{{opt_no}}</td>
		        <td class="whitetablebg" align="center">{{fseq}}</td>
		        <td class="whitetablebg" align="center">{{your_no}}</td>
		        <td class="whitetablebg" align="center">{{fext_seq}}</td>
		        <td class="whitetablebg">{{appl_name}}</td>
		        <td class="whitetablebg" nowrap>{{pr_rs_code_name}}</td>
		        <td class="whitetablebg" align="center">{{opt_in_date}}</td>
		        <td class="whitetablebg" align="center">{{pr_scode_name}}</td>
		        <td class="whitetablebg" align="center">{{confirm_date}}</td>
		        <td class="whitetablebg" align="center">{{ctrl_date}}</td>
		        <td class="whitetablebg" align="center">{{last_date}}</td>
		        <td class="whitetablebg" nowrap align="center">
                    <span id="todo_send_{{nRow}}">
			            定稿：<select name="tf_code_{{nRow}}" id="tf_code_{{nRow}}"><%#tf_code_html%></select>
			            <span onclick="formemail('{{nRow}}')" style="cursor:pointer;color:darkblue" onmouseover="this.style.color='red'" onmouseout="this.style.color='darkblue'">
			                [{{todoname}}]
			            </span>

				        <span id="span_openmail_{{nRow}}">
				            (<span onclick="open_email('{{opt_sqlno}}','{{opt_no}}')" title="檢視發文信函" style="cursor:pointer;color:red" onmouseover="this.style.color='darkblue'" onmouseout="this.style.color='red'">
                                {{email_cnt}}
				                <span id="span_copymail_{{nRow}}">
				                    <span onclick="formemail('{{nRow}}')" style="cursor:pointer;color:darkgreen" onmouseover="this.style.color='red'" onmouseout="this.style.color='darkblue'">
				                    [複製E-mail]
				                    </span>
				                </span>
				            </span>)
                        </span>
			            <br>
                        <a id="tr_edit_{{nRow}}" href="../opte3m/opte31Edit.aspx?opt_sqlno={{opt_sqlno}}&opt_no={{opt_no}}&Branch={{branch}}&Case_no={{case_no}}&arcase={{arcase}}&prgid=opte31&prgname=<%#HTProgCap%>&from_prgid=<%=prgid%>" target="Eblank">[承辦文件上傳]</a>
			            <a id="tr_editA_{{nRow}}" href="../opte3m/opte31EditA.aspx?opt_sqlno={{opt_sqlno}}&opt_no={{opt_no}}&Branch={{branch}}&arcase={{arcase}}&prgid=opte31&prgname=<%#HTProgCap%>&from_prgid=<%=prgid%>" target="Eblank">[承辦文件上傳]</a>
                    </span>
                    <span id="todo_update_{{nRow}}">
		                承辦人員:<select name="pr_scode_{{nRow}}" id="pr_scode_{{nRow}}" >
				             <%=BJPrScode_html%>
		                </select><br>
		                <input type="hidden" id="pr_branch_{{nRow}}" name="pr_branch_{{nRow}}" value="BJ">
		                <span id="span_your_no_{{nRow}}">
		                對方號:<input type="text" name="your_no_{{nRow}}" id="your_no_{{nRow}}" size=20 maxlength=50>
		                </span>
                    </span>
		        </td>
	        </tr>
	    </tfoot>
	    <tbody>
	    </tbody>
    </TABLE>
    <br>
    <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>
    <table border="0" cellspacing="1" cellpadding="2" width="98%" id="formSend">
    <tr align=center>
	    <td nowrap align="center">
	   	    寄出日期:
		    <input type="text" id="mail_date" name="mail_date" size="10" maxlength="10" class="dateField" onblur="chkdateformat(this)" value="<%#DateTime.Today.ToShortDateString()%>" >
	    </td>
    </tr>
    </table>
    <table border="0" cellspacing="1" cellpadding="2" width="98%" id="formBtn">
    <tr align=center>
	    <td class="text9">
		    <input type="button" class="greenbutton" id="btnSubmit" name="btnSubmit" value="確　認">&nbsp;&nbsp;&nbsp;&nbsp;
	        <input type="hidden" id="count" name="count"><!--checkbox數量-->
	    </td>
    </tr>
    </table>
    </form>

<br />
作業備註:<br>
<font color=blue>◎作業選項：尚未寄出確認</font><br>
1.請先選擇定稿再點選[E-mail]執行Email寄發。<br>
2.待確定Email寄出(寄件人員會收到副本通知)，再勾選案件並執行寄出確認。<br>
3.系統會預設抓取區所上傳文件，若還有文件需提供北京聖島，煩請先點選[承辦文件上傳]將檔案上傳後，再執行Email寄發。<br>
<font color=blue>◎作業選項：已寄出補入承辦</font><br>
1.已寄出分案通知，輸入北京聖島承辦人員及北京聖島案號(新立案)。<br>
2.請先選擇承辦人員或輸入北京聖島案號，再勾選案件並執行確認。<br>
3.已分案未結辦前才能由此輸入承辦人員。<br>
<font color=blue>欄位備註:</font><br>
1.對方號：大陸案為北京聖島案號。<br>
2.收文日期：指收件確認日期，空白表自行新增分案。<br>

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
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",false).triggerHandler("click");//☑測試
        $("#chkTest").click(function (e) {
            $("#ActFrame").showFor($(this).prop("checked"));
        });

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
        $("#divPaging,#noData,#dataList,#formSend,#formBtn").hide();
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
                    $("#formSend").showFor($("input[name='qrytodo']:checked").val()=="send");
                    $("#formBtn").show();
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

                        //判斷作業種類
                        $("#todo_send_"+nRow).showFor($("input[name='qrytodo']:checked").val()=="send");
                        $("#todo_update_"+nRow).showFor($("input[name='qrytodo']:checked").val()=="update");

                        //檢視發文信函
                        $("#span_openmail_"+nRow).hide();
                        if(parseInt(item.email_cnt, 10)>0){
                            $("#span_openmail_"+nRow).show();
                            //複製e-mail
                            if($("#email_sqlno_"+nRow).val()!="0"){
                                $("#span_copymail_"+nRow).hide();
                            }
                        }

                        //對方號
                        $("#span_your_no_"+nRow).hide();
                        if((item.ext_seq||"")==""){
                            $("#span_your_no_"+nRow).show();
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

    //全選
    function checkall(){
        if($("#chk_flag").val()=="")$("#chk_flag").val("Y");
	
        //全選
        if($("#chk_flag").val()=="Y"){
            $("input[name^='ckbox_']").prop("checked",true);
            $("input[name^='hchk_flag_']").val($("#chk_flag").val());
            $("#chk_flag").val("N");
            $("#chk_text").html("全不選");
        }else if($("#chk_flag").val()=="N"){
            // 全不選
            $("input[name^='ckbox_']").prop("checked",false);
            $("input[name^='hchk_flag_']").val($("#chk_flag").val());
            $("#chk_flag").val("Y");
            $("#chk_text").html("全選");
        }
    }

    //單選
    function chkclick(nRow){
        if($("#ckbox_"+nRow).prop("checked"))
            $("#hchk_flag_"+nRow).val("Y");
        else
            $("#hchk_flag_"+nRow).val("N");
    }

    //Email發送
    function formemail(pnum){
        //檢查新增email時要選擇定稿，才能Email，草稿Email及複製Email不用選定稿
        if($("#email_sqlno_"+pnum).val()=="0" &&$("#maxemail_sqlno_"+pnum).val()=="0"){
            if($("#tf_code_"+pnum).val()==""){
                alert("案件" +$("#opt_no_"+pnum).val()+"尚未選擇定稿，不可執行E-mail發送！");
                return false;
            }
        }

        var purl="opte23_mailpreview.aspx?submittask=" + $("#task_"+pnum).val() +
                 "&branch=" + $("#branch_"+pnum).val() +
                 "&opt_sqlno=" + $("#opt_sqlno_"+pnum).val() +
                 "&email_sqlno=" + $("#email_sqlno_"+pnum).val() + 
                 "&mail_status=" + $("#mail_status_"+pnum).val() +
                 "&recordnum=" + pnum+
                 "&tf_code=" +$("#tf_code_"+pnum).val()+
                 "&prgid=" +$("#prgid").val();
        window.open(purl,"mailsendN", "width=900 height=800 top=10 left=10 toolbar=no, menubar=no, location=no, directories=no resizable=Yes status=no scrollbars=yes");
    }

    //檢視發送Email
    function open_email(pjob_sqlno,ptfsend_no){
        window.open("mailframe.aspx?prgid="+$("#prgid").val()+"&source=BJ_email&job_sqlno=" + pjob_sqlno + "&tfsend_no=" + ptfsend_no,"MyMailWindow");
    }

    //入檔
    $("#btnSubmit").click(function (e) {
        var errMsg = "";
        
        var check=$("input[name^='ckbox_']:checked").length;
        if (check==0){
            alert("尚未勾選任何資料項目!!");
            return false;
        }

        var totnum=0;
        var task=$("input[name='qrytodo']:checked").val();
        var count = parseInt($("#count").val(), 10);
        if (task=="send"){//寄出確認
            for(var i=1;i<=count;i++){
                if($("#ckbox_"+i).prop("checked")){
                    if($("#email_cnt_"+i).val()=="0"){
                        alert("案件" + $("#opt_no_"+i).val()+ "尚無Email寄出記錄，不可勾選且不可執行寄出確認作業！");
                        $("#ckbox_"+i).focus();
                        return false;
                    }

                    totnum+=1;
                }
            }

            if (chkNull("寄出日期", $("#mail_date")[0])) return false;
            var mail_date=new Date(Date.parse($("#mail_date").val()));
            if(mail_date>(new Date())){
                alert("寄出日期不得大於今日！");
                $("#mail_date").focus();
                return false;
            }
        }else if(task=="update"){//補入承辦人員
            for(var i=1;i<=count;i++){
                if($("#ckbox_"+i).prop("checked")){
                    if($("#pr_scode_"+i).val()=="" && $("#your_no_"+i).val()==""){
                        alert("案件" + $("#opt_no_"+i).val()+ "皆無輸入承辦人員或對方號，不可勾選且不需執行確認修改作業！");
                        $("#ckbox_"+i).focus();
                        return false;
                    }
                    totnum+=1;
                }
            }
        }

        if (totnum==0){
            alert("請勾選您要確認的資料項目!!");
            return false;
        }

        if (errMsg!="") {
            alert(errMsg);
            return false;
        }
    
        if(confirm("注意！\n你確定要執行確認作業嗎？")){
            $("btnSubmit").lock(!$("#chkTest").prop("checked"));
            reg.action = "<%=HTProgPrefix%>_updall.aspx?task="+task;
            reg.target = "ActFrame";
            reg.submit();
        }
    });

    $("#qryopt_no").blur(function (e) {
        chkNum1($(this)[0], "案件編號");
    });

    $("#qryBSeq").blur(function (e) {
        chkNum1($(this)[0], "區所案件編號");
    });
</script>
