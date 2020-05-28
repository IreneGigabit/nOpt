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
                if (dtAgt.Rows.Count > 0) {
                    dtAgt.Rows[0]["agt_name1"] = dtAgt.Rows[0].SafeRead("agt_name1", "").Replace(",", "");
                    dtAgt.Rows[0]["agt_name2"] = dtAgt.Rows[0].SafeRead("agt_name2", "").Replace(",", "");
                    if (dtAgt.Rows[0].SafeRead("agt_id2", "") != "") {
                        ipoRpt.ReplaceBookmark("agt_id1", dtAgt.Rows[0].SafeRead("agt_id1", "") + "、" + dtAgt.Rows[0].SafeRead("agt_id2", ""));
                    } else {
                        ipoRpt.ReplaceBookmark("agt_id1", dtAgt.Rows[0].SafeRead("agt_id1", ""));
                    }

                    if (dtAgt.Rows[0].SafeRead("agt_name2", "") != "") {
                        ipoRpt.ReplaceBookmark("agt_name", dtAgt.Rows[0].SafeRead("agt_name1", "") + "、" + dtAgt.Rows[0].SafeRead("agt_name2", ""));
                    } else {
                        ipoRpt.ReplaceBookmark("agt_name", dtAgt.Rows[0].SafeRead("agt_name1", ""));
                    }

                    ipoRpt.ReplaceBookmark("agt_addr", dtAgt.Rows[0].SafeRead("agt_zip", "") + dtAgt.Rows[0].SafeRead("agt_addr", ""));
                    ipoRpt.ReplaceBookmark("agt_tel", dtAgt.Rows[0].SafeRead("agt_tel", ""));
                    ipoRpt.ReplaceBookmark("agt_fax", dtAgt.Rows[0].SafeRead("agt_fax", ""));

                    string agatt_tel = dtAgt.Rows[0].SafeRead("agatt_tel0", "");
                    agatt_tel += dtAgt.Rows[0].SafeRead("agatt_tel", "") == "" ? "" : "-" + dtAgt.Rows[0].SafeRead("agatt_tel", "");
                    ipoRpt.ReplaceBookmark("agatt_tel", agatt_tel);

                    ipoRpt.ReplaceBookmark("agatt_tel1", dtAgt.Rows[0].SafeRead("agatt_tel1", ""));
                }
            }

            //對照當事人
            ipoRpt.CopyBlock("b_mod");
            switch (opt.Rows[0]["tran_mark"].ToString()) {
                case "A": ipoRpt.ReplaceBookmark("tran_markA", "Ｖ"); break;
                case "I": ipoRpt.ReplaceBookmark("tran_markI", "Ｖ"); break;
            }
            using (DataTable dtMod = ipoRpt.TranListE.Where(row => row.SafeRead("mod_field", "") == "mod_client").CopyToDataTable()) {
                for (int i = 0; i < dtMod.Rows.Count; i++) {
                    ipoRpt.CopyBlock("tbl_mod");
                    ipoRpt.ReplaceBookmark("ncname", dtMod.Rows[i].SafeRead("ncname1", "").ToXmlUnicode());
                    ipoRpt.ReplaceBookmark("naddr", dtMod.Rows[i].SafeRead("naddr1", "").ToXmlUnicode());
                    ipoRpt.ReplaceBookmark("nagent", opt.Rows[0].SafeRead("other_item2", "").ToXmlUnicode());
                }
            }
            ipoRpt.AddParagraph();

            //應舉行聽證之理由
            ipoRpt.CopyBlock("b_content");
            ipoRpt.ReplaceBookmark("tran_remark1", opt.Rows[0].SafeRead("tran_remark1", "").ToXmlUnicode());

            ipoRpt.CopyPageFoot("apply");//申請書頁尾
		}
		ipoRpt.Flush(docFileName);
		ipoRpt.SetPrint();
	}
</script>
