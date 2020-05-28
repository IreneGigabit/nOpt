<%@ Page Language="C#"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient" %>
<%@ Import Namespace = "System.IO"%>
<%@ Import Namespace = "System.Linq"%>
<%@ Import Namespace = "System.Collections.Generic"%>

<script runat="server">
    protected string branch = "";
    protected string opt_sqlno = "";

	protected IPOReport ipoRpt = null;

	private void Page_Load(System.Object sender, System.EventArgs e) {
		Response.CacheControl = "Private";
		Response.AddHeader("Pragma", "no-cache");
		Response.Expires = -1;
		Response.Clear();

        branch = (Request["branch"] ?? "").ToString();//K
        opt_sqlno = (Request["opt_sqlno"] ?? "").ToString();//4
		try {
            ipoRpt = new IPOReport(branch, opt_sqlno)
			{
				ReportCode = "B5C1"
			};
			WordOut();
		}
		finally {
			if (ipoRpt != null) ipoRpt.Close();
		}
	}

	protected void WordOut() {
        string docFileName = "[聽證]-" + ipoRpt.Seq + ".docx";
		
		Dictionary<string, string> _tplFile = new Dictionary<string, string>(){
			{"apply", Server.MapPath("~/ReportTemplate/申請書/聽證申請書.docx")}
		};
		ipoRpt.CloneFromFile(_tplFile, true);

		DataTable opt = ipoRpt.Opt;
		if (opt.Rows.Count > 0) {
            //標題區塊
            ipoRpt.CopyBlock("b_barcode");
            ipoRpt.CopyBlock("b_title");
            ipoRpt.ReplaceBookmark("tyear", (DateTime.Today.Year - 1911).ToString());
            ipoRpt.ReplaceBookmark("tyear2", (DateTime.Today.Year - 1911).ToString());
            ipoRpt.ReplaceBookmark("issue_no", opt.Rows[0]["issue_no"].ToString().Trim());
            //商標或標章種類
            switch (opt.Rows[0]["s_mark"].ToString()) {
                case "S": ipoRpt.ReplaceBookmark("smark2", "Ｖ"); break;//
                case "L": ipoRpt.ReplaceBookmark("smark3", "Ｖ"); break;
                case "M": ipoRpt.ReplaceBookmark("smark4", "Ｖ"); break;
                case "N": ipoRpt.ReplaceBookmark("smark5", "Ｖ"); break;
                default: ipoRpt.ReplaceBookmark("smark1", "Ｖ"); break;
            }
            //案件種類
            switch (opt.Rows[0]["remark3"].ToString()) {
                case "DI1": ipoRpt.ReplaceBookmark("remark3_DI1", "Ｖ"); break;
                case "DO1": ipoRpt.ReplaceBookmark("remark3_DO1", "Ｖ"); break;
                case "DR1": ipoRpt.ReplaceBookmark("remark3_DR1", "Ｖ"); break;
            }
            //商標或標章名稱
            ipoRpt.ReplaceBookmark("appl_name", opt.Rows[0]["appl_name"].ToString().ToXmlUnicode());

            //申請人區塊
            ipoRpt.CopyBlock("b_ap");
            ipoRpt.ReplaceBookmark("apcust_num", ipoRpt.Apcust.Rows.Count.ToString());
            //申請人種類
            switch (opt.Rows[0]["detail_mark"].ToString()) {
                case "A": ipoRpt.ReplaceBookmark("markA", "Ｖ"); break;
                case "I": ipoRpt.ReplaceBookmark("markI", "Ｖ"); break;
            }
            using (DataTable dtAp = ipoRpt.Apcust) {
                for (int i = 0; i < dtAp.Rows.Count; i++) {
                    ipoRpt.CopyBlock("tbl_ap");
                    ipoRpt.ReplaceBookmark("apply_num", (i + 1).ToString());
                    ipoRpt.ReplaceBookmark("apcust_no", dtAp.Rows[i]["c_id"].ToString());
                    ipoRpt.ReplaceBookmark("ap_cname", dtAp.Rows[i]["Cname_string"].ToString().ToUnicode());
                    ipoRpt.ReplaceBookmark("ap_ename", dtAp.Rows[i]["Ename_string"].ToString().ToUnicode());
                    ipoRpt.ReplaceBookmark("ap_addr", dtAp.Rows[i]["c_zip"].ToString() + dtAp.Rows[i]["c_addr"].ToString().ToUnicode());
                    ipoRpt.ReplaceBookmark("ap_crep", dtAp.Rows[i]["ap_crep"].ToString().ToUnicode());
                    ipoRpt.ReplaceBookmark("ap_erep", dtAp.Rows[i]["ap_erep"].ToString().ToUnicode());
                    ipoRpt.ReplaceBookmark("server_flag", dtAp.Rows[i]["server_flag"].ToString() == "Y" ? "V" : "");
                }
            }
            ipoRpt.AddParagraph();
            
            //代理人
            ipoRpt.CopyBlock("b_agent");
            using (DataTable dtAgt = ipoRpt.Agent) {
                for (int i = 0; i < dtAgt.Rows.Count; i++) {
                    ipoRpt.ReplaceBookmark("apply_num", (i + 1).ToString());
                    ipoRpt.ReplaceBookmark("apcust_no", dtAgt.Rows[i]["c_id"].ToString());
                    ipoRpt.ReplaceBookmark("ap_cname", dtAgt.Rows[i]["Cname_string"].ToString().ToUnicode());
                    ipoRpt.ReplaceBookmark("ap_ename", dtAgt.Rows[i]["Ename_string"].ToString().ToUnicode());
                    ipoRpt.ReplaceBookmark("ap_addr", dtAgt.Rows[i]["c_zip"].ToString() + dtAgt.Rows[i]["c_addr"].ToString().ToUnicode());
                    ipoRpt.ReplaceBookmark("ap_crep", dtAgt.Rows[i]["ap_crep"].ToString().ToUnicode());
                    ipoRpt.ReplaceBookmark("ap_erep", dtAgt.Rows[i]["ap_erep"].ToString().ToUnicode());
                    ipoRpt.ReplaceBookmark("server_flag", dtAgt.Rows[i]["server_flag"].ToString() == "Y" ? "V" : "");
                }
            }
/*
			//事務所或申請人案件編號
			ipoRpt.ReplaceBookmark("seq", ipoRpt.Seq + "(" + DateTime.Today.ToString("yyyyMMdd") + ")");
			//商標或標章種類
            ipoRpt.ReplaceBookmark("s_mark", opt.Rows[0]["s_marknm"].ToString());
			//申請人
			using (DataTable dtAp = ipoRpt.Apcust) {
				for (int i = 0; i < dtAp.Rows.Count; i++) {
					ipoRpt.CopyBlock("b_apply");
					ipoRpt.ReplaceBookmark("apply_num", (i + 1).ToString());
					ipoRpt.ReplaceBookmark("ap_country", dtAp.Rows[i]["Country_name"].ToString());
					ipoRpt.ReplaceBookmark("ap_cname_title", dtAp.Rows[i]["Title_cname"].ToString());
					ipoRpt.ReplaceBookmark("ap_ename_title", dtAp.Rows[i]["Title_ename"].ToString());
					ipoRpt.ReplaceBookmark("ap_cname", dtAp.Rows[i]["Cname_string"].ToString().ToXmlUnicode());
					ipoRpt.ReplaceBookmark("ap_ename", dtAp.Rows[i]["Ename_string"].ToString().ToXmlUnicode(true), true);
				}
			}
			//代理人
			ipoRpt.CopyBlock("b_agent");
			using (DataTable dtAgt = ipoRpt.Agent) {
				ipoRpt.ReplaceBookmark("agt_name1", dtAgt.Rows[0]["agt_name1"].ToString());
				ipoRpt.ReplaceBookmark("agt_name2", dtAgt.Rows[0]["agt_name2"].ToString());
			}
			//申請內容
			ipoRpt.CopyBlock("b_content");
			ipoRpt.ReplaceBookmark("tran_remark1", opt.Rows[0]["tran_remark1"].ToString().ToXmlUnicode());
            if (opt.Rows[0]["tran_remark1"].ToString() != "") {
				ipoRpt.AddParagraph();
			}
			//繳費資訊
			ipoRpt.CreateFees();
            
            //具結
			ipoRpt.CopyBlock("b_sign");
*/
			ipoRpt.CopyPageFoot("apply");//申請書頁尾
		}
		ipoRpt.Flush(docFileName);
		ipoRpt.SetPrint();
	}
</script>
