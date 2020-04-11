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
        myToken.CheckMe(false, true);

        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(false)) {
            isql = "select a.*,''fseq,''optap_cname,''qbr,''tran_status ";
            isql += ",(select code_name from cust_code as c where code_type='Ostat_code' and a.Bstat_code=c.cust_code) as dowhat_name ";
            isql += " from vbr_opt a ";
            isql += " where a.Bmark='N' and (a.opt_no is not null) ";

            if ((Request["qryBranch"] ?? "") != "") {
                isql += " and a.Branch='" + Request["qryBranch"] + "'";
            }
            if ((Request["qryBSeq"] ?? "") != "") {
                isql += " and a.Bseq='" + Request["qryBSeq"] + "'";
            }
            if ((Request["qryBSeq1"] ?? "") != "") {
                isql += " and a.Bseq1='" + Request["qryBSeq1"] + "'";
            }
            if ((Request["qryCase_no"] ?? "") != "") {
                isql += " and a.Case_no='" + Request["qryCase_no"] + "'";
            }
            if ((Request["qryCust_area"] ?? "") != "") {
                isql += " and a.Cust_area='" + Request["qryCust_area"] + "'";
            }
            if ((Request["qryCust_seq"] ?? "") != "") {
                isql += " and a.Cust_seq='" + Request["qryCust_seq"] + "'";
            }
            if ((Request["qryap_cname"] ?? "") != "") {
                isql += " and ( a.ap_cname like '%" + Request["qryap_cname"] + "%' or a.ap_ename like '%" + Request["qryap_cname"] + "%') ";
            }
            if ((Request["qryappl_name"] ?? "") != "") {
                isql += " and a.appl_name like '%" + Request["qryappl_name"] + "%'";
            }

            if ((Request["qryOrder"] ?? "") != "") {
                isql += " order by " + Request["qryOrder"];
            } else {
                isql += " order by a.opt_no";
            }

            DataTable dt = new DataTable();
            conn.DataTable(isql, dt);

            //處理分頁
            int nowPage = Convert.ToInt32(Request["GoPage"] ?? "1"); //第幾頁
            int PerPageSize = Convert.ToInt32(Request["PerPage"] ?? "10"); //每頁筆數
            Paging page = new Paging(nowPage, PerPageSize);
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

                //申請人
                isql = "select ap_cname from caseopt_ap ";
                isql += "where case_no='" + page.pagedTable.Rows[i].SafeRead("case_no", "")+"' ";
                isql += "and opt_sqlno=" + page.pagedTable.Rows[i].SafeRead("opt_sqlno", "");
                string ap_cname = "";
                using (SqlDataReader dr = conn.ExecuteReader(isql)) {
                    while (dr.Read()) {
                        ap_cname += (ap_cname != "" ? "、" : "") + dr.SafeRead("ap_cname", "").Trim();
                    }
                }
                page.pagedTable.Rows[i]["optap_cname"] = ap_cname.CutData(30);

                //案件名稱
                page.pagedTable.Rows[i]["appl_name"] = page.pagedTable.Rows[i].SafeRead("appl_name", "").CutData(20);
                //承辦狀態
                isql = "Select max(Tran_status) as Tran_status from cancel_opt where opt_sqlno=" + page.pagedTable.Rows[i].SafeRead("opt_sqlno", "");
                using (SqlDataReader dr = conn.ExecuteReader(isql)) {
                    if (dr.Read()) {
                        page.pagedTable.Rows[i]["tran_status"] = dr.SafeRead("Tran_status", "").Trim();
                    }
                }

                if (page.pagedTable.Rows[i].SafeRead("tran_status", "") == "DT" || page.pagedTable.Rows[i].SafeRead("tran_status", "") == "DY")
                    page.pagedTable.Rows[i]["dowhat_name"] = "註銷中";
                else {
                    if (page.pagedTable.Rows[i].SafeRead("dowhat_name", "") == "")
                        page.pagedTable.Rows[i]["dowhat_name"] = "未收件";
                }
                //作業
                if (page.pagedTable.Rows[i].SafeRead("Case_no", "") != "")
                    page.pagedTable.Rows[i]["qbr"] = "N";
                else
                    page.pagedTable.Rows[i]["qbr"] = "Y";
            }

            var settings = new JsonSerializerSettings()
            {
                Formatting = Formatting.Indented,
                ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
                Converters = new List<JsonConverter> { new DBNullCreationConverter() }//dbnull轉空字串
            };
            Response.Write(JsonConvert.SerializeObject(page, settings).ToUnicode());
            Response.End();
        }
    }
</script>
