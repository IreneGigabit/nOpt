<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "區所抽件確認作業‧-入檔";//功能名稱
    protected string HTProgPrefix = "opt51";//程式檔名前綴
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

        ReqVal = Util.GetRequestParam(Context,Request["chkTest"] == "TEST");

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            if (submitTask == "U") {//發文確認
                doConfirm();
            }

            this.DataBind();
        }
    }
    private void doConfirm() {
        for (int i = 1; i <= count; i++) {
            DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
            DBHelper connB = new DBHelper(Conn.OptB(ReqVal.TryGet("Branch" + i, ""))).Debug(Request["chkTest"] == "TEST");
            try {
                if (ReqVal.TryGet("opt_sqlno" + i, "") != "") {
                    SQL = "Update br_opt Set mark='D'";
                    SQL += " where opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "'";
                    conn.ExecuteNonQuery(SQL);

                    SQL = "Update cancel_opt Set tran_status='DZ'";
                    SQL += ",conf_date=getdate()";
                    SQL += ",conf_scode='" + Session["scode"] + "'";
                    SQL += " where opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "'";
                    SQL += " and sqlno='" + ReqVal.TryGet("cancel_sqlno" + i, "") + "'";
                    conn.ExecuteNonQuery(SQL);

                    //抓前一todo的流水號
                    string pre_sqlno = "", todo_scode = "";
                    SQL = "Select max(sqlno) as maxsqlno from todo_opt ";
                    SQL += "where syscode='" + ReqVal.TryGet("Branch" + i, "") + "TBRT' ";
                    SQL += "and apcode='brt34' and opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "' ";
                    SQL += "and dowhat='DD' ";
                    using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                        if (dr.Read()) {
                            pre_sqlno = dr.SafeRead("maxsqlno", "");
                        }
                    }

                    SQL = "update todo_opt set approve_scode='" + Session["scode"] + "'";
                    SQL += ",resp_date=getdate()";
                    SQL += ",job_status='YY'";
                    SQL += " where apcode='brt34' and opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "'";
                    SQL += " and dowhat='DD' and syscode='" + ReqVal.TryGet("Branch" + i, "") + "TBRT' ";
                    SQL += " and sqlno='" + pre_sqlno + "'";
                    conn.ExecuteNonQuery(SQL);

                    //[區所]
                    //抓區所承辦
                    SQL = "select pr_scode from step_dmt ";
                    SQL += " where opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "'";
                    object objResult = connB.ExecuteScalar(SQL);
                    string pr_scode = (objResult != DBNull.Value && objResult != null) ? objResult.ToString().Trim().ToLower() : "";

                    SQL = "update step_dmt set opt_stat='D' where opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "'";
                    connB.ExecuteNonQuery(SQL);

                    //通知區所抽件完成
                    CreateMail(conn, pr_scode, ReqVal.TryGet("case_no" + i, ""), ReqVal.TryGet("branch" + i, ""));

                    //發完mail才能更新註記,否則找不到
                    SQL = "Update case_opt Set mark='D'";
                    SQL += " where opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "'";
                    conn.ExecuteNonQuery(SQL);

                    connB.Commit();
                    conn.Commit();
                    //connB.RollBack();
                    //conn.RollBack();
                }

                msg = "爭救案抽件成功";
            }
            catch (Exception ex) {
                connB.RollBack();
                conn.RollBack();
                Sys.errorLog(ex, conn.exeSQL, prgid);
                msg = "爭救案抽件申請失敗";

                throw new Exception(msg, ex);
            }
            finally {
                connB.Dispose();
                conn.Dispose();
            }
        }
        strOut.AppendLine("alert('" + msg + "');");
        if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.parent.Etop.goSearch();");
    }


    private void CreateMail(DBHelper conn, string pr_scode, string case_no, string branch) {
        string fseq = "", in_scode = "", in_scode_name = "", cust_area = "", cust_seq = "";
        string ap_cname = "", appl_name = "", arcase_name = "", last_date = "";
        SQL = "select Bseq,Bseq1,branch,in_scode,scode_name,cust_area,cust_seq ";
        SQL += ",appl_name,arcase_name,Last_date,ap_cname ";
        SQL += "from vbr_opt where case_no='" + case_no + "' and branch='" + branch + "' ";
        using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
            if (dr.Read()) {
                fseq = Funcs.formatSeq(dr.SafeRead("Bseq", ""), dr.SafeRead("Bseq1", ""), "", dr.SafeRead("Branch", ""), Sys.GetSession("dept"));
                in_scode = dr.SafeRead("in_scode", "");
                in_scode_name = dr.SafeRead("scode_name", "");
                cust_area = dr.SafeRead("cust_area", "");
                cust_seq = dr.SafeRead("cust_seq", "");
                ap_cname = dr.SafeRead("ap_cname", "");
                appl_name = dr.SafeRead("appl_name", "");
                arcase_name = dr.SafeRead("arcase_name", "");
                last_date = dr.SafeRead("last_date", "");
            }
        }

        string Subject = "專案室爭救案件抽件完成通知";
        string strFrom = Session["scode"] + "@saint-island.com.tw";
        List<string> strTo = new List<string>();
        List<string> strCC = new List<string>();
        List<string> strBCC = new List<string>();
        switch (Sys.Host) {
            case "web08":
                strTo.Add(Session["scode"] + "@saint-island.com.tw");
                strCC.Add(Session["scode"] + "@saint-island.com.tw");
                Subject = "(web08)" + Subject;
                break;
            case "web10":
                strTo.Add(Session["scode"] + "@saint-island.com.tw");
                strCC.Add(Session["scode"] + "@saint-island.com.tw");
                Subject = "(web10)" + Subject;
                break;
            default:
                strTo.Add(pr_scode + "@saint-island.com.tw");
                strCC.Add(in_scode + "@saint-island.com.tw");
                strCC.Add(Session["scode"] + "@saint-island.com.tw");
                break;
        }

        string body = "【區所案件編號】 : <B>" + fseq + "</B><br>" +
            "【營洽】 : <B>" + in_scode + "-" + in_scode_name + "</B><br>" +
            "【申請人】 : <B>" + ap_cname + "</B><br>" +
            "【案件名稱】 : <B>" + appl_name + "</B><br>" +
            "【案性】 : <B>" + arcase_name + "</B><Br><Br><p>";

        Sys.DoSendMail(Subject, body, strFrom, strTo, strCC, strBCC);
    }

</script>

<script language="javascript" type="text/javascript">
    <%Response.Write(strOut.ToString());%>
</script>
