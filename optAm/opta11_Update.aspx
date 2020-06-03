<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "法條明細檔案作業-入檔";//功能名稱
    protected string HTProgPrefix = "opta11";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string SQL = "";
    protected string msg = "";

    string submitTask = "";

    protected Dictionary<string, string> ReqVal = new Dictionary<string, string>();
    protected StringBuilder strOut = new StringBuilder();

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        submitTask = (Request["submittask"] ?? "").Trim();

        ReqVal = Util.GetRequestParam(Context);

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            if (Request["chkTest"] == "TEST") {
                foreach (KeyValuePair<string, string> p in ReqVal) {
                    Response.Write(string.Format("{0}:{1}<br>", p.Key, p.Value));
                }
                Response.Write("<HR>");
            }

            DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
            try {
                if (submitTask == "A") {//新增
                    doAdd(conn);
                } else if (submitTask == "U") {//修改
                    doUpdate(conn);
                } else if (submitTask == "D") {//停用
                    doDel(conn);
                }

                //conn.Commit();
                conn.RollBack();

                msg = "法條明細檔案作業入檔成功!!";
            }
            catch (Exception ex) {
                conn.RollBack();
                Sys.errorLog(ex, conn.exeSQL, prgid);

                msg = "法條明細檔案作業入檔失敗!!!";

                throw new Exception(msg, ex);
            }
            finally {
                conn.Dispose();
            }

            strOut.AppendLine("alert('" + msg + "');");
            if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.parent.Etop.goSearch();");

            this.DataBind();
        }
    }

    private void doAdd(DBHelper conn) {
        SQL = " INSERT into law_detail ";
        SQL += "(law_type,law_no1,law_no2,law_no3,law_mark,tran_Scode,tran_Date,end_date) ";
        SQL += " VALUES ";
        SQL += "('" + Request["edit_law_type"] + "'";
        SQL += ",'" + Request["edit_law_no1"] + "'";
        SQL += ",'" + Request["edit_law_no2"] + "'";
        SQL += ",'" + Request["edit_law_no3"] + "'";
        SQL += ",'" + Request["edit_law_mark"].ToBig5() + "'";
        SQL += ",'" + Session["scode"] + "'";
        SQL += ",GETDATE() ";
        SQL += ",null )";
        conn.ExecuteNonQuery(SQL);
    }

    private void doUpdate(DBHelper conn) {
        if (ReqVal.TryGet("O_edit_law_mark", "") != ReqVal.TryGet("edit_law_mark", "")) {
            Funcs.insert_log_table(conn, "U", prgid, "law_detail", "law_sqlno", ReqVal.TryGet("law_sqlno", ""));

            SQL = " Update law_detail ";
            SQL += "set law_mark = '" + Request["edit_law_mark"].ToBig5() + "'";
            SQL += ",tran_scode = '" + Session["scode"] + "'";
            SQL += " where 1=1 and law_sqlno = '" + Request["law_sqlno"] + "'";
            conn.ExecuteNonQuery(SQL);
        }
    }

    private void doDel(DBHelper conn) {
        Funcs.insert_log_table(conn, "D", prgid, "law_detail", "law_sqlno", ReqVal.TryGet("law_sqlno", ""));

        SQL = " Update law_detail ";
        if (ReqVal.TryGet("edit_end_date", "") == "") {
            SQL += "set end_date = NULL";
        } else {
            SQL += "set end_date = '" + Request["edit_end_date"] + "'";
        }
        SQL += ",tran_scode = '" + Session["scode"] + "'";
        SQL += " where 1=1 and law_sqlno = '" + Request["law_sqlno"] + "'";
        conn.ExecuteNonQuery(SQL);
    }
</script>

<script language="javascript" type="text/javascript">
    <%Response.Write(strOut.ToString());%>
</script>
