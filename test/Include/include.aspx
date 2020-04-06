<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    string value1 = "this is value1";
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    body value1=<%=value1%>
       <!--#include file="head.inc"-->
    </form>
</body>
</html>
