<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "區所交辦收件確認-入檔";//功能名稱
    protected string HTProgPrefix = "opt11";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string SQL = "";
    protected string strConnB = "";
    protected string msg = "";

    protected string case_no = "";
    protected string branch = "";
    protected string opt_sqlno = "";
    protected string submitTask = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        strConnB = Conn.OptB(Request["branch"]);

        case_no = Request["case_no"];
        branch = Request["branch"];
        opt_sqlno = Request["opt_sqlno"];
        submitTask = Request["submitTask"];

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            if (submitTask == "U") {
                doConfirm();//收件確認
            } else if (submitTask == "B") {//退回區所
                doReturn();
            }

            this.DataBind();
        }
    }

    private void doConfirm() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        try {
            //產生案件編號
            SQL="select max(opt_no)+1 from br_opt where left(opt_no,4)=(year(getdate()))";
            object objResult = conn.ExecuteScalar(SQL);
            string opt_no = (objResult == DBNull.Value || objResult == null ? (DateTime.Now.Year + "000001") : objResult.ToString());

            //入br_opt_log
            //Funcs.insert_log_table(conn, "U", prgid, "br_opt", "opt_sqlno", opt_sqlno );

            //抓前一todo的流水號
            string pre_sqlno = "";
            SQL = "Select max(sqlno) as maxsqlno,in_scode from todo_opt ";
            SQL += "where syscode='" + branch + "TBRT' ";
            SQL += "and apcode='brt18' and opt_sqlno='" + opt_sqlno + "' ";
            SQL += "and dowhat='RE' group by in_scode ";
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    pre_sqlno = dr.SafeRead("maxsqlno", "");
                }
            }

            SQL = "update br_opt set confirm_scode='" + Session["scode"] + "'";
            SQL += ",confirm_date='" + DateTime.Now.ToString("yyyy/M/dd") + "'";
            SQL += ",stat_code='RR'";
            SQL += ",opt_no='" + opt_no + "'";
            SQL += ",Fees=" + (Request["nfy_fees"] ?? "0") + "";
            SQL += " where opt_sqlno='" + opt_sqlno + "'";
            conn.ExecuteNonQuery(SQL);

            SQL = "update todo_opt set approve_scode='" + Session["scode"] + "'";
            SQL += ",resp_date=getdate()";
            SQL += ",job_status='YY'";
            SQL += " where apcode='brt18' and opt_sqlno='" + opt_sqlno + "'";
            SQL += " and dowhat='RE' and syscode='" + branch + "TBRT'";
            SQL += " and sqlno=" + pre_sqlno;
            conn.ExecuteNonQuery(SQL);

            //入流程控制檔
            SQL = "insert into todo_opt(pre_sqlno,syscode,apcode,opt_sqlno,branch,case_no";
            SQL += ",in_scode,in_date,dowhat,job_status) values (";
            SQL += "'" + pre_sqlno + "','" + Session["Syscode"] + "','" + prgid + "'," + opt_sqlno + ",'" + branch + "','" + case_no + "'";
            SQL += ",'" + Session["scode"] + "',getdate(),'BR','NN')";
            conn.ExecuteNonQuery(SQL);

            conn.Commit();
            //conn.RollBack();
            msg = "收件成功";
        }
        catch (Exception ex) {
            conn.RollBack();
            string sqlno = Sys.errorLog(ex, conn.exeSQL, prgid);
            msg = "收件失敗\\n(" + sqlno + ")" + ex.Message;
            throw new Exception(msg, ex);
        }
        finally {
            conn.Dispose();
        }
    }

    private void doReturn() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        DBHelper connB = new DBHelper(Conn.OptB(branch)).Debug(Request["chkTest"] == "TEST");
        try {
            //入br_opt_log
            //Funcs.insert_log_table(conn, "U", prgid, "br_opt", "opt_sqlno", opt_sqlno);

            SQL = "update br_opt set mark='B' ";
            SQL += " where opt_sqlno='" + opt_sqlno + "' ";
            conn.ExecuteNonQuery(SQL);

            SQL = "update step_dmt set opt_sqlno=null ";
            SQL += ",opt_branch=null ";
            SQL += ",opt_stat='N' ";
            SQL += " where opt_sqlno='" + opt_sqlno + "' ";
            SQL += " and case_no='" + case_no + "' ";
            connB.ExecuteNonQuery(SQL);

            //2010/8/4因承辦交辦發文增加todo_dmt
            SQL = "insert into todo_dmt(pre_sqlno,syscode,apcode,from_flag,branch,seq,seq1,step_grade,case_in_scode,in_no,case_no,in_scode,in_date";
            SQL += ",dowhat,job_scode,job_team,job_status) ";
            SQL += "select sqlno,syscode,'" + prgid + "','CGRS','" + branch + "','" + Request["bseq"] + "','" + Request["bseq1"] + "' ";
            SQL += ",step_grade,case_in_scode,in_no,'" + case_no + "','" + Session["scode"] + "' ";
            SQL += ",getdate(),'DP_GS',job_scode,job_team,'NN' ";
            SQL += "from todo_dmt where temp_rs_sqlno='" + opt_sqlno + "' and case_no='" + case_no + "' and dowhat='DP_GS' ";
            connB.ExecuteNonQuery(SQL);

            //抓前一todo的流水號
            string pre_sqlno = "",todo_scode="";
            SQL = "Select max(sqlno) as maxsqlno,in_scode from todo_opt ";
            SQL += "where syscode='" + branch + "TBRT' ";
            SQL += "and apcode='brt18' and opt_sqlno='" + opt_sqlno + "' ";
            SQL += "and dowhat='RE' group by in_scode ";
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    pre_sqlno = dr.SafeRead("maxsqlno", "");
                    todo_scode = dr.SafeRead("in_scode", "");
                }
            }

            SQL = "update todo_opt set approve_scode='" + Session["scode"] + "' ";
            SQL += ",approve_desc='" + Request["Preject_reason"].ToBig5() + "' ";
            SQL += ",resp_date=getdate() ";
            SQL += ",job_status='XX' ";
            SQL += " where apcode='brt18' and opt_sqlno='" + opt_sqlno + "' ";
            SQL += " and dowhat='RE' and syscode='" + branch + "TBRT' ";
            SQL += " and sqlno=" + pre_sqlno;
            conn.ExecuteNonQuery(SQL);

            CreateMail(conn,pre_sqlno,todo_scode);

            conn.Commit();
            connB.Commit();
            //conn.RollBack();
            //connB.RollBack();
            msg = "退回成功";
        }
        catch (Exception ex) {
            conn.RollBack();
            connB.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);
            msg = "退回失敗";
            throw new Exception(msg, ex);
        }
        finally {
            conn.Dispose();
            connB.Dispose();
        }
    }

    private void CreateMail(DBHelper conn,string pre_sqlno,string todo_scode){
        string fseq="",in_scode="",in_scode_name="",cust_area="",cust_seq="";
        string ap_cname="",appl_name="",arcase_name="",last_date="";
        SQL = "select Bseq,Bseq1,branch,in_scode,scode_name,cust_area,cust_seq ";
        SQL += ",appl_name,arcase_name,Last_date,ap_cname ";
        SQL+="from vbr_opt where case_no='" + case_no + "' and branch='" + branch + "'";
        using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
            if (dr.Read()) {
                fseq=Funcs.formatSeq(dr.SafeRead("Bseq", ""), dr.SafeRead("Bseq1", ""), "", dr.SafeRead("Branch", ""), Sys.GetSession("dept"));
                in_scode=dr.SafeRead("in_scode", "");
                in_scode_name=dr.SafeRead("scode_name", "");
                cust_area=dr.SafeRead("cust_area", "");
                cust_seq=dr.SafeRead("cust_seq", "");
                ap_cname=dr.SafeRead("ap_cname", "");
                appl_name=dr.SafeRead("appl_name", "");
                arcase_name =dr.SafeRead("arcase_name", "");
                last_date=dr.SafeRead("last_date", "");
            }
        }

        string Subject = "專案室爭救案件退件通知";
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
                strTo.Add(todo_scode + "@saint-island.com.tw");
                strCC.Add(in_scode + "@saint-island.com.tw");
                break;
        }

        string body="【區所案件編號】 : <B>" + fseq + "</B><br>"+
            "【營洽】 : <B>" + in_scode+"-"+in_scode_name+ "</B><br>"+
            "【申請人】 : <B>"+ ap_cname + "</B><br>"+
            "【案件名稱】 : <B>" + appl_name + "</B><br>"+
            "【案性】 : <B>" + arcase_name  + "</B><br>"+
            "【退件理由】 : <br>　　"+Request["Preject_reason"]+"<Br><Br><p>"+
            "◎請至承辦作業－＞國內案承辦交辦發文作業，重新交辦。 ";

        Sys.DoSendMail(Subject, body, strFrom, strTo, strCC, strBCC);
    }
</script>

<script language="javascript" type="text/javascript">
    alert("<%#msg%>");
    if ("<%#Request["chkTest"]%>" != "TEST") {
        window.parent.parent.Etop.goSearch();
    }
</script>
