<%@ Page Language="C#" CodePage="65001" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">
    protected string StrProjectName = Sys.getAppSetting("Project");

    protected void Page_PreInit(object sender, EventArgs e) {
        Sys.errorLog(new Exception("1_Page_PreInit"), "", "0000");
    }
    protected void Page_Init(object sender, EventArgs e) {
        Sys.errorLog(new Exception("2_Page_Init"), "", "0000");
    }
    protected void Page_InitComplete(object sender, EventArgs e) {
        Sys.errorLog(new Exception("3_Page_InitComplete"), "", "0000");
    }
    protected void Page_PreLoad(object sender, EventArgs e) {
        Sys.errorLog(new Exception("4_Page_PreLoad"), "", "0000");
    }
    protected void Page_Load(object sender, EventArgs e) {
        Sys.errorLog(new Exception("5_Page_Load"), "", "0000");
        throw new Exception("擲出Exception");
    }
    protected void Page_LoadComplete(object sender, EventArgs e) {
        Sys.errorLog(new Exception("6_Page_LoadComplete"), "", "0000");
    }
    protected void Page_PreRender(object sender, EventArgs e) {
        Sys.errorLog(new Exception("7_Page_PreRender"), "", "0000");
    }
    protected void Page_PreRenderComplete(object sender, EventArgs e) {
        Sys.errorLog(new Exception("8_Page_PreRenderComplete"), "", "0000");
    }
    protected void Page_SaveStateComplete(object sender, EventArgs e) {
        Sys.errorLog(new Exception("9_Page_SaveStateComplete"), "", "0000");
    }
    protected void Page_Unload(object sender, EventArgs e) {
        // No message can be shown at this stage
        Sys.errorLog(new Exception("10_Page_Unload"), "", "0000");
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
<title><%#StrProjectName%></title>
</head>
<body></body>
</html>
