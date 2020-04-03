<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/inc/setstyle.css")%>" />
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/lib/jquery.datepick.css")%>" />
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/lib/toastr.css")%>" />
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery-1.12.4.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery.datepick.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery.datepick-zh-TW.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/toastr.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/util.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.irene.form.js")%>"></script>
</head>
<body>
<form id="form1" runat="server">
    <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="100%">
    <tr>
        <td class="lightbluetable" colspan="8" valign="top">
            <TEXTAREA id=Ptran_remark1 class=sedit rows=9 cols=90 readOnly name=Ptran_remark1 style="white-space: pre-wrap"></TEXTAREA>
        </td>
    </tr>
    </table>
</form>
</body>
</html>

<script language="javascript">
    $("#Ptran_remark1").val("1.二者商標皆以AS為主體，且以AS重疊方式表現，且指定於同一或類似商品。\r\n2.吳氏皮飾為一個非常知名的廠商，名下的商標共計為數十件商標，幾乎皆以AS為商標命名，其在各大百貨公司設立裝櫃。\r\n3.被異議人確以國正布業有限公司標章，躲開官方審查，其取得註冊顯有不當，係屬二者為近似商標，依商標法第23條1項13款應予撤銷。\r\n該公司網站http://www.as-eweb.com\r\n");
</script>
