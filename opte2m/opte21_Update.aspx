<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "出口爭救案分案作業確認‧-入檔";//功能名稱
    protected string HTProgPrefix = "opte21";//程式檔名前綴
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
                doConfirm();//分案確認
            } else if (submitTask == "ADD") {//新增分案主檔
                doAdd();
            } else if (submitTask == "DEL") {//刪除分案主檔
                doDel();
            }
            
            this.DataBind();
        }
    }

    private void doConfirm() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        try {
            //入br_opte_log
            Funcs.insert_log_table(conn, "U", prgid, "br_opte",  "opt_sqlno", opt_sqlno);

            SQL = "update br_opte set in_scode='" + Session["scode"] + "'";
            SQL += ",in_date='" + DateTime.Now.ToString("yyyy/M/d") + "'";
            //2014/3/26修改，若自行新增分案可修改法定期限
            if (case_no == "")
                SQL += ",last_date='" + Request["dfy_last_date"] + "'";
            SQL += ",ctrl_date='" + Request["ctrl_date"] + "'";
            SQL += ",pr_branch='" + Request["pr_branch"] + "'";
            SQL += ",pr_scode='" + Request["pr_scode"] + "'";
            SQL += ",br_remark='" + Request["Br_remark"].ToBig5().Trim() + "'";
            SQL += ",stat_code='NN'";
            SQL += ",pr_rs_type='" + Request["pr_rs_type"] + "'";
            SQL += ",pr_rs_class='" + Request["pr_rs_class"] + "'";
            SQL += ",pr_rs_code='" + Request["pr_rs_code"] + "'";
            SQL += " where opt_sqlno='" + opt_sqlno + "'";
            conn.ExecuteNonQuery(SQL);

            SQL = "update todo_opte set approve_scode='" + Session["scode"] + "'";
            SQL += ",resp_date=getdate()";
            SQL += ",job_status='YY'";
            SQL += " where sqlno=" + todo_sqlno;
            SQL += " and dowhat='BR' and syscode='" + Session["Syscode"] + "'";
            SQL += " and job_status='NN'";
            conn.ExecuteNonQuery(SQL);

            //入流程控制檔
            SQL = " insert into todo_opte(pre_sqlno,syscode,apcode,from_flag,opt_no,opt_sqlno,branch,case_no,in_scode,in_date";
            SQL += ",dowhat,job_status) values (";
            SQL += "'" + todo_sqlno + "','" + Session["Syscode"] + "','" + prgid + "','pr','" + Request["opt_no"] + "'," + opt_sqlno + ",'" + branch + "','" + case_no + "'";
            SQL += ",'" + Session["scode"] + "',getdate(),'PR','NN')";
            conn.ExecuteNonQuery(SQL);

            conn.Commit();
            //conn.RollBack();
            msg = "分案成功";
        }
        catch (Exception ex) {
            conn.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);
            msg = "分案失敗";
            throw new Exception(msg, ex);
        }
        finally {
            conn.Dispose();
        }
    }

    private void doAdd() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        DBHelper connB = new DBHelper(Conn.OptB(branch)).Debug(Request["chkTest"] == "TEST");
        try {
            //產生案件編號
            SQL = "select max(substring(opt_no,2,9))+1 from br_opte where substring(opt_no,2,4)=(year(getdate()))";
            object objResult = conn.ExecuteScalar(SQL);
            string opt_no = (objResult == DBNull.Value || objResult == null ? ("E" + DateTime.Now.Year + "00001") : "E" + objResult.ToString());

            //新增分案主檔
            SQL = "insert into br_opte(opt_no,br_source,branch,Bseq,Bseq1,Bcase_date,Last_date";
            SQL += ",in_scode,in_date,ctrl_date,pr_branch,pr_scode,br_remark,stat_code,mark,pr_rs_type,pr_rs_class,pr_rs_code,confirm_date) values (";
            SQL += "'" + opt_no + "','opte','" + Request["branch"] + "'," + Request["Bseq"] + ",'" + Request["Bseq1"] + "'";
            SQL += ",'" + DateTime.Now.ToString("yyyy/M/d") + "'," + Util.dbnull(Request["dfy_last_date"]) + ",'" + Session["scode"] + "','" + DateTime.Now.ToString("yyyy/M/d") + "'";
            SQL += "," + Util.dbnull(Request["ctrl_date"]) + ",'" + Request["pr_branch"] + "','" + Request["pr_scode"] + "'";
            SQL += ",'" + Request["br_remark"].ToBig5().Trim() + "','NN','N','" + Request["pr_rs_type"] + "'";
            SQL += ",'" + Request["pr_rs_class"] + "','" + Request["pr_rs_code"] + "','" + DateTime.Now.ToString("yyyy/M/d") + "')";
            conn.ExecuteNonQuery(SQL);

            //抓insert後的流水號
            SQL = "SELECT SCOPE_IDENTITY() AS Current_Identity";
            object objResult1 = conn.ExecuteScalar(SQL);
            opt_sqlno = objResult1.ToString();

            //新增接洽記錄檔
            SQL = " insert into case_opte(opt_sqlno,branch,in_scode,seq,seq1,cust_area,cust_seq,att_sql,arcase_type,arcase_class,arcase";
            SQL += ",service,fees,tot_num,remark,mark";
            SQL += ") values ('" + opt_sqlno + "','" + Request["branch"] + "','" + Request["in_scode"] + "','" + Request["Bseq"] + "','" + Request["Bseq1"] + "'";
            SQL += ",'" + Request["cust_area"] + "','" + Request["cust_seq"] + "','" + Request["att_sql"] + "','" + Request["arcase_type"] + "'";
            SQL += ",'" + Request["arcase_class"] + "','" + Request["arcase"] + "',0,0,1,'" + Request["remark"].ToBig5() + "','N')";
            conn.ExecuteNonQuery(SQL);

            //新增接洽記錄暫存檔
            SQL = " insert into opte_detail(opt_sqlno,branch,seq,seq1,country,class,class_count,in_date,apply_date,apply_no,issue_date,issue_no";
            SQL += ",appl_name,agt_no,agt_no1,renewal_date,renewal_no,renewal_agt_no,renewal_agt_no1,ext_term1,ext_term2,ext_seq,ext_seq1,your_no";
            SQL += ") values ('" + opt_sqlno + "','" + Request["branch"] + "','" + Request["Bseq"] + "','" + Request["Bseq1"] + "','" + Request["country"] + "'";
            SQL += ",'" + Request["class"] + "'," + Request["class_count"] + ",'" + Request["in_date"] + "'";
            SQL += "," + Util.dbnull(Request["apply_date"]) + ",'" + Request["apply_no"] + "'";
            SQL += "," + Util.dbnull(Request["issue_date"]) + ",'" + Request["issue_no"] + "'," + Util.dbnull(Request["appl_name"].ToBig5()) + ",'" + Request["agt_no"] + "'";
            SQL += ",'" + Request["agt_no1"] + "'," + Util.dbnull(Request["renewal_date"]) + ",'" + Request["renewal_no"] + "'";
            SQL += ",'" + Request["renewal_agt_no"] + "','" + Request["renewal_agt_no1"] + "'";
            SQL += "," + Util.dbnull(Request["ext_term1"]) + "," + Util.dbnull(Request["ext_term2"]) + "," + Util.dbnull(Request["ext_seq"]) + "," + Util.dbnull(Request["ext_seq1"]) + ",'" + Request["your_no"] + "')";
            conn.ExecuteNonQuery(SQL);

            //新增接洽案件申請人檔
            for (int apnum = 1; apnum <= Convert.ToInt32(Request["br_apnum"]); apnum++) {
                SQL = " insert into caseopte_ap(opt_sqlno,branch,apsqlno,apcust_no,ap_cname,ap_cname1,ap_cname2,ap_ename,ap_ename1,ap_ename2,tran_date,tran_scode) values ";
                SQL += "('" + opt_sqlno + "','" + Request["branch"] + "','" + Request["apsqlno_" + apnum] + "','" + Request["apcust_no_" + apnum] + "'";
                SQL += ",'" + Request["ap_cname_" + apnum].ToBig5() + "','" + Request["ap_cname1_" + apnum].ToBig5() + "','" + Request["ap_cname2_" + apnum].ToBig5() + "'";
                SQL += ",'" + Request["ap_ename_" + apnum].ToBig5() + "','" + Request["ap_ename1_" + apnum].ToBig5() + "'";
                SQL += ",'" + Request["ap_ename2_" + apnum].ToBig5() + "',getdate(),'" + Session["scode"] + "')";
                conn.ExecuteNonQuery(SQL);
            }

            //入流程控制檔
            SQL = " insert into todo_opte(syscode,apcode,from_flag,opt_no,opt_sqlno,Branch,in_scode,in_date";
            SQL += ",dowhat,job_status) values (";
            SQL += "'" + Session["syscode"] + "','" + prgid + "','pr_opt','" + opt_no + "'," + opt_sqlno + ",'" + branch + "'";
            SQL += ",'" + Session["scode"] + "',getdate(),'PR','NN')";
            conn.ExecuteNonQuery(SQL);

            conn.Commit();
            connB.Commit();
            //conn.RollBack();
            //connB.RollBack();
            msg = "新增分案成功";
        }
        catch (Exception ex) {
            conn.RollBack();
            connB.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);
            msg = "新增分案失敗";
            throw new Exception(msg, ex);
        }
        finally {
            conn.Dispose();
            connB.Dispose();
        }
    }

    private void doDel() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        try {
            //註記刪除
            SQL = "Update br_opte Set mark='D'";
            SQL += " where opt_sqlno='" + opt_sqlno + "'";
            conn.ExecuteNonQuery(SQL);

            SQL = "Update case_opte Set mark='D'";
            SQL += " where opt_sqlno='" + opt_sqlno + "'";
            conn.ExecuteNonQuery(SQL);
            
            //抓前一todo的流水號
            string pre_sqlno = "";
            SQL = "Select max(sqlno) as maxsqlno from todo_opte ";
            SQL += "where syscode='" + Session["Syscode"] + "' ";
            SQL += "and apcode='opte11' and opt_sqlno='" + opt_sqlno + "' ";
            SQL += "and dowhat='BR' ";
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    pre_sqlno = dr.SafeRead("maxsqlno", "");
                }
            }

            SQL = "update todo_opte set approve_scode='" + Session["scode"] + "' ";
            SQL += ",approve_desc='刪除分案' ";
            SQL += ",resp_date=getdate() ";
            SQL += ",job_status='XX' ";
            SQL += " where apcode='opte11' and opt_sqlno='" + opt_sqlno + "'";
            SQL += " and dowhat='BR' and syscode='" + Session["Syscode"] + "' ";
            SQL += " and sqlno=" + pre_sqlno;
            conn.ExecuteNonQuery(SQL);

            conn.Commit();
            //conn.RollBack();
            msg = "刪除分案成功";
        }
        catch (Exception ex) {
            conn.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);
            msg = "刪除分案失敗";
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
        window.parent.parent.Etop.goSearch();
    }
</script>
