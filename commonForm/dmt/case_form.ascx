<%@ Control Language="C#" ClassName="case_form" %>

<script runat="server">
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
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
	<td class="lightbluetable" align=right>洽案營洽 :</td>
	<td class="whitetablebg" align="left" colspan=3>
		<select id="F_tscode" name="F_tscode" class="Lock"></SELECT>
	</td>
</TR>
<TR>
	<TD class=lightbluetable align=left colspan=4><strong>案性及費用：</strong></TD>
</TR>
<TR>
    <TD class=whitetablebg align=center colspan=4>
	    <TABLE border=0 class=bluetable cellspacing=1 cellpadding=2 >
		    <TR>
		        <TD class=lightbluetable align=right width="4%">案&nbsp;&nbsp;&nbsp;&nbsp;性：</TD>
		        <TD class=whitetablebg width=10%><select id=tfy_Arcase NAME=tfy_Arcase class="Lock"></SELECT></TD>
		        <TD class=lightbluetable align=right width=4%>服務費：</TD>
		        <TD class=whitetablebg  align="left">
                    <INPUT TYPE=text id=nfyi_Service name=nfyi_Service class="Lock" SIZE=8 maxlength=8 style="text-align:right;" >
                    <INPUT TYPE=hidden id=Service name=Service>
		        </TD>
		        <TD class=lightbluetable align=right width=4%>規費：</TD>
		        <TD class=whitetablebg align="left"><INPUT TYPE=text id=nfyi_Fees name=nfyi_Fees class="Lock" size=8 maxlength=8 style="text-align:right;" ><INPUT TYPE=hidden id=Fees name=Fees></TD>
		    </TR>
		    <tr id=ta_## style="display:none">
			    <td class=lightbluetable align=right width="4%">##.其他費用：</td>
			    <td class=whitetablebg align=left width="10%">
			    <select id="nfyi_item_Arcase_##" name="nfyi_item_Arcase_##" class="Lock"></select> x <input type=text id="nfyi_item_count_##" name="nfyi_item_count_##" size=2 maxlength=2 value="" class="Lock">項</td>
			    <td class=lightbluetable align=right width=4%>服務費：</td>
			    <td class=whitetablebg align=left width=5%>
			    <INPUT TYPE=text id=nfyi_Service_## name=nfyi_Service_## SIZE=8 maxlength=8 style="text-align:right;" class="Lock">
			    <input type=hidden id=nfzi_Service_## name=nfzi_Service_## SIZE=5>
			    </td>
			    <td class=lightbluetable align=right width=4%>規費：</td>
			    <td class=whitetablebg align=left width=5%>
			    <INPUT TYPE=text id=nfyi_fees_## name=nfyi_fees_## SIZE=8 maxlength=8 style="text-align:right;" class="Lock">
			    <input type=hidden id=nfzi_fees_## name=nfzi_fees_## SIZE=5>
			    </td>
		    </tr>
		    <TR>
			    <td class=lightbluetable align=right colspan=2>小計：</td>
			    <td class=lightbluetable align=right>服務費：</td>
			    <td class=whitetablebg align=left><INPUT TYPE=text id=nfy_service NAME=nfy_service SIZE=8 maxlength=8 style="text-align:right;" class="Lock"></td>
			    <td class=lightbluetable align=right>規費：</td>
			    <td class=whitetablebg align=left><INPUT TYPE=text id=nfy_fees NAME=nfy_fees SIZE=8 maxlength=8 style="text-align:right;" class="Lock"></td>
		    </TR>
		    <TR>
			    <TD class=lightbluetable align=right width="4%">轉帳費用：</TD>
			    <TD class=whitetablebg width="11%">
                    <select id=tfy_oth_arcase NAME=tfy_oth_arcase class="Lock"></SELECT>
			    </TD>
			    <TD class=lightbluetable align=right width=4%>轉帳金額：</TD>
			    <TD class=whitetablebg width=5%><input type="text" id="nfy_oth_money" name="nfy_oth_money" size="8" style="text-align:right;" class="Lock"></TD>
			    <TD class=lightbluetable align=right width=4%>轉帳單位：</TD>
			    <TD class=whitetablebg width=5%>
			    <select id=tfy_oth_code NAME=tfy_oth_code class="Lock"></SELECT>
			    </TD>
		    </TR>
		    <TR>
			    <TD class=lightbluetable align=right colspan=2>合計：</TD>
			    <TD class=whitetablebg colspan=4>
                    <INPUT TYPE=text id=OthSum NAME=OthSum SIZE=7 class="Lock">
			    </TD>
		    </TR>
	    </TABLE>
    </TD>
</TR>
<TR>
	<TD class=lightbluetable align=right>請款註記：</TD>
	<TD class=whitetablebg>
        <Select id=tfy_Ar_mark name=tfy_Ar_mark class="Lock"></Select>
	</TD>
	<TD class=lightbluetable align=right>折扣率：</TD>
	<TD class="whitetablebg">
        <input TYPE="hidden" id="nfy_Discount" name="nfy_Discount">
        <input TYPE=text id="Discount" name="Discount" class="Lock">
	    <INPUT TYPE=checkbox id=tfy_discount_chk name=tfy_discount_chk value="Y"  class="Lock" >折扣請核單
	</td>
</TR>		
<TR>
	<TD class=lightbluetable align=right>案源代碼：</TD>
	<TD class=whitetablebg>
        <Select id=tfy_source name=tfy_source class="Lock"></Select>
	</TD>
	<TD class=lightbluetable align=right>契約號碼：</TD>
	<TD class=whitetablebg>
        <input type="radio" id="Contract_no_Type_N" name="Contract_no_Type" value="N" class="Lock">
        <INPUT TYPE=text id=tfy_Contract_no name=tfy_Contract_no SIZE=10 MAXLENGTH=10  class="Lock">
		<input type="radio" id="Contract_no_Type_A" name="Contract_no_Type" value="A" class="Lock">後續案無契約書
	    <span style="display:none"><!--2015/12/29修改，併入C不顯示-->
		<input type="radio" id="Contract_no_Type_B" name="Contract_no_Type" value="B" class="Lock">特案簽報
	    </span>	
	    <input type="radio" id="Contract_no_Type_C" name="Contract_no_Type" value="C" class="Lock">其他契約書無編號/特案簽報
	    <input type="radio" id="Contract_no_Type_M" name="Contract_no_Type" value="M" class="Lock">總契約書
	    <span id="span_btn_contract" style="display:none">
		    <INPUT TYPE=text id=Mcontract_no name=Mcontract_no SIZE=10 MAXLENGTH=10 class="Lock">
		    <input type=button class="sgreenbutton Lock" name="btn_contract" value="查詢總契約書">
		    +客戶案件委辦書
	    </span>
	    <br>
	</TD>
</TR>
<TR>
	<TD class=lightbluetable align=right>法定期限：</TD>
	<TD class=whitetablebg align=left colspan=3>
        <INPUT type=text id=dfy_last_date name=dfy_last_date SIZE=10 class="dateField Lock">
	</TD>
</TR>
<TR>
	<TD class=lightbluetable align=right>其他接洽：<BR>事項記錄：</TD>
	<TD class=whitetablebg colspan=3><TEXTAREA id=tfy_Remark name=tfy_Remark ROWS=6 COLS=70 class="Lock"></TEXTAREA>
	</TD>
</TR>
</TABLE>
<input type=hidden id="TaCount" name="TaCount">
	
<script language="javascript" type="text/javascript">
    var case_form = {};
    case_form.init = function () {
        $("#F_tscode").getOption({//洽案營洽
            url: "../ajax/AjaxGetSqlDataBranch.aspx",
            data: { branch: "<%#branch%>", sql: "select distinct scode,sc_name,scode1 from sysctrl.dbo.vscode_roles where branch='<%#branch%>' and dept='T' and syscode='<%#branch%>Tbrt' and roles='sales' order by scode1" },
            valueFormat: "{scode}",
            textFormat: "{sc_name}"
        });
        $("#tfy_Arcase").getOption({//案性
            url: getRootPath() + "/AJAX/DmtData.aspx",
            data: { type: "arcaselist", branch: "<%#branch%>", opt_sqlno: "<%#opt_sqlno%>" },
            valueFormat: "{rs_code}",
            textFormat: "{rs_code}---{rs_detail}"
        });
        $("select[id='nfyi_item_Arcase_##']").getOption({//其他費用
            url: getRootPath() + "/AJAX/DmtData.aspx",
            data: { type: "arcaseItemList", branch: "<%#branch%>", opt_sqlno: "<%#opt_sqlno%>" },
            valueFormat: "{rs_code}",
            textFormat: "{rs_code}---{rs_detail}"
        });
        $("#tfy_oth_arcase").getOption({//轉帳費用
            url: getRootPath() + "/AJAX/DmtData.aspx",
            data: { type: "arcaseOtherList", branch: "<%#branch%>", opt_sqlno: "<%#opt_sqlno%>" },
            valueFormat: "{rs_code}",
            textFormat: "{rs_code}---{rs_detail}"
        });
        $("#tfy_oth_code").getOption({//轉帳單位
            url: "../ajax/AjaxGetSqlDataCnn.aspx",
            data: { sql: "SELECT branch,branchname FROM sysctrl.dbo.branch_code WHERE class = 'branch'" },
            valueFormat: "{branch}",
            textFormat: "{branch}_{branchname}"
        });
        $("#tfy_Ar_mark").getOption({//請款註記
            url: "../ajax/AjaxGetSqlDataBranch.aspx",
            data: { branch: "<%#branch%>", sql: "select cust_code,code_name from cust_code where code_type='ar_mark' and (mark1 like '%<%#Session["SeBranch"]%><%#Session["Dept"]%>%' or mark1 is null)" },
            valueFormat: "{cust_code}",
            textFormat: "{code_name}"
        });
        $("#tfy_source").getOption({//案源代碼
            url: "../ajax/AjaxGetSqlDataBranch.aspx",
            data: { branch: "<%#branch%>", sql: "select cust_code,code_name from cust_code where code_type='Source' AND cust_code<> '__' AND End_date is null order by cust_code" },
            valueFormat: "{cust_code}",
            textFormat: "({cust_code}---{code_name})"
        });

        //案性/案源
        $.ajax({
            type: "get",
            url: getRootPath() + "/AJAX/DmtData.aspx?type=brcase&branch=<%#branch%>&opt_sqlno=<%#opt_sqlno%>",
            async: false,
            cache: false,
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                if (JSONdata.length == 0) {
                    toastr.warning("無案件資料可載入！");
                    return false;
                }
                var j = JSONdata[0];
                $("#F_tscode").val(j.in_scode);
                $("#tfy_Arcase").val(j.arcase);
                $("#tfy_oth_code").val(j.oth_code);
                $("#tfy_oth_arcase").val(j.oth_arcase);
                $("#tfy_Ar_mark").val(j.ar_mark);
                $("#tfy_discount_chk").attr("checked", j.discount_chk=="Y");
                $("#tfy_source").val(j.source);
                if (j.contract_type != "") {
                    $("input[name='Contract_no_Type'][value='" + j.contract_type + "']").attr("checked", true);
                    if (j.contract_type == "M") {
                        $("#span_btn_contract").show();
                        $("#Mcontract_no").val(j.contract_no);
                    }
                    if (j.contract_type == "N") {
                        $("#tfy_Contract_no").val(j.contract_no);
                    }
                }
                
                $("#dfy_last_date").val(dateReviver(j.Last_date, "yyyy/M/d"));
                $("#tfy_Remark").val(j.remark);
                $("#nfy_service").val(j.service);
                $("#nfy_fees").val(j.fees);
                $("#nfy_oth_money").val(j.oth_money);
                $("#OthSum").val(j.othsum);
                $("#nfy_Discount").val(j.discount);
                $("#Discount").val(j.discount+"%");

                //產生其他費用tr
                for (z=1;z<=j.tot_case;z++){
                    var copyStr = "<tr id='ta_" + z + "' style='display:none'>" + $("tr[id='ta_##']").html().replace(/##/g, z) + "</tr>";
                    $(copyStr).insertBefore("tr[id='ta_##']");
                }

            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>案件資料載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });

        //費用
        $.ajax({
            type: "get",
            url: getRootPath() + "/AJAX/DmtData.aspx?type=brcasefees&branch=<%#branch%>&opt_sqlno=<%#opt_sqlno%>",
            async: false,
            cache: false,
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                if (JSONdata.length == 0) {
                    toastr.warning("無費用資料可載入！");
                    return false;
                }
                $.each(JSONdata, function (i, item) {
                    if (item.item_sql == "0") {
                        $("#tfy_Arcase").val(item.item_arcase);
                        $("#nfyi_Service").val(item.item_service);
                        $("#nfyi_Fees").val(item.item_fees);
                        $("#Service").val(item.service==""?"0":item.service);
                        $("#fees").val(item.fees==""?"0":item.fees);
                        $("#TaCount").val(item.item_sql);
                    } else {
                        $("#nfyi_item_Arcase_"+item.item_sql).val(item.item_arcase);
                        $("#nfyi_item_count_" + item.item_sql).val(item.item_count);
                        $("#nfyi_Service_" + item.item_sql).val(item.item_service);
                        $("#nfzi_Service_" + item.item_sql).val(item.item_service);
                        $("#nfyi_fees_" + item.item_sql).val(item.item_fees);
                        $("#nfzi_fees_" + item.item_sql).val(item.item_fees);
                        $("#nfzi_service_" + item.item_sql).val(item.service == "" ? "0" : item.service);
                        $("#nfzi_fees_" + item.item_sql).val(item.fees == "" ? "0" : item.fees);
                        $("#TaCount").val(item.item_sql);
                        $("#ta_" + item.item_sql).show();
                    }
                });
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>費用資料載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });
    };
</script>
