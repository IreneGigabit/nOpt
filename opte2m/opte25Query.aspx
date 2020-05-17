<%@ Page Language="C#" CodePage="65001"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opte25";//程式檔名前綴
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
		        ◎作業選項:
                <label><input type="radio" name="qrytodo" value="copy" checked>未複製</label>
		         <label><input type="radio" name="qrytodo" value="recopy">已複製</label>
	        </td>
        </tr>
        <tr>
	        <td class="text9">
		        ◎區所案件編號:
			    <Select id="qryBranch" name="qryBranch"></Select>
			    <input type="text" name="qryBSeq" id="qryBSeq" size="5" maxLength="5">-<input type="text" name="qryBSeq1" id="qryBSeq1" size="1" maxLength="1">
                <input type="button" id="btnSrch" value ="查詢" class="cbutton" />
	        </td>
	        <td class="text9">
		        ◎分案日期:
                <input type="text" name="qryopt_in_dateS" id="qryopt_in_dateS" class="dateField" size="10" maxLength="10"> ~
                <input type="text" name="qryopt_in_dateE" id="qryopt_in_dateE" class="dateField" size="10" maxLength="10">
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
	    <font color="red">=== 目前無資料，請先輸入區所案件編號再查詢 ===</font>
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
	        <td  class="lightbluetable" nowrap align="center">附件檔名</td>
	        <td  class="lightbluetable" nowrap align="center">附件說明</td> 
	        <td  class="lightbluetable" nowrap align="center">案件名稱</td> 
	        <td  class="lightbluetable" nowrap align="center">案性</td> 
	        <td  class="lightbluetable" nowrap align="center">分案日期</td> 
	        <td  class="lightbluetable" nowrap align="center">承辦人</td> 
         </tr>
	    </thead>
	    <tfoot style="display:none">
	        <tr class='{{tclass}}' id='tr_data_{{nRow}}'>
		        <td class="whitetablebg" align="center">
                    <input type=checkbox id="ckbox_{{nRow}}" name="ckbox_{{nRow}}" onclick="chkclick('{{nRow}}')">
                    <input type="hidden" id="hchk_flag_{{nRow}}" name="hchk_flag_{{nRow}}" value="N">
		            <input type="hidden" id="opt_no_{{nRow}}" name="opt_no_{{nRow}}" value="{{opt_no}}">
		            <input type="hidden" id="opt_sqlno_{{nRow}}" name="opt_sqlno_{{nRow}}" value="{{opt_sqlno}}">
		            <input type="hidden" id="attach_sqlno_{{nRow}}" name="attach_sqlno_{{nRow}}" value="{{attach_sqlno}}">
		            <input type="hidden" id="branch_{{nRow}}" name="branch_{{nRow}}" value="{{branch}}">
		            <input type="hidden" id="Bseq_{{nRow}}" name="Bseq_{{nRow}}" value="{{bseq}}">
		            <input type="hidden" id="Bseq1_{{nRow}}" name="Bseq1_{{nRow}}" value="{{bseq1}}">
		            <input type="text" id="attach_path_{{nRow}}" name="attach_path_{{nRow}}" value="{{attach_path}}">
		            <input type="text" id="attach_name_{{nRow}}" name="attach_name_{{nRow}}" value="{{attach_name}}">
		        </td>
		        <td class="whitetablebg" align="center">{{opt_no}}</td>
		        <td class="whitetablebg" align="center">{{fseq}}<br>
                    <a id="tr_edit_{{nRow}}" href="../opte3m/opte31Edit.aspx?opt_sqlno={{opt_sqlno}}&opt_no={{opt_no}}&Branch={{branch}}&Case_no={{case_no}}&arcase={{arcase}}&prgid=opte31&prgname=<%#HTProgCap%>&from_prgid=<%=prgid%>" target="Eblank">[承辦文件上傳]</a>
			        <a id="tr_editA_{{nRow}}" href="../opte3m/opte31EditA.aspx?opt_sqlno={{opt_sqlno}}&opt_no={{opt_no}}&Branch={{branch}}&arcase={{arcase}}&prgid=opte31&prgname=<%#HTProgCap%>&from_prgid=<%=prgid%>" target="Eblank">[承辦文件上傳]</a>
		        </td>
		        <td class="whitetablebg" align="center">{{your_no}}</td>
		        <td class="whitetablebg" align="center"><font color="darkblue" style="cursor:pointer" onclick="pdf_onclick('{{pdf_path}}')">{{attach_name}}</font>({{pdfsize}}KB)</td>
		        <td class="whitetablebg" align="center">{{attach_desc}}</td>
		        <td class="whitetablebg">{{appl_name}}</td>
		        <td class="whitetablebg" nowrap>{{pr_rs_code_name}}</td>
		        <td class="whitetablebg" align="center">{{opt_in_date}}</td>
		        <td class="whitetablebg" align="center">{{pr_scode_name}}</td>
	        </tr>
	    </tfoot>
	    <tbody>
	    </tbody>
    </TABLE>
    <br>
    <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>
    <table border="0" cellspacing="1" cellpadding="2" width="98%" id="formBtn">
    <tr align=center>
	    <td class="text9">
		    <input type="button" class="greenbutton" id="btnSubmit" name="btnSubmit" value="檔案複製至北京專區暨通知資訊部">&nbsp;&nbsp;&nbsp;&nbsp;
	        <input type="hidden" id="count" name="count"><!--checkbox數量-->
	        <input type="hidden" id="recopy_flag" name="recopy_flag"><!--是否同天複製-->
	    </td>
    </tr>
    </table>
    </form>

<br />
作業備註:<br>
<font color=blue>◎作業選項：未複製</font><br>
1.指檔案尚未複製到北京專區。<br>
2.請以案件為單位，勾選需複製檔案再點選「檔案複製至北京專區暨通知資訊部」。<br>
3.系統會預設抓取區所上傳文件，若還有文件需提供北京聖島，煩請先點選[承辦文件上傳]將檔案上傳後，再重新執行本項作業。<br>
<font color=blue>◎作業選項：已複製</font><br>
1.指檔案已複製到北京專區，但檔案內容修改需重新複製。<br>
2.請先勾選需重新複製檔案。<br>
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
        $("#divPaging,#noData,#dataList,#formBtn").hide();
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
                        strLine1 = strLine1.replace(/{{branch}}/g, item.branch);
                        strLine1 = strLine1.replace(/{{bseq}}/g, item.bseq);
                        strLine1 = strLine1.replace(/{{bseq1}}/g, item.bseq1);
                        strLine1 = strLine1.replace(/{{attach_path}}/g, item.attach_path);
                        strLine1 = strLine1.replace(/{{attach_name}}/g, item.attach_name);
                        strLine1 = strLine1.replace(/{{fseq}}/g, item.fseq);
                        strLine1 = strLine1.replace(/{{case_no}}/g, item.case_no);
                        strLine1 = strLine1.replace(/{{arcase}}/g, item.arcase);
                        strLine1 = strLine1.replace(/{{your_no}}/g, item.your_no);
                        strLine1 = strLine1.replace(/{{pdf_path}}/g, item.pdf_path);
                        strLine1 = strLine1.replace(/{{attach_name}}/g, item.attach_name);
                        strLine1 = strLine1.replace(/{{pdfsize}}/g, xRound(item.pdfsize,0));
                        strLine1 = strLine1.replace(/{{attach_desc}}/g, item.attach_desc);
                        strLine1 = strLine1.replace(/{{appl_name}}/g, item.appl_name);
                        strLine1 = strLine1.replace(/{{pr_rs_code_name}}/g, item.pr_rs_code_name);
                        strLine1 = strLine1.replace(/{{opt_in_date}}/g, dateReviver(item.opt_in_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{pr_scode_name}}/g, item.pr_scode_name);

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

    //檢視PDF
    function pdf_onclick(pdfpath){
        window.open("http://"+pdfpath,"","width=800 height=600 top=40 left=80 toolbar=no, menubar=yes, location=no, directories=no resizable=yes status=no scrollbars=yes");
    }

    //入檔
    $("#btnSubmit").click(function (e) {
        var errMsg = "";
        
        var check=$("input[name^='ckbox_']:checked").length;
        if (check==0){
            errMsg+="請勾選您要複製的檔案!!\n";
        }

        if (errMsg!="") {
            alert(errMsg);
            return false;
        }
    
        if(confirm("注意！\n你確定要執行複製作業嗎？")){
            $("btnSubmit").lock(!$("#chkTest").prop("checked"));
            reg.action = "<%=HTProgPrefix%>_Update.aspx";
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

    $("#qryinput_dateS").blur(function (e) {
        ChkDate($("#qryinput_dateS")[0]);
    });
    $("#qryinput_dateE").blur(function (e) {
        ChkDate($("#qryinput_dateE")[0]);
    });

</script>
