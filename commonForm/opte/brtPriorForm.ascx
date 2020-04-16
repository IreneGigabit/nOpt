<%@ Control Language="C#" ClassName="prior_form" %>

<script runat="server">
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string SQL = "";
    protected string branch = "";
    protected string opt_sqlno = "";

    protected string html_country = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";

        html_country = Funcs.getcountry().Option("{coun_code}", "{coun_code}_{coun_c}");
        this.DataBind();
    }
</script>

<%=Sys.GetAscxPath(this, MapPathSecure(TemplateSourceDirectory))%>
<input type=text id=priornum name=priornum value=0><!--筆數-->
<table border="0" id=tabprior class="bluetable" cellspacing="1" cellpadding="2" width="100%">
	<THEAD>
	<TR class=whitetablebg align=center>
		<TD colspan=5 align=left>
			<input type=button value="增加一筆優先權" class="cbutton QLock" id=prior_Add_button name=prior_Add_button>
			<input type=button value="減少一筆優先權" class="cbutton QLock" id=prior_Del_button name=prior_Del_button>
		</TD>
	</TR>
	<TR align=center class=lightbluetable>
		<TD></TD><TD>是否主張</TD><TD>優先權申請日</TD><TD>申請案號</TD><TD>首次申請國家</TD>
	</TR>
	</THEAD>
	<TFOOT style="display:none">
		<TR>
			<TD class=lightbluetable align=right>
                <input type=text id="priornum_##" name="priornum_##" class=Lock size=2 value="##.">
	            <input type=hidden id="prior_sqlno_##" name="prior_sqlno_##">
			</TD>
			<TD class=lightbluetable align=right>
                <input type=radio name=prior_flag_## value='Y' class="QLock">是
	            <input type=radio name=prior_flag_## value='N' class="QLock">否
			</TD>
			<TD class=lightbluetable align=right>
                <input type=text size=10 maxlength=10 id=prior_date_## name=prior_date_## onblur="priordate_onblur('_##')" class="dateField QLock">
			</TD>
			<TD class=lightbluetable align=right>
                <input type=text id="prior_no_##" name="prior_no_##" size=22 maxlength=20 class="QLock">
			</TD>
			<TD class=lightbluetable align=right>
                <select id=prior_country_## name=prior_country_## class="QLock"><%=html_country%></select>
			</TD>
		</TR>
	</TFOOT>
	<TBODY>
	</TBODY>
</table>


<script language="javascript" type="text/javascript">
    var ext_form_prior = {};
    ext_form_prior.init = function () {
        //優先權
        var jPrior = br_opt.opte_prior;
        $.each(jPrior, function (i, item) {
            //增加一筆
            $("#prior_Add_button").click();

            //填資料
            var nRow = $("#priornum").val();
            $("input[name='prior_flag_'"+nRow+"][value='" + item.prior_flag + "']").prop("checked", true);
            $("#prior_date_" + nRow).val(dateReviver(jOpt.prior_date, "yyyy/M/d"));
            $("#prior_no_" + nRow).val(item.prior_no);
            $("#prior_country_" + nRow).val(item.prior_country);
        });
    }
    
    //增加一筆優先權
    $("#prior_Add_button").click(function () { ext_form_prior.AddPrior(); });
    ext_form_prior.AddPrior = function () {
        var nRow = parseInt($("#priornum").val(), 10) + 1;
        //複製樣板
        var copyStr = "";
        $("#tabprior>tfoot tr").each(function (i) {
            copyStr += "<tr id='tr_ap_" + nRow + "'>" + $(this).html().replace(/##/g, nRow) + "</tr>"
        });
        $("#tabprior>tbody").append(copyStr);
        $("#priornum").val(nRow);
    }

    //減少一筆優先權
    $("#prior_Del_button").click(function () { ext_form_prior.DelPrior(); });
    ext_form_prior.DelPrior = function () {
        var nRow = parseInt($("#priornum").val(), 10);
        $('#tr_ap_' + nRow).remove();
        $("#priornum").val(Math.max(0, nRow - 1));
    }
</script>
