<%@ Control Language="C#" ClassName="brdmt_upload_form" %>

<script runat="server">
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string SQL = "";
    //<%=MapPathSecure(TemplateSourceDirectory)%>\<%=this.GetType().ToString().Replace("ASP.","")%>.ascx
    protected string branch = "";
    protected string case_no = "";

    protected string uploadfield = "brdmt";
    protected string doc_maxAttach_no = "";
    protected string doc_attach_cnt = "";
    protected string epath = "doc/case";
    protected string uploadsource = "CASE";
    
    private void Page_Load(System.Object sender, System.EventArgs e) {
        branch = Request["branch"] ?? "";
        case_no = Request["case_no"] ?? "";
        
        this.DataBind();
    }
</script>

<input type="hidden" name="<%=uploadfield%>_maxAttach_no" value=""><!--目前table裡最大值-->
<input type="hidden" name="<%=uploadfield%>_attach_cnt" value=""><!--目前table裡有效筆數-->
<input type="hidden" name="<%=uploadfield%>filenum" value="0">
<input type="hidden" name="<%=uploadfield%>_path" value="<%=epath%>">
<input type="hidden" name="uploadfield" value="<%=uploadfield%>">
<input type="hidden" name="maxattach_no" value="0">
<input type="hidden" name="attach_seq">
<input type="hidden" name="attach_seq1">
<input type="hidden" name="attach_step_grade" value="0">
<input type="hidden" name="attach_in_no">
<input type="hidden" name="attach_case_no">
<input type="hidden" name="uploadsource" value="<%=uploadsource%>"><!--為了入dmt_attach.source的欄位-->
<TABLE id='tabfile<%=uploadfield%>' border=0 class="bluetable" cellspacing=1 cellpadding=2 width="100%">
    <thead>
	    <TR>
		    <TD align=center colspan=5 class=lightbluetable1>
                <font color=white>區&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;所&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;上&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;傳&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;文&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;件</font>
		    </TD>
	    </TR>
    </thead>
    <tfoot>
		<TR>
			<TD class=lightbluetable align=center>
		        文件檔案<input type=text name='<%=uploadfield%>filenum##' class="Lock" size=2 value='##'>.
			</TD>
			<TD class=sfont9 colspan="2">
		        <input TYPE=text ID="ttg1_mod_ap_ncname1_##" NAME="ttg1_mod_ap_ncname1_##" SIZE=60 MAXLENGTH=60 alt='『註冊人名稱』' onblur='fDataLen(this.value,this.maxlength,this.alt)' class="Lock">
                <br />
                <input TYPE=text id="ttg1_mod_ap_ncname2_##" NAME="ttg1_mod_ap_ncname2_##" SIZE=60 MAXLENGTH=60 alt='『註冊人名稱』' onblur='fDataLen(this.value,this.maxlength,this.alt)' class="Lock">

                檔案名稱：<input type=text name='<%=uploadfield%>_name_##' class="Lock" size=50 maxlength=50>
                <input type=button name='btn<%=uploadfield%>S_##' class='cbutton' value='檢視' onclick="brdmt_PreviewAttach('##')">
                <input type='hidden' name='<%=uploadfield%>_size_##'>
                <input type='hidden' name='<%=uploadfield%>_##'>
                <input type='hidden' name='tstep_grade_##'>
                <input type='hidden' name='attach_sqlno_##'>
                <input type='hidden' name='attach_flag_##'>
                <input type='hidden' name='source_name_##'>
                <input type='hidden' name='attach_no_##' value='##'>
                <input type='hidden' name='old_<%=uploadfield%>_name_##'>
                <br>檔案說明：<input type='hidden' id='doc_type_##' name='doc_type_##'><input type=text name='<%=uploadfield%>_desc_##' class="Lock_s_QD" size=50 maxlength=50 >
                <input type=checkbox name='<%=uploadfield%>_branch_##' class="Lock" value='B'><font color='blue'>交辦專案室</font>

			</TD>
		</TR>
    </tfoot>
</table>

<script language="javascript" type="text/javascript">
    var brupload_form = {};
    brupload_form.init = function () {
        //欄位開關
        //if submitTask="D" or submitTask="Q" then
        //    QupClass = "class=sedit readonly"
        //    QupDisabled = "disabled"
        //else
	    //    QupClass = ""
        //    QupDisabled = ""
        //end if
    }

    //增加一筆註冊人
    $("#DR1_AP_Add_button").click(function () { tran_form.appendModAp(); });
    brupload_form.appendModAp = function () {
        var nRow = parseInt($("#DR1_apnum").val(), 10) + 1;
        //複製樣板
        var copyStr = "";
        $("#DR1_tabap>tfoot tr").each(function (i) {
            copyStr += "<tr name='tr_tran_" + nRow + "'>" + $(this).html().replace(/##/g, nRow) + "</tr>"
        });
        $("#DR1_tabap>tbody").append(copyStr);
        $("#DR1_apnum").val(nRow)
    }

    //減少一筆註冊人
    $("#DR1_AP_Del_button").click(function () { tran_form.deleteModAp(); });
    brupload_form.deleteModAp = function () {
        var nRow = parseInt($("#DR1_apnum").val(), 10);
        $("tr[name='tr_tran_" + nRow + "']").remove();
        $("#DR1_apnum").val(Math.max(0, nRow - 1));
    }

</script>
