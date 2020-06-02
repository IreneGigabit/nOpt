<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "爭救案判行確認‧-入檔";//功能名稱
    protected string HTProgPrefix = "opt22";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string SQL = "";
    protected string msg = "";

    string case_no = "";
    string branch = "";
    string opt_no = "";
    string opt_sqlno = "";
    string submitTask = "";
    string reportp = "";
    string end_flag = "";
    string sameap_flag = "";
    //交辦資料
    string Arcase = "";

    string Pmod_ap = "N";//預設N
    string Pmod_pul = "N";//預設N
    string Pmod_aprep = "N";//預設N
    string Pmod_claim1 = "N";//預設N
    string Pmod_class = "N";//預設N
    string Pmod_dmt = "N";//預設N

    protected Dictionary<string, string> ReqVal = new Dictionary<string, string>();
    protected StringBuilder strOut = new StringBuilder();

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        case_no = (Request["case_no"] ?? "").Trim();
        branch = (Request["Branch"] ?? "").Trim();
        opt_no = (Request["opt_no"] ?? "").Trim();
        opt_sqlno = (Request["opt_sqlno"] ?? "").Trim();
        submitTask = (Request["submittask"] ?? "").Trim();
        end_flag = (Request["End_flag"] ?? "").Trim();
        sameap_flag = (Request["sameap_flag"] ?? "").Trim();
        //交辦資料
        Arcase = (Request["tfy_Arcase"] ?? "").Trim();

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

            if (submitTask == "U") {//判行
                doConfirm();
            } else if (submitTask == "S") {//已判行維護
                doEdit();
            } else if (submitTask == "B") {//退回分案
                doBack();
            }

            if (ReqVal.TryGet("send_dept", "") == "L") {
                MailWin();//轉法律處作業出現outlook通知
            }

            this.DataBind();
        }
    }

    private void doConfirm() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        try {
            SQL = "update br_opt set PRY_hour=" + Util.dbzero(ReqVal.TryGet("PRY_hour", "0")) + "";
            SQL += ",AP_hour=" + Util.dbzero(ReqVal.TryGet("AP_hour", "0")) + "";
            SQL += ",send_dept=" + Util.dbnull(ReqVal.TryGet("send_dept", null)) + "";
            SQL += ",mp_date=" + Util.dbnull(ReqVal.TryGet("mp_date", null)) + "";
            SQL += ",GS_date=" + Util.dbnull(ReqVal.TryGet("GS_date", null)) + "";
            SQL += ",Send_cl=" + Util.dbnull(ReqVal.TryGet("Send_cl", null)) + "";
            SQL += ",Send_cl1=" + Util.dbnull(ReqVal.TryGet("Send_cl1", null)) + "";
            SQL += ",Send_Sel=" + Util.dbnull(ReqVal.TryGet("Send_Sel", null)) + "";
            SQL += ",rs_type=" + Util.dbnull(ReqVal.TryGet("rs_type", null)) + "";
            SQL += ",rs_class=" + Util.dbnull(ReqVal.TryGet("rs_class", null)) + "";
            SQL += ",rs_code=" + Util.dbnull(ReqVal.TryGet("rs_code", null)) + "";
            SQL += ",act_code=" + Util.dbnull(ReqVal.TryGet("act_code", null)) + "";
            SQL += ",RS_detail='" + ReqVal.TryGet("RS_detail", "") + "'";
            SQL += ",Fees=" + Util.dbzero(ReqVal.TryGet("Send_Fees", "0")) + "";
            SQL += ",ap_date='" + DateTime.Today.ToShortDateString() + "'";
            SQL += ",ap_remark='" + ReqVal.TryGet("ap_remark", "") + "'";
            if (ReqVal.TryGet("score_flag", "") == "Y") {
                SQL += ",score_flag=" + Util.dbnull(ReqVal.TryGet("score_flag", null)) + "";
                SQL += ",score=" + Util.dbzero(ReqVal.TryGet("Score", "0")) + "";
            } else {
                SQL += ",score_flag='N'";
                SQL += ",score=0";
            }
            SQL += ",rs_agt_no='" + ReqVal.TryGet("rs_agt_no", "") + "'";
            SQL += ",remark='" + ReqVal.TryGet("opt_remark", "").ToBig5() + "'";
            SQL += ",stat_code='YY'";
            SQL += ",tran_scode='" + Session["scode"] + "'";
            SQL += ",tran_date=getdate()";
            SQL += " where opt_sqlno='" + opt_sqlno + "'";
            conn.ExecuteNonQuery(SQL);

            //抓前一todo的流水號
            string pre_sqlno = "";
            SQL = "Select max(sqlno) as maxsqlno from todo_opt where syscode='" + Session["Syscode"] + "'";
            SQL += " and apcode='opt31' and opt_sqlno='" + opt_sqlno + "'";
            SQL += " and dowhat='AP'";
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    pre_sqlno = dr.SafeRead("maxsqlno", "");
                }
            }

            SQL = "update todo_opt set approve_scode='" + Session["scode"] + "'";
            SQL += ",resp_date=getdate()";
            SQL += ",job_status='YY'";
            SQL += " where apcode='opt31' and opt_sqlno='" + opt_sqlno + "'";
            SQL += " and dowhat='AP' and syscode='" + Session["Syscode"] + "'";
            SQL += " and sqlno=" + pre_sqlno;
            conn.ExecuteNonQuery(SQL);

            //入流程控制檔
            SQL = " insert into todo_opt(pre_sqlno,syscode,apcode,opt_sqlno,branch,case_no,in_scode,in_date";
            SQL += ",dowhat,job_status) values (";
            SQL += " '" + pre_sqlno + "','" + Session["Syscode"] + "','" + prgid + "'," + opt_sqlno + ",'" + branch + "','" + case_no + "'";
            SQL += ",'" + Session["scode"] + "',getdate(),'MG_GS','NN')";
            conn.ExecuteNonQuery(SQL);

            //conn.Commit();
            conn.RollBack();

            msg = "判行成功";
            strOut.AppendLine("alert('" + msg + "');");
            if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.parent.Etop.goSearch();");
        }
        catch (Exception ex) {
            conn.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);

            msg = "判行失敗";
            strOut.AppendLine("alert('" + msg + "');");

            throw new Exception(msg, ex);
        }
        finally {
            conn.Dispose();
        }
    }

    private void doEdit() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        DBHelper connB = new DBHelper(Conn.OptB(Request["branch"])).Debug(Request["chkTest"] == "TEST");
        DBHelper connM = new DBHelper(Conn.OptBM).Debug(Request["chkTest"] == "TEST");
        try {
            //Funcs.insert_log_table(conn, "U", prgid, "br_opt", "opt_sqlno", opt_sqlno);

            SQL = "update br_opt set remark='" + ReqVal.TryGet("opt_remark", "").ToBig5() + "'";
            if (ReqVal.TryGet("score_flag", "") == "Y") {
                SQL += ",score_flag=" + Util.dbnull(ReqVal.TryGet("score_flag", null)) + "";
                SQL += ",score=" + Util.dbzero(ReqVal.TryGet("Score", "0")) + "";
            } else {
                SQL += ",score_flag='N'";
                SQL += ",score=0";
            }
            //總管處未送件確認才可改
            if (ReqVal.TryGet("mconf", "") == "N") {
                SQL += ",send_dept=" + Util.dbnull(ReqVal.TryGet("send_dept", null)) + "";
                SQL += ",GS_date=" + Util.dbnull(ReqVal.TryGet("GS_date", null)) + "";
                SQL += ",mp_date=" + Util.dbnull(ReqVal.TryGet("mp_date", null)) + "";
                SQL += ",Send_cl=" + Util.dbnull(ReqVal.TryGet("Send_cl", null)) + "";
                SQL += ",Send_cl1=" + Util.dbnull(ReqVal.TryGet("Send_cl1", null)) + "";
                SQL += ",Send_Sel=" + Util.dbnull(ReqVal.TryGet("Send_Sel", null)) + "";
                SQL += ",act_code=" + Util.dbnull(ReqVal.TryGet("act_code", null)) + "";
                SQL += ",RS_detail='" + ReqVal.TryGet("RS_detail", "") + "'";
            }
            SQL += ",tran_scode='" + Session["scode"] + "'";
            SQL += ",tran_date=getdate()";
            SQL += " where opt_sqlno='" + opt_sqlno + "'";
            conn.ExecuteNonQuery(SQL);

            //修改上傳文件
            string opt_uploadfield = ReqVal.TryGet("opt_uploadfield", "");
            //目前畫面上的最大值
            int sqlnum = Convert.ToInt32("0" + ReqVal.TryGet(opt_uploadfield + "_sqlnum", ""));
            for (int i = 1; i <= sqlnum; i++) {
                string dbflag = ReqVal.TryGet(opt_uploadfield + "_dbflag_" + i, "");
                if (dbflag == "A") {
                    //當上傳路徑不為空的 and attach_sqlno為空的,才需要新增
                    if (ReqVal.TryGet(opt_uploadfield + "_" + i, "") != "" && ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, "") == "") {
                        SQL = "insert into attach_opt (Opt_sqlno,Source";
                        SQL += ",add_date,add_scode,Attach_no,attach_path,attach_desc";
                        SQL += ",Attach_name,Attach_size,attach_flag,Mark,tran_date,tran_scode";
                        SQL += ",Source_name,doc_type,doc_flag";
                        SQL += ") values (";
                        SQL += opt_sqlno + ",'PR'";
                        SQL += ",'" + DateTime.Today.ToShortDateString() + "','" + Session["scode"] + "'";
                        SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_attach_no_" + i, "") + "','" + ReqVal.TryGet(opt_uploadfield + "_" + i, "").Replace(@"\nopt\", @"\opt\") + "'";//因舊系統儲存路徑為opt為了統一照舊
                        SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_desc_" + i, "") + "','" + ReqVal.TryGet(opt_uploadfield + "_name_" + i, "") + "'";
                        SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_size_" + i, "") + "','A','',getdate(),'" + Session["scode"] + "'";
                        SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_source_name_" + i, "") + "'";
                        SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_doc_type_" + i, "") + "'";
                        SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_doc_flag_" + i, "") + "'";
                        SQL += ")";
                        conn.ExecuteNonQuery(SQL);
                    }
                } else if (dbflag == "U") {
                    Funcs.insert_log_table(conn, "U", prgid, "attach_opt", "attach_sqlno", ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, ""));
                    SQL = "Update attach_opt set Source='PR'";
                    SQL += ",attach_path='" + ReqVal.TryGet(opt_uploadfield + "_" + i, "").Replace(@"\nopt\", @"\opt\") + "'";//因舊系統儲存路徑為opt為了統一照舊
                    SQL += ",attach_desc='" + ReqVal.TryGet(opt_uploadfield + "_desc_" + i, "") + "'";
                    SQL += ",attach_name='" + ReqVal.TryGet(opt_uploadfield + "_name_" + i, "") + "'";
                    SQL += ",attach_size='" + ReqVal.TryGet(opt_uploadfield + "_size_" + i, "") + "'";
                    SQL += ",source_name='" + ReqVal.TryGet(opt_uploadfield + "_source_name_" + i, "") + "'";
                    SQL += ",doc_type='" + ReqVal.TryGet(opt_uploadfield + "_doc_type_" + i, "") + "'";
                    SQL += ",doc_flag='" + ReqVal.TryGet(opt_uploadfield + "_doc_flag_" + i, "") + "'";
                    SQL += ",attach_flag='U'";
                    SQL += ",tran_date=getdate()";
                    SQL += ",tran_scode='" + Session["scode"] + "'";
                    //SQL += " OUTPUT 'U', GETDATE(),'" + Session["scode"] + "'," + Util.dbnull(prgid) + "," + "DELETED.* INTO attach_opt_log";
                    SQL += " Where attach_sqlno='" + ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, "") + "'";
                    conn.ExecuteNonQuery(SQL);
                } else if (dbflag == "D") {
                    Funcs.insert_log_table(conn, "U", prgid, "attach_opt", "attach_sqlno", ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, ""));
                    //當attach_sqlno <> empty時,表示db有值,必須刪除data(update attach_flag = 'D')
                    if (ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, "") == "") {
                        SQL = "update attach_opt set attach_flag='D'";
                        //SQL += " OUTPUT 'U', GETDATE(),'" + Session["scode"] + "'," + Util.dbnull(prgid) + "," + "DELETED.* INTO attach_opt_log";
                        SQL += " where attach_sqlno='" + ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, "") + "'";
                        conn.ExecuteNonQuery(SQL);
                    }
                }
            }

            //已發文
            if (ReqVal.TryGet("stat_code", "") == "YS") {
                SQL = "select rs_no,rs_type,rs_class,rs_code,act_code,rs_detail ";
                SQL += ",rs_class_name,rs_code_name,act_code_name ";
                SQL += " from vbr_opt where opt_sqlno='" + opt_sqlno + "'";
                DataTable dt = new DataTable();
                conn.DataTable(SQL, dt);
                string rs_no = "", act_code_name = "";
                if (dt.Rows.Count != 0) {
                    rs_no = dt.Rows[0].SafeRead("rs_no", "").Trim();
                    act_code_name = dt.Rows[0].SafeRead("act_code_name", "").Trim();
                }

                //[區所]:爭救案專案室所上傳的檔案
                SQL = "Update bdmt_attach_temp set attach_flag='D' ";
                SQL += "where seq='" + Request["bseq"] + "' ";
                SQL += "and seq1='" + Request["bseq1"] + "' ";
                SQL += "and rs_no='" + rs_no + "' ";
                connB.ExecuteNonQuery(SQL);
                SQL = "Select * from attach_opt where opt_sqlno='" + opt_sqlno + "' and attach_flag<>'D'";
                using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                    while (dr.Read()) {
                        SQL = "insert into bdmt_attach_temp(rs_no,Seq,Seq1,Source,attach_no,attach_path";
                        SQL += ",attach_desc,attach_name,source_name,attach_size,attach_flag,doc_type,in_date,in_scode,doc_flag";
                        SQL += ") values (";
                        SQL += " '" + rs_no + "'," + Request["bseq"] + ",'" + Request["bseq1"] + "','OPT','" + dr.SafeRead("attach_no", "").Trim() + "'";
                        SQL += ",'" + dr.SafeRead("attach_path", "").Trim() + "','" + dr.SafeRead("attach_desc", "").Trim() + "'";
                        SQL += ",'" + dr.SafeRead("attach_name", "").Trim() + "','" + dr.SafeRead("source_name", "").Trim() + "'";
                        SQL += ",'" + dr.SafeRead("attach_size", "").Trim() + "','" + dr.SafeRead("attach_flag", "").Trim() + "'";
                        SQL += ",'" + dr.SafeRead("doc_type", "").Trim() + "',getdate(),'" + Session["scode"] + "'";
                        SQL += ",'" + dr.SafeRead("doc_flag", "").Trim() + "'";
                        SQL += ")";
                        connB.ExecuteNonQuery(SQL);
                    }
                }
                
                //總管處未送件確認才可改
                if (ReqVal.TryGet("mconf", "") == "N") {
                    //[區所]Bstep_temp
                    SQL = "Update Bstep_temp set send_dept=" + Util.dbnull(ReqVal.TryGet("send_dept", null)) + "";
                    SQL += ",step_date=" + Util.dbnull(ReqVal.TryGet("GS_date", null)) + "";
                    SQL += ",mp_date=" + Util.dbnull(ReqVal.TryGet("mp_date", null)) + "";
                    SQL += ",Send_cl=" + Util.dbnull(ReqVal.TryGet("Send_cl", null)) + "";
                    SQL += ",Send_cl1=" + Util.dbnull(ReqVal.TryGet("Send_cl1", null)) + "";
                    SQL += ",Send_Sel=" + Util.dbnull(ReqVal.TryGet("Send_Sel", null)) + "";
                    SQL += ",act_code=" + Util.dbnull(ReqVal.TryGet("act_code", null)) + "";
                    SQL += ",RS_detail='" + ReqVal.TryGet("RS_detail", "") + "'";
                    SQL += ",send_way='" + ReqVal.TryGet("send_way", "") + "'";
                    SQL += ",rectitle_name='" + ReqVal.TryGet("rectitle_name", "") + "'";
                    SQL += ",receipt_type='" + ReqVal.TryGet("receipt_type", "") + "'";
                    SQL += ",receipt_title='" + ReqVal.TryGet("receipt_title", "") + "'";
                    SQL += "where Branch='" + Request["Branch"] + "' ";
                    SQL += "and seq='" + Request["bseq"] + "' ";
                    SQL += "and seq1='" + Request["bseq1"] + "' ";
                    SQL += "and rs_no='" + rs_no + "' ";
                    connB.ExecuteNonQuery(SQL);

                    //[總收發]mgt_send
                    Dictionary<string, string> cond = new Dictionary<string, string>() {
                                    { "seq_area0","B" },
                                    { "seq_area",Request["Branch"] },
                                    { "seq",Request["bseq"] },
                                    { "seq1",Request["bseq1"] },
                                    {"rs_no",rs_no}};
                    Funcs.insert_log_table(connM, "U", prgid, "mgt_send", cond);
                    SQL = "Update mgt_send set step_date=" + Util.dbnull(ReqVal.TryGet("GS_date", null)) + "";
                    SQL += ",mp_date=" + Util.dbnull(ReqVal.TryGet("mp_date", null)) + "";
                    SQL += ",Send_cl=" + Util.dbnull(ReqVal.TryGet("Send_cl", null)) + "";
                    SQL += ",Send_cl1=" + Util.dbnull(ReqVal.TryGet("Send_cl1", null)) + "";
                    SQL += ",act_code=" + Util.dbnull(ReqVal.TryGet("act_code", null)) + "";
                    SQL += ",act_code_name=" + Util.dbnull(act_code_name) + "";
                    SQL += ",RS_detail='" + ReqVal.TryGet("RS_detail", "") + "'";
                    SQL += ",tran_scode='" + Session["scode"] + "'";
                    SQL += ",tran_date=getdate()";
                    SQL += "where seq_area0='B' ";
                    SQL += "and seq_area='" + Request["Branch"] + "' ";
                    SQL += "and seq='" + Request["bseq"] + "' ";
                    SQL += "and seq1='" + Request["bseq1"] + "' ";
                    SQL += "and rs_no='" + rs_no + "' ";
                    connM.ExecuteNonQuery(SQL);
                }
            }
            
            //conn.Commit();
            //connB.Commit();
            //connM.Commit();
            conn.RollBack();
            connB.RollBack();
            connM.RollBack();

            msg = "編修存檔成功，若有需要請通知區所重新抓取資料！";
            strOut.AppendLine("alert('" + msg + "');");
            if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.parent.Etop.goSearch();");
        }
        catch (Exception ex) {
            conn.RollBack();
            connB.RollBack();
            connM.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);

            msg = "存檔失敗！";
            strOut.AppendLine("alert('" + msg + "');");

            throw new Exception(msg, ex);
        }
        finally {
            conn.Dispose();
            connB.Dispose();
            connM.Dispose();
        }
    }
    
    private void doBack() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        try {
            SQL = "update br_opt set stat_code='NX'";
            SQL+=",ap_scode=null";
            SQL += " where opt_sqlno='" + opt_sqlno + "'";
            conn.ExecuteNonQuery(SQL);

            //抓前一todo的流水號
            string pre_sqlno = "", todo_scode = "";
            SQL = "Select max(sqlno) as maxsqlno,in_scode from todo_opt ";
            SQL += "where syscode='" + Session["Syscode"] + "' ";
            SQL += "and apcode='opt31' and opt_sqlno='" + opt_sqlno + "' ";
            SQL += "and dowhat='AP' group by in_scode ";
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    pre_sqlno = dr.SafeRead("maxsqlno", "");
                    todo_scode = dr.SafeRead("in_scode", "");
                }
            }

            SQL = "update todo_opt set approve_scode='" + Session["scode"] + "' ";
            SQL += ",approve_desc='" + ReqVal.TryGet("Preject_reason", "").ToBig5() + "' ";
            SQL += ",resp_date=getdate() ";
            SQL += ",job_status='XX' ";
            SQL += " where apcode='opt31' and opt_sqlno='" + opt_sqlno + "' ";
            SQL += " and dowhat='AP' and syscode='" + Session["Syscode"] + "' ";
            SQL += " and sqlno='" + pre_sqlno + "'";
            conn.ExecuteNonQuery(SQL);

            //入流程控制檔
            SQL = " insert into todo_opt(pre_sqlno,syscode,apcode,opt_sqlno,Branch";
            SQL += ",case_no,in_scode,in_date,dowhat,job_status) values (";
            SQL += " '" + pre_sqlno + "','" + Session["syscode"] + "','opt21'," + opt_sqlno + ",'" + branch + "'";
            SQL += ",'" + case_no + "','" + Session["scode"] + "',getdate(),'PR','NN')";
            conn.ExecuteNonQuery(SQL);

            //CreateMail(conn, opt_sqlno, todo_scode);

            //conn.Commit();
            conn.RollBack();

            msg = "退回成功";
            strOut.AppendLine("alert('" + msg + "');");
            if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.parent.Etop.goSearch();");
        }
        catch (Exception ex) {
            conn.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);
            msg = "退回失敗";
            strOut.AppendLine("alert('" + msg + "');");

            throw new Exception(msg, ex);
        }
        finally {
            conn.Dispose();
        }
    }
    
    private void MailWin() {
        string fseq = "", in_scode = "", in_scode_name = "", cust_area = "", cust_seq = "", ap_cname = "", appl_name = "", arcase_name = "", last_date = "", cust_name = "";
        using (DBHelper conn = new DBHelper(Conn.OptK, false).Debug(Request["chkTest"] == "TEST")) {
            SQL = "select Bseq,Bseq1,in_scode,scode_name,cust_area,cust_seq";
            SQL += " ,appl_name,arcase_name,Last_date,ap_cname from vbr_opt where case_no='" + case_no + "' and branch='" + branch + "'";
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    fseq = Funcs.formatSeq(dr.SafeRead("Bseq", ""), dr.SafeRead("Bseq1", "").Trim(), "", Sys.GetSession("SeBranch"), Sys.GetSession("dept"));
                    in_scode = dr.SafeRead("in_scode", "").Trim();
                    in_scode_name = dr.SafeRead("scode_name", "").Trim();
                    cust_area = dr.SafeRead("cust_area", "").Trim();
                    cust_seq = dr.SafeRead("cust_seq", "").Trim();
                    ap_cname = dr.SafeRead("ap_cname", "").Trim();
                    appl_name = dr.SafeRead("appl_name", "").Trim();
                    arcase_name = dr.SafeRead("arcase_name", "").Trim();
                    last_date = dr.SafeRead("last_date", "").Trim();
                }
            }
        }

        using (DBHelper connB = new DBHelper(Conn.OptB(branch), false).Debug(Request["chkTest"] == "TEST")) {
            SQL = "Select RTRIM(ISNULL(ap_cname1, '')) + RTRIM(ISNULL(ap_cname2, ''))  as cust_name from apcust as c ";
            SQL += " where c.cust_area='" + cust_area + "' and c.cust_seq='" + cust_seq + "'";
            using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    cust_name = dr.SafeRead("cust_name", "").CutData(10);
                }
            }
        }

        string subject = fseq + "-" + appl_name + "-" + cust_name;
        Response.Write("<script language=javascript>\n");
        //Response.Write("window.open('mailto:?subject=" + subject + "');\n");
        Response.Write("document.location.href='mailto:?subject=" + subject + "'\n");
        Response.Write("<" + "/script>\n");
    }

    private void CreateMail(DBHelper conn, string opt_sqlno,string todo_scode) {
        string fseq = "", in_scode = "", in_scode_name = "", cust_area = "", cust_seq = "";
        string ap_cname = "", appl_name = "", arcase_name = "", last_date = "";
        SQL = "select Bseq,Bseq1,branch,in_scode,scode_name,cust_area,cust_seq ";
        SQL += ",appl_name,arcase_name,Last_date,ap_cname ";
        SQL += "from vbr_opt where opt_sqlno='" + opt_sqlno + "'";
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

        string Subject = "國內所商標爭救案件管理系統－爭救案件判行退回通知";
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
            "【申請人】 : <B>" + ap_cname + "</B><br>" +
            "【案件名稱】 : <B>" + appl_name + "</B><br>" +
            "【案性】 : <B>" + arcase_name + "</B><br>" +
            "【法定期限】 : <font color=red><B>" + last_date + "</font></B><br>" +
            "【退件理由】 : <br>　　" + Request["Preject_reason"] + "<Br><Br><p>";
        body += "◎請至承辦作業－＞承辦暨結辦作業，重新承辦。 ";

        Sys.DoSendMail(Subject, body, strFrom, strTo, strCC, strBCC);
    }
</script>

<script language="javascript" type="text/javascript">
    <%Response.Write(strOut.ToString());%>
</script>
