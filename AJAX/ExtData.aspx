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
    protected string opt_sqlno = "";
    protected string seq = "";
    protected string seq1 = "";

    //http://web08/nOpt/AJAX/OptData.aspx?branch=N&opt_sqlno=2453&_=1584086771124

    protected void Page_Load(object sender, EventArgs e) {
        strConnB = Conn.OptB(Request["branch"]);

        branch = Request["branch"];
        opt_sqlno = Request["opt_sqlno"];
        seq = Request["seq"];
        seq1 = Request["seq1"];

        DataTable dt_ext = GetExt(seq, seq1);//主檔
        DataTable dt_ext_ap = GetExtAp(seq, seq1);//申請人

        var settings = new JsonSerializerSettings() {
            Formatting = Formatting.Indented,
            ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
                Converters = new List<JsonConverter> { new DBNullCreationConverter(), new TrimCreationConverter() }//dbnull轉空字串且trim掉
        };

        Response.Write("{");
        Response.Write("\"ext\":" + JsonConvert.SerializeObject(dt_ext, settings).ToUnicode() + "\n");
        Response.Write(",\"ext_ap\":" + JsonConvert.SerializeObject(dt_ext_ap, settings).ToUnicode() + "\n");
        Response.Write("}");

        //Response.Write(JsonConvert.SerializeObject(rtnStr, Formatting.Indented, new DBNullCreationConverter()).ToUnicode());
    }

    #region GetExt 案件資料
    private DataTable GetExt(string pSeq, string pSeq1) {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "select d.*,''custname,'' agtname,''apcust_no,''ap_cname,''now_statnm ";
            SQL += ",''now_arcasenm,''now_rsclass,''renewal_agtname ";
            SQL += ",(select sc_name from sysctrl.dbo.scode s where s.scode=d.scode) scodename ";
            SQL += ",(select code_name from cust_code c where code_type='tcase_stat' and c.cust_code=d.now_stat) now_statnm ";
            SQL += ",(select rs_detail from code_br b where cr='Y' and dept='" + Session["dept"] + "' and b.rs_type = d.arcase_type and b.rs_code=d.arcase) arcase ";
            
            SQL += ",(select rmark_code from custz z where z.cust_area=d.cust_area and z.cust_seq=d.cust_seq) rmarkcode ";
            SQL += "from ext d ";
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
                
                SQL = "select agent_na1 from agent ";
                SQL += "where agent_no='" + dt.Rows[0].SafeRead("agt_no", "") + "' ";
                SQL += "and agent_no1='" + dt.Rows[0].SafeRead("agt_no1", "") + "' ";
                using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                    if (dr.Read()) {
                        dt.Rows[0]["agtname"] = dr.SafeRead("agent_na1", "").Trim();
                    }
                }

                SQL = "select code_name from cust_code ";
                SQL += "where code_type='tcase_stat' ";
                SQL += "and cust_code='" + dt.Rows[0].SafeRead("now_stat", "") + "' ";
                using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                    if (dr.Read()) {
                        dt.Rows[0]["now_statnm"] = dr.SafeRead("code_name", "").Trim();
                    }
                }
                
                SQL = "select apcust_no,ap_cname from ext_apcust ";
                SQL += "where seq='" + pSeq + "' and seq1='" + pSeq1 + "' ";
                using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                    if (dr.Read()) {
                        dt.Rows[0]["apcust_no"] = dr.SafeRead("apcust_no", "").Trim();
                        dt.Rows[0]["ap_cname"] = dr.SafeRead("ap_cname", "").Trim();
                    }
                }
                
                string lf="cr";
                SQL = "select cg,rs from step_dmt ";
                SQL += "where seq='" + pSeq + "' and seq1='" + pSeq1 + "' ";
                SQL += "and step_grade ='" + dt.Rows[0].SafeRead("now_grade", "") + "' ";
                using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                    if (dr.Read()) {
                        lf=dr.SafeRead("cg", "").Trim()+dr.SafeRead("rs", "").Trim();
                    }
                }

                SQL = "select rs_class,rs_detail from code_br ";
                SQL += "where " + lf + "='Y' and dept='" + Session["dept"] + "' ";
                SQL += "and rs_type='" + dt.Rows[0].SafeRead("now_arcase_type", "") + "' ";
                SQL += "and rs_code='" + dt.Rows[0].SafeRead("now_arcase", "") + "' ";
                using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                    if (dr.Read()) {
                        dt.Rows[0]["now_arcasenm"] = dr.SafeRead("rs_detail", "").Trim();
                        dt.Rows[0]["now_rsclass"] = dr.SafeRead("rs_class", "").Trim();
                    }
                }

                SQL = "select agent_na1 from agent ";
                SQL += "where agent_no='" + dt.Rows[0].SafeRead("renewal_agt_no", "") + "' ";
                SQL += "and agent_no1='" + dt.Rows[0].SafeRead("renewal_agt_no1", "") + "' ";
                using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                    if (dr.Read()) {
                        dt.Rows[0]["renewal_agtname"] = dr.SafeRead("agent_na1", "").Trim();
                    }
                }
            }

            return dt;
        }
    }
    #endregion

    #region GetExtAp 申請人
    private DataTable GetExtAp(string pSeq, string pSeq1) {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "Select a.* ";
            SQL += "from ext_apcust a ";
            SQL += "where a.seq='" + pSeq + "' and a.seq1='" + pSeq1 + "' ";

            DataTable dt = new DataTable();
            connB.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion
</script>
