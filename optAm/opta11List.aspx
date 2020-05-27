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
            isql = "SELECT *,''law_detail_no,''law_mark_str ";
            isql += "FROM law_detail a ";
            isql += "LEFT JOIN cust_code b ON a.law_type = b.CUST_CODE and b.Code_type = 'law_type' ";
            isql += "where 1=1 ";

            if ((Request["qry_law_type"] ?? "") != "") {
                isql += " AND law_type = '" + Request["qry_law_type"] + "' ";
		    }
            if ((Request["qry_law_no1"] ?? "") != "") {
                isql += " and law_no1='" + Request["qry_law_no1"] + "'";
            }
            if ((Request["qry_law_no2"] ?? "") != "") {
                isql += " AND law_no2='" + Request["qry_law_no2"] + "'";
            }
            if ((Request["qry_law_no3"] ?? "") != "") {
                isql += " AND law_no3='" + Request["qry_law_no3"] + "'";
            }
            if ((Request["qry_law_mark"] ?? "") != "") {
                isql += " AND law_mark like '%" + Request["qry_law_mark"] + "%'";
            }
            if ((Request["qry_end_mark"] ?? "") != "") {
                if ((Request["qry_end_mark"] ?? "") == "Y") {
                    isql += " and ( a.end_date is not null OR a.end_date <> '')";
                } else {
                    isql += " and ( a.end_date is null OR a.end_date = '')";                    
                }
            }

            if ((Request["SetOrder"] ?? "") != "") {
                isql += " order by " + Request["SetOrder"];
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
                //條文法規
                string law_detail_no = "";
                if (page.pagedTable.Rows[i].SafeRead("law_no1", "") != "") {
                    law_detail_no += page.pagedTable.Rows[i].SafeRead("Code_name", "");
                    law_detail_no += "第" + page.pagedTable.Rows[i].SafeRead("law_no1", "") + "條";
                }
                if (page.pagedTable.Rows[i].SafeRead("law_no2", "") != "") {
                    law_detail_no += "第" + page.pagedTable.Rows[i].SafeRead("law_no2", "") + "款";
                }
                if (page.pagedTable.Rows[i].SafeRead("law_no3", "") != "") {
                    law_detail_no += "第" + page.pagedTable.Rows[i].SafeRead("law_no3", "") + "項";
                }
                page.pagedTable.Rows[i]["law_detail_no"] = law_detail_no;

                //法規內文
                page.pagedTable.Rows[i]["law_mark_str"] = page.pagedTable.Rows[i].SafeRead("law_mark", "").CutData(100);
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
