<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "出口爭救案資料修改";//功能名稱
    protected string HTProgPrefix = HttpContext.Current.Request["prgid"] ?? "";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string SQL = "";
    protected string msg = "";

    protected string opt_sqlno = "";
    protected string your_no = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        opt_sqlno = (Request["opt_sqlno"] ?? "").Trim();
        your_no = (Request["your_no"] ?? "").Trim();

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            doCopy();

            this.DataBind();
        }
    }

    private void doCopy() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        try {
            Funcs.insert_log_table(conn, "U", prgid, "opte_detail", "opt_sqlno", opt_sqlno );

            SQL = "update opte_detail Set your_no='" + your_no + "'";
            SQL += " where opt_sqlno=" + opt_sqlno;
            conn.ExecuteNonQuery(SQL);
            conn.Commit();
            //conn.RollBack();
            msg = "案件資料修改成功！";
        }
        catch (Exception ex) {
            conn.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);
            msg = "案件資料修改失敗！！";
            throw new Exception(msg, ex);
        }
        finally {
            conn.Dispose();
        }
    }
</script>

<script language="javascript" type="text/javascript">
    alert("<%#msg%>");
    if ("<%#Request["chkTest"]%>" != "TEST") {
        if (!(window.parent.parent.tt === undefined)) {
            window.parent.parent.tt.rows = "100%,0%";
        }
    }
</script>
