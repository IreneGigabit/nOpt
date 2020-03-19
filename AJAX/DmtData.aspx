<%@ Page Language="C#" CodePage="65001" AutoEventWireup="true"  %>
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
    protected string SQL = "";
    protected string strConnB = "";

    protected string branch = "";
    protected string seq = "";
    protected string seq1 = "";

    //http://web08/nOpt/AJAX/OptData.aspx?branch=N&opt_sqlno=2453&_=1584086771124

    protected void Page_Load(object sender, EventArgs e) {
        strConnB = Conn.OptB(Request["branch"]);

        branch = Request["branch"];
        seq = Request["seq"];
        seq1 = Request["seq1"];

        DataTable dt_dmt = GetDmt(seq, seq1);//主檔
        DataTable dt_dmt_ap = GetDmtAp(seq, seq1);//申請人

        var settings = new JsonSerializerSettings() {
            Formatting = Formatting.Indented,
            ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
            Converters = new List<JsonConverter> { new DBNullCreationConverter() }//dbnull轉空字串
        };

        Response.Write("{");
        Response.Write("\"dmt\":" + JsonConvert.SerializeObject(dt_dmt, settings).ToUnicode() + "\n");
        Response.Write(",\"dmt_ap\":" + JsonConvert.SerializeObject(dt_dmt_ap, settings).ToUnicode() + "\n");
        Response.Write("}");

        //Response.Write(JsonConvert.SerializeObject(rtnStr, Formatting.Indented, new DBNullCreationConverter()).ToUnicode());
    }

    #region GetDmt 案件資料
    private DataTable GetDmt(string pSeq, string pSeq1) {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "select d.*,''custname,''apcust_no,''ap_cname,''now_arcasenm ";
            SQL += ",(select agt_name from agt a where a.agt_no=d.agt_no) agtname ";
            SQL += ",(select sc_name from sysctrl.dbo.scode s where s.scode=.scode) scodename ";
            SQL += ",(select code_name from cust_code c where code_type='tcase_stat' and c.cust_code=d.now_stat) now_statnm ";
            SQL += ",(select rs_detail from code_br b where cr='Y' and dept='" + Session["dept"] + "' and b.rs_type = d.arcase_type and b.rs_code=d.arcase) arcase ";
            SQL += ",(select rmark_code from custz z where z.cust_area=d.cust_area and z.cust_seq=d.cust_seq) rmarkcode ";
            SQL += "from dmt d ";
            SQL += "where d.seq='" + pSeq + "' and d.seq1='" + pSeq1 + "' ";
            DataTable dt = new DataTable();
            connB.DataTable(SQL, dt);
            if (dt.Rows.Count>0) {
                SQL = "select ap_cname1,ap_cname2 from apcust ";
                SQL += "where cust_area='" + dt.Rows[0].SafeRead("cust_area", "") + "' ";
                SQL += "and cust_seq='" + dt.Rows[0].SafeRead("cust_seq", "") + "' ";
                using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                    if (dr.Read()) {
                        dt.Rows[0]["custname"] = dr.SafeRead("ap_cname1", "").Trim() + dr.SafeRead("ap_cname2", "").Trim();
                    }
                }

                SQL = "select apcust_no,ap_cname from dmt_ap ";
                SQL += "where cust_area='" + dt.Rows[0].SafeRead("cust_area", "") + "' ";
                SQL += "and cust_seq='" + dt.Rows[0].SafeRead("cust_seq", "") + "' ";
                using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                    if (dr.Read()) {
                        dt.Rows[0]["apcust_no"] = dr.SafeRead("apcust_no", "").Trim();
                        dt.Rows[0]["ap_cname"] = dr.SafeRead("ap_cname", "").Trim();
                    }
                }
                
                
    if rs("now_grade") <> "" then
        SQL="select cg,rs from step_dmt where seq=" & seq & " and seq1='" & seq1 & "' " & _
        " and step_grade = " & rs("now_grade")
        rs1.Open SQL,conn1,1,1
        if not rs1.EOF then
            lf = rs1("cg") & rs1("rs")
        else
            lf = "cr"
        end if
        rs1.Close
    else
        lf = "cr"			
    end if
        
    SQL="select rs_class,rs_detail from code_br where " & lf & "='Y' and dept='" & ucase(session("dept")) & "' " & _
    " and rs_type = '" & rs("now_arcase_type") & "' and rs_code='"&rs("now_arcase")&"'"
    rs2.Open SQL,conn1,1,1
    if not rs2.EOF then
        lrs_class = rs2("rs_class")
        %>
        <now_arcasenm><%=rs2("rs_detail")%></now_arcasenm>	<%'29%>
    <%end if
            }

            return dt;
        }
    }
    #endregion

    #region GetDmtAp 申請人
    private DataTable GetDmtAp(string pSeq, string pSeq1) {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "Select a.*,b.ap_cname1,b.ap_cname2,b.ap_ename1,b.ap_ename2 ";
            SQL += "from dmt_ap a,apcust b ";
            SQL += "where a.apsqlno=b.apsqlno and seq='" + pSeq + "' and seq1='" + pSeq1 + "' ";

            DataTable dt = new DataTable();
            connB.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion
</script>
