<%@Page Language="C#" CodePage="65001"%>
<%@Import Namespace = "System.Data.SqlClient"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script runat="server">
    protected string HTProgCap = "區所交辦收件確認-入檔";//功能名稱
    protected string HTProgPrefix = "opt11";//程式檔名前綴
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
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
        
        Token myToken = new Token(prgid);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            if (submitTask == "U") {
                doConfirm();//收件確認
            } else if (submitTask == "B") {//退回區所
                doReturn();
            }
            
            this.DataBind();
        }
    }

    private void doConfirm() {
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
        try {
            //產生案件編號
            SQL="select max(opt_no)+1 from br_opt where left(opt_no,4)=(year(getdate()))";
            object objResult = conn.ExecuteScalar(SQL);
            string opt_no = (objResult == null ? (DateTime.Now.Year + "000001") : objResult.ToString());

            //抓前一todo的流水號
            string pre_sqlno = "";
            SQL = "Select max(sqlno) as maxsqlno,in_scode from todo_opt ";
            SQL += "where syscode='" + branch + "TBRT' ";
            SQL += "and apcode='brt18' and opt_sqlno='" + opt_sqlno + "' ";
            SQL += "and dowhat='RE' group by in_scode ";
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    pre_sqlno = dr.SafeRead("maxsqlno", "");
                }
            }

            SQL = "update br_opt set confirm_scode='" + Session["scode"] + "'";
            SQL += ",confirm_date='" + DateTime.Now.ToString("yyyy/MM/dd") + "'";
            SQL += ",stat_code='RR'";
            SQL += ",opt_no='" + opt_no + "'";
            SQL += ",Fees=" + (Request["nfy_fees"] ?? "0") + "";
            SQL += " where opt_sqlno='" + opt_sqlno + "'";
            conn.ExecuteNonQuery(SQL);

            SQL = "update todo_opt set approve_scode='" + Session["scode"] + "'";
            SQL += ",resp_date=getdate()";
            SQL += ",job_status='YY'";
            SQL += " where apcode='brt18' and opt_sqlno='" + opt_sqlno + "'";
            SQL += " and dowhat='RE' and syscode='" + branch + "TBRT'";
            SQL += " and sqlno=" + pre_sqlno;
            conn.ExecuteNonQuery(SQL);
    
            //入流程控制檔
            SQL = "insert into todo_opt(pre_sqlno,syscode,apcode,opt_sqlno,branch,case_no ";
            SQL += ",in_scode,in_date,dowhat,job_status) values ( ";
            SQL += "'" + pre_sqlno + "','" + Session["Syscode"] + "','" + prgid + "'," + opt_sqlno + ",'" + branch + "','" + case_no + "'";
            SQL += ",'" + Session["scode"] + "',getdate(),'BR','NN')";
            conn.ExecuteNonQuery(SQL);
            
            //conn.Commit();
            conn.RollBack();
            msg = "收件成功";
        }
        catch (Exception ex) {
            conn.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);
            msg = "收件失敗";
        }
        finally {
            conn.Dispose();
        }
    }

    private void doReturn() {
        
    }
</script>


<script language="javascript" type="text/javascript">
    alert("<%#msg%>");
    if ("<%#Request["chkTest"]%>" != "TEST") {
        window.parent.Etop.goSearch();
    }
</script>
