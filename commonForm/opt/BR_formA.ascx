<%@ Control Language="C#" ClassName="br_formA" %>

<script runat="server">
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string SQL = "";
    //<%=MapPathSecure(TemplateSourceDirectory)%>\<%=this.GetType().ToString().Replace("ASP.","")%>.ascx
    protected string branch = "";
    protected string opt_sqlno = "";
    protected string submitTask = "";
    
    private void Page_Load(System.Object sender, System.EventArgs e) {
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";
        submitTask = Request["submitTask"] ?? "";
        
        this.DataBind();
    }
</script>

<input type="text" id="apply_no" name="apply_no">
<input type="text" id="apply_date" name="apply_date">
<input type="text" id="issue_no" name="issue_no">
<input type="text" id="issue_date" name="issue_date">
<input type="text" id="rej_no" name="rej_no">
<input type="text" id="open_date" name="open_date">
<input type="text" id="dmt_term1" name="dmt_term1">
<input type="text" id="dmt_term2" name="dmt_term2">
<input type="text" id="apsqlno" name="apsqlno">
<input type="text" id="cust_name" name="cust_name">
<input type="text" id="ap_ename" name="ap_ename">
<input type="text" id="br_apnum" name="br_apnum" value=0><!--進度筆數-->
<table id=br_tab border="0" class="bluetable" cellspacing="1" cellpadding="2" width="100%">
	<Tr>
		<TD align=center colspan=4 class=lightbluetable1><font color="white">工&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;作&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;資&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;料</font></TD>
	</TR>
	<tr id="tr_Popt_show1" style="display:none">
		<td class="lightbluetable" valign="top"  align="right"><strong>案件編號：</strong></td>
		<td class="whitetablebg" colspan="7" valign="top">
			<input type="text" size="11" id="Opt_no" name="Opt_no" class="Lock" maxLength="10">
		</td>
	</tr>
	<TR>
		<td class="lightbluetable"  align="right">區所本所編號 :</td>
		<td class="whitetablebg"  align="left" colspan=3 >
			<Select id="Branch" name="Branch" class="unlockADD"></Select>
			<input type="text" id="Bseq" name="Bseq" SIZE=5 class="unlockADD" maxLength="5">-
			<input type="text" id="Bseq1" name="Bseq1" SIZE=1 class="unlockADD" maxLength="1">
			<input type="button" value="確定" class="cbutton showADD" id="btnBseq" name="btnBseq">
			<input type="text" id="keyBseq" name="keyBseq" class="Hide" value="N">
			<input type="text" id="oldBranch" name="oldBranch">
			<input type="text" id="oldBseq" name="oldBseq">
			<input type="text" id="oldBseq1" name="oldBseq1">
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right">營洽 :</td>
		<td class="whitetablebg"  align="left">
			<input type="text" id="in_scode" name="in_scode" SIZE=5 >
			<input type="text" id="scode_name" name="scode_name" SIZE=10 >
		</td>
		<td class="lightbluetable"  align="right">出名代理人 :</td>
		<td class="whitetablebg"  align="left">
			<select id=agt_no name=agt_no SIZE=1 ></select>
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right">案件名稱 :</td>
		<td class="whitetablebg"  align="left" colspan=3>
			<input type="text" id="appl_name" name="appl_name" SIZE=90 maxlength=100 >
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right">申請人 :</td>
		<td class="whitetablebg"  align="left" colspan=3>
			<input type="text" id="ap_cname" name="ap_cname" SIZE=60 maxlength=60 >
		    <input type="text" id="cust_seq" name="cust_seq">
		    <input type="text" id="cust_area" name="cust_area">
		    <input type="text" id="att_sql" name="att_sql">
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right">交辦案性 :</td>
		  <td class="whitetablebg"  align="left" colspan=3>
			 	案性：<select id=Arcase NAME=Arcase SIZE=1 class="unlockADD">	</SELECT>
				<input type="text" id="arcase_type" name="arcase_type">
				<input type="text" id="arcase_class" name="arcase_class">
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right" nowrap>法定期限 :</td>
		  <td class="whitetablebg"  align="left" colspan=3 >
			<input type="text" id="dfy_last_date" name="dfy_last_date" SIZE=10 class="BRClass dateField" maxlength=10>
		</td>
	</TR>
	<Tr>
		<td class="lightbluetable" align="right">工作說明 :</td>
		<TD class=lightbluetable colspan=3>
			<textarea ROWS="6" COLS="90%" id=remark name="remark" class="BRClass"></textarea>
		</TD>
	</tr>
</table>


<script language="javascript" type="text/javascript">
    var br_formA = {};
    br_formA.init = function () {
        $("#Branch").getOption({//區所別
            url: "../ajax/AjaxGetSqlDataCnn.aspx",
            data: { sql: "select branch,branchname from branch_code where mark='Y' and branch<>'J' order by sort" },
            valueFormat: "{branch}",
            textFormat: "{branch}_{branchname}"
        });
        $("#agt_no").getOption({//出名代理人
            url: "../ajax/LookupDataBranch.aspx",
            data: { type: "getagtdata", branch: "<%#branch%>" },
            valueFormat: "{agt_no}",
            textFormat: "{strcomp_name}{agt_name}"
        });
        $("#Arcase").getOption({//交辦案性
            url: "../ajax/LookupDataBranch.aspx",
            data: { type: "getarcasedata", branch: "<%#branch%>" },
            valueFormat: "{rs_code}",
            textFormat: "{rs_codenm}---{rs_detail}",
            attrFormat: "val1='{rs_type}' val2='{rs_class}'"
        });

        $("#Branch").val("<%#branch%>");

       if ("<%#submitTask%>" != "ADD") {
            br_formA.loadOpt();
            $("#btnBseq").click();
        } else {
            $("#Bseq1").val("_");
            $("#Arcase").val("FOC").trigger("change");
        }

        $("#tr_Popt_show1").hideFor($("#submittask").val()=="ADD");//新增分案時不顯示案件編號
        $(".unlockADD").unlock($("#submittask").val()=="ADD");//新增分案解鎖
        $(".showADD").showFor($("#submittask").val()=="ADD");//新增分案顯示
    }

    //載入爭救案件資料
    br_formA.loadOpt = function () {
        var jOpt = br_opt.opt[0];
        if (jOpt!=null) {
            $("#Branch,#oldBranch").val(jOpt.branch);
            $("#ctrl_date").val(dateReviver(jOpt.ctrl_date, "yyyy/M/d"));
            if (jOpt.dfy_last_date == "") {
                var Adate = dateConvert(jOpt.dfy_last_date).addDays(-5);
                if (Adate < (new Date()))
                    $("#ctrl_date").val(dateReviver(jOpt.dfy_last_date, "yyyy/M/d"));
                else
                    $("#ctrl_date").val(Adate);
            }
            $("#Opt_no").val(jOpt.opt_no);
            $("#Bseq,#oldBseq").val(jOpt.bseq);
            $("#Bseq1,#oldBseq1").val(jOpt.bseq1);
            $("#in_scode").val(jOpt.in_scode);
            $("#scode_name").val(jOpt.scode_name);
            $("#appl_name").val(jOpt.appl_name);
            $("#ap_cname").val(jOpt.ap_cname);
            $("#cust_seq").val(jOpt.cust_seq);
            $("#cust_area").val(jOpt.cust_area);
            $("#att_sql").val(jOpt.att_sql);
            $("#Arcase").val(jOpt.arcase).trigger("change");
            $("#dfy_last_date").val(dateReviver(jOpt.last_date, "yyyy/M/d"));
            $("#remark").val(jOpt.remark);
            $("#apply_no").val(jOpt.apply_no);
            $("#apply_date").val(jOpt.apply_date);
            $("#issue_no").val(jOpt.issue_no);
            $("#issue_date").val(jOpt.issue_date);
            $("#rej_no").val(jOpt.rej_no);
            $("#open_date").val(jOpt.open_date);
            $("#dmt_term1").val(jOpt.dmt_term1);
            $("#dmt_term2").val(jOpt.dmt_term2);
            $("#apsqlno").val(jOpt.apsqlno);
            $("#ap_ename").val(jOpt.ap_ename);
        }
    };

    //載入區所案件資料
    $("#btnBseq").click(function () { 
        br_formA.loadDmt(); 
    });
    br_formA.loadDmt = function () {
        var br_dmt = {};
        if ($("#Branch").val()==""){ alert("區所別未輸入!!!"); return false;}
        if ($("#Bseq").val()==""){ alert("區所編號未輸入!!!"); return false;}
        if ($("#Bseq1").val()==""){ alert("區所編號副碼未輸入!!!"); return false;}
        //取得區所案件資料
        $.ajax({
            type: "get",
            url: getRootPath() + "/AJAX/DmtData.aspx?branch=" + $("#Branch").val() + "&seq=" + $("#Bseq").val() + "&seq1=" + $("#Bseq1").val(),
            async: false,
            cache: false,
            success: function (json) {
                if ($("#chkTest").attr("checked")) toastr.info("<a href='" + this.url + "' target='_new'>DmtData Debug！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
                var JSONdata = $.parseJSON(json);
                if (JSONdata.dmt.length == 0) {
                    alert($("#Bseq").val()+"-"+$("#Bseq1").val()+"不存在於案件主檔內，請重新輸入!!!");
                    return false;
                }
                var jDmt = JSONdata.dmt[0];
                if (jDmt != null) {
                    $("#appl_name").val(jDmt.appl_name);
                    $("#cust_area").val(jDmt.cust_area);
                    $("#cust_seq").val(jDmt.cust_seq);
                    $("#cust_name").val(jDmt.custname);
                    $("#agt_no").val(jDmt.agt_no);
                    $("#scode_name").val(jDmt.scodename);
                    $("#in_scode").val(jDmt.scode);
                    $("#apply_date").val(dateReviver(jDmt.apply_date, "yyyy/M/d"));
                    $("#apply_no").val(jDmt.apply_no);
                    $("#issue_date").val(dateReviver(jDmt.issue_date, "yyyy/M/d"));
                    $("#issue_no").val(jDmt.issue_no);
                    $("#open_date").val(dateReviver(jDmt.open_date, "yyyy/M/d"));
                    $("#rej_no").val(jDmt.rej_no);
                    $("#dmt_term1").val(dateReviver(jDmt.term1, "yyyy/M/d"));
                    $("#dmt_term2").val(dateReviver(jDmt.term2, "yyyy/M/d"));
                    $("#apsqlno").val(jDmt.apsqlno);
                    $("#ap_cname").val(jDmt.ap_cname);
                    $("#ap_ename").val(jDmt.ap_ename);
                    $("#att_sql").val(jDmt.att_sql);
                    $("#br_apnum").val(JSONdata.dmt_ap.length);

		            $("#oldBranch").val($("#Branch").val());
		            $("#oldBseq").val($("#Bseq").val());
		            $("#oldBseq1").val($("#Bseq1").val());
                    $("#keyBseq").val("Y"); //有按確定給Y
                }
                $("#btnBseq").attr("disabled",true);
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>案件資料載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });
    };

    //載入區所案件資料
    $("#Arcase").change(function () {
        br_formA.getArcaseData(this);
    });
    br_formA.getArcaseData = function (obj) {
        $("#arcase_type").val($(":selected",obj).attr("val1"));
        $("#arcase_class").val($(":selected",obj).attr("val2"));
    };
</script>
