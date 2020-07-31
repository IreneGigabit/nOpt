<%@ Control Language="C#" ClassName="multi_upload_form" %>

<script runat="server">
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string SQL = "";

    protected string branch = "";
    protected string opt_sqlno = "";
    protected string arcase = "";

    protected string uploadfield = "opt_file";
    protected string opt_source_type = "OPT";

    protected string doc_maxAttach_no = "";
    protected string doc_attach_cnt = "";
    protected string html_attach_doc = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";
        arcase = Request["arcase"] ?? "";

        html_attach_doc = Funcs.getdoc_type(arcase).Option("{cust_code}", "{code_name}");

        this.DataBind();
    }
</script>

<%=Sys.GetAscxPath(this)%>
<TABLE id='tabfileopt_file' border=0 class="bluetable" cellspacing=1 cellpadding=2 width="100%">
    <thead>
	    <TR>
		    <TD align=center colspan=5 class=lightbluetable1>
                <font color=white>承&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;辦&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;附&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;件&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;資&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;料</font>
	            <input type="hidden" id="<%=uploadfield%>_sqlnum" name="<%=uploadfield%>_sqlnum" value="0"><!--畫面NO顯示編號-->
	            <input type="hidden" id="<%=uploadfield%>_maxAttach_no" name="<%=uploadfield%>_maxAttach_no" value="0"><!--目前table裡最大值-->
	            <input type="hidden" id="opt_uploadfield" name="opt_uploadfield" value="<%#uploadfield%>">
            </TD>
	    </TR>
	    <TR id="tr_upload_btn">
		    <TD class=whitetablebg align=center colspan=5>
               <input type="button" value="多檔上傳" class="greenbutton" id="multi_upload_button" name="multi_upload_button" onclick="multi_upload_form.mAppendFile()">
 			    <input type=button value="減少一筆附件" class="c1button" id="<%=uploadfield%>_Del_button" name="<%=uploadfield%>_Del_button" onclick="multi_upload_form.deleteFile()">
		    </TD>
	    </TR>
    </thead>
    <tbody></tbody>
</table>

<script type="text/html" id="attach-template">
	<TR id="tr_opt_attach_##">
		<TD class=lightbluetable align=center nowrap>
            附件<input type=text id='<%=uploadfield%>_sqlno_##' name='<%=uploadfield%>_sqlno_##' class="Lock" size=2 value='##'>.
		</TD>
		<TD class=sfont9 colspan="2" align="left">
	        附件名稱：<input type=text id='<%=uploadfield%>_name_##' name='<%=uploadfield%>_name_##' class="Lock" size=45 maxlength=50>
	        <input type=button id='btn<%=uploadfield%>_##' name='btn<%=uploadfield%>_##' class='cbutton' value='上傳' onclick="multi_upload_form.UploadOptAttach('##')">
	        <input type=button id='btn<%=uploadfield%>_D_##' name='btn<%=uploadfield%>_D_##' class='delbutton' value='刪除' onclick="multi_upload_form.DelOptAttach('##')">
	        <input type=button id='btn<%=uploadfield%>_S_##' name='btn<%=uploadfield%>_S_##' class='cbutton' value='檢視' onclick="multi_upload_form.PreviewOptAttach('##')">
            <label style="color:blue"><INPUT id='<%=uploadfield%>_doc_flag_##' type=checkbox value=E name='<%=uploadfield%>_doc_flag_##'>電子送件檔</label>
	        <input type='hidden' id='<%=uploadfield%>_dbflag_##' name='<%=uploadfield%>_dbflag_##' value="A">
	        <input type='hidden' id='<%=uploadfield%>_attach_sqlno_##' name='<%=uploadfield%>_attach_sqlno_##'>
	        <input type='hidden' id='<%=uploadfield%>_size_##' name='<%=uploadfield%>_size_##'>
	        <input type='hidden' id='<%=uploadfield%>_##' name='<%=uploadfield%>_##'>
	        <input type='hidden' id='<%=uploadfield%>_attach_no_##' name='<%=uploadfield%>_attach_no_##' value='##'>
	        <input type='hidden' id='<%=uploadfield%>_path_##' name='<%=uploadfield%>_path_##' value=''>
	        <input type='hidden' id='<%=uploadfield%>_add_scode_##' name='<%=uploadfield%>_add_scode_##' value=''>
	        <input type='hidden' id='<%=uploadfield%>_source_name_##' name='<%=uploadfield%>_source_name_##' value=''><br>
	        文件種類：<Select id='<%=uploadfield%>_doc_type_##' name='<%=uploadfield%>_doc_type_##' Onchange="multi_upload_form.getdesc('##')"><%=html_attach_doc%></Select>
	        附件說明：<input type=text id='<%=uploadfield%>_desc_##' name='<%=uploadfield%>_desc_##' size=50 maxlength=50 onblur="fChkDataLen(this,'附件說明')">
	        上傳日期：<input type=text id='<%=uploadfield%>_add_date_##' name='<%=uploadfield%>_add_date_##' class="Lock" size=10 maxlength=10 onblur="fChkDataLen(this,'上傳日期')">
	        <span id='span_<%=uploadfield%>_add_scodenm_##' style='display:none'>
                <br>上傳人員：<input type=text id='<%=uploadfield%>_add_scodenm_##' name='<%=uploadfield%>_add_scodenm_##' class="Lock" size=10 maxlength=10 onblur="fChkDataLen(this,'上傳人員')">
	        </span>
		</TD>
		<TD class="sfont9 delcol" align=center style="display:none">
            刪除:<input type=checkbox id='del_<%=uploadfield%>_##' name='del_<%=uploadfield%>_##'>
        </td>
	</TR>
</script>

<script language="javascript" type="text/javascript">
    var multi_upload_form = {};
    multi_upload_form.init = function () {
    }

    //增加一筆
    multi_upload_form.appendFile = function () {
        var fld = $("#opt_uploadfield").val();
        var tsqlnum = parseInt($("#" + fld + "_sqlnum").val(), 10) + 1;//畫面顯示NO
        var maxattachno = parseInt($("#" + fld + "_maxAttach_no").val(), 10) + 1;//最大attach_no

        var template = $('#attach-template').text().replace(/##/g, tsqlnum);
        $('#tabfile' + fld + ' tbody').append(template);

        $("#" + fld + "_sqlnum").val(tsqlnum);
        $("#" + fld + "_attach_no_" + tsqlnum).val(maxattachno);
        $("#" + fld + "_maxAttach_no").val(maxattachno);
    }

    //減少一筆
    multi_upload_form.deleteFile = function () {
        var fld = $("#opt_uploadfield").val();
        var tsqlnum = parseInt($("#" + fld + "_sqlnum").val(), 10);//畫面顯示NO
        var maxattachno = parseInt($("#" + fld + "_maxAttach_no").val(), 10);//最大attach_no

        //實體檔案不在才可以減少
        if ($("#" + fld + "_name_" + tsqlnum).val() == "") {
            $("#tr_opt_attach_" + tsqlnum).remove();
            $("#" + fld + "_sqlnum").val(Math.max(0, tsqlnum - 1));
            $("#" + fld + "_maxAttach_no").val(Math.max(0, maxattachno - 1));
        }
    }

    //多檔上傳
    multi_upload_form.mAppendFile = function () {
        var popt_no = $("#opt_no").val().Left(4);
        var topt_no = $("#opt_no").val().substr(4);
        var tfolder = "attach" + "/" + popt_no + "/" + topt_no;//存檔路徑
        var nfilename = "KT-" + $("#opt_no").val() + "-{{attach_no}}m";//新檔名格式

        var urlasp = getRootPath() + "/sub/multi_upload_file.aspx?type=doc&prgid=<%=prgid%>&remark=" + escape("多檔上傳");
        urlasp += "&temptable=attachtemp_opt&attach_tablename=attach_opt";
        urlasp += "&upfolder=" + tfolder + "&nfilename=" + nfilename;
        urlasp += "&syscode=<%=Session["Syscode"]%>&apcode=&branch=K&dept=T&opt_sqlno=" + $("#opt_no").val();//attachtemp_opt的key值
        var mm = window.open(urlasp, "mupload", "width=700 height=600 top=50 left=150 toolbar=no, menubar=no, location=no, directories=no resizeable=no status=yes scrollbars=yes");
        mm.focus();
    }

    //多檔上傳後回傳資料顯示於畫面上
    function uploadSuccess(rvalue) {
        var fld = $("#opt_uploadfield").val();
        multi_upload_form.appendFile();
        //傳回:檔案名稱，虛擬完整路徑，原始檔名，檔案大小，attach_no
        var listno = $("#" + fld + "_sqlnum").val();
        $("#" + fld + "_maxAttach_no").val(rvalue.attach_no);
        $("#" + fld + "_name_" + listno).val(rvalue.name);
        $("#" + fld + "_path_" + listno).val(rvalue.path);
        $("#" + fld + "_" + listno).val(rvalue.path);
        $("#" + fld + "_source_name_" + listno).val(rvalue.source);
        $("#" + fld + "_desc_" + listno).val(rvalue.desc);
        $("#" + fld + "_size_" + listno).val(rvalue.size);
        $("#" + fld + "_attach_no_" + listno).val(rvalue.attach_no);
        $("#btn" + fld + "_" + listno).prop("disabled", true);

        //先判斷原本資料是否有attach_sqlno,若有表示修改,若沒有表示新增
        if ($("#" + fld + "_attach_sqlno_" + listno).val() != "") {
            $("#" + fld + "_dbflag_" + listno).val("U");//修改
        } else {
            $("#" + fld + "_dbflag_" + listno).val("A");//新增
        }
    }

    //[上傳]
    multi_upload_form.UploadOptAttach = function (nRow) {
        var fld = $("#opt_uploadfield").val();
        var popt_no = $("#opt_no").val().Left(4);
        var topt_no = $("#opt_no").val().substr(4);
        var tfolder = "attach" + "/" + popt_no + "/" + topt_no;
        var url = getRootPath() + "/sub/upload_win_file.aspx?type=doc&draw_file=" + $("#" + fld + "_" + nRow).val() +
            "&folder_name=" + tfolder + "&form_name=" + fld + "_" + nRow + "&size_name=" + fld + "_size_" + nRow +
            "&file_name=" + fld + "_name_" + nRow +
            "&add_date=" + fld + "_add_date_" + nRow +
            "&add_scode=" + fld + "_add_scode_" + nRow +
            "&btnname=btn" + fld + "_" + nRow +
            "&source_name=" + fld + "_source_name_" + nRow +
            "&desc=" + fld + "_desc_" + nRow;
        window.open(url, "", "width=700 height=600 top=50 left=50 toolbar=no, menubar=no, location=no, directories=no resizeable=no status=no scrollbars=yes");
        //先判斷原本資料是否有attach_sqlno,若有表示修改,若沒有表示新增
        if ($("#" + fld + "_attach_sqlno_" + nRow).val() != "") {
            $("#" + fld + "_dbflag_" + nRow).val("U");
        } else {
            $("#" + fld + "_dbflag_" + nRow).val("A");
        }
    }

    //[刪除]
    multi_upload_form.DelOptAttach = function (nRow) {
        var fld = $("#opt_uploadfield").val();
        var popt_no = $("#opt_no").val().Left(4);
        var topt_no = $("#opt_no").val().substr(4);
        var tfolder = "attach" + "/" + popt_no + "/" + topt_no;

        if ($("#" + fld + "_name_" + nRow).val() == "") {
            return false;
        }
        if (confirm("確定刪除上傳附件？")) {
            var url = getRootPath() + "/sub/del_draw_file.aspx?type=doc&folder_name=" + tfolder + "&draw_file=" + $("#" + fld + "_" + nRow).val() +
                "&btnname=btn" + fld + "_" + nRow + "&form_name=" + fld + "_" + nRow;
            window.open(url, "myWindowOne1", "width=700 height=600 top=10 left=10 toolbar=no, menubar=no, location=no, directories=no resizeable=no status=no scrollbar=no");
            //window.open(url, "myWindowOne1", "width=1 height=1 top=1000 left=1000 toolbar=no, menubar=no, location=no, directories=no resizeable=no status=no scrollbar=no");
            $("#" + fld + "_doc_type" + nRow).val("");
            $("#" + fld + "_name_" + nRow).val("");
            $("#" + fld + "_desc_" + nRow).val("");
            $("#" + fld + "_" + nRow).val("");
            $("#" + fld + "_size_" + nRow).val("");
            $("#" + fld + "_path_" + nRow).val("");
            $("#" + fld + "_add_date_" + nRow).val("");
            $("#" + fld + "_add_scode_" + nRow).val("");
            $("#" + fld + "_source_name_" + nRow).val("");
            //$("#btn" + fld + "_" + nRow).prop("disabled", false);
            //當刪除時,修改DBflag = 'D'
            $("#" + fld + "_dbflag_" + nRow).val("D");
        } else {
            $("#" + fld + "_desc_" + nRow).focus();
        }
    }

    //[檢視]
    multi_upload_form.PreviewOptAttach = function (nRow) {
        var fld = $("#opt_uploadfield").val();
        if ($("#" + fld + "_name_" + nRow).val() == "") {
            alert("請先上傳附件 !!");
            return false;
        }
        var popt_no = $("#opt_no").val().Left(4);
        var topt_no = $("#opt_no").val().substr(4);
        var tfolder = "attach" + "/" + popt_no + "/" + topt_no;
        var url = getRootPath() + "/sub/display_file.aspx?type=doc&folder_name=" + tfolder + "&draw_file=" + $("#" + fld + "_" + nRow).val() + "&gs_date=" + ($("#GS_date").val() || "");
        window.open(url, "window", "width=700,height=600,toolbar=yes,menubar=yes,resizable=yes,scrollbars=yes,status=0,top=50,left=80");
	}

    multi_upload_form.getdesc = function (nRow) {
        
    }
</script>
