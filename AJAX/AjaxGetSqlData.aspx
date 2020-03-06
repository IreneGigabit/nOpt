<%@ Page Language="C#" CodePage="65001" AutoEventWireup="true"  %>
<%@ Import Namespace="System.Data" %>
<%@Import Namespace = "System.Text"%>
<%@Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.IO"%>
<%@ Import Namespace = "System.Linq"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Web.Script.Serialization"%>
<%@ Import Namespace = "Newtonsoft.Json"%>
<%@ Import Namespace = "Newtonsoft.Json.Linq"%>

<script runat="server">
    protected string SQL = "";
    
    protected void Page_Load(object sender, EventArgs e)
    {
        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(false))
        {
            SQL = Request["SQL"];
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);
            Response.Write(JsonConvert.SerializeObject(dt, Formatting.Indented));
        }
    }
</script>
