<%@ Page Language="C#"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string uploadfield = "";
    protected string prgid = "";
    
    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="x-ua-compatible" content="IE=11">

    <title>多檔上傳</title>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery-1.12.4.min.js")%>"></script>
</head>

<body>
    <input type="button" value="檔案上傳(可批次)" class="greenbutton" onclick="multi_upload_onclick()" id="multi_upload_button" name="multi_upload_button">
</body>
</html>

<script type="text/javascript" language="javascript">
    //多檔上傳
    function multi_upload_onclick(){
        var seq = $("#seq").val()||"";
        var tseq = (seq.length >= 5 ? seq : new Array(5 - seq.length + 1).join("0") + seq);//不足五碼前面補0，ex:01234
        var tfolder = "temp/<%=Session["se_branch"]%>/" + $("#seq1").val() + "/" + tseq.substring(0,3) +"/"+ tseq;  //_/123/12345
	
        urlasp = "multi_upload_file.aspx?prgid=<%=prgid%>&seqdept=P&seq=" + $("#seq").val() + "&seq1=" + $("#seq1").val() + "&step_grade=" + $("#step_grade").val();
        urlasp +="&job_sqlno="+$("#job_sqlno").val()+"&upfolder="+tfolder+"&attach_tablename=dmp_attach&temptable=attachtemp";
        urlasp += "&attach_no=" + $("#<%=uploadfield%>filenum").val() + "&screen_no=" + $("#<%=uploadfield%>sqlnum").val();
        window.open(urlasp,"","width=700 height=600 top=50 left=150 toolbar=no, menubar=no, location=no, directories=no resizeable=no status=yes scrollbars=yes");
    }

    //上傳後回傳資料顯示於畫面上
    function AddFileattach(rvalue)
    {
        file_Add_button_onclick1("<%=uploadfield%>");
        //alert(rvalue);
        var arvalue = rvalue.split("#@#");
        //傳回:檔案名稱，虛擬完整路徑，原始檔名，檔案大小，attach_no
        //alert(arvalue[0]);
        //alert(arvalue[1]);
        var listno = document.getElementById("<%=uploadfield%>sqlnum").value;
        //alert(listno);
        document.getElementById("<%=uploadfield%>_name" + listno).value = arvalue[0];
        document.getElementById("<%=uploadfield%>_path" + listno).value = arvalue[1];
        document.getElementById("<%=uploadfield%>" + listno).value = arvalue[1];
        document.getElementById("<%=uploadfield%>_source_name" + listno).value = arvalue[2];
        document.getElementById("<%=uploadfield%>_size" + listno).value = arvalue[3];
        document.getElementById("<%=uploadfield%>_attach_no" + listno).value = arvalue[4];
        document.getElementById("<%=uploadfield%>_dbflag" + listno).value = "A"; //新增
    }
</script>