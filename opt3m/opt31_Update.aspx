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
    protected string strConnB = "";
    protected string msg = "";

    protected string case_no = "";
    protected string branch = "";
    protected string opt_sqlno = "";
    protected string submitTask = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        strConnB = Conn.OptB(Request["branch"]);

        case_no = Request["case_no"];
        branch = Request["branch"];
        opt_sqlno = Request["opt_sqlno"];
        submitTask = Request["submitTask"];

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            if (submitTask == "U" || submitTask == "P") {//承辦結辦/列印
                doConfirm();//分案確認
            } else if (submitTask == "B") {//退回分案
                doBack();
            }
            
            this.DataBind();
        }
    }

    private void doConfirm() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        try {
            //抓前一todo的流水號
            string pre_sqlno = "";
            SQL = "Select max(sqlno) as maxsqlno from todo_opt ";
            SQL += "where syscode='" + Session["Syscode"] + "' ";
            SQL += "and apcode='opt11' and opt_sqlno='" + opt_sqlno + "' ";
            SQL += "and dowhat='BR' ";
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    pre_sqlno = dr.SafeRead("maxsqlno", "");
                }
            }
        
            SQL = "update br_opt set in_scode='" + Session["scode"] + "'";
            SQL += ",in_date='" + DateTime.Now.ToString("yyyy/MM/dd") + "'";
            SQL += ",last_date='" + Request["dfy_last_date"] + "'";
            SQL += ",ctrl_date='" + Request["ctrl_date"] + "'";
            SQL += ",pr_branch='" + Request["pr_branch"] + "'";
            SQL += ",pr_scode='" + Request["pr_scode"] + "'";
            SQL += ",br_remark='" + Request["Br_remark"].ToBig5() + "'";
            SQL += ",stat_code='NN'";
            SQL += " where opt_sqlno='" + opt_sqlno + "'";
            conn.ExecuteNonQuery(SQL);

            SQL = "update todo_opt set approve_scode='" + Session["scode"] + "'";
            SQL += ",resp_date=getdate()";
            SQL += ",job_status='YY'";
            SQL += " where apcode='opt11' and opt_sqlno='" + opt_sqlno + "'";
            SQL += " and dowhat='BR' and syscode='" + Session["Syscode"] + "' ";
            SQL += " and sqlno=" + pre_sqlno;
            conn.ExecuteNonQuery(SQL);
    
            //入流程控制檔
            SQL = "insert into todo_opt(pre_sqlno,syscode,apcode,opt_sqlno,branch,case_no ";
            SQL += ",in_scode,in_date,dowhat,job_status) values ( ";
            SQL += "'" + pre_sqlno + "','" + Session["Syscode"] + "','" + prgid + "'," + opt_sqlno + ",'" + branch + "','" + case_no + "'";
            SQL += ",'" + Session["scode"] + "',getdate(),'PR','NN')";
            conn.ExecuteNonQuery(SQL);
            
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
            SQL += ",approve_desc='" + Request["Preject_reason"].ToBig5() + "' ";
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
            SQL += "'" + Request["case_no"] + "','" + Session["scode"] + "',getdate(),'BR','NN')";
            conn.ExecuteNonQuery(SQL);

            //conn.Commit();
            //connB.Commit();
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
</script>

<script language="javascript" type="text/javascript">
    alert("<%#msg%>");
    if ("<%#Request["chkTest"]%>" != "TEST") {
        window.parent.Etop.goSearch();
    }
</script>
