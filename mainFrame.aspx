<%@ Page Language="C#" CodePage="65001" %>
<script runat="server">
    protected string mainSrc = "";
    
	private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        if (Convert.ToBoolean(Session["Password"])) {
            mainSrc = "homelist.aspx";
        } else {
            mainSrc = "login.aspx";
        }
        this.Page.DataBind();
    }
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf8"/>
<meta http-equiv="cache-control" content="no-cache"/>
</head>
<!--frameset col="30%,70%" id="tt">
    <frame name="Etop" id="Etop" scrolling="auto" src="homelist.aspx"/>
    <frame name="Eblank" id="Eblank" scrolling="auto" src="login.aspx"/>
</frameset-->
<frameset name="f" id="f" cols="0,*">
    <frame src="about:blank" frameborder="0" name="leftFrame" id="leftFrame" />
    <frameset rows="100%,*" name="tt" id="tt">
        <frame name="Etop" id="Etop" scrolling="auto" src="<%#mainSrc%>">"/>
        <frame name="Eblank" id="Eblank" scrolling="auto" src="about:blank"/>
　　 </frameset>
</frameset>
</html>
