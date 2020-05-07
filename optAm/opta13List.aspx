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

    protected Dictionary<string, string> ReqVal = new Dictionary<string, string>();

    protected void Page_Load(object sender, EventArgs e) {
        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe(false, true);

        ReqVal = Request.Form.ToDictionary();
        
        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(false)) {
            isql = "SELECT * FROM law_opt where 1=1 ";

            if ((Request["qry_opt_no"] ?? "") != "") {
                isql += " AND opt_no = '" + Request["qry_opt_no"] + "' ";
		    }
            if ((Request["qry_BJTbranch"] ?? "") != "") {
                isql += " and BJTbranch='" + Request["qry_BJTbranch"] + "'";
            }
            if ((Request["qry_BJTSeq"] ?? "") != "") {
                isql += " AND BJTSeq='" + Request["qry_BJTSeq"] + "'";
            }
            if ((Request["qry_BJTSeq1"] ?? "") != "") {
                isql += " AND BJTSeq1='" + Request["qry_BJTSeq1"] + "'";
            }
            if ((Request["qry_branch"] ?? "") != "") {
                isql += " AND branch='" + Request["qry_branch"] + "'";
            }
            if ((Request["qry_BSeq"] ?? "") != "") {
                isql += " and Bseq='" + Request["qry_BSeq"] + "'";
            }
            if ((Request["qry_BSeq1"] ?? "") != "") {
                isql += " and Bseq1='" + Request["qry_BSeq1"] + "'";
            }
            if ((Request["qry_pr_no"] ?? "") != "") {
                isql += " and pr_no='" + Request["qry_pr_no"] + "'";
            }
            if ((Request["qry_opt_comfirm"] ?? "") != "") {
                isql += " and opt_comfirm='" + Request["qry_opt_comfirm"] + "'";
            }
            if ((Request["qry_opt_check"] ?? "") != "") {
                isql += " and opt_check='" + Request["qry_opt_check"] + "'";
            }
            if ((Request["qry_opt_class"] ?? "") != "") {
                string[] arr_opt_class = ReqVal.TryGet("qry_opt_class", "").Split(',');
                isql += " AND (";
                for (int i = 0; i < arr_opt_class.Length; i++) {
                    isql += (i > 0 ? " OR" : "");
                    isql += " ','+opt_class+',' like '%," + arr_opt_class[i] + ",%'";
                }
                isql += " ) ";
            }

            if ((Request["No_date"] ?? "") != "Y") {
                if ((Request["qry_pr_date_B"] ?? "") != "") {
                    isql += " and pr_date>='" + Request["qry_pr_date_B"] + "'";
                }
                if ((Request["qry_pr_date_E"] ?? "") != "") {
                    isql += " and pr_date<='" + Request["qry_pr_date_E"] + "'";
                }
            }

            //法條搜尋條件
            bool first_check=false;//判斷有無填寫條件
            for (int i = 0; i < int.Parse(ReqVal.TryGet("class_num","0")); i++) {
                if ((Request["law_type1_"+i] ?? "") != ""
                    ||(Request["law_type2_"+i] ?? "") != ""
                    ||(Request["law_type3_"+i] ?? "") != "") {
                    first_check=true;
                    break;
                }
            }
            if (first_check) {
                isql += "  AND ( ";
                for (int i = 0; i < int.Parse(ReqVal.TryGet("class_num", "0")); i++) {
                    isql += (i == 0 ? " ( " : " OR ( ");
                    if ((Request["law_type1_" + i] ?? "") != "") {
                        isql += " ','+ref_law+',' like '%," + Request["law_type1_" + i] + ",%' ";
                    }
                    if ((Request["law_type2_" + i] ?? "") != "") {
                        isql += " AND ','+ref_law+',' like '%," + Request["law_type2_" + i] + ",%' ";
                    }
                    if ((Request["law_type3_" + i] ?? "") != "") {
                        isql += " AND ','+ref_law+',' like '%," + Request["law_type3_" + i] + ",%' ";
                    }
                    isql += " ) ";
                }
                isql += "  ) ";
            }

            
            for (int i = 0; i < int.Parse(ReqVal.TryGet("law_count","0")); i++) {
            }
            for (int i = 0; i < int.Parse(ReqVal.TryGet("law_CNot","0")); i++) {
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
