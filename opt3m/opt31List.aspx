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
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼

    protected void Page_Load(object sender, EventArgs e) {
        Token myToken = new Token(prgid);
        myToken.CheckMe(false,true);

        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(false)) {
            isql = "select a.*,''fseq,''optap_cname ";
            isql += "from vbr_opt a ";
            isql += "where (a.Bstat_code like 'NN%' or a.Bstat_code like 'NX%') and Bmark='N' ";

            if ((Request["qryPr_scode"] ?? "") != "") {
                isql += " and a.Pr_scode='" + Request["qryPr_scode"] + "'";
            }
            if ((Request["qryopt_no"] ?? "") != "") {
                isql += " and a.Opt_no='" + Request["qryopt_no"] + "'";
            }
            if ((Request["qryBranch"]??"")!=""){
                isql+=" and a.Branch='"+Request["qryBranch"]+"'";
            }
            if ((Request["qryBSeq"]??"")!=""){
                isql+=" and a.Bseq='"+Request["qryBSeq"]+"'";
            }
            if ((Request["qryBSeq1"]??"")!=""){
                isql+=" and a.Bseq1='"+Request["qryBSeq1"]+"'";
            }

            if ((Request["qryOrder"] ?? "") != "") {
                isql += " order by " + Request["qryOrder"];
            }else{
                isql += " order by a.confirm_date";
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
                page.pagedTable.Rows[i]["fseq"] = Sys.formatSeq(
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
                Converters = new List<JsonConverter> { new DBNullCreationConverter() }//dbnull轉空字串
            };
            Response.Write(JsonConvert.SerializeObject(page, settings).ToUnicode());
            Response.End();
        }
    }


</script>
