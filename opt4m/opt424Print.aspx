<%@ Page Language="C#" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient" %>
<%@ Import Namespace = "System.IO"%>
<%@ Import Namespace = "System.Linq"%>
<%@ Import Namespace = "System.Collections.Generic"%>

<script runat="server">
    protected OpenXmlHelper Rpt = new OpenXmlHelper();
    protected StringBuilder strOut = new StringBuilder();

    protected string dept="";
    protected string send_way = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "Private";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;
        Response.Clear();

        dept = Sys.GetSession("dept");
        send_way = (Request["send_way"] ?? "").ToString();//E

        try {
            WordOut();
        }
        catch(Exception ex) {
            strOut.AppendLine("<script language=\"javascript\">");
            strOut.AppendLine("    alert(\"爭救案件發文回條 Word 產生失敗!!!\");");
            strOut.AppendLine("<" + "/script>");
            Response.Write(strOut.ToString());
            Response.Write(ex.Message);
        }
        finally {
            if (Rpt != null) Rpt.Dispose();
        }
    }

    protected void WordOut() {
        Dictionary<string, string> _tplFile = new Dictionary<string, string>();
        _tplFile.Add("gsrpt", Server.MapPath("~/ReportTemplate/報表/發文回條.docx"));
        Rpt.CloneFromFile(_tplFile, true);

        string docFileName = string.Format("GS{0}-514P-{1:yyyyMMdd}.docx", send_way, DateTime.Today);

        string SQL = "";
        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(true)) {
            SQL = "select in_scode,appl_name,apply_no,issue_no,rej_no,class,class_count,term1,term2,last_date";
            SQL += ",rs_no,tot_num,class_count,branch,Bseq,Bseq1,Bstep_grade,gs_date,mp_date,send_selnm,send_clnm,send_cl1nm,rs_class,rs_detail,Bfees,pr_scode";
            SQL += ",a.send_sel,(select mark1 from "+Sys.tdbname("K")+".cust_code where code_type='SEND_SEL' and cust_code=a.send_sel) as send_selfel";//發文性質的欄位名稱
            SQL += ",(select branchname from sysctrl.dbo.branch_code where branch=a.branch) as branchnm";
            SQL += ",send_way,receipt_type,receipt_title,rectitle_name";
            SQL += " from vbr_opt a where a.Bstat_code='YS' and a.Bmark='N' ";
            //20170605 因應電子收據上線，不顯示電子收據資料
            SQL += " and isnull(receipt_type,'')<>'E' ";
            
            if ((Request["send_way"] ?? "") != "") SQL += " and send_way='" + Request["send_way"] + "'";
            if ((Request["sdate"] ?? "") != "") SQL += " and GS_date>='" + Request["sdate"] + "'";
            if ((Request["edate"] ?? "") != "") SQL += " and GS_date<='" + Request["edate"] + "'";
            if ((Request["srs_no"] ?? "") != "") SQL += " and rs_no>='" + Request["srs_no"] + "'";
            if ((Request["ers_no"] ?? "") != "") SQL += " and rs_no<='" + Request["ers_no"] + "'";
            if ((Request["sseq"] ?? "") != "") SQL += " and seq>=" + Request["sseq"];
            if ((Request["eseq"] ?? "") != "") SQL += " and seq<=" + Request["eseq"];
            if ((Request["cust_area"] ?? "") != "") SQL += " and cust_area='" + Request["cust_area"] + "'";
            if ((Request["scust_seq"] ?? "") != "") SQL += " and cust_seq>=" + Request["scust_seq"];
            if ((Request["ecust_seq"] ?? "") != "") SQL += " and cust_seq<=" + Request["ecust_seq"];
            if ((Request["qrysend_dept"] ?? "") != "") SQL += " and send_dept='" + Request["qrysend_dept"] + "'";

            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            for (int i = 0; i < dt.Rows.Count; i++) {
                int runTime = 1;
                //副本有選擇要多一印份給副本收文者
                if (dt.Rows[i].SafeRead("send_cl1nm", "") != "") runTime = 2;

                for (int r = 1; r <= runTime; r++) {
                    Rpt.CopyBlock("b_table");
                    //總管處發文日期
                    DateTime mp_date;
                    string mpDate = DateTime.TryParse(dt.Rows[i].SafeRead("mp_date", ""), out mp_date) ? mp_date.ToShortDateString() : "";
                    Rpt.ReplaceBookmark("mp_date", mpDate);

                    //發文序號
                    string strrs_no = string.Format("發文({0})聖爭{1}　{2}　字第　B{3}　號"
                                        , DateTime.TryParse(mpDate, out mp_date) ? (mp_date.Year - 1911).ToString() : ""
                                        , (dept.ToUpper() == "T" ? "商" : "") + (dept.ToUpper() == "P" ? "專" : "")
                                        , dt.Rows[i].SafeRead("pr_scode", "")
                                        , dt.Rows[i].SafeRead("rs_no", "").Substring(3)
                                        );
                    Rpt.ReplaceBookmark("strrs_no", strrs_no);

                    //受文者，發文單位
                    if (r == 2) {
                        Rpt.ReplaceBookmark("send_clnm", "副本\n" + dt.Rows[i].SafeRead("send_cl1nm", ""));
                    } else {
                        Rpt.ReplaceBookmark("send_clnm", dt.Rows[i].SafeRead("send_clnm", ""));
                    }

                    //簡由，發文性質+案件名稱+發文內容
                    string send_detail = "";
                    string send_sel = dt.Rows[i].SafeRead("send_sel", "").Trim();
                    string str1 = "";
                    if (send_sel != "") {
                        switch (send_sel) {
                            case "1":
                                if (dt.Rows[i].SafeRead("apply_no", "").Trim() != "")
                                    str1 = "申請號 第　" + dt.Rows[i].SafeRead("apply_no", "").Trim() + "　號";
                                break;
                            case "2":
                                if (dt.Rows[i].SafeRead("issue_no", "").Trim() != "")
                                    str1 = "審定號 第　" + dt.Rows[i].SafeRead("issue_no", "").Trim() + "　號";
                                break;
                            case "3":
                                if (dt.Rows[i].SafeRead("rej_no", "").Trim() != "")
                                    str1 = "核駁號 第　" + dt.Rows[i].SafeRead("rej_no", "").Trim() + "　號";
                                break;
                            case "4":
                                if (dt.Rows[i].SafeRead("issue_no", "").Trim() != "")
                                    str1 = "註冊號 第　" + dt.Rows[i].SafeRead("issue_no", "").Trim() + "　號";
                                break;
                        }
                    }
                    if (send_detail != "" && str1 != "") send_detail += "\n";
                    send_detail += str1;

                    string str2 = dt.Rows[i].SafeRead("appl_name", "").Trim();
                    if (send_detail != "" && str2 != "") send_detail += "\n";
                    send_detail += str2;

                    string str3 = dt.Rows[i].SafeRead("rs_detail", "").Trim();
                    if (send_detail != "" && str3 != "") send_detail += "\n";
                    send_detail += str3;

                    string str4 = "";
                    if (dt.Rows[i].SafeRead("rs_class", "").Trim() == "A4") {
                        str4 = "專用期限:" + Util.parsedate(dt.Rows[i].SafeRead("term1", ""), "yyyy/M/d") + " ~ " + Util.parsedate(dt.Rows[i].SafeRead("term2", ""), "yyyy/M/d");
                    }
                    if (send_detail != "" && str4 != "") send_detail += "\n";
                    send_detail += str4;

                    string str5 = "";
                    if (dt.Rows[i].SafeRead("rs_class", "").Trim() == "A0"
                        || dt.Rows[i].SafeRead("rs_class", "").Trim() == "A1"
                        || dt.Rows[i].SafeRead("rs_class", "").Trim() == "A4"
                        ) {
                        str5 = "共:" + dt.Rows[i].SafeRead("class_count", "") + "類(" + dt.Rows[i].SafeRead("class", "") + ")";
                    }
                    if (send_detail != "" && str5 != "") send_detail += "\n";
                    send_detail += str5;

                    string str6 = "";
                    if (dt.Rows[i].SafeRead("send_way", "").Trim() == "E") {
                        str6 = "※電子送件";
                    } else if (dt.Rows[i].SafeRead("send_way", "").Trim() == "EA") {
                        str6 = "※註冊費電子送件";
                    }
                    if (send_detail != "" && str6 != "") send_detail += "\n";
                    send_detail += str6;

                    //20180621 增加收據抬頭,若是空白則不顯示
                    //有指定抬頭才要顯示
                    string receipt_title = dt.Rows[i].SafeRead("receipt_title", "");
                    string rectitle_name = "";
                    if (receipt_title == "A" || receipt_title == "C") {
                        if (receipt_title == "A") {
                            rectitle_name = dt.Rows[i].SafeRead("rectitle_name", "");
                        } else if (receipt_title == "C") {//專利權人(代繳人)
                            rectitle_name = dt.Rows[i].SafeRead("rectitle_name", "") + "(代繳人：聖島國際專利商標聯合事務所)";
                        }

                        send_detail += "\n收據抬頭：" + rectitle_name;
                    }
                    Rpt.ReplaceBookmark("send_detail", send_detail);

                    //本所編號
                    string seq = dt.Rows[i].SafeRead("branch", "") + dept + dt.Rows[i].SafeRead("Bseq", "");
                    if (dt.Rows[i].SafeRead("Bseq1", "_") != "_")
                        seq = dt.Rows[i].SafeRead("Bseq", "") + "-" + dt.Rows[i].SafeRead("Bseq1", "");
                    Rpt.ReplaceBookmark("seq", seq);

                    //最後期限，法定期限(本次官發銷管的管制日期)
                    Rpt.ReplaceBookmark("ctrl_date", Util.parsedate(dt.Rows[i].SafeRead("last_date", ""), "yyyy/M/d"));

                    //規費
                    if (r == 2)
                        Rpt.ReplaceBookmark("fees", "0 元");
                    else
                        Rpt.ReplaceBookmark("fees", dt.Rows[i]["Bfees"] + " 元");
                }
            }

            if (dt.Rows.Count > 0) {
                Rpt.CopyPageFoot("gsrpt", false);//複製頁尾/邊界
                Rpt.Flush(docFileName);
                //Rpt.SaveTo(Server.MapPath("~/reportdata/" + docFileName));
            } else {
                strOut.AppendLine("<script language=\"javascript\">");
                strOut.AppendLine("    alert(\"無資料需產生\");");
                strOut.AppendLine("<"+"/script>");
                Response.Write(strOut.ToString());
            }
        }
    }
</script>

