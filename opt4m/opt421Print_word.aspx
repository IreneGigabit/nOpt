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
            strOut.AppendLine("    alert(\"爭救案件官發發文明細表 Word 產生失敗!!!\");");
            strOut.AppendLine("<" + "/script>");
            Response.Write(strOut.ToString());
            Response.Write(ex.Message);
            Response.Write(ex.StackTrace.Replace("\n","<BR>"));
        }
        finally {
            if (Rpt != null) Rpt.Dispose();
        }
    }

    protected void WordOut() {
        Dictionary<string, string> _tplFile = new Dictionary<string, string>();
        _tplFile.Add("gsrpt", Server.MapPath("~/ReportTemplate/報表/發文明細表.docx"));
        Rpt.CloneFromFile(_tplFile, true);
        string docFileName = string.Format("GS{0}-511T-{1:yyyyMMdd}.docx", send_way, DateTime.Today);

        string SQL = "", wSQL = "";
        DataTable dt = new DataTable();
        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(true)) {
            if ((Request["send_way"] ?? "") != "") wSQL += " and send_way='" + Request["send_way"] + "'";
            if ((Request["sdate"] ?? "") != "") wSQL += " and GS_date>='" + Request["sdate"] + "'";
            if ((Request["edate"] ?? "") != "") wSQL += " and GS_date<='" + Request["edate"] + "'";
            if ((Request["srs_no"] ?? "") != "") wSQL += " and rs_no>='" + Request["srs_no"] + "'";
            if ((Request["ers_no"] ?? "") != "") wSQL += " and rs_no<='" + Request["ers_no"] + "'";
            if ((Request["qryBranch"] ?? "") != "") wSQL += " and branch='" + Request["eseq"] + "'";
            if ((Request["sseq"] ?? "") != "") wSQL += " and seq>=" + Request["sseq"];
            if ((Request["eseq"] ?? "") != "") wSQL += " and seq<=" + Request["eseq"];
            if ((Request["cust_area"] ?? "") != "") wSQL += " and cust_area='" + Request["cust_area"] + "'";
            if ((Request["scust_seq"] ?? "") != "") wSQL += " and cust_seq>=" + Request["scust_seq"];
            if ((Request["ecust_seq"] ?? "") != "") wSQL += " and cust_seq<=" + Request["ecust_seq"];
            if ((Request["qrysend_dept"] ?? "") != "") wSQL += " and send_dept='" + Request["qrysend_dept"] + "'";

            SQL = "select send_cl,send_clnm,branch,Bseq,Bseq1,rs_no,gs_date,rs_detail,apply_no";
            SQL += ",Bfees,pr_scode,'正本' as sendmark,receipt_type,appl_name,bstep_grade,class,sortfld";
            SQL += ",''fseq,''branchname,''pr_scodenm,''rectitle";
            SQL += " from vbr_opt where Bstat_code='YS' and Bmark='N'";
            SQL += wSQL;
            SQL += " union ";
            SQL += "select send_cl1 as send_cl,send_cl1nm as send_clnm,branch,Bseq,Bseq1,rs_no,GS_date,rs_detail,apply_no";
            SQL += ",0 Bfees,pr_scode,'副本' as sendmark,receipt_type,appl_name,bstep_grade,class,sortfld";
            SQL += ",''fseq,''branchname,''pr_scodenm,''rectitle";
            SQL += " from vbr_opt where Bstat_code='YS' and Bmark='N'";
            SQL += wSQL + " and send_cl1 is not null";
            SQL += " group by send_cl,rs_no,send_clnm,send_cl1,send_cl1nm,branch,Bseq,Bseq1,rs_no,GS_date,rs_detail,apply_no,Bfees,pr_scode,receipt_type,appl_name,bstep_grade,class,sortfld";
            SQL += " order by sortfld,Branch,send_cl,Bseq,Bseq1,rs_no";
            conn.DataTable(SQL, dt);

            //整理資料
            for (int i = 0; i < dt.Rows.Count; i++) {
                using (DBHelper cnn = new DBHelper(Conn.Sysctrl).Debug(Request["chkTest"] == "TEST")) {
                    SQL = "select branchname from branch_code where branch='" + dt.Rows[i]["Branch"] + "'";
                    object objResult = cnn.ExecuteScalar(SQL);
                    dt.Rows[i]["branchname"] = (objResult == DBNull.Value || objResult == null ? "" : objResult.ToString());

                    string fseq = dt.Rows[i].SafeRead("branch", "") + Sys.GetSession("dept") + dt.Rows[i].SafeRead("bseq", "");
                    if (dt.Rows[i].SafeRead("bseq1", "") != "_") fseq += "-" + dt.Rows[i].SafeRead("bseq1", "");
                    dt.Rows[i]["fseq"] = fseq;
                    
                    if (dt.Rows[i].SafeRead("issue_no", "") != "") {
                        dt.Rows[i]["issue_no"] = "(" + dt.Rows[i].SafeRead("issue_no", "") + ")";
                    }
                    
                    SQL = "select sc_name from scode where scode='" + dt.Rows[i]["pr_scode"] + "'";
                    object objResult1 = cnn.ExecuteScalar(SQL);
                    dt.Rows[i]["pr_scodenm"] = (objResult == DBNull.Value || objResult == null ? "" : objResult.ToString());

                    if (dt.Rows[i].SafeRead("Bfees", "0") == "0") {
                        dt.Rows[i]["rectitle"] = "";
                    } else {
                        if (dt.Rows[i].SafeRead("receipt_type", "") == "E") {
                            dt.Rows[i]["rectitle"] = "電子收據(" + dt.Rows[i]["receipt_title"] + ")";
                        } else {
                            dt.Rows[i]["rectitle"] = "紙本收據";
                        }
                    }
                }
            }

	        int fees = 0;//小計規費
		    int Pcount = 0;//小計紙本收據件數
		    int Ecount = 0;//小計電子收據件數
		    int Zcount = 0;//小計無規費件數
	        int totfees = 0;//總計規費
		    int totPcount = 0;//總計紙本收據件數
		    int totEcount = 0;//總計電子收據件數
		    int totZcount = 0;//總計無規費件數

            //產生內容
            string title = "";
            if (send_way == "E") {
                title = "(電子送件)";
            } else if (send_way == "EA") {
                title = "(註冊費電子送件)";
            }
            DataTable dtBranch = dt.DefaultView.ToTable(true, new string[] { "branch", "branchname" });
            for (int i = 0; i < dtBranch.Rows.Count; i++) {
                totfees = 0;//總計規費
                totPcount = 0;//總計紙本收據件數
                totEcount = 0;//總計電子收據件數
                totZcount = 0;//總計無規費件數

                if (i != 0) Rpt.NewPage();
                Rpt.CopyTable("tbl_title");
                Rpt.ReplaceBookmark("br_nm", dtBranch.Rows[i].SafeRead("branchname", ""));
                Rpt.ReplaceBookmark("send_way", title);
                Rpt.ReplaceBookmark("sdate", Request["sdate"]);
                Rpt.ReplaceBookmark("edate", Request["edate"]);
                Rpt.ReplaceBookmark("pdate", DateTime.Today.ToShortDateString());

                DataTable dtCL = dt.Select("branch='" + dtBranch.Rows[i].SafeRead("branch", "") + "'").CopyToDataTable().DefaultView.ToTable(true, new string[] { "branch", "send_cl", "send_clnm" });
                for (int c = 0; c < dtCL.Rows.Count; c++) {
                    fees = 0;//小計規費
                    Pcount = 0;//小計紙本收據件數
                    Ecount = 0;//小計電子收據件數
                    Zcount = 0;//小計無規費件數

                    Rpt.CopyTable("tbl_cltitle");
                    Rpt.ReplaceBookmark("send_clnm", dtCL.Rows[c].SafeRead("send_clnm", ""));
                    DataTable dtDtl = dt.Select("branch='" + dtCL.Rows[c].SafeRead("branch", "") + "' and send_cl='" + dtCL.Rows[c].SafeRead("send_cl", "") + "'").CopyToDataTable();
                    for (int d = 0; d < dtDtl.Rows.Count; d++) {
                        Rpt.CopyTable("tbl_detail");
                        Rpt.ReplaceBookmark("seq", dtDtl.Rows[d].SafeRead("fseq", ""));
                        Rpt.ReplaceBookmark("rs_detail", dtDtl.Rows[d].SafeRead("rs_detail", ""));
                        Rpt.ReplaceBookmark("send_cl", dtDtl.Rows[d].SafeRead("sendmark", ""));
                        Rpt.ReplaceBookmark("step_date", Util.parseDBDate(dtDtl.Rows[d].SafeRead("GS_date", ""), "yyyy/M/d"));
                        Rpt.ReplaceBookmark("rs_no", dtDtl.Rows[d].SafeRead("rs_no", ""));
                        Rpt.ReplaceBookmark("step_grade", dtDtl.Rows[d].SafeRead("bstep_grade", ""));
                        Rpt.ReplaceBookmark("apply_no", dtDtl.Rows[d].SafeRead("apply_no", ""));
                        Rpt.ReplaceBookmark("issue_no", dtDtl.Rows[d].SafeRead("issue_no", ""));
                        Rpt.ReplaceBookmark("fees", dtDtl.Rows[d].SafeRead("Bfees", ""));
                        Rpt.ReplaceBookmark("appl_name", dtDtl.Rows[d].SafeRead("appl_name", ""));
                        Rpt.ReplaceBookmark("pr_nm", dtDtl.Rows[d].SafeRead("pr_scodenm", ""));
                        Rpt.ReplaceBookmark("rectitle", dtDtl.Rows[d].SafeRead("rectitle", ""));
                        Rpt.ReplaceBookmark("class", dtDtl.Rows[d].SafeRead("class", ""));

                        fees += Convert.ToInt32(dtDtl.Rows[d].SafeRead("Bfees", "0"));//小計規費
                        totfees += Convert.ToInt32(dtDtl.Rows[d].SafeRead("Bfees", ""));//總計規費
                        
                        if(Convert.ToInt32(dtDtl.Rows[d].SafeRead("Bfees", "0"))==0){
                            Zcount += 1;
                            totZcount += 1;
                        } else {
                            if (dtDtl.Rows[d].SafeRead("receipt_type", "") == "E") {
                                Ecount += 1;
                                totEcount += 1;
                            } else {
                                Pcount += 1;
                                totPcount += 1;
                            }
                        }
                    }
                    Rpt.CopyTable("tbl_subtot");
                    Rpt.ReplaceBookmark("ecnt", Ecount.ToString());
                    Rpt.ReplaceBookmark("pcnt", Pcount.ToString());
                    Rpt.ReplaceBookmark("zcnt", Zcount.ToString());
                    Rpt.ReplaceBookmark("cnt", (Ecount + Pcount + Zcount).ToString());
                    Rpt.ReplaceBookmark("sub_fees", fees.ToString());
                }
                Rpt.CopyTable("tbl_total");
                Rpt.ReplaceBookmark("tot_ecnt", totEcount.ToString());
                Rpt.ReplaceBookmark("tot_pcnt", totPcount.ToString());
                Rpt.ReplaceBookmark("tot_zcnt", totZcount.ToString());
                Rpt.ReplaceBookmark("tot_cnt", (totEcount + totPcount + totZcount).ToString());
                Rpt.ReplaceBookmark("tot_fees", totfees.ToString());
                
                Rpt.AddParagraph();
                Rpt.CopyBlock("b_foot");
            }

            if (dt.Rows.Count > 0) {
                Rpt.CopyPageFoot("gsrpt", false);//複製頁尾/邊界
                //Rpt.Flush(docFileName);
                Rpt.SaveAndFlush(Server.MapPath("~/ReportWord/" + docFileName), docFileName);
                //Rpt.SaveTo(Server.MapPath("~/ReportWord/" + docFileName));
            } else {
                strOut.AppendLine("<script language=\"javascript\">");
                strOut.AppendLine("    alert(\"無資料需產生\");");
                strOut.AppendLine("<" + "/script>");
                Response.Write(strOut.ToString());
            }
        }
    }
</script>

