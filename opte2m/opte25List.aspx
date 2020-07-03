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
            isql = "select a.*,b.attach_sqlno,b.attach_no,b.attach_path,b.attach_desc,b.attach_name";
            isql += ",b.attach_datebj,b.attach_size";
            isql += ",''fseq,''fext_seq,''optap_cname,''pdf_path,''pdfsize,''recopy_flag";
            isql += " from vbr_opte a ";
            isql += " inner join attach_opte b on a.opt_sqlno=b.opt_sqlno and b.attach_flag<>'D' ";
            isql += " where (a.Bstat_code like 'NN%' or a.Bstat_code like 'NX%') and a.Bmark='N'";
            isql += " and a.pr_branch='BJ' ";

            if ((Request["qrytodo"] ?? "") == "copy") {
                isql += " and (b.attach_flagbj is null or b.attach_flagbj='' or b.attach_flagbj='N') ";
            } else if ((Request["qrytodo"] ?? "") == "recopy") {
                isql += " and b.attach_flagbj='Y' ";
            }
            if ((Request["qryopt_no"] ?? "") != "") {
                isql += " and a.Opt_no='" + Request["qryopt_no"] + "'";
            }
            if ((Request["qryBranch"] ?? "") != "") {
                isql += " and a.Branch='" + Request["qryBranch"] + "'";
            }
            isql += " and a.Bseq='" + Request["qryBSeq"] + "'";//必填條件
            if ((Request["qryBSeq1"] ?? "") != "") {
                isql += " and a.Bseq1='" + Request["qryBSeq1"] + "'";
            }
            if ((Request["qryinput_dateS"] ?? "") != "") {
                isql += " and a.opt_in_date>='" + Request["qryinput_dateS"] + "'";
            }
            if ((Request["qryinput_dateE"] ?? "") != "") {
                isql += " and a.opt_in_date<='" + Request["qryinput_dateE"] + "'";
            }

            if ((Request["qryOrder"] ?? "") != "") {
                isql += " order by " + Request["qryOrder"];
            } else {
                isql += " order by a.opt_sqlno,b.attach_no";
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
                //檢視檔案路徑session("webservername") & trim(RSreg("attach_path"))
                page.pagedTable.Rows[i]["pdf_path"] = Sys.Host + page.pagedTable.Rows[i].SafeRead("attach_path", "").Replace("\\", "/").Replace("/opt/", "/nopt/").Replace(@"\opt\", "/nopt/").Replace(@"/btbrt/", @"/nopt/");
                //檔案大小
                page.pagedTable.Rows[i]["pdfsize"] = (Convert.ToInt32("0" + page.pagedTable.Rows[i].SafeRead("attach_size", "")) / 1024) + 1;

                if((Request["qrytodo"] ?? "") == "recopy") {
                    if(Util.parseDBDate(page.pagedTable.Rows[i].SafeRead("attach_datebj", ""), "yyyy/M/d") == DateTime.Today.ToString("yyyy/M/d")) {
                        recopy_flag = "Y";
                    }
                }
                //是否同天複製
                page.pagedTable.Rows[i]["recopy_flag"] = recopy_flag;
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
