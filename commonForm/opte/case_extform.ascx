<%@ Control Language="C#" ClassName="case_form" %>

<script runat="server">
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string SQL = "";
    protected string branch = "";
    protected string opt_sqlno = "";

    protected string tfz1_country = "", F_tscode = "",tfg_item_Arcase9="";
    protected string tfy_oth_code = "", tfy_Ar_mark = "", tfy_source = "";
    protected string tfy_invoice_chk = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";

        tfz1_country = Funcs.getcountry().Option("{coun_code}", "{coun_c}");
        using (DBHelper cnn = new DBHelper(Conn.Sysctrl).Debug(false)) {
            tfy_oth_code = SHtml.Option(cnn, "SELECT branch,branchname FROM branch_code WHERE class = 'branch'", "{branch}", "{branch}_{branchname}");
        }
        using (DBHelper connB = new DBHelper(Conn.OptB(branch)).Debug(false)) {
            F_tscode = SHtml.Option(connB, "select distinct scode,sc_name,scode1  from sysctrl.dbo.vscode_roles where branch='"+branch+"' and dept='"+ Session["dept"] +"' and syscode='"+branch+"Tbrt' and roles='sales' order by scode1", "{scode}", "{sc_name}");
            SQL = "SELECT rs_code, rs_detail FROM code_ext WHERE rs_type = '" + Request["code_type"] + "' And cr_flag='Y' and left(mark,1)='B' and getdate() >= beg_date and (end_date is null or end_date='' or end_date > getdate()) ORDER BY rs_code";
            tfg_item_Arcase9 = SHtml.Option(connB, SQL, "{rs_code}", "{rs_code}---{rs_detail}");
        }
        tfy_invoice_chk = Funcs.getcust_code_mul("TEinvoice_chk","","sortfld").Option("{cust_code}", "{code_name}");
        tfy_Ar_mark = Funcs.getcust_code_mul("ar_mark","and (mark1 like '%" + Session["SeBranch"] + Session["Dept"] + "E%' or mark1 is null)","").Option("{cust_code}", "{code_name}");
        tfy_source = Funcs.getcust_code_mul("Source","AND cust_code<> '__' AND End_date is null","cust_code").Option("{cust_code}", "({cust_code})---{code_name}");

        this.DataBind();
    }
</script>

<%=Sys.GetAscxPath(this,MapPathSecure(TemplateSourceDirectory))%>
<input type=hidden name=hcountry value="">
<input type=hidden id="nfy_tot_num" name="nfy_tot_num">	
<input type=hidden id="spe_ctrl2" name="spe_ctrl2"><!--判斷是否為權利異動-->
<input type=hidden id="spe_ctrl3" name="spe_ctrl3"><!--判斷是否為分割-->
<input type=hidden id="spe_ctrl4" name="spe_ctrl4"><!--判斷是否為一案多件-->
<input type=hidden id="spe_ctrla" name="spe_ctrla"><!--判斷權利異動種類-->
<input type=hidden id="spe_ctrl6" name="spe_ctrl6"><!--判斷是否已結案可允許不復案-->
<input type=hidden id="spe_ctrl7" name="spe_ctrl7"><!--判斷是否為爭救案性-->
<TABLE border=0 class=bluetable cellspacing=1 cellpadding=2 width="100%">	
	<TR>
		<TD class=lightbluetable align=right>國&nbsp;&nbsp;&nbsp;&nbsp;別：</TD>
		<TD class=whitetablebg>
	        <select id=tfz1_country name=tfz1_country class="QLock" onchange="case_form.ToArcase(reg.tfz1_country.value,reg.tfg_item_Arcase0.value,reg.Ar_Form.value)">
	        <%=tfz1_country%>
	        </select>
		    <INPUT TYPE=hidden id="ext_country" NAME="ext_country">
		    <span id="span_ext_country" style="display:none"></span>
		</TD>
		<td class="lightbluetable" align="right" id=salename>洽案營洽 :</td>
		<td class="whitetablebg"  align="left">
		    <select id="F_tscode" name="F_tscode" class="QLock"><%#F_tscode%></SELECT>
	    </td>
	</TR>
	<tr>
		<TD class=lightbluetable align=right>請款註記：</TD>
		<TD class=whitetablebg colspan=3>
            <input type=hidden name="oar_mark" id="oar_mark">
            <Select id=tfy_Ar_mark name=tfy_Ar_mark onchange="special()" class="QLock"><%#tfy_Ar_mark%></Select>
		</TD>
	</tr>
	<TR>
		<TD class=lightbluetable align=left colspan=4><strong>案性及費用：</strong>
            <input type="button" id="ta_add" name="ta_add" class="cbutton QLock" value="增加費用" onclick="ta_display('Add')">
            <input type="button" id="ta_del" name="ta_del" class="cbutton QLock" value="減少費用" onclick="ta_display('Del')">
		</TD>
	</TR>
	<TR>
		<TD class=whitetablebg align=center colspan=4>
		<TABLE border=0 class=bluetable cellspacing=1 cellpadding=2 width="100%">
			<tr>
				<td class=lightbluetable align=right width="15%">委辦案性：</td>
				<td class=whitetablebg align=left>
				    <select id=tfg_item_Arcase0 name=tfg_item_Arcase0 onchange ="ToArcase(reg.tfz1_country.value , this.value,reg.Ar_Form.value)" class="QLock"></SELECT>
				    <input type="hidden" id="tfy_Arcase" name="tfy_Arcase">
				</td>
				<td class=lightbluetable align=right>服務費：</td>
				<td class=whitetablebg align=left>
				    <INPUT TYPE=text id=tfg_Service0 name=tfg_Service0 SIZE=8 maxlength=8 style="text-align:right;" class="QLock">
				    <INPUT TYPE=hidden id=nfz_Service0 name=nfz_Service0>
				    <INPUT TYPE=hidden id=ifz_Service0 name=ifz_Service0>
				</td>
				<td class=lightbluetable align=right>規費：</td>
				<td class=whitetablebg align=left>
				    <INPUT TYPE=text id=tfg_fees0 name=tfg_fees0 SIZE=8 maxlength=8 style="text-align:right;" class="QLock">
				    <INPUT TYPE=hidden id=nfz_fees0 name=nfz_fees0>
				    <INPUT TYPE=hidden id=ifz_fees0 name=ifz_fees0>
				</td>
			</tr>
			<tr id=ta9 style="display:none">
				<td class=lightbluetable align=right width="15%">公簽證費：</td>
				<td class=whitetablebg align=left>
				<select id=tfg_item_Arcase9 NAME=tfg_item_Arcase9 SIZE=1 onchange ="ToFee(reg.tfz1_country.value, this.value, reg.Ar_Form.value, 9)" class="QLock">
				<%#tfg_item_Arcase9%>
				</select>
				</td>
				<td class=lightbluetable align=right>服務費：</td>
				<td class=whitetablebg align=left>
				<INPUT TYPE=text NAME=tfg_Service9 SIZE=8 maxlength=8 style="text-align:right;"  class="QLock">
				<INPUT TYPE=hidden NAME=nfz_Service9 style="text-align:right;">
				<INPUT TYPE=hidden NAME=ifz_Service9 style="text-align:right;">
				</td>
				<td class=lightbluetable align=right>規費：</td>
				<td class=whitetablebg align=left>
				<INPUT TYPE=text NAME=tfg_fees9 SIZE=8 maxlength=8 style="text-align:right;"  class="QLock">
				<INPUT TYPE=hidden NAME=nfz_fees9 style="text-align:right;">
				<INPUT TYPE=hidden NAME=ifz_fees9 style="text-align:right;">
				</td>
			</tr>
			<tr id=ta_## style="display:none">
				<td class=lightbluetable align=right width="15%">##.其他費用：</td>
				<td class=whitetablebg align=left>
				    <select id="tfg_item_Arcase_##" name="tfg_item_Arcase_##" size=1 onchange ="ToFee(reg.tfz1_country.value ,this.value ,reg.Ar_Form.value,'##')" class="QLock"></select>
                     x <input type=text id="tfg_item_count_##" name="tfg_item_count_##" size=3 maxlength=3 value="" class="QLock">項
				</td>
				<td class=lightbluetable align=right>服務費：</td>
				    <td class=whitetablebg align=left>
				    <INPUT TYPE=text id=tfg_Service_## name=tfg_Service_## SIZE=8 maxlength=8 style="text-align:right;" class="QLock">
				    <input type=hidden id=nfz_Service_## name=nfz_Service_## SIZE=5>
				    <input type=hidden id=ifz_Service_## name=ifz_Service_## SIZE=5>
				</td>
				<td class=lightbluetable align=right>規費：</td>
				<td class=whitetablebg align=left>
				    <INPUT TYPE=text id=tfg_fees_## name=tfg_fees_## SIZE=8 maxlength=8 style="text-align:right;" class="QLock">
				    <input type=hidden id=nfz_fees_## name=nfz_fees_## SIZE=5>
				    <input type=hidden id=ifz_fees_## name=ifz_fees_## SIZE=5>
				</td>
			</tr>
			<tr>
				<td class=lightbluetable align=right colspan=2>小計：</td>
				<td class=lightbluetable align=right>服務費：</td>
				<td class=whitetablebg align=left>
                    <INPUT TYPE=text id=nfy_tot_service name=nfy_tot_service size=8 maxlength=8 style="text-align:right;" class="Lock">
					<INPUT TYPE=hidden id=ifz_tot_service name=ifz_tot_service size=8 maxlength=8 >
				</td>
				<td class=lightbluetable align=right>規費：</td>
				<td class=whitetablebg align=left colspan=3>
                    <INPUT TYPE=text id=nfy_tot_fees name=nfy_tot_fees SIZE=8 maxlength=8 style="text-align:right;" class="Lock">
					<INPUT TYPE=hidden id=ifz_tot_fees name=ifz_tot_fees SIZE=8 maxlength=8 >
				</td>
			</tr>
			<TR>
				<td class=lightbluetable align=right colspan=2></td>	
				<td class=lightbluetable align=right>轉帳金額：</TD>
				<TD class=whitetablebg width=5%><input type="text" id="nfy_oth_money" name="nfy_oth_money" size="8" maxlength=8 value="" style="text-align:right;" onblur="vbs:summary()" class="QLock"></TD>		
				<td class=lightbluetable align=right>轉帳單位：</TD>
				<TD class=whitetablebg width=5%>
				<select id=tfy_oth_code NAME=tfy_oth_code class="QLock">
                    <%#tfy_oth_code%><option value="Z">Z_轉其他人</option>
				</SELECT>
			    <input type="hidden" id="tot_zservice" name="tot_zservice" value=0>
			    <input type="hidden" id="tot_yservice" name="tot_yservice" value=0>
				</TD>
			</TR>
			<tr>
				<td class=lightbluetable align=right>營業稅：</td>
				<td class=whitetablebg align=left>
                    <INPUT TYPE=text id=tfy_Tot_Tax name=tfy_Tot_Tax SIZE=12 style="text-align:right;" class="Lock">　
				    <select id="tfy_invoice_chk" name="tfy_invoice_chk"><%#tfy_invoice_chk%></select>
				</td>
				<td class=lightbluetable align=right>(含稅)合計：</td>
				<td class=whitetablebg align=left colspan=5>
                    <INPUT TYPE=text id=OthSum name=OthSum SIZE=8 style="text-align:right;" class="Lock">
				    (未稅合計：<INPUT TYPE=text id=utaxOthSum name=utaxOthSum SIZE=8 style="text-align:right;" class="Lock">)
				</td>
			</tr>
			<TR style="display:none">
				<TD class=whitetablebg align=center colspan=8>
					<TABLE border=0 class=bluetable cellspacing=1 cellpadding=2 width=100%>
						<TR>
							<td class=lightbluetable2 align=center width=20%>追加服務費</td>
							<td class=lightbluetable2 align=center width=20%>追加規費</td>
							<td class=lightbluetable2 align=center width=20%>已請款服務費</td>
							<td class=lightbluetable2 align=center width=20%>已請款規費</td>
							<td class=lightbluetable2 align=center width=20%>已請款次數</td>
						</TR>
						<TR>
							<td class=whitetablebg><INPUT TYPE=text id=xadd_service name=xadd_service SIZE=8 maxlength=8 style="text-align:right;" class="Lock"></td>
							<td class=whitetablebg><INPUT TYPE=text id=xadd_fees name=xadd_fees SIZE=8 maxlength=8 style="text-align:right;" class="Lock"></td>
							<td class=whitetablebg><INPUT TYPE=text id=xar_service name=xar_service SIZE=8 maxlength=8 style="text-align:right;" class="Lock"></td>
							<td class=whitetablebg><INPUT TYPE=text id=xar_fees name=xar_fees SIZE=8 maxlength=8 style="text-align:right;" class="Lock"></td>
							<td class=whitetablebg><INPUT TYPE=text id=xar_curr name=xar_curr SIZE=8 maxlength=8 style="text-align:right;" class="Lock"></td>
						</TR>
					</TABLE>		  
				</TD>
			</TR> 
		</TABLE>		  
		</TD>
	</TR>
		
	<TR>
		<TD class=lightbluetable align=right>折扣率：</TD>
		<TD class="whitetablebg" colspan=3>
            <input TYPE="hidden" id="nfy_Discount" NAME="nfy_Discount" >
            <input TYPE=text id="Discount" NAME="Discount" class="Lock">
            <INPUT TYPE=checkbox NAME=Discount_chk value="Y" class="QLock">折扣請核單
		</td>
	</TR>
	<TR>
		<TD class=lightbluetable align=right>請核單上傳：</TD>
		<TD class="whitetablebg" colspan=3>
            <input TYPE="radio" name="tfy_upload_chk" value="Y" onclick="uploadchk('Y')" class="QLock">需要<input TYPE="radio" name="tfy_upload_chk" value="N" checked onclick="uploadchk('N')" class="QLock">不需要
		    <input type=hidden id=attach_size name=attach_size >
		    <input type=hidden id=attach name=attach >
		    <input type=text id=tfy_upload_file name=upload_file class="Lock" size=60>
		    <input type=button id=btnupload name=btnupload class="cbutton Lock" value="檔案上傳" onclick="Attach_upload1()">
		    <input type=button id=btnuploaddel name=btnuploaddel class="c1button Lock" value="檔案刪除" onclick="Attach_del1()">
		    <input type=button id=btnuploadview name=btnuploadview class="cbutton QLock" value="檔案檢視" onclick="Attach_view1()">
		</TD>
	</TR>		
	<TR>
		<TD class=lightbluetable align=right>契約號碼：</TD>
		<TD class=whitetablebg>
        <input type="radio" id="Contract_no_Type_N" name="Contract_no_Type" value="N" class="QLock">
            <INPUT TYPE=text id=tfy_Contract_no NAME=tfy_Contract_no SIZE=10 MAXLENGTH=10 onchange="reg.Contract_no_Type(0).checked=true" class="QLock">
		    <span id="contract_type" style="display:">
		        <input type="radio" id="Contract_no_Type_A" name="Contract_no_Type" value="A" class="QLock">後續案無契約書
		    </span>
		    <span style="display:none"><!--2015/12/29修改，併入C不顯示-->
		        <input type="radio" id="Contract_no_Type_B" name="Contract_no_Type" value="B" class="QLock">特案簽報
		    </span>	
	        <input type="radio" id="Contract_no_Type_C" name="Contract_no_Type" value="C" class="QLock">其他契約書無編號/特案簽報
	        <input type="radio" id="Contract_no_Type_M" name="Contract_no_Type" value="M" class="QLock">總契約書
		    <span id="span_btn_contract" style="display:none">
			    <INPUT TYPE=text id=Mcontract_no NAME=Mcontract_no SIZE=10 MAXLENGTH=10 class="gsedit">
			    <input type=button class="sgreenbutton QLock" name="btn_contract" value="查詢總契約書">
			    +客戶案件委辦書
		    </span>
		</TD>
		<TD class=lightbluetable align=right>案源代碼：</TD>
		<TD class=whitetablebg>
            <Select id=tfy_Source NAME=tfy_Source class="QLock"><%#tfy_source%></Select>
		</TD>
	</TR>
	<TR style="display:none">
	<TD class=lightbluetable ></TD> 
	<TD class=whitetablebg colspan=3>
		<INPUT TYPE=checkbox NAME=tfy_ar_chk  value="Y">請款單／收據與附本寄發
		<INPUT TYPE=checkbox NAME=tfy_ar_chk1 value="Y">即發請款單／收據
	</TD>
	</TR>
	<TR>
		<TD class=lightbluetable align=right>承辦期限：</TD>
		<TD class=whitetablebg colspan=3>
		<span id=sp_tfy_urgent style="display:none">
		<input type=radio name=tfy_urgent value="NN" onclick="urgent_onclick()" class="QLock">非急件
		<input type=radio name=tfy_urgent value="Y1" onclick="urgent_onclick()" class="QLock">急件(<=3日)
		<input type=radio name=tfy_urgent value="Y2" onclick="urgent_onclick()" class="QLock">急件(>3日,<7日)&nbsp;&nbsp;
		</span>
		<input type=text NAME=tfy_urgent_date size=10 class="QLock">(<7天為急件期限)
		</TD>
		   
	</TR>	
	<TR>
		<TD class=lightbluetable align=right>其他接洽：<BR>事項記錄：</TD>
		<TD class=whitetablebg colspan=3>
            <TEXTAREA id=tfy_Remark NAME=tfy_Remark ROWS=7 COLS=60 class="QLock"></TEXTAREA>
		    <input type=hidden name="nfy_tot_case" id="nfy_tot_case" value="0">
		    <input type=hidden name="TaCount" id="TaCount" value="">
		    <input type=hidden name="anfees" id="anfees" value="">
		    <input type=hidden name="tfy_ar_code" id="tfy_ar_code" value="N">	
		</TD>
	</TR>				
</TABLE>
<input type=hidden id="code_type" name="code_type">



	
<script language="javascript" type="text/javascript">
    var case_form = {};
    case_form.init = function () {
        $("#tfg_item_Arcase0").getOption({//案性
            dataList: br_opte.arcase,
            valueFormat: "{rs_code}",
            textFormat: "{rs_code}---{rs_detail}"
        });
        $("select[id='tfg_item_Arcase_##']").getOption({//其他費用
            dataList: br_opte.arcase_item,
            valueFormat: "{rs_code}",
            textFormat: "{rs_code}---{rs_detail}"
        });

        //案性/案源
        var jCase = br_opte.opte[0];
        $("#tfz1_country").val(jCase.country);
        $("#F_tscode").val(jCase.in_scode);
        $("#tfy_Arcase").val(jCase.arcase);
        $("#tfg_item_Arcase0").val(jCase.arcase);
        $("#tfy_oth_code").val(jCase.oth_code);
        $("#tfy_Ar_mark").val(jCase.ar_mark);
        $("#tfy_discount_chk").prop("checked", jCase.discount_chk == "Y");
        $("#tfy_Source").val(jCase.source);

        if (jCase.contract_type != "") {
            $("input[name='Contract_no_Type'][value='" + jCase.contract_type + "']").prop("checked", true);
            if (jCase.contract_type == "M") {
                $("#span_btn_contract").show();
                $("#Mcontract_no").val(jCase.contract_no);
            }
            if ("ABCM".indexOf(jCase.contract_type)==-1) {
                $("input[name='Contract_no_Type']:eq(0)").prop("checked", true);
                $("#tfy_Contract_no").val(jCase.contract_no);
            }
        }
        $("#tfy_ar_code").val(jCase.ar_code);

        //產生其他費用tr
        for (z = 1; z <= jCase.tot_case; z++) {
            var copyStr = "<tr id='ta_" + z + "' style='display:none'>" + $("tr[id='ta_##']").html().replace(/##/g, z) + "</tr>";
            $(copyStr).insertBefore("tr[id='ta_##']");
        }

        //費用
        $.each(br_opte.casefee, function (i, item) {
            if (item.item_sql == "0") {
                $("#tfg_item_Arcase0").val(item.item_arcase == "" ? "0" : item.item_arcase);
                $("#tfg_Service0").val(item.item_service == "" ? "0" : item.item_service);
                $("#nfz_Service0").val("0");
                $("#tfg_fees0").val(item.item_fees == "" ? "0" : item.item_fees);
                $("#nfz_fees0").val("0");
                $("#TaCount").val(item.item_sql);
            } else {
                $("#tfg_item_Arcase_" + item.item_sql).val(item.item_arcase);
                $("#tfg_item_count_" + item.item_sql).val(item.item_count);
                $("#tfg_Service_" + item.item_sql).val(item.item_service);
                $("#nfz_Service_" + item.item_sql).val("0");
                $("#tfg_fees_" + item.item_sql).val(item.item_fees);
                $("#nfz_fees_" + item.item_sql).val("0");
                if (item.p_service == "0" && item.p_fees == "0") {
                    $("#anfees").val("N");
                } else {
                    $("#anfees").val("Y");
                }
                $("#TaCount").val(item.item_sql);

                $("#ta_" + item.item_sql).show();
            }
        });

        $("#nfy_tot_service").val(jCase.service);
        $("#nfy_tot_fees").val(jCase.fees);
        $("#tfy_Tot_Tax").val(jCase.tot_tax);
        $("#nfy_oth_money").val(jCase.oth_money);
        $("#tfy_oth_code").val(jCase.oth_code);
        $("#utaxOthSum").val(parseFloat(jCase.service) + parseFloat(jCase.fees) + parseFloat(jCase.oth_money));
        $("#OthSum").val(jCase.othsum);
        $("#xadd_service").val(jCase.add_service);
        $("#xadd_fees").val(jCase.add_fees);
        $("#xar_service").val(jCase.ar_service);
        $("#xar_fees").val(jCase.ar_fees);
        $("#xar_curr").val(jCase.ar_curr);
        $("#nfy_Discount").val(jCase.discount);
        $("#Discount").val(jCase.discount + "%");
        $("#tfy_invoice_chk").val(jCase.invoice_chk);
        $("#code_type").val(jCase.arcase_type);
    }
</script>
