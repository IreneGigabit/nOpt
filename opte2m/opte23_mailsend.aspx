<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.IO"%>
<%@ Import Namespace = "System.Linq"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "發文(Email發送)";//功能名稱
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
        ReqVal = Request.Form.ToDictionary();
        email_sqlno = (Request["email_sqlno"] ?? "").Trim();

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            //foreach (KeyValuePair<string, string> p in ReqVal) {
            //    Response.Write(string.Format("{0}:{1}<br>", p.Key, p.Value));
            //}
            //Response.Write("<HR>");

            DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
            try {
                doSave(conn);
                doSend();
                
                conn.Commit();
                //conn.RollBack();

                msg = "發文--Email發送成功!!!，請確認是否有收到此份Email副本，若無收到，請通知資訊部，謝謝。";
            }
            catch (Exception ex) {
                conn.RollBack();
                Sys.errorLog(ex, conn.exeSQL, prgid);
                msg = "發文(Email發送)--失敗!!!";

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

    private void doSave(DBHelper conn) {
        if (ReqVal.TryGet("mail_status", "").Trim() == "draft") {
            Funcs.insert_log_table(conn, "U", prgid, "opt_email_log", "email_sqlno", email_sqlno);
            SQL = "update opt_email_log set work_scode='" + Request["work_scode"] + "'";
            SQL += ",att_name='" + Request["att_name"] + "'";
            SQL += ",to_email='" + Request["att_email"] + "'";
            SQL += ",cc_email='" + Request["cc_email"] + "'";
            SQL += ",bcc_email='" + Request["bcc_email"] + "'";
            SQL += ",from_email='" + ReqVal.TryGet("from_email", "").Trim() + "'";
            SQL += ",email_title=" + Util.dbchar(ReqVal.TryGet("tf_subject", "")).ToBig5();
            SQL += ",content=" + Util.dbchar(ReqVal.TryGet("tf_content", "")).ToBig5();
            SQL += ",tran_date=getdate()";
            SQL += ",tran_scode='" + Request["send_scode"] + "'";
            SQL += ",pdf_name='" + getFileStr() + "'";
            SQL += ",file_size='" + Request["file_size"] + "'";
            SQL += ",mail_status='send' ";
            SQL += " where email_sqlno=" + email_sqlno;
            conn.ExecuteNonQuery(SQL);
        } else {
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
            SQL += "," + Util.dbchar(ReqVal.TryGet("tf_subject", "")).ToBig5() + "," + Util.dbchar(ReqVal.TryGet("tf_content", "")).ToBig5() + ",'" + prgid + "','send'";
            SQL += ",GETDATE(),'" + Request["send_scode"] + "',GETDATE(),'" + Request["send_scode"] + "'";
            SQL += ")";
            conn.ExecuteNonQuery(SQL);
        }

        SQL = "update br_opte set email_cnt=email_cnt+1";
        SQL += " where opt_sqlno='" + Request["job_sqlno"] + "'";
        conn.ExecuteNonQuery(SQL);
    }

    private void doSend() {
        //主旨
        string Subject = ReqVal.TryGet("tf_subject", "").ToBig5();

        //內文
        //表頭2017/6/9修改，因北京更換Exchange主機，如無宣告表頭表委，則會造成亂碼
        string tf_head = "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'>";
        tf_head += "<html xmlns='http://www.w3.org/1999/xhtml'><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=big5\"/>";
        tf_head += "<title>webmail</title>";
        tf_head += "</head>";
        tf_head += "<body>";
        string tf_tail = "</body></html>";//表尾
        string body = tf_head + ReqVal.TryGet("tf_content", "").ToBig5() + tf_tail;

        //mail
        string strFrom = ReqVal.TryGet("from_email", "").Trim();
        List<string> strTo = ReqVal.TryGet("att_email", "").Split(';').ToList();
        List<string> strCC = ReqVal.TryGet("cc_email", "").Split(';').ToList();
        List<string> strBCC = ReqVal.TryGet("bcc_email", "").Split(';').ToList();

        //附件
        List<string[]> arrAttach = new List<string[]>();
        for (int i = 1; i <= Convert.ToInt32(ReqVal.TryGet("pdfcnt", "0")); i++) {
            if (ReqVal.TryGet("pdf_send" + i, "") == "Y") {
                string pdfpath = ReqVal.TryGet("pdfpath" + i, "");
                //Response.Write("**1**"+pdfpath+"<HR>");
                pdfpath = pdfpath.Replace("/", @"\");//統一斜線方向
                //Response.Write("**2**"+pdfpath+"<HR>");
                pdfpath = pdfpath.Replace(@"\nopt\", @"\");//去掉project name
                //Response.Write("**3**"+pdfpath+"<HR>");
                pdfpath = pdfpath.Replace(@"\btbrt\", @"\");//去掉project name
                //Response.Write("**4**"+pdfpath+"<HR>");
                pdfpath = pdfpath.Replace(ReqVal.TryGet("source_server", "")+@"\", ReqVal.TryGet("brupload_server" + i, "") + @"\");//如果是apserver則轉成對應uploadserver
                //Response.Write("**5**"+pdfpath+"<HR>");
                pdfpath = @"\\" + pdfpath;
                //Response.Write("**6**"+pdfpath+"<HR>");

                arrAttach.Add(new string[] { pdfpath, ReqVal.TryGet("pdfname" + i, "") });
            }
        }
        
        Sys.DoSendMail(Subject, body, strFrom, strTo, strCC, strBCC, arrAttach);
    }
</script>

<script language="javascript" type="text/javascript">
    <%Response.Write(strOut.ToString());%>
</script>
