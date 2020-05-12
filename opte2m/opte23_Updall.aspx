<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.IO"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "交辦北京聖島分案通知寄出確認作業‧-入檔";//功能名稱
    protected string HTProgPrefix = "opte23";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string SQL = "";
    protected string msg = "";

    string submitTask = "";
    int count = 0;

    protected Dictionary<string, string> ReqVal = new Dictionary<string, string>();
    protected StringBuilder strOut = new StringBuilder();

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        submitTask = (Request["submittask"] ?? "").Trim();
        count = Convert.ToInt32("0" + Request["count"]);

        ReqVal = Request.Form.ToDictionary();

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
                if (ReqVal.TryGet("task", "") == "send") {
                    for (int i = 1; i <= count; i++) {
                        if (ReqVal.TryGet("hchk_flag_" + i, "") == "Y") {
                            update_br_opte(conn,i);
                        }
                    }

                    msg="寄出確認作業完成!!";
                } else if (ReqVal.TryGet("task", "") == "update") {
                    for (int i = 1; i <= count; i++) {
                        if (ReqVal.TryGet("hchk_flag_" + i, "") == "Y") {
                            if (ReqVal.TryGet("pr_scode_" + i, "") != "") {
                                update_br_opte_pr(conn, i);
                            }
                            if (ReqVal.TryGet("your_no_" + i, "") != "") {
                                update_opte_detail(conn, i);
                            }
                        }
                    }
                    msg="補入承辦人員或對方號完成!!";
                }

                conn.Commit();
                //conn.RollBack();
            }
            catch (Exception ex) {
                conn.RollBack();
                Sys.errorLog(ex, conn.exeSQL, prgid);

                if (ReqVal.TryGet("task", "") == "send") {
                    msg = "補入承辦人員或對方號失敗!!";
                } else if (ReqVal.TryGet("task", "") == "send") {
                    msg = "補入承辦人員或對方號失敗!!";
                }

                throw new Exception(msg, ex);
            }
            finally {
                conn.Dispose();
            }

            strOut.AppendLine("alert('" + msg + "');");
            if (Request["chkTest"] != "TEST") {
                strOut.AppendLine("window.parent.parent.Etop.goSearch();");
            }

            this.DataBind();
        }
    }

    //修改分案主檔之寄出確認狀態
    private void update_br_opte(DBHelper conn, int pno) {
        //入cust_step_log
        Funcs.insert_log_table(conn, "U", prgid, "br_opte", "opt_sqlno", Request["opt_sqlno" + pno] ?? "");

        //更新分案主檔寄出日期及寄出狀態
        SQL = "update br_opte set opt_no = opt_no";
        SQL += ",email_date='" + Request["mail_date"] + "'";
        SQL += ",email_scode='" + Session["scode"] + "'";
        SQL += ",emconf_date=getdate()";
        SQL += ",tran_date=getdate()";
        SQL += ",tran_scode='" + Session["scode"] + "'";
        SQL += " where opt_sqlno = '" + Request["opt_sqlno" + pno] + "'";
        conn.ExecuteNonQuery(SQL);
    }

    //修改分案主檔之承辦人員
    private void update_br_opte_pr(DBHelper conn, int pno) {
        //入cust_step_log
        Funcs.insert_log_table(conn, "U", prgid, "br_opte", "opt_sqlno", Request["opt_sqlno" + pno] ?? "");

        //更新分案主檔承辦人員
        SQL = "update br_opte set opt_no = opt_no";
        SQL += ",pr_branch='" + Request["pr_branch_" + pno] + "'";
        SQL += ",pr_scode='" + Request["pr_scode_" + pno] + "'";
        SQL += ",email_scode='" + Session["scode"] + "'";
        SQL += ",tran_date=getdate()";
        SQL += ",tran_scode='" + Session["scode"] + "'";
        SQL += " where opt_sqlno = '" + Request["opt_sqlno" + pno] + "'";
        conn.ExecuteNonQuery(SQL);
    }

    //修改案件主檔之對方號
    private void update_opte_detail(DBHelper conn, int pno) {
        //入cust_step_log
        Funcs.insert_log_table(conn, "U", prgid, "opte_detail", "opt_sqlno", Request["opt_sqlno" + pno] ?? "");

        //更新案件主檔對方號
        SQL = "update opte_detail set opt_sqlno = opt_sqlno";
        SQL += ",your_no='" + Request["your_no_" + pno] + "'";
        SQL += ",tr_date=getdate()";
        SQL += ",where='" + Session["scode"] + "'";
        SQL += " where opt_sqlno = '" + Request["opt_sqlno" + pno] + "'";
        conn.ExecuteNonQuery(SQL);
    }
</script>

<script language="javascript" type="text/javascript">
    <%Response.Write(strOut.ToString());%>
</script>
