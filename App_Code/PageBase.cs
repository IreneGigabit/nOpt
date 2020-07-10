using System;
using System.Text;

/// <summary>
/// 登入驗證的相關程式碼
/// 每頁本來繼承【System.Web.UI.Page】改繼承【PageBase】即可
/// https://dotblogs.com.tw/topcat/2014/09/24/146692
/// https://www.cnblogs.com/VinC/archive/2008/05/22/1991086.html
/// </summary>
public class PageBase : System.Web.UI.Page
{
    //是否須登入驗證，預設要
    public bool LoginChk = true;

    protected override void OnPreInit(EventArgs e) {
        base.OnPreInit(e);
        ChkLogin();
    }

    protected override void OnLoad(EventArgs e) {
        base.OnLoad(e);
        ChkLogin();
    }

    ///<summary>
    ///登入驗證
    ///</summary>
    private void ChkLogin() {
        if (LoginChk) {//要驗證
            //如果Session("isLogined")不是Y→未登入
            if (Convert.ToBoolean(Session["Password"])==false) {
                //清除所有的Session
                //Session.Abandon();//會把連線字串也洗掉
                //導向到Login.aspx
                //Response.Redirect("~/Login.aspx");//無法指定window.top
                //ClientScript.RegisterClientScriptBlock(this.GetType(), "RedirectScript", "window.top.location.href = '" + Request.ApplicationPath + "/Login.aspx';");
                StringBuilder jsText = new StringBuilder();
                jsText.AppendLine("<script type='text/javascript'>");
                jsText.AppendLine("alert('系統停滯時間逾時，請重新登入(base)！'); ");
                jsText.AppendLine("if (typeof(window.opener)!='undefined'){");
                jsText.AppendLine(" window.opener.top.location.href = '" + (Request.ApplicationPath == "/" ? "" : Request.ApplicationPath) + "/Login.aspx'; ");
                jsText.AppendLine(" window.close();");
                jsText.AppendLine("}else{");
                jsText.AppendLine(" window.top.location.href = '" + (Request.ApplicationPath == "/" ? "" : Request.ApplicationPath) + "/Login.aspx'; ");
                jsText.AppendLine("}");
                jsText.AppendLine("</script>");
                Response.Write(jsText);
                Response.End();
            }
        }
    }
}
