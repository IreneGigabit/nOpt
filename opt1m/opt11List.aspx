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
            isql = "select a.*,''fseq,''ap_cname ";
            isql += "from vbr_opt a ";
            isql += "where a.Bstat_code is null and Bmark='N' ";

            if ((Request["qryBranch"]??"")!=""){
                isql+=" and a.Branch='"+Request["qryBranch"]+"'";
            }
            if ((Request["qryBSeq"]??"")!=""){
                isql+=" and a.Bseq='"+Request["qryBSeq"]+"'";
            }
            if ((Request["qryBSeq1"]??"")!=""){
                isql+=" and a.Bseq1='"+Request["qryBSeq1"]+"'";
            }
            if ((Request["qryBCaseDateS"]??"")!=""){
                isql+=" and a.Bcase_date>='"+Request["qryBCaseDateS"]+"'";
            }
            if ((Request["qryBCaseDateE"]??"")!=""){
                isql+=" and a.Bcase_date<='"+Request["qryBCaseDateE"]+"'";
            }

            if ((Request["SetOrder"] ?? "") != "") {
                isql += " order by " + Request["SetOrder"];
            }else{
                isql += " order by a.opt_sqlno";
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
                page.pagedTable.Rows[i]["fseq"]=Funcs.formatSeq(
                    page.pagedTable.Rows[i].SafeRead("Bseq", "")
                    ,page.pagedTable.Rows[i].SafeRead("Bseq1", "")
                    ,""
                    ,page.pagedTable.Rows[i].SafeRead("Branch", "")
                    ,Sys.GetSession("dept"));

                //申請人
                DataTable dt_ap = new DataTable();
                isql="select ap_cname from caseopt_ap ";
                isql += "where case_no='"+ page.pagedTable.Rows[i].SafeRead("case_no", "") + "' ";
                isql += "and opt_sqlno=" + page.pagedTable.Rows[i].SafeRead("opt_sqlno", "");
                conn.DataTable(isql, dt_ap);
                string ap_cname="";
                for (int j = 0; j < dt_ap.Rows.Count; j++) {
                    ap_cname+="、" + dt_ap.Rows[j]["ap_cname"].ToString();
                }
                ap_cname = ap_cname.Substring(Convert.ToInt16(ap_cname.Length > 0));
                page.pagedTable.Rows[i]["ap_cname"] = ap_cname.CutData(20);

                //案件名稱
                page.pagedTable.Rows[i]["appl_name"] = page.pagedTable.Rows[i].SafeRead("appl_name", "").CutData(30);
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
