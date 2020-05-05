<%@ Page Language="C#" CodePage="65001" AutoEventWireup="true"  %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Text"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.IO"%>
<%@ Import Namespace = "System.Linq"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Web.Script.Serialization"%>
<%@ Import Namespace = "Newtonsoft.Json"%>

<script runat="server">
    protected string isql = "";
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected void Page_Load(object sender, EventArgs e) {
        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe(false, true);

        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(false)) {
            isql = "select a.*,b.sqlno as todo_sqlno,''fseq,''fext_seq,''optap_cname";
            isql += ",0 email_sqlno,0 maxemail_sqlno,''task,''todoname,''mail_status,''urlmail";
		    isql+= " from vbr_opte a ";
		    isql+= " inner join todo_opte b on b.opt_sqlno=a.opt_sqlno and b.dowhat='PR' and b.job_status='NN' ";
		    isql+= " where (a.Bstat_code like 'NN%' or a.Bstat_code like 'NX%') and a.Bmark='N'";
		    isql+= " and a.pr_branch='BJ' ";
            if ((Request["qrytodo"] ?? "") == "send") {
		       isql+= " and a.email_date is null ";
		    }else if ((Request["qrytodo"] ?? "") == "update") {
		       isql+= " and a.email_date is not null ";
		       isql+= " and (a.bpr_scode is null or a.bpr_scode='') ";
		    }

            if ((Request["qryopt_no"] ?? "") != "") {
                isql += " and a.Opt_no='" + Request["qryopt_no"] + "'";
            }
            if ((Request["qryBranch"] ?? "") != "") {
                isql += " and a.Branch='" + Request["qryBranch"] + "'";
            }
            if ((Request["qryBSeq"] ?? "") != "") {
            isql += " and a.Bseq='" + Request["qryBSeq"] + "'";
            }
            if ((Request["qryBSeq1"] ?? "") != "") {
                isql += " and a.Bseq1='" + Request["qryBSeq1"] + "'";
            }
            if ((Request["qryyour_no"] ?? "") != "") {
                isql += " and a.your_no='" + Request["qryyour_no"] + "'";
            }

            if ((Request["qryOrder"] ?? "") != "") {
                isql += " order by " + Request["qryOrder"];
            } else {
                isql += " order by a.in_date";
            }

            DataTable dt = new DataTable();
            conn.DataTable(isql, dt);

            //處理分頁
            int nowPage = Convert.ToInt32(Request["GoPage"] ?? "1"); //第幾頁
            int PerPageSize = Convert.ToInt32(Request["PerPage"] ?? "10"); //每頁筆數
            Paging page = new Paging(nowPage, PerPageSize, string.Join(";", conn.exeSQL.ToArray()));
            page.GetPagedTable(dt);

            string recopy_flag = "N";
            //分頁完再處理其他資料才不會虛耗資源
            for (int i = 0; i < page.pagedTable.Rows.Count; i++) {
                //組本所編號
                page.pagedTable.Rows[i]["fseq"] = Funcs.formatSeq(
                    page.pagedTable.Rows[i].SafeRead("Bseq", "")
                    , page.pagedTable.Rows[i].SafeRead("Bseq1", "")
                    , page.pagedTable.Rows[i].SafeRead("country", "")
                    , page.pagedTable.Rows[i].SafeRead("Branch", "")
                    , Sys.GetSession("dept") + "E");
                //國外所編號
                page.pagedTable.Rows[i]["fext_seq"] = Funcs.formatSeq(
                    page.pagedTable.Rows[i].SafeRead("ext_seq", "")
                    , page.pagedTable.Rows[i].SafeRead("ext_seq1", "")
                    , ""
                    , ""
                    , Sys.GetSession("dept") + "E");

                //申請人
                isql = "select ap_cname from caseopt_ap ";
                isql += "where opt_sqlno=" + page.pagedTable.Rows[i].SafeRead("opt_sqlno", "");
                string ap_cname = "";
                using (SqlDataReader dr = conn.ExecuteReader(isql)) {
                    while (dr.Read()) {
                        ap_cname += (ap_cname != "" ? "、" : "") + dr.SafeRead("ap_cname", "").Trim();
                    }
                }
                page.pagedTable.Rows[i]["optap_cname"] = ap_cname.CutData(20);

                //案件名稱
                page.pagedTable.Rows[i]["appl_name"] = page.pagedTable.Rows[i].SafeRead("appl_name", "").CutData(20);

                //email
                int email_sqlno = 0;
                int maxemail_sqlno = 0;
                string task = "A";
                string todoname = "E-mail";
                string mail_status = "send";

                //抓取已發信最大email_sqlno
                if (Convert.ToInt32("0" + page.pagedTable.Rows[i].SafeRead("email_cnt", "")) > 0) {
                    isql = "select max(email_sqlno) as maxemail_sqlno from opt_email_log where job_sqlno=" + page.pagedTable.Rows[i].SafeRead("opt_sqlno", "") + " and mail_status='send' ";
                    object objResult = conn.ExecuteScalar(isql);
                    maxemail_sqlno = (objResult == DBNull.Value || objResult == null ? 0 : (int)objResult);
                }

                //抓取暫存郵件email_sqlno
                isql = "select email_sqlno,mail_status from opt_email_log where job_sqlno=" + page.pagedTable.Rows[i].SafeRead("opt_sqlno", "") + " and mail_status='draft' ";
                using (SqlDataReader dr = conn.ExecuteReader(isql)) {
                    if (dr.Read()) {
                        email_sqlno = dr.SafeRead("email_sqlno", 0);
                        mail_status = dr.SafeRead("mail_status", "");
                    }
                }

                if (email_sqlno > 0) {
                    task = "U";
                    todoname = "草稿發送";
                }

                page.pagedTable.Rows[i]["email_sqlno"] = email_sqlno;
                page.pagedTable.Rows[i]["maxemail_sqlno"] = maxemail_sqlno;
                page.pagedTable.Rows[i]["task"] = task;
                page.pagedTable.Rows[i]["todoname"] = todoname;
                page.pagedTable.Rows[i]["mail_status"] = mail_status;

                page.pagedTable.Rows[i]["urlmail"] = "opte23_mailpreview.aspx?submittask=" + task +
                                 "&branch=" + page.pagedTable.Rows[i].SafeRead("branch", "") +
                                 "&opt_sqlno=" + page.pagedTable.Rows[i].SafeRead("opt_sqlno", "") +
                                 "&email_sqlno=" + email_sqlno + "&mail_status=" + mail_status +
                                 "&recordnum=" + (i + 1);
            }
            
            
            var settings = new JsonSerializerSettings()
            {
                Formatting = Formatting.Indented,
                ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
                Converters = new List<JsonConverter> { new DBNullCreationConverter(), new TrimCreationConverter() }//dbnull轉空字串且trim掉
            };
            Response.Write(JsonConvert.SerializeObject(page, settings).ToUnicode());
            Response.End();
        }
    }
</script>
