<%@ Page Language="C#"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string prgid = "";
    protected string uploadfield = "attach";
    protected string uploadsource = "PR";
    protected string html_attach_doc = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        html_attach_doc = Funcs.getdoc_type("").Option("{cust_code}", "{code_name}");
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="x-ua-compatible" content="IE=11">
    <title>多檔上傳</title>
    <link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/inc/setstyle.css")%>" />
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery-1.12.4.min.js")%>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/util.js")%>"></script>
</head>

<body>
    <input type="text" name="<%=uploadfield%>_maxAttach_no" id="<%=uploadfield%>_maxAttach_no" value="0"><!--isnull(max(dmp_attach.attach_no),0)-->
    <input type="text" name="<%=uploadfield%>_maxfilenum" id="<%=uploadfield%>_maxfilenum" value="0"><!--dmp_attach.attach_no-->
    <input type="text" name="<%=uploadfield%>_attach_cnt" id="<%=uploadfield%>_attach_cnt" value="0"><!--dmp_attach目前table的筆數-->
    <input type="text" name="<%=uploadfield%>filenum" id="<%=uploadfield%>filenum" value="0"><!--dmp_attach.attach_no-->
    <input type="text" name="<%=uploadfield%>sqlnum" id="<%=uploadfield%>sqlnum" value="0"><!--畫面NO顯示編號-->
    <input type="text" name="<%=uploadfield%>sqlnumadd" id="<%=uploadfield%>sqlnumadd" value="0">
    <input type="text" name="uploadfield" id="uploadfield" value="<%=uploadfield%>">
    <input type="text" name="uploadsource" id="uploadsource" value="<%=uploadsource%>">

    <TABLE id='tabfile<%=uploadfield%>' border=0 class="bluetable" cellspacing=1 cellpadding=2 width="80%">
	    <TR>
		    <TD class=whitetablebg align=center colspan=5>
	            <input type="button" value="檔案上傳(可批次)" class="greenbutton" onclick="multi_upload_onclick()" id="multi_upload_button" name="multi_upload_button">
		    </TD>
	    </TR>
    </table>


    <script type="text/html" id="attach-template">
    	<TR>
		    <TD class=lightbluetable align=center>
                附件<input type=text name='<%=uploadfield%>_sqlno_##' class=gsedit1 readonly size=2 value='##'>.
		    </TD>
		    <TD class=sfont9 align=left colspan="2">
                <span id='span_<%=uploadfield%>_esend_flag_##'>
                    <input type='checkbox' name='<%=uploadfield%>_esend_flag_##' id='<%=uploadfield%>_esend_flag_##' disabled onclick="esend_flag_onclick('##')">
                    電子送件檔(檔案複製時會以原始檔名複製至送件資料夾，原始檔名請依智慧局規定設定)<br>
                </span>
                附件名稱：<input type=text name='<%=uploadfield%>_name_##' id='<%=uploadfield%>_name_##' class=sedit readonly size=45 maxlength=50>
                <input type=button name='btn<%=uploadfield%>_##' class='sgreenbutton' value='上傳' onclick="UploadAttach('##')">
                <input type=button name='btn<%=uploadfield%>D_##' class='sgreenbutton' value='刪除' onclick="DelAttach('##')">
                <input type=button name='btn<%=uploadfield%>S_##' class='sgreenbutton' value='檢視' onclick="PreviewAttach('##')">
                <input type='hidden' name='<%=uploadfield%>_dmp_sqlno_##' id='<%=uploadfield%>_dmp_sqlno_##'>
                <input type='hidden' name='<%=uploadfield%>_dbflag_##' id='<%=uploadfield%>_dbflag_##'>
                <input type='hidden' name='<%=uploadfield%>_attach_sqlno_##' id='<%=uploadfield%>_attach_sqlno_##'>
                <input type='hidden' name='<%=uploadfield%>_##' id='<%=uploadfield%>_##'>
                <input type='hidden' name='<%=uploadfield%>_attach_no_##' id='<%=uploadfield%>_attach_no_##' value='##'>
                <input type='hidden' name='<%=uploadfield%>_path_##' id='<%=uploadfield%>_path_##' value="">
                <input type='hidden' name='<%=uploadfield%>_page_##' id='<%=uploadfield%>_page_##' value='0'>
                <input type='hidden' name='<%=uploadfield%>_copyfile_flag_##' id='<%=uploadfield%>_copyfile_flag_##' value=''>
                <input type='hidden' name='<%=uploadfield%>_case_no_##' id='<%=uploadfield%>_case_no_##' value=''>
                <input type='hidden' name='<%=uploadfield%>_in_scode_##' id='<%=uploadfield%>_in_scode_##' value=''>
                <input type='hidden' name='<%=uploadfield%>_apattach_sqlno_##' id='<%=uploadfield%>_apattach_sqlno_##' value='' size=11>
                <input type='hidden' name='<%=uploadfield%>_save_##' id='<%=uploadfield%>_save_##' value='N' size=1>
                <br>文件種類：
	            <Select id='<%=uploadfield%>_doc_type_##' name='<%=uploadfield%>_doc_type_##' Onchange="upload_form.getdesc('##')" class="BLock YZLock"><%=html_attach_doc%></Select>
                <br>附件說明：
                <input type=text name='<%=uploadfield%>_desc_##' id='<%=uploadfield%>_desc_##' size=50 maxlength=50 onblur="fChkDataLen(this,'附件說明')">
                <br>
                上傳日期：<input type=text name='<%=uploadfield%>_in_date_##' id='<%=uploadfield%>_in_date_##' class='sedit' readonly size=24 onblur="fChkDataLen(this,'上傳日期')">
                &nbsp;原始檔名：<input type=text name='<%=uploadfield%>_source_name_##' id='<%=uploadfield%>_source_name_##' class=sedit readonly size=45 maxlength=50>
                <span id='span_<%=uploadfield%>_size_##' style='display:none'>&nbsp;檔案大小：<input type=text name='<%=uploadfield%>_size_##' id='<%=uploadfield%>_size_##' class=sedit readonly size=12>Byte</span>
		    </TD>
	    </TR>
    </script>

</body>
</html>

<script type="text/javascript" language="javascript">
    //多檔上傳
    function multi_upload_onclick() {
        var seq = $("#seq").val() || "";
        var tseq = (seq.length >= 5 ? seq : new Array(5 - seq.length + 1).join("0") + seq);//不足五碼前面補0，ex:01234
        var tfolder = "temp/<%=Session["se_branch"]%>/" + $("#seq1").val() + "/" + tseq.substring(0, 3) + "/" + tseq;  //_/123/12345

        urlasp = "multi_upload_file.aspx?prgid=<%=prgid%>";
        urlasp += "&seqdept=P&seq=" + $("#seq").val() + "&seq1=" + $("#seq1").val() + "&step_grade=" + $("#step_grade").val();
        urlasp += "&job_sqlno=" + $("#job_sqlno").val() + "&upfolder=" + tfolder + "&attach_tablename=dmp_attach&temptable=attachtemp";
        urlasp += "&attach_no=" + $("#<%=uploadfield%>filenum").val() + "&screen_no=" + $("#<%=uploadfield%>sqlnum").val();
        window.open(urlasp, "", "width=700 height=600 top=50 left=150 toolbar=no, menubar=no, location=no, directories=no resizeable=no status=yes scrollbars=yes");
    }

    //增加一筆
    multi_upload_form.appendFile = function () {
        var template = $('#attach-template').text();

        $('#tabfile<%=uploadfield%>').append(template);
    };

    //上傳後回傳資料顯示於畫面上
    function AddFileattach(rvalue) {
        var fld = "<%=uploadfield%>";
        multi_upload_form.appendFile();
        //alert(rvalue);
        var arvalue = rvalue.split("#@#");
        //傳回:檔案名稱，虛擬完整路徑，原始檔名，檔案大小，attach_no
        //alert(arvalue[0]);
        //alert(arvalue[1]);
        var listno = document.getElementById(fld + "sqlnum").value;
        //alert(listno);
        document.getElementById(fld + "_name_" + listno).value = arvalue[0];
        document.getElementById(fld + "_path_" + listno).value = arvalue[1];
        document.getElementById(fld + "_" + listno).value = arvalue[1];
        document.getElementById(fld + "_source_name_" + listno).value = arvalue[2];
        document.getElementById(fld + "_size_" + listno).value = arvalue[3];
        document.getElementById(fld + "_attach_no_" + listno).value = arvalue[4];
        document.getElementById(fld + "_dbflag_" + listno).value = "A"; //新增
    }
</script>
