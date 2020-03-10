<%@ Control Language="C#" ClassName="case_form" %>

<script runat="server">
    protected string prgid = HttpContext.Current.Request["prgid"];//功能權限代碼
    protected string SQL = "";

    protected string branch = "";
    protected string opt_sqlno = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";
        
        this.DataBind();
    }
</script>

<TABLE border=0 class=bluetable cellspacing=1 cellpadding=2 width="100%">
<TR>
	<td class="lightbluetable" id=salename>洽案營洽 :</td>
	<td class="whitetablebg"  align="left" colspan=3>
		<select id="F_tscode" name="F_tscode" class="Lock"></SELECT>
	</td>
</TR>
<TR>
	<TD class=lightbluetable align=left colspan=4><strong>案性及費用：</strong></TD>
</TR>
<TR>
<TD class=whitetablebg align=center colspan=4>
	<TABLE border=0 class=bluetable cellspacing=1 cellpadding=2 >
		<TD class=lightbluetable align=right width="4%">案&nbsp;&nbsp;&nbsp;&nbsp;性：</TD>
		<TD class=whitetablebg width=10%><select TYPE=text id=tfy_Arcase NAME=tfy_Arcase class="Lock"></SELECT></TD>
		<TD class=lightbluetable align=right width=4%>服務費：</TD>
		<TD class=whitetablebg  align="left">
            <INPUT TYPE=text NAME=nfyi_Service class="Lock" SIZE=8 maxlength=8 style="text-align:right;" ><INPUT TYPE=hidden NAME=Service>
		</TD>
		<TD class=lightbluetable align=right width=4%>規費：</TD>
		<TD class=whitetablebg align="left"><INPUT TYPE=text NAME=nfyi_Fees  class="Lock" size=8 maxlength=8 style="text-align:right;" ><INPUT TYPE=hidden NAME=Fees></TD>
		</TR>
			<tr id=ta_##>
				<td class=lightbluetable align=right width="4%">_##.其他費用：</td>
				<td class=whitetablebg align=left width="10%">
				<select id="nfyi_item_Arcase_##" name="nfyi_item_Arcase_##" disabled></select> x <input type=text name="nfyi_item_count_##" size=2 maxlength=2 value="" class="Lock">項</td>
				<td class=lightbluetable align=right width=4%>服務費：</td>
				<td class=whitetablebg align=left width=5%>
				<INPUT TYPE=text NAME=nfyi_Service_## SIZE=8 maxlength=8 style="text-align:right;" class="Lock">
				<input type=hidden name=nfzi_Service_## SIZE=5 value=nfyi_service_##.value>
				</td>
				<td class=lightbluetable align=right width=4%>規費：</td>
				<td class=whitetablebg align=left width=5%>
				<INPUT TYPE=text NAME=nfyi_fees_## SIZE=8 maxlength=8 style="text-align:right;" class="Lock">
				<input type=hidden name=nfzi_fees_## SIZE=5>
				</td>
			</tr>
		<TR>
			<td class=lightbluetable align=right colspan=2>小計：</td>
			<td class=lightbluetable align=right>服務費：</td>
			<td class=whitetablebg align=left><INPUT TYPE=text NAME=nfy_service SIZE=8 maxlength=8 style="text-align:right;" class="Lock" value="<%=Service%>"></td>
			<td class=lightbluetable align=right>規費：</td>
			<td class=whitetablebg align=left><INPUT TYPE=text NAME=nfy_fees SIZE=8 maxlength=8 style="text-align:right;" class="Lock" value="<%=Fees%>"></td>
		</TR>
		<TR>
			<TD class=lightbluetable align=right width="4%">轉帳費用：</TD>
			<TD class=whitetablebg width="11%">
                <select TYPE=text NAME=tfy_oth_arcase class="Lock"></SELECT>
			</TD>
			<TD class=lightbluetable align=right width=4%>轉帳金額：</TD>
			<TD class=whitetablebg width=5%><input type="text" name="nfy_oth_money" size="8" style="text-align:right;" class="Lock" value=<%=oth_money%>></TD>
			<TD class=lightbluetable align=right width=4%>轉帳單位：</TD>
			<TD class=whitetablebg width=5%>
			<select TYPE=text NAME=tfy_oth_code class="Lock"></SELECT>
			</TD>
		</TR>
		<TR>
			<TD class=lightbluetable align=right colspan=2>合計：</TD>
			<TD class=whitetablebg colspan=4>
                <INPUT TYPE=text NAME=OthSum SIZE=7  class="Lock" value=<%=othSum%>>
			</TD>
		</TR>
	</TABLE>
</TD>
</TR>
<TR>
	<TD class=lightbluetable align=right>請款註記：</TD>
	<TD class=whitetablebg>
        <Select NAME=tfy_Ar_mark class="Lock"></SELECT>
	</TD>
	<TD class=lightbluetable align=right>折扣率：</TD>
	<TD class="whitetablebg">
        <input TYPE="hidden" NAME="nfy_Discount" value="<%=Discount%>">
        <input TYPE=text NAME="Discount" class="Lock" value="<%=Discount%>%">
	    <INPUT TYPE=checkbox NAME=tfy_discount_chk value="Y"  class="Lock" >折扣請核單
	</td>
</TR>		
<TR>
	<TD class=lightbluetable align=right>案源代碼：</TD>
	<TD class=whitetablebg>
        <Select NAME=tfy_source class="Lock"></SELECT>
	</TD>
	<TD class=lightbluetable align=right>契約號碼：</TD>
	<TD class=whitetablebg>
        <input type="radio" name="Contract_no_Type"  class="Lock">
        <INPUT TYPE=text NAME=tfy_Contract_no SIZE=10 MAXLENGTH=10  class="Lock">
	    <span id="contract_type" style="display:">
		<input type="radio" name="Contract_no_Type" class="Lock">後續案無契約書
	    </span>
	    <span style="display:none"><!--2015/12/29修改，併入C不顯示-->
		    <input type="radio" name="Contract_no_Type" class="Lock">特案簽報
	    </span>	
	    <input type="radio" name="Contract_no_Type" class="Lock">其他契約書無編號/特案簽報
	    <input type="radio" name="Contract_no_Type" value="M" onclick="vbscript: contract_type_ctrl()" class="Lock">總契約書
	    <span id="span_btn_contract" style="display:none">
		    <INPUT TYPE=text NAME=Mcontract_no SIZE=10 MAXLENGTH=10 readonly class="gsedit">
		    <input type=button class="sgreenbutton" name="btn_contract" value="查詢總契約書" class="Lock">
		    +客戶案件委辦書
	    </span>
	    <br>
	</TD>
</TR>
<TR>
	<TD class=lightbluetable align=right>法定期限：</TD>
	<TD class=whitetablebg align=left colspan=3>
        <INPUT type=text NAME=dfy_last_date SIZE=10  class="dateField Lock" value="<%=last_date%>">
	</TD>
</TR>
<TR>
	<TD class=lightbluetable align=right>其他接洽：<BR>事項記錄：</TD>
	<TD class=whitetablebg colspan=3><TEXTAREA NAME=tfy_Remark ROWS=6 COLS=70 class="Lock"><%=remark%></TEXTAREA>
	</TD>
</TR>
</TABLE>
<input type=hidden name="TaCount" value="">
	
<script>
    var case_form={};
    case_form.init = function () {
        $("#F_tscode").getOption({//洽案營洽
            url: "../ajax/AjaxGetSqlDataBranch.aspx",
            data: { branch: "<%#branch%>", sql: "select distinct scode,sc_name,scode1 from sysctrl.dbo.vscode_roles where branch='<%#branch%>' and dept='T' and syscode='<%#branch%>Tbrt' and roles='sales' order by scode1" },
            valueFormat: "{scode}",
            textFormat: "{sc_name}"
        });
        $("#tfy_Arcase").getOption({//案性
            url: getRootPath() + "/AJAX/CaseData.aspx",
            data: { type: "arcaselist", branch: "<%#branch%>", opt_sqlno: "<%#opt_sqlno%>" },
            valueFormat: "{rs_code}",
            textFormat: "{rs_code}---{rs_detail}"
        });
        $("#tfy_Arcase").getOption({//其他費用
            url: getRootPath() + "/AJAX/CaseData.aspx",
            data: { type: "arcaseItemList", branch: "<%#branch%>", opt_sqlno: "<%#opt_sqlno%>" },
            valueFormat: "{rs_code}",
            textFormat: "{rs_code}---{rs_detail}"
        });


        $.ajax({
            type: "get",
            url: getRootPath() + "/AJAX/DmtData.aspx?type=brcust&branch=<%#branch%>&opt_sqlno=<%#opt_sqlno%>",
            async: false,
            cache: false,
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                if (JSONdata.length == 0) {
                    toastr.warning("無客戶資料可載入！");
                    return false;
                }
                var j = JSONdata[0];
                $("#F_cust_area").val(j.cust_area);
                $("#F_cust_seq").val(j.cust_seq);
                $("#F_ap_country").val(j.ap_country);
                $("#F_apclass").val(j.apclass + " " + j.apclassnm);
                $("#F_ref_seq").val(j.ref_seq + " " + j.ref_seqnm);
                $("#F_id_no").val(j.apcust_no);
                $("#F_ap_cname1").val(j.ap_cname1);
                $("#F_ap_cname2").val(j.ap_cname2);
                $("#F_ap_ename1").val(j.ap_ename1);
                $("#F_ap_ename2").val(j.ap_ename2);
                $("#F_ap_crep").val(decodeStr(j.ap_crep));
                $("#F_ap_erep").val(j.ap_erep);
                $("#F_ap_zip").val(j.ap_zip);
                $("#F_ap_addr1").val(j.ap_addr1);
                $("#F_ap_addr2").val(j.ap_addr2);
                $("#F_ap_eaddr1").val(j.ap_eaddr1);
                $("#F_ap_eaddr2").val(j.ap_eaddr2);
                $("#F_ap_eaddr3").val(j.ap_eaddr3);
                $("#F_ap_eaddr4").val(j.ap_eaddr4);
                $("#F_www").val(j.www);
                $("#F_email").val(j.email);
                $("#F_acc_zip").val(j.acc_zip);
                $("#F_acc_addr1").val(j.acc_addr1);
                $("#F_acc_addr2").val(j.acc_addr2);
                $("#F_acc_tel0").val(j.acc_tel0);
                $("#F_acc_tel").val(j.acc_tel);
                $("#F_acc_tel1").val(j.acc_tel1);
                $("#F_acc_fax").val(j.acc_fax);
                $("#F_mag").val(j.magnm);
                $("#F_con_code").val(j.con_code);
                $("#F_con_term").val(dateReviver(j.con_term, "yyyy/M/d"));
                $("#F_plevel").val(j.plevel);
                $("#F_tlevel").val(j.tlevel);
                $("#F_pdis_type").val(j.pdis_type);
                $("#F_tdis_type").val(j.tdis_type);
                $("#F_ppay_type").val(j.ppay_type);
                $("#F_tpay_type").val(j.tpay_type);
                $("#F_mark").val(decodeStr(j.cust_remark));

            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>資料載入失敗！<BR>點擊顯示詳細訊息</a>"); }
        });
    };
</script>
