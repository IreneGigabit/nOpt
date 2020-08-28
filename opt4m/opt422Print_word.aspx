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
            strOut.AppendLine("    alert(\"爭救案件官發規費明細表 Word 產生失敗!!!\");");
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
        _tplFile.Add("gsrpt", Server.MapPath("~/ReportTemplate/報表/官方規費明細表.docx"));
        Rpt.CloneFromFile(_tplFile, true);
        string docFileName = string.Format("GS{0}-512T-{1:yyyyMMdd}.docx", send_way, DateTime.Today);

        string SQL = "", wSQL = "";
        DataTable dt = new DataTable();
        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(false)) {
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

            SQL = "select distinct send_cl,send_clnm,sortfld,branch,Bseq,Bseq1,cust_area,cust_seq,ap_cname,rs_no,GS_date,rs_code,rs_detail";
            SQL += ",Bfees,Service,in_scode,appl_name,case_no,scode_name,rs_no";
            SQL += ",(select ar_mark from case_opt where opt_sqlno=a.opt_sqlno and a.mark='N') as ar_mark";
            SQL += ",''branchname,''fseq,''cust_name,''mp_text";
            SQL += " from vbr_opt a where a.Bstat_code='YS' and a.Bmark='N' ";
            SQL += wSQL + " and Bfees>0";
            SQL += " order by send_cl,sortfld,Bseq,Bseq1,a.rs_no";
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

                    if (Request["sdate"].ToString() == Request["edate"].ToString()) {
                        if (dt.Rows[i].SafeRead("mp_date", "") != "") {
                            dt.Rows[i]["mp_text"] = "總發文日期：" + Util.parseDBDate(dt.Rows[i].SafeRead("mp_date", ""), "yyyy/M/d");
                        }
                    }
                    
                    using (DBHelper connB = new DBHelper(Conn.OptB(dt.Rows[i].SafeRead("Branch", ""))).Debug(Request["chkTest"] == "TEST")) {
                        SQL = "Select RTRIM(ISNULL(ap_cname1, '')) + RTRIM(ISNULL(ap_cname2, ''))  as cust_name from apcust as c ";
                        SQL += " where c.cust_area='" + dt.Rows[i]["cust_area"] + "' and c.cust_seq='" + dt.Rows[i]["cust_seq"] + "'";
                        dt.Rows[i]["cust_name"] = dt.Rows[i].SafeRead("cust_area", "") + dt.Rows[i].SafeRead("cust_seq", "").PadLeft(5, '0');
                        using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                            if (dr.Read()) {
                                dt.Rows[i]["cust_name"] += dr.SafeRead("cust_name", "");
                            }
                        }
                    }
                }
            }

            int fees = 0;//小計規費
            int service = 0;//小計服務費
		    int count = 0;//小計件數

            //產生內容
            string title = "";
            if (send_way == "E") {
                title = "(電子送件)";
            } else if (send_way == "EA") {
                title = "(註冊費電子送件)";
            }
            DataTable dtBranch = dt.DefaultView.ToTable(true, new string[] { "branch", "branchname" });
            for (int i = 0; i < dtBranch.Rows.Count; i++) {
                if (i != 0) Rpt.NewPage();
                Rpt.CopyTable("tbl_title");
                Rpt.ReplaceBookmark("br_nm", dtBranch.Rows[i].SafeRead("branchname", ""));
                Rpt.ReplaceBookmark("send_way", title);
                Rpt.ReplaceBookmark("sdate", Request["sdate"]);
                Rpt.ReplaceBookmark("edate", Request["edate"]);
                Rpt.ReplaceBookmark("mp_date", dtBranch.Rows[i].SafeRead("mp_text", ""));
                Rpt.ReplaceBookmark("pdate", DateTime.Today.ToShortDateString());

                DataTable dtCL = dt.Select("branch='" + dtBranch.Rows[i].SafeRead("branch", "") + "'").CopyToDataTable().DefaultView.ToTable(true, new string[] { "branch", "send_cl", "send_clnm" });
                for (int c = 0; c < dtCL.Rows.Count; c++) {
                    fees = 0;//小計規費
                    service = 0;//小計服務費
                    count = 0;//小計件數

                    Rpt.CopyTable("tbl_cltitle");
                    Rpt.ReplaceBookmark("send_clnm", dtCL.Rows[c].SafeRead("send_clnm", ""));
                    DataTable dtDtl = dt.Select("branch='" + dtCL.Rows[c].SafeRead("branch", "") + "' and send_cl='" + dtCL.Rows[c].SafeRead("send_cl", "") + "'").CopyToDataTable();
                    for (int d = 0; d < dtDtl.Rows.Count; d++) {
                        Rpt.CopyTable("tbl_detail");
                        Rpt.ReplaceBookmark("seq", dtDtl.Rows[d].SafeRead("fseq", ""));
                        Rpt.ReplaceBookmark("appl_name", dtDtl.Rows[d].SafeRead("appl_name", ""));
                        Rpt.ReplaceBookmark("rs_code", dtDtl.Rows[d].SafeRead("rs_code", ""));
                        Rpt.ReplaceBookmark("rs_detail", dtDtl.Rows[d].SafeRead("rs_detail", ""));
                        Rpt.ReplaceBookmark("cust_name", dtDtl.Rows[d].SafeRead("cust_name", ""));
                        Rpt.ReplaceBookmark("case_no", dtDtl.Rows[d].SafeRead("case_no", ""));
                        Rpt.ReplaceBookmark("service", dtDtl.Rows[d].SafeRead("service", "0") + (dtDtl.Rows[d].SafeRead("ar_mark", "") == "D" ? "(D)" : ""));
                        Rpt.ReplaceBookmark("fees", dtDtl.Rows[d].SafeRead("Bfees", "0"));
                        Rpt.ReplaceBookmark("sc_name", dtDtl.Rows[d].SafeRead("scode_name", ""));

                        fees += Convert.ToInt32(dtDtl.Rows[d].SafeRead("Bfees", "0"));//小計規費
                        service += Convert.ToInt32(dtDtl.Rows[d].SafeRead("service", "0"));//總計規費
                        count += 1;
                    }
                    Rpt.CopyTable("tbl_subtot");
                    Rpt.ReplaceBookmark("cnt", count.ToString());
                    Rpt.ReplaceBookmark("sub_service", service.ToString());
                    Rpt.ReplaceBookmark("sub_fees", fees.ToString());
                }
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

