<%@ Page Language="C#" CodePage="65001"%>

<script runat="server">
    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        this.DataBind();
    }
</script>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5;no-caches;">
<title></title>
</head>
    <frameset rows="100%,*" name="tt" id="tt">
        <frame name="Etop" id="Etop" scrolling="auto" src="mailopen.aspx?prgid=<%#Request["prgid"]%>&source=<%#Request["source"]%>&job_sqlno=<%#Request["job_sqlno"]%>&tfsend_no=<%#Request["tfsend_no"]%>>" />
        <frame name="Eblank" id="Eblank" scrolling="auto" src="about:blank"/>
　　 </frameset>
</html>
