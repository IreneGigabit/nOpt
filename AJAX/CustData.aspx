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
    protected string strConnB = "";
    /*Set connB = Server.CreateObject("ADODB.Connection")
Select Case Branch
Case "N"
	dbname="sindbs"
	connB.Open session("optBN")
Case "C"
	dbname="sicdbs"
	connB.Open session("optBC")
Case "S"
	dbname="sisdbs"
	connB.Open session("optBS")
Case "K"
	dbname="sikdbs"
	connB.Open session("optBK")
End Select
    */
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["branch"] == "N") strConnB = Conn.OptBN;
        if (Request["branch"] == "C") strConnB = Conn.OptBC;
        if (Request["branch"] == "S") strConnB = Conn.OptBS;
        if (Request["branch"] == "K") strConnB = Conn.OptBK;
        
        if(Request["type"]=="brcust") GetSquare();
    }
    
    private void GetSquare() {
        string cust_area = "";
        string cust_seq = "";
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "Select * from vbr_opt where opt_sqlno='" + Request["opt_sqlno"] + "' ";
            SqlDataReader dr = conn.ExecuteReader(SQL);
            if (dr.Read()) {
                cust_area = dr.SafeRead("cust_area", "");
                cust_seq = dr.SafeRead("cust_seq", "");
            }
        }
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "Select * from vcustlist ";
            SQL += "where cust_area='" + cust_area + "' and  cust_seq='" + cust_seq + "' ";
            DataTable dt = new DataTable();
            connB.DataTable(SQL,dt);
            
            Response.Write(JsonConvert.SerializeObject(dt, Formatting.Indented));
            Response.End();
        }
    }

</script>
