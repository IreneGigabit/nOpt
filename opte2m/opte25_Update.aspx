<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "爭救檔案複製至北京專區‧-入檔";//功能名稱
    protected string HTProgPrefix = "opte25";//程式檔名前綴
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
        int pno=0;//最後一筆勾選的，作抓取案件分案資料
        int filenum=0;//複製的筆數
        for (int i = 1; i <= count; i++) {
            DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");
            DBHelper connB = new DBHelper(Conn.OptB(ReqVal.TryGet("Branch" + i, ""))).Debug(Request["chkTest"] == "TEST");
            try {
               
                if (ReqVal.TryGet("hchk_flag" + i, "") == "Y") {
                    //copy_attach_opte(i);
                    //update_attach_opte(i);
                    
                    pno = i;
				    filenum+=1;

                    //複製完成通知資訊部網管組
                    //CreateMail(conn, pno, filenum);
                 
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

    private bool copy_attach_opte(int pno){
        string branch=ReqVal.TryGet("branch" + pno, "");
        string bseq=ReqVal.TryGet("branch" + pno, "");
        string bseq1=ReqVal.TryGet("branch" + pno, "");
        string attach_name = ReqVal.TryGet("attach_name" + pno, "");
        string strpath = ReqVal.TryGet("attach_path" + pno, "");

        //建第一層目錄：區所案號+日期，如NTE12345-_-20160810
        string tfoldername = String.Format("{0}-{1}-{2}"
            , branch +  Sys.GetSession("dept")+"E"+bseq
            ,bseq1
            , DateTime.Now.ToString("yyyyMMdd"));
	   
        if (Request["task"]=="recopy" && Request["recopy_flag"]=="Y"){
            tfoldername+="/重新複製";
        }
        
        //測試環境放置測試目錄下
                if (Sys.Host.IndexOf("web")>-1){
            tfoldername="測試/"+tfoldername;
        }

        Check_CreateFolder_virtual(tfoldername);
        
        //要將檔案copy至sin07/ToBJ
        string sendt_path="/" + tfoldername;
        //copyFile(strpath,sendt_path,attach_name)         
		
        return true;
    }

    //檢查目錄是否存在,若不存在則建立
    private void Check_CreateFolder_virtual(string strFolder) {
        if (!System.IO.Directory.Exists(Server.MapPath(strFolder))) {
            //新增資料夾
            System.IO.Directory.CreateDirectory(Server.MapPath(strFolder));
        }
    }
    
    //修改上傳文件之複製狀態
    //private bool update_attach_opte(DBHelper conn) {
    //    dim isql
	
    //    //入cust_step_log
    //    call insert_log_table(conn,"U",prgid,"attach_opte","attach_sqlno",request("attach_sqlno"&pno))
	
    //    //更新上傳檔案複製註記
    //    isql = "update attach_opte set attach_datebj=getdate() "
    //    if request("task")="copy" then
    //        isql = isql & ", attach_flagbj = 'Y'"
    //    end if	
    //    isql = isql & ",tran_date=getdate()"
    //    isql = isql & ",tran_scode='" & session("se_scode") & "'"
    //    isql = isql & " where attach_sqlno = '" & request("attach_sqlno"&pno) & "'"
    //    conn.execute isql
    //    if err.number=0 and conn.errors.count=0 then
    //        update_attach_opte=true
    //    else
    //        msg="修改上傳檔案" & request("opt_sqlno"&pno) & "-" & request("attach_sqlno"&pno) & "複製狀態失敗" & chr(10) & err.Description	
    //        update_attach_opte=false
    //    end if
    //}
    
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
