<%@ Page Language="C#" CodePage="65001"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opt41";//程式檔名前綴
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
        <td class="text9" nowrap="nowrap">&nbsp;【<%#prgid%> <%#HTProgCap%>‧<b style="color:Red">未發文清單</b>】</td>
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
		        ◎發文方式:
			        <input type="radio" name="qrysend_dept" value="B" checked>專案室發文
			        <input type="radio" name="qrysend_dept" value="L">轉發法律處
            <tr>
        </tr>
        <tr>
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
		        ◎預計發文日期:
                <input type="text" name="qryBMPDateS" id="qryBMPDateS" class="dateField" value="" size="10" /> ~
                <input type="text" name="qryBMPDateE" id="qryBMPDateE" class="dateField" value="" size="10" />
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

    <div align="center" id="noData" style="display:none">
	    <font color="red">=== 目前無資料 ===</font>
    </div>

    <input type="text" id="count" name="count">
    <input type="text" id="submittask" name="submittask">
    <table style="display:none" border="0" class="bluetable" cellspacing="1" cellpadding="2" width="98%" align="center" id="dataList">
	    <thead>
          <Tr>
	        <td class="lightbluetable" nowrap align="center"></td>
	        <td class="lightbluetable" nowrap align="center">案件編號</td>
	        <td class="lightbluetable" nowrap align="center">區所案件編號</td>
	        <td class="lightbluetable" nowrap align="center">申請人</td> 
	        <td class="lightbluetable" nowrap align="center">案件名稱</td> 
	        <td class="lightbluetable" nowrap align="center">承辦人</td> 
	        <td class="lightbluetable" nowrap align="center">法定期限</td>
	        <td class="lightbluetable" nowrap align="center">判行日期</td> 
	        <td class="lightbluetable" nowrap align="center">發文日期</td>
	        <td class="lightbluetable" nowrap align="center">發文單位</td>
         </tr>
	    </thead>
	    <tfoot style="display:none">
	    <tr class='{{tclass}}' id='tr_data_{{nRow}}'>
            <td align="center"><input type=checkbox id="BT" name="B{{nRow}}" value="Y"></td>
		    <td align="center"><a href='{{urlasp}}' target='Eblank'>{{opt_no}}</a></td>
		    <td align="center"><a href='{{urlasp}}' target='Eblank'>{{fseq}}</a>
			    <img src="../images/mailg.gif" title="Email通知區所" align="absmiddle"  border="0" onClick="tobrbutton_email('{{fseq}}','{{case_no}}','{{last_date}}','{{appl_name}}','{{gs_date}}','{{opt_sqlno}}','{{branch}}')">
		    </td>
		    <td><a href='{{urlasp}}' target='Eblank'>{{ap_cname}}</a></td>
		    <td><a href='{{urlasp}}' target='Eblank'>{{appl_name}}</a></td>
		    <td align="center"><a href='{{urlasp}}' target='Eblank'>{{pr_scode_name}}</a></td>
		    <td align="center"><a href='{{urlasp}}' target='Eblank'>{{last_date}}</a></td>
		    <td align="center"><a href='{{urlasp}}' target='Eblank'>{{ap_date}}</a></td>
		    <td align="center"><a href='{{urlasp}}' target='Eblank'><input type="text" name="step_date{{nRow}}" value="{{gs_date}}" size="10" class="dateField" onblur="chkstep_date('{{nRow}}')"></a></td>
		    <td align="center"><a href='{{urlasp}}' target='Eblank'>{{send_dept_name}}</a>
		        <input type="text" id="branch{{nRow}}" name="branch{{nRow}}" value="{{branch}}">
		        <input type="text" id="opt_sqlno{{nRow}}" name="opt_sqlno{{nRow}}">
		        <input type="text" id="sqlno{{nRow}}" name="sqlno{{nRow}}" value="{{opt_sqlno}}">
		        <input type="text" id="send_dept{{nRow}}" name="send_dept{{nRow}}" value="{{send_dept}}">
		        <input type="text" id="gs_date{{nRow}}" name="gs_date{{nRow}}" value="{{gs_date}}">
		        <input type="text" id="mp_date{{nRow}}" name="mp_date{{nRow}}" value="{{mp_date}}">
		        <input type="text" id="contract_flag{{nRow}}" name="contract_flag{{nRow}}" value="{{contract_flag}}">
		        <input type="text" id="fseq{{nRow}}" name="fseq{{nRow}}" value="{{fseq}}">
		    </td>
	    </tr>
	    </tfoot>
	    <tbody>
	    </tbody>
    </TABLE>
    <br>
    <table border="0" width="98%" cellspacing="0" cellpadding="0" align="center">
        <tr>
            <td width="100%" align="center">     
		        <input type=button value="發文確認" class="cbutton" id="btnSubmit" name="btnSubmit">
		        <input type=button value="退回承辦" class="redbutton" id="btnBack" name="btnBack">
            </td>
        </tr>
    </table>
    </form>
    <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>

    <iframe id="ActFrame" name="ActFrame" src="about:blank" width="100%" height="500" style="display:none"></iframe>
</body>
</html>


<script language="javascript" type="text/javascript">
    $(document).ajaxStart(function () { $.maskStart("資料載入中"); });
    $(document).ajaxStop(function () { $.maskStop(); });

    $("#qryBranch").getOption({//區所別
        url: "../ajax/_GetSqlDataCnn.aspx",
        data:{sql:"select branch,branchname from branch_code where mark='Y' and branch<>'J' order by sort"},
        valueFormat: "{branch}",
        textFormat: "{branch}_{branchname}"
    });

    $("#chkTest").click(function (e) {
        $("#ActFrame").showFor($(this).prop("checked"));
    });

    $(function () {
        $("input.dateField").datepick();
        //get_ajax_selection("select branch,branchname from branch_code where mark='Y' and branch<>'J' order by sort")
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",true).triggerHandler("click");//☑測試

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
                        strLine1 = strLine1.replace(/{{pr_scode_name}}/g, item.pr_scode_name);
                        strLine1 = strLine1.replace(/{{last_date}}/g, dateReviver(item.last_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{ap_date}}/g, dateReviver(item.ap_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{gs_date}}/g, dateReviver(item.gs_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{mp_date}}/g, dateReviver(item.mp_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{contract_flag}}/g, item.contract_flag);
                        strLine1 = strLine1.replace(/{{send_dept}}/g, item.send_dept);
                        strLine1 = strLine1.replace(/{{send_dept_name}}/g, item.send_dept_name);
                        strLine1 = strLine1.replace(/{{opt_sqlno}}/g, item.opt_sqlno);
                        strLine1 = strLine1.replace(/{{case_no}}/g, item.case_no);
                        strLine1 = strLine1.replace(/{{branch}}/g, item.branch);
                        strLine1 = strLine1.replace(/{{arcase}}/g, item.arcase);

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

        if( chkgsdate) return false;
        if( chkcontractflag)return false;
        for(var i=1;i<=parseInt($("#count").val(), 10);i++){
            if($("input[name='B"+i+"']").prop("checked")==true){
                $("#opt_sqlno"+i).val($("#sqlno"+i).val());
            }else{
                $("#opt_sqlno"+i).val("");
            }
        }
        $("btnSubmit,#btnBack").lock(!$("#chkTest").prop("checked"));
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.target = "ActFrame";
        //reg.submit();
    });

    //退回承辦
    $("#btnBack").click(function (e) {
        var errMsg = "";
        
        var check=$("input[id='BT']:checked").length;
        if (check==0){
            errMsg+="尚未選定!!\n";
        }

        if (errMsg!="") {
            alert(errMsg);
            return false;
        }


        if (!confirm("是否確定退回重新承辦？？")){
            return false;
        }else{
            for(var i=1;i<=parseInt($("#count").val(), 10);i++){
                if($("input[name='B"+i+"']").prop("checked")==true){
                    $("#opt_sqlno"+i).val($("#sqlno"+i).val());
                }else{
                    $("#opt_sqlno"+i).val("");
                }
            }
            $("btnSubmit,#btnBack").lock(!$("#chkTest").prop("checked"));
            reg.submittask.value="B";
            reg.action = "<%=HTProgPrefix%>_Update.aspx";
            reg.target = "ActFrame";
            //reg.submit();
        }
    });

    //檢查發文日期
    function chkgsdate(){
        for(var c=1;c<=parseInt($("#count").val(), 10);c++){
            if($("input[name='B"+c+"']").prop("checked")==true){
                if($("#step_date"+c).val()!=(new Date()).format("yyyy/M/d")){
                    alert("只可選擇發文日期為今天的，請修改發文日期!");
                    return true;
                    break;
                }
            }
        }
    }

    //檢查契約書後補註記
    function chkcontractflag(){
        chkcontractflag=false
        for(var c=1;c<=parseInt($("#count").val(), 10);c++){
            if($("input[name='B"+c+"']").prop("checked")==true){
                if($("#contract_flag"+c).val()=="Y"){
                    if((<%#HTProgRight%> & 256)){
                        if (!confirm("案件" +$("#fseq"+c).val()+"尚有契約書後補，確定發文嗎？"))
                            return true;
                    }
                }else{
                    alert("案件" +$("#fseq"+c).val()+ "尚有契約書後補，請通知國內所，以便發文!");
                    return true;
                }
            }
        }
    }

    //發文方式
    $("input [name=qrysend_dept]").click(function (e) {
        goSearch();
    });

    $("#qryopt_no").blur(function (e) {
        chkNum1($(this)[0], "案件編號");
    });

    $("#qryBSeq").blur(function (e) {
        chkNum1($(this)[0], "區所案件編號");
    });

    $("#qryBMPDateS").blur(function (e) {
        ChkDate($("#qryBMPDateS")[0]);
    });
    $("#qryBMPDateE").blur(function (e) {
        ChkDate($("#qryBMPDateE")[0]);
    });

    function chkstep_date(nRow){
        if(ChkDate($("#step_date"+nRow)[0])) {
            return false;
        }else{
            var mpdate=new Date($("#step_date"+nRow).val()).addDays(1).format("yyyy/M/d");
            $("#mp_date"+nRow).val(mpdate);
        }
    }

    //契約書後補通知區所mail簽核
    function tobrbutton_email(fseq,case_no,last_date,appl_name,gs_date,opt_sqlno,branch){
        /*
        var server="<%#Sys.Host%>";
        var Sender="",StrToList="",CCtoList="";
        if(server=="web8"||server=="web10"){
            Sender="<%#Session["scode"]%>"//寄件者
            StrToList="<%#Session["scode"]%>@saint-island.com.tw"  //收件者
        }else{
            Sender="<%#Session["scode"]%>"//寄件者
            //通知區所承辦、程序
            fsql="select in_scode from todo_opt where opt_sqlno=" & opt_sqlno & " and apcode='brt18' and dowhat='RE' and job_status='YY' "
            url = "/opt/xml/xmlgetsqldata.asp?searchsql=" & fsql
            set xmldoc = CreateObject("Microsoft.XMLDOM")
            xmldoc.async = false
            xmldoc.validateOnParse = true
            if xmldoc.load (url) then
            if xmldoc.selectSingleNode("//xhead/Found").text = "Y" then
            todo_scode = xmldoc.selectSingleNode("//xhead/in_scode").text
        else
                        todo_scode = ""	
            end if
        end if
        set xmldoc = nothing
			
            fsql="select scode from sysctrl.dbo.scode_group where grpclass='" & branch & "' and grpid='T210' and grptype='F'"
            url = "/opt/xml/xmlgetsqldata.asp?searchsql=" & fsql
            set xmldoc = CreateObject("Microsoft.XMLDOM")
            xmldoc.async = false
            xmldoc.validateOnParse = true
            if xmldoc.load (url) then
            if xmldoc.selectSingleNode("//xhead/Found").text = "Y" then
            bproc_scode =  xmldoc.selectSingleNode("//xhead/scode").text
        else
                        bproc_scode = ""	
            end if
        end if
        set xmldoc = nothing
	        
            if todo_scode<>"" then
            StrToList=todo_scode & "@saint-island.com.tw;"  //收件者						
            end if
            if bproc_scode<>"" then   
            StrToList=StrToList & bproc_scode & "@saint-island.com.tw"
            end if  
            CCtoList = " "	'副本 

        }

	
        tsubject = "國內所爭救案系統－官發待契約書後補通知（區所編號： " & fseq & " ）"
	
        tbody = "致: 國內所 程序、承辦" & "%0A%0A"
        tbody = tbody & "【通 知 日 期 】: "&date()
        tbody = tbody & "%0A【區所編號】:" & fseq & "，交辦單號：" & case_no & "，法定期限：" & last_date & "，預計發文日期：" & gs_date  
        tbody = tbody & "%0A【案件名稱】:" & appl_name
        tbody = tbody & "%0A 請儘速後補契約書，以俾爭議組發文，如無法及時完成後補，請進行mail簽核作業，經主管同意後由資訊部開放可先官發。"
	
        window.parent.Eblank.location.href= "mailto:"& StrToList &"?subject="&tsubject&"&cc="&CCtoList&"&body="&tbody
        */
    }
</script>
