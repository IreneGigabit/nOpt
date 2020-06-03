<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
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

            if (submitTask == "U" || submitTask == "P") {//承辦結辦/列印
                doConfirm();
            } else if (submitTask == "B") {//退回分案
                doBack();
            }

            if (sameap_flag == "Y" && ReqVal.TryGet("send_dept", "") == "L") {
                MailWin();//轉法律處作業出現outlook通知
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
                if (ReqVal.TryGet("P1mod_pul_new_no", "") != "" || ReqVal.TryGet("P1mod_pul_ncname1", "") != "" || ReqVal.TryGet("P1mod_pul_mod_type", "") != "") {
                    P1mod_pul = "Y";
                    insert_opttranlist(conn, "mod_pul", "1");
                }
                if (ReqVal.TryGet("P2mod_pul_mod_type", "") != "") {
                    P2mod_pul = "Y";
                    insert_opttranlist(conn, "mod_pul", "2");
                }
                if (ReqVal.TryGet("P3mod_pul_new_no", "") != "" || ReqVal.TryGet("P3mod_pul_mod_dclass", "") != "" || ReqVal.TryGet("P3mod_pul_mod_type", "") != "") {
                    P3mod_pul = "Y";
                    insert_opttranlist(conn, "mod_pul", "3");
                }
                if (ReqVal.TryGet("P4mod_pul_new_no", "") != "" || ReqVal.TryGet("P4mod_pul_mod_dclass", "") != "" || ReqVal.TryGet("P4mod_pul_ncname1", "") != "" || ReqVal.TryGet("P4mod_pul_mod_type", "") != "") {
                    P4mod_pul = "Y";
                    insert_opttranlist(conn, "mod_pul", "4");
                }
                if (P1mod_pul == "Y" || P2mod_pul == "Y" || P3mod_pul == "Y" || P4mod_pul == "Y") {
                    Pmod_pul = "Y";
                }

                if (ReqVal.TryGet("Pmod_dmt_ncname1", "") != "" || ReqVal.TryGet("Pmod_dmt_ncname2", "") != ""
                    || ReqVal.TryGet("Pmod_dmt_nename1", "") != "" || ReqVal.TryGet("mod_dmt_nename2", "") != "" || ReqVal.TryGet("Pmod_dmt_ncrep", "") != "") {
                    Pmod_dmt = "Y";
                    insert_opttranlist(conn, "mod_dmt", "");
                }

                if (Arcase == "DR1") {//廢止
                    //2012/10/5因應2012/7/1新申請書增加商標違法說明
                    if (ReqVal.TryGet("Pmod_claim1_ncname1", "") != "") {
                        Pmod_claim1 = "Y";
                        insert_opttranlist(conn, "mod_claim1", "");
                    }
                    if (ReqVal.TryGet("Pmod_class_ncname1", "") != "" || ReqVal.TryGet("Pmod_class_ncname2", "") != "" || ReqVal.TryGet("Pmod_class_nename1", "") != "" || ReqVal.TryGet("Pmod_class_nename2", "") != "" || ReqVal.TryGet("Pmod_class_ncrep", "") != "") {
                        Pmod_class = "Y";
                        insert_opttranlist(conn, "mod_class", "");
                    }
                    //被異議人資料
                    int DR1_apnum = Convert.ToInt32("0" + ReqVal.TryGet("DR1_apnum", "0"));
                    if (DR1_apnum > 0) {
                        for (int k = 1; k <= DR1_apnum; k++) {
                            SQL = "INSERT INTO opt_tranlist(opt_sqlno,branch,case_no,mod_field,ncname1,ncname2,ncrep,nzip,naddr1,naddr2";
                            SQL += ") VALUES('" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + ",'mod_ap',";
                            SQL += "'" + ReqVal.TryGet("ttg1_mod_ap_ncname1_" + k, "").ToBig5() + "','" + ReqVal.TryGet("ttg1_mod_ap_ncname2_" + k, "").ToBig5() + "',";
                            SQL += "'" + ReqVal.TryGet("ttg1_mod_ap_ncrep_" + k, "").ToBig5() + "','" + ReqVal.TryGet("ttg1_mod_ap_nzip_" + k, "") + "',";
                            SQL += "'" + ReqVal.TryGet("ttg1_mod_ap_naddr1_" + k, "").ToBig5() + "','" + ReqVal.TryGet("ttg1_mod_ap_naddr2_" + k, "").ToBig5() + "')";
                            conn.ExecuteNonQuery(SQL);
                        }
                        Pmod_ap = "Y";
                    }
                } else if (Arcase == "DI1") {//評定
                    if (ReqVal.TryGet("Pmod_aprep_mod_count", "") != "") {
                        Pmod_aprep = "Y";
                        insert_opttranlist(conn, "mod_aprep", ReqVal.TryGet("Pmod_aprep_mod_count", ""));
                    }
                    //被異議人資料
                    int DI1_apnum = Convert.ToInt32("0" + ReqVal.TryGet("DI1_apnum", "0"));
                    if (DI1_apnum > 0) {
                        for (int k = 1; k <= DI1_apnum; k++) {
                            SQL = "INSERT INTO opt_tranlist(opt_sqlno,branch,case_no,mod_field,ncname1,ncname2,ncrep,nzip,naddr1,naddr2";
                            SQL += ") VALUES('" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + ",'mod_ap',";
                            SQL += "'" + ReqVal.TryGet("ttg3_mod_ap_ncname1_" + k, "").ToBig5() + "','" + ReqVal.TryGet("ttg3_mod_ap_ncname2_" + k, "").ToBig5() + "',";
                            SQL += "'" + ReqVal.TryGet("ttg3_mod_ap_ncrep_" + k, "").ToBig5() + "','" + ReqVal.TryGet("ttg3_mod_ap_nzip_" + k, "") + "',";
                            SQL += "'" + ReqVal.TryGet("ttg3_mod_ap_naddr1_" + k, "").ToBig5() + "','" + ReqVal.TryGet("ttg3_mod_ap_naddr2_" + k, "").ToBig5() + "')";
                            conn.ExecuteNonQuery(SQL);
                        }
                        Pmod_ap = "Y";
                    }
                } else if (Arcase == "DO1") {//異議
                    if (ReqVal.TryGet("Pmod_aprep_mod_count", "") != "") {
                        Pmod_aprep = "Y";
                        insert_opttranlist(conn, "mod_aprep", ReqVal.TryGet("Pmod_aprep_mod_count", ""));
                    }
                    //被異議人資料
                    int DO1_apnum = Convert.ToInt32("0" + ReqVal.TryGet("DO1_apnum", "0"));
                    if (DO1_apnum > 0) {
                        for (int k = 1; k <= DO1_apnum; k++) {
                            SQL = "INSERT INTO opt_tranlist(opt_sqlno,branch,case_no,mod_field,ncname1,ncname2,ncrep,nzip,naddr1,naddr2";
                            SQL += ") VALUES('" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + ",'mod_ap',";
                            SQL += "'" + ReqVal.TryGet("ttg2_mod_ap_ncname1_" + k, "").ToBig5() + "','" + ReqVal.TryGet("ttg2_mod_ap_ncname2_" + k, "").ToBig5() + "',";
                            SQL += "'" + ReqVal.TryGet("ttg2_mod_ap_ncrep_" + k, "").ToBig5() + "','" + ReqVal.TryGet("ttg2_mod_ap_nzip_" + k, "") + "',";
                            SQL += "'" + ReqVal.TryGet("ttg2_mod_ap_naddr1_" + k, "").ToBig5() + "','" + ReqVal.TryGet("ttg2_mod_ap_naddr2_" + k, "").ToBig5() + "')";
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
                    int de1_apnum = Convert.ToInt32("0" + ReqVal.TryGet("de1_apnum", "0"));
                    for (int k = 1; k <= de1_apnum; k++) {
                        SQL = "insert into opt_tranlist(opt_sqlno,branch,case_no,mod_field,ncname1,naddr1) values (";
                        SQL += "'" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + ",'mod_client','" + ReqVal.TryGet("tfr4_ncname1_" + k, "").ToBig5() + "','" + ReqVal.TryGet("tfr4_naddr1_" + k, "").ToBig5() + "')";
                        conn.ExecuteNonQuery(SQL);
                    }
                }
            } else {
                update_optdetail(conn);
                Update_opttran(conn);
            }

            upin_attach_opt(conn, opt_sqlno, "PR");
            update_bropt(conn);
            if (end_flag == "Y") {//結辦
                update_bropt_end(conn);
            }
            if (sameap_flag == "Y") {
                update_bropt_ap(conn);
            }

            //取得列印程式
            using (DBHelper connB = new DBHelper(Conn.OptB(branch), false).Debug(Request["chkTest"] == "TEST")) {
                SQL = "select reportp from code_br e where rs_code='" + Arcase + "' ";
                SQL += " AND e.dept = 'T' AND e.cr = 'Y' and e.no_code = 'N' ";
                SQL += " and e.rs_type='" + ReqVal.TryGet("rs_type", "") + "' and e.prt_code not in ('null','ZZ','D9Z','D3')";
                using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                    if (dr.Read()) {
                        reportp = dr.SafeRead("reportp", "").Trim();
                    }
                }
            }

            //conn.Commit();
            conn.RollBack();

            if (submitTask == "U") {
                if (end_flag == "Y") {
                    if (sameap_flag == "Y")
                        msg = "結案暨判行成功";
                    else
                        msg = "結案成功";
                    strOut.AppendLine("alert('" + msg + "');");
                    if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.parent.Etop.goSearch();");
                } else {
                    if (ReqVal.TryGet("progid", "") == "opt31") {
                        msg = "編修存檔完成";
                        strOut.AppendLine("alert('" + msg + "');");
                    }
                    string thref = "opt31Edit.aspx?prgid=opt31&opt_sqlno=" + opt_sqlno + "&opt_no=" + opt_no + "&branch=" + branch + "&case_no=" + case_no + "&arcase=" + Arcase;
                    if (ReqVal.TryGet("progid", "") != "") {
                        thref = "opt31Edit.aspx?prgid=" + ReqVal.TryGet("progid", "") + "&opt_sqlno=" + opt_sqlno + "&opt_no=" + opt_no + "&branch=" + branch + "&case_no=" + case_no + "&arcase=" + Arcase;
                    }
                    if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.location.href='" + thref + "';");
                }
            } else if (submitTask == "P") {
                if (end_flag == "Y") {
                    strOut.AppendLine("window.parent.Etop.goSearch();");
                } else {
                    string thref = "opt31Edit.aspx?prgid=opt31&opt_sqlno=" + opt_sqlno + "&opt_no=" + opt_no + "&branch=" + branch + "&case_no=" + case_no + "&arcase=" + Arcase;
                    if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.location.href='" + thref + "';");

                    if (reportp == "") {
                        strOut.AppendLine("alert('無列印程式！！');");
                    } else {
                        string prt_name = "../opt_print/Print_" + reportp + ".aspx?opt_sqlno=" + opt_sqlno + "&prgid=" + prgid + "&Branch=" + branch;
                        strOut.AppendLine("window.open('" + prt_name + "');\n");
                    }
                }
            }
        }
        catch (Exception ex) {
            conn.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);

            if (submitTask == "U") {
                if (end_flag == "Y") {
                    if (sameap_flag == "Y")
                        msg = "結案暨判行失敗";
                    else
                        msg = "結案失敗";
                } else {
                    msg = "存檔失敗";
                }
            } else if (submitTask == "P") {
                msg = "列印失敗";
            }
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
            SQL += ",approve_desc='" + ReqVal.TryGet("Preject_reason", "").ToBig5() + "' ";
            SQL += ",resp_date=getdate() ";
            SQL += ",job_status='XX' ";
            SQL += " where apcode='opt21' and opt_sqlno='" + opt_sqlno + "' ";
            SQL += " and dowhat='PR' and syscode='" + Session["Syscode"] + "' ";
            SQL += " and sqlno='" + pre_sqlno + "'";
            conn.ExecuteNonQuery(SQL);

            //入流程控制檔
            SQL = " insert into todo_opt(pre_sqlno,syscode,apcode,opt_sqlno,Branch";
            SQL += ",case_no,in_scode,in_date,dowhat,job_status) values (";
            SQL += " '" + pre_sqlno + "','" + Session["syscode"] + "','opt11'," + opt_sqlno + ",'" + branch + "'";
            SQL += ",'" + case_no + "','" + Session["scode"] + "',getdate(),'BR','NN')";
            conn.ExecuteNonQuery(SQL);

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

    //交辦內容opt_detail
    private void update_optdetail(DBHelper conn) {
        SQL = "Update opt_detail set ";
        SQL += " Cappl_name=" + Util.dbnull(ReqVal.TryGet("PCappl_name", null)).ToBig5() + "";
        SQL += ",Eappl_name=" + Util.dbnull(ReqVal.TryGet("PEappl_name", null)).ToBig5() + "";
        SQL += ",Jappl_name=" + Util.dbnull(ReqVal.TryGet("PJappl_name", null)).ToBig5() + "";
        SQL += ",Zappl_name1=" + Util.dbnull(ReqVal.TryGet("PZappl_name1", null)).ToBig5() + "";
        SQL += ",Draw=" + Util.dbnull(ReqVal.TryGet("PDraw", null)) + "";
        SQL += ",Remark3='" + ReqVal.TryGet("Remark3", "").ToBig5() + "'";
        SQL += ",Mark=" + Util.dbnull(ReqVal.TryGet("PMark", null)).ToBig5() + "";
        SQL += " where opt_sqlno='" + opt_sqlno + "'";
        conn.ExecuteNonQuery(SQL);
    }

    //案件異動檔opt_tran
    private void Update_opttran(DBHelper conn) {
        SQL = "Update opt_tran set ";
        SQL += " agt_no1=" + Util.dbnull(ReqVal.TryGet("Pagt_no1", null)) + "";
        SQL += ",mod_ap=" + Util.dbnull(Pmod_ap) + "";
        SQL += ",mod_aprep=" + Util.dbnull(Pmod_aprep) + "";
        SQL += ",mod_claim1=" + Util.dbnull(Pmod_claim1) + "";
        SQL += ",mod_pul=" + Util.dbnull(Pmod_pul) + "";
        SQL += ",mod_dmt=" + Util.dbnull(Pmod_dmt) + "";
        SQL += ",mod_class=" + Util.dbnull(Pmod_class) + "";
        SQL += ",tran_remark1='" + ReqVal.TryGet("Ptran_remark1", "").ToBig5() + "'";
        SQL += ",tran_remark2='" + ReqVal.TryGet("Ptran_remark2", "").ToBig5() + "'";
        SQL += ",tran_remark3='" + ReqVal.TryGet("Ptran_remark3", "").ToBig5() + "'";
        SQL += ",tran_remark4='" + ReqVal.TryGet("Ptran_remark4", "").ToBig5() + "'";
        SQL += ",other_item='" + ReqVal.TryGet("Pother_item", "") + "'";
        SQL += ",other_item1='" + ReqVal.TryGet("Pother_item1", "") + "'";
        SQL += ",other_item2='" + ReqVal.TryGet("Pother_item2", "") + "'";
        SQL += ",tran_mark='" + ReqVal.TryGet("Ptran_mark", "").ToBig5() + "'";
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
                SQL += ",'" + Pfield + "','" + ReqVal.TryGet("P1mod_pul_new_no", "") + "','" + ReqVal.TryGet("P1mod_pul_ncname1", "").ToBig5() + "'";
                SQL += ",'" + ReqVal.TryGet("P1mod_pul_mod_type", "") + "')";
            } else if (pno == "2") {
                SQL = "insert into opt_tranlist(opt_sqlno,Branch,Case_no";
                SQL += ",mod_field,mod_type";
                SQL += ") values (";
                SQL += "'" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + "";
                SQL += ",'" + Pfield + "','" + ReqVal.TryGet("P2mod_pul_mod_type", "") + "')";
            } else if (pno == "3") {
                SQL = "insert into opt_tranlist(opt_sqlno,Branch,Case_no";
                SQL += ",mod_field,mod_type,new_no,mod_dclass";
                SQL += ") values (";
                SQL += "'" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + "";
                SQL += ",'" + Pfield + "','" + ReqVal.TryGet("P3mod_pul_mod_type", "") + "','" + ReqVal.TryGet("P3mod_pul_new_no", "") + "','" + ReqVal.TryGet("P3mod_pul_mod_dclass", "") + "')";
            } else if (pno == "4") {
                SQL = "insert into opt_tranlist(opt_sqlno,Branch,Case_no";
                SQL += ",mod_field,mod_type,new_no,mod_dclass,ncname1";
                SQL += ") values (";
                SQL += "'" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + "";
                SQL += ",'" + Pfield + "','" + ReqVal.TryGet("P4mod_pul_mod_type", "") + "','" + ReqVal.TryGet("P4mod_pul_new_no", "") + "','" + ReqVal.TryGet("P4mod_pul_mod_dclass", "") + "'";
                SQL += ",'" + ReqVal.TryGet("P4mod_pul_ncname1", "").ToBig5() + "')";
            }
            conn.ExecuteNonQuery(SQL);
        } else if (Pfield == "mod_claim1") {
            SQL = "insert into opt_tranlist(opt_sqlno,Branch,Case_no";
            SQL += ",mod_field,ncname1";
            SQL += ") values (";
            SQL += "'" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + "";
            SQL += ",'" + Pfield + "','" + ReqVal.TryGet("Pmod_claim1_ncname1", "").ToBig5() + "')";
            conn.ExecuteNonQuery(SQL);
        } else if (Pfield == "mod_aprep") {
            for (int i = 1; i <= Convert.ToInt32(pno); i++) {
                SQL = "insert into opt_tranlist(opt_sqlno,Branch,Case_no";
                SQL += ",mod_field,mod_count,ncname1,new_no";
                SQL += ") values (";
                SQL += "'" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + "";
                SQL += ",'" + Pfield + "'," + Util.dbnull(pno) + ",'" + ReqVal.TryGet("Pmod_aprep_ncname1" + i, "").ToBig5() + "'";
                SQL += ",'" + ReqVal.TryGet("Pmod_aprep_new_no" + i, "") + "'";
                conn.ExecuteNonQuery(SQL);
            }
        } else if (Pfield == "mod_dmt") {
            SQL = "insert into opt_tranlist(opt_sqlno,Branch,Case_no";
            SQL += ",mod_field,ncname1,ncname2,nename1,nename2";
            SQL += ",ncrep) values (";
            SQL += "'" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + "";
            SQL += ",'" + Pfield + "','" + ReqVal.TryGet("Pmod_dmt_ncname1", "").ToBig5() + "','" + ReqVal.TryGet("Pmod_dmt_ncname2", "").ToBig5() + "'";
            SQL += ",'" + ReqVal.TryGet("Pmod_dmt_nename1", "").ToBig5() + "','" + ReqVal.TryGet("Pmod_dmt_nename2", "").ToBig5() + "','" + ReqVal.TryGet("Pmod_dmt_ncrep", "").ToBig5() + "')";
            conn.ExecuteNonQuery(SQL);
        } else if (Pfield == "mod_class") {
            SQL = "insert into opt_tranlist(opt_sqlno,Branch,Case_no";
            SQL += ",mod_field,ncname1,ncname2,nename1,nename2";
            SQL += ",ncrep) values (";
            SQL += "'" + opt_sqlno + "','" + branch + "'," + Util.dbnull(case_no) + "";
            SQL += ",'" + Pfield + "','" + ReqVal.TryGet("Pmod_class_ncname1", "").ToBig5() + "','" + ReqVal.TryGet("Pmod_class_ncname2", "").ToBig5() + "'";
            SQL += ",'" + ReqVal.TryGet("Pmod_class_nename1", "").ToBig5() + "','" + ReqVal.TryGet("Pmod_class_nename2", "").ToBig5() + "','" + ReqVal.TryGet("Pmod_class_ncrep", "").ToBig5() + "')";
            conn.ExecuteNonQuery(SQL);
        }
    }

    private void Del_opttranlist(DBHelper conn) {
        string SQL = "Delete opt_tranlist where opt_sqlno='" + opt_sqlno + "'";
        conn.ExecuteNonQuery(SQL);
    }

    private void update_bropt(DBHelper conn) {
        SQL = "update br_opt set pr_hour=" + Util.dbzero(ReqVal.TryGet("pr_hour", "0")) + "";
        SQL += ",pr_per=" + Util.dbzero(ReqVal.TryGet("pr_per","0")) + "";
        SQL += ",pr_date=" + Util.dbnull(ReqVal.TryGet("pr_date",null)) + "";
        SQL += ",pr_remark='" + ReqVal.TryGet("pr_remark", "").ToBig5() + "'";
        SQL += ",send_dept=" + Util.dbnull(ReqVal.TryGet("send_dept",null)) + "";
        SQL += ",mp_date=" + Util.dbnull(ReqVal.TryGet("mp_date",null)) + "";
        SQL += ",GS_date=" + Util.dbnull(ReqVal.TryGet("GS_date",null)) + "";
        SQL += ",Send_cl=" + Util.dbnull(ReqVal.TryGet("Send_cl",null)) + "";
        SQL += ",Send_cl1=" + Util.dbnull(ReqVal.TryGet("Send_cl1",null)) + "";
        SQL += ",Send_Sel=" + Util.dbnull(ReqVal.TryGet("Send_Sel",null)) + "";
        SQL += ",rs_type=" + Util.dbnull(ReqVal.TryGet("rs_type",null)) + "";
        SQL += ",rs_class=" + Util.dbnull(ReqVal.TryGet("rs_class",null)) + "";
        SQL += ",rs_code=" + Util.dbnull(ReqVal.TryGet("rs_code",null)) + "";
        SQL += ",act_code=" + Util.dbnull(ReqVal.TryGet("act_code",null)) + "";
        SQL += ",RS_detail='" + ReqVal.TryGet("RS_detail","").ToBig5() + "'";
        SQL += ",Fees=" + Util.dbzero(ReqVal.TryGet("Send_Fees","0")) + "";
        SQL += ",tran_scode='" + Session["scode"] + "'";
        SQL += ",tran_date=getdate()";
        SQL += " where opt_sqlno='" + opt_sqlno + "'";
        conn.ExecuteNonQuery(SQL);
    }

    private void update_bropt_end(DBHelper conn) {
        string Job_Scode = "";
        if (ReqVal.TryGet("ap_type", "") == "1")
            Job_Scode = ReqVal.TryGet("job_scode1", "");
        else if (ReqVal.TryGet("ap_type", "") == "2")
            Job_Scode = ReqVal.TryGet("job_scode2", "");

        SQL = "update br_opt set stat_code='NY'";
        SQL += ",rs_agt_no='" + ReqVal.TryGet("rs_agt_no", "") + "'";
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
        SQL += " '" + pre_sqlno + "','" + Session["Syscode"] + "','" + prgid + "'," + opt_sqlno + ",'" + branch + "','" + case_no + "'";
        SQL += ",'" + Session["scode"] + "',getdate(),'AP','" + Job_Scode + "','NN')";
        conn.ExecuteNonQuery(SQL);
    }

    //當承辦與判行同一人時執行這段
    private void update_bropt_ap(DBHelper conn) {
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
        SQL += ",RS_detail='" + ReqVal.TryGet("RS_detail", "").ToBig5() + "'";
        SQL += ",Fees=" + Util.dbzero(ReqVal.TryGet("Send_Fees", "0")) + "";
        SQL += ",ap_date='" + DateTime.Today.ToShortDateString() + "'";
        SQL += ",ap_remark='" + ReqVal.TryGet("ap_remark", "").ToBig5() + "'";
        if (ReqVal.TryGet("score_flag", "") == "Y") {
            SQL += ",score_flag=" + Util.dbnull(ReqVal.TryGet("score_flag", null)) + "";
            SQL += ",score=" + Util.dbzero(ReqVal.TryGet("Score", "0")) + "";
        } else {
            SQL += ",score_flag='N'";
            SQL += ",score=0";
        }
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
        SQL += " '" + pre_sqlno + "','" + Session["Syscode"] + "','opt22'," + opt_sqlno + ",'" + branch + "','" + case_no + "'";
        SQL += ",'" + Session["scode"] + "',getdate(),'MG_GS','NN')";
        conn.ExecuteNonQuery(SQL);
    }

    //處理上傳圖檔的部份
    private void upin_attach_opt(DBHelper conn, string popt_sqlno, string psource) {
        //欄位名稱
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
                    SQL += popt_sqlno + ",'" + psource + "'";
                    SQL += ",'" + DateTime.Today.ToShortDateString() + "','" + Session["scode"] + "'";
                    SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_attach_no_" + i, "") + "','" + ReqVal.TryGet(opt_uploadfield + "_" + i, "").Replace(@"\nopt\", @"\opt\") + "'";//因舊系統儲存路徑為opt為了統一照舊
                    SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_desc_" + i, "").ToBig5() + "','" + ReqVal.TryGet(opt_uploadfield + "_name_" + i, "").ToBig5() + "'";
                    SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_size_" + i, "") + "','A','',getdate(),'" + Session["scode"] + "'";
                    SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_source_name_" + i, "").ToBig5() + "'";
                    SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_doc_type_" + i, "") + "'";
                    SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_doc_flag_" + i, "") + "'";
                    SQL += ")";
                    conn.ExecuteNonQuery(SQL);
                }
            } else if (dbflag == "U") {
                Funcs.insert_log_table(conn, "U", prgid, "attach_opt", "attach_sqlno", ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, "") );
                SQL = "Update attach_opt set Source='" + psource + "'";
                SQL += ",attach_path='" + ReqVal.TryGet(opt_uploadfield + "_" + i, "").Replace(@"\nopt\", @"\opt\") + "'";//因舊系統儲存路徑為opt為了統一照舊
                SQL += ",attach_desc='" + ReqVal.TryGet(opt_uploadfield + "_desc_" + i, "").ToBig5() + "'";
                SQL += ",attach_name='" + ReqVal.TryGet(opt_uploadfield + "_name_" + i, "").ToBig5() + "'";
                SQL += ",attach_size='" + ReqVal.TryGet(opt_uploadfield + "_size_" + i, "") + "'";
                SQL += ",source_name='" + ReqVal.TryGet(opt_uploadfield + "_source_name_" + i, "").ToBig5() + "'";
                SQL += ",doc_type='" + ReqVal.TryGet(opt_uploadfield + "_doc_type_" + i, "") + "'";
                SQL += ",doc_flag='" + ReqVal.TryGet(opt_uploadfield + "_doc_flag_" + i, "") + "'";
                SQL += ",attach_flag='U'";
                SQL += ",tran_date=getdate()";
                SQL += ",tran_scode='" + Session["scode"] + "'";
                //SQL += " OUTPUT 'U', GETDATE(),'" + Session["scode"] + "'," + Util.dbnull(prgid) + "," + "DELETED.* INTO attach_opt_log";
                SQL += " Where attach_sqlno='" + ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, "") + "'";
                conn.ExecuteNonQuery(SQL);
            } else if (dbflag == "D") {
                Funcs.insert_log_table(conn, "U", prgid, "attach_opt",  "attach_sqlno", ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, "") );
                //當attach_sqlno <> empty時,表示db有值,必須刪除data(update attach_flag = 'D')
                if (ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, "") == "") {
                    SQL = "update attach_opt set attach_flag='D'";
                    //SQL += " OUTPUT 'U', GETDATE(),'" + Session["scode"] + "'," + Util.dbnull(prgid) + "," + "DELETED.* INTO attach_opt_log";
                    SQL += " where attach_sqlno='" + ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, "") + "'";
                    conn.ExecuteNonQuery(SQL);
                }
            }
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
</script>

<script language="javascript" type="text/javascript">
    <%Response.Write(strOut.ToString());%>
</script>
