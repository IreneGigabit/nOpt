<%@ Control Language="C#" ClassName="dmt_form" %>

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

<table border="0" class="bluetable" cellspacing="1" cellpadding="2" style="font-size: 9pt" width="100%">
	<tr id=tr_opt_show style="display:none">			
		<td class=lightbluetable align=right >爭救案案件編號：</td>
		<td class=whitetablebg align=left colspan=7>
            <input type="text" id="opt_no" name="opt_no" class="Lock">
		</td>
	</tr>
	<tr>
		<td class=lightbluetable align=right>區所案件編號：</td>
		<td class=whitetablebg colspan=3 id=DelayCase>
			<INPUT TYPE=text id=Branch NAME=Branch SIZE=1 MAXLENGTH=1 class="Lock">-<INPUT TYPE=text id=Bseq NAME=Bseq SIZE=5 MAXLENGTH=5 class="Lock">-<INPUT TYPE=text id=Bseq1 NAME=Bseq1 SIZE=1 MAXLENGTH=1 class="Lock">
		</td>
		<td class=lightbluetable align=right>母案本所編號：</td>
		<td class=whitetablebg colspan=3 >
			<INPUT TYPE=text id="tfzd_ref_no" NAME="tfzd_ref_no" class="Lock" SIZE=5 MAXLENGTH=5>-<INPUT TYPE=text id="tfzd_ref_no1" NAME="tfzd_ref_no1" value="_" SIZE=1 MAXLENGTH=1 class="Lock">
		</td>
	</tr>
	<tr>
		<td class=lightbluetable align=right>商標種類：</td>
		<td class=whitetablebg colspan=7>
			<input type=radio name=tfzy_S_Mark value="" class="Lock" checked>商標
            <input type=radio name=tfzy_S_Mark value="S" class="Lock">92年修正前服務標章
            <input type=radio name=tfzy_S_Mark value="N" class="Lock">團體商標
            <input type=radio name=tfzy_S_Mark value="M" class="Lock">團體標章
            <input type=radio name=tfzy_S_Mark value="L" class="Lock">證明標章
			<input type="hidden" id="tfzd_S_Mark" name="tfzd_S_Mark">
		</TD>
	</tr>		
	<tr>
		<td class=lightbluetable align=right>正聯防：</td>
		<td class=whitetablebg colspan=7>
            <SELECT id=tfzy_Pul name=tfzy_Pul class="Lock">
				<option value="">正商標</option>
				<option value="1">聯合商標</option>
				<option value="2">防護商標</option>
            </SELECT>
			<input type="hidden" Name=tfzd_Pul>
		</TD>
	</tr>		
	<tr style="display:none" id="tfzd_Smark">
		<td class=lightbluetable align=right>正商標號數：</td>
		<td class=whitetablebg colspan=3><INPUT TYPE=text NAME=tfzd_Tcn_ref class="Lock" SIZE=7 alt="『正商標號數』"  MAXLENGTH="7" ></TD>
		<td class=lightbluetable align=right>正商標類別：</td>
		<td class=whitetablebg colspan=3><input TYPE=text NAME=tfzd_Tcn_Class class="Lock" SIZE=20 alt="『正商標類別』"  MAXLENGTH="20" ></td>
	</tr>
	<tr style="display:none" id="tfzd_Smark1">
		<td class=lightbluetable align=right>正商標名稱：</td>
		<td class=whitetablebg colspan=3><INPUT TYPE=text NAME=tfzd_Tcn_name class="Lock" alt="『正商標名稱』" SIZE="20" MAXLENGTH="100" ></TD>
		<td class=lightbluetable align=right>正商標種類：</td>
		<td class=whitetablebg colspan=3>
            <select NAME=tfzd_Tcn_mark id=tfzd_Tcn_mark class="Lock">
			    <option>請選擇</option>
			    <option value="T">商標</option>
			    <option value="S">標章</option>
            </select>
		</td>
	</tr>
	<tr>
		<td class=lightbluetable align=right>申請號數：</td>
		<td class=whitetablebg colspan=3><INPUT TYPE=text id=tfzd_apply_no NAME=tfzd_apply_no class="Lock" SIZE=20 alt="『申請號數』" MAXLENGTH="20"></TD>
		<td class=lightbluetable align=right>註冊號數：</td>
		<td class=whitetablebg colspan=3><input TYPE=text id=tfzd_issue_no NAME=tfzd_issue_no class="Lock" SIZE=20 alt="『註冊號數』" MAXLENGTH="20"></td>
	</tr>
	<tr>
		<td class=lightbluetable align=right>商標名稱：</td>
		<td class=whitetablebg colspan=7><INPUT TYPE=text id=tfzd_Appl_name NAME=tfzd_Appl_name class="Lock" alt="『商標名稱』" SIZE="60" MAXLENGTH="100"></TD>
	</tr>
	<tr style="display:" id=fileupload>
		<td class=lightbluetable align=right>商標圖樣：</td>	
		<td class=whitetablebg colspan=7>	
			 <a id="draw_icon" style="display:none" target="_blank"><img border="0" src="../images/annex.gif" WIDTH="18" HEIGHT="18"></a>
			<input TYPE="hidden" id="file" name="file">
			<input TYPE="text" name="Draw_file" id="tfz1_Draw_file" SIZE="50" maxlength="50" class="Lock">
		</TD>
	</tr>	
	<tr>
		<td class=lightbluetable align=right>聲明不專用：</td>
		<td class=whitetablebg colspan=7><INPUT TYPE=text id=tfzd_Oappl_name NAME=tfzd_Oappl_name class="Lock" alt="『不單獨主張專用』" SIZE="60" MAXLENGTH="100"></TD>
	</tr>			
	<tr>
		<td class=lightbluetable align=right>圖樣中文部份：</td>
		<td class=whitetablebg colspan=7><INPUT TYPE=text id=tfzd_Cappl_name NAME=tfzd_Cappl_name class="Lock" alt="『圖樣中文』" SIZE="60" MAXLENGTH="100"></TD>
	</tr>
	<tr>
		<td class=lightbluetable align=right>圖樣外文部份：</td>
		<td class=whitetablebg colspan=7>
		外文：<INPUT TYPE=text NAME=tfzd_Eappl_name id=tfzd_Eappl_name class="Lock" alt="『圖樣外文』" SIZE="60" MAXLENGTH="100" ><br>
		中文字義：<input type=text name=tfzd_eappl_name1 id=tfzd_eappl_name1 class="Lock" alt="『中文字義』" SIZE="60" MAXLENGTH="100"  ><br>
		讀音：<input type=text name=tfzd_eappl_name2 id=tfzd_eappl_name2 class="Lock" alt="『讀音』" SIZE="30" MAXLENGTH="100"  >　
		語文別：<select NAME="tfzy_Zname_type" id="tfzy_Zname_type" class="Lock"></select>
		<input type="hidden" name="tfzd_Zname_type" id="tfzd_Zname_type">
		</TD>
	</tr>
	<tr>
		<td class=lightbluetable align=right>圖形描述：</td>
		<td class=whitetablebg colspan=7><INPUT TYPE=text id=tfzd_Draw NAME=tfzd_Draw class="Lock" alt="『圖形描述』" SIZE="50" MAXLENGTH="50"  ></TD>
	</tr>
	<tr>
		<td class=lightbluetable align=right>記號說明：</td>
		<td class=whitetablebg colspan=7><INPUT TYPE=text id=tfzd_Symbol NAME=tfzd_Symbol class="Lock" alt="『記號說明』" SIZE="50" MAXLENGTH="50"  ></TD>
	</tr>
	<tr>
		<td class=lightbluetable align=right>圖樣顏色：</td>
		<td class=whitetablebg colspan=7>
            <INPUT TYPE=radio NAME=tfzy_color class="Lock" value="B">墨色
            <INPUT TYPE=radio NAME=tfzy_color class="Lock" value="C">彩色
            <INPUT TYPE=radio NAME=tfzy_color class="Lock" value="">無
		    <input type="hidden" name="tfzd_color">
		</td>
	</tr>

	<tr>
		<td class="lightbluetable" align="right">優先權申請日：</td>
		<td class="whitetablebg" colspan="3"><input TYPE="text" id="pfzd_prior_date" NAME="pfzd_prior_date" class="Lock" SIZE="10"></TD>
		<td class="lightbluetable" align="right">優先權首次申請國家：</td>
		<td class="whitetablebg" colspan="3">
            <select NAME="tfzy_prior_country" id="tfzy_prior_country" class="Lock"></select>
		    <input type="hidden" name="tfzd_prior_country">
		</td>
	</tr>
	<tr>
		<td class=lightbluetable align=right>優先權申請案號：</td>
		<td class=whitetablebg colspan=7><INPUT TYPE=text NAME=tfzd_prior_no ID=tfzd_prior_no size="10" maxlength="20" class="Lock"></td>
	</tr>
	<tr>
		<td class="lightbluetable" align="right">申請日期：</td>
		<td class="whitetablebg" colspan="3"><input TYPE="text" id="tfzd_apply_date" NAME="tfzd_apply_date" class="Lock" SIZE="10"></TD>
		<td class="lightbluetable" align="right">註冊日期：</td>
		<td class="whitetablebg" colspan="3"><input TYPE="text" id="tfzd_issue_date" NAME="tfzd_issue_date" class="Lock" SIZE="10"></TD>
	</tr>
	<tr>
		<td class="lightbluetable" align="right">公告日期：</td>
		<td class="whitetablebg" colspan="3"><input TYPE="text" id="tfzd_open_date" NAME="tfzd_open_date" class="Lock" SIZE="10"></TD>
		<td class="lightbluetable" align="right">核駁號：</td>
		<td class="whitetablebg" colspan="3"><input TYPE="text" id="tfzd_rej_no" NAME="tfzd_rej_no" class="Lock" SIZE="10" alt="『核駁號』"  MAXLENGTH="20" ></TD>
	</tr>
	<tr>
		<td class="lightbluetable" align="right">結案日期：</td>
		<td class="whitetablebg" colspan="3"><input TYPE="text" id="tfzd_end_date" NAME="tfzd_end_date" class="Lock" SIZE="10"></TD>
		<td class="lightbluetable" align="right">結案代碼：</td>
		<td class="whitetablebg" colspan="3">
            <select id="tfzy_end_code" NAME="tfzy_end_code" class="Lock"></select>
		    <input type="hidden" name="tfzd_End_Code">
		</TD>
	</tr>
	<tr>
		<td class="lightbluetable" align="right">專用期限：</td>
		<td class="whitetablebg" colspan="3"><input TYPE="text" id="tfzd_dmt_term1" NAME="tfzd_dmt_term1" class="Lock" SIZE="10">～<input TYPE="text" id="tfzd_dmt_term2" NAME="tfzd_dmt_term2" class="Lock" SIZE="10"></TD>
		<td class="lightbluetable" align="right">延展次數：</td>
		<td class="whitetablebg" colspan="3"><input TYPE="text" id="tfzd_renewal" NAME="tfzd_renewal" class="Lock" SIZE="2"></TD>
	</tr>
	<tr>
	<td class=whitetablebg colspan=8>
	    <TABLE id=tabbr1 border=0 class="bluetable" cellspacing=1 cellpadding=2 width="100%">
	        <tr>
		        <td class=lightbluetable align=right>類別：</td>		
		        <td class=whitetablebg colspan=7>共<input type="text" class="Lock" name=tfzr_class_count size=2 onchange="add_button(this.value)">類<input type="text" name=tfzr_class class="Lock" readonly>
		        <input type=hidden name=ctrlnum1 value="1">
			        <input type=hidden name=ctrlcount1 value="">
			        <input type=hidden name=num1 value="1">
		        </td>
	        </tr>
	        <tr>
		        <td class="lightbluetable" align="right" style="cursor:hand" title="請輸入類別，並以逗號分開(例如：1,5,32)。或輸入類別範圍，並以  -  (半形) 分開(例如：8-16)。也可複項組合(例如：3,5,13-32,35)">類別1：</td>		
		        <td class="whitetablebg" colspan="7"><!--2013/1/22玉雀告知不顯示商標法施行細則第13條-->第<INPUT type="text" class="Lock" name=class11 size=2 maxlength=2 onchange="count_kind(reg.class11.value,1)">類</td>		
	        </tr>
	        <tr style="height:107.6pt">
		        <td class="lightbluetable" align="right" width="18%">商品名稱1：</td>			
		        <td class="whitetablebg" colspan="7"><textarea NAME="good_name11" ROWS="10" COLS="75" class="Lock"></textarea><br>共<input type="text" name=good_count11 size=2 class="Lock">項</td>
	        </tr>		
	        <tr>
		        <td class="lightbluetable" align="right">商品群組代碼1：</td>
		        <td class="whitetablebg" colspan="7"><textarea NAME=grp_code11 ROWS="1" COLS="50" class="Lock"></textarea>(跨群組請以全形「、」作分隔)</td>
		        <input type="hidden" name="color1" value="">
	        </tr>
	    </table>
	</td>
	</tr>
</table>

<script language="javascript" type="text/javascript">
    var dmt = {};
    dmt.init = function () {
        $("#tfzy_Zname_type").getOption({//語文別
            url: "../ajax/AjaxGetSqlDataCnn.aspx",
            data: { sql: "SELECT coun_code, coun_c FROM country where markb<>'X' ORDER BY coun_code" },
            valueFormat: "{coun_code}",
            textFormat: "{coun_code}-{coun_c}"
        });
        $("#tfzy_prior_country").getOption({//優先權首次申請國家
            url: "../ajax/AjaxGetSqlDataCnn.aspx",
            data: { sql: "SELECT coun_code, coun_c FROM country where markb<>'X' ORDER BY coun_code" },
            valueFormat: "{coun_code}",
            textFormat: "{coun_code}-{coun_c}"
        });
        $("#tfzy_end_code").getOption({//結案代碼
            url: "../ajax/AjaxGetSqlDataBranch.aspx",
            data: { branch: "<%#branch%>", sql: "SELECT chrelno, chrelname FROM relation where ChRelType = 'ENDCODE' ORDER BY sortfld" },
            valueFormat: "{chrelno}",
            textFormat: "{chrelname}"
        });

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
                $("#opt_no").val(j.opt_no);
                $("#Branch").val(j.branch);
                $("#Bseq").val(j.bseq);
                $("#Bseq1").val(j.bseq1);
                $("#tfzd_ref_no").val(j.ref_no);
                $("#tfzd_ref_no1").val(j.ref_no1);
                $("input[name='tfzy_S_Mark'][value='" + j.s_mark + "']").attr("checked", true);
                $("#tfzd_S_Mark").val(j.s_mark);
                $("#tfzy_Pul").val(j.pul);
                $("#tfzy_Zname_type").val(j.zname_type);
                $("#tfzd_Zname_type").val(j.zname_type);
                $("input[name='tfzy_color'][value='" + j.color + "']").attr("checked", true);
                $("#tfzy_prior_country").val(j.prior_country);
                $("#tfzy_end_code").val(j.end_code);

                $("#tfzd_apply_no").val(j.apply_no);
                $("#tfzd_issue_no").val(j.issue_no);
                $("#tfzd_Appl_name").val(j.appl_name);
                $("#draw_icon").attr("href", j.drfile);
                if (j.draw_file != "") $("#draw_icon").show();
                $("#file").val(j.draw_file);
                $("#tfz1_Draw_file").val(j.draw_file);
                $("#tfzd_Oappl_name").val(j.oappl_name);
                $("#tfzd_Cappl_name").val(j.cappl_name);
                $("#tfzd_Eappl_name").val(j.eappl_name);
                $("#tfzd_eappl_name1").val(j.eappl_name1);
                $("#tfzd_eappl_name2").val(j.eappl_name2);
                $("#tfzd_Zname_type").val(j.zname_type);
                $("#tfzd_Draw").val(j.draw);
                $("#tfzd_Symbol").val(j.symbol);
                $("#pfzd_prior_date").val(dateReviver(j.prior_date,"yyyy/M/d"));
                $("#tfzd_prior_no").val(j.prior_no);
                $("#tfzd_apply_date").val(dateReviver(j.apply_date,"yyyy/M/d"));
                $("#tfzd_issue_date").val(dateReviver(j.issue_date,"yyyy/M/d"));
                $("#tfzd_open_date").val(dateReviver(j.open_date,"yyyy/M/d"));
                $("#tfzd_rej_no").val(j.rej_no);
                $("#tfzd_end_date").val(dateReviver(j.end_date,"yyyy/M/d"));
                $("#tfzd_dmt_term1").val(j.dmt_term1);
                $("#tfzd_dmt_term2").val(j.dmt_term2);
                $("#tfzd_renewal").val(j.renewal);
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>案件資料載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });
    };
</script>
