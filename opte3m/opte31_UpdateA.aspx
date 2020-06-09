<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "出口爭救案承辦作業確認-入檔";//功能名稱
    protected string HTProgPrefix = "opte31";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string SQL = "";
    protected string msg = "";

    string case_no = "";
    string branch = "";
    string opt_no = "";
    string opt_sqlno = "";
    string todo_sqlno = "";
    string submitTask = "";
    string reportp = "";
    string end_flag = "";
    string sameap_flag = "";

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
        todo_sqlno = (Request["todo_sqlno"] ?? "").Trim();
        submitTask = (Request["submittask"] ?? "").Trim();
        end_flag = (Request["End_flag"] ?? "").Trim();
        sameap_flag = (Request["sameap_flag"] ?? "").Trim();

        ReqVal = Util.GetRequestParam(Context,Request["chkTest"] == "TEST");

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            if (submitTask == "U") {//承辦結辦
                doConfirm();
            } else if (submitTask == "B") {//退回分案
                //doBack();//退回分案在opte31_update.aspx處理
            }
            this.DataBind();
        }
    }

    private void doConfirm() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        try {
            //處理上傳文件
            upin_attach_opt(conn, opt_sqlno, "PR");

            //判行人員
            string Job_Scode = "";
            if (ReqVal.TryGet("ap_type", "") == "1")
                Job_Scode = ReqVal.TryGet("job_scode1", "");
            else if (ReqVal.TryGet("ap_type", "") == "2")
                Job_Scode = ReqVal.TryGet("job_scode2", "");

            //修改分案主檔等資料
            update_bropt(conn, Job_Scode);

            //結辦-流程狀態修改
            if (end_flag == "Y") {
                //結辦與判行人員相同，修改流程狀態
                if( sameap_flag=="Y")
                    update_bropt_ap(conn);
                else
                    update_bropt_end(conn, Job_Scode);
            }

            //出口案先不提供結辦暨判行
            //if (sameap_flag == "Y") {
            //    update_bropt_ap(conn);
            //}

            conn.Commit();
            //conn.RollBack();

            if (submitTask == "U") {
                if (end_flag == "Y") {
                    if (sameap_flag == "Y")
                        msg = "結案暨判行成功";
                    else
                        msg = "結案成功";
                    strOut.AppendLine("alert('" + msg + "');");
                    if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.parent.Etop.goSearch();");
                } else {
                    if (ReqVal.TryGet("progid", "") == "opte31") {
                        msg = "編修存檔完成";
                        strOut.AppendLine("alert('" + msg + "');");
                    }
                    string thref = "";
                    if (ReqVal.TryGet("progid", "") != "") {
                        thref = "opte31Edit.aspx?prgid=" + Request["progid"] + "&opt_sqlno=" + opt_sqlno + "&opt_no=" + opt_no + "&branch=" + branch + "&case_no=" + case_no + "&todo_sqlno=" + todo_sqlno;
                    } else {
                        thref = "opte31Edit.aspx?prgid=opte31&opt_sqlno" + opt_sqlno + "&opt_no=" + opt_no + "&branch=" + branch + "&case_no=" + case_no + "&todo_sqlno" + todo_sqlno;
                    }
                    if (ReqVal.TryGet("from_prgid", "") == "opte23") {
                        thref = "../opte2m/opte23List.aspx?prgid=" + Request["from_prgid"];
                    }
                    if (ReqVal.TryGet("from_prgid", "") == "opte25") {
                        thref = "../opte2m/opte25List.aspx?prgid=" + Request["from_prgid"];
                    }

                    if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.location.href='" + thref + "';");
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
            }
            strOut.AppendLine("alert('" + msg + "');");

            throw new Exception(msg, ex);
        }
        finally {
            conn.Dispose();
        }
    }

    //修改分案主檔之承辦資料
    private void update_bropt(DBHelper conn, string job_scode) {
        Funcs.insert_log_table(conn, "U", prgid, "br_opte", "opt_sqlno", opt_sqlno );

        SQL = "update br_opte set pr_hour=" + Util.dbzero(ReqVal.TryGet("pr_hour", "0")) + "";
        SQL += ",pr_per=" + Util.dbzero(ReqVal.TryGet("pr_per", "0")) + "";
        SQL += ",pr_remark=N'" + ReqVal.TryGet("pr_remark", "") + "'";
        if (end_flag == "Y") {//結辦處理
            SQL += ",pr_date=" + Util.dbnull(ReqVal.TryGet("pr_date", null)) + "";
            SQL += ",ch_scode='" + Session["scode"] + "'";
            SQL += ",ch_date=getdate()";
            SQL += ",ap_scode='" + job_scode + "'";
            SQL += ",send_dept='B'";
            if (sameap_flag == "Y") {//承辦與判行同一人，修改判行資料
                SQL += ",PRY_hour=" + Util.dbzero(ReqVal.TryGet("PRY_hour", "0")) + "";
                SQL += ",AP_hour=" + Util.dbzero(ReqVal.TryGet("AP_hour", "0")) + "";
                SQL += ",ap_date='" + DateTime.Today.ToShortDateString() + "'";
                SQL += ",ap_remark='" + ReqVal.TryGet("ap_remark", "").ToBig5() + "'";
                SQL += ",stat_code='YY'";
            } else {
                SQL += ",stat_code='NY'";
            }
        }
        SQL += ",tran_scode='" + Session["scode"] + "'";
        SQL += ",tran_date=getdate()";
        SQL += " where opt_sqlno='" + opt_sqlno + "'";
        conn.ExecuteNonQuery(SQL);
    }

    //結辦處理-修改流程狀態
    private void update_bropt_end(DBHelper conn, string job_scode) {
        //修改目前流程狀態
        SQL = "update todo_opte set approve_scode='" + Session["scode"] + "'";
        SQL += ",resp_date=getdate()";
        SQL += ",job_status='YY'";
        SQL += " where sqlno=" + todo_sqlno + " and syscode='" + Session["Syscode"] + "' ";
        SQL += " and dowhat='PR' and job_status='NN' ";
        conn.ExecuteNonQuery(SQL);

        SQL = " insert into todo_opte(pre_sqlno,syscode,apcode,from_flag,opt_no,opt_sqlno,branch,in_scode,in_date";
        SQL += ",dowhat,job_scode,job_status) values (";
        SQL += "'" + todo_sqlno + "','" + Session["Syscode"] + "','" + prgid + "','pr_opt','" + opt_no + "'," + opt_sqlno + ",'" + branch + "'";
        SQL += ",'" + Session["scode"] + "',getdate(),'AP','" + job_scode + "','NN')";
        conn.ExecuteNonQuery(SQL);
    }

    //結辦且承辦與判行同一人，流程狀態修改
    private void update_bropt_ap(DBHelper conn) {
        SQL = "update todo_opte set approve_scode='" + Session["scode"] + "'";
        SQL += ",resp_date=getdate()";
        SQL += ",job_status='YY'";
        SQL += " where sqlno=" + todo_sqlno + " and syscode='" + Session["Syscode"] + "' ";
        SQL += " and dowhat='PR' and job_status='NN' ";
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
                    SQL = "insert into attach_opte (Opt_sqlno,Source";
                    SQL += ",add_date,add_scode,Attach_no,attach_path,attach_desc";
                    SQL += ",Attach_name,Attach_size,attach_flag,Mark,tran_date,tran_scode";
                    SQL += ",Source_name,doc_type,attach_branch";
                    SQL += ") values (";
                    SQL += popt_sqlno + ",'" + psource + "'";
                    SQL += ",'" + DateTime.Today.ToShortDateString() + "','" + Session["scode"] + "'";
                    SQL += ",'" + ReqVal.TryGet(opt_uploadfield + "_attach_no_" + i, "") + "','" + ReqVal.TryGet(opt_uploadfield + "_" + i, "").Replace(@"\nopt\", @"\opt\") + "'";//因舊系統儲存路徑為opt為了統一照舊
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
                SQL = "Update attach_opte set Source='" + psource + "'";
                SQL += ",attach_path='" + ReqVal.TryGet(opt_uploadfield + "_" + i, "").Replace(@"\nopt\", @"\opt\") + "'";//因舊系統儲存路徑為opt為了統一照舊
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
                Funcs.insert_log_table(conn, "U", prgid, "attach_opte", "attach_sqlno", ReqVal.TryGet(opt_uploadfield + "_attach_sqlno_" + i, "") );
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
</script>

<script language="javascript" type="text/javascript">
    <%Response.Write(strOut.ToString());%>
</script>
