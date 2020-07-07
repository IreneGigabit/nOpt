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

        ReqVal = Util.GetRequestParam(Context);

        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(false)) {
            isql = "SELECT *,''fBJTseq,''opt_comfirm_str,''opt_check_str,''law_detail_no ";
            isql+="FROM law_opt where 1=1 ";

            if ((Request["qry_opt_no"] ?? "") != "") {
                isql += " AND opt_no = '" + Request["qry_opt_no"] + "' ";
            }
            if ((Request["qry_BJTbranch"] ?? "") != "") {
                isql += " and BJTbranch='" + Request["qry_BJTbranch"] + "'";
            }
            if ((Request["qry_BJTSeq"] ?? "").Trim() != "") {
                isql += " AND BJTSeq='" + Request["qry_BJTSeq"] + "'";
            }
            if ((Request["qry_BJTSeq1"] ?? "").Trim() != "") {
                isql += " AND BJTSeq1='" + Request["qry_BJTSeq1"] + "'";
            }
            if ((Request["qry_branch"] ?? "") != "") {
                isql += " AND branch='" + Request["qry_branch"] + "'";
            }
            if ((Request["qry_BSeq"] ?? "").Trim() != "") {
                isql += " and Bseq='" + Request["qry_BSeq"] + "'";
            }
            if ((Request["qry_BSeq1"] ?? "").Trim() != "") {
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

            if ((Request["No_date"] ?? "") != "Y") {
                if ((Request["qry_pr_date_B"] ?? "") != "") {
                    isql += " and pr_date>='" + Request["qry_pr_date_B"] + "'";
                }
                if ((Request["qry_pr_date_E"] ?? "") != "") {
                    isql += " and pr_date<='" + Request["qry_pr_date_E"] + "'";
                }
            }

            if ((Request["qryOrder"] ?? "") != "") {
                isql += " order by " + Request["qryOrder"];
            } else {
                isql += " order by pr_date desc";
            }

            DataTable dt = new DataTable();
            conn.DataTable(isql, dt);

            //處理分頁
            int nowPage = Convert.ToInt32(Request["GoPage"] ?? "1"); //第幾頁
            int PerPageSize = Convert.ToInt32(Request["PerPage"] ?? "10"); //每頁筆數
            Paging page = new Paging(nowPage, PerPageSize, string.Join(";", conn.exeSQL.ToArray()));
            page.GetPagedTable(dt);

            //分頁完再處理其他資料才不會虛耗資源
            for (int i = 0; i < page.pagedTable.Rows.Count; i++) {

                //組北京案號
                page.pagedTable.Rows[i]["fBJTseq"] = Funcs.formatSeq(
                    page.pagedTable.Rows[i].SafeRead("BJTSeq", "")
                    , page.pagedTable.Rows[i].SafeRead("BJTSeq1", "")
                    , ""
                    , page.pagedTable.Rows[i].SafeRead("BJTbranch", "")
                    , "");

                //商標圖樣
                //page.pagedTable.Rows[i]["opt_pic_path"] = page.pagedTable.Rows[i].SafeRead("opt_pic_path", "").Replace("/", @"\").Replace(@"\opt\", @"\nopt\");
                page.pagedTable.Rows[i]["opt_pic_path"] = Sys.Path2Nopt(page.pagedTable.Rows[i].SafeRead("opt_pic_path", ""));

                //條款成立狀態
                switch (page.pagedTable.Rows[i].SafeRead("opt_comfirm", "")) {
                    case "1":
                        page.pagedTable.Rows[i]["opt_comfirm_str"] = "全部成立";
                        break;
                    case "2":
                        page.pagedTable.Rows[i]["opt_comfirm_str"] = "部分成立";
                        break;
                    case "3":
                        page.pagedTable.Rows[i]["opt_comfirm_str"] = "全部不成立";
                        break;
                }

                //裁決生效狀態
                switch (page.pagedTable.Rows[i].SafeRead("opt_check", "")) {
                    case "1":
                        page.pagedTable.Rows[i]["opt_check_str"] = "確定已生效";
                        break;
                    case "2":
                        page.pagedTable.Rows[i]["opt_check_str"] = "確定被推翻";
                        break;
                    case "3":
                        page.pagedTable.Rows[i]["opt_check_str"] = "救濟中或尚未能確定";
                        break;
                }

                //引用條文法規
                string law_detail_no="";
                if (page.pagedTable.Rows[i].SafeRead("ref_law", "") !="") {
                    isql = "SELECT * ";
                    isql += "from law_detail a ";
                    isql += "LEFT JOIN Cust_code b ON a.law_type=b.Cust_code and b.Code_type='law_type' ";
                    isql += "where law_sqlno in ('" + page.pagedTable.Rows[i].SafeRead("ref_law", "").Replace(",", "','") + "') ";
                    using (SqlDataReader dr = conn.ExecuteReader(isql)) {
                        while (dr.Read()) {
                            law_detail_no += (dr.SafeRead("Code_name", "") == "" ? "" : dr.SafeRead("Code_name", ""));
                            law_detail_no += (dr.SafeRead("law_no1", "") == "" ? "" : dr.SafeRead("law_no1", "") + "條");
                            law_detail_no += (dr.SafeRead("law_no2", "") == "" ? "" : dr.SafeRead("law_no2", "") + "款");
                            law_detail_no += (dr.SafeRead("law_no3", "") == "" ? "" : dr.SafeRead("law_no3", "") + "項");
                            law_detail_no += "<BR>";
                        }
                    }
                    page.pagedTable.Rows[i]["law_detail_no"] = law_detail_no;
                }
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
