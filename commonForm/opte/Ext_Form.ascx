<%@ Control Language="C#" ClassName="ext_form" %>
<%@ Register Src="~/commonForm/opte/brtPriorForm.ascx" TagPrefix="uc1" TagName="brtPriorForm" %>
<%@ Register Src="~/commonForm/opte/extgoodform.ascx" TagPrefix="uc1" TagName="extgoodform" %>



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
        s_mark_html = Funcs.getcust_code_mul("Tes_mark", "", "sortfld").Radio("tfzd_s_mark", "{cust_code}", "{code_name}");
        s_type_html = Funcs.getcust_code_mul("Tes_type", "", "sortfld").Radio("tfzd_s_type", "{cust_code}", "{code_name}");
        using (DBHelper connB = new DBHelper(Conn.OptB(branch)).Debug(false)) {
            tfzy_end_code = SHtml.Option(connB, "SELECT chrelno, chrelname FROM relation where ChRelType = 'ENDCODE' ORDER BY sortfld", "{chrelno}", "{chrelname}");
        }

        this.DataBind();
    }
</script>

<%=Sys.GetAscxPath(this, MapPathSecure(TemplateSourceDirectory))%>
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
				<input type=text name=tfzb_seq id=tfzb_seq>
				<input type=text name=tfzb_seq1 id=tfzb_seq1>
				<input type=text name=zold_seq id=zold_seq>
				<input type=text name=zold_seq1 id=zold_seq1>
				<input type=text name=zoldseq_end_date id=zoldseq_end_date>
				<input type=text name=zoldseq_ext_seq id=zoldseq_ext_seq>
				<input type=text name=zoldseq_ext_seq1 id=zoldseq_ext_seq1>
				<input type=text name=kind id=kind><!--傳入之作業種類-->
				<INPUT TYPE=text id=Branch name=Branch SIZE=1 MAXLENGTH=1  class="Lock">-
				<INPUT TYPE=text id=old_seq name=old_seq SIZE=5 MAXLENGTH=5 onblur="mainseqChange('old_seq')" class="QLock">
                -<INPUT TYPE=text id=old_seq1 name=old_seq1 SIZE=1 MAXLENGTH=1 value="_" onblur="mainseqChange('old_seq')" class="QLock">	
				<input type=hidden name=seqtypenum>
				<input type="hidden" name=keyseq value="N">
		</td>
		<td class=lightbluetable align=right>對方號：</td>
		<td class=whitetablebg ><INPUT TYPE=text id=tfzd_your_no NAME=tfzd_your_no SIZE=20 MAXLENGTH=20 class="QLock">	
			
		<td class=lightbluetable align=right>母案本所編號：</td>
		<td class=whitetablebg colspan=3><INPUT TYPE=text id=tfzd_mseq NAME=tfzd_mseq SIZE=5 MAXLENGTH=5 onblur="mseqchange()" class="QLock">-<INPUT TYPE=text id=tfzd_mseq1 NAME=tfzd_mseq1 SIZE=3 MAXLENGTH=3 value="_" onblur="mseqchange()" class="QLock">	
			
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
		<td class=whitetablebg ><INPUT TYPE=text id=tfzd_zold_seq NAME=tfzd_zold_seq SIZE=5 MAXLENGTH=5 onblur="zoldseqchange()" class="QLock">-<INPUT TYPE=text id=tfzd_zold_seq1 NAME=tfzd_zold_seq1 SIZE=3 MAXLENGTH=3  value="Z" onblur="zoldseqchange()" class="QLock">	
		<td class=lightbluetable align=right>相關案號：</td>
		<td class=whitetablebg colspan=3><INPUT TYPE=text id=tfzd_ref_seq NAME=tfzd_ref_seq SIZE=20 MAXLENGTH=20 class="Lock">-<INPUT TYPE=text id=tfzd_ref_seq1 NAME=tfzd_ref_seq1 SIZE=1 MAXLENGTH=3 class="Lock" value="_">	
	</tr>
	<tr>
		<td class=lightbluetable align=right rowspan=2>代理人編號：</td>
		<td class=whitetablebg colspan=7>
		<font color=blue>案件代理人</font><input type="text" id="tfz1_agt_no" NAME="tfz1_agt_no" SIZE="4" maxlength="4" class="QLock"><input type="text" id="tfz1_agt_no1" NAME="tfz1_agt_no1" SIZE="1" maxlength="1" class="QLock"><span id="span_agent_name"></span>
		<font color=blue>延展代理人</font><input type="text" id="tfz1_renewal_agt_no" NAME="tfz1_renewal_agt_no" SIZE="4" maxlength="4" class="QLock"><input type="text" id="tfz1_renewal_agt_no1" NAME="tfz1_renewal_agt_no1" SIZE="1" maxlength="1" class="QLock"><span id="span_renewal_agent_name"></span>
		</td>
	</tr>	
	<tr>
		<td class=whitetablebg colspan=7>
		<INPUT TYPE=checkbox id=tfy_assign_agt name=tfy_assign_agt value="Y" class="QLock">國外所指定代理人
		<input type="text" id="re_date" name="re_date"  size=50 class="Lock">
		</td>
	</tr>		
	<tr>
		<td class=lightbluetable align=right>指定代理人說明：</td>
		<td class=whitetablebg colspan=7><textarea id="tfzd_remark2" NAME="tfzd_remark2" ROWS="2" COLS="75" class="QLock"></textarea></td>
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
		<td class=whitetablebg colspan=3><INPUT TYPE=text NAME=tfzd_apply_no id=tfzd_apply_no SIZE=30 MAXLENGTH=30 class="QLock"></TD>
		<td class=lightbluetable align=right>註冊號數：</td>
		<td class=whitetablebg colspan=3><input TYPE=text NAME=tfzd_issue_no id=tfzd_issue_no SIZE=30 MAXLENGTH=30 class="QLock"></td>
	</tr>
	<tr>
		<td class=lightbluetable align=right>商標名稱：</td>
		<td class=whitetablebg colspan=7><input TYPE="text" id="tfzd_Appl_name"  NAME="tfzd_Appl_name" alt="『商標名稱』" SIZE="50" MAXLENGTH="100" onblur="fDataLen(this.value,this.maxLength,this.alt)" class="QLock">
			
	<tr id=fileupload>
		<td class=lightbluetable align=right>商標圖樣：</td>
		<td class=whitetablebg colspan=7>
			<input TYPE="hidden" id="file1" name="file1">
			<input TYPE="text" id="tfzd_Draw_file" name="Draw_file1" SIZE="50" maxlength="50" class="Lock">	    
			<input type="button" class="cbutton QLock" id="butUpload"   name="butUpload"  value="商標圖檔上傳" onclick="UploadAttach_photo()">
			<input type="button" class="redbutton QLock" id="btnDelAtt" name="btnDelAtt"  value="商標圖檔刪除" onclick="DelAttach_photo()">
			<input type="button" class="cbutton" id="btnDisplay"  name="btnDisplay" value="商標圖檔檢視" onclick="PreviewAttach_photo()" >
		    <input type="hidden" name="draw_attach_file" id="draw_attach_file"> 
		</TD>
	</tr>	
	<tr>
		<td class=lightbluetable align=right>不單獨主張專用：</td>
		<td class=whitetablebg colspan=7><INPUT TYPE=text NAME=tfzd_Oappl_name id=tfzd_Oappl_name  SIZE="50" alt="『不主張專用』" MAXLENGTH="100" onblur="fDataLen(this.value,this.maxLength,this.alt)" class="QLock"></TD>			
	</tr>		
	<tr>
		<td class=lightbluetable align=right>圖樣中文：</td>
		<td class=whitetablebg colspan=7><INPUT TYPE=text NAME=tfzd_cappl_name id=tfzd_cappl_name  SIZE="50" alt="『圖樣中文』" MAXLENGTH="100" onblur="fDataLen(this.value,this.maxLength,this.alt)" class="QLock"></TD>			
	</tr>	
	<tr>
		<td class=lightbluetable align=right>圖樣英文：</td>
		<td class=whitetablebg colspan=7><INPUT TYPE=text NAME=tfzd_eappl_name id=tfzd_eappl_name  SIZE="50" alt="『圖樣中文』" MAXLENGTH="100" onblur="fDataLen(this.value,this.maxLength,this.alt)" class="QLock"></TD>			
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
            <input type="text" id="tfzd_color_content" name="tfzd_color_content" size=50 alt="『色彩描述』" maxlength=100 onblur="fDataLen(this.value,this.maxLength,this.alt)">
		</td>
	</tr>
	<tr>
		<td class="lightbluetable" align="right">文字描述：</td>
		<td class="whitetablebg" colspan="7">
		<input TYPE="radio" id="tfzd_text_classI" NAME="tfzd_text_class" value="I" class="QLock">屬自創字，不具特殊意義(invented word with no particular meaning)<br>
		<input TYPE="radio" id="tfzd_text_classE" NAME="tfzd_text_class" value="E" class="QLock">中文字之英文音譯及意譯：
        <input type="text" id="tfzd_text_content" name="tfzd_text_content" size=50 alt="『文字描述』" maxlength=200 onblur="fDataLen(this.value,this.maxLength,this.alt)" class="QLock"><br>
		<input TYPE="radio" id="tfzd_text_classZ" NAME="tfzd_text_class" value="Z" class="QLock">其他外文
		</td>
	</tr>
	<tr>
		<td class="lightbluetable" align="right" >圖形描述：</td>
		<td class="whitetablebg" colspan="7">
            <input TYPE="text" id="tfzd_Draw" NAME="tfzd_Draw" SIZE="50" alt="『圖形描述』" maxlength=50 onblur="fDataLen(this.value,this.size,this.alt)" class="QLock">
		</td>
	</tr>
	<tr>
		<td class="lightbluetable" align="right">申請日期：</td>
		<td class="whitetablebg" colspan="3"><input TYPE="text" NAME="tfzd_apply_date"  id="tfzd_apply_date" SIZE="10" onblur="ext_form.chkdate(this.id)" class="QLock"></TD>
		<td class="lightbluetable" align="right">註冊日期：</td>
		<td class="whitetablebg" colspan="3"><input TYPE="text" NAME="tfzd_issue_date" id="tfzd_issue_date" SIZE="10" onblur="ext_form.chkdate(this.id)" class="QLock"></TD>
	</tr>
	<tr>
		<td class="lightbluetable" align="right">延展日期：</td>
		<td class="whitetablebg" colspan="3"><input TYPE="text" NAME="tfzd_renewal_date"  id="tfzd_renewal_date" SIZE="10" onblur="ext_form.chkdate(this.id)" class="QLock"></TD>
		<td class="lightbluetable" align="right">延展號碼：</td>
		<td class="whitetablebg" colspan="3"><input TYPE="text" NAME="tfzd_renewal_no" id="tfzd_renewal_no" SIZE="20" class="QLock"></TD>
	</tr>
	<tr>
		<td class="lightbluetable" align="right">結案日期：</td>
		<td class="whitetablebg" colspan="3">
            <input TYPE="text" NAME="tfzd_end_date" id="tfzd_end_date" SIZE="10" onblur="ext_form.chkdate(this.id)" class="QLock">
		</TD>
		<td class="lightbluetable" align="right">結案代碼：</td>
		<td class="whitetablebg" colspan="3">
		<select NAME="tfzd_end_code" id="tfzd_end_code" class="QLock"><%#tfzy_end_code%></select>
		</TD>
	</tr>
	<tr>
		<td class=lightbluetable align=right>專用期限：</td>
		<td class=whitetablebg colspan=3>
            <INPUT TYPE=text NAME=tfzd_ext_term1 id=tfzd_ext_term1 SIZE=10 onblur="ext_form.chkdate(this.id)" class="QLock">~
			<INPUT TYPE=text NAME=tfzd_ext_term2 id=tfzd_ext_term2 SIZE=10 onblur="ext_form.chkdate(this.id)" class="QLock">
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
		<td class="whitetablebg" colspan="6"><input TYPE="text" id="tfzd_Af_date" NAME="tfzd_Af_date" SIZE="10" onblur="ext_form.chkdate(this.id)" class="QLock"></TD>
	</tr>
	<tr>
		<td class="lightbluetable" align="right">世界最早使用日：
		<td class="whitetablebg" colspan="2"><input TYPE="text" id="tfzd_Wf_date" NAME="tfzd_Wf_date" SIZE="10" onblur="ext_form.chkdate(this.id)" class="QLock">
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
			<input TYPE="text" id="tfzd_bissue_date" NAME="tfzd_bissue_date" SIZE="10" onblur="ext_form.chkdate(this.id)" class="QLock">
		</TD>
		<td class="lightbluetable" align="right">註冊號：
		<td class="whitetablebg" colspan="3"><input TYPE="text" id="tfzd_bissue_no" NAME="tfzd_bissue_no" SIZE="30" class="QLock"></TD>
	</tr>
		<tr class='sfont9'>
			<td colspan=8>
                <uc1:brtPriorForm runat="server" ID="brtPriorForm" />
                <!--include file="../commonForm/opte/brtPriorForm.ascx"--><!--優先權畫面-->
			</td>
		</tr>	
		<tr class='sfont9'>
			<td colspan=8>
                <uc1:extgoodform runat="server" ID="extgoodform" />
                <!--include file="../commonForm/opte/extgoodform.ascx"--><!--商品畫面-->
			</td>
		</tr>	
</table>


<script language="javascript" type="text/javascript">
    var ext_form = {};
    ext_form.init = function () {
        $("input[name='tfzd_s_mark']").addClass("QLock");
        $("input[name='tfzd_s_type']").addClass("QLock");

        var jOpt = br_opte.opte[0];
        $("#opt_no").val(jOpt.opt_no);
        $("#Branch").val(jOpt.branch);

        $("#tfzb_seq").val(jOpt.bseq);
        $("#old_seq").val(jOpt.bseq);
        $("#tfzb_seq1").val(jOpt.bseq1);
        $("#old_seq1").val(jOpt.bseq1);
        $("#tfzd_ext_seq").val(jOpt.ext_seq);
        $("#tfzd_ext_seq1").val(jOpt.ext_seq1);
        //******國外所指定代理人
        if (jOpt.assign_agt == "Y") {
            $("#tfy_assign_agt").prop("checked", true);
            //國外所已確認不能修改
            if ($("#re_date").val() != "") {
                $("#tfy_assign_agt").prop("disabled", true);
            }
        } else {
            $("#tfy_assign_agt").prop("checked", false);
        }
        $("#tfzd_remark2").val(jOpt.remark2);//*代理人說明
        $("#tfz1_agt_no").val(jOpt.agt_no);//*出名代理人代碼
        $("#tfz1_agt_no1").val(jOpt.agt_no1);//*出名代理人副碼
        $("#tfz1_renewal_agt_no").val(jOpt.renewal_agt_no);//*延展代理人代碼
        $("#tfz1_renewal_agt_no1").val(jOpt.renewal_agt_no1);//*延展代理人副碼
        $("#tfzd_Appl_name").val(jOpt.appl_name);//*商標名稱
        $("#tfzd_ref_seq").val(jOpt.ref_seq);
        $("#tfzd_ref_seq1").val(jOpt.ref_seq1);
        $("#tfzd_mseq").val(jOpt.mseq);
        $("#tfzd_mseq1").val(jOpt.mseq1);
        $("#tfzd_zold_seq").val(jOpt.zold_seq);
        $("#tfzd_zold_seq1").val(jOpt.zold_seq1);
        $("#tfzd_your_no").val(jOpt.your_no);
        $("#tfzd_apply_no").val(jOpt.apply_no);
        $("#tfzd_issue_no").val(jOpt.issue_no);

        $("#tfzd_Draw_file").val(jOpt.draw_file);//'*圖檔實際路徑
        $("#file1").val(jOpt.draw_file);//'*圖檔實際路徑-for編修時記錄原檔名
        $("#draw_attach_file").val(jOpt.drfile);//'*圖檔實際路徑-for檢視用
        $("#tfzd_Oappl_name").val(jOpt.oappl_name);//'*不單獨主張專用權
        $("#tfzd_cappl_name").val(jOpt.cappl_name);//'*商標圖樣中文
        $("#tfzd_eappl_name").val(jOpt.eappl_name);//'*商標圖樣英文
        $("input[name='tfzd_word_type'][value='" + jOpt.word_type + "']").prop("checked", true);//*字體描述
        $("input[name='tfzd_color'][value='" + jOpt.color + "']").prop("checked", true);//*顏色
        $("#tfzd_color_content").val(jOpt.color_content);//'*色彩描述內容
        $("input[name='tfzd_text_class'][value='" + jOpt.text_class + "']").prop("checked", true);//'*文字描述
        $("#tfzd_text_content").val(jOpt.text_content);//'*文字描述內容
        $("#tfzd_Draw").val(jOpt.draw);//'*圖型描述
        $("input[name='tfzd_s_mark'][value='" + jOpt.s_mark + "']").prop("checked", true);//'*商標種類
        $("input[name='tfzd_s_type'][value='" + jOpt.s_type + "']").prop("checked", true);//'*商標類型
        $("#tfzd_apply_date").val(dateReviver(jOpt.apply_date, "yyyy/M/d"));//'*申請日
        $("#tfzd_issue_date").val(dateReviver(jOpt.issue_date, "yyyy/M/d"));//'*註冊日
        $("#tfzd_renewal_date").val(dateReviver(jOpt.renewal_date, "yyyy/M/d"));//'*延展日
        $("#tfzd_renewal_no").val(jOpt.renewal_no);//'*延展號
        $("#tfzd_end_date").val(dateReviver(jOpt.end_date, "yyyy/M/d"));//'*結案日
        $("#tfzy_end_code").val(jOpt.end_code);//'*結案代碼

        $("#tfzd_ext_term1").val(dateReviver(jOpt.ext_term1, "yyyy/M/d"));//'*專用期限起日
        $("#tfzd_ext_term2").val(dateReviver(jOpt.ext_term2, "yyyy/M/d"));//'*專用期限迄日

        $("input[name='tfzd_apply_base'][value='" + jOpt.apply_base + "']").prop("checked", true);//'*申請基礎

        $("#tfzd_Af_date").val(dateReviver(jOpt.af_apply_nodate, "yyyy/M/d"));//'*申請最早使用日
        if ($("#tfzd_Af_date").val() == "1900/1/1") $("#tfzd_Af_date").val("");
        $("#tfzd_Wf_date").val(dateReviver(jOpt.wf_date, "yyyy/M/d"));//'*世界申請最早使用日
        if ($("#tfzd_Wf_date").val() == "1900/1/1") $("#tfzd_Wf_date").val("");

        $("#tfzd_wf_country").val(jOpt.wf_country);//'*註冊國
        $("#tfzd_bissue_coun").val(jOpt.bissue_coun);//'*註冊國
        $("#tfzd_bissue_no").val(jOpt.bissue_no);//'*註冊號
        $("#tfzd_bissue_date").val(dateReviver(jOpt.bissue_date, "yyyy/M/d"));//'*註冊日
        $("#tfz1_main_flag").val(jOpt.main_flag);//'*更新主檔註記

        //優先權
        ext_form_prior.init();

        //商品
        ext_form_good.init();
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

    ext_form.chkdate=function(pobj){
        ChkDate($("#" + pobj)[0]);
    }

    //重新抓取區所案件主檔資料
    $("#GetBranch_ext_button").click(function () { 
        if (confirm("是否確定重新取得區所案件主檔資料？")) {
            var url = "../AJAX/get_branchdata.aspx?prgid=<%=prgid%>&datasource=ext&branch=" + $("#Branch").val() + "&case_no=" + $("#case_no").val() +
                    "&opt_sqlno=" + $("#opt_sqlno").val() + "&chkTest=" + $("#chkTest:checked").val();
            //window.open(url, "", "width=800 height=600 top=100 left=100 toolbar=no, menubar=no, location=no, directories=no resizeable=no status=no scrollbars=yes");
            ActFrame.location.href = url;
        }
    });
</script>
