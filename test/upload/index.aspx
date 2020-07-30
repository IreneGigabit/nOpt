<%@ Page Language="C#"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string prgid = "";
    protected string uploadfield = "attach";
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
    案件編號：<input type="text" name="opt_no" id="opt_no" value="2011000060" class="SEdit" readonly>
    流水號：<input type="text" name="opt_sqlno" id="opt_sqlno" value="78" class="SEdit" readonly>
    <br />
    <input type="text" name="<%=uploadfield%>_filenum" id="<%=uploadfield%>_filenum" value="0"><!--dmp_attach.attach_no-->
    <input type="text" name="<%=uploadfield%>_sqlnum" id="<%=uploadfield%>_sqlnum" value="0"><!--畫面NO顯示編號-->
    <input type="text" name="<%=uploadfield%>_maxAttach_no" id="<%=uploadfield%>_maxAttach_no" value="0"><!--isnull(max(dmp_attach.attach_no),0)-->
    <input type="text" name="<%=uploadfield%>_maxfilenum" id="<%=uploadfield%>_maxfilenum" value="0"><!--dmp_attach.attach_no-->
    <input type="text" name="<%=uploadfield%>_attach_cnt" id="<%=uploadfield%>_attach_cnt" value="0"><!--dmp_attach目前table的筆數-->
    <input type="text" name="uploadfield" id="uploadfield" value="<%=uploadfield%>">
    <TABLE id='tabfile<%=uploadfield%>' border=0 class="bluetable" cellspacing=1 cellpadding=2 width="80%">
	    <TR>
		    <TD class=whitetablebg align=center colspan=5>
			    <input type=button value="增加一筆附件" class="c1button" id="<%=uploadfield%>_Add_button" name="<%=uploadfield%>_Add_button" onclick="multi_upload_form.appendFile()">
                <input type="button" value="檔案上傳(可批次)" class="greenbutton" onclick="multi_upload_onclick()" id="multi_upload_button" name="multi_upload_button">
		    </TD>
	    </TR>
    </table>


    <script type="text/html" id="attach-template">
    	<TR>
		    <TD class=lightbluetable align=center>
                附件<input type=text name='<%=uploadfield%>_sqlno_##' class=SEdit readonly size=2 value='##'>.
		    </TD>
		    <TD class=sfont9 align=left colspan="2">
 	            附件名稱：<input type=text id='<%=uploadfield%>_name_##' name='<%=uploadfield%>_name_##' class="Lock" size=45 maxlength=50>
	            <input type=button id='btn<%=uploadfield%>_##' name='btn<%=uploadfield%>_##' class='cbutton BLock YZLock' value='上傳' onclick="upload_form.UploadOptAttach('##')">
	            <input type=button id='btn<%=uploadfield%>_D_##' name='btn<%=uploadfield%>_D_##' class='delbutton BLock YZLock' value='刪除' onclick="upload_form.DelOptAttach('##')">
	            <input type=button id='btn<%=uploadfield%>_S_##' name='btn<%=uploadfield%>_S_##' class='cbutton' value='檢視' onclick="upload_form.PreviewOptAttach('##')">
                <label style="color:blue"><INPUT id='<%=uploadfield%>_doc_flag_##' type=checkbox value=E name='<%=uploadfield%>_doc_flag_##'>電子送件檔</label>
	            <input type='hidden' id='<%=uploadfield%>_dbflag_##' name='<%=uploadfield%>_dbflag_##' value="A">
	            <input type='hidden' id='<%=uploadfield%>_attach_sqlno_##' name='<%=uploadfield%>_attach_sqlno_##'>
	            <input type='hidden' id='<%=uploadfield%>_##' name='<%=uploadfield%>_##'>
	            <input type='hidden' id='<%=uploadfield%>_attach_no_##' name='<%=uploadfield%>_attach_no_##' value='##'>
	            <input type='hidden' id='<%=uploadfield%>_path_##' name='<%=uploadfield%>_path_##' value=''>
	            <input type='hidden' id='<%=uploadfield%>_add_scode_##' name='<%=uploadfield%>_add_scode_##' value=''>
                <br>文件種類：<Select id='<%=uploadfield%>_doc_type_##' name='<%=uploadfield%>_doc_type_##' Onchange="upload_form.getdesc('##')" class="BLock YZLock"><%=html_attach_doc%></Select>
                <br>附件說明：<input type=text name='<%=uploadfield%>_desc_##' id='<%=uploadfield%>_desc_##' size=50 maxlength=50 onblur="fChkDataLen(this,'附件說明')">
                <br>上傳日期：<input type=text name='<%=uploadfield%>_in_date_##' id='<%=uploadfield%>_in_date_##' class='SEdit' readonly size=24 onblur="fChkDataLen(this,'上傳日期')">
                &nbsp;原始檔名：<input type=text name='<%=uploadfield%>_source_name_##' id='<%=uploadfield%>_source_name_##' class=SEdit readonly size=45 maxlength=50>
                &nbsp;檔案大小：<input type=text name='<%=uploadfield%>_size_##' id='<%=uploadfield%>_size_##' class=SEdit readonly size=12>Byte
		    </TD>
	    </TR>
    </script>

</body>
</html>

<script type="text/javascript" language="javascript">
    var multi_upload_form = {};

    //增加一筆
    multi_upload_form.appendFile = function () {
        var fld = "<%=uploadfield%>";
        var tfilenum = parseInt($("#" + fld + "_filenum").val(), 10) + 1;//attach_no
        var tsqlnum = parseInt($("#" + fld + "_sqlnum").val(), 10) + 1;//畫面顯示NO
        var maxattach_no = parseInt($("#" + fld + "_maxAttach_no").val(), 10) + 1;//table+畫面顯示 NO

        var template = $('#attach-template').text().replace(/##/g, tsqlnum);
        $('#tabfile' + fld).append(template);

        $("#" + fld + "_filenum").val(tfilenum);
        $("#" + fld + "_sqlnum").val(tsqlnum);
        $("#" + fld + "_maxAttach_no").val(maxattach_no);
    };

    //多檔上傳
    function multi_upload_onclick() {
        var popt_no = $("#opt_no").val().Left(4);
        var topt_no = $("#opt_no").val().substr(4);
        var tfolder = "attach" + "/" + popt_no + "/" + topt_no;
        var urlasp = "multi_upload_file.aspx?type=doc&prgid=<%=prgid%>&remark=" + escape("多檔上傳");
        urlasp += "&upfolder=" + tfolder + "&temptable=attachtemp_opt&attach_tablename=attach_opt";
        urlasp += "&nfilename=KT-" + $("#opt_no").val() + "-{{attach_no}}m";
        //attachtemp_opt的key值
        urlasp += "&syscode=<%=Session["Syscode"]%>&apcode=&branch=K&dept=T&opt_sqlno=" + $("#opt_no").val();
        window.open(urlasp, "", "width=700 height=600 top=50 left=150 toolbar=no, menubar=no, location=no, directories=no resizeable=no status=yes scrollbars=yes");
    }

    //上傳後回傳資料顯示於畫面上
    function uploadSuccess(rvalue) {
        var fld = "<%=uploadfield%>";
        multi_upload_form.appendFile();
        //傳回:檔案名稱，虛擬完整路徑，原始檔名，檔案大小，attach_no
        var listno = $("#" + fld + "_sqlnum").val();
        $("#" + fld + "_name_" + listno).val(rvalue.name);
        $("#" + fld + "_path_" + listno).val(rvalue.path);
        $("#" + fld + "_" + listno).val(rvalue.path);
        $("#" + fld + "_source_name_" + listno).val(rvalue.source);
        $("#" + fld + "_desc_" + listno).val(rvalue.desc);
        $("#" + fld + "_size_" + listno).val(rvalue.size);
        $("#" + fld + "_attach_no_" + listno).val(rvalue.attach_no);
        $("#" + fld + "_dbflag_" + listno).val("A"); //新增
    }
</script>
