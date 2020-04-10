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
            isql = "select a.*,''fseq,''send_dept_name ";
            isql += "from vbr_opt a ";
            isql += "where (a.Bstat_code like 'YY%') and a.Bmark='N' ";

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
            if ((Request["qryBMPDateS"]??"")!=""){
                isql+=" and a.GS_date>='"+Request["qryBMPDateS"]+"'";
            }
            if ((Request["qryBMPDateE"]??"")!=""){
                isql+=" and a.GS_date<='"+Request["qryBMPDateE"]+"'";
            }
            if ((Request["qrysend_dept"]??"")!=""){
                isql+=" and a.Send_dept='"+Request["qrysend_dept"]+"'";
            }else{
                isql+=" and a.Send_dept='B'";
            }

            if ((Request["qryOrder"] ?? "") != "") {
                isql += " order by " + Request["qryOrder"];
            }else{
                isql += " order by a.gs_date";
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
                string contract_flag = "";
                
                //組本所編號
                page.pagedTable.Rows[i]["fseq"] = Funcs.formatSeq(
                    page.pagedTable.Rows[i].SafeRead("Bseq", "")
                    , page.pagedTable.Rows[i].SafeRead("Bseq1", "")
                    , ""
                    , page.pagedTable.Rows[i].SafeRead("Branch", "")
                    , Sys.GetSession("dept"));

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
                page.pagedTable.Rows[i]["ap_cname"] = ap_cname.CutData(20);
                
                //案件名稱
                page.pagedTable.Rows[i]["appl_name"] = page.pagedTable.Rows[i].SafeRead("appl_name", "").CutData(20);
                
                //發文單位
                string send_dept_name = "";
                if (page.pagedTable.Rows[i].SafeRead("send_dept", "") == "B") {
                    send_dept_name = "專案室發文";
                } else if (page.pagedTable.Rows[i].SafeRead("send_dept", "") == "L") {
                    send_dept_name = "<font color='red'>轉發法律處</font><br><font size=-3>（請自行通知）</font>";
                }
                page.pagedTable.Rows[i]["send_dept_name"] = send_dept_name;
                
                //契約書後補
                using (DBHelper connB = new DBHelper(Conn.OptB(page.pagedTable.Rows[i].SafeRead("branch", ""))).Debug(false)) {
                    string SQL = "select contract_flag,contract_flag_date from case_dmt where case_no='" + page.pagedTable.Rows[i].SafeRead("case_no", "") + "'";
                    using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                        if (dr.Read()) {
                            contract_flag = dr.SafeRead("contract_flag", "");
                            if (dr.SafeRead("contract_flag_date", "") != "")
                                contract_flag = "N";
                        }
                    }
                }
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
