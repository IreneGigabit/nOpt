<%@ Page Language="C#"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Text"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.IO"%>
<%@ Import Namespace = "System.Linq"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Web.Script.Serialization"%>
<%@ Import Namespace = "Newtonsoft.Json"%>
<%@ Import Namespace = "Newtonsoft.Json.Linq"%>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e) {
        using (DBHelper conn = new DBHelper(Conn.Sysctrl).Debug(false)) {
            string isql = "select * from scode";

            if (Request["SetOrder"] != null && Request["SetOrder"] != "") isql += " order by " + Request["SetOrder"];
            DataTable dt = new DataTable();
            conn.DataTable(isql, dt);

            int nowPage = Convert.ToInt32(Request["GoPage"] ?? "1"); //第幾頁
            int PerPageSize = Convert.ToInt32(Request["PerPage"] ?? "10"); //每頁筆數
            Paging page = new Paging(nowPage, PerPageSize);
            page.GetPagedTable(dt);
            string str_json = JsonConvert.SerializeObject(page, Formatting.Indented);
            Response.Write(str_json);
        }
    }
</script>

