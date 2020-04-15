<%@ Control Language="C#" ClassName="ext_form" %>

<script runat="server">
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string SQL = "";
    protected string branch = "";
    protected string opt_sqlno = "";

    protected string tfzy_country = "", tfzy_end_code = "";
    protected string s_mark_html = "", s_type_html = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";

        tfzy_country = Funcs.getcountry().Option("{coun_code}", "{coun_code}_{coun_c}");
        s_mark_html = Funcs.getcust_code_mul("tfzd_s_mark", "", "sortfld").Radio("Tes_mark", "{cust_code}", "code_name");
        s_type_html = Funcs.getcust_code_mul("tfzd_s_type", "", "sortfld").Radio("Tes_type", "{cust_code}", "code_name");
        using (DBHelper connB = new DBHelper(Conn.OptB(branch)).Debug(false))
        {
            tfzy_end_code = SHtml.Option(connB, "SELECT chrelno, chrelname FROM relation where ChRelType = 'ENDCODE' ORDER BY sortfld", "{chrelno}", "{chrelname}");
        }

        this.DataBind();
    }
</script>

<%=Sys.GetAscxPath(this,MapPathSecure(TemplateSourceDirectory))%>
<table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="100%">
	<tr id=tr_opt_show>
		<td class=lightbluetable align=right >爭救案案件編號：</td>
		<td class=whitetablebg align=left colspan=7>
            <input type="text" id="opt_no" name="opt_no" class="Lock">
	        <input type="button" value="重新抓取區所案件主檔資料" class="c1button ALock"  id="GetBranch_ext_button" name="GetBranch_ext_button">
	    </td>
	</tr>
	<tr >
		<td class=lightbluetable align=right>區所案件編號：</td>
		<td class=whitetablebg  id=DelayCase>
				<input type=hidden name=tfzb_seq id=tfzb_seq>
				<input type=hidden name=tfzb_seq1 id=tfzb_seq1>
				<input type=hidden name=zold_seq id=zold_seq>
				<input type=hidden name=zold_seq1 id=zold_seq1>
				<input type=hidden name=zoldseq_end_date id=zoldseq_end_date>
				<input type=hidden name=zoldseq_ext_seq id=zoldseq_ext_seq>
				<input type=hidden name=zoldseq_ext_seq1 id=zoldseq_ext_seq1>
				<input type=hidden name=kind id=kind><!--傳入之作業種類-->
				<INPUT TYPE=text id=Branch NAME=Branch SIZE=1 MAXLENGTH=1  class="Lock">-
				<INPUT TYPE=text NAME=old_seq SIZE=5 MAXLENGTH=5 onblur="mainseqChange('old_seq')" class="QLock">-<INPUT TYPE=text NAME=old_seq1 SIZE=1 MAXLENGTH=1 value="_" onblur="mainseqChange('old_seq')" class="QLock">	
				<input type=hidden name=seqtypenum>
				<input type="hidden" name=keyseq value="N">
		</td>
		<td class=lightbluetable align=right>對方號：</td>
		<td class=whitetablebg ><INPUT TYPE=text id=tfzd_your_no NAME=tfzd_your_no SIZE=20 MAXLENGTH=20 class="QLock">	
			
		<td class=lightbluetable align=right>母案本所編號：</td>
		<td class=whitetablebg colspan=3><INPUT TYPE=text id=tfzd_mseq NAME=tfzd_mseq SIZE=5 MAXLENGTH=5 onblur="vbscript:mseqchange()" class="QLock">-<INPUT TYPE=text id=tfzd_mseq1 NAME=tfzd_mseq1 SIZE=3 MAXLENGTH=3 value="_" onblur="vbscript:mseqchange()" class="QLock">	
			
		<input type=hidden name=keymseq value="N">
		<!-- 程序客收移轉舊案要結案 2010/6/17 -->
			<input type=hidden name="endflag51" id="endflag51" value="X">
			<input type=hidden name="end_date51" id="end_date51">
			<input type=hidden name="end_code51" id="end_code51">
			<input type=hidden name="end_type51" id="end_type51">
			<input type=hidden name="end_remark51" id="end_remark51">
			<INPUT TYPE=button Name="but_end" id="but_end" class="redbutton" style="display:none" value="母案結案">
				
	</tr>
	<tr>
		<td class=lightbluetable align=right>國外所案號：</td>
		<td class=whitetablebg ><INPUT TYPE=text id=tfzd_ext_seq NAME=tfzd_ext_seq SIZE=5 MAXLENGTH=5 class="Lock">-<INPUT TYPE=text id=tfzd_ext_seq1 NAME=tfzd_ext_seq1 SIZE=3 MAXLENGTH=3  class="Lock" value="_">	
		<td class=lightbluetable align=right>原雜卷編號：</td>
		<td class=whitetablebg ><INPUT TYPE=text id=tfzd_zold_seq NAME=tfzd_zold_seq SIZE=5 MAXLENGTH=5 onblur="vbscript:zoldseqchange()" class="QLock">-<INPUT TYPE=text id=tfzd_zold_seq1 NAME=tfzd_zold_seq1 SIZE=3 MAXLENGTH=3  value="Z" onblur="vbscript:zoldseqchange()" class="QLock">	
		<td class=lightbluetable align=right>相關案號：</td>
		<td class=whitetablebg colspan=3><INPUT TYPE=text id=tfzd_ref_seq NAME=tfzd_ref_seq SIZE=20 MAXLENGTH=20 class="Lock">-<INPUT TYPE=text id=tfzd_ref_seq1 NAME=tfzd_ref_seq1 SIZE=1 MAXLENGTH=3 class="Lock" value="_">	
	</tr>
	<tr>
		<td class=lightbluetable align=right rowspan=2>代理人編號：</td>
		<td class=whitetablebg colspan=7>
		<font color=blue>案件代理人</font><input type="text" NAME="tfz1_agt_no" SIZE="4" maxlength="4" class="QLock"><input type="text" NAME="tfz1_agt_no1" SIZE="1" maxlength="1" class="QLock"><span id="span_agent_name"></span>
		<font color=blue>延展代理人</font><input type="text" NAME="tfz1_renewal_agt_no" SIZE="4" maxlength="4" class="QLock"><input type="text" NAME="tfz1_renewal_agt_no1" SIZE="1" maxlength="1" class="QLock"><span id="span_renewal_agent_name"></span>
		</td>
	</tr>	
	<tr>
		<td class=whitetablebg colspan=7>
		<INPUT TYPE=checkbox NAME=tfy_assign_agt value="Y" class="QLock">國外所指定代理人
		<input type="text" name="re_date"  size=50 class="Lock">
		</td>
	</tr>		
	<tr>
		<td class=lightbluetable align=right>指定代理人說明：</td>
		<td class=whitetablebg colspan=7><textarea NAME="tfzd_remark2" ROWS="2" COLS="75" class="QLock"></textarea></td>
	</tr>	
	<tr>
		<td class=lightbluetable align=right>商標種類：</td>
		<td class=whitetablebg colspan=7><%=s_mark_html%></TD>
	</tr>	
	<tr>
		<td class=lightbluetable align=right>商標類型：</td>
		<td class=whitetablebg colspan=7><%=s_type_html%></TD>
	</tr>
	<tr>
		<td class=lightbluetable align=right>申請號數：</td>
		<td class=whitetablebg colspan=3><INPUT TYPE=text NAME=tfzd_apply_no id=tfzd_Apply_no SIZE=30 MAXLENGTH=30 class="QLock"></TD>
		<td class=lightbluetable align=right>註冊號數：</td>
		<td class=whitetablebg colspan=3><input TYPE=text NAME=tfzd_issue_no id=tfzd_issue_no SIZE=30 MAXLENGTH=30 class="QLock"></td>
	</tr>
	<tr>
		<td class=lightbluetable align=right>商標名稱：</td>
		<td class=whitetablebg colspan=7><input TYPE="text" id="tfzd_Appl_name"  NAME="tfzd_Appl_name" alt="『商標名稱』" SIZE="50" MAXLENGTH="100" onblur="fDataLen this.value,this.MAXLENGTH,this.alt" class="QLock">
			
	<tr id=fileupload>
		<td class=lightbluetable align=right>商標圖樣：</td>
		<td class=whitetablebg colspan=7>
			<input TYPE="hidden" id="file1" name="file1">
			<input TYPE="text" id="tfzd_Draw_file" name="Draw_file1" SIZE="50" maxlength="50" class="Lock">	    
			<input type="button" class="cbutton QLock" id="butUpload"   name="butUpload"  value="商標圖檔上傳" onclick="vbscript:UploadAttach_photo()">
			<input type="button" class="redbutton QLock" id="btnDelAtt" name="btnDelAtt"  value="商標圖檔刪除" onclick="vbscript:DelAttach_photo()">
			<input type="button" class="cbutton" id="btnDisplay"  name="btnDisplay" value="商標圖檔檢視" onclick="vbscript:PreviewAttach_photo()" >
		    <input type="hidden" name="draw_attach_file" id="draw_attach_file"> 
		</TD>
	</tr>	
	<tr>
		<td class=lightbluetable align=right>不單獨主張專用：</td>
		<td class=whitetablebg colspan=7><INPUT TYPE=text NAME=tfzd_Oappl_name id=tfzd_Oappl_name  SIZE="50" alt="『不主張專用』" MAXLENGTH="100" onblur="fDataLen this.value,this.MAXLENGTH,this.alt" class="QLock"></TD>			
	</tr>		
	<tr>
		<td class=lightbluetable align=right>圖樣中文：</td>
		<td class=whitetablebg colspan=7><INPUT TYPE=text NAME=tfzd_cappl_name id=tfzd_cappl_name  SIZE="50" alt="『圖樣中文』" MAXLENGTH="100" onblur="fDataLen this.value,this.MAXLENGTH,this.alt" class="QLock"></TD>			
	</tr>	
	<tr>
		<td class=lightbluetable align=right>圖樣英文：</td>
		<td class=whitetablebg colspan=7><INPUT TYPE=text NAME=tfzd_eappl_name id=tfzd_eappl_name  SIZE="50" alt="『圖樣中文』" MAXLENGTH="100" onblur="fDataLen this.value,this.MAXLENGTH,this.alt" class="QLock"></TD>			
	</tr>	
	<tr>
		<td class="lightbluetable" align="right">字體描述：</td>
		<td class="whitetablebg" colspan="7">
            <input TYPE="radio" id="tfzd_word_typeP" NAME="tfzd_word_type" value="P" class="QLock">印刷體(Printed mark)
			<input TYPE="radio" id="tfzd_word_typeS" NAME="tfzd_word_type" value="S" class="QLock">設計商標(Stylized mark)
		</td>
	</tr>
	<tr>
		<td class="lightbluetable" align="right">色彩描述：</td>
		<td class="whitetablebg" colspan="7">
            <input TYPE="radio" id="tfzd_colorB" NAME="tfzd_color" value="B" class="QLock">墨色
			<input TYPE="radio" id="tfzd_colorC" NAME="tfzd_color" value="C" class="QLock">彩色：請聲明組成顏色：
            <input type="text" id="tfzd_color_content" name="tfzd_color_content" size=50 alt="『色彩描述』" maxlength=100 onblur="fDataLen this.value,this.maxlength,this.alt">
		</td>
	</tr>
	<tr>
		<td class="lightbluetable" align="right">文字描述：</td>
		<td class="whitetablebg" colspan="7">
		<input TYPE="radio" id="tfzd_text_classI" NAME="tfzd_text_class" value="I" class="QLock">屬自創字，不具特殊意義(invented word with no particular meaning)<br>
		<input TYPE="radio" id="tfzd_text_classE" NAME="tfzd_text_class" value="E" class="QLock">中文字之英文音譯及意譯：
            <input type="text" id="tfzd_text_content" name="tfzd_text_content" size=50 alt="『文字描述』" maxlength=200 onblur="fDataLen this.value,this.maxlength,this.alt" class="QLock"><br>
		<input TYPE="radio" id="tfzd_text_classZ" NAME="tfzd_text_class" value="Z" class="QLock">其他外文
		</td>
	</tr>
	<tr>
		<td class="lightbluetable" align="right" >圖形描述：</td>
					<td class="whitetablebg" colspan="7"><input TYPE="text" id="tfzd_Draw" NAME="tfzd_Draw" SIZE="50" alt="『圖形描述』" maxlength=50 onblur="fDataLen this.value,this.size,this.alt" class="QLock"></td>
	</tr>
	<tr>
		<td class="lightbluetable" align="right">申請日期：</td>
		<td class="whitetablebg" colspan="3"><input TYPE="text" NAME="tfzd_apply_date"  id="tfzd_apply_date" SIZE="10" onblur="chkdate_onblur(this.id)" class="QLock"></TD>
		<td class="lightbluetable" align="right">註冊日期：</td>
		<td class="whitetablebg" colspan="3"><input TYPE="text" NAME="tfzd_issue_date" id="tfzd_issue_date" SIZE="10" onblur="chkdate_onblur(this.id)" class="QLock"></TD>
	</tr>
	<tr>
		<td class="lightbluetable" align="right">延展日期：</td>
		<td class="whitetablebg" colspan="3"><input TYPE="text" NAME="tfzd_renewal_date"  id="tfzd_renewal_date" SIZE="10" onblur="chkdate_onblur(this.id)" class="QLock"></TD>
		<td class="lightbluetable" align="right">延展號碼：</td>
		<td class="whitetablebg" colspan="3"><input TYPE="text" NAME="tfzd_renewal_no" id="tfzd_renewal_no" SIZE="20" class="QLock"></TD>
	</tr>
	<tr>
		<td class="lightbluetable" align="right">結案日期：</td>
		<td class="whitetablebg" colspan="3">
            <input TYPE="text" NAME="tfzd_end_date" id="tfzd_end_date" SIZE="10" onblur="chkdate_onblur(this.id)" class="QLock">
		</TD>
		<td class="lightbluetable" align="right">結案代碼：</td>
		<td class="whitetablebg" colspan="3">
		<select NAME="tfzd_end_code" id="tfzd_end_code" class="QLock"><%#tfzy_end_code%></select>
		</TD>
	</tr>
	<tr>
		<td class=lightbluetable align=right>專用期限：</td>
		<td class=whitetablebg colspan=3>
            <INPUT TYPE=text NAME=tfzd_ext_term1 id=tfzd_ext_term1 SIZE=10 onblur="chkdate_onblur(this.id)" class="QLock">~
			<INPUT TYPE=text NAME=tfzd_ext_term2 id=tfzd_ext_term2 SIZE=10 onblur="chkdate_onblur(this.id)" class="QLock">
		</TD>
		<td class="lightbluetable" align="right">延展次數：</td>
		<td class="whitetablebg" colspan="3"><input TYPE="text" NAME="tfzd_renewal" id="tfzd_renewal" SIZE="2" class="QLock"></TD>
	</tr>
	<tr>
		<td class="lightbluetable" align="right">申請基礎：</td>		
		<td class="whitetablebg" colspan="7">
			<INPUT type="radio" id="tfzd_apply_base1" name=tfzd_apply_base value="1" class="QLock">1.已使用
			<INPUT type="radio" id="tfzd_apply_base2" name=tfzd_apply_base value="2" class="QLock">2.欲使用
			<INPUT type="radio" id="tfzd_apply_base3" name=tfzd_apply_base value="4" class="QLock">3.本國申請
			<INPUT type="radio" id="tfzd_apply_base4" name=tfzd_apply_base value="3" class="QLock">4.本國註冊
		</td>		
	</tr>
	<tr>
		<td class="lightbluetable" align="right" rowspan="2">使用日(使用主義)：</td>
		<td class="lightbluetable" align="right">申請國最早使用日：
		<td class="whitetablebg" colspan="6"><input TYPE="text" id="tfzd_Af_date" NAME="tfzd_Af_date" SIZE="10" onblur="chkdate_onblur(this.id)" class="QLock"></TD>
	</tr>
	<tr>
		<td class="lightbluetable" align="right">世界最早使用日：
		<td class="whitetablebg" colspan="2"><input TYPE="text" id="tfzd_Wf_date" NAME="tfzd_Wf_date" SIZE="10" onblur="chkdate_onblur(this.id)" class="QLock">
		<td class="lightbluetable" align="right">世界最早使用國：
		<td class="whitetablebg" colspan="3">
            <select id="tfzd_wf_country" NAME="tfzd_wf_country" class="QLock"><%#tfzy_country%></select>
		</TD>
	</tr>
	<tr>
		<td class="lightbluetable" align="right" rowspan="2">註冊資料：</td>
		<td class="lightbluetable" align="right">註冊國：
		<td class="whitetablebg" colspan="6">
            <select id="tfzd_bissue_coun" NAME="tfzd_bissue_coun" class="QLock"><%#tfzy_country%></select>
		</TD>
	</tr>
	<tr>
		<td class="lightbluetable" align="right">註冊日：
		<td class="whitetablebg" colspan="2">
			<input TYPE="text" id="tfzd_bissue_date" NAME="tfzd_bissue_date" SIZE="10" onblur="chkdate_onblur(this.id)" class="QLock">
		</TD>
		<td class="lightbluetable" align="right">註冊號：
		<td class="whitetablebg" colspan="3"><input TYPE="text" id="tfzd_bissue_no" NAME="tfzd_bissue_no" SIZE="30" class="QLock"></TD>
	</tr>
</table>


<script language="javascript" type="text/javascript">
    var ext_form = {};
    ext_form.init = function () {
        var jOpt = br_opt.opt[0];
        $("#opt_no").val(jOpt.opt_no);
        $("#Branch").val(jOpt.branch);

        $("input[name='tfzy_S_Mark'][value='" + jOpt.s_mark + "']").prop("checked", true);
        $("#tfzd_S_Mark").val(jOpt.s_mark);
        $("#tfzy_Pul").val(jOpt.pul);
        $("#tfzy_Zname_type").val(jOpt.zname_type);
        $("#tfzd_Zname_type").val(jOpt.zname_type);
        $("input[name='tfzy_color'][value='" + jOpt.color + "']").prop("checked", true);
        $("#tfzy_prior_country").val(jOpt.prior_country);
        $("#tfzy_end_code").val(jOpt.end_code);

        $("#tfzd_apply_no").val(jOpt.apply_no);
        $("#tfzd_issue_no").val(jOpt.issue_no);
        $("#tfzd_Appl_name").val(jOpt.appl_name);
        if (jOpt.draw_file != "") $("#draw_icon").attr("href", jOpt.drfile).show();
        $("#file").val(jOpt.draw_file);
        $("#tfz1_Draw_file").val(jOpt.draw_file);
        $("#tfzd_Oappl_name").val(jOpt.oappl_name);
        $("#tfzd_Cappl_name").val(jOpt.cappl_name);
        $("#tfzd_Eappl_name").val(jOpt.eappl_name);
        $("#tfzd_eappl_name1").val(jOpt.eappl_name1);
        $("#tfzd_eappl_name2").val(jOpt.eappl_name2);
        $("#tfzd_Zname_type").val(jOpt.zname_type);
        $("#tfzd_Draw").val(jOpt.draw);
        $("#tfzd_Symbol").val(jOpt.symbol);
        $("#pfzd_prior_date").val(dateReviver(jOpt.prior_date, "yyyy/M/d"));
        $("#tfzd_prior_no").val(jOpt.prior_no);
        $("#tfzd_apply_date").val(dateReviver(jOpt.apply_date, "yyyy/M/d"));
        $("#tfzd_issue_date").val(dateReviver(jOpt.issue_date, "yyyy/M/d"));
        $("#tfzd_open_date").val(dateReviver(jOpt.open_date, "yyyy/M/d"));
        $("#tfzd_rej_no").val(jOpt.rej_no);
        $("#tfzd_end_date").val(dateReviver(jOpt.end_date, "yyyy/M/d"));
        $("#tfzd_dmt_term1").val(jOpt.dmt_term1);
        $("#tfzd_dmt_term2").val(jOpt.dmt_term2);
        $("#tfzd_renewal").val(jOpt.renewal);

        //商品
        var good = br_opt.casegood;
        var classCount = good.length;
        if (classCount == 0) classCount = 1;//至少有1筆
        $("#tfzr_class_count").val(good.length == 0 ? "" : classCount);//共N類
        ext_form.Add_button(classCount);//產生類別清單

        if (good.length!=0){
            $.each(good, function (i, item) {
                var nRow = i + 1;
                $("#class1_" + nRow).val(item.class);
                $("#good_count1_" + nRow).val(item.dmt_goodcount);
                $("#grp_code1_" + nRow).val(item.dmt_grp_code);
                $("#good_name1_" + nRow).val(item.dmt_goodname);
            });
        }
        //類別串接
        $("#tfzr_class").val($("#goodllist>tbody input[id^='class1_']").map(function () { return $(this).val(); }).get().join(','));

        $("#tr_opt_show").showFor("<%#prgid%>" == "opt31" || "<%#prgid%>" == "opt31_1");//承辦/結辦作業要顯示 爭救案件編號
    }
    
    ext_form.Add_button = function (classCount) {
        for (var nRow = 1; nRow <= classCount; nRow++) {
            //複製一筆
            $("#goodllist>tfoot").each(function (i) {
                var strLine1 = $(this).html().replace(/##/g, nRow);
                $("#goodllist>tbody").append(strLine1);
            });
        }
    }

    //重新抓取區所案件主檔資料
    $("#GetBranch_ext_button").click(function () { 
        if (confirm("是否確定重新取得區所案件主檔資料？")) {
            var url = "../AJAX/get_branchdata.aspx?prgid=<%=prgid%>&datasource=ext&branch=" + $("#Branch").val() + "&case_no=" + $("#case_no").val() + "&opt_sqlno=" + $("#opt_sqlno").val();
            window.open(url, "", "width=800 height=600 top=100 left=100 toolbar=no, menubar=no, location=no, directories=no resizeable=no status=no scrollbars=yes");
        }
    });
</script>
