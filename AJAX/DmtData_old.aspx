<%@ Page Language="C#" CodePage="65001" AutoEventWireup="true"  %>
<%@ Import Namespace="System.Data" %>
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

    protected void Page_Load(object sender, EventArgs e) {
        strConnB = Conn.OptB(Request["branch"]);

        string branch = "";
        string opt_sqlno = "";
        string cust_area = "";
        string cust_seq = "";
        string att_sql = "";
        string arcase_type = "";
        string case_no = "";
        
        DataTable dt = new DataTable();
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            //抓區所商標圖server主機名稱(iis)
            string uploadserver_name="";
            SQL = "Select code_name,form_name from cust_code where code_type='OSerName' and cust_code='" + Request["branch"] + "'";
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    uploadserver_name = dr.SafeRead("form_name", "");
                }
                if (uploadserver_name == "") {
                    if (Sys.Host == "web10") uploadserver_name = "web01";
                    else if (Sys.Host == "web08") uploadserver_name = "web02";
                    else uploadserver_name = Sys.Host;
                }
            }
            
            SQL = "Select *,''fseq,''drfile from vbr_opt where opt_sqlno='" + Request["opt_sqlno"] + "' ";
            conn.DataTable(SQL, dt);
            if (dt.Rows.Count>0) {
                branch = dt.Rows[0].SafeRead("branch", "");
                opt_sqlno = dt.Rows[0].SafeRead("opt_sqlno", "");
                cust_area = dt.Rows[0].SafeRead("cust_area", "");
                cust_seq = dt.Rows[0].SafeRead("cust_seq", "");
                att_sql = dt.Rows[0].SafeRead("att_sql", "");
                arcase_type = dt.Rows[0].SafeRead("arcase_type", "");
                case_no = dt.Rows[0].SafeRead("case_no", "");
                dt.Rows[0]["fseq"] = Sys.formatSeq(dt.Rows[0].SafeRead("Bseq", ""), dt.Rows[0].SafeRead("Bseq1", ""), "", dt.Rows[0].SafeRead("Branch", ""), Sys.GetSession("dept"));
                
                string drawFile = dt.Rows[0].SafeRead("draw_file", "");
                if (drawFile.IndexOf("\\") > -1) {//絕對路徑
                    string a = drawFile.Replace("\\", "/").ToLower();//斜線改方向
                    dt.Rows[0]["drfile"] = "http://" + uploadserver_name + "/btbrt" + a.Substring(a.IndexOf("/" + branch + "t/", StringComparison.OrdinalIgnoreCase));//擷取『/XT/』後(含)的字串
                } else {
                    dt.Rows[0]["drfile"] = "http://" + uploadserver_name + drawFile;
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
        
        if (Request["type"] == "braplist") {//案件申請人
            rtnStr = GetBRAP(case_no);
        }

        if (Request["type"] == "brcase") {//案件資料
            rtnStr = dt;
        }
        if (Request["type"] == "brcasefees") {//案件費用
            rtnStr = GetCaseFees(arcase_type, opt_sqlno, case_no, branch);
        }
        if (Request["type"] == "arcaselist") {//案性
            rtnStr = GetArcase(arcase_type);
        }
        if (Request["type"] == "arcaseItemList") {//其他費用案性
            rtnStr = GetArcaseItem();
        }
        if (Request["type"] == "arcaseOtherList") {//轉帳費用案性
            rtnStr = GetArcaseOther(arcase_type);
        }

        var settings = new JsonSerializerSettings()
        {
            Formatting = Formatting.Indented,
            ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
            Converters = new List<JsonConverter> { new DBNullCreationConverter() }//dbnull轉空字串
        };
        Response.Write(JsonConvert.SerializeObject(rtnStr, settings).ToUnicode());

        //Response.Write(JsonConvert.SerializeObject(rtnStr, Formatting.Indented, new DBNullCreationConverter()).ToUnicode());
    }

    #region GetBRCust 案件客戶
    private DataTable GetBRCust(string pCustArea,string pCustSeq) {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "Select *,''apclassnm,''ref_seqnm,''magnm ";
            SQL += "from vcustlist ";
            SQL += "where cust_area='" + pCustArea + "' and  cust_seq='" + pCustSeq + "' ";
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
    private DataTable GetBRAtt(string pCustArea, string pCustSeq) {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "Select *,''deptnm,''magnm ";
            SQL += "from custz_att ";
            SQL += "where cust_area='" + pCustArea + "' ";
            SQL += "and cust_seq='" + pCustSeq + "' ";
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

    private DataTable GetBRAtt(string pCustArea, string pCustSeq, string pAttSql) {
        DataTable oTable = GetBRAtt(pCustArea, pCustSeq);
        DataTable nTable = oTable.Select("att_sql='" + pAttSql + "'").CopyToDataTable();
        return nTable;
    }
    #endregion

    #region GetBRAP 案件申請人
    private DataTable GetBRAP(string pCaseNo) {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "SELECT d.apsqlno,d.Server_flag,d.ap_cname1,d.ap_cname2,d.ap_ename1,d.ap_ename2 ";
            SQL += ",d.ap_fcname,d.ap_lcname,d.ap_fename,d.ap_lename ";
            SQL += ",d.ap_sql,d.ap_zip as dmt_ap_zip,d.ap_addr1 as dmt_ap_addr1,d.ap_addr2 as dmt_ap_addr2 ";
            SQL += ",d.ap_eaddr1 as dmt_ap_eaddr1,d.ap_eaddr2 as dmt_ap_eaddr2,d.ap_eaddr3 as dmt_ap_eaddr3,d.ap_eaddr4 as dmt_ap_eaddr4 ";
            SQL += ",a.apcust_no,a.Apclass,a.Ap_country,a.Ap_crep,a.Ap_erep,a.Ap_addr1,a.Ap_addr2 ";
            SQL += ",a.Ap_eaddr1,a.Ap_eaddr2,a.Ap_eaddr3,a.Ap_eaddr4 ";
            SQL += ",a.Apatt_zip,a.Apatt_addr1,a.Apatt_addr2,a.Apatt_tel0 ";
            SQL += ",a.Apatt_tel,a.Apatt_tel1,a.Apatt_fax,a.Ap_zip ";
            SQL += "From dmt_temp_ap as d ";
            SQL += "inner join apcust as a on d.apsqlno=a.apsqlno ";
            SQL += "inner join case_dmt as b on d.in_no=b.in_no ";
            SQL += "Where b.case_no = '" + pCaseNo + "' and d.case_sqlno=0 ";
            DataTable dt = new DataTable();
            connB.DataTable(SQL, dt);

            for (int i = 0; i < dt.Rows.Count; i++) {
                //因交辦案件申請人先前無中英文地址，當無申請人序號，則依申請人檔資料顯示
                //若申請人序號>=0，則以交辦案件申請人為準
                if (dt.Rows[i].SafeRead("ap_sql", "") == "") {
                    dt.Rows[i]["ap_sql"] = "0";
                } else {
                    dt.Rows[i]["ap_zip"] = dt.Rows[i].SafeRead("dmt_ap_zip", "");
                    dt.Rows[i]["ap_addr1"] = dt.Rows[i].SafeRead("dmt_ap_addr1", "");
                    dt.Rows[i]["ap_addr2"] = dt.Rows[i].SafeRead("dmt_ap_addr2", "");
                    dt.Rows[i]["ap_eaddr1"] = dt.Rows[i].SafeRead("dmt_ap_eaddr1", "");
                    dt.Rows[i]["ap_eaddr2"] = dt.Rows[i].SafeRead("dmt_ap_eaddr2", "");
                    dt.Rows[i]["ap_eaddr3"] = dt.Rows[i].SafeRead("dmt_ap_eaddr3", "");
                    dt.Rows[i]["ap_eaddr4"] = dt.Rows[i].SafeRead("dmt_ap_eaddr4", "");
                }
            }
            
            return dt;
        }
    }
    #endregion

    #region GetCaseFees 交辦費用
    private DataTable GetCaseFees(string pType, string pOptSqlno,string pCaseNo,string pBranch) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select a.item_sql,a.item_arcase,a.item_count,a.item_service,a.item_fees,b.prt_code,c.service,c.fees,c.others,c.oth_code,c.oth_code1 ";
            SQL += "from caseitem_opt a ";
            SQL += "inner join "+Sys.tdbname+".dbo.code_br b on  a.item_arcase=b.rs_code AND b.no_code='N' and b.rs_type='"+pType+"' ";
            SQL += "left outer join "+Sys.tdbname+".dbo.case_fee c on c.dept='T' and c.country='T' and c.rs_code=a.item_arcase and getdate() between c.beg_date and c.end_date ";
            SQL += "where a.opt_sqlno='" + pOptSqlno + "' and a.Case_no= '" + pCaseNo + "' and a.Branch='" + pBranch + "' ";
            SQL += "order by a.item_sql";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region GetArcase 委辦案性
    private DataTable GetArcase(string pType) {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "SELECT rs_code,prt_code,rs_detail,remark ";
            SQL += "FROM code_br ";
            SQL += "WHERE  (mark = 'B' ) And cr= 'Y' and dept='T' And rs_type='" + pType + "' AND no_code='N' and getdate() >= beg_date ";
            SQL += "ORDER BY rs_code";
            DataTable dt = new DataTable();
            connB.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region GetArcaseItem 其他費用案性
    private DataTable GetArcaseItem() {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "SELECT  rs_code, rs_detail ";
            SQL += "FROM code_br ";
            SQL += "WHERE rs_class = 'Z1' And cr= 'Y' and dept='T' AND no_code='N' and getdate() >= beg_date ";
            SQL += "ORDER BY rs_code";
            DataTable dt = new DataTable();
            connB.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region GetArcaseOther 轉帳費用案性
    private DataTable GetArcaseOther(string pType) {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "SELECT rs_code,prt_code,rs_detail ";
            SQL += "FROM code_br ";
            SQL += "WHERE cr= 'Y' and dept='T' And rs_type='" + pType + "' AND no_code='N' and mark='M' ";
			SQL += "and getdate() >= beg_date and end_date is null ";
            SQL += "ORDER BY rs_code";
            DataTable dt = new DataTable();
            connB.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion
</script>
