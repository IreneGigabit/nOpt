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

    protected void Page_Load(object sender, EventArgs e) {
        Token myToken = new Token(HTProgCode);
        myToken.CheckMe(false,true);

        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(false)) {
            isql = "select a.*,''fseq,''optap_cname ";
			isql += ",e.rs_detail AS case_name";
			isql += ",e.rs_class  AS Ar_form";
			isql += ",e.prt_code  AS prt_code";
            isql += ",e.reportp  AS reportp";
            isql += " from vbr_opt a ";
			isql += " inner join "+Sys.kdbname+".dbo.code_br e on e.rs_code=a.arcase AND e.dept = 'T' AND e.cr = 'Y' and e.no_code = 'N' and e.rs_type=a.arcase_type and e.prt_code not in ('null','D9Z','D3') ";
            isql += " LEFT OUTER JOIN " + Sys.kdbname + ".dbo.case_fee c ON a.arcase = c.rs_code and c.dept = 'T' AND c.country = 'T' AND (GETDATE() BETWEEN c.beg_date AND c.end_date) ";
            isql += " where 1=1 ";
            if ((Request["qryArcase"] ?? "") != "") {
                isql += " and a.arcase='" + Request["qryArcase"] + "'";
            }
            
            if ((Request["qryno_type"] ?? "") == "opt_no") {
                if ((Request["qrySopt_no"] ?? "") != "") {
                    isql += " and a.Opt_no>='" + Request["qrySopt_no"] + "'";
                }
                if ((Request["qryEopt_no"] ?? "") != "") {
                    isql += " and a.Opt_no<='" + Request["qryEopt_no"] + "'";
                }
            } else if ((Request["qryno_type"] ?? "") == "Bseq_no") {
                if ((Request["qryBranch"] ?? "") != "") {
                    isql += " and a.Branch='" + Request["qryBranch"] + "'";
                }
                if ((Request["qryBSeq"] ?? "") != "") {
                    isql += " and a.Bseq='" + Request["qryBSeq"] + "'";
                }
                if ((Request["qryBSeq1"] ?? "") != "") {
                    isql += " and a.Bseq1='" + Request["qryBSeq1"] + "'";
                }
            }
            
            if ((Request["qryPr_scode"] ?? "") != "") {
                isql += " and a.Pr_scode='" + Request["qryPr_scode"] + "'";
            }
            if ((Request["qrySin_date"] ?? "") != "") {
                isql += " and a.opt_in_date>='" + Request["qrySin_date"] + "'";
            }
            if ((Request["qryEin_date"] ?? "") != "") {
                isql += " and a.opt_in_date<='" + Request["qryEin_date"] + "'";
            }
            if ((Request["qrynew"] ?? "") != "") {
                isql += " and a.new='" + Request["qrynew"] + "'";
            }
            if ((Request["qryOrder"] ?? "") != "") {
                isql += " order by " + Request["qryOrder"];
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
                //組本所編號
                page.pagedTable.Rows[i]["fseq"] = Funcs.formatSeq(
                    page.pagedTable.Rows[i].SafeRead("Bseq", "")
                    , page.pagedTable.Rows[i].SafeRead("Bseq1", "")
                    , ""
                    , page.pagedTable.Rows[i].SafeRead("Branch", "")
                    , Sys.GetSession("dept"));

                isql = "select ap_cname from caseopt_ap where opt_sqlno=" + page.pagedTable.Rows[i].SafeRead("opt_sqlno", "");
                string ap_cname = "";
                using (SqlDataReader dr = conn.ExecuteReader(isql)) {
                    while (dr.Read()) {
                        ap_cname += (ap_cname != "" ? "、" : "") + dr.SafeRead("ap_cname", "").Trim();
                    }
                }

                //申請人
                page.pagedTable.Rows[i]["optap_cname"] = ap_cname.CutData(20);
                //案件名稱
                page.pagedTable.Rows[i]["appl_name"] = page.pagedTable.Rows[i].SafeRead("appl_name", "").CutData(20);
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
