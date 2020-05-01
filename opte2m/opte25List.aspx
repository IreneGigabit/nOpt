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
            isql = "select a.*,b.creason,b.input_date,b.sqlno as cancel_sqlno";
            isql += ",c.sqlno as todo_sqlno,c.in_scode todo_scode,''fseq,''optap_cname ";
            isql += " from vbr_opte a ";
            isql += " inner join cancel_opte as b on a.opt_sqlno=b.opt_sqlno";
            isql += " inner join todo_opte as c on a.opt_sqlno=c.opt_sqlno and c.dowhat='DD' and c.job_status='NN' ";
            isql += " where (b.tran_status='DY') and a.Bmark='N' ";

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
            if ((Request["qryinput_dateS"] ?? "") != "") {
                isql += " and b.input_date>='" + Request["qryinput_dateS"] + "'";
            }
            if ((Request["qryinput_dateE"] ?? "") != "") {
                isql += " and b.input_date<='" + Request["qryinput_dateE"] + "'";
            }

            if ((Request["qryOrder"] ?? "") != "") {
                isql += " order by " + Request["qryOrder"];
            } else {
                isql += " order by b.input_date";
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
                    , page.pagedTable.Rows[i].SafeRead("country", "")
                    , page.pagedTable.Rows[i].SafeRead("Branch", "")
                    , Sys.GetSession("dept") + "E");

                //申請人
                isql = "select ap_cname from caseopt_ap ";
                isql += "where case_no='" + page.pagedTable.Rows[i].SafeRead("case_no", "") + "' ";
                isql += "and opt_sqlno=" + page.pagedTable.Rows[i].SafeRead("opt_sqlno", "");
                string ap_cname = "";
                using (SqlDataReader dr = conn.ExecuteReader(isql)) {
                    while (dr.Read()) {
                        ap_cname += (ap_cname != "" ? "、" : "") + dr.SafeRead("ap_cname", "").Trim();
                    }
                }
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
