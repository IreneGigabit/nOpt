<%@ Control Language="C#" ClassName="ext_br_form" %>

<script runat="server">
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string SQL = "";
    protected string submitTask = "";
    protected string branch = "";
    protected string opt_sqlno = "";
    protected string case_no = "";

    protected string pr_branch = "";
    protected string pr_rs_type = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";
        case_no = Request["case_no"] ?? "";
        submitTask = Request["submitTask"] ?? "";

        pr_branch = Funcs.getcust_code("OEBranch", "", "sortfld").Option("{cust_code}", "{code_name}", false);
        pr_rs_type = Funcs.GetBJRsType();
        this.DataBind();
    }
</script>

<%=Sys.GetAscxPath(this)%>
<input type="text" name="br_source" id="br_source"><!--記錄分案來源-->		
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
			<Select id="pr_branch" name="pr_branch" class="RLock"><%#pr_branch%></Select>
		</td>
		<td class="lightbluetable"  align="right">承辦人員 :</td>
		  <td class="whitetablebg"  align="left">
			<Select id="pr_scode" name="pr_scode" class="RLock"></Select>
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right">承辦案性 :</td>
		  <td class="whitetablebg"  align="left" colspan=3>
            結構分類：
            <select name="pr_rs_class" id="pr_rs_class" class="RLock" ></select>
            案性：
            <select id=pr_rs_code NAME=pr_rs_code class="RLock"></select>
            <input type="text" id="pr_rs_type" name="pr_rs_type" value="<%#pr_rs_type %>">
		</td>
	</TR>
	<Tr>
		<td class="lightbluetable" align="right">分案說明 :</td>
		<TD class=lightbluetable colspan=3>
			<textarea ROWS="6" style="width:90%" id=Br_remark name="Br_remark" class="RLock"></textarea>
		</TD>
	</tr>
</table>


<script language="javascript" type="text/javascript">
    var br_form = {};
    br_form.init = function () {
        br_form.getPrScode();//取得承辦人員
        br_form.getRsClass();//取得結構分類
        $("#pr_rs_class").triggerHandler("change");//依結構分類帶案性代碼
    }

    br_form.loadOpt = function () {
        var jOpt = br_opte.opte[0];
        $("#pr_branch").val(jOpt.pr_branch || "B");
        br_form.getPrScode();
        $("#pr_scode").val(jOpt.bpr_scode);
        $("#ctrl_date").val(dateReviver(jOpt.ctrl_date, "yyyy/M/d"));
        $("#span_last_date").html(dateReviver(jOpt.last_date, "yyyy/M/d"));
        $("#Br_remark").val(jOpt.br_remark);

        $("#pr_rs_type").val(jOpt.pr_rs_type);
        br_form.getRsClass();
        $("#pr_rs_class").val(jOpt.pr_rs_class);
        $("#pr_rs_class").triggerHandler("change");//依結構分類帶案性代碼
        $("#pr_rs_code").val(jOpt.pr_rs_code);
    }

    br_form.getPrScode = function () {
        $("#pr_scode").getOption({//爭議組承辦人員
            url: "../ajax/LookupDataCnn.aspx?type=GetPrScode&submitTask=A&pr_branch=" + $("#pr_branch").val(),
            valueFormat: "{scode}",
            textFormat: "{scode}_{sc_name}"
        });
    }

    //取得結構分類
    br_form.getRsClass = function () {
        $("#pr_rs_class").getOption({
            url: "../ajax/bjtrs_class.aspx?rs_type=" + $("#pr_rs_type").val(),
            valueFormat: "{rs_class}",
            textFormat: "{rs_class}_{rs_class_name}",
        });
    }

    //依結構分類帶案性
    $("#pr_rs_class").change(function () {
        $("#pr_rs_code").getOption({//案性
            url: "../ajax/bjtrs_code.aspx?rs_type=" + $("#pr_rs_type").val() + "&rs_class="+$("#pr_rs_class").val(),
            valueFormat: "{cust_code}",
            textFormat: "{cust_code}_{code_name}",
            attrFormat: "val1='{form_name}'"
        });
    });

    //依案性帶結構分類
    $("#pr_rs_code").change(function () {
        //if ($("#pr_rs_class").val() == "") {
        //    $("#pr_rs_class").getOption({//結構分類
        //        url: "../ajax/bjtrs_class.aspx?rs_type=" + $("#pr_rs_type").val() + "&rs_code=" + $("#pr_rs_code").val(),
        //        valueFormat: "{rs_class}",
        //        textFormat: "{rs_class}_{rs_class_name}",
        //    });
        //}
        $("#pr_rs_class").val($(':selected',this).attr("val1"));
    });
</script>
