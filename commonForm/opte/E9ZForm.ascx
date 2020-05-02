<%@ Control Language="C#" ClassName="e9z_form" %>

<script runat="server">
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string SQL = "";
    protected string branch = "";
    protected string opt_sqlno = "";

    protected string tfy_end_type = "";
    public string main_branch = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";

        tfy_end_type = Funcs.getcust_code_mul("Tend_type", "", "sortfld").Option("{cust_code}", "{code_name}");

        this.DataBind();
    }
</script>

<%=Sys.GetAscxPath(this)%>
<input type=hidden id=tfz1_main_flag name=tfz1_main_flag value="Y1"><!--記錄用案件申請人或異動資料update ext_apcust-->
<table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="100%">
	<tr>
		<TD align=center colspan=8 class=lightbluetable1>
            <font color=white>交&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;辦&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;說&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;明</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		    <input type="button" value="重新抓取區所交辦說明資料" class="c1button ALock"  id="GetBranch_remark_button" name="GetBranch_remark_button">
		</TD>
	</tr>
	<tr>
		<td class="lightbluetable" align=right>交辦國外所說明：</td>
		<td class="whitetablebg" colspan="7"><TEXTAREA rows=5 cols=80 id=tfz1_remark1 name=tfz1_remark1 class="PLock"></TEXTAREA></td>
	</tr>	
	<tr>
		<td class="lightbluetable" align=right>交辦爭議組說明：</td>
		<td class="whitetablebg" colspan="7"><TEXTAREA rows=15 cols=80 id=tfz1_remark2 name=tfz1_remarkb class="PLock"></TEXTAREA></td>
	</tr>
	<tr>
		<TD class=lightbluetable align=right>法定期限：</TD>
		<TD class=whitetablebg ><input type=text id=tfy_last_date NAME=tfy_last_date size=10 class="PLock"></TD>
	</tr>    
	<tr id="tr_backflag" style="display:none">
		<td class="lightbluetable" align="right" width="14%">結案/復案註記：</td>
		<td class="whitetablebg" colspan=7>
		    <input type=hidden name="oback_flag" id="oback_flag">
		    <input type=hidden name="oend_flag" id="oend_flag">
		    <input type="hidden" name="todoend_flag" id="todoend_flag" value="N"><!--結案流程進行中，N:無 Y:有-->
		    <input type=checkbox name="tfy_back_flag" id="tfy_back_flag" value="Y" onclick="e9z_form.backendflag('back')"><font color=red>復案註記</font>&nbsp;&nbsp;
		    <input type=checkbox name="tfy_end_flag" id="tfy_end_flag" value="Y" onclick="e9z_form.backendflag('end')"><font color=red>結案註記</font>
		    (※復案註記：當案件已結案且此交辦需復案，請勾選(注意：如有結案程序未完成，復案後系統將自動取消結案流程並銷管結案期限)；結案註記：當此交辦需同時指示代理人結案，請勾選(注意：勾選結案系統將進行結案流程並管制結案期限))
		</td>
	</tr>
	<tr id="tr_endtype" style="display:none">
		<td class="lightbluetable" align="right" width="14%">結案原因：</td>
		<td class="whitetablebg" colspan=7>
		    <select name="tfy_end_type" id="tfy_end_type"><%#tfy_end_type%></select>
		</td>
	</tr>
	<tr id="tr_flagremark" style="display:none">
		<td class="lightbluetable" align="right" width="14%">結案/復案說明：</td>
		<td class="whitetablebg" colspan=7>
		    <textarea name="tfy_flag_remark" id="tfy_flag_remark" rows=5 cols=80></textarea>
		</td>
	</tr>
	<tr id="tr_zold_flag" style="display:none">
		<td class="lightbluetable" align="right" width="14%">原雜卷是否結案：</td>
		<td class="whitetablebg" colspan=7>
		    <input type=radio name="zold_flag" id="zold_flagY" value="Y">是
		    <input type=radio name="zold_flag" id="zold_flagN" value="N">否
		    <input type=radio name="zold_flag" id="zold_flagX" value="X">不需<br>
		    <span id="span_zoldflag_remark" style="display:none">
		    ，不結案理由：<input type=text name="zoldflag_remark" id="zoldflag_remark" size=60 maxlength=200>
		    ，交辦結案期限：<input type=text name="zold_ctrl_date" id="zold_ctrl_date" size=10 onblur="ext_form.chkdate(this.id)" class="dateField">
		    </span>
		</td>
	</tr>
</table>


<script language="javascript" type="text/javascript">
    var e9z_form = {};
    e9z_form.init = function () {
        var jCase = br_opte.opte[0];
        $("#tfz1_remark1").val(jCase.remark1);
        $("#tfz1_remark2").val(jCase.remarkb);
        $("#tfy_last_date").val(dateReviver(jCase.last_date, "yyyy/M/d"));
    }

    //原雜卷是否結案
    $("input[name='zold_flag']").click(function () { 
        if ($(this).val()=="Y" ||$(this).val()=="X") {
            $("#span_zoldflag_remark").hide();
        }else{
            $("#span_zoldflag_remark").show();
        }
    });

    //復案結案註記
    e9z_form.backendflag = function (pvalue) {
        if (pvalue == "back") {
            if ($("#tfy_back_flag").prop("checked") == true) {
                $("#tr_endtype").hide();
                $("#tfy_end_type").val("");
                $("#tfy_end_flag").prop("checked", false);
            }
        } else if (pvalue == "end") {
            if ($("#tfy_end_flag").prop("checked") == true) {
                $("#tr_endtype").show();
                $("#tfy_back_flag").prop("checked", false);
            } else {
                $("#tr_endtype").hide();
                $("#tfy_end_type").val("");

            }
        }
    }

    //重新抓取區所交辦資料
    $("#GetBranch_remark_button").click(function () { 
        if (confirm("是否確定重新取得區所交辦說明資料？")) {
            var url = getRootPath() + "/json/get_branchdata.aspx?prgid=<%=prgid%>&datasource=remark&branch=" + $("#Branch").val() + "&case_no=" + $("#case_no").val() + 
                "&opt_sqlno=" + $("#opt_sqlno").val() + "&step_grade=" + $("#bstep_grade").val() + "&seq=" + $("#tfzb_seq").val() + "&seq1=" + $("#tfzb_seq1").val() + "&chkTest=" + $("#chkTest:checked").val();
            //window.open(url, "", "width=800 height=600 top=100 left=100 toolbar=no, menubar=no, location=no, directories=no resizeable=no status=no scrollbars=yes");
            ActFrame.location.href = url;
        }
    });
</script>
