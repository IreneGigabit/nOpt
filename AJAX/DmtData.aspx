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

    protected void Page_Load(object sender, EventArgs e) {
        if (Request["branch"] == "N") strConnB = Conn.OptBN;
        if (Request["branch"] == "C") strConnB = Conn.OptBC;
        if (Request["branch"] == "S") strConnB = Conn.OptBS;
        if (Request["branch"] == "K") strConnB = Conn.OptBK;

        string cust_area = "";
        string cust_seq = "";
        string att_sql = "";
        string arcase_type = "";

        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "Select * from vbr_opt where opt_sqlno='" + Request["opt_sqlno"] + "' ";
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    cust_area = dr.SafeRead("cust_area", "");
                    cust_seq = dr.SafeRead("cust_seq", "");
                    att_sql = dr.SafeRead("att_sql", "");
                    arcase_type = dr.SafeRead("arcase_type", "");
                }
            }
        }

        DataTable rtnStr = null;
        if (Request["type"] == "brcust"){//客戶資料
            rtnStr = GetBRCust(cust_area,cust_seq);
        }

        if (Request["type"] == "brattlist") {//聯絡人清單
            rtnStr = GetBRAtt(cust_area,cust_seq);
        }
        if (Request["type"] == "bratt") {//指定聯絡人
            rtnStr = GetBRAtt(cust_area,cust_seq,att_sql);
        }

        if (Request["type"] == "arcaselist") {//案性
            rtnStr = GetArcase(arcase_type);
        }
        if (Request["type"] == "arcaseItemList") {//其他費用
            rtnStr = GetArcaseOther();
        }

        Response.Write(JsonConvert.SerializeObject(rtnStr, Formatting.Indented, new DBNullCreationConverter()));
    }

    #region GetBRCust 案件客戶
    private DataTable GetBRCust(string pcust_area,string pcust_seq) {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "Select *,''apclassnm,''ref_seqnm,''magnm ";
            SQL += "from vcustlist ";
            SQL += "where cust_area='" + pcust_area + "' and  cust_seq='" + pcust_seq + "' ";
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

            return dt;
        }
    }
    #endregion

    #region GetBRAtt 案件聯絡人
        private DataTable GetBRAtt(string pcust_area,string pcust_seq) {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "Select *,''deptnm,''magnm ";
            SQL += "from custz_att ";
            SQL += "where cust_area='" + pcust_area + "' ";
            SQL += "and cust_seq='" + pcust_seq + "' ";
            DataTable dt = new DataTable();
            connB.DataTable(SQL, dt);

            for (int i = 0; i < dt.Rows.Count; i++) {
                if (dt.Rows[i].SafeRead("dept", "").Trim() == "T")
                    dt.Rows[i]["deptnm"] = "商標";
                else if (dt.Rows[i].SafeRead("dept", "").Trim() == "P")
                    dt.Rows[i]["deptnm"] = "專利";

                if (dt.Rows[i].SafeRead("att_mag", "").Trim() == "Y")
                    dt.Rows[i]["magnm"] = "需要";
                else
                    dt.Rows[i]["magnm"] = "不需要";
            }

            return dt;
        }
    }

    private DataTable GetBRAtt(string pcust_area,string pcust_seq,string patt_sql) {
        DataTable oTable = GetBRAtt(pcust_area,pcust_seq);
        DataTable nTable = oTable.Select("att_sql='" + patt_sql + "'").CopyToDataTable();
        return nTable;
    }
    #endregion

    #region GetArcase 案辦案性
    private DataTable GetArcase(string type) {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "SELECT rs_code,prt_code,rs_detail,remark FROM  code_br WHERE  (mark = 'B' )";
            SQL += " And cr= 'Y' and dept='T' And rs_type='" + type + "' AND no_code='N' ";
            SQL += "and getdate() >= beg_date ";
            SQL += "ORDER BY rs_code";
            DataTable dt = new DataTable();
            connB.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region GetArcaseOther 其他費用案性
    private DataTable GetArcaseOther() {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "SELECT  rs_code, rs_detail FROM  code_br WHERE rs_class = 'Z1' ";
            SQL += "And cr= 'Y' and dept='T' AND no_code='N' ";
            SQL += "and getdate() >= beg_date ";
            SQL += "ORDER BY rs_code";
            DataTable dt = new DataTable();
            connB.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion
</script>
