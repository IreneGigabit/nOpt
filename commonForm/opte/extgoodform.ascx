<%@ Control Language="C#" ClassName="ext_form_good" %>
<%@ Register Src="~/commonForm/opte/brtPriorForm.ascx" TagPrefix="uc1" TagName="brtPriorForm" %>


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

<%=Sys.GetAscxPath(this, MapPathSecure(TemplateSourceDirectory))%>
<TABLE border=0 id="goodllist" class="bluetable" cellspacing=1 cellpadding=2 width="100%">
    <thead>
	    <tr>
			<td class="lightbluetable" align="right" style="color:blue" title="請輸入類別，並以逗號分開(例如：01,05,32)。">類別項目：</td>
			<td class="whitetablebg" colspan="7">
                共<input type="text" id=tfz1_class_count name=tfz1_class_count size=2 onchange="ext_form_good.Add_button(this.value)" class="QLock">類，
                <INPUT type="text" size=60 maxlength=100 id=tfz1_class name=tfz1_class readonly>
			</td>
	    </tr>
    </thead>
    <tfoot style="display:none;">
 		<tr>
			<td class="lightbluetable" align="right">類別##：</td>
			<td class="whitetablebg" colspan="7">第<input type=text id=class_## NAME=class_## size=5 maxlength=5 class="QLock" onchange="count_kind(this.value,1)">類</td>
		</tr>

		<tr>
			<td class="lightbluetable" align="right">中文商品/服務名稱##：</td>
			<td class="whitetablebg" colspan="7">
                <textarea id=good_name_## name=good_name_## ROWS="10" COLS="75" class="QLock" onchange="good_name_count('good_name_##','good_count_##')"></textarea>
                <input type="hidden" id=good_count_## name=good_count_## size=2 class="QLock">
			</td>
		</tr>
		<tr>
			<td class="lightbluetable" align="right" width="18%">英文商品/服務名稱##：</td>			
			<td class="whitetablebg" colspan="7">
                <textarea id="egood_name_##" name="egood_name_##" ROWS="10" COLS="75" class="QLock" onchange="good_name_count('egood_name_##','egood_count_##')"></textarea>
                <input type="hidden" id=egood_count_## name=egood_count_## size=2 class="QLock">
			</td>
		</tr>
		<tr>
			<td class="lightbluetable" align="right" width="18%">商品數##：</td>			
			<td class="whitetablebg" colspan="7">共<input type="text" id=goodcount_## name=goodcount_## size=2 class="QLock">項</td>
		</tr>
    </tfoot>
    <tbody></tbody>
</table>


<script language="javascript" type="text/javascript">
    var ext_form_good = {};
    ext_form_good.init = function () {
        //商品
        var good = br_opt.opte_good;
        var classCount = good.length;
        if (classCount == 0) classCount = 1;//至少有1筆
        $("#tfz1_class_count").val(good.length == 0 ? "" : classCount);//共N類
        ext_form_good.Add_button(classCount);//產生類別清單

        if (good.length!=0){
            $.each(good, function (i, item) {
                var nRow = i + 1;
                $("#class_" + nRow).val(item.class);
                $("#good_count_" + nRow).val(item.dmt_goodcount);
                $("#grp_code_" + nRow).val(item.dmt_grp_code);
                $("#good_name_" + nRow).val(item.dmt_goodname);
            });
        }
        //類別串接
        $("#tfzr_class").val($("#goodllist>tbody input[id^='class_']").map(function () { return $(this).val(); }).get().join(','));
    }
    
    ext_form_good.Add_button = function (classCount) {
        for (var nRow = 1; nRow <= classCount; nRow++) {
            //複製一筆
            $("#goodllist>tfoot").each(function (i) {
                var strLine1 = $(this).html().replace(/##/g, nRow);
                $("#goodllist>tbody").append(strLine1);
            });
        }
    }
</script>
