<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "出口爭救案判行確認‧-入檔";//功能名稱
    protected string HTProgPrefix = "opte22";//程式檔名前綴
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
    string todo_sqlno = "";

    string job_scode = "", job_team = "";

    protected Dictionary<string, string> ReqVal = new Dictionary<string, string>();
    protected StringBuilder strOut = new StringBuilder();

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        if (prgid == "opte24") {
            HTProgCap = "出口爭救案已判行維護";
        }

        case_no = (Request["case_no"] ?? "").Trim();
        branch = (Request["Branch"] ?? "").Trim();
        opt_no = (Request["opt_no"] ?? "").Trim();
        opt_sqlno = (Request["opt_sqlno"] ?? "").Trim();
        submitTask = (Request["submittask"] ?? "").Trim();
        todo_sqlno = (Request["todo_sqlno"] ?? "").Trim();

        ReqVal = Util.GetRequestParam(Context,Request["chkTest"] == "TEST");

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            if (submitTask == "U") {//判行
                doConfirm();
            } else if (submitTask == "S") {//已判行維護
                doEdit();
            } else if (submitTask == "B") {//退回分案
                doBack();
            }

            this.DataBind();
        }
    }

    private void doConfirm() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        DBHelper connB = new DBHelper(Conn.OptB(branch)).Debug(Request["chkTest"] == "TEST");
        try {
            Funcs.insert_log_table(conn, "U", prgid, "br_opte", "opt_sqlno", opt_sqlno);

            SQL = "update br_opte set PRY_hour=" + Util.dbzero(ReqVal.TryGet("PRY_hour", "0")) + "";
            SQL += ",AP_hour=" + Util.dbzero(ReqVal.TryGet("AP_hour", "0")) + "";
            SQL += ",Ap_date='" + DateTime.Today.ToShortDateString() + "'";
            SQL += ",ap_remark='" + ReqVal.TryGet("ap_remark", "") + "'";
            SQL += ",stat_code='YY'";
            SQL += ",brtran_mark='Y' ";
            SQL += ",tran_scode='" + Session["scode"] + "'";
            SQL += ",tran_date=getdate()";
            SQL += " where opt_sqlno='" + opt_sqlno + "'";
            conn.ExecuteNonQuery(SQL);

            //修改流程狀態
            SQL = "update todo_opte set approve_scode='" + Session["scode"] + "'";
            SQL += ",resp_date=getdate()";
            SQL += ",job_status='YY'";
            SQL += " where sqlno=" + todo_sqlno + " and syscode='" + Session["Syscode"] + "' and apcode='opte31' ";
            SQL += " and dowhat='AP' and job_status='NN' ";
            conn.ExecuteNonQuery(SQL);

            //區所交辦寫回區所回稿待確認
            if (ReqVal.TryGet("br_source", "") == "br") {
                //新增bstep_ext_temp
                SQL = "insert into bstep_ext_temp(branch,seq,seq1,bstep_grade,bcase_date,last_date,case_no,opt_sqlno,your_no,in_date,in_scode,send_remark) values ";
                SQL += "('" + branch + "'," + ReqVal.TryGet("tfzb_seq", "") + ",'" + ReqVal.TryGet("tfzb_seq1", "") + "'," + ReqVal.TryGet("bstep_grade", "");
                SQL += ",'" + ReqVal.TryGet("bcase_date", "") + "','" + ReqVal.TryGet("tfy_last_date", "") + "','" + case_no + "'," + opt_sqlno;
                SQL += ",'" + ReqVal.TryGet("tfzd_your_no", "") + "',getdate(),'" + Session["scode"] + "','" + ReqVal.TryGet("send_remark", "").ToBig5() + "')";
                connB.ExecuteNonQuery(SQL);

                //抓insert後的流水號
                SQL = "SELECT SCOPE_IDENTITY() AS Current_Identity";
                object objResult1 = connB.ExecuteScalar(SQL);
                string Getbstep_sqlno = objResult1.ToString();

                //新增battach_ext_temp
                string opt_uploadfield = ReqVal.TryGet("opt_uploadfield", "");
                int sqlnum = Convert.ToInt32("0" + ReqVal.TryGet(opt_uploadfield + "_sqlnum", ""));
                for (int i = 1; i <= sqlnum; i++) {
                    //有勾選上傳區所才需寫入
                    if (ReqVal.TryGet(opt_uploadfield + "_attach_branch_" + i, "") == "BR") {
                        SQL = "insert into battach_ext_temp(seq,seq1,opt_sqlno,temp_sqlno,source,in_date,in_scode,attach_no,attach_path,doc_type,attach_desc";
                        SQL += ",attach_name,source_name,attach_size,attach_flag) values ";
                        SQL += "(" + ReqVal.TryGet("tfzb_seq", "") + ",'" + ReqVal.TryGet("tfzb_seq1", "").Trim() + "'," + opt_sqlno + "," + Getbstep_sqlno + ",'opt',getdate()";
                        SQL += ",'" + Session["scode"] + "'," + ReqVal.TryGet(opt_uploadfield + "_attach_no_" + i, "").Trim() + ",'" + ReqVal.TryGet(opt_uploadfield + "_" + i, "") + "'";
                        SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_doc_type_" + i, "") + "','" + ReqVal.TryGet(opt_uploadfield + "_desc_" + i, "").Trim().ToBig5() + "'";
                        SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_name_" + i, "").Trim().ToBig5() + "','" + ReqVal.TryGet(opt_uploadfield + "_source_name_" + i, "").Trim().ToBig5() + "'";
                        SQL += "," + ReqVal.TryGet(opt_uploadfield + "_size_" + i, "") + ",'" + ReqVal.TryGet(opt_uploadfield + "_attach_flag_" + i, "") + "')";
                        connB.ExecuteNonQuery(SQL);
                    }
                }

                //新增回稿確認流程檔
                //抓取區所承辦人員，依營洽抓取對應承辦人員
                SQL = "select a.pr_scode,b.grpid ";
                SQL += " from sysctrl.dbo.scode_group a ";
                SQL += " left outer join sysctrl.dbo.scode_group b on a.pr_scode=b.scode and a.grpclass=b.grpclass ";
                SQL += " where a.grpclass='" + branch + "' and a.scode='" + ReqVal.TryGet("F_tscode", "").Trim() + "' and a.pr_scode is not null ";
                SQL += " order by b.grpid";
                using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                    if (dr.Read()) {
                        job_scode = dr.SafeRead("pr_scode", "").Trim();
                        job_team = dr.SafeRead("grpid", "").Trim();
                    }
                }

                //新增流程控制檔
                SQL = "insert into todo_ext(syscode,apcode,from_flag,branch,seq,seq1,step_grade,case_in_scode,in_no,case_no,att_no,in_scode,in_date,dowhat,job_scode,job_team,job_status) values ";
                SQL += "('" + Session["Syscode"] + "','" + prgid + "','CGRS1','" + branch + "'," + ReqVal.TryGet("tfzb_seq", "") + ",'" + ReqVal.TryGet("tfzb_seq1", "") + "'";
                SQL += "," + ReqVal.TryGet("bstep_grade", "") + ",'" + ReqVal.TryGet("F_tscode", "").Trim() + "','" + ReqVal.TryGet("attach_in_no", "").Trim() + "'";
                SQL += ",'" + case_no + "'," + Getbstep_sqlno + ",'" + Session["scode"] + "',getdate(),'DP_RR','" + job_scode + "','" + job_team + "','NN')";
                connB.ExecuteNonQuery(SQL);
            }

            //區所交辦，通知區所已承辦完成
            if (ReqVal.TryGet("br_source", "") == "br") {
                //區所交辦，通知區所已承辦完成
                Sendmail_br(conn,opt_sqlno,job_scode);
            }

            conn.Commit();
            connB.Commit();
            //conn.RollBack();
            //connB.RollBack();

            msg = "判行成功";
            strOut.AppendLine("alert('" + msg + "');");
            if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.parent.Etop.goSearch();");
        }
        catch (Exception ex) {
            conn.RollBack();
            connB.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);
            Sys.errorLog(ex, connB.exeSQL, prgid);

            msg = "判行失敗";
            strOut.AppendLine("alert('" + msg + "');");

            throw new Exception(msg, ex);
        }
        finally {
            conn.Dispose();
            connB.Dispose();
        }
    }

    private void doEdit() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        try {
            Funcs.insert_log_table(conn, "U", prgid, "br_opte", "opt_sqlno", opt_sqlno);

            SQL = "update br_opte set pr_branch='" + ReqVal.TryGet("pr_branch", "") + "'";
            SQL += ",pr_scode='" + ReqVal.TryGet("pr_scode", "") + "'";
            SQL += ",pr_hour=" + Util.dbzero(ReqVal.TryGet("pr_hour", "0")) + "";
            SQL += ",PRY_hour=" + Util.dbzero(ReqVal.TryGet("PRY_hour", "0")) + "";
            SQL += ",AP_hour=" + Util.dbzero(ReqVal.TryGet("AP_hour", "0")) + "";
            SQL += ",pr_rs_class='" + Request["pr_rs_class"] + "'";
            SQL += ",pr_rs_code='" + Request["pr_rs_code"] + "'";
            if (ReqVal.TryGet("stat_code","") == "YY") {
                if (ReqVal.TryGet("br_source", "") == "br") {//區所交辦
                    SQL += ",send_remark='" + ReqVal.TryGet("send_remark", "").ToBig5() + "'";//回稿說明
                }
            }
            SQL += ",tran_scode='" + Session["scode"] + "'";
            SQL += ",tran_date=getdate()";
            SQL += " where opt_sqlno='" + opt_sqlno + "'";
            conn.ExecuteNonQuery(SQL);

            if (ReqVal.TryGet("br_source", "") == "opte") {//自行分案
                Funcs.insert_log_table(conn, "U", prgid, "opte_detail", "opt_sqlno", opt_sqlno);

                SQL = "update opte_detail set your_no='" + ReqVal.TryGet("your_no", "") + "'";
                SQL += ",tr_scode='" + Session["scode"] + "'";
                SQL += ",tr_date=getdate()";
                SQL += " where opt_sqlno='" + opt_sqlno + "'";
                conn.ExecuteNonQuery(SQL);
            }

            if (ReqVal.TryGet("stat_code", "") == "YY") {//已判行,未回稿確認
                //修改上傳文件
                string opt_uploadfield = ReqVal.TryGet("opt_uploadfield", "");
                int sqlnum = Convert.ToInt32("0" + ReqVal.TryGet(opt_uploadfield + "_sqlnum", ""));

                for (int i = 1; i <= sqlnum; i++) {
                    string dbflag = ReqVal.TryGet(opt_uploadfield + "_dbflag_" + i, "");
                    if (dbflag == "A") {
                        //當上傳路徑不為空的 and attach_sqlno為空的,才需要新增
                        if (ReqVal.TryGet(opt_uploadfield + "_" + i, "") != "" && ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, "") == "") {
                            SQL = "insert into attach_opte (Opt_sqlno,branch,Source";
                            SQL += ",add_date,add_scode,Attach_no,attach_path,attach_desc";
                            SQL += ",Attach_name,Attach_size,attach_flag,Mark,tran_date,tran_scode";
                            SQL += ",Source_name,doc_type,attach_branch";
                            SQL += ") values (";
                            SQL += opt_sqlno + ",'" + branch + "','PR'";
                            SQL += ",getdate(),'" + Session["scode"] + "','" + ReqVal.TryGet(opt_uploadfield + "_attach_no_" + i, "") + "'";
                            SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_" + i, "").Replace(@"\nopt\", @"\opt\").Replace(@"/nopt/", @"\opt\") + "'";//因舊系統儲存路徑為opt為了統一照舊
                            SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_desc_" + i, "").ToBig5() + "','" + ReqVal.TryGet(opt_uploadfield + "_name_" + i, "").ToBig5() + "'";
                            SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_size_" + i, "") + "','A','',getdate(),'" + Session["scode"] + "'";
                            SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_source_name_" + i, "").ToBig5() + "'";
                            SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_doc_type_" + i, "") + "'";
                            SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_attach_branch_" + i, "") + "'";
                            SQL += ")";
                            conn.ExecuteNonQuery(SQL);
                        }
                    } else if (dbflag == "U") {
                        Funcs.insert_log_table(conn, "U", prgid, "attach_opte", "attach_sqlno", ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, ""));
                        SQL = "Update attach_opte set Source='PR'";
                        SQL += ",attach_path='" + ReqVal.TryGet(opt_uploadfield + "_" + i, "").Replace(@"\nopt\", @"\opt\").Replace(@"/nopt/", @"\opt\") + "'";//因舊系統儲存路徑為opt為了統一照舊
                        SQL += ",attach_desc='" + ReqVal.TryGet(opt_uploadfield + "_desc_" + i, "").ToBig5() + "'";
                        SQL += ",attach_name='" + ReqVal.TryGet(opt_uploadfield + "_name_" + i, "").ToBig5() + "'";
                        SQL += ",attach_size='" + ReqVal.TryGet(opt_uploadfield + "_size_" + i, "") + "'";
                        SQL += ",source_name='" + ReqVal.TryGet(opt_uploadfield + "_source_name_" + i, "").ToBig5() + "'";
                        SQL += ",doc_type='" + ReqVal.TryGet(opt_uploadfield + "_doc_type_" + i, "") + "'";
                        SQL += ",attach_branch='" + ReqVal.TryGet(opt_uploadfield + "_attach_branch_" + i, "") + "'";
                        SQL += ",attach_flag='U'";
                        SQL += ",tran_date=getdate()";
                        SQL += ",tran_scode='" + Session["scode"] + "'";
                        //SQL += " OUTPUT 'U', GETDATE(),'" + Session["scode"] + "'," + Util.dbnull(prgid) + "," + "DELETED.* INTO attach_opt_log";
                        SQL += " Where attach_sqlno='" + ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, "") + "'";
                        conn.ExecuteNonQuery(SQL);
                    } else if (dbflag == "D") {
                        Funcs.insert_log_table(conn, "U", prgid, "attach_opte", "attach_sqlno", ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, ""));
                        //當attach_sqlno <> empty時,表示db有值,必須刪除data(update attach_flag = 'D')
                        if (ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, "") == "") {
                            SQL = "update attach_opte set attach_flag='D'";
                            //SQL += " OUTPUT 'U', GETDATE(),'" + Session["scode"] + "'," + Util.dbnull(prgid) + "," + "DELETED.* INTO attach_opt_log";
                            SQL += " where attach_sqlno='" + ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, "") + "'";
                            conn.ExecuteNonQuery(SQL);
                        }
                    }
                }
            }

            conn.Commit();
            //conn.RollBack();

            msg = "編修存檔成功，若有需要請通知區所重新抓取資料！";
            strOut.AppendLine("alert('" + msg + "');");
            if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.parent.Etop.goSearch();");
        }
        catch (Exception ex) {
            conn.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);

            msg = "存檔失敗！";
            strOut.AppendLine("alert('" + msg + "');");

            throw new Exception(msg, ex);
        }
        finally {
            conn.Dispose();
        }
    }

    private void doBack() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        try {
            //入br_opte_flag
            Funcs.insert_log_table(conn, "U", prgid, "br_opte", "opt_sqlno", opt_sqlno);

            SQL = "update br_opte set stat_code='NX'";
            SQL += ",ap_scode=null";
            SQL += " where opt_sqlno='" + opt_sqlno + "'";
            conn.ExecuteNonQuery(SQL);

            //修改流程狀態
            SQL = "update todo_opte set approve_scode='" + Session["scode"] + "' ";
            SQL += ",approve_desc='" + ReqVal.TryGet("Preject_reason", "").ToBig5() + "' ";
            SQL += ",resp_date=getdate() ";
            SQL += ",job_status='XX' ";
            SQL += " where sqlno='" + todo_sqlno + "' and syscode='" + Session["Syscode"] + "' and apcode='opte31'";
            SQL += " and dowhat='AP' and job_status='NN' ";
            conn.ExecuteNonQuery(SQL);

            //入流程控制檔
            string from_flag = "";
            if (case_no != "")
                from_flag = "pr";
            else
                from_flag = "pr_opt";

            SQL = " insert into todo_opte(pre_sqlno,syscode,apcode,from_flag,opt_no,opt_sqlno,branch,case_no,in_scode,in_date";
            SQL += ",dowhat,job_status) values (";
            SQL += "'" + todo_sqlno + "','" + Session["Syscode"] + "','opte22','" + from_flag + "','" + opt_no + "'," + opt_sqlno + ",'" + branch + "','" + case_no + "'";
            SQL += ",'" + Session["scode"] + "',getdate(),'PR','NN')";
            conn.ExecuteNonQuery(SQL);

            Sendmail_back(conn, opt_sqlno, ReqVal.TryGet("pr_scode", ""));

            conn.Commit();
            //conn.RollBack();

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

    //區所交辦，通知區所已承辦完成
    private void Sendmail_br(DBHelper conn, string opt_sqlno, string job_scode) {
        string Subject = "國內所商標爭救案件管理系統－出口爭救案件承辦完成通知";
        string strFrom = Session["scode"] + "@saint-island.com.tw";
        List<string> strTo = new List<string>();
        List<string> strCC = new List<string>();
        List<string> strBCC = new List<string>();
        switch (Sys.Host) {
            case "web08":
                strTo.Add(Session["scode"] + "@saint-island.com.tw");
                Subject = "(web08測試)" + Subject;
                break;
            case "web10":
                strTo.Add(Session["scode"] + "@saint-island.com.tw");
                Subject = "(web10測試)" + Subject;
                break;
            default:
                ////通知區所承辦、程序
                using (DBHelper connB = new DBHelper(Conn.OptB(branch), false).Debug(Request["chkTest"] == "TEST")) {
                    SQL = "select scode from sysctrl.dbo.scode_group where grpclass='" + branch + "' and grpid='T220' and grptype='F'";
                    object objResult1 = connB.ExecuteScalar(SQL);
                    if (objResult1 != DBNull.Value && objResult1 != null) {
                        strTo.Add(objResult1.ToString() + "@saint-island.com.tw");
                    }
                }

                strTo.Add(job_scode + "@saint-island.com.tw");
                break;
        }

        string fseq = "", in_scode = "", in_scode_name = "";
        string ap_cname = "", appl_name = "", arcase_name = "", last_date = "";
        SQL = "select Bseq,Bseq1,branch,in_scode,scode_name ";
        SQL += ",appl_name,arcase_name,Last_date ";
        SQL += "from vbr_opte where opt_sqlno='" + opt_sqlno + "'";
        using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
            if (dr.Read()) {
                fseq = Funcs.formatSeq(dr.SafeRead("Bseq", ""), dr.SafeRead("Bseq1", ""), dr.SafeRead("country", ""), dr.SafeRead("Branch", ""), Sys.GetSession("dept") + "E");
                in_scode = dr.SafeRead("in_scode", "");
                in_scode_name = dr.SafeRead("scode_name", "");
                appl_name = dr.SafeRead("appl_name", "");
                arcase_name = dr.SafeRead("arcase_name", "");
                last_date = dr.SafeRead("last_date", "");
            }
        }

        //抓取申請人名稱
        SQL = "select ap_cname from caseopte_ap where opt_sqlno=" + opt_sqlno;
        using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
            while (dr.Read()) {
                ap_cname += (ap_cname != "" ? "、" : "") + dr.SafeRead("ap_cname", "").Trim();
            }
        }

        //抓取區所名稱
        SQL = "select code_name from cust_code where code_type='obranch' and cust_code='" + branch + "'";
        object objResult = conn.ExecuteScalar(SQL);
        string branch_name = (objResult == DBNull.Value || objResult == null ? "" : objResult.ToString());

        string body = "致：" + branch_name + "出商承辦<br><br>" +
                    "【通知日期】 : " + DateTime.Today.ToShortDateString() + "<br>" +
                    "【區所案件編號】 : " + fseq + "<br>" +
                    "【營洽】 : " + in_scode + "-" + in_scode_name + "<br>" +
                    "【申請人名稱】 : " + ap_cname + "<br>" +
                    "【案件名稱】 : " + appl_name + "<br>" +
                    "【案性】 : " + arcase_name + "<br>" +
                    "【法定期限】 : <font color=red>" + last_date + "</font><br><br>";
        body += "◎請至" + branch_name + "商標網路作業系統－＞承辦作業－＞出口爭救案回稿確認作業　進行回稿確認";

        Sys.DoSendMail(Subject, body, strFrom, strTo, strCC, strBCC);
    }

    //Email通知承辦被退回
    private void Sendmail_back(DBHelper conn, string opt_sqlno, string pr_scode) {
        string Subject = "國內所商標爭救案件管理系統－爭救案件判行退回通知";
        string strFrom = Session["sc_name"] + "<" + Session["scode"] + "@saint-island.com.tw>";
        List<string> strTo = new List<string>();
        List<string> strCC = new List<string>();
        List<string> strBCC = new List<string>();
        switch (Sys.Host) {
            case "web08":
                strTo.Add(Session["scode"] + "@saint-island.com.tw");
                strCC.Add(Session["scode"] + "@saint-island.com.tw");
                Subject = Subject + "(web08測試)";
                break;
            case "web10":
                strTo.Add(Session["scode"] + "@saint-island.com.tw");
                strCC.Add(Session["scode"] + "@saint-island.com.tw");
                Subject = Subject + "(web10測試)";
                break;
            default:
                strTo.Add(pr_scode + "@saint-island.com.tw");
                break;
        }

        string fseq = "", in_scode = "", in_scode_name = "";
        string ap_cname = "", appl_name = "", arcase_name = "", last_date = "";
        SQL = "select Bseq,Bseq1,branch,country,in_scode,scode_name ";
        SQL += ",appl_name,arcase_name,Last_date ";
        SQL += "from vbr_opte where opt_sqlno='" + opt_sqlno + "'";
        using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
            if (dr.Read()) {
                fseq = Funcs.formatSeq(dr.SafeRead("Bseq", ""), dr.SafeRead("Bseq1", ""), dr.SafeRead("country", ""), dr.SafeRead("Branch", ""), Sys.GetSession("dept") + "E");
                in_scode = dr.SafeRead("in_scode", "");
                in_scode_name = dr.SafeRead("scode_name", "");
                appl_name = dr.SafeRead("appl_name", "");
                arcase_name = dr.SafeRead("arcase_name", "");
                last_date = Util.parseDBDate(dr.SafeRead("last_date", ""), "yyyy/M/d");
            }
        }

        //抓取申請人名稱
        SQL = "select ap_cname from caseopte_ap where opt_sqlno=" + opt_sqlno;
        using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
            while (dr.Read()) {
                ap_cname += (ap_cname != "" ? "、" : "") + dr.SafeRead("ap_cname", "").Trim();
            }
        }

        string body = "【區所案件編號】 : <B>" + fseq + "</B><br>" +
            "【營洽】 : <B>" + in_scode + "-" + in_scode_name + "</B><br>" +
            "【申請人】 : <B>" + ap_cname + "</B><br>" +
            "【案件名稱】 : <B>" + appl_name + "</B><br>" +
            "【案性】 : <B>" + arcase_name + "</B><br>" +
            "【法定期限】 : <font color=red><B>" + last_date + "</font></B><br>" +
            "【退件理由】 : <br>　　" + Request["Preject_reason"] + "<Br><Br><p>";
        body += "◎請至國內所商標爭救案件管理系統－＞承辦作業－＞出口案承辦暨結辦作業　進行修改並重新結辦";

        Sys.DoSendMail(Subject, body, strFrom, strTo, strCC, strBCC);
    }
</script>

<script language="javascript" type="text/javascript">
    <%Response.Write(strOut.ToString());%>
</script>
