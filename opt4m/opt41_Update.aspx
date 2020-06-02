<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "爭救案官發作業‧-入檔";//功能名稱
    protected string HTProgPrefix = "opt41";//程式檔名前綴
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

            if (submitTask == "U") {//發文確認
                doConfirm();
            } else if (submitTask == "B") {//退回承辦
                doBack();
            }

            this.DataBind();
        }
    }

    private void doConfirm() {
        for (int i = 1; i <= count; i++) {
            if (ReqVal.TryGet("opt_sqlno" + i, "") != "") {
                DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
                DBHelper connB = new DBHelper(Conn.OptB(ReqVal.TryGet("branch" + i, ""))).Debug(Request["chkTest"] == "TEST");
                DBHelper connM = new DBHelper(Conn.OptBM).Debug(Request["chkTest"] == "TEST");
                DBHelper conni = new DBHelper(Conn.Acc(ReqVal.TryGet("branch" + i, ""))).Debug(Request["chkTest"] == "TEST");
                try {
                    //抓取發文序號
                    SQL = "select sql+1 as rs_no from cust_code where code_type='Z' and cust_code='BTGS'";
                    object objResult = conn.ExecuteScalar(SQL);
                    string rs_no = (objResult == DBNull.Value || objResult == null ? "BGS0000001" : "BGS" + objResult.ToString().PadLeft(7, '0'));

                    SQL = "update br_opt set stat_code='YS'";
                    SQL += ",rs_no='" + rs_no + "'";
                    SQL += ",GS_date='" + ReqVal.TryGet("step_date" + i, "") + "'";
                    SQL += ",mp_date='" + ReqVal.TryGet("mp_date" + i, "") + "'";
                    SQL += ",tran_scode='" + Session["scode"] + "'";
                    SQL += ",tran_date=getdate()";
                    SQL += " where opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "'";
                    conn.ExecuteNonQuery(SQL);

                    //抓前一todo的流水號
                    string pre_sqlno = "";
                    SQL = "Select max(sqlno) as maxsqlno from todo_opt ";
                    SQL += "where syscode='" + Session["Syscode"] + "' ";
                    SQL += "and apcode='opt22' and opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "' ";
                    SQL += "and dowhat='MG_GS' ";
                    using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                        if (dr.Read()) {
                            pre_sqlno = dr.SafeRead("maxsqlno", "");
                        }
                    }

                    SQL = "update todo_opt set approve_scode='" + Session["scode"] + "'";
                    SQL += ",resp_date=getdate()";
                    SQL += ",job_status='YY'";
                    SQL += " where apcode='opt22' and opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "'";
                    SQL += " and dowhat='MG_GS' and syscode='" + Session["Syscode"] + "'";
                    SQL += " and sqlno='" + pre_sqlno + "'";
                    conn.ExecuteNonQuery(SQL);

                    //更新發文序號
                    SQL = "update cust_code set sql=sql+1 where code_type='Z' and cust_code='BTGS'";
                    conn.ExecuteNonQuery(SQL);

                    SQL = "select Branch,Bseq,Bseq1,send_dept,gs_date,mp_date,send_cl,Send_Cl1,send_sel";
                    SQL += ",rs_type,rs_class,rs_code,act_code,rs_detail,Bfees,case_no,rs_agt_no,mseq,mseq1 ";
                    SQL += ",rs_class_name,rs_code_name,act_code_name,class_count,appl_name,eappl_name";
                    SQL += ",s_mark,apply_no,apply_date,issue_no,issue_date,rej_no,open_date";
                    SQL += ",term1,term2,end_date,end_code,cust_area,cust_seq,in_scode";
                    SQL += ",send_way,rectitle_name,receipt_type,receipt_title";
                    SQL += " from vbr_opt where opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "'";
                    DataTable dt = new DataTable();
                    conn.DataTable(SQL, dt);

                    string Branch = "", seq = "", seq1 = "", gs_date = "", mp_date = "", send_dept = "", send_cl = "", send_cl1 = "", send_sel = "";
                    string rs_type = "", rs_class = "", rs_class_name = "", rs_code = "", rs_code_name = "", act_code = "", act_code_name = "", rs_detail = "";
                    string fees = "", case_no = "", rs_agt_no = "", mseq = "", mseq1 = "", class_count = "", cappl_name = "", eappl_name = "", s_mark = "";
                    string apply_no = "", apply_date = "", issue_no = "", issue_date = "", rej_no = "", open_date = "", term1 = "", term2 = "";
                    string end_date = "", end_code = "", cust_area = "", cust_seq = "", in_scode = "", send_way = "", rectitle_name = "", receipt_type = "", receipt_title = "";
                    if (dt.Rows.Count != 0) {
                        Branch = dt.Rows[0].SafeRead("Branch", "").Trim();
                        seq = dt.Rows[0].SafeRead("Bseq", "").Trim();
                        seq1 = dt.Rows[0].SafeRead("Bseq1", "").Trim();
                        gs_date = dt.Rows[0].SafeRead("gs_date", "");
                        mp_date = dt.Rows[0].SafeRead("mp_date", "").Trim();
                        send_dept = dt.Rows[0].SafeRead("send_dept", "").Trim();
                        send_cl = dt.Rows[0].SafeRead("send_cl", "").Trim();
                        send_cl1 = dt.Rows[0].SafeRead("Send_Cl1", "").Trim();
                        send_sel = dt.Rows[0].SafeRead("send_sel", "").Trim();
                        rs_type = dt.Rows[0].SafeRead("rs_type", "").Trim();
                        rs_class = dt.Rows[0].SafeRead("rs_class", "").Trim();
                        rs_class_name = dt.Rows[0].SafeRead("rs_class_name", "").Trim();
                        rs_code = dt.Rows[0].SafeRead("rs_code", "").Trim();
                        rs_code_name = dt.Rows[0].SafeRead("rs_code_name", "").Trim();
                        act_code = dt.Rows[0].SafeRead("act_code", "").Trim();
                        act_code_name = dt.Rows[0].SafeRead("act_code_name", "").Trim();
                        rs_detail = dt.Rows[0].SafeRead("rs_detail", "").Trim().ToBig5();
                        fees = dt.Rows[0].SafeRead("Bfees", "0");
                        case_no = dt.Rows[0].SafeRead("case_no", "").Trim();
                        rs_agt_no = dt.Rows[0].SafeRead("rs_agt_no", "").Trim();
                        mseq = dt.Rows[0].SafeRead("mseq", "").Trim();
                        mseq1 = dt.Rows[0].SafeRead("mseq1", "").Trim();
                        class_count = dt.Rows[0].SafeRead("class_count", "").Trim();
                        cappl_name = dt.Rows[0].SafeRead("appl_name", "").Trim().ToBig5();
                        eappl_name = dt.Rows[0].SafeRead("eappl_name", "").Trim().ToBig5();
                        s_mark = dt.Rows[0].SafeRead("s_mark", "_").Trim();
                        if (s_mark == "") s_mark = "_";
                        apply_no = dt.Rows[0].SafeRead("apply_no", "").Trim();
                        apply_date = dt.Rows[0].SafeRead("apply_date", "").Trim();
                        issue_no = dt.Rows[0].SafeRead("issue_no", "").Trim();
                        issue_date = dt.Rows[0].SafeRead("issue_date", "").Trim();
                        rej_no = dt.Rows[0].SafeRead("rej_no", "").Trim();
                        open_date = dt.Rows[0].SafeRead("open_date", "").Trim();
                        term1 = dt.Rows[0].SafeRead("term1", "").Trim();
                        term2 = dt.Rows[0].SafeRead("term2", "").Trim();
                        end_date = dt.Rows[0].SafeRead("end_date", "").Trim();
                        end_code = dt.Rows[0].SafeRead("end_code", "").Trim();
                        cust_area = dt.Rows[0].SafeRead("cust_area", "").Trim();
                        cust_seq = dt.Rows[0].SafeRead("cust_seq", "").Trim();
                        in_scode = dt.Rows[0].SafeRead("in_scode", "").Trim();
                        send_way = dt.Rows[0].SafeRead("send_way", "").Trim();
                        rectitle_name = dt.Rows[0].SafeRead("rectitle_name", "").Trim();
                        receipt_type = dt.Rows[0].SafeRead("receipt_type", "").Trim();
                        receipt_title = dt.Rows[0].SafeRead("receipt_title", "").Trim();
                    }
                    //[區所]Bstep_temp
                    SQL = "insert into Bstep_temp(RS_no,Branch,seq,seq1,send_dept,step_date,mp_date,CG,RS,Send_cl,Send_Cl1";
                    SQL += ",send_sel,rs_type,rs_class,rs_code,act_code,rs_detail,fees,case_no,opt_sqlno,rs_agt_no";
                    SQL += ",send_way,rectitle_name,receipt_type,receipt_title) values (";
                    SQL += " '" + rs_no + "','" + Branch + "'," + seq + ",'" + seq1 + "','" + send_dept + "'," + Util.dbdate(gs_date,"yyyy/M/d") + "";
                    SQL += "," + Util.dbdate(mp_date, "yyyy/M/d") + ",'G','S','" + send_cl + "','" + send_cl1 + "','" + send_sel + "'";
                    SQL += ",'" + rs_type + "','" + rs_class + "','" + rs_code + "','" + act_code + "','" + rs_detail + "'";
                    SQL += "," + fees + ",'" + case_no + "','" + ReqVal.TryGet("opt_sqlno" + i, "") + "','" + rs_agt_no + "'";
                    SQL += "," + send_way + ",'" + rectitle_name + "','" + receipt_type + "','" + receipt_title + "')";
                    connB.ExecuteNonQuery(SQL);

                    //[區所]:爭救案專案室所上傳的檔案
                    SQL = "Select * from attach_opt where opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "' and attach_flag<>'D'";
                    using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                        while (dr.Read()) {
                            SQL = "insert into bdmt_attach_temp(rs_no,Seq,Seq1,Source,attach_no,attach_path";
                            SQL += ",attach_desc,attach_name,source_name,attach_size,attach_flag,doc_type,in_date,in_scode";
                            SQL += ") values (";
                            SQL += " '" + rs_no + "'," + seq + ",'" + seq1 + "','OPT','" + dr.SafeRead("attach_no", "").Trim() + "'";
                            SQL += ",'" + dr.SafeRead("attach_path", "").Trim() + "','" + dr.SafeRead("attach_desc", "").Trim() + "'";
                            SQL += ",'" + dr.SafeRead("attach_name", "").Trim() + "','" + dr.SafeRead("source_name", "").Trim() + "'";
                            SQL += ",'" + dr.SafeRead("attach_size", "").Trim() + "','" + dr.SafeRead("attach_flag", "").Trim() + "'";
                            SQL += ",'" + dr.SafeRead("doc_type", "").Trim() + "',getdate(),'" + Session["scode"] + "'";
                            SQL += ")";
                            connB.ExecuteNonQuery(SQL);
                        }
                    }

                    //若是第一筆官發給Y
                    string case_new = "N", new_flag = "";
                    SQL = "select count(*) as cnt from step_dmt where Seq='" + seq + "' and Seq1='" + seq1 + "' and cg='G' and rs='S'";
                    object objResult1 = connB.ExecuteScalar(SQL);
                    string cnt = (objResult1 == DBNull.Value || objResult1 == null ? "0" : objResult1.ToString());
                    if (Convert.ToInt32(cnt) == 0) case_new = "Y";

                    //抓取區所立案日期,2019/8/23增加抓取結案日期及結案代碼，因KT36495客收同時復案以致寫入爭議組交辦資料含結案日期，所以再重抓區所資料寫入總收發文系統
                    SQL = "select in_date,end_date,end_code from dmt where Seq='" + seq + "' and Seq1='" + seq1 + "'";
                    string br_in_date = null;
                    using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                        if (dr.Read()) {
                            br_in_date = dr.SafeRead("in_date", "");
                            end_date = dr.SafeRead("end_date", "");
                            end_code = dr.SafeRead("end_code", "");
                        }
                    }

                    string country = "T";
                    if (seq1.ToUpper() == "M") country = "CM";

                    //[總收發]新增mgt_send
                    SQL = "insert into mgt_send(seq_area0,seq_area,seq,seq1,br_in_date,br_step_grade,br_rs_sqlno,mseq,mseq1";
                    SQL += ",rs_no,mrs_no,rs_type,rs_class,rs_class_name,rs_code,rs_code_name";
                    SQL += ",act_code,act_code_name,rs_detail,send_cl,send_cl1";
                    SQL += ",class_count,add_count,new_flag,case_new,fees,step_date";
                    SQL += ",mp_date,cappl_name,eappl_name,s_mark1,country,apply_date,apply_no";
                    SQL += ",issue_date,issue_no2,issue_no3,open_date,pay_times,pay_date";
                    SQL += ",term1,term2,end_date,end_code,source,send_status,branch_date";
                    SQL += ",branch_scode,tran_date,tran_scode,agt_no";
                    SQL += ") values (";
                    SQL += "'B','" + Branch + "','" + seq + "','" + seq1 + "'," + Util.dbdate(br_in_date,"yyyy/M/d");
                    SQL += ",0,0,'" + mseq + "','" + mseq1 + "','" + rs_no + "'";
                    SQL += ",'" + rs_no + "','" + rs_type + "','" + rs_class + "'";
                    SQL += ",'" + rs_class_name + "','" + rs_code + "','" + rs_code_name + "'";
                    SQL += ",'" + act_code + "','" + act_code_name + "','" + rs_detail + "'";
                    SQL += ",'" + send_cl + "','" + send_cl1 + "'," + Util.dbzero(class_count);
                    SQL += ",'1','" + new_flag + "','" + case_new + "'," + Util.dbzero(fees) + "," + Util.dbdate(gs_date,"yyyy/M/d");
                    SQL += "," + Util.dbdate(mp_date,"yyyy/M/d") + ",'" + cappl_name + "','" + eappl_name + "','" + s_mark + "','" + country + "'";
                    SQL += "," + Util.dbdate(apply_date,"yyyy/M/d") + ",'" + apply_no + "'," + Util.dbdate(issue_date,"yyyy/M/d");
                    SQL += ",'" + issue_no + "','" + rej_no + "'," + Util.dbdate(open_date,"yyyy/M/d") + ",''";
                    SQL += ",null," + Util.dbnull(term1) + "," + Util.dbnull(term2) + "," + Util.dbdate(end_date,"yyyy/M/d");
                    SQL += ",'" + end_code + "','B','NN',getdate(),'" + Session["scode"] + "',getdate()";
                    SQL += ",'" + Session["scode"] + "','" + rs_agt_no + "'";
                    SQL += ")";
                    connM.ExecuteNonQuery(SQL);

                    //[總收發]新增todo_mgt
                    SQL = "insert into todo_mgt(syscode,apcode,br_rs_sqlno,seq_area,seq,seq1,rs";
                    SQL += ",rs_no,in_date,in_scode,dowhat,job_status) values (";
                    SQL += "'" + Session["Syscode"] + "','" + prgid + "',0,'" + Branch + "'";
                    SQL += "," + Util.dbnull(seq) + ",'" + seq1 + "','S','" + rs_no + "',getdate()";
                    SQL += ",'" + Session["scode"] + "','br_send','NN')";
                    connM.ExecuteNonQuery(SQL);

                    //[帳款]區所account db
                    //DateTime tgs_date = DateTime.ParseExact(gs_date, "yyyy/MM/dd", System.Globalization.CultureInfo.InvariantCulture);
                    //string step_date = tgs_date.ToString("MM/dd/YYYY");
                    //string step_date = Util.dbdate(gs_date, "MM/dd/YYYY");
                    SQL = "select case_no,Bfees,arcase as case_arcase,ar_mark from vbr_opt a where rs_no='" + rs_no + "'";
                    using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                        string chk_type = "N";
                        if (dr.HasRows) {
                            SQL = "select count(*) from plus_temp where branch='" + Branch + "' and dept='" + Session["Dept"] + "' ";
                            SQL += "and rs_no='" + rs_no + "' and chk_type='Y'";
                            object objResult2 = conni.ExecuteScalar(SQL);
                            string cnt2 = (objResult2 == DBNull.Value || objResult2 == null ? "0" : objResult2.ToString());
                            if (Convert.ToInt32(cnt2) > 0) {
                                chk_type = "Y";
                            } else {
                                chk_type = "N";
                                Dictionary<string, string> cond = new Dictionary<string, string>() {
                                    { "branch",Branch },
                                    { "dept",Sys.GetSession("dept") },
                                    { "rs_no",rs_no },
                                    {"chk_type","N"}
                                };
                                Funcs.insert_log_table(conni, "D", prgid, "plus_temp", cond);

                                SQL = "delete from plus_temp where branch='" + Branch + "' and dept='" + Session["dept"] + "' and rs_no='" + rs_no + "' and chk_type='N'";
                                conni.ExecuteNonQuery(SQL);
                            }
                        }

                        while (dr.Read()) {
                            if (Convert.ToInt32("0" + dr.SafeRead("Bfees", "")) > 0) {
                                if (chk_type == "N") {
                                    SQL = "insert into plus_temp(class,tr_date,tr_scode,send_date,branch,dept,";
                                    SQL += "case_no,rs_no,seq,seq1,country,cust_seq,scode,case_arcase,";
                                    SQL += "arcase,ar_mark,tr_money,chk_type,chk_date,mstat_flag,mstat_date) values(";
                                    SQL += "'1','" + DateTime.Now.ToShortDateString() + "','" + Session["scode"] + "'," + Util.dbdate(gs_date, "MM/dd/yyyy") + ",'" + Branch + "',";
                                    SQL += "'" + Session["dept"] + "','" + case_no + "','" + rs_no + "',";
                                    SQL += seq + ",'" + seq1 + "','T'," + cust_seq + ",";
                                    SQL += "'" + in_scode + "','" + dr.SafeRead("case_arcase", "") + "',";
                                    SQL += "'" + rs_code + "','" + dr.SafeRead("ar_mark", "") + "'," + dr.SafeRead("Bfees", "") + ",'N',null,'NN',null)";
                                    conni.ExecuteNonQuery(SQL);
                                }
                            }
                        }
                    }

                    //conn.Commit();
                    //connB.Commit();
                    //connM.Commit();
                    //conni.Commit();
                    conn.RollBack();
                    connB.RollBack();
                    connM.RollBack();
                    conni.RollBack();

                    msg = "官方發文成功";
                }
                catch (Exception ex) {
                    conn.RollBack();
                    connB.RollBack();
                    connM.RollBack();
                    conni.RollBack();
                    Sys.errorLog(ex, conn.exeSQL, prgid);
                    Sys.errorLog(ex, connB.exeSQL, prgid);
                    Sys.errorLog(ex, connM.exeSQL, prgid);
                    Sys.errorLog(ex, conni.exeSQL, prgid);
                    msg = "官方發文失敗";

                    throw new Exception(msg, ex);
                }
                finally {
                    conn.Dispose();
                    connB.Dispose();
                    connM.Dispose();
                    conni.Dispose();
                }
            }
        }
        strOut.AppendLine("alert('" + msg + "');");
        if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.parent.Etop.goSearch();");
    }

    private void doBack() {
        for (int i = 1; i <= count; i++) {
            if (ReqVal.TryGet("opt_sqlno" + i, "") != "") {
                DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
                try {
                    SQL = "update br_opt set stat_code='NX'";
                    SQL += ",ap_scode=null";
                    SQL += ",PRY_hour=0";
                    SQL += ",AP_hour=0";
                    SQL += ",ap_date=null";
                    SQL += ",ap_remark=null";
                    SQL += ",remark=null";
                    SQL += ",tran_scode='" + Session["scode"] + "'";
                    SQL += ",tran_date=getdate()";
                    SQL += " where opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "'";
                    conn.ExecuteNonQuery(SQL);

                    //抓前一todo的流水號
                    string pre_sqlno = "";
                    SQL = "Select max(sqlno) as maxsqlno from todo_opt ";
                    SQL += "where syscode='" + Session["Syscode"] + "' ";
                    SQL += "and apcode='opt22' and opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "' ";
                    SQL += "and dowhat='MG_GS' ";
                    using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                        if (dr.Read()) {
                            pre_sqlno = dr.SafeRead("maxsqlno", "");
                        }
                    }

                    SQL = "update todo_opt set approve_scode='" + Session["scode"] + "'";
                    SQL += ",approve_desc='" + Request["Preject_reason"].ToBig5() + "'";
                    SQL += ",resp_date=getdate()";
                    SQL += ",job_status='XX'";
                    SQL += " where apcode='opt22' and opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "'";
                    SQL += " and dowhat='MG_GS' and syscode='" + Session["Syscode"] + "'";
                    SQL += " and sqlno='" + pre_sqlno + "'";
                    conn.ExecuteNonQuery(SQL);

                    //入流程控制檔
                    SQL = " insert into todo_opt(pre_sqlno,syscode,apcode,opt_sqlno,branch,case_no,in_scode,in_date";
                    SQL += ",dowhat,job_status) values (";
                    SQL += "'" + pre_sqlno + "','" + Session["Syscode"] + "','opt21','" + ReqVal.TryGet("opt_sqlno" + i, "") + "'";
                    SQL += ",'" + ReqVal.TryGet("branch" + i, "") + "','" + ReqVal.TryGet("case_no" + i, "") + "'";
                    SQL += ",'" + Session["scode"] + "',getdate(),'PR','NN')";
                    conn.ExecuteNonQuery(SQL);

                    //conn.Commit();
                    conn.RollBack();

                    msg = "退回成功";
                }
                catch (Exception ex) {
                    conn.RollBack();
                    Sys.errorLog(ex, conn.exeSQL, prgid);
                    msg = "退回失敗";

                    throw new Exception(msg, ex);
                }
                finally {
                    conn.Dispose();
                }
            }
        }
        strOut.AppendLine("alert('" + msg + "');");
        if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.parent.Etop.goSearch();");
    }
</script>

<script language="javascript" type="text/javascript">
    <%Response.Write(strOut.ToString());%>
</script>
