<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.IO"%>
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
    int filenum=0;//複製的筆數

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

            doCopy();

            this.DataBind();
        }
    }
    private void doCopy() {
        int pno = 0;//最後一筆勾選的，作抓取案件分案資料
        DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");

        try {
            for (int i = 1; i <= count; i++) {
                if (ReqVal.TryGet("hchk_flag_" + i, "") == "Y") {
                    copy_attach_opte(i);
                    update_attach_opte(conn, i);

                    pno = i;
                    filenum += 1;
                }
            }

            if (Request["qrytodo"] == "copy"){
                msg = "複製作業完成!!";
            } else if (Request["qrytodo"] == "recopy") {
                msg = "重新複製作業完成!!";
            }

            //複製完成通知資訊部網管組
            Sendmail(conn, pno, filenum);

            //conn.Commit();
            conn.RollBack();
        }
        catch (Exception ex) {
            conn.RollBack();
            Sys.errorLog(ex, conn.exeSQL, prgid);
            msg = "複製作業失敗";

            throw new Exception(msg, ex);
        }
        finally {
            conn.Dispose();
        }

        strOut.AppendLine("alert('" + msg + "');");
        if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.parent.Etop.goSearch();");
    }

    private bool copy_attach_opte(int pno) {
        string branch = ReqVal.TryGet("branch_" + pno, "");
        string bseq = ReqVal.TryGet("Bseq_" + pno, "");
        string bseq1 = ReqVal.TryGet("Bseq1_" + pno, "");

        string attach_name = ReqVal.TryGet("attach_name_" + pno, "");
        string strpath = ReqVal.TryGet("attach_path_" + pno, "");
        
        //因資料庫儲存的路徑仍為舊系統路徑,要改為project路徑
        strpath = strpath.Replace(@"\opt\", @"\nopt\");

        //建第一層目錄：區所案號+日期，如NTE12345-_-20160810
        string tfoldername = String.Format("{0}-{1}-{2}"
            , branch + Sys.GetSession("dept") + "E" + bseq
            , bseq1
            , DateTime.Now.ToString("yyyyMMdd"));

        if (Request["qrytodo"] == "recopy" && Request["recopy_flag"] == "Y") {
            tfoldername += "/重新複製";
        }

        //測試環境放置測試目錄下
        if (Sys.Host.IndexOf("web") > -1) {
            tfoldername = "測試/" + tfoldername;
        }

        //要將檔案copy至sin07/ToBJ
        string sendt_path = Sys.BJDir + "/" + tfoldername;
        Check_CreateFolder_virtual(sendt_path);

        if (Request["chkTest"] == "TEST") {
            Response.Write("copy1..<BR>" + strpath + "→" + sendt_path + attach_name + "<HR>");
            Response.Write("copy2..<BR>" + Server.MapPath(strpath) + "→" + Server.MapPath(sendt_path +"/" +attach_name) + "<HR>");
        }
        System.IO.File.Copy(Server.MapPath(strpath), Server.MapPath(sendt_path +"/" +attach_name), true);

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
    private bool update_attach_opte(DBHelper conn,int pno) {
        //入attach_opte_log
        Funcs.insert_log_table(conn, "U", prgid, "attach_opte", "attach_sqlno",ReqVal.TryGet("attach_sqlno_" + pno, ""));

        //更新上傳檔案複製註記
        SQL = "update attach_opte set attach_datebj=getdate() ";
        if (Request["qrytodo"]=="copy"){
            SQL+= ", attach_flagbj = 'Y'";
        }
        SQL+= ",tran_date=getdate()";
        SQL+= ",tran_scode='" + Session["scode"] + "'";
        SQL+= " where attach_sqlno = '"+ReqVal.TryGet("attach_sqlno_" + pno, "")+  "'";
        conn.ExecuteNonQuery(SQL);
        
        return true;
    }

    private void Sendmail(DBHelper conn, int pno, int filenum) {
        string Subject = "";
        string strFrom = Session["sc_name"] + "<" + Session["scode"] + "@saint-island.com.tw>";
        List<string> strTo = new List<string>();
        List<string> strCC = new List<string>();
        List<string> strBCC = new List<string>();
        switch (Sys.Host) {
            case "web08":
                strTo.Add(Session["scode"] + "@saint-island.com.tw");
                Subject = "(web08測試信)";
                break;
            case "web10":
                strTo.Add(Session["scode"] + "@saint-island.com.tw");
                Subject = "(web10測試信)";
                break;
            default:
                SQL = "Select a.cust_code from cust_code a inner join sysctrl.dbo.scode b on a.cust_code=b.scode ";
                SQL += " where a.code_type='oetobj' ";
                SQL += " and (b.end_date is null or b.end_date>=getdate()) ";
                SQL += " order by a.sortfld ";
                using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                    while (dr.Read()) {
                        strTo.Add(dr.SafeRead("cust_code", "") + "@saint-island.com.tw");
                    }
                }
                break;
        }

        string fseq = "", appl_name = "", arcase_name = "";
        SQL = "select Bseq,Bseq1,branch,in_scode,scode_name,cust_area,cust_seq";
        SQL += " ,appl_name,arcase_name,Last_date,country";
        SQL += " from vbr_opte where opt_sqlno='" + ReqVal.TryGet("opt_sqlno_" + pno, "") + "' and branch='" + ReqVal.TryGet("branch_" + pno, "") + "'";
        using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
            if (dr.Read()) {
                fseq = Funcs.formatSeq(dr.SafeRead("Bseq", ""), dr.SafeRead("Bseq1", ""), dr.SafeRead("country", ""), dr.SafeRead("Branch", ""), Sys.GetSession("dept") + "E");
                appl_name = dr.SafeRead("appl_name", "");
                arcase_name = dr.SafeRead("arcase_name", "");
            }
        }

        //目錄
        string branch = ReqVal.TryGet("branch_" + pno, "");
        string bseq = ReqVal.TryGet("Bseq_" + pno, "");
        string bseq1 = ReqVal.TryGet("Bseq1_" + pno, "");
        string tfoldername = String.Format("{0}-{1}-{2}"
            , branch + Sys.GetSession("dept") + "E" + bseq
            , bseq1
            , DateTime.Now.ToString("yyyyMMdd"));

        Subject += "爭救案複製至北京專區通知(區所案號：" + fseq + "，通知日期：" + DateTime.Now.ToString("yyyy/M/d") + ")";
        if (Request["qrytodo"] == "recopy" && Request["recopy_flag"] == "Y") {
            Subject += "-重新複製";
        }

        string body = "致 資訊部人員：<br><br>" +
                    "   煩請至北京專區資料夾協助將下列檔案目錄之檔案複製到北京主機之相同目錄，並於拷貝完成後回覆，以便爭議組承辦通知北京人員。謝謝！<br><br>" +
                    "【區所案件編號】 : " + fseq + "<br>" +
                    "【案件名稱】 : " + appl_name + "<br>" +
                    "【案性】 : " + arcase_name + "<br><Br>";
        if (Request["qrytodo"] == "recopy" && Request["recopy_flag"] == "Y") {
            body += "【檔案目錄】 :<B> ToBJ\\" + tfoldername + "\\重新複製</B><Br>";
        } else {
            body += "【檔案目錄】 :<B> ToBJ\\" + tfoldername + "</B><Br>";
        }
        body += "【檔案個數】 :<B> 共" + filenum + "個</B><Br><p>";

        Sys.DoSendMail(Subject, body, strFrom, strTo, strCC, strBCC);
    }
</script>

<script language="javascript" type="text/javascript">
    <%Response.Write(strOut.ToString());%>
</script>
