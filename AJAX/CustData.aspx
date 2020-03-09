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
            using(SqlDataReader dr = conn.ExecuteReader(SQL)){
                if (dr.Read()) {
                    cust_area = dr.SafeRead("cust_area", "");
                    cust_seq = dr.SafeRead("cust_seq", "");
                }
            }
        }
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "Select *,''apclassnm,''ref_seqnm,''magnm ";
            SQL += "from vcustlist ";
            SQL += "where cust_area='" + cust_area + "' and  cust_seq='" + cust_seq + "' ";
            DataTable dt = new DataTable();
            connB.DataTable(SQL,dt);

            for (int i = 0; i < dt.Rows.Count; i++) {
                switch (dt.Rows[i].SafeRead("apclass", "").Trim()) {
                    case "AA": dt.Rows[i]["apclassnm"] = "本國公司機關無統編者"; break;
                    case "AB": dt.Rows[i]["apclassnm"] = "公司與機關團體(大企業)"; break;
                    case "AC": dt.Rows[i]["apclassnm"] = "公司與機關團體(小企業)"; break;
                    case "B": dt.Rows[i]["apclassnm"] = "本國人(身份證)"; break;
                    case "CA": dt.Rows[i]["apclassnm"] = "外國人(自動流水號)"; break;
                    case "CB": dt.Rows[i]["apclassnm"] = "外國人(智慧財產局編碼)"; break;
                    case "CT": dt.Rows[i]["apclassnm"] = "外國人(國外所申請人號)"; break;
                }

                if (dt.Rows[i].SafeRead("ref_seq", "").Trim() != "" && dt.Rows[i].SafeRead("ref_seq", "").Trim() != "0") {
                    SQL = "select ap_cname1,ap_cname2 from apcust where cust_seq='" + dt.Rows[i].SafeRead("ref_seq", "") + "' ";
                    using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                        if (dr.Read()) {
                            dt.Rows[i]["ref_seqnm"] = dr.SafeRead("ap_cname1", "").Trim() + dr.SafeRead("ap_cname2", "").Trim();
                        }
                    }
                }
                
			    //配合區所顯示資料修改為下面寫法
                if (dt.Rows[i].SafeRead("mag", "").Trim() == "Y")
                    dt.Rows[i]["magnm"] = "需要";
                else
                    dt.Rows[i]["magnm"] = "不需要";
            }
                
            Response.Write(JsonConvert.SerializeObject(dt, Formatting.Indented));
            Response.End();
        }
    }

</script>
