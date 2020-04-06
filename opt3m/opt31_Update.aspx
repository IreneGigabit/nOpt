<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Net.Mail"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "爭救案承辦作業確認‧-入檔";//功能名稱
    protected string HTProgPrefix = "opt31";//程式檔名前綴
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
    string Reportp = "";
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
    
    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        case_no=(Request["case_no"]??"").Trim();
        branch=(Request["Branch"]??"").Trim();
        opt_no=(Request["opt_no"]??"").Trim();
        opt_sqlno=(Request["opt_sqlno"]??"").Trim();
        submitTask=(Request["submittask"]??"").Trim();
        end_flag=(Request["End_flag"]??"").Trim();
        sameap_flag=(Request["sameap_flag"]??"").Trim();
        //交辦資料
        Arcase=(Request["tfy_Arcase"]??"").Trim();
   
        ReqVal=Request.Form.ToDictionary();
        
        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            if (submitTask == "U" || submitTask == "P") {//承辦結辦/列印
                doConfirm();
            } else if (submitTask == "B") {//退回分案
                doBack();
            }
            
            this.DataBind();
        }
    }

    private void doConfirm() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        try {
            Del_opttranlist(conn);//刪除案件異動明細檔

            if (Arcase == "DO1" || Arcase == "DI1" || Arcase == "DR1") {//申請異議，評定，廢止
                string P1mod_pul = "N", P2mod_pul = "N", P3mod_pul = "N", P4mod_pul = "N";
                if (ReqVal["P1mod_pul_new_no"] != "" || ReqVal["P1mod_pul_ncname1"] != "" || ReqVal["P1mod_pul_mod_type"] != "") {
                    P1mod_pul = "Y";
                    insert_opttranlist(conn, "mod_pul", "1");
                }
                if (ReqVal["P2mod_pul_mod_type"] != "") {
                    P2mod_pul = "Y";
                    insert_opttranlist(conn, "mod_pul", "2");
                }
                if (ReqVal["P3mod_pul_new_no"] != "" || ReqVal["P3mod_pul_mod_dclass"] != "" || ReqVal["P3mod_pul_mod_type"] != "") {
                    P3mod_pul = "Y";
                    insert_opttranlist(conn, "mod_pul", "3");
                }
                if (ReqVal["P4mod_pul_new_no"] != "" || ReqVal["P4mod_pul_mod_dclass"] != "" || ReqVal["P4mod_pul_ncname1"] != "" || ReqVal["P4mod_pul_mod_type"] != "") {
                    P4mod_pul = "Y";
                    insert_opttranlist(conn, "mod_pul", "4");
                }
                if (P1mod_pul == "Y" || P2mod_pul == "Y" || P3mod_pul == "Y" || P4mod_pul == "Y") {
                    Pmod_pul = "Y";
                }

                if (ReqVal["Pmod_dmt_ncname1"] != "" || ReqVal["Pmod_dmt_ncname2"] != "" || ReqVal["Pmod_dmt_nename1"] != "" || ReqVal["mod_dmt_nename2"] != "" || ReqVal["Pmod_dmt_ncrep"] != "") {
                    Pmod_dmt = "Y";
                    insert_opttranlist(conn, "mod_dmt", "");
                }
                Request.Form.ToDictionary();

                if (Arcase == "DR1") {//廢止
                    //2012/10/5因應2012/7/1新申請書增加商標違法說明
                    if (ReqVal["Pmod_claim1_ncname1"] != "") {
                        Pmod_claim1 = "Y";
                        insert_opttranlist(conn, "mod_claim1", "");
                    }
                    if (ReqVal["Pmod_class_ncname1"] != "" || ReqVal["Pmod_class_ncname2"] != "" || ReqVal["Pmod_class_nename1"] != "" || ReqVal["Pmod_class_nename2"] != "" || ReqVal["Pmod_class_ncrep"] != "") {
                        Pmod_class = "Y";
                        insert_opttranlist(conn, "mod_class", "");
                    }
                    //被異議人資料
                    if (ReqVal["DR1_apnum"] == "") ReqVal["DR1_apnum"] = "0";
                    if (Convert.ToInt32(ReqVal["DR1_apnum"]) > 0) {
                        for (int k = 1; k <= Convert.ToInt32(ReqVal["DR1_apnum"]); k++) {
                            SQL = "INSERT INTO opt_tranlist(opt_sqlno,branch,case_no,mod_field,ncname1,ncname2,ncrep,nzip,naddr1,naddr2";
                            SQL += ") VALUES('" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + ",'mod_ap',";
                            SQL += "'" + ReqVal["ttg1_mod_ap_ncname1_" + k] + "','" + ReqVal["ttg1_mod_ap_ncname2_" + k] + "',";
                            SQL += "'" + ReqVal["ttg1_mod_ap_ncrep_" + k] + "','" + ReqVal["ttg1_mod_ap_nzip_" + k] + "',";
                            SQL += "'" + ReqVal["ttg1_mod_ap_naddr1_" + k] + "','" + ReqVal["ttg1_mod_ap_naddr2_" + k] + "')";
                            conn.ExecuteNonQuery(SQL);
                        }
                        Pmod_ap = "Y";
                    }
                } else if (Arcase == "DI1") {//評定
                    if (ReqVal["Pmod_aprep_mod_count"] != "") {
                        Pmod_aprep = "Y";
                        insert_opttranlist(conn, "mod_aprep", ReqVal["Pmod_aprep_mod_count"]);
                    }
                    //被異議人資料
                    if (ReqVal["DI1_apnum"] == "") ReqVal["DI1_apnum"] = "0";
                    if (Convert.ToInt32(ReqVal["DI1_apnum"]) > 0) {
                        for (int k = 1; k <= Convert.ToInt32(ReqVal["DI1_apnum"]); k++) {
                            SQL = "INSERT INTO opt_tranlist(opt_sqlno,branch,case_no,mod_field,ncname1,ncname2,ncrep,nzip,naddr1,naddr2";
                            SQL += ") VALUES('" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + ",'mod_ap',";
                            SQL += "'" + ReqVal["ttg3_mod_ap_ncname1_" + k] + "','" + ReqVal["ttg3_mod_ap_ncname2_" + k] + "',";
                            SQL += "'" + ReqVal["ttg3_mod_ap_ncrep_" + k] + "','" + ReqVal["ttg3_mod_ap_nzip_" + k] + "',";
                            SQL += "'" + ReqVal["ttg3_mod_ap_naddr1_" + k] + "','" + ReqVal["ttg3_mod_ap_naddr2_" + k] + "')";
                            conn.ExecuteNonQuery(SQL);
                        }
                        Pmod_ap = "Y";
                    }
                } else if (Arcase == "DO1") {//異議
                    if (ReqVal["Pmod_aprep_mod_count"] != "") {
                        Pmod_aprep = "Y";
                        insert_opttranlist(conn, "mod_aprep", ReqVal["Pmod_aprep_mod_count"]);
                    }
                    //被異議人資料
                    if (ReqVal["DO1_apnum"] == "") ReqVal["DO1_apnum"] = "0";
                    if (Convert.ToInt32(ReqVal["DO1_apnum"] ?? "0") > 0) {
                        for (int k = 1; k <= Convert.ToInt32(ReqVal["DO1_apnum"]); k++) {
                            SQL = "INSERT INTO opt_tranlist(opt_sqlno,branch,case_no,mod_field,ncname1,ncname2,ncrep,nzip,naddr1,naddr2";
                            SQL += ") VALUES('" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + ",'mod_ap',";
                            SQL += "'" + ReqVal["ttg2_mod_ap_ncname1_" + k] + "','" + ReqVal["ttg2_mod_ap_ncname2_" + k] + "',";
                            SQL += "'" + ReqVal["ttg2_mod_ap_ncrep_" + k] + "','" + ReqVal["ttg2_mod_ap_nzip_" + k] + "',";
                            SQL += "'" + ReqVal["ttg2_mod_ap_naddr1_" + k] + "','" + ReqVal["ttg2_mod_ap_naddr2_" + k] + "')";
                            conn.ExecuteNonQuery(SQL);
                        }
                        Pmod_ap = "Y";
                    }
                }
                update_optdetail(conn);
                Update_opttran(conn);

            } else if (Arcase == "DE1" || Arcase == "AD7" || Arcase == "DE2" || Arcase == "AD8") {//申請聽證,出席聽證
                update_optdetail(conn);
                Update_opttran(conn);
                if (Arcase == "DE1" || Arcase == "AD7") {
                    //新增對照當事人資料
                    if (ReqVal["de1_apnum"] == "") ReqVal["de1_apnum"] = "0";
                    for (int k = 1; k <= Convert.ToInt32(ReqVal["de1_apnum"] ?? "0"); k++) {
                        SQL = "insert into opt_tranlist(opt_sqlno,branch,case_no,mod_field,ncname1,naddr1) values (";
                        SQL += "'" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + ",'mod_client','" + ReqVal["tfr4_ncname1_" + k] + "','" + ReqVal["tfr4_naddr1_" + k] + "')";
                        conn.ExecuteNonQuery(SQL);
                    }
                }
            } else {
                update_optdetail(conn);
                Update_opttran(conn);
            }

            upin_attach_opt(opt_sqlno, "PR");
	        update_bropt(conn);
	        if(end_flag=="Y"){//結辦
		        update_bropt_end(conn);
            }
	        if(sameap_flag=="Y"){
		        update_bropt_ap(conn);
	        }
        
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

    private void doBack() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        try {
            SQL = "update br_opt set in_scode=null ";
            SQL += ",in_date=null ";
            SQL += ",ctrl_date=null ";
            SQL += ",pr_branch=null ";
            SQL += ",pr_scode=null ";
            SQL += ",br_remark=null ";
            SQL += ",stat_code='RX' ";
            SQL += " where opt_sqlno='" + opt_sqlno + "'";
            conn.ExecuteNonQuery(SQL);

            //抓前一todo的流水號
            string pre_sqlno = "";
            SQL = "Select max(sqlno) as maxsqlno from todo_opt ";
            SQL += "where syscode='" + Session["Syscode"] + "' ";
            SQL += "and apcode='opt21' and opt_sqlno='" + opt_sqlno + "' ";
            SQL += "and dowhat='PR' ";
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    pre_sqlno = dr.SafeRead("maxsqlno", "");
                }
            }

            SQL = "update todo_opt set approve_scode='" + Session["scode"] + "' ";
            SQL += ",approve_desc='" + ReqVal["Preject_reason"] + "' ";
            SQL += ",resp_date=getdate() ";
            SQL += ",job_status='XX' ";
            SQL += " where apcode='opt21' and opt_sqlno='" + opt_sqlno + "' ";
            SQL += " and dowhat='PR' and syscode='" + Session["Syscode"] + "' ";
            SQL += " and sqlno='" + pre_sqlno + "'";
            conn.ExecuteNonQuery(SQL);

            //入流程控制檔
            SQL = " insert into todo_opt(pre_sqlno,syscode,apcode,opt_sqlno,Branch";
            SQL += ",case_no,in_scode,in_date,dowhat,job_status) values (";
            SQL += "'" + pre_sqlno + "','" + Session["syscode"] + "','opt11'," + opt_sqlno + ",'" + branch + "'";
            SQL += "'" + case_no + "','" + Session["scode"] + "',getdate(),'BR','NN')";
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
    
    
    //交辦內容opt_detail
    private void update_optdetail(DBHelper conn) {
        SQL = "Update opt_detail set ";
        SQL += " Cappl_name=" + Util.dbnull(ReqVal["PCappl_name"]) + "";
        SQL += ",Eappl_name=" + Util.dbnull(ReqVal["PEappl_name"]) + "";
        SQL += ",Jappl_name=" + Util.dbnull(ReqVal["PJappl_name"]) + "";
        SQL += ",Zappl_name1=" + Util.dbnull(ReqVal["PZappl_name1"]) + "";
        SQL += ",Draw=" + Util.dbnull(ReqVal["PDraw"]) + "";
        SQL += ",Remark3='" + ReqVal["Remark3"] + "'";
        SQL += ",Mark=" + Util.dbnull(ReqVal["PMark"]) + "";
        SQL += " where opt_sqlno='" + opt_sqlno + "'";
        conn.ExecuteNonQuery(SQL);
    }

    //案件異動檔opt_tran
    private void Update_opttran(DBHelper conn) {
        SQL = "Update opt_tran set ";
        SQL += " agt_no1=" + Util.dbnull(ReqVal["Pagt_no1"]) + "";
        SQL += ",mod_ap=" + Util.dbnull(ReqVal["Pmod_ap"]) + "";
        SQL += ",mod_aprep=" + Util.dbnull(ReqVal["Pmod_aprep"]) + "";
        SQL += ",mod_claim1=" + Util.dbnull(ReqVal["Pmod_claim1"]) + "";
        SQL += ",mod_pul=" + Util.dbnull(ReqVal["Pmod_pul"]) + "";
        SQL += ",mod_dmt=" + Util.dbnull(ReqVal["Pmod_dmt"]) + "";
        SQL += ",mod_class=" + Util.dbnull(ReqVal["Pmod_class"]) + "";
        SQL += ",tran_remark1='" + ReqVal["Ptran_remark1"] + "'";
        SQL += ",tran_remark2='" + ReqVal["Ptran_remark2"] + "'";
        SQL += ",tran_remark3='" + ReqVal["Ptran_remark3"] + "'";
        SQL += ",tran_remark4='" + ReqVal["Ptran_remark4"] + "'";
        SQL += ",other_item='" + ReqVal["Pother_item"] + "'";
        SQL += ",other_item1='" + ReqVal["Pother_item1"] + "'";
        SQL += ",other_item2='" + ReqVal["Pother_item2"] + "'";
        SQL += ",tran_mark='" + ReqVal["Ptran_mark"] + "'";
        SQL += " where opt_sqlno='" + opt_sqlno + "'";
        conn.ExecuteNonQuery(SQL);
    }
       
    //案件異動名細檔opt_tranlist
    private void insert_opttranlist(DBHelper conn, string Pfield, string pno) {
        if (Pfield == "mod_ap") {
        } else if (Pfield == "mod_pul") {
            if (pno == "1") {
                SQL = "insert into opt_tranlist(opt_sqlno,Branch,Case_no";
                SQL += ",mod_field,new_no,ncname1,mod_type";
                SQL += ") values (";
                SQL += "'" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + "";
                SQL += ",'" + Pfield + "','" + ReqVal["P1mod_pul_new_no"] + "','" + ReqVal["P1mod_pul_ncname1"] + "'";
                SQL += ",'" + ReqVal["P1mod_pul_mod_type"] + "')";
            } else if (pno == "2") {
                SQL = "insert into opt_tranlist(opt_sqlno,Branch,Case_no";
                SQL += ",mod_field,mod_type";
                SQL += ") values (";
                SQL += "'" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + "";
                SQL += ",'" + Pfield + "','" + ReqVal["P2mod_pul_mod_type"] + "')";
            } else if (pno == "3") {
                SQL = "insert into opt_tranlist(opt_sqlno,Branch,Case_no";
                SQL += ",mod_field,mod_type,new_no,mod_dclass";
                SQL += ") values (";
                SQL += "'" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + "";
                SQL += ",'" + Pfield + "','" + ReqVal["P3mod_pul_mod_type"] + "','" + ReqVal["P3mod_pul_new_no"] + "','" + ReqVal["P3mod_pul_mod_dclass"] + "')";
            } else if (pno == "4") {
                SQL = "insert into opt_tranlist(opt_sqlno,Branch,Case_no";
                SQL += ",mod_field,mod_type,new_no,mod_dclass,ncname1";
                SQL += ") values (";
                SQL += "'" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + "";
                SQL += ",'" + Pfield + "','" + ReqVal["P4mod_pul_mod_type"] + "','" + ReqVal["P4mod_pul_new_no"] + "','" + ReqVal["P4mod_pul_mod_dclass"] + "'";
                SQL += ",'" + ReqVal["P4mod_pul_ncname1"] + "')";
            }
            conn.ExecuteNonQuery(SQL);
        } else if (Pfield == "mod_claim1") {
            SQL = "insert into opt_tranlist(opt_sqlno,Branch,Case_no";
            SQL += ",mod_field,ncname1";
            SQL += ") values (";
            SQL += "'" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + "";
            SQL += ",'" + Pfield + "','" + ReqVal["Pmod_claim1_ncname1"] + "')";
            conn.ExecuteNonQuery(SQL);
        } else if (Pfield == "mod_aprep") {
            for (int i = 1; i <= Convert.ToInt32(pno); i++) {
                SQL = "insert into opt_tranlist(opt_sqlno,Branch,Case_no";
                SQL += ",mod_field,mod_count,ncname1,new_no";
                SQL += ") values (";
                SQL += "'" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + "";
                SQL += ",'" + Pfield + "'," + Util.dbnull(pno) + ",'" + ReqVal["Pmod_aprep_ncname1" + i] + "'";
                SQL += ",'" + ReqVal["Pmod_aprep_new_no" + i] + "'";
                conn.ExecuteNonQuery(SQL);
            }
        } else if (Pfield == "mod_dmt") {
            SQL = "insert into opt_tranlist(opt_sqlno,Branch,Case_no";
            SQL += ",mod_field,ncname1,ncname2,nename1,nename2";
            SQL += ",ncrep) values (";
            SQL += "'" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + "";
            SQL += ",'" + Pfield + "','" + ReqVal["Pmod_dmt_ncname1"] + "','" + ReqVal["Pmod_dmt_ncname2"] + "'";
            SQL += ",'" + ReqVal["Pmod_dmt_nename1"] + "','" + ReqVal["Pmod_dmt_nename2"] + "','" + ReqVal["Pmod_dmt_ncrep"] + "')";
            conn.ExecuteNonQuery(SQL);
        } else if (Pfield == "mod_class") {
            SQL = "insert into opt_tranlist(opt_sqlno,Branch,Case_no";
            SQL += ",mod_field,ncname1,ncname2,nename1,nename2";
            SQL += ",ncrep) values (";
            SQL += "'" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + "";
            SQL += ",'" + Pfield + "','" + ReqVal["Pmod_class_ncname1"] + "','" + ReqVal["Pmod_class_ncname2"] + "'";
            SQL += ",'" + ReqVal["Pmod_class_nename1"] + "','" + ReqVal["Pmod_class_nename2"] + "','" + ReqVal["Pmod_class_ncrep"] + "')";
            conn.ExecuteNonQuery(SQL);
        }
    }
	
    private void Del_opttranlist(DBHelper conn) {
        string SQL = "Delete opt_tranlist where opt_sqlno='" + opt_sqlno + "'";
        conn.ExecuteNonQuery(SQL);
    }

    private void update_bropt(DBHelper conn) {
        SQL = "update br_opt set pr_hour=" + Util.dbzero(ReqVal["pr_hour"]) + "";
        SQL += ",pr_per=" + Util.dbzero(ReqVal["pr_per"]) + "";
        SQL += ",pr_date=" + Util.dbnull(ReqVal["pr_date"]) + "";
        SQL += ",pr_remark='" + ReqVal["pr_remark"] + "'";
        SQL += ",send_dept=" + Util.dbnull(ReqVal["send_dept"]) + "";
        SQL += ",mp_date=" + Util.dbnull(ReqVal["mp_date"]) + "";
        SQL += ",GS_date=" + Util.dbnull(ReqVal["GS_date"]) + "";
        SQL += ",Send_cl=" + Util.dbnull(ReqVal["Send_cl"]) + "";
        SQL += ",Send_cl1=" + Util.dbnull(ReqVal["Send_cl1"]) + "";
        SQL += ",Send_Sel=" + Util.dbnull(ReqVal["Send_Sel"]) + "";
        SQL += ",rs_type=" + Util.dbnull(ReqVal["rs_type"]) + "";
        SQL += ",rs_class=" + Util.dbnull(ReqVal["rs_class"]) + "";
        SQL += ",rs_code=" + Util.dbnull(ReqVal["rs_code"]) + "";
        SQL += ",act_code=" + Util.dbnull(ReqVal["act_code"]) + "";
        SQL += ",RS_detail='" + ReqVal["RS_detail"] + "'";
        SQL += ",Fees=" + Util.dbzero(ReqVal["Send_Fees"]) + "";
        SQL += ",tran_scode='" + Session["scode"] + "'";
        SQL += ",tran_date=getdate()";
        SQL += " where opt_sqlno='" + opt_sqlno + "'";
        conn.ExecuteNonQuery(SQL);
    }

    private void update_bropt_end(DBHelper conn) {
        string Job_Scode = "";
        if (ReqVal["ap_type"] == "1")
            Job_Scode = ReqVal["job_scode1"];
        else if (ReqVal["ap_type"] == "2")
            Job_Scode = ReqVal["job_scode2"];

        SQL = "update br_opt set stat_code='NY'";
        SQL += ",rs_agt_no='" + ReqVal["rs_agt_no"] + "'";
        SQL += ",AP_Scode='" + Job_Scode + "'";
        SQL += ",tran_date=getdate()";
        SQL += " where opt_sqlno='" + opt_sqlno + "'";
        conn.ExecuteNonQuery(SQL);

        //抓前一todo的流水號
        string pre_sqlno = "";
        SQL = "Select max(sqlno) as maxsqlno from todo_opt where syscode='" + Session["Syscode"] + "'";
        SQL += " and apcode='opt21' and opt_sqlno='" + opt_sqlno + "'";
        SQL += " and dowhat='PR'";
        using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
            if (dr.Read()) {
                pre_sqlno = dr.SafeRead("maxsqlno", "");
            }
        }

        SQL = "update todo_opt set approve_scode='" + Session["scode"] + "'";
        SQL += ",resp_date=getdate()";
        SQL += ",job_status='YY'";
        SQL += " where apcode='opt21' and opt_sqlno='" + opt_sqlno + "'";
        SQL += " and dowhat='PR' and syscode='" + Session["Syscode"] + "'";
        SQL += " and sqlno=" + pre_sqlno;
        conn.ExecuteNonQuery(SQL);

        //入流程控制檔
        SQL = " insert into todo_opt(pre_sqlno,syscode,apcode,opt_sqlno,branch,case_no,in_scode,in_date";
        SQL += ",dowhat,job_scode,job_status) values (";
        SQL += "'" + pre_sqlno + "','" + Session["Syscode"] + "','" + prgid + "'," + opt_sqlno + ",'" + branch + "','" + case_no + "'";
        SQL += ",'" + Session["scode"] + "',getdate(),'AP','" + Job_Scode + "','NN')";
        conn.ExecuteNonQuery(SQL);
    }
        
    //當承辦與判行同一人時執行這段
    private void update_bropt_ap(DBHelper conn) {
	    SQL="update br_opt set PRY_hour="+Util.dbzero(ReqVal["PRY_hour"]) + "";
	    SQL+=",AP_hour="+Util.dbzero(ReqVal["AP_hour"]) + "";
	    SQL+=",send_dept="+Util.dbnull(ReqVal["send_dept"]) + "";
	    SQL+=",mp_date="+Util.dbnull(ReqVal["mp_date"]) + "";
	    SQL+=",GS_date="+Util.dbnull(ReqVal["GS_date"]) + "";
	    SQL+=",Send_cl="+Util.dbnull(ReqVal["Send_cl"]) + "";
	    SQL+=",Send_cl1="+Util.dbnull(ReqVal["Send_cl1"]) + "";
	    SQL+=",Send_Sel="+Util.dbnull(ReqVal["Send_Sel"]) + "";
	    SQL+=",rs_type="+Util.dbnull(ReqVal["rs_type"]) + "";
	    SQL+=",rs_class="+Util.dbnull(ReqVal["rs_class"]) + "";
	    SQL+=",rs_code="+Util.dbnull(ReqVal["rs_code"]) + "";
	    SQL+=",act_code="+Util.dbnull(ReqVal["act_code"]) + "";
	    SQL+=",RS_detail='"+ReqVal["RS_detail"] + "'";
	    SQL+=",Fees="+Util.dbzero(ReqVal["Send_Fees"]) + "";
	    SQL+=",ap_date='"+DateTime.Today.ToShortDateString()+"'";
	    SQL+=",ap_remark='"+ReqVal["ap_remark"] + "'";
        if (ReqVal["score_flag"]=="Y")
	    IF trim(request("score_flag"))="Y" then
		    SQL+=",score_flag="+Util.dbnull(ReqVal["score_flag"]) + "";
		    SQL+=",score="+Util.dbzero(ReqVal["Score"]) + "";
	    Else
		    SQL+=",score_flag='N'"
		    SQL+=",score=0"
	    End IF
	    SQL+=",remark='"+ReqVal["opt_remark"] + "'";
	    SQL+=",stat_code='YY'"
	    SQL+=",tran_scode='" + Session["scode"] + "'"
	    SQL+=",tran_date=getdate()"
	    SQL+=" where opt_sqlno='" + opt_sqlno + "'";
            conn.ExecuteNonQuery(SQL);
	
	    SQL = "Select max(sqlno) as maxsqlno from todo_opt where syscode='"+ Session["Syscode"] +"'"
	    SQL+= " and apcode='opt31' and opt_sqlno='" + opt_sqlno + "'";
	    SQL+= " and dowhat='AP'"
	    RSreg.Open qSQL,Conn,1,1
	    IF not RSreg.EOF then
		    pre_sqlno=trim(RSreg("maxsqlno"))
	    End IF
	    RSreg.close

	    SQL="update todo_opt set approve_scode='" + Session["scode"] + "'"
	    SQL+= ",resp_date=getdate()"
	    SQL+= ",job_status='YY'"
	    SQL+= " where apcode='opt31' and opt_sqlno='" + opt_sqlno + "'";
	    SQL+= " and dowhat='AP' and syscode='"+ Session["Syscode"] +"'"
	    SQL+= " and sqlno=" + pre_sqlno;
            conn.ExecuteNonQuery(SQL);

	    //入流程控制檔
	    SQL = " insert into todo_opt(pre_sqlno,syscode,apcode,opt_sqlno,branch,case_no,in_scode,in_date"
	    SQL+=",dowhat,job_status) values ("
	    SQL+="'" + pre_sqlno+"','"+ Session["Syscode"] +"','opt22'," + opt_sqlno + ",'"+ branch +"','"+ case_no +"'";
	    SQL+=",'" + Session["scode"] + "',getdate(),'MG_GS','NN')" ;
        conn.ExecuteNonQuery(SQL);
    }  
</script>

<script language="javascript" type="text/javascript">
    alert("<%#msg%>");
    if ("<%#Request["chkTest"]%>" != "TEST") {
        window.parent.Etop.goSearch();
    }
</script>
