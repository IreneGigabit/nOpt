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
        HTProgRight= myToken.CheckMe(false,true);

        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(false)) {
            isql = "select a.*,''fseq ";
            isql += ",(select code_name from cust_code as c where code_type='Ostat_code' and a.Bstat_code=c.cust_code) as stat_name ";
            isql += "from vbr_opt a ";
            isql += "where a.Bstat_code like 'Y%' and a.Bmark='N' ";

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
		    //權限控制
            if(!((HTProgRight & 64)!=0)){
                isql += " and a.ap_scode='" + Session["scode"] + "'";
            }
            if ((Request["qryOrder"] ?? "") != "") {
                isql += " order by " + Request["qryOrder"];
            }else{
                isql += " order by a.opt_no";
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
