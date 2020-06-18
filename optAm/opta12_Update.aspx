<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "大陸爭救案案例維護-入檔";//功能名稱
    protected string HTProgPrefix = "opta12";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string SQL = "";
    protected string msg = "";

    string submitTask = "";

    protected Dictionary<string, string> ReqVal = new Dictionary<string, string>();
    protected StringBuilder strOut = new StringBuilder();

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        submitTask = (Request["submittask"] ?? "").Trim();

        ReqVal = Util.GetRequestParam(Context,Request["chkTest"] == "TEST");

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
            try {
                if (submitTask == "A") {//新增
                    doAdd(conn);
                } else if (submitTask == "U") {//修改
                    doUpdate(conn);
                } else if (submitTask == "D") {//停用
                    doDel(conn);
                }

                conn.Commit();
                //conn.RollBack();
                
                msg = "大陸爭救案案例維護入檔成功!!";
            }
            catch (Exception ex) {
                conn.RollBack();
                Sys.errorLog(ex, conn.exeSQL, prgid);

                msg = "大陸爭救案案例維護入檔失敗!!!";

                throw new Exception(msg, ex);
            }
            finally {
                conn.Dispose();
            }

            strOut.AppendLine("alert('" + msg + "');");
            if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.parent.Etop.goSearch();");

            this.DataBind();
        }
    }

    private void doAdd(DBHelper conn) {
        int class_num = Convert.ToInt32("0" + Request["class_num"]);
        string law_string = "";
        for (int i = 1; i <= class_num; i++) {
            law_string += (law_string == "" ? "" : ",") + Request["law_type_" + i];
        }
        SQL = " INSERT into law_opt ";
	    SQL += "(branch,BSeq,Bseq1,BJTbranch,BJTSeq,BJTseq1,opt_pic,opt_pic_path,opt_class,opt_class_name " ;
        SQL +=",opt_point ,Cbranch,Cust_no,Cust_name,opt_mark,opt_comfirm,opt_check,opt_type,pr_no,pr_date " ;
        SQL +=",pr_mark,Ref_law,end_date,tran_date,tran_scode,in_date,in_scode ";
        SQL += ") VALUES (";
        SQL += " '" + Request["edit_branch"] + "'";
	    SQL += ", '" + Request["edit_BSeq"]  + "'";
	    SQL += ", '" + Request["edit_BSeq1"]  + "'";
	    SQL += ", '" + Request["edit_BJTbranch"]  + "'";
	    SQL += ", '" + Request["edit_BJTSeq"]  + "'";
	    SQL += ", '" + Request["edit_BJTSeq1"]  + "'";
	    SQL += ", '" + ReqVal.TryGet("edit_opt_pic", "").ToBig5()  + "'";
        SQL += ", '" + ReqVal.TryGet("edit_opt_pic_path", "").ToBig5().Replace(@"\nopt\", @"\opt\").Replace(@"/nopt/", @"/opt/") + "'";//因舊系統儲存路徑為opt為了統一照舊
	    SQL += ", '" + Request["edit_opt_class"]  + "'";
	    SQL += ", '" + ReqVal.TryGet("edit_opt_class_name", "").ToBig5()  + "'";
	    SQL += ", '" + ReqVal.TryGet("edit_opt_point", "").ToBig5()  + "'";
	    SQL += ", '" + Request["edit_Cbranch"]  + "'";
	    SQL += ", '" + Request["edit_Cust_no"]  + "'";
	    SQL += ", '" + ReqVal.TryGet("edit_Cust_name", "").ToBig5() + "'";
	    SQL += ", '" + ReqVal.TryGet("edit_opt_mark", "").ToBig5() + "'";
	    SQL += ", '" + Request["edit_opt_comfirm"] + "'";
	    SQL += ", '" + Request["edit_opt_check"] + "'";
	    SQL += ", ''";
	    SQL += ", '" + ReqVal.TryGet("edit_pr_no", "").ToBig5()  + "'";
	    SQL += ", " + Util.dbnull(Request["edit_pr_date"])  + "";
	    SQL += ", ''";
	    SQL += ", '" +law_string+ "'";
	    SQL += ", null ";
	    SQL += ", GETDATE() ";
	    SQL += ", '" + Session["scode"] + "'";
	    SQL += ", GETDATE() ";
	    SQL += ", '" + Session["scode"] + "' )";
        conn.ExecuteNonQuery(SQL);

        //抓insert後的流水號
        SQL = "SELECT SCOPE_IDENTITY() AS Current_Identity";
        object objResult1 = conn.ExecuteScalar(SQL);
        string edit_opt_no = objResult1.ToString();
        
        //上傳附件資料至附件Table中
        int attachnum = Convert.ToInt32("0" + Request["attachnum"]);
        for (int i = 1; i <= attachnum; i++) {
            Insert_law_attach(conn, i, edit_opt_no);
        }
    }

    private void doUpdate(DBHelper conn) {
        Funcs.insert_log_table(conn, "U", prgid, "law_opt", "opt_no", ReqVal.TryGet("edit_opt_no", ""));

        int class_num = Convert.ToInt32("0" + Request["class_num"]);
        string law_string = "";
        for (int i = 1; i <= class_num; i++) {
            law_string += (law_string == "" ? "" : ",") + Request["law_type_" + i];
        }

        SQL = " Update law_opt ";
        SQL += "set branch = '" + Request["edit_branch"] + "'";
        SQL += ", BSeq = '" + Request["edit_BSeq"] + "'";
        SQL += ", BSeq1 = '" + Request["edit_BSeq1"] + "'";
        SQL += ", BJTbranch = '" + Request["edit_BJTbranch"] + "'";
        SQL += ", BJTSeq = '" + Request["edit_BJTSeq"] + "'";
        SQL += ", BJTSeq1 = '" + Request["edit_BJTSeq1"] + "'";
        SQL += ", opt_pic = '" + ReqVal.TryGet("edit_opt_pic", "").ToBig5() + "'";
        SQL += ", opt_pic_path = '" + ReqVal.TryGet("edit_opt_pic_path", "").ToBig5().Replace(@"\nopt\", @"\opt\").Replace(@"/nopt/", @"/opt/") + "'";//因舊系統儲存路徑為opt為了統一照舊
        SQL += ", opt_class = '" + Request["edit_opt_class"] + "'";
        SQL += ", opt_class_name = '" + ReqVal.TryGet("edit_opt_class_name", "").ToBig5() + "'";
        SQL += ", opt_point = '" + ReqVal.TryGet("edit_opt_point", "").ToBig5() + "'";
        SQL += ", Cbranch = '" + Request["edit_Cbranch"] + "'";
        SQL += ", Cust_no = '" + Request["edit_Cust_no"] + "'";
        SQL += ", Cust_name = '" + ReqVal.TryGet("edit_Cust_name", "").ToBig5() + "'";
        SQL += ", opt_mark = '" + ReqVal.TryGet("edit_opt_mark", "").ToBig5() + "'";
        SQL += ", opt_comfirm = '" + Request["edit_opt_comfirm"] + "'";
        SQL += ", opt_check = '" + Request["edit_opt_check"] + "'";
        SQL += ", pr_no = '" + ReqVal.TryGet("edit_pr_no", "").ToBig5() + "'";
        SQL += ", pr_date = " + Util.dbnull(Request["edit_pr_date"]) + "";
        SQL += ", ref_law = '" + law_string + "'";
        SQL += ", tran_date = GETDATE() ";
        SQL += ", tran_scode = '" + Session["scode"] + "'";
        SQL += " where opt_no = '" + Request["edit_opt_no"] + "'";
        conn.ExecuteNonQuery(SQL);

        //上傳附件資料至附件Table中
        int attachnum = Convert.ToInt32("0" + Request["attachnum"]);
        for (int i = 1; i <= attachnum; i++) {
            SQL = " SELECT * from law_Attach where sqlno = '" + Request["attach_sqlno" + i] + "'";
            object objResult = conn.ExecuteScalar(SQL);
            if (objResult == DBNull.Value || objResult == null) {
                Insert_law_attach(conn, i, Request["edit_opt_no"]);
            } else {
                Update_law_attach(conn, i);
            }
        }
    }

    private void doDel(DBHelper conn) {
        //Funcs.insert_log_table(conn, "D", prgid, "law_opt", "opt_no", ReqVal.TryGet("edit_opt_no", ""));
    }
    
    //上傳附件資料至附件Table中
    private void Insert_law_attach(DBHelper conn, int pno, string edit_opt_no) {
        SQL = " INSERT into law_attach ";
        SQL += " (opt_no,attach_name,attach_path,attach_type,attach_remark ";
        SQL += ",end_date,attach_flag,attach_in_date , attach_scode";
        SQL += ") VALUES (";
        SQL += "  '" + edit_opt_no + "'";
        SQL += ", '" + ReqVal.TryGet("edit_opt_pic_path_name" + pno, "").ToBig5() + "'";
        SQL += ", '" + ReqVal.TryGet("edit_opt_pic_path" + pno, "").ToBig5().Replace(@"\nopt\", @"\opt\").Replace(@"/nopt/", @"/opt/") + "'";//因舊系統儲存路徑為opt為了統一照舊
        SQL += ", '" + Request["attach_type" + pno] + "'";
        SQL += ", '" + ReqVal.TryGet("attach_remark" + pno, "").ToBig5() + "'";
        SQL += ", NULL";
        SQL += ", 'A'";
        SQL += ", '" + Request["edit_opt_pic_path_add_date" + pno] + "'";
        SQL += ", '" + Request["edit_opt_pic_path_add_scode" + pno] + "' )";
        conn.ExecuteNonQuery(SQL);
    }


    //修改附件資料至附件Table中
    private void Update_law_attach(DBHelper conn, int pno) {
        //Funcs.insert_log_table(conn,"U",prgid,"law_attach","sqlno",ReqVal.TryGet("attach_sqlno"+pno));
        SQL = " Update law_attach ";
        SQL += "set attach_name = '" + ReqVal.TryGet("edit_opt_pic_path_name" + pno, "").ToBig5() + "'";
        SQL += ", attach_path = '" + ReqVal.TryGet("edit_opt_pic_path" + pno, "").ToBig5().Replace(@"\nopt\", @"\opt\").Replace(@"/nopt/", @"/opt/") + "'";//因舊系統儲存路徑為opt為了統一照舊
        SQL += ", attach_type = '" + Request["attach_type" + pno] + "'";
        SQL += ", attach_remark = '" + ReqVal.TryGet("attach_remark" + pno, "").ToBig5() + "'";
        if (Request["mEnd_date" + pno] == "") {
            SQL += ", end_date = NULL ";
            SQL += ", attach_flag = 'U'";
        } else {
            SQL += ", end_date = '" + Request["mEnd_date" + pno] + "'";
            SQL += ", attach_flag = 'D'";
        }
        SQL += " where sqlno = '" + Request["attach_sqlno" + pno] + "'";
        conn.ExecuteNonQuery(SQL);
    }
</script>

<script language="javascript" type="text/javascript">
    <%Response.Write(strOut.ToString());%>
</script>
