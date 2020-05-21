<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "爭救案區所交辦資料複製";//功能名稱
    protected string HTProgPrefix = HttpContext.Current.Request["prgid"] ?? "";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string SQL = "";
    protected string strConnB = "";
    protected string msg = "";

    protected string qBranch = "";
    protected string qSeq = "";
    protected string qSeq1 = "";
    protected string qCase_no = "";
    protected string qArcase = "";
    protected string qopt_sqlno = "";
    protected string qopt_no = "";
    protected string in_no = "";
    protected string in_scode = "";
    protected string qBr = "";
    protected string CItem = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        strConnB = Conn.OptB(Request["branch"]);

        qBranch = (Request["qBranch"] ?? "").Trim();
        qSeq = (Request["qSeq"] ?? "").Trim();
        qSeq1 = (Request["qSeq1"] ?? "").Trim();
        qCase_no = (Request["qCase_no"] ?? "").Trim();
        qArcase = (Request["qArcase"] ?? "").Trim();
        qopt_sqlno = (Request["qopt_sqlno"] ?? "").Trim();
        qopt_no = (Request["qopt_no"] ?? "").Trim();
        in_no=(Request["in_no"] ?? "").Trim();
        in_scode=(Request["in_scode"] ?? "").Trim();
        qBr = (Request["qBr"] ?? "").Trim();//N代表區所交辦　//Y代表自行分案
        CItem = (Request["CItem"] ?? "").Trim();

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            doCopy();

            this.DataBind();
        }
    }

    private void doCopy() {
        string[] arrItem = CItem.Split(',');
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");

        try {
            log_update(conn);
            foreach (string i in arrItem) {
                switch (i) {
                    case "vcustlist"://案件客戶、聯絡人
                        SQL = "update case_opt Set cust_area=b.cust_area,cust_seq=b.cust_seq,att_sql=b.att_sql";
                        SQL += " from case_opt as a ," + Sys.tdbname(qBranch) + ".case_dmt as b ";
                        SQL += " where a.case_no=b.case_no and a.case_no='" + qCase_no + "' and a.branch='" + qBranch + "'";
                        conn.ExecuteNonQuery(SQL);
                        break;
                    case "apcust"://案件申請人
                        SQL = "update opt_detail Set apsqlno=b.apsqlno,ap_cname=b.ap_cname,ap_cname1=b.ap_cname1";
                        SQL += ",ap_cname2=b.ap_cname2,ap_ename=b.ap_ename,ap_ename1=b.ap_ename1,ap_ename2=b.ap_ename2";
                        SQL += " from opt_detail as a ," + Sys.tdbname(qBranch) + ".dmt_temp as b ";
                        SQL += " where a.case_no='" + qCase_no + "' and a.branch='" + qBranch + "' and b.in_no='" + in_no + "'";
                        conn.ExecuteNonQuery(SQL);

                        //2008/7/22因應共同申請人修改，先刪除caseopt_ap,再抓取區所dmt_temp_ap更新
                        SQL = "delete from caseopt_ap where opt_sqlno='" + qopt_sqlno + "'";
                        conn.ExecuteNonQuery(SQL);

                        //2011/1/27因應申請人序號修改，
                        SQL = " insert into caseopt_ap (opt_sqlno,case_no,branch,apsqlno,server_flag,apcust_no,";
                        SQL += "ap_cname,ap_cname1,ap_cname2,ap_ename,ap_ename1,ap_ename2,tran_date,tran_scode ";
                        SQL += ",ap_fcname,ap_lcname,ap_fename,ap_lename,ap_sql,ap_zip,ap_addr1,ap_addr2,ap_eaddr1,ap_eaddr2,ap_eaddr3,ap_eaddr4)";
                        SQL += "select '" + qopt_sqlno + "','" + qCase_no + "','" + qBranch + "',apsqlno,server_flag,apcust_no,";
                        SQL += "ap_cname,ap_cname1,ap_cname2,ap_ename,ap_ename1,ap_ename2,getdate(),'" + Session["scode"] + "' ";
                        SQL += ",ap_fcname,ap_lcname,ap_fename,ap_lename,ap_sql,ap_zip,ap_addr1,ap_addr2,ap_eaddr1,ap_eaddr2,ap_eaddr3,ap_eaddr4 ";
                        SQL += "from " + Sys.tdbname(qBranch) + ".dmt_temp_ap where in_no='" + in_no + "'";
                        conn.ExecuteNonQuery(SQL);
                        break;
                    case "caseitem_dmt"://收費與接洽事項
                        //刪除
                        SQL = "delete case_opt where opt_sqlno='" + qopt_sqlno + "'";
                        conn.ExecuteNonQuery(SQL);

                        //insert case_opt
                        SQL = "insert into case_opt(Opt_sqlno,Branch,Case_no,in_scode,seq,seq1,cust_area,cust_seq,att_sql,arcase_type";
                        SQL += ",arcase_class,arcase,div_arcase,service,fees,tot_case,add_service,add_fees,gs_fees";
                        SQL += ",gs_curr,oth_arcase,oth_code,oth_money";
                        SQL += ",ar_service,ar_fees,ar_curr,ar_code,ar_mark,discount,discount_chk,ar_chk";
                        SQL += ",ar_chk1,source,cust_date,pr_date,case_date";
                        SQL += ",case_num,contract_no,stat_code,remark,new,case_stat,tot_num,tran_date,mark";
                        SQL += ",rectitle_name,send_way,receipt_type,receipt_title)";
                        SQL += " select '" + qopt_sqlno + "','" + qBranch + "','" + qCase_no + "',in_scode,seq,seq1,cust_area,cust_seq,att_sql,arcase_type";
                        SQL += ",arcase_class,arcase,div_arcase,service,fees,tot_case,add_service,add_fees,gs_fees";
                        SQL += ",gs_curr,oth_arcase,oth_code,oth_money";
                        SQL += ",ar_service,ar_fees,ar_curr,ar_code,ar_mark,discount,discount_chk,ar_chk";
                        SQL += ",ar_chk1,source,cust_date,pr_date,case_date";
                        SQL += ",case_num,contract_no,stat_code,remark,new,case_stat,tot_num,tran_date,mark";
                        SQL += ",rectitle_name,send_way,receipt_type,receipt_title";
                        SQL += " from " + Sys.tdbname(qBranch) + ".case_dmt where in_no='" + in_no + "'";
                        conn.ExecuteNonQuery(SQL);

                        //刪除
                        SQL = "delete caseitem_opt where opt_sqlno='" + qopt_sqlno + "'";
                        conn.ExecuteNonQuery(SQL);

                        //insert caseitem_opt
                        SQL = "insert into caseitem_opt(opt_sqlno,Branch,Case_no,item_sql,seq,seq1,item_arcase";
                        SQL += ",item_service,item_fees,item_count,mark) ";
                        SQL += " select '" + qopt_sqlno + "','" + qBranch + "','" + qCase_no + "',item_sql,seq,seq1,item_arcase";
                        SQL += ",item_service,item_fees,item_count,mark ";
                        SQL += " from " + Sys.tdbname(qBranch) + ".caseitem_dmt where in_no='" + in_no + "'";
                        conn.ExecuteNonQuery(SQL);
                        break;
                    case "dmt_temp"://交辦內容
                        //刪除opt_detail
                        SQL = "delete opt_detail where opt_sqlno='" + qopt_sqlno + "'";
                        conn.ExecuteNonQuery(SQL);

                        //insert opt_detail
                        SQL = " insert into opt_detail(opt_sqlno,Branch,Case_no,seq,seq1,s_mark,pul,tcn_ref,class_type,class,class_count,tcn_class,tcn_name,tcn_mark";
                        SQL += ",in_date,apsqlno,ap_cname,ap_cname1,ap_cname2,ap_ename,ap_ename1,ap_ename2,apply_date,apply_no,issue_date,issue_no";
                        SQL += ",appl_name,cappl_name,eappl_name,eappl_name1,eappl_name2,jappl_name,jappl_name1,jappl_name2,zappl_name1,zappl_name2";
                        SQL += ",zname_type,oappl_name,draw,draw_file,symbol,color,agt_no,prior_date,prior_no,prior_country,open_date,rej_no,end_date,end_code";
                        SQL += ",dmt_term1,dmt_term2,renewal,grp_code,good_name,good_count,remark1,remark2,remark3,remark4,tr_date,tr_scode,ref_no,ref_no1,Mseq,Mseq1,mark) ";
                        SQL += "select '" + qopt_sqlno + "','" + qBranch + "','" + qCase_no + "',seq,seq1,s_mark,pul,tcn_ref,class_type,class,class_count,tcn_class,tcn_name,tcn_mark";
                        SQL += ",in_date,apsqlno,ap_cname,ap_cname1,ap_cname2,ap_ename,ap_ename1,ap_ename2,apply_date,apply_no,issue_date,issue_no";
                        SQL += ",appl_name,cappl_name,eappl_name,eappl_name1,eappl_name2,jappl_name,jappl_name1,jappl_name2,zappl_name1,zappl_name2";
                        SQL += ",zname_type,oappl_name,draw,draw_file,symbol,color,agt_no,prior_date,prior_no,prior_country,open_date,rej_no,end_date,end_code";
                        SQL += ",dmt_term1,dmt_term2,renewal,grp_code,good_name,good_count,remark1,remark2,remark3,remark4,tr_date,tr_scode,ref_no,ref_no1,Mseq,Mseq1,mark ";
                        SQL += " from " + Sys.tdbname(qBranch) + ".dmt_temp where in_no='" + in_no + "'";
                        conn.ExecuteNonQuery(SQL);

                        //刪除caseopt_good
                        SQL = "delete caseopt_good where opt_sqlno='" + qopt_sqlno + "'";
                        conn.ExecuteNonQuery(SQL);

                        //insert caseopt_good
                        SQL = "insert into caseopt_good(opt_sqlno,Branch,Case_no,class";
                        SQL += ",dmt_grp_code,dmt_goodname,dmt_goodcount,tr_date,tr_scode,mark) ";
                        SQL += " select '" + qopt_sqlno + "','" + qBranch + "','" + qCase_no + "',class";
                        SQL += ",dmt_grp_code,dmt_goodname,dmt_goodcount,tr_date,tr_scode,mark ";
                        SQL += " from " + Sys.tdbname(qBranch) + ".casedmt_good where in_no='" + in_no + "'";
                        conn.ExecuteNonQuery(SQL);

                        //刪除opt_tran
                        SQL = "delete opt_tran where opt_sqlno='" + qopt_sqlno + "'";
                        conn.ExecuteNonQuery(SQL);

                        //insert opt_tran
                        SQL = " insert into opt_tran(opt_sqlno,Branch,Case_no,agt_no1,agt_no2,mod_ap";
                        SQL += ",mod_aprep,mod_apaddr,mod_agt,mod_agtaddr";
                        SQL += ",mod_dmt,mod_class,mod_pul,mod_tcnref,mod_claim1,mod_claim2,mod_oth,mod_oth1";
                        SQL += ",mod_oth2,term1,term2,tran_remark1,tran_remark2,debit_money";
                        SQL += ",other_item,other_item1,other_item2,tr_date,tr_scode,tran_mark) ";
                        SQL += " select '" + qopt_sqlno + "','" + qBranch + "','" + qCase_no + "',agt_no1,agt_no2,mod_ap";
                        SQL += ",mod_aprep,mod_apaddr,mod_agt,mod_agtaddr";
                        SQL += ",mod_dmt,mod_class,mod_pul,mod_tcnref,mod_claim1,mod_claim2,mod_oth,mod_oth1";
                        SQL += ",mod_oth2,term1,term2,tran_remark1,tran_remark2,debit_money";
                        SQL += ",other_item,other_item1,other_item2,tr_date,tr_scode,tran_mark ";
                        SQL += " from " + Sys.tdbname(qBranch) + ".dmt_tran where in_no='" + in_no + "'";
                        conn.ExecuteNonQuery(SQL);

                        //刪除opt_tranlist
                        SQL = "delete opt_tranlist where opt_sqlno='" + qopt_sqlno + "'";
                        conn.ExecuteNonQuery(SQL);

                        //insert opt_tranlist
                        SQL = "insert into opt_tranlist(opt_sqlno,Branch,Case_no,mod_field,mod_type";
                        SQL += ",mod_dclass,mod_count,new_no,ncname1,ncname2,nename1,nename2,ncrep";
                        SQL += ",nerep,nzip,naddr1,naddr2,neaddr1,neaddr2,neaddr3,neaddr4,ntel0,ntel,ntel1,nfax";
                        SQL += ",old_no,ocname1,ocname2,oename1,oename2,ocrep,oerep,ozip,oaddr1,oaddr2,oeaddr1,oeaddr2";
                        SQL += ",oeaddr3,oeaddr4,otel0,otel,otel1,ofax";
                        SQL += ",list_remark,tran_code,mark) ";
                        SQL += " select '" + qopt_sqlno + "','" + qBranch + "','" + qCase_no + "',mod_field,mod_type";
                        SQL += ",mod_dclass,mod_count,new_no,ncname1,ncname2,nename1,nename2,ncrep";
                        SQL += ",nerep,nzip,naddr1,naddr2,neaddr1,neaddr2,neaddr3,neaddr4,ntel0,ntel,ntel1,nfax";
                        SQL += ",old_no,ocname1,ocname2,oename1,oename2,ocrep,oerep,ozip,oaddr1,oaddr2,oeaddr1,oeaddr2";
                        SQL += ",oeaddr3,oeaddr4,otel0,otel,otel1,ofax";
                        SQL += ",list_remark,tran_code,mark ";
                        SQL += " from " + Sys.tdbname(qBranch) + ".dmt_tranlist where in_no='" + in_no + "'";
                        conn.ExecuteNonQuery(SQL);
                        break;
                    case "dmt"://區所案件之營洽、出名代理人、案件名稱、申請人等資料
                        //update case_opt
                        SQL = "update case_opt Set in_scode=b.scode,cust_area=b.cust_area,cust_seq=b.cust_seq,att_sql=b.att_sql";
                        SQL += " from case_opt as a ," + Sys.tdbname(qBranch) + ".dmt as b ";
                        SQL += " where a.seq=b.seq and a.seq1=b.seq1 and a.Branch='" + qBranch + "' and a.opt_sqlno='" + qopt_sqlno + "'";
                        SQL += "  and b.seq='" + qSeq + "' and b.seq1='" + qSeq1 + "'";
                        conn.ExecuteNonQuery(SQL);

                        //update opt_detail
                        SQL = "update opt_detail Set apsqlno=b.apsqlno,ap_cname=b.ap_cname";
                        SQL += ",ap_ename=b.ap_ename,agt_no=b.agt_no";
                        SQL += ",appl_name=b.appl_name";
                        SQL += " from opt_detail as a ," + Sys.tdbname(qBranch) + ".dmt as b ";
                        SQL += " where a.seq=b.seq and a.seq1=b.seq1";
                        SQL += "  and b.seq='" + qSeq + "' and b.seq1='" + qSeq1 + "'";
                        SQL += "  and a.Branch='" + qBranch + "' and a.opt_sqlno='" + qopt_sqlno + "'";
                        conn.ExecuteNonQuery(SQL);
                        break;
                }
            }

            //conn.Commit();
            conn.RollBack();
            if (qBr == "N") {
                msg = "區所交辦資料複製成功！";
            } else {
                msg = "區所案件資料複製成功！";
            }
        }
        catch (Exception ex) {
            conn.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);
            if (qBr == "N") {
                msg = "區所交辦資料複製失敗！";
            } else {
                msg = "區所案件資料複製失敗！";
            }
            throw new Exception(msg, ex);
        }
        finally {
            conn.Dispose();
        }
    }

    private void log_update(DBHelper conn) {
        Funcs.insert_log_table(conn, "U", prgid, "case_opt",  "opt_sqlno", qopt_sqlno );
        ////case_opt_log
        //SQL = "insert into case_opt_log(ud_date,ud_scode,Opt_sqlno,Branch,Case_no,in_scode,seq,seq1,cust_area,cust_seq,att_sql,arcase_type";
        //SQL += ",arcase_class,arcase,div_arcase,service,fees,tot_case,add_service,add_fees,gs_fees";
        //SQL += ",gs_curr,oth_arcase,oth_code,oth_money";
        //SQL += ",ar_service,ar_fees,ar_curr,ar_code,ar_mark,discount,discount_chk,ar_chk";
        //SQL += ",ar_chk1,source,cust_date,pr_date,case_date";
        //SQL += ",case_num,contract_no,stat_code,remark,new,case_stat,tot_num,tran_date,mark)";
        //SQL += " select getdate(),'" + Session["scode"] + "',opt_sqlno,Branch,Case_no,in_scode,seq,seq1,cust_area,cust_seq,att_sql,arcase_type,arcase_class";
        //SQL += ",arcase,div_arcase,service,fees,tot_case,add_service,add_fees,gs_fees,gs_curr,oth_arcase,oth_code";
        //SQL += ",oth_money,ar_service,ar_fees,ar_curr,ar_code,ar_mark,discount,discount_chk,ar_chk,ar_chk1,source";
        //SQL += ",cust_date,pr_date,case_date,case_num,contract_no,stat_code,remark,new,case_stat,tot_num,tran_date,mark";
        //SQL += " from case_opt where opt_sqlno='" + qopt_sqlno + "'";
        //connb.ExecuteNonQuery(SQL);

        Funcs.insert_log_table(conn, "U", prgid, "opt_detail", "opt_sqlno", qopt_sqlno );
        //opt_detail_log
        //SQL = " insert into opt_detail_log(ud_date,ud_scode,Branch,Case_no,opt_sqlno,seq,seq1,s_mark,pul,tcn_ref,class_type,class,class_count,tcn_class,tcn_name,tcn_mark";
        //SQL += ",in_date,apsqlno,ap_cname,ap_cname1,ap_cname2,ap_ename,ap_ename1,ap_ename2,apply_date,apply_no,issue_date,issue_no";
        //SQL += ",appl_name,cappl_name,eappl_name,eappl_name1,eappl_name2,jappl_name,jappl_name1,jappl_name2,zappl_name1,zappl_name2";
        //SQL += ",zname_type,oappl_name,draw,draw_file,symbol,color,agt_no,prior_date,prior_no,prior_country,open_date,rej_no,end_date,end_code";
        //SQL += ",dmt_term1,dmt_term2,renewal,grp_code,good_name,good_count,remark1,remark2,remark3,remark4,tr_date,tr_scode,ref_no,ref_no1,Mseq,Mseq1,mark) ";
        //SQL += "select getdate(),'" + Session["scode"] + "',Branch,Case_no,opt_sqlno,seq,seq1,s_mark,pul,tcn_ref,class_type,class,class_count,tcn_class,tcn_name,tcn_mark";
        //SQL += ",in_date,apsqlno,ap_cname,ap_cname1,ap_cname2";
        //SQL += ",ap_ename,ap_ename1,ap_ename2,apply_date,apply_no,issue_date,issue_no,appl_name,cappl_name,eappl_name,eappl_name1,eappl_name2";
        //SQL += ",jappl_name,jappl_name1,jappl_name2,zappl_name1,zappl_name2,zname_type,oappl_name,draw,draw_file,symbol,color,agt_no,prior_date";
        //SQL += ",prior_no,prior_country,open_date,rej_no,end_date,end_code,dmt_term1,dmt_term2,renewal,grp_code,good_name,good_count,remark1,remark2";
        //SQL += ",remark3,remark4,tr_date,tr_scode,ref_no,ref_no1,Mseq,Mseq1,mark from opt_detail where opt_sqlno='" + qopt_sqlno + "'";
        //connb.ExecuteNonQuery(SQL);

        //caseitem_opt_log
        Funcs.insert_log_table(conn, "U", prgid, "caseitem_opt", "opt_sqlno", qopt_sqlno);
        //SQL = "insert into caseitem_opt_log(ud_date,ud_scode,opt_sqlno,Branch,Case_no,item_sql,seq,seq1,item_arcase";
        //SQL += " ,item_service,item_fees,item_count,mark) ";
        //SQL += " select getdate(),'" + Session["scode"] + "',opt_sqlno,Branch,Case_no,item_sql";
        //SQL += " ,seq,seq1,item_arcase,item_service,item_fees,item_count,mark ";
        //SQL += " from caseitem_opt where opt_sqlno='" + qopt_sqlno + "'";
        //connb.ExecuteNonQuery(SQL);

        //caseopt_good_log	
        Funcs.insert_log_table(conn, "U", prgid, "caseopt_good", "opt_sqlno", qopt_sqlno);
        //SQL = "insert into caseopt_good_log(ud_date,ud_scode,sqlno,opt_sqlno,Branch,Case_no,class";
        //SQL += ",dmt_grp_code,dmt_goodname,dmt_goodcount,tr_date,tr_scode,mark) ";
        //SQL += " select getdate(),'" + Session["scode"] + "',sqlno,opt_sqlno,Branch,Case_no";
        //SQL += ",class,dmt_grp_code,dmt_goodname,dmt_goodcount,tr_date,tr_scode,mark ";
        //SQL += " from caseopt_good where opt_sqlno='" + qopt_sqlno + "'";
        //connb.ExecuteNonQuery(SQL);

        //opt_tran_log	
        Funcs.insert_log_table(conn, "U", prgid, "opt_tran", "opt_sqlno", qopt_sqlno );
        //SQL = " insert into opt_tran_log(ud_date,ud_scode,opt_sqlno,Branch,Case_no,agt_no1,agt_no2,mod_ap";
        //SQL += ",mod_aprep,mod_apaddr,mod_agt,mod_agtaddr";
        //SQL += ",mod_dmt,mod_class,mod_pul,mod_tcnref,mod_claim1,mod_claim2,mod_oth,mod_oth1";
        //SQL += ",mod_oth2,term1,term2,tran_remark1,tran_remark2,debit_money";
        //SQL += ",other_item,other_item1,other_item2,tr_date,tr_scode,tran_mark) ";
        //SQL += " select getdate(),'" + Session["scode"] + "',opt_sqlno,Branch,case_no,agt_no1";
        //SQL += ",agt_no2,mod_ap,mod_aprep,mod_apaddr,mod_agt,mod_agtaddr,mod_dmt,mod_class";
        //SQL += ",mod_pul,mod_tcnref,mod_claim1,mod_claim2,mod_oth,mod_oth1,mod_oth2,term1,term2";
        //SQL += ",tran_remark1,tran_remark2,debit_money,other_item";
        //SQL += ",other_item1,other_item2,tr_date,tr_scode,tran_mark ";
        //SQL += " from opt_tran where opt_sqlno='" + qopt_sqlno + "'";
        //connb.ExecuteNonQuery(SQL);

        //opt_tranlist_log
        Funcs.insert_log_table(conn, "U", prgid, "opt_tranlist","opt_sqlno", qopt_sqlno);
        //SQL = "insert into opt_tranlist_log(ud_date,ud_scode,tran_sqlno,opt_sqlno,Branch,Case_no,mod_field,mod_type";
        //SQL += ",mod_dclass,mod_count,new_no,ncname1,ncname2,nename1,nename2,ncrep";
        //SQL += ",nerep,nzip,naddr1,naddr2,neaddr1,neaddr2,neaddr3,neaddr4,ntel0,ntel,ntel1,nfax,nserver_flag";
        //SQL += ",old_no,ocname1,ocname2,oename1,oename2,ocrep,oerep,ozip,oaddr1,oaddr2,oeaddr1,oeaddr2";
        //SQL += ",oeaddr3,oeaddr4,otel0,otel,otel1,ofax,oserver_flag";
        //SQL += ",list_remark,tran_code,mark) ";
        //SQL += " select getdate(),'" + Session["scode"] + "',tran_sqlno,opt_sqlno,Branch,case_no,mod_field";
        //SQL += ",mod_type,mod_dclass,mod_count,new_no";
        //SQL += ",ncname1,ncname2,nename1,nename2,ncrep,nerep,nzip";
        //SQL += ",naddr1,naddr2,neaddr1,neaddr2,neaddr3,neaddr4,ntel0,ntel,ntel1,nfax,nserver_flag";
        //SQL += ",old_no,ocname1,ocname2,oename1,oename2,ocrep,oerep,ozip,oaddr1,oaddr2,oeaddr1,oeaddr2";
        //SQL += ",oeaddr3,oeaddr4,otel0,otel,otel1,ofax,oserver_flag";
        //SQL += ",list_remark,tran_code,mark ";
        //SQL += " from opt_tranlist where opt_sqlno='" + qopt_sqlno + "'";
        //connb.ExecuteNonQuery(SQL);

        //caseopt_ap_log
        Funcs.insert_log_table(conn, "U", prgid, "caseopt_ap", "opt_sqlno", qopt_sqlno );
        //SQL = "insert into caseopt_ap_log(ud_date,ud_scode,opt_ap_sqlno,opt_sqlno,case_no,branch,apsqlno,server_flag,apcust_no";
        //SQL += ",ap_cname,ap_cname1,ap_cname2,ap_ename,ap_ename1,ap_ename2,tran_date,tran_scode,mark) ";
        //SQL += " select getdate(),'" + Session["scode"] + "',opt_ap_sqlno,opt_sqlno,case_no,branch,apsqlno,server_flag,apcust_no";
        //SQL += ",ap_cname,ap_cname1,ap_cname2,ap_ename,ap_ename1,ap_ename2,tran_date,tran_scode,mark ";
        //SQL += " from caseopt_ap where opt_sqlno='" + qopt_sqlno + "'";
        //connb.ExecuteNonQuery(SQL);
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
