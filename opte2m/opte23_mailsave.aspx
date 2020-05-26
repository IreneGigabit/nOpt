<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.IO"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "發文(Email暫存)";//功能名稱
    protected string HTProgPrefix = "opte23";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string SQL = "";
    protected string msg = "";

    string submitTask = "";
    string email_sqlno = "";

    protected Dictionary<string, string> ReqVal = new Dictionary<string, string>();
    protected StringBuilder strOut = new StringBuilder();

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        submitTask = (Request["submittask"] ?? "").Trim();
        ReqVal = Util.GetRequestParam(Context);
        email_sqlno = (Request["email_sqlno"] ?? "").Trim();

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            if (Request["chkTest"] == "TEST") {
                foreach (KeyValuePair<string, string> p in ReqVal) {
                    Response.Write(string.Format("{0}:{1}<br>", p.Key, p.Value));
                }
                Response.Write("<HR>");
            }

            if (submitTask == "A") {//新增
                doAdd();
            } else if (submitTask == "U") {//存檔
                doUpdate();
            } else if (submitTask == "D") {//刪除
                doDelete();
            }

            this.DataBind();
        }
    }

    //勾選的附件檔名串接
    private string getFileStr() {
        List<string> arr_pdf_name = new List<string>();
        for (int i = 1; i <= Convert.ToInt32(ReqVal.TryGet("pdfcnt", "0")); i++) {
            if (ReqVal.TryGet("pdf_send" + i, "") == "Y") {
                //抓檔名
                arr_pdf_name.Add(System.IO.Path.GetFileName(ReqVal.TryGet("pdfname" + i, "")));
            }
        }
        return string.Join(";", arr_pdf_name.ToArray());
    }

    private void doAdd() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");

        try {
            string log_flag = "";
            if (ReqVal.TryGet("tf_class", "").Trim() != "") {
                log_flag = ReqVal.TryGet("tf_class", "").Trim() + "_email";
            } else {
                if (ReqVal.TryGet("tf_class", "").Trim() != "") {
                    log_flag = ReqVal.TryGet("log_flag", "").Trim();
                } else {
                    log_flag = "email";
                }
            }
            SQL = "INSERT INTO opt_email_log (";
            SQL += "log_flag,agt_comp,dept,seq,seq1";
            SQL += ",job_sqlno,tfsend_no,work_scode,att_name,to_email,cc_email,bcc_email,from_email";
            SQL += ",pdf_name,attach_name,file_size,email_title,content,from_prgid,mail_status";
            SQL += ",in_date,in_scode,tran_date,tran_scode";
            SQL += ") VALUES('" + log_flag + "','" + Request["agt_comp"] + "','" + Request["sendrs_kind"] + "'";
            SQL += "," + Request["sendseq"] + ",'" + Request["sendseq1"] + "'";
            SQL += ",'" + Request["job_sqlno"] + "','" + Request["tfsend_no"] + "','" + Request["work_scode"] + "'";
            SQL += ",'" + Request["att_name"] + "','" + Request["att_email"] + "','" + Request["cc_email"] + "','" + Request["bcc_email"] + "'";
            SQL += ",'" + ReqVal.TryGet("from_email", "").Trim() + "','" + getFileStr() + "','','" + Request["file_size"] + "'";
            SQL += "," + Util.dbchar(ReqVal.TryGet("tf_subject", "")).ToBig5() + "," + Util.dbchar(ReqVal.TryGet("tf_content", "")).ToBig5() + ",'" + prgid + "','draft'";
            SQL += ",GETDATE(),'" + Request["send_scode"] + "',GETDATE(),'" + Request["send_scode"] + "'";
            SQL += ")";
            conn.ExecuteNonQuery(SQL);

            msg = "發文--Email暫存成功!!";

            conn.Commit();
            //conn.RollBack();
        }
        catch (Exception ex) {
            conn.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);
            msg = "發文(Email暫存)--失敗!!!";

            throw new Exception(msg, ex);
        }
        finally {
            conn.Dispose();
        }

        strOut.AppendLine("alert('" + msg + "');");
        if (Request["chkTest"] != "TEST") {
            strOut.AppendLine("window.parent.opener.parent.Etop.goSearch();");
            strOut.AppendLine("window.parent.close();");
        }
    }

    private void doUpdate() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");

        try {
            Funcs.insert_log_table(conn, "U", prgid, "opt_email_log", "email_sqlno", email_sqlno);
            SQL = "update opt_email_log set work_scode='" + Request["work_scode"] + "'";
            SQL += ",att_name='" + Request["att_name"] + "'";
            SQL += ",to_email='" + Request["att_email"] + "'";
            SQL += ",from_email='" + ReqVal.TryGet("from_email", "").Trim() + "'";
            SQL += ",email_title=" + Util.dbchar(ReqVal.TryGet("tf_subject", "")).ToBig5();
            SQL += ",content=" + Util.dbchar(ReqVal.TryGet("tf_content", "")).ToBig5();
            SQL += ",tran_date=getdate()";
            SQL += ",tran_scode='" + Request["send_scode"] + "'";
            SQL += ",pdf_name='" + getFileStr() + "'";
            SQL += ",file_size='" + Request["file_size"] + "'";
            SQL += " where email_sqlno=" + email_sqlno;
            conn.ExecuteNonQuery(SQL);

            msg = "發文--Email暫存-修改成功!!";

            conn.Commit();
            //conn.RollBack();
        }
        catch (Exception ex) {
            conn.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);
            msg = "發文(Email暫存)--失敗!!!";

            throw new Exception(msg, ex);
        }
        finally {
            conn.Dispose();
        }

        strOut.AppendLine("alert('" + msg + "');");
        if (Request["chkTest"] != "TEST") {
            strOut.AppendLine("window.parent.opener.parent.Etop.goSearch();");
            strOut.AppendLine("window.parent.close();");
        }
    }

    private void doDelete() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");

        try {
            Funcs.insert_log_table(conn, "D", prgid, "opt_email_log", "email_sqlno", email_sqlno);
            SQL = "delete from opt_email_log where email_sqlno=" + email_sqlno;
            conn.ExecuteNonQuery(SQL);

            msg = "發文--Email暫存-刪除成功!!";

            conn.Commit();
            //conn.RollBack();
        }
        catch (Exception ex) {
            conn.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);
            msg = "發文(Email暫存)--失敗!!!";

            throw new Exception(msg, ex);
        }
        finally {
            conn.Dispose();
        }

        strOut.AppendLine("alert('" + msg + "');");
        if (Request["chkTest"] != "TEST") {
            strOut.AppendLine("window.parent.opener.parent.Etop.goSearch();");
            strOut.AppendLine("window.parent.close();");
        }
    }
</script>

<script language="javascript" type="text/javascript">
    <%Response.Write(strOut.ToString());%>
</script>
