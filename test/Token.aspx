<%@ Page Language="C#" CodePage="65001" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">
    protected string StrProjectName = system.getAppSetting("Project");

	private void Page_Load(Object sender, EventArgs e) {
        Token token = new Token("opt11");
        token.Check(false);
         Response.Write(token.Check(128));
        Response.Write(token.Rights);
	}

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="icon" type="image/ico" href="./icon/myfarm.ico" />
<link rel="shortcut icon" href="./icon/myfarm.ico" />
<title><%#StrProjectName%></title>
</head>
<body></body>
</html>