<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Net.Mail"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "出口爭救案收件確認-入檔";//功能名稱
    protected string HTProgPrefix = "opte11";//程式檔名前綴
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
    protected string todo_sqlno = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        strConnB = Conn.OptB(Request["branch"]);

        case_no = Request["case_no"];
        branch = Request["branch"];
        opt_sqlno = Request["opt_sqlno"];
        submitTask = Request["submitTask"];
        todo_sqlno = Request["todo_sqlno"];

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
            SQL = "select max(substring(opt_no,2,9))+1 from br_opte where substring(opt_no,2,4)=(year(getdate()))";
            object objResult = conn.ExecuteScalar(SQL);
            string opt_no = (objResult == DBNull.Value || objResult == null ? ("E"+DateTime.Now.Year + "000001") : "E"+objResult.ToString());

            //入br_opte_log
            Funcs.insert_log_table(conn, "U", prgid, "br_opte", new Dictionary<string, string>() { { "opt_sqlno", opt_sqlno } });
            
            SQL = "update br_opte set confirm_scode='" + Session["scode"] + "'";
            SQL += ",confirm_date='" + DateTime.Now.ToString("yyyy/MM/dd") + "'";
            SQL += ",stat_code='RR'";
            SQL += ",opt_no='" + opt_no + "'";
            SQL += " where opt_sqlno='" + opt_sqlno + "'";
            conn.ExecuteNonQuery(SQL);
            
            SQL="update todo_opte set approve_scode='"+ Session["scode"] + "'";
            SQL+= ",resp_date=getdate()";
            SQL+= ",job_status='YY'";
            SQL+= ",opt_no='" + opt_no +  "'";
            SQL+= " where sqlno='" + todo_sqlno + "'";
            SQL+= " and dowhat='RE' and syscode='" + branch + "TBRT'";
            SQL+= " and job_status='NN'";
            conn.ExecuteNonQuery(SQL);

            //入流程控制檔
            SQL = " insert into todo_opte(pre_sqlno,syscode,apcode,from_flag,opt_no,opt_sqlno ";
            SQL += ",branch,case_no,in_scode,in_date,dowhat,job_status) values (";
            SQL+="'" + todo_sqlno +"','"+ Session["Syscode"] +"','"+ prgid +"','pr','" + opt_no + "',"+ opt_sqlno +",'"+ branch +"','"+ case_no + "'";
            SQL+=",'"+ Session["scode"] +"',getdate(),'BR','NN')" ;
            conn.ExecuteNonQuery(SQL);
            
            //conn.Commit();
            conn.RollBack();
            msg = "收件成功";
        }
        catch (Exception ex) {
            conn.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);
            msg = "收件失敗";
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
            //入br_opte_log
            Funcs.insert_log_table(conn, "U", prgid, "br_opte", new Dictionary<string, string>() { { "opt_sqlno", opt_sqlno } });

            SQL = "update br_opte set mark='B'";
            SQL += ",tran_date=getdate(),tran_scode='" + Session["scode"] + "'";
            SQL += " where opt_sqlno='" + opt_sqlno + "'";
            conn.ExecuteNonQuery(SQL);

            //入step_ext_log
            Dictionary<string, string> cond = new Dictionary<string, string>(){
                { "branch", branch },{ "seq", Request["tfzb_seq"] },{ "seq1", Request["tfzb_seq1"] },{ "opt_sqlno", opt_sqlno },
            };
            Funcs.insert_log_table(connB, "U", prgid, "step_ext", cond);

            SQL = "update step_ext set opt_sqlno=null";
            SQL += ",opt_branch=null";
            SQL += ",opt_stat='X'";//2018/4/10修改，因退件至承辦交辦國外所DP_TS，且為能讓區所可維護再交辦專案室(因時間未到先退回)，所以修改為X不需交辦專案室
            SQL += " where branch='" + branch + "' ";
            SQL += "and seq=" + Request["tfzb_seq"] + " ";
            SQL += "and seq1='" + Request["tfzb_seq1"] + "' ";
            SQL += "and opt_sqlno=" + opt_sqlno;
            connB.ExecuteNonQuery(SQL);

            //寫回承辦交辦發文狀態todo_ext
            SQL = "insert into todo_ext(pre_sqlno,syscode,apcode,from_flag,branch,seq,seq1,step_grade,in_team,case_in_scode,in_no,case_no,in_scode,in_date";
            SQL += ",dowhat,job_scode,job_team,job_status) ";
            SQL += "select sqlno,syscode,'" + prgid + "','CGRS','" + branch + "'," + Request["tfzb_seq"] + ",'" + Request["tfzb_seq1"] + "'";
            SQL += ",step_grade,in_team,case_in_scode,in_no,'" + case_no + "','" + Session["scode"] + "'";
            SQL += ",getdate(),'DP_TS',job_scode,job_team,'NN'";
            SQL += " from todo_ext where att_no=" + opt_sqlno + " and case_no='" + case_no + "' and dowhat='DP_BS' ";
            connB.ExecuteNonQuery(SQL);

            SQL = "update todo_opte set approve_scode='" + Session["scode"] + "'";
            SQL += ",approve_desc='" + Request["Preject_reason"].ToBig5() + "' ";
            SQL += ",resp_date=getdate()";
            SQL += ",job_status='XX'";
            SQL += " where sqlno=" + todo_sqlno;
            SQL += " and dowhat='RE' and syscode='" + branch + "TBRT'";
            SQL += " and job_status='NN'";
            conn.ExecuteNonQuery(SQL);

            CreateMail(conn,connB, todo_sqlno);

            //conn.Commit();
            //connB.Commit();
            conn.RollBack();
            connB.RollBack();
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

    private void CreateMail(DBHelper conn, DBHelper connB, string todo_sqlno) {
        string fseq = "", in_scode = "", in_scode_name = "", cust_area = "", cust_seq = "";
        string cust_name = "", appl_name = "", arcase_name = "", last_date = "";
        string todo_scode = "";
        SQL = "select Bseq,Bseq1,branch,in_scode,scode_name,cust_area,cust_seq ";
        SQL += ",appl_name,arcase_name,Last_date,country ";
        SQL += "from vbr_opte where case_no='" + case_no + "' and branch='" + branch + "'";

        using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
            if (dr.Read()) {
                fseq = Funcs.formatSeq(dr.SafeRead("Bseq", ""), dr.SafeRead("Bseq1", ""), dr.SafeRead("country", ""), dr.SafeRead("Branch", ""), Sys.GetSession("dept") + "E");
                in_scode = dr.SafeRead("in_scode", "");
                in_scode_name = dr.SafeRead("scode_name", "");
                cust_area = dr.SafeRead("cust_area", "");
                cust_seq = dr.SafeRead("cust_seq", "");
                appl_name = dr.SafeRead("appl_name", "");
                arcase_name = dr.SafeRead("arcase_name", "");
                last_date = dr.SafeRead("last_date", "");
            }
        }

        SQL = "Select RTRIM(ISNULL(ap_cname1, '')) + RTRIM(ISNULL(ap_cname2, ''))  as cust_name from apcust as c ";
        SQL += " where c.cust_area='" + cust_area + "' and c.cust_seq='" + cust_seq + "'";
        object objResult = connB.ExecuteScalar(SQL);
        cust_name = (objResult == DBNull.Value || objResult == null) ? "" : objResult.ToString();

        SQL = "Select in_scode from todo_opte where sqlno='" + todo_sqlno + "' and dowhat='RE' and syscode='" + branch + "TBRT'";
        object objResult0 = conn.ExecuteScalar(SQL);
        todo_scode = (objResult0 == DBNull.Value || objResult0 == null) ? "" : objResult0.ToString();

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

        string body = "【區所案件編號】 : <B>" + fseq + "</B><br>" +
            "【營洽】 : <B>" + in_scode + "-" + in_scode_name + "</B><br>" +
            "【客戶】 : <B>" + cust_name + "</B><br>" +
            "【案件名稱】 : <B>" + appl_name + "</B><br>" +
            "【案性】 : <B>" + arcase_name + "</B><br>" +
            "【退件理由】 : <br>　　" + Request["Preject_reason"] + "<Br><Br><p>" +
            "◎請至承辦作業－＞國外所出口案交辦作業，重新交辦。 ";

        Sys.DoSendMail(Subject, body, strFrom, strTo, strCC, strBCC);
    }
</script>

<script language="javascript" type="text/javascript">
    alert("<%#msg%>");
    if ("<%#Request["chkTest"]%>" != "TEST") {
        window.parent.Etop.goSearch();
    }
</script>
