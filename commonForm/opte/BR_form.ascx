<%@ Control Language="C#" ClassName="ext_br_form" %>

<script runat="server">
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string SQL = "";
    protected string submitTask = "";
    protected string branch = "";
    protected string opt_sqlno = "";
    protected string case_no = "";

    protected string pr_branch = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";
        case_no = Request["case_no"] ?? "";
        submitTask = Request["submitTask"] ?? "";

        pr_branch = Funcs.getcust_code("OEBranch", "", "sortfld").Option("{cust_code}", "{code_name}", false);

        this.DataBind();
    }
</script>

<%=Sys.GetAscxPath(this,MapPathSecure(TemplateSourceDirectory))%>
<input type="hidden" name="br_source" id="br_source" value="<%=br_source%>"><!--記錄分案來源-->		
<table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="100%">
	<Tr>
		<TD align=center colspan=4 class=lightbluetable1><font color="white">分&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;案&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;設&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;定</font></TD>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right" nowrap>預計完成日期 :</td>
		  <td class="whitetablebg"  align="left" colspan=3 >
			<input type="text" id="ctrl_date" name="ctrl_date" SIZE=10 class="dateField RLock">
			<span id="span_last_date0">
			    <font color="blue">區所指定法定期限：</font><font color="red"><span id="span_last_date"></span></font>
			</span>
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right">承辦單位別 :</td>
		  <td class="whitetablebg"  align="left">
			<Select id="pr_branch" name="pr_branch" class="Lock"><%#pr_branch%></Select>
		</td>
		<td class="lightbluetable"  align="right">承辦人員 :</td>
		  <td class="whitetablebg"  align="left">
			<Select id="pr_scode" name="pr_scode" class="RLock"></Select>
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right">承辦案性 :</td>
		  <td class="whitetablebg"  align="left" colspan=3>結構分類：
				<span id=spanpr_rs_class>
			    <select name="pr_rs_class" id="pr_rs_class" <%=Rdisabled%> onchange="vbscript:pr_rsclass_onchange()" >
				<%
				
				  SQL = "SELECT Cust_code, Code_name,form_name" 
			      SQL = SQL & " FROM Cust_code" 
				  SQL = SQL & " WHERE Code_type = '" & pr_rs_type & "' "
				  if strpr_rs_class<>"" then
				     SQL = SQL & " and cust_code in ('" & replace(strpr_rs_class,",","','") & "') "
				  end if
				  SQL = SQL & " order by sortfld " 
				
				response.write sql&"<br>"
				call ShowSelect3(conn,SQL,true,pr_rs_class)%>			
			</select>
			</span>
			 	案性：<span id=spanpr_rs_code>
			 	<select TYPE=text NAME=pr_rs_code SIZE=1 <%=Rdisabled%> onchange="vbscript:getrsclassData">
							
							
				<%SQL="select cust_code,code_name,form_name from cust_code where code_type='bjtrs_code' and ref_code = '" & pr_rs_type & "' "
				  SQL = SQL & " and (end_date is null or end_date = '' or end_date > getdate())"	
				  if pr_rs_class<>"" then
				     SQL = SQL & " and form_name= '" & pr_rs_class & "' "
				  end if				
				  SQL =  SQL & " order by sortfld"
				  'response.write sql&"<br>"
				call ShowSelect3(conn,SQL,true,pr_rs_code)%>
				</select>
				</span>
				<input type="hidden" id="pr_rs_type" name="pr_rs_type" value="<%=pr_rs_type%>">
				
		</td>
	</TR>
	<Tr>
		<td class="lightbluetable" align="right">分案說明 :</td>
		<TD class=lightbluetable colspan=3>
			<textarea ROWS="6" style="width:90%" id=Br_remark name="Br_remark" class="RLock"><%=Br_remark%></textarea>
		</TD>
	</tr>
</table>


<script language="javascript" type="text/javascript">
    var br_form = {};
    br_form.init = function () {
        if ("<%#case_no%>" != "") {
            br_form.loadOpt();
        }
        $("#span_last_date0").showFor($("#span_last_date").html()!= "");
    }

    br_form.loadOpt = function () {
        var jOpt = br_opt.opt[0];
        $("#pr_branch").val(jOpt.pr_branch || "B");
        br_form.getPrScode();
        $("#pr_scode").val(jOpt.pr_scode);
        $("#ctrl_date").val(dateReviver(jOpt.ctrl_date, "yyyy/M/d"));
        $("#span_last_date").html(dateReviver(jOpt.last_date, "yyyy/M/d"));

        if (jOpt.ctrl_date == "") {
            var Adate = dateConvert(jOpt.last_date).addDays(-1);
            if (Adate < (new Date()))
                $("#ctrl_date").val(dateReviver(jOpt.last_date, "yyyy/M/d"));
            else
                $("#ctrl_date").val(Adate);
        }
    }

    br_form.getPrScode = function () {
        $("#pr_scode").getOption({//爭議組承辦人員
            url: "../ajax/LookupDataCnn.aspx?type=GetPrScode&submitTask=A&pr_branch=" + $("#pr_branch").val(),
            valueFormat: "{scode}",
            textFormat: "{scode}_{sc_name}"
        });
    }
</script>
