<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Net.Mail"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "區所檢核資料複製";//功能名稱
    protected string HTProgPrefix = HttpContext.Current.Request["prgid"] ?? "";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;


    protected string SQL = "";
    protected string msg = "";

    protected string branch = "";
    protected string case_no = "";
    protected string opt_sqlno = "";
    protected string datasource = "";
    protected string seq = "";
    protected string seq1 = "";
    protected string step_grade = "";
    protected string datasource_name = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        branch = Request["branch"] ?? "";
        case_no = Request["case_no"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";
        datasource = Request["datasource"] ?? "";
        seq = Request["seq"] ?? "";
        seq1 = Request["seq1"] ?? "";
        step_grade = Request["step_grade"] ?? "";

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            doCopy(datasource.ToLower());

            this.DataBind();
        }
    }

    private void doCopy(string pdatasource) {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");

        try {
            switch (pdatasource) {
                case "attach":
                    datasource_name = "上傳文件";
                    using (DBHelper connB = new DBHelper(Conn.OptB(branch)).Debug(Request["chkTest"] == "TEST")) {
                        SQL = "select a.* from caseattach_ext a inner join case_ext b on a.in_no=b.in_no ";
                        SQL += " where b.case_no='" + case_no + "' and attach_opt='Y' ";
                        SQL += " order by a.attach_sqlno ";
                        using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                            if (dr.HasRows) {
                                //先刪除attach_opte.source=br區所上傳文件資料
                                //入attach_opte_log
                                Funcs.insert_log_table(conn, "U", prgid, "attach_opte", new Dictionary<string, string>() { { "opt_sqlno", opt_sqlno } });
                                SQL = "delete from attach_opte where opt_sqlno='" + opt_sqlno + "' and source='BR'";
                                conn.ExecuteNonQuery(SQL);
                                int k = 0;
                                while (dr.Read()) {
                                    k += 1;
                                    string add_date = dr.SafeRead("in_date", "");
                                    SQL = "insert into attach_opte(opt_sqlno,branch,add_date,add_scode,source,attach_no,attach_path,attach_desc,attach_name,source_name,attach_size";
                                    SQL += ",doc_type,attach_flag,tran_date,tran_scode) values (";
                                    SQL += opt_sqlno + ",'" + branch + "'," + Util.dbdate(add_date, "yyyy/M/d HH:mm:ss") + ",'" + dr.SafeRead("in_scode", "") + "','BR'," + k + "";
                                    SQL += ",'" + dr.SafeRead("attach_path", "").Trim() + "','" + dr.SafeRead("attach_desc", "").Trim() + "'";
                                    SQL += ",'" + dr.SafeRead("attach_name", "").Trim() + "','" + dr.SafeRead("attach_name", "").Trim() + "'";
                                    SQL += "," + dr.SafeRead("attach_size", "") + ",'','A',getdate(),'" + Session["scode"] + "')";
                                    conn.ExecuteNonQuery(SQL);
                                }
                            }
                        }
                    }
                    break;
                case "ext"://交辦案件主檔
                    datasource_name = "案件主檔";
                    using (DBHelper connB = new DBHelper(Conn.OptB(branch)).Debug(Request["chkTest"] == "TEST")) {
                        SQL = "select a.* from ext_temp a inner join case_ext b on a.in_no=b.in_no ";
                        SQL += " where b.case_no='" + case_no + "' and case_sqlno=0 ";
                        using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                            if (dr.Read()) {
                                //入opte_detail_log
                                Funcs.insert_log_table(conn, "U", prgid, "opte_detail", new Dictionary<string, string>() { { "opt_sqlno", opt_sqlno } });
                                SQL = "update opte_detail set s_mark='" + dr.SafeRead("s_mark", "").Trim() + "'";
                                SQL += ",s_type='" + dr.SafeRead("s_type", "").Trim() + "'";
                                SQL += ",class='" + dr.SafeRead("class", "").Trim() + "'";
                                SQL += ",class_count=" + Util.dbzero(dr.SafeRead("class_count", "0"));
                                SQL += ",in_date='" + dr.SafeRead("in_date", "").Trim() + "'";
                                SQL += ",apply_date=" + Util.dbnull(dr.SafeRead("apply_date", ""));
                                SQL += ",apply_no='" + dr.SafeRead("apply_no", "").Trim() + "'";
                                SQL += ",issue_date=" + Util.dbnull(dr.SafeRead("issue_date", ""));
                                SQL += ",issue_no='" + dr.SafeRead("issue_no", "").Trim() + "'";
                                SQL += ",appl_name='" + dr.SafeRead("appl_name", "").Trim() + "'";
                                SQL += ",cappl_name='" + dr.SafeRead("cappl_name", "").Trim() + "'";
                                SQL += ",eappl_name='" + dr.SafeRead("eappl_name", "").Trim() + "'";
                                SQL += ",oappl_name='" + dr.SafeRead("oappl_name", "").Trim() + "'";
                                SQL += ",word_type='" + dr.SafeRead("word_type", "").Trim() + "'";
                                SQL += ",text_class='" + dr.SafeRead("text_class", "").Trim() + "'";
                                SQL += ",text_content='" + dr.SafeRead("text_content", "").Trim() + "'";
                                SQL += ",draw='" + dr.SafeRead("draw", "").Trim() + "'";
                                SQL += ",draw_file='" + dr.SafeRead("draw_file", "").Trim() + "'";
                                SQL += ",color='" + dr.SafeRead("color", "").Trim() + "'";
                                SQL += ",color_content='" + dr.SafeRead("color_content", "").Trim() + "'";
                                SQL += ",agt_no='" + dr.SafeRead("agt_no", "").Trim() + "'";
                                SQL += ",agt_no1='" + dr.SafeRead("agt_no1", "").Trim() + "'";
                                SQL += ",end_date=" + Util.dbnull(dr.SafeRead("end_date", ""));
                                SQL += ",end_code='" + dr.SafeRead("end_code", "").Trim() + "'";
                                SQL += ",ext_term1=" + Util.dbnull(dr.SafeRead("ext_term1", ""));
                                SQL += ",ext_term2=" + Util.dbnull(dr.SafeRead("ext_term2", ""));
                                SQL += ",renewal_date=" + Util.dbnull(dr.SafeRead("renewal_date", ""));
                                SQL += ",renewal_no='" + dr.SafeRead("renewal_no", "").Trim() + "'";
                                SQL += ",renewal_agt_no='" + dr.SafeRead("renewal_agt_no", "").Trim() + "'";
                                SQL += ",renewal_agt_no1='" + dr.SafeRead("renewal_agt_no1", "").Trim() + "'";
                                SQL += ",renewal=" + Util.dbzero(dr.SafeRead("renewal", "0"));
                                SQL += ",apply_base='" + dr.SafeRead("apply_base", "").Trim() + "'";
                                SQL += ",af_date=" + Util.dbnull(dr.SafeRead("af_date", ""));
                                SQL += ",wf_date=" + Util.dbnull(dr.SafeRead("wf_date", ""));
                                SQL += ",wf_country='" + dr.SafeRead("wf_country", "").Trim() + "'";
                                SQL += ",bissue_coun='" + dr.SafeRead("bissue_coun", "").Trim() + "'";
                                SQL += ",bissue_no='" + dr.SafeRead("bissue_no", "").Trim() + "'";
                                SQL += ",bissue_date=" + Util.dbnull(dr.SafeRead("bissue_date", ""));
                                SQL += ",remark1='" + dr.SafeRead("remark1", "").Trim() + "'";
                                SQL += ",remark2='" + dr.SafeRead("remark2", "").Trim() + "'";
                                SQL += ",tr_date=getdate()";
                                SQL += ",tr_scode='" + Session["scode"] + "'";
                                SQL += ",ext_seq=" + Util.dbnull(dr.SafeRead("ext_seq", ""));
                                SQL += ",ext_seq1='" + dr.SafeRead("ext_seq1", "").Trim() + "'";
                                SQL += ",ref_seq=" + Util.dbnull(dr.SafeRead("ref_seq", ""));
                                SQL += ",ref_seq1='" + dr.SafeRead("ref_seq1", "").Trim() + "'";
                                SQL += ",mseq=" + Util.dbnull(dr.SafeRead("mseq", ""));
                                SQL += ",mseq1='" + dr.SafeRead("mseq1", "").Trim() + "'";
                                SQL += ",zold_seq=" + Util.dbnull(dr.SafeRead("zold_seq", ""));
                                SQL += ",zold_seq1='" + dr.SafeRead("zold_seq1", "").Trim() + "'";
                                SQL += ",your_no='" + dr.SafeRead("your_no", "").Trim() + "'";
                                SQL += ",tran_type='" + dr.SafeRead("tran_type", "").Trim() + "'";
                                SQL += ",ch_type='" + dr.SafeRead("ch_type", "").Trim() + "'";
                                SQL += ",ap_roles='" + dr.SafeRead("ap_roles", "").Trim() + "'";
                                SQL += ",ap_remark='" + dr.SafeRead("ap_remark", "").Trim() + "'";
                                SQL += ",main_flag='" + dr.SafeRead("main_flag", "").Trim() + "'";
                                SQL += ",remarkb='" + dr.SafeRead("remarkb", "").Trim() + "'";
                                SQL += " where opt_sqlno=" + opt_sqlno;
                                conn.ExecuteNonQuery(SQL);
                            }
                        }
                        //商品檔
                        SQL = "select a.* from caseext_good a inner join case_ext b on a.in_no=b.in_no ";
                        SQL += " where b.case_no='" + case_no + "'";
                        SQL += " order by a.sqlno ";
                        using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                            if (dr.HasRows) {
                                //入caseopte_good_log
                                Funcs.insert_log_table(conn, "U", prgid, "caseopte_good", new Dictionary<string, string>() { { "opt_sqlno", opt_sqlno } });
                                SQL = "delete from caseopte_good where opt_sqlno=" + opt_sqlno;
                                conn.ExecuteNonQuery(SQL);
                                while (dr.Read()) {
                                    SQL = "insert into caseopte_good(opt_sqlno,Branch,Case_no,class";
                                    SQL += ",ext_goodname,ext_goodcount,ext_egoodname,ext_egoodcount,goodcount,tr_date,tr_scode,mark";
                                    SQL += ") values (";
                                    SQL += opt_sqlno + ",'" + branch + "','" + case_no + "','" + dr.SafeRead("class", "").Trim() + "'";
                                    SQL += ",'" + dr.SafeRead("ext_goodname", "").Trim() + "'," + Util.dbzero(dr.SafeRead("ext_goodcount", "0")) + "";
                                    SQL += ",'" + dr.SafeRead("ext_egoodname", "").Trim() + "'," + Util.dbzero(dr.SafeRead("ext_egoodcount", "0")) + "";
                                    SQL += "," + Util.dbzero(dr.SafeRead("goodcount", "0")) + ",getdate(),'" + Session["scode"] + "','" + dr.SafeRead("mark", "").Trim() + "')";
                                    conn.ExecuteNonQuery(SQL);
                                }
                            }
                        }
                        //優先權檔
                        SQL = "select a.* from caseext_prior a inner join case_ext b on a.in_no=b.in_no";
                        SQL += " where b.case_no='" + case_no + "'";
                        SQL += " order by a.sqlno ";
                        using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                            if (dr.HasRows) {
                                //入caseopte_prior_log
                                Funcs.insert_log_table(conn, "U", prgid, "caseopte_prior", new Dictionary<string, string>() { { "opt_sqlno", opt_sqlno } });
                                SQL = "delete from caseopte_prior where opt_sqlno=" + opt_sqlno;
                                conn.ExecuteNonQuery(SQL);
                                while (dr.Read()) {
                                    SQL = "insert into caseopte_prior(opt_sqlno,Branch,Case_no,prior_flag";
                                    SQL += ",prior_date,prior_no,prior_country,tr_date,tr_scode,mark";
                                    SQL += ") values (";
                                    SQL += opt_sqlno + ",'" + branch + "','" + case_no + "','" + dr.SafeRead("prior_flag", "").Trim() + "'";
                                    SQL += "," + Util.dbnull(dr.SafeRead("prior_date", "")) + ",'" + dr.SafeRead("prior_no", "").Trim() + "'";
                                    SQL += ",'" + dr.SafeRead("prior_country", "").Trim() + "',getdate(),'" + Session["scode"] + "','" + dr.SafeRead("mark", "").Trim() + "')";
                                    conn.ExecuteNonQuery(SQL);
                                }
                            }
                        }
                    }
                    break;
                case "apcust"://交辦申請人檔
                    datasource_name = "案件申請人檔";
                    using (DBHelper connB = new DBHelper(Conn.OptB(branch)).Debug(Request["chkTest"] == "TEST")) {
                        SQL = "select a.* from caseext_apcust a inner join case_ext b on a.in_no=b.in_no";
                        SQL += " where b.case_no='" + case_no + "'";
                        SQL += " order by a.sqlno ";
                        using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                            if (dr.HasRows) {
                                //入caseopte_ap_log
                                Funcs.insert_log_table(conn, "U", prgid, "caseopte_ap", new Dictionary<string, string>() { { "opt_sqlno", opt_sqlno } });
                                SQL = "delete from caseopte_ap where opt_sqlno=" + opt_sqlno;
                                conn.ExecuteNonQuery(SQL);
                                while (dr.Read()) {
                                    SQL = "insert into caseopte_ap(opt_sqlno,Branch,Case_no,apsqlno,apcust_no";
                                    SQL += ",ap_cname,ap_cname1,ap_cname2,ap_sql,ap_ename,ap_ename1,ap_ename2";
                                    SQL += ",ap_zip,ap_addr1,ap_addr2,ap_eaddr1,ap_eaddr2,ap_eaddr3,ap_eaddr4,tran_date,tran_scode,mark";
                                    SQL += ") values (";
                                    SQL += opt_sqlno + ",'" + branch + "','" + case_no + "'," + dr.SafeRead("apsqlno", "").Trim() + ",'" + dr.SafeRead("apcust_no", "").Trim() + "'";
                                    SQL += ",'" + dr.SafeRead("ap_cname", "").Trim() + "','" + dr.SafeRead("ap_cname1", "").Trim() + "','" + dr.SafeRead("ap_cname2", "").Trim() + "'";
                                    SQL += "," + Util.dbnull(dr.SafeRead("ap_sql", "")) + ",'" + dr.SafeRead("ap_ename", "").Trim() + "','" + dr.SafeRead("ap_ename1", "").Trim() + "'";
                                    SQL += ",'" + dr.SafeRead("ap_ename2", "").Trim() + "','" + dr.SafeRead("ap_zip", "").Trim() + "','" + dr.SafeRead("ap_addr1", "").Trim() + "'";
                                    SQL += ",'" + dr.SafeRead("ap_addr2", "").Trim() + "','" + dr.SafeRead("ap_eaddr1", "").Trim() + "','" + dr.SafeRead("ap_eaddr2", "").Trim() + "'";
                                    SQL += ",'" + dr.SafeRead("ap_eaddr3", "").Trim() + "','" + dr.SafeRead("ap_eaddr4", "").Trim() + "'";
                                    SQL += ",getdate(),'" + Session["scode"] + "','" + dr.SafeRead("mark", "").Trim() + "')";
                                    conn.ExecuteNonQuery(SQL);
                                }
                            }
                        }
                    }
                    break;
                case "cust"://客戶及聯絡人
                    datasource_name = "案件客戶及聯絡人檔";
                    using (DBHelper connB = new DBHelper(Conn.OptB(branch)).Debug(Request["chkTest"] == "TEST")) {
                        SQL = "select a.cust_area,a.cust_seq,a.att_sql from case_ext a ";
                        SQL += " where a.case_no='" + case_no + "'";
                        using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                            if (dr.Read()) {
                                //入case_opte_log
                                Funcs.insert_log_table(conn, "U", prgid, "case_opte", new Dictionary<string, string>() { { "opt_sqlno", opt_sqlno } });
                                SQL = "update case_opte set cust_area='" + dr.SafeRead("cust_area", "").Trim() + "'";
                                SQL += ",cust_seq=" + dr.SafeRead("cust_seq", "");
                                SQL += ",att_sql=" + dr.SafeRead("att_sql", "");
                                SQL += " where opt_sqlno=" + opt_sqlno;
                                conn.ExecuteNonQuery(SQL);
                            }
                        }
                    }
                    break;
                case "remark"://交辦說明及法定期限
                    datasource_name = "交辦說明";
                    using (DBHelper connB = new DBHelper(Conn.OptB(branch)).Debug(Request["chkTest"] == "TEST")) {
                        SQL = "select a.remark1,a.remarkb from ext_temp a inner join case_ext b on a.in_no=b.in_no ";
                        SQL += " where b.case_no='" + case_no + "' and a.case_sqlno=0 ";
                        using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                            if (dr.Read()) {
                                //入opte_detail_log
                                Funcs.insert_log_table(conn, "U", prgid, "opte_detail", new Dictionary<string, string>() { { "opt_sqlno", opt_sqlno } });
                                SQL = "update opte_detail set cust_area='" + dr.SafeRead("remark1", "").Trim() + "'";
                                SQL += ",remarkb='" + dr.SafeRead("remarkb", "").Trim() + "'";
                                SQL += " where opt_sqlno=" + opt_sqlno;
                                conn.ExecuteNonQuery(SQL);
                            }
                        }
                    }
                    break;
                case "seq_ext"://案件主檔for自行新增分案，重新抓取案件主檔及申請人檔
                    datasource_name = "案件主檔及申請人檔";
                    using (DBHelper connB = new DBHelper(Conn.OptB(branch)).Debug(Request["chkTest"] == "TEST")) {
                        SQL = "select cust_area,cust_seq,att_sql,class,class_count,apply_date,apply_no,issue_date,issue_no";
                        SQL = ",appl_name,agt_no,agt_no1,renewal_agt_no,renewal_agt_no1,ext_seq,ext_seq1,your_no,scode from ext ";
                        SQL += " where seq=" + seq + " and seq1='" + seq1 + "'";
                        using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                            if (dr.Read()) {
                                //修改case_opte營洽及客戶資料
                                //入case_opte_log
                                Funcs.insert_log_table(conn, "U", prgid, "case_opte", new Dictionary<string, string>() { { "opt_sqlno", opt_sqlno } });
                                SQL = "update case_opte set in_scode='" + dr.SafeRead("scode", "").Trim() + "'";
                                SQL += ",cust_area='" + dr.SafeRead("cust_area", "").Trim() + "'";
                                SQL += ",cust_seq=" + dr.SafeRead("cust_seq", "");
                                SQL += ",att_sql=" + dr.SafeRead("att_sql", "");
                                SQL += " where opt_sqlno=" + opt_sqlno;
                                conn.ExecuteNonQuery(SQL);

                                //修改opte_detail案件主檔資料
                                //入opte_detail_log
                                Funcs.insert_log_table(conn, "U", prgid, "opte_detail", new Dictionary<string, string>() { { "opt_sqlno", opt_sqlno } });
                                SQL = "update opte_detail set class='" + dr.SafeRead("class", "").Trim() + "'";
                                SQL += ",class_count=" + Util.dbzero(dr.SafeRead("class_count", "0"));
                                SQL += ",apply_date=" + Util.dbnull(dr.SafeRead("apply_date", ""));
                                SQL += ",apply_no='" + dr.SafeRead("apply_no", "").Trim() + "'";
                                SQL += ",issue_date=" + Util.dbnull(dr.SafeRead("issue_date", ""));
                                SQL += ",issue_no='" + dr.SafeRead("issue_no", "").Trim() + "'";
                                SQL += ",appl_name='" + dr.SafeRead("appl_name", "").Trim() + "'";
                                SQL += ",agt_no='" + dr.SafeRead("agt_no", "").Trim() + "'";
                                SQL += ",agt_no1='" + dr.SafeRead("agt_no1", "").Trim() + "'";
                                SQL += ",renewal_agt_no='" + dr.SafeRead("renewal_agt_no", "").Trim() + "'";
                                SQL += ",renewal_agt_no1='" + dr.SafeRead("renewal_agt_no1", "").Trim() + "'";
                                SQL += ",ext_seq=" + Util.dbnull(dr.SafeRead("ext_seq", ""));
                                SQL += ",ext_seq1='" + dr.SafeRead("ext_seq1", "").Trim() + "'";
                                SQL += ",your_no='" + dr.SafeRead("your_no", "").Trim() + "'";
                                SQL += " where opt_sqlno=" + opt_sqlno;
                                conn.ExecuteNonQuery(SQL);
                            }
                        }

                        //修改申請人   
                        SQL = "select a.* from ext_apcust a ";
                        SQL += " where a.seq=" + seq + " and a.seq1='" + seq1 + "'";
                        SQL += " order by a.sqlno ";
                        using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                            if (dr.Read()) {
                                //入caseopte_ap_log
                                Funcs.insert_log_table(conn, "U", prgid, "caseopte_ap", new Dictionary<string, string>() { { "opt_sqlno", opt_sqlno } });
                                SQL = "delete from caseopte_ap where opt_sqlno=" + opt_sqlno;
                                conn.ExecuteNonQuery(SQL);
                                while (dr.Read()) {
                                    SQL = "insert into caseopte_ap(opt_sqlno,Branch,apsqlno,apcust_no";
                                    SQL += ",ap_cname,ap_cname1,ap_cname2,ap_sql,ap_ename,ap_ename1,ap_ename2";
                                    SQL += ",ap_zip,ap_addr1,ap_addr2,ap_eaddr1,ap_eaddr2,ap_eaddr3,ap_eaddr4,tran_date,tran_scode,mark";
                                    SQL += ") values (";
                                    SQL += opt_sqlno + ",'" + branch + "'," + dr.SafeRead("apsqlno", "").Trim() + ",'" + dr.SafeRead("apcust_no", "").Trim() + "'";
                                    SQL += ",'" + dr.SafeRead("ap_cname", "").Trim() + "','" + dr.SafeRead("ap_cname1", "").Trim() + "','" + dr.SafeRead("ap_cname2", "").Trim() + "'";
                                    SQL += "," + Util.dbnull(dr.SafeRead("ap_sql", "")) + ",'" + dr.SafeRead("ap_ename", "").Trim() + "','" + dr.SafeRead("ap_ename1", "").Trim() + "'";
                                    SQL += ",'" + dr.SafeRead("ap_ename2", "").Trim() + "','" + dr.SafeRead("ap_zip", "").Trim() + "','" + dr.SafeRead("ap_addr1", "").Trim() + "'";
                                    SQL += ",'" + dr.SafeRead("ap_addr2", "").Trim() + "','" + dr.SafeRead("ap_eaddr1", "").Trim() + "','" + dr.SafeRead("ap_eaddr2", "").Trim() + "'";
                                    SQL += ",'" + dr.SafeRead("ap_eaddr3", "").Trim() + "','" + dr.SafeRead("ap_eaddr4", "").Trim() + "'";
                                    SQL += ",getdate(),'" + Session["scode"] + "','" + dr.SafeRead("mark", "").Trim() + "')";
                                    conn.ExecuteNonQuery(SQL);
                                }
                            }
                        }
                    }
                    break;
            }

            //conn.Commit();
            conn.RollBack();

            msg = "區所" + datasource_name + "資料複製成功！";
        }
        catch (Exception ex) {
            conn.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);

            msg = "區所" + datasource_name + "資料複製失敗！！";

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
        if (!(window.parent.parent.tt === undefined)) {
            window.parent.parent.tt.rows = "100%,0%";
        }else{
            window.opener.this_init();
            window.close();
        }
    }
</script>
