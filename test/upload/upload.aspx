<%@ Page Language="C#"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="x-ua-compatible" content="IE=10">
<title>Dropzone simple example上傳測試</title>
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/inc/setstyle.css")%>" />
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/lib/dropzone.css")%>" />
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery-1.12.4.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/dropzone.js")%>"></script>
</head>


<body>
<p>
  This is the most minimal example of Dropzone. The upload in this example
  doesn't work, because there is no actual server to handle the file upload.
</p>

<!-- Change /upload-target to your upload address -->
<form action="/upload-target" class="dropzone"></form>

</body>
</html>



<script type="text/javascript" language="javascript">
    $(function () {
    });
</script>
