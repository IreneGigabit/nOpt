<%@ Control Language="C#" ClassName="br_form" %>

<script runat="server">
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string SQL = "";
    //<%=MapPathSecure(TemplateSourceDirectory)%>\<%=this.GetType().ToString().Replace("ASP.","")%>.ascx
    protected string branch = "";
    protected string opt_sqlno = "";
    
    private void Page_Load(System.Object sender, System.EventArgs e) {
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";
        
        this.DataBind();
    }
</script>

<table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="100%">		
	<Tr>
		<TD align=center colspan=4 class=lightbluetable1><font color="white">分&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;案&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;設&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;定</font></TD>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right" nowrap>預計完成日期 :</td>
		<td class="whitetablebg"  align="left" colspan=3 >
			<input type="text" id="ctrl_date" name="ctrl_date" SIZE=10 class="dateField Lock BRClass">
			<span id="span_last_date0">
			    <font color="blue">區所指定法定期限：</font><font color="red"><span id="span_last_date"></span></font>
			</span>
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right">承辦區所別 :</td>
		<td class="whitetablebg"  align="left">
			<Select id="pr_branch" name="pr_branch" class="Lock"></Select>
		</td>
		<td class="lightbluetable"  align="right">承辦人員 :</td>
		<td class="whitetablebg"  align="left">
			<Select id="pr_scode" name="pr_scode" class="Lock BRClass"></Select>
		</td>
	</TR>
	<Tr>
		<td class="lightbluetable" align="right">分案說明 :</td>
		<TD class=lightbluetable colspan=3 align="center">
			<textarea ROWS="6" style="width:90%" id=Br_remark name="Br_remark" class="Lock BRClass"></textarea>
		</TD>
	</tr>
</table>

<script language="javascript" type="text/javascript">
    var br_form = {};
    br_form.init = function () {
        $("#pr_branch").getOption({//承辦區所別
            url: "../ajax/AjaxGetSqlData.aspx",
            data: { sql: "select cust_code,code_name from cust_code where code_type='OBranch'" },
            valueFormat: "{cust_code}",
            textFormat: "{code_name}",
            showEmpty: false
        });
        $("#pr_scode").getOption({//爭議組承辦人員
            url: "../ajax/ScodeData.aspx?type=GetPrScode",
            valueFormat: "{scode}",
            textFormat: "{scode}_{sc_name}"
        });

        var jOpt = br_opt.opt[0];
        $("#pr_branch").val(jOpt.pr_branch||"B");
        $("#pr_scode").val(jOpt.pr_scode);
        $("#ctrl_date").val(jOpt.ctrl_date);
        $("#span_last_date").html(dateReviver(jOpt.last_date, "yyyy/M/d"));
        $("#span_last_date0").showFor(jOpt.last_date != "");

        if (jOpt.ctrl_date == "") {
            var Adate = dateConvert(jOpt.last_date).addDays(-1);
            if (Adate<(new Date()))
                $("#ctrl_date").val(dateReviver(jOpt.last_date, "yyyy/M/d"));
            else
                $("#ctrl_date").val(Adate);
        }
    }
</script>
