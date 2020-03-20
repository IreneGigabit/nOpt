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

<table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="100%">		
	<TR>
		<td class="lightbluetable"  align="right" nowrap>預計完成日期 :</td>
		<td class="whitetablebg" colspan=3 >
			<input type="text" id="ctrl_date" name="ctrl_date" SIZE=10 class="dateField Lock BRClass">
			<span id="span_last_date0">
			    <font color="blue">區所指定法定期限：</font><font color="red"><span id="span_last_date"></span></font>
			</span>
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right">承辦區所別 :</td>
		<td class="whitetablebg">
			<Select id="pr_branch" name="pr_branch" class="Lock"></Select>
		</td>
		<td class="lightbluetable"  align="right">承辦人員 :</td>
		<td class="whitetablebg">
			<Select id="pr_scode" name="pr_scode" class="Lock BRClass"></Select>
		</td>
	</TR>
	<Tr>
		<td class="lightbluetable" align="right">分案說明 :</td>
		<TD class=lightbluetable colspan=3>
			<textarea ROWS="6" style="width:90%" id=Br_remark name="Br_remark" class="Lock BRClass"></textarea>
		</TD>
	</tr>
</table>

<table id=br_tab border="0" class="bluetable" cellspacing="1" cellpadding="2" width="100%">
	<Tr>
		<TD align=center colspan=4 class=lightbluetable1><font color="white">工&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;作&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;資&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;料</font></TD>
	</TR>
	<tr id="tr_Popt_show1" style="display:none">
		<td class="lightbluetable" valign="top"  align="right"><strong>案件編號：</strong></td>
		<td class="whitetablebg" colspan="7" valign="top">
			<input type="text" size="11" id="Opt_no" name="Opt_no" <%=QClass%> maxLength="10">
		</td>
	</tr>
	<TR>
		<td class="lightbluetable"  align="right">區所本所編號 :</td>
		<td class="whitetablebg"  align="left" colspan=3 >
			<Select id="Branch" name="Branch" <%=Qdisabled%>></Select>
			<input type="text" id="Bseq" name="Bseq" SIZE=5 <%=QClass%> maxLength="5">-
			<input type="text" id="Bseq1" name="Bseq1" SIZE=1 <%=QClass%> maxLength="1">
			<input type="button" value="確定" class="cbutton" name="btnBseq" <%=QStyle%>>
			<input type="hidden" id="keyBseq" name="keyBseq" value="N" <%=QStyle%>>
			<input type="hidden" id="oldBranch" name="oldBranch">
			<input type="hidden" id="oldBseq" name="oldBseq">
			<input type="hidden" id="oldBseq1" name="oldBseq1">
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right">營洽 :</td>
		<td class="whitetablebg"  align="left">
			<input type="text" id="in_scode" name="in_scode" SIZE=5 <%=CClass%>>
			<input type="text" id="scode_name" name="scode_name" SIZE=10 <%=CClass%>>
		</td>
		<td class="lightbluetable"  align="right">出名代理人 :</td>
		<td class="whitetablebg"  align="left">
			<select id=agt_no name=agt_no SIZE=1 <%=Cdisabled%>></select>
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right">案件名稱 :</td>
		<td class="whitetablebg"  align="left" colspan=3>
			<input type="text" id="appl_name" name="appl_name" SIZE=90 maxlength=100 <%=CClass%>>
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right">申請人 :</td>
		<td class="whitetablebg"  align="left" colspan=3>
			<input type="text" id="ap_cname" name="ap_cname" SIZE=60 maxlength=60 <%=CClass%>>
		    <input type="hidden" id="cust_seq" name="cust_seq">
		    <input type="hidden" id="cust_area" name="cust_area">
		    <input type="hidden" id="att_sql" name="att_sql">
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right">交辦案性 :</td>
		  <td class="whitetablebg"  align="left" colspan=3>
			 	案性：<select id=Arcase NAME=Arcase SIZE=1 <%=Qdisabled%> onchange="vbscript:getArcaseData">	</SELECT>
				<input type="hidden" id="arcase_type" name="arcase_type">
				<input type="hidden" id="arcase_class" name="arcase_class">
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right" nowrap>法定期限 :</td>
		  <td class="whitetablebg"  align="left" colspan=3 >
			<input type="text" name="dfy_last_date" SIZE=10 class="dateField" <%=RClass%> maxlength=10>
		</td>
	</TR>
	<Tr>
		<td class="lightbluetable" align="right">工作說明 :</td>
		<TD class=lightbluetable colspan=3>
			<textarea ROWS="6" COLS="90%" align="center" id=remark name="remark"  <%=RClass%>></textarea>
		</TD>
	</tr>
</table>
<input type="hidden" id="apply_no" name="apply_no">
<input type="hidden" id="apply_date" name="apply_date">
<input type="hidden" id="issue_no" name="issue_no">
<input type="hidden" id="issue_date" name="issue_date">
<input type="hidden" id="rej_no" name="rej_no">
<input type="hidden" id="open_date" name="open_date">
<input type="hidden" id="dmt_term1" name="dmt_term1">
<input type="hidden" id="dmt_term2" name="dmt_term2">
<input type="hidden" id="apsqlno" name="apsqlno">
<input type="hidden" id="cust_name" name="cust_name" value="<%=cust_name%>">
<input type="hidden" id="ap_ename" name="ap_ename">
<input type="hidden" id="Submittask" name="Submittask" value="<%=submitTask%>">
<input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">
<input type=hidden id=br_apnum name=br_apnum value=0><!--進度筆數-->


<script language="javascript" type="text/javascript">
    var br_formA = {};
    br_formA.init = function () {
        $("#Branch").getOption({//區所別
            url: "../ajax/AjaxGetSqlDataCnn.aspx",
            data: { sql: "select branch,branchname from branch_code where mark='Y' and branch<>'J' order by sort" },
            valueFormat: "{branch}",
            textFormat: "{branch}_{branchname}",
        });
        $("#agt_no").getOption({//出名代理人
            url: "../ajax/AgtData.aspx",
            data: { branch: "<%#branch%>" },
            valueFormat: "{agt_no}",
            textFormat: "{strcomp_name}{agt_name}"
        });

        var jOpt = br_opt.opt[0];
        if (jOpt.length > 0) {
            $("#Branch,#oldBranch").val(branch);
            $("#ctrl_date").val(jOpt.ctrl_date);
            if (jOpt.ctrl_date == "") {
                var Adate = dateConvert(jOpt.last_date).addDays(-1);
                if (Adate < (new Date()))
                    $("#ctrl_date").val(dateReviver(jOpt.last_date, "yyyy/M/d"));
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
            $("#arcase_type").val(jOpt.arcase_type);
            $("#arcase_class").val(jOpt.arcase_class);
            $("#dfy_last_date").val(jOpt.last_date);
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
    }
</script>
