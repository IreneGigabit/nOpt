<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Net.Mail"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "主管分案作業‧-入檔";//功能名稱
    protected string HTProgPrefix = "opt21";//程式檔名前綴
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
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
        
        Token myToken = new Token(prgid);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            if (submitTask == "U") {
                doConfirm();//分案確認
            } else if (submitTask == "ADD") {//新增分案主檔
                doAdd();
            }
            
            this.DataBind();
        }
    }

    private void doConfirm() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        try {
            //抓前一todo的流水號
            string pre_sqlno = "";
            SQL = "Select max(sqlno) as maxsqlno from todo_opt ";
            SQL += "where syscode='" + Session["Syscode"] + "' ";
            SQL += "and apcode='opt11' and opt_sqlno='" + opt_sqlno + "' ";
            SQL += "and dowhat='BR' ";
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    pre_sqlno = dr.SafeRead("maxsqlno", "");
                }
            }
        
            SQL = "update br_opt set in_scode='" + Session["scode"] + "'";
            SQL += ",in_date='" + DateTime.Now.ToString("yyyy/MM/dd") + "'";
            SQL += ",last_date='" + Request["dfy_last_date"] + "'";
            SQL += ",ctrl_date='" + Request["ctrl_date"] + "'";
            SQL += ",pr_branch='" + Request["pr_branch"] + "'";
            SQL += ",pr_scode='" + Request["pr_scode"] + "'";
            SQL += ",br_remark='" + Request["Br_remark"].ToBig5() + "'";
            SQL += ",stat_code='NN'";
            SQL += " where opt_sqlno='" + opt_sqlno + "'";
            conn.ExecuteNonQuery(SQL);

            SQL = "update todo_opt set approve_scode='" + Session["scode"] + "'";
            SQL += ",resp_date=getdate()";
            SQL += ",job_status='YY'";
            SQL += " where apcode='opt11' and opt_sqlno='" + opt_sqlno + "'";
            SQL += " and dowhat='BR' and syscode='" + Session["Syscode"] + "' ";
            SQL += " and sqlno=" + pre_sqlno;
            conn.ExecuteNonQuery(SQL);
    
            //入流程控制檔
            SQL = "insert into todo_opt(pre_sqlno,syscode,apcode,opt_sqlno,branch,case_no ";
            SQL += ",in_scode,in_date,dowhat,job_status) values ( ";
            SQL += "'" + pre_sqlno + "','" + Session["Syscode"] + "','" + prgid + "'," + opt_sqlno + ",'" + branch + "','" + case_no + "'";
            SQL += ",'" + Session["scode"] + "',getdate(),'PR','NN')";
            conn.ExecuteNonQuery(SQL);
            
            //conn.Commit();
            conn.RollBack();
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
            SQL = "select max(opt_no)+1 from br_opt where left(opt_no,4)=(year(getdate()))";
            object objResult = conn.ExecuteScalar(SQL);
            string opt_no = (objResult == DBNull.Value || objResult == null ? (DateTime.Now.Year + "000001") : objResult.ToString());
            
            //新增分案主檔
	        SQL = "insert into br_opt(opt_no,branch,Bseq,Bseq1,Bcase_date,Last_date";
	        SQL += ",in_scode,in_date,ctrl_date,pr_branch,pr_scode,br_remark,stat_code,mark,br_source,confirm_date) values (";
	        SQL += "'"+opt_no+"','"+Request["branch"]+"',"+Request["Bseq"]+",'"+Request["Bseq1"]+"'";
	        SQL += ",'"+DateTime.Now.ToString("yyyy/MM/dd")+"',"+Util.dbnull(Request["dfy_last_date"])+",'"+Session["scode"]+"','"+DateTime.Now.ToString("yyyy/MM/dd")+"'";
	        SQL += ","+Util.dbnull(Request["ctrl_date"])+",'"+Request["pr_branch"]+"','"+Request["pr_scode"]+"'";
            SQL += ",'" + Request["br_remark"].ToBig5() + "','NN','N','opt','" + DateTime.Now.ToString("yyyy/MM/dd") + "')";
            conn.ExecuteNonQuery(SQL);
	
            //抓insert後的流水號
            SQL = "SELECT SCOPE_IDENTITY() AS Current_Identity";
            object objResult1 = conn.ExecuteScalar(SQL);
            opt_sqlno = objResult1.ToString();

            //新增接洽記錄檔
	        SQL = " insert into case_opt(opt_sqlno,branch,in_scode,seq,seq1,cust_area,cust_seq,att_sql,arcase_type,arcase_class,arcase ";
	        SQL += ",service,fees,tot_num,ar_mark,remark,mark,new ";
	        SQL += ") values ('"+opt_sqlno+"','"+Request["branch"]+"','"+Request["in_scode"]+"','"+Request["Bseq"]+"','"+Request["Bseq1"]+"'";
	        SQL += ",'"+Request["cust_area"]+"','"+Request["cust_seq"]+"','"+Request["att_sql"]+"','"+Request["arcase_type"]+"'";
            SQL += ",'" + Request["arcase_class"] + "','" + Request["arcase"] + "',0,0,1,'N','" + Request["remark"].ToBig5() + "','N','N')";
            conn.ExecuteNonQuery(SQL);
	
	        //新增接洽記錄暫存檔
	        SQL = " insert into opt_detail(opt_sqlno,branch,seq,seq1,in_date,apsqlno,ap_cname,ap_ename,apply_date,apply_no,issue_date,issue_no ";
	        SQL += ",appl_name,agt_no,open_date,rej_no,dmt_term1,dmt_term2 ";
	        SQL += ") values ('"+opt_sqlno+"','"+Request["branch"]+"','"+Request["Bseq"]+"','"+Request["Bseq1"]+"','"+DateTime.Now.ToString("yyyy/MM/dd")+"','"+Request["apsqlno"]+"' ";
            SQL += ",'" + Request["ap_cname"].ToBig5() + "','" + Request["ap_ename"].ToBig5() + "'," + Util.dbnull(Request["apply_date"]) + ",'" + Request["apply_no"] + "'";
            SQL += "," + Util.dbnull(Request["issue_date"]) + ",'" + Request["issue_no"] + "'," + Util.dbnull(Request["appl_name"].ToBig5()) + ",'" + Request["agt_no"] + "'";
	        SQL += ","+Util.dbnull(Request["open_date"])+",'"+Request["rej_no"]+"',"+Util.dbnull(Request["dmt_term1"])+"";
	        SQL += ","+Util.dbnull(Request["dmt_term2"])+")";
            conn.ExecuteNonQuery(SQL);
	
	        //新增接洽案件申請人檔
            for(int apnum=1;apnum<=Convert.ToInt32(Request["br_apnum"]);apnum++){
		        SQL = " insert into caseopt_ap(opt_sqlno,branch,apsqlno,server_flag,apcust_no,ap_cname,ap_cname1,ap_cname2,ap_ename,ap_ename1,ap_ename2,tran_date,tran_scode) values ";
		        SQL+= "('" + opt_sqlno + "','" + Request["branch"] + "','" + Request["apsqlno_" + apnum] + "','" + Request["server_flag_"+apnum] + "','" + Request["apcust_no_"+apnum] + "',";
                SQL += "'" + Request["ap_cname_" + apnum].ToBig5() + "','" + Request["ap_cname1_" + apnum].ToBig5() + "','" + Request["ap_cname2_" + apnum].ToBig5() + "','" + Request["ap_ename_" + apnum].ToBig5() + "',";
                SQL += "'" + Request["ap_ename1_" + apnum].ToBig5() + "','" + Request["ap_ename2_" + apnum].ToBig5() + "',getdate(),'" + Session["scode"] + "')";
                conn.ExecuteNonQuery(SQL);
	        }
	
	        //入流程控制檔
	        SQL = " insert into todo_opt(syscode,apcode,opt_sqlno,Branch,in_scode,in_date";
	        SQL+=",dowhat,job_status) values (";
	        SQL+="'"+Session["syscode"]+"','"+ prgid +"',"+opt_sqlno+",'"+branch+"'";
	        SQL+=",'"+Session["scode"]+"',getdate(),'PR','NN')" ;
            conn.ExecuteNonQuery(SQL);
           
            //conn.Commit();
            //connB.Commit();
            conn.RollBack();
            connB.RollBack();
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
</script>

<script language="javascript" type="text/javascript">
    alert("<%#msg%>");
    if ("<%#Request["chkTest"]%>" != "TEST") {
        window.parent.Etop.goSearch();
    }
</script>
