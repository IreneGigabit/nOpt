<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "出口案區所抽件確認作業‧-入檔";//功能名稱
    protected string HTProgPrefix = "opte51";//程式檔名前綴
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

        ReqVal = Request.Form.ToDictionary();

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            foreach (KeyValuePair<string, string> p in ReqVal) {
                Response.Write(string.Format("{0}:{1}<br>", p.Key, p.Value));
            }
            Response.Write("<HR>");

            if (submitTask == "U") {//發文確認
                doConfirm();
            }

            this.DataBind();
        }
    }
    private void doConfirm() {
        for (int i = 1; i <= count; i++) {
            DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
            DBHelper connB = new DBHelper(Conn.OptB(ReqVal.TryGet("Branch" + i, ""))).Debug(Request["chkTest"] == "TEST");
            try {
                if (ReqVal.TryGet("opt_sqlno" + i, "") != "") {
                    //入br_opte_log
                    Funcs.insert_log_table(conn, "U", prgid, "br_opte", "opt_sqlno", ReqVal.TryGet("opt_sqlno" + i, ""));
                    SQL = "Update br_opte Set mark='D'";
                    SQL += " where opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "'";
                    conn.ExecuteNonQuery(SQL);

                    SQL="Update cancel_opte Set tran_status='DZ'";
                    SQL+= ",conf_date=getdate()";
                    SQL += ",conf_scode='" + Session["scode"] + "'";
                    SQL+= " where opt_sqlno='"+ ReqVal.TryGet("opt_sqlno" + i, "") + "'";
                    SQL+= " and sqlno='"+ ReqVal.TryGet("cancel_sqlno" + i, "") + "'";
                    conn.ExecuteNonQuery(SQL);
                    
			        SQL="update todo_opte set approve_scode='"+ Session["scode"] +"'";
			        SQL+= ",resp_date=getdate()";
			        SQL+= ",job_status='YY'";
			        SQL+= " where syscode='" + ReqVal.TryGet("Branch" + i, "") + "TBRT' and opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "'";
			        SQL+= " and dowhat='DD' and sqlno="+ ReqVal.TryGet("todo_sqlno" + i, "") + " and job_status='NN' ";
                    conn.ExecuteNonQuery(SQL);

                    //[區所]
                    //抓區所承辦
                    SQL = "select pr_scode from step_ext ";
                    SQL += " where branch='" + ReqVal.TryGet("Branch" + i, "") + "'";
                    SQL += " and seq=" + ReqVal.TryGet("bseq" + i, "") + "";
                    SQL += " and seq1='" + ReqVal.TryGet("bseq1_" + i, "") + "'";
                    SQL += " and opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "'";
                    object objResult = connB.ExecuteScalar(SQL);
                    string pr_scode = (objResult != DBNull.Value && objResult != null) ? objResult.ToString().Trim().ToLower() : "";
                    
				    //入step_ext_log
                    Dictionary<string, string> key = new Dictionary<string, string>() { 
                        { "branch",ReqVal.TryGet("Branch" + i, "") }, 
                        { "seq",ReqVal.TryGet("bseq" + i, "") }, 
                        { "seq1",ReqVal.TryGet("bseq1_" + i, "") }, 
                        {"opt_sqlno",ReqVal.TryGet("opt_sqlno" + i, "")}
                    };
                    Funcs.insert_log_table(connB, "U", prgid, "step_ext", key);
				    SQL="update step_ext set opt_stat='D'";
				    SQL+= " where branch='" +ReqVal.TryGet("Branch" + i, "")+ "'";
                    SQL+= " and seq=" +ReqVal.TryGet("bseq" + i, "")+ "";
                    SQL+= " and seq1='" +ReqVal.TryGet("bseq1_" + i, "")+ "'";
                    SQL+= " and opt_sqlno='"+ReqVal.TryGet("opt_sqlno" + i, "")+"'";
                    connB.ExecuteNonQuery(SQL);
                    
                    //通知區所抽件完成
                    CreateMail(conn, ReqVal.TryGet("opt_sqlno" + i, ""), pr_scode, ReqVal.TryGet("case_no" + i, ""), ReqVal.TryGet("branch" + i, ""));

                    //發完mail才能更新註記,否則找不到
                    //入case_opte_log
                    Funcs.insert_log_table(conn, "U", prgid, "case_opte", "opt_sqlno", ReqVal.TryGet("opt_sqlno" + i, ""));
                    SQL = "Update case_opte Set mark='D'";
                    SQL += " where opt_sqlno='" + ReqVal.TryGet("opt_sqlno" + i, "") + "'";
                    conn.ExecuteNonQuery(SQL);
                 
                    //connB.Commit();
                    //conn.Commit();
                    connB.RollBack();
                    conn.RollBack();
                }

                msg = "出口爭救案抽件成功";
            }
            catch (Exception ex) {
                connB.RollBack();
                conn.RollBack();
                Sys.errorLog(ex, conn.exeSQL, prgid);
                msg = "出口爭救案抽件失敗";

                throw new Exception(msg, ex);
            }
            finally {
                connB.Dispose();
                conn.Dispose();
            }
        }
        strOut.AppendLine("alert('" + msg + "');");
        if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.parent.Etop.goSearch();");
    }


    private void CreateMail(DBHelper conn, string opt_sqlno, string pr_scode, string case_no, string branch) {
        string fseq = "", in_scode = "", in_scode_name = "", cust_area = "", cust_seq = "";
        string ap_cname = "", appl_name = "", arcase_name = "", last_date = "";
        SQL = "select Bseq,Bseq1,branch,in_scode,scode_name,cust_area,cust_seq ";
        SQL += ",appl_name,arcase_name,Last_date ";
        SQL += "from vbr_opte where case_no='" + case_no + "' and branch='" + branch + "' ";
        using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
            if (dr.Read()) {
                fseq = Funcs.formatSeq(dr.SafeRead("Bseq", ""), dr.SafeRead("Bseq1", ""), dr.SafeRead("country", ""), dr.SafeRead("Branch", ""), Sys.GetSession("dept") + "E");
                in_scode = dr.SafeRead("in_scode", "");
                in_scode_name = dr.SafeRead("scode_name", "");
                cust_area = dr.SafeRead("cust_area", "");
                cust_seq = dr.SafeRead("cust_seq", "");
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
        
        string Subject = "專案室出口爭救案件抽件完成通知";
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
                strTo.Add(pr_scode + "@saint-island.com.tw");
                strCC.Add(in_scode + "@saint-island.com.tw");
                strCC.Add(Session["scode"] + "@saint-island.com.tw");
                break;
        }

        string body = "【區所案件編號】 : <B>" + fseq + "</B><br>" +
            "【營洽】 : <B>" + in_scode + "-" + in_scode_name + "</B><br>" +
            "【申請人】 : <B>" + ap_cname + "</B><br>" +
            "【案件名稱】 : <B>" + appl_name + "</B><br>" +
            "【案性】 : <B>" + arcase_name + "</B><Br><Br><p>";

        Sys.DoSendMail(Subject, body, strFrom, strTo, strCC, strBCC);
    }
</script>

<script language="javascript" type="text/javascript">
    <%Response.Write(strOut.ToString());%>
</script>
