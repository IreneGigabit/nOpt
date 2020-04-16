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
    protected string cust_area = "";
    protected string cust_seq = "";
    protected string att_sql = "";
    protected string arcase_type = "";
    protected string case_no = "";
    protected string ar_form = "";
    protected string country = "";

    //http://web08/nOpt/AJAX/OptData.aspx?branch=N&opt_sqlno=2453&_=1584086771124

    protected void Page_Load(object sender, EventArgs e) {
        strConnB = Conn.OptB(Request["branch"]);

        branch = Request["branch"];
        opt_sqlno = Request["opt_sqlno"];

        DataTable dt_opt = GetBROpt(branch, opt_sqlno);//案件資料
        DataTable dt_cust = GetBRCust(cust_area, cust_seq);//客戶
        DataTable dt_attList = GetBRAtt(cust_area, cust_seq);//聯絡人清單
        DataTable dt_ap = GetBRAP(case_no);//申請人
        DataTable dt_casefee = GetCaseFees(arcase_type, opt_sqlno, case_no, branch, country);//交辦費用
        DataTable dt_arcase = GetArcase(arcase_type,ar_form);//委辦案性
        DataTable dt_arcaseItem = GetArcaseItem(ar_form);//其他費用案性
        DataTable dt_optePrior = GetOptePrior(opt_sqlno, case_no, branch);//優先權
        //DataTable dt_arcaseOther = GetArcaseOther(arcase_type);//轉帳費用案性
        DataTable dt_opteGood = GetOpteGood(opt_sqlno, case_no);//類別
        //DataTable dt_tran = GetTran(opt_sqlno);//異動
        //DataTable dt_tran_mod_client = GetTranModClient(case_no, opt_sqlno);//關係人
        //DataTable dt_tran_mod_dmt = GetTranModDmt(case_no, opt_sqlno);
        //DataTable dt_tran_mod_pul = GetTranModPul(case_no, opt_sqlno);
        //DataTable dt_tran_mod_ap = GetTranModAp(case_no, opt_sqlno);
        //DataTable dt_tran_mod_aprep = GetTranModAprep(case_no, opt_sqlno);
        //DataTable dt_tran_mod_claim1 = GetTranModClaim1(case_no, opt_sqlno);
        //DataTable dt_tran_mod_class = GetTranModClass(case_no, opt_sqlno);
        //DataTable dt_brdmt_attach = GetBRDmtAttach(case_no);
        //DataTable dt_opt_attach = GetOptAttach(opt_sqlno);

        var settings = new JsonSerializerSettings() {
            Formatting = Formatting.Indented,
            ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
            Converters = new List<JsonConverter> { new DBNullCreationConverter(),new TrimCreationConverter() }//dbnull轉空字串且trim掉
        };

        Response.Write("{");
        Response.Write("\"opt\":" + JsonConvert.SerializeObject(dt_opt, settings).ToUnicode() + "\n");
        Response.Write(",\"cust\":" + JsonConvert.SerializeObject(dt_cust, settings).ToUnicode() + "\n");
        Response.Write(",\"att_list\":" + JsonConvert.SerializeObject(dt_attList, settings).ToUnicode() + "\n");
        Response.Write(",\"caseap\":" + JsonConvert.SerializeObject(dt_ap, settings).ToUnicode() + "\n");
        Response.Write(",\"casefee\":" + JsonConvert.SerializeObject(dt_casefee, settings).ToUnicode() + "\n");
        Response.Write(",\"arcase\":" + JsonConvert.SerializeObject(dt_arcase, settings).ToUnicode() + "\n");
        Response.Write(",\"arcase_item\":" + JsonConvert.SerializeObject(dt_arcaseItem, settings).ToUnicode() + "\n");
        Response.Write(",\"opte_prior\":" + JsonConvert.SerializeObject(dt_optePrior, settings).ToUnicode() + "\n");
        //Response.Write(",\"arcase_other\":" + JsonConvert.SerializeObject(dt_arcaseOther, settings).ToUnicode() + "\n");
        Response.Write(",\"opte_good\":" + JsonConvert.SerializeObject(dt_opteGood, settings).ToUnicode() + "\n");
        //Response.Write(",\"tran\":" + JsonConvert.SerializeObject(dt_tran, settings).ToUnicode() + "\n");
        //Response.Write(",\"tran_mod_client\":" + JsonConvert.SerializeObject(dt_tran_mod_client, settings).ToUnicode() + "\n");
        //Response.Write(",\"tran_mod_dmt\":" + JsonConvert.SerializeObject(dt_tran_mod_dmt, settings).ToUnicode() + "\n");
        //Response.Write(",\"tran_mod_pul\":" + JsonConvert.SerializeObject(dt_tran_mod_pul, settings).ToUnicode() + "\n");
        //Response.Write(",\"tran_mod_ap\":" + JsonConvert.SerializeObject(dt_tran_mod_ap, settings).ToUnicode() + "\n");
        //Response.Write(",\"tran_mod_aprep\":" + JsonConvert.SerializeObject(dt_tran_mod_aprep, settings).ToUnicode() + "\n");
        //Response.Write(",\"tran_mod_claim1\":" + JsonConvert.SerializeObject(dt_tran_mod_claim1, settings).ToUnicode() + "\n");
        //Response.Write(",\"tran_mod_class\":" + JsonConvert.SerializeObject(dt_tran_mod_class, settings).ToUnicode() + "\n");
        //Response.Write(",\"brdmt_attach\":" + JsonConvert.SerializeObject(dt_brdmt_attach, settings).ToUnicode() + "\n");
        //Response.Write(",\"opt_attach\":" + JsonConvert.SerializeObject(dt_opt_attach, settings).ToUnicode() + "\n");
        Response.Write("}");

        //Response.Write(JsonConvert.SerializeObject(rtnStr, Formatting.Indented, new DBNullCreationConverter()).ToUnicode());
    }

    private string showDRFile(string pBranch, string pFile) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            //抓區所商標圖server主機名稱(iis)
            string uploadserver_name = Sys.webservername(pBranch);
            //SQL = "Select code_name,form_name from cust_code where code_type='OSerName' and cust_code='" + pBranch + "'";
            //DataTable dt = new DataTable();
            //
            //using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
            //    if (dr.Read()) {
            //        uploadserver_name = dr.SafeRead("form_name", "");
            //    }
            //    if (uploadserver_name == "") {
            //        if (Sys.Host == "web10") uploadserver_name = "web01";
            //        else if (Sys.Host == "web08") uploadserver_name = "web02";
            //        else uploadserver_name = Sys.Host;
            //    }
            //}

            string rtnStr = "";
            if (pFile.IndexOf("\\") > -1) {//絕對路徑
                string a = pFile.Replace("\\", "/").ToLower();//斜線改方向
                //擷取『/XT/』後(含)的字串
                rtnStr = "http://" + uploadserver_name + "/btbrt" + a.Substring(a.IndexOf("/" + branch + "t/", StringComparison.OrdinalIgnoreCase));
            } else {
                rtnStr = "http://" + uploadserver_name + pFile;
            }

            return rtnStr;
        }
    }

    private string showBRDmtFile(string pBranch, string pFile, string tname) {
        string servername = Sys.webservername(pBranch);

        if (pFile.IndexOf(".") > -1) {//路徑包含檔案
            return "http://" + servername + pFile;
        } else {
            return "http://" + servername + pFile + "/" + tname;
        }
    }

    #region GetBROpt 案件資料
    private DataTable GetBROpt(string pBranch,string pOptSqlno) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "Select *,''fseq,''drfile from vbr_opte where opt_sqlno='" + pOptSqlno + "' ";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);
            if (dt.Rows.Count>0) {
                branch = dt.Rows[0].SafeRead("branch", "");
                opt_sqlno = dt.Rows[0].SafeRead("opt_sqlno", "");
                cust_area = dt.Rows[0].SafeRead("cust_area", "");
                cust_seq = dt.Rows[0].SafeRead("cust_seq", "");
                att_sql = dt.Rows[0].SafeRead("att_sql", "");
                arcase_type = dt.Rows[0].SafeRead("arcase_type", "");
                case_no = dt.Rows[0].SafeRead("case_no", "");
                ar_form = dt.Rows[0].SafeRead("ar_form", "");

                dt.Rows[0]["fseq"] = Funcs.formatSeq(dt.Rows[0].SafeRead("Bseq", "")
                                    , dt.Rows[0].SafeRead("Bseq1", "")
                                    , dt.Rows[0].SafeRead("country", "")
                                    , dt.Rows[0].SafeRead("Branch", "")
                                    , Sys.GetSession("dept")+"E");
                dt.Rows[0]["drfile"] = showDRFile(pBranch,dt.Rows[0].SafeRead("draw_file", ""));
                dt.Rows[0]["send_dept"] = dt.Rows[0].SafeRead("send_dept", "B");

            }

            return dt;
        }
    }
    #endregion

    #region GetBRCust 案件客戶
    private DataTable GetBRCust(string pCustArea,string pCustSeq) {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "Select *,''apclassnm,''ref_seqnm,''magnm ";
            SQL += "from vcustlist ";
            SQL += "where cust_area='" + pCustArea + "' and  cust_seq='" + pCustSeq + "' ";
            //Select * from vcustlist where cust_area='K' and cust_seq='6168'
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
    #endregion

    #region GetBRAP 案件申請人
    private DataTable GetBRAP(string pCaseNo) {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "select a.* ";
            SQL += ",b.apcust_no,b.Apclass,b.Ap_country,b.Ap_crep,b.Ap_erep,b.apatt_zip,b.apatt_addr1,b.apatt_addr2,b.apatt_tel0,b.apatt_tel1,b.apatt_tel,b.apatt_fax ";
            SQL += ",(select code_name from cust_code where code_type='apclass' and cust_code=b.apclass) as apclassnm ";
            SQL += " from caseext_apcust a ";
            SQL += " inner join apcust b on a.apsqlno=b.apsqlno ";
            SQL += " inner join case_ext c on a.in_no=c.in_no ";
            SQL += " where  c.case_no='" + pCaseNo + "'";
            DataTable dt = new DataTable();
            connB.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region GetCaseFees 交辦費用
    private DataTable GetCaseFees(string pType, string pOptSqlno,string pCaseNo,string pBranch,string pCountry) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select a.*,b.service as P_service,b.fees as P_fees from caseitem_opte a ";
            SQL += "left outer join " + Sys.kdbname + ".dbo.case_fee b on b.dept='T' and b.country='" + pCountry + "' and b.rs_code=a.item_arcase and getdate() between b.beg_date and b.end_date ";
            SQL += "where opt_sqlno = '" + pOptSqlno + "' and case_no='" + pCaseNo + "' and branch='" + pBranch + "' ";
            SQL += "order by item_sql";

            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region GetArcase 委辦案性
    private DataTable GetArcase(string pType,string pAr_form) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "SELECT  rs_code, rs_detail ";
            SQL += "FROM " + Sys.kdbname + ".dbo.code_ext ";
            SQL += "WHERE rs_class like '" +pAr_form+ "%' And  cr_flag= 'Y' ";
            SQL += "And getdate() >= beg_date and (end_date is null or end_date='' or end_date > getdate()) ";
            SQL+="And (Mark is null or left(mark,1)<>'A') and rs_type='" +pType+ "' ORDER BY rs_code";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region GetArcaseItem 其他費用案性
    private DataTable GetArcaseItem(string pAr_form) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "SELECT  rs_code, rs_detail ";
            SQL += "FROM  " + Sys.kdbname + ".dbo.code_ext ";
            SQL += "WHERE rs_class like  '" + pAr_form + "%'  And  cr_flag= 'Y' and left(mark,1)='A' ";
            SQL += " and getdate() >= beg_date and (end_date is null or end_date='' or end_date > getdate()) ORDER BY rs_code";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion
    
    #region GetArcaseItem 其他費用案性
    private DataTable GetOptePrior(string pOptSqlno, string pCaseNo, string pBranch) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select * from caseopte_prior ";
            SQL += "where opt_sqlno='" + pOptSqlno + "' and case_no='" + pCaseNo + "' and branch='" + pBranch + "'";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

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

    #region GetOpteGood 類別
    private DataTable GetOpteGood(string pOptSqlno, string pCaseNo) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select * from caseopte_good where case_no='" + pCaseNo + "' and opt_sqlno='" + pOptSqlno + "' order by class ";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region GetTran 異動
    private DataTable GetTran(string pOptSqlno) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select * from opt_tran where opt_sqlno='" + pOptSqlno + "'";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region GetTranModClient 異動關係人
    private DataTable GetTranModClient(string pCaseNo,string pOptSqlno) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select * from opt_tranlist where case_no='" + pCaseNo + "' and opt_sqlno='" + pOptSqlno + "' and mod_field='mod_client'";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region GetTranModDmt 
    private DataTable GetTranModDmt(string pCaseNo,string pOptSqlno) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select *,''mod_dmt_ncname1,''mod_dmt_ncname2,''mod_dmt_nename1,''mod_dmt_nename2 ";
            SQL += ",''mod_dmt_ncrep,''mod_dmt_nerep ";
            SQL += ",''mod_dmt_neaddr1,''mod_dmt_neaddr2,''mod_dmt_neaddr3,''mod_dmt_neaddr4 ";
            SQL += "from opt_tranlist where case_no='" + pCaseNo + "' and opt_sqlno='" + pOptSqlno + "' and mod_field='mod_dmt'";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            for (int i = 0; i < dt.Rows.Count; i++) {
                dt.Rows[i]["mod_dmt_ncname1"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("ncname1", ""));
                dt.Rows[i]["mod_dmt_ncname2"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("ncname2", ""));
                dt.Rows[i]["mod_dmt_nename1"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("nename1", ""));
                dt.Rows[i]["mod_dmt_nename2"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("nename2", ""));
                dt.Rows[i]["mod_dmt_ncrep"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("ncrep", ""));
                dt.Rows[i]["mod_dmt_nerep"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("nerep", ""));
                dt.Rows[i]["mod_dmt_neaddr1"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("neaddr1", ""));
                dt.Rows[i]["mod_dmt_neaddr2"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("neaddr2", ""));
                dt.Rows[i]["mod_dmt_neaddr3"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("neaddr3", ""));
                dt.Rows[i]["mod_dmt_neaddr4"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("neaddr4", ""));
            }

            return dt;
        }
    }
    #endregion

    #region GetTranModPul
    private DataTable GetTranModPul(string pCaseNo, string pOptSqlno) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select * ";
            SQL += "from opt_tranlist where case_no='" + pCaseNo + "' and opt_sqlno='" + pOptSqlno + "' and mod_field='mod_pul'";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region GetTranModAp
    private DataTable GetTranModAp(string pCaseNo, string pOptSqlno) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select * ";
            SQL += "from opt_tranlist where case_no='" + pCaseNo + "' and opt_sqlno='" + pOptSqlno + "' and mod_field='mod_ap'";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region GetTranModAprep
    private DataTable GetTranModAprep(string pCaseNo, string pOptSqlno) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select * ";
            SQL += "from opt_tranlist where case_no='" + pCaseNo + "' and opt_sqlno='" + pOptSqlno + "' and mod_field='mod_aprep'";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region GetTranModClaim1
    private DataTable GetTranModClaim1(string pCaseNo, string pOptSqlno) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select * ";
            SQL += "from opt_tranlist where case_no='" + pCaseNo + "' and opt_sqlno='" + pOptSqlno + "' and mod_field='mod_claim1'";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region GetTranModClass
    private DataTable GetTranModClass(string pCaseNo, string pOptSqlno) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select *,''mod_class_ncname1,''mod_class_ncname2,''mod_class_nename1,''mod_class_nename2 ";
            SQL += ",''mod_class_ncrep,''mod_class_nerep ";
            SQL += ",''mod_class_neaddr1,''mod_class_neaddr2,''mod_class_neaddr3,''mod_class_neaddr4 ";
            SQL += "from opt_tranlist where case_no='" + pCaseNo + "' and opt_sqlno='" + pOptSqlno + "' and mod_field='mod_class'";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            for (int i = 0; i < dt.Rows.Count; i++) {
                dt.Rows[i]["mod_class_ncname1"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("ncname1", ""));
                dt.Rows[i]["mod_class_ncname2"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("ncname2", ""));
                dt.Rows[i]["mod_class_nename1"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("nename1", ""));
                dt.Rows[i]["mod_class_nename2"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("nename2", ""));
                dt.Rows[i]["mod_class_ncrep"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("ncrep", ""));
                dt.Rows[i]["mod_class_nerep"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("nerep", ""));
                dt.Rows[i]["mod_class_neaddr1"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("neaddr1", ""));
                dt.Rows[i]["mod_class_neaddr2"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("neaddr2", ""));
                dt.Rows[i]["mod_class_neaddr3"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("neaddr3", ""));
                dt.Rows[i]["mod_class_neaddr4"] = showDRFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("neaddr4", ""));
            }

            return dt;
        }
    }
    #endregion

    #region GetBRDmtAttach
    private DataTable GetBRDmtAttach(string pCaseNo) {
        using (DBHelper connB = new DBHelper(strConnB, false)) {
            SQL = "select *,''preview_path ";
            SQL += "from dmt_attach ";
            SQL += "where case_no='" +pCaseNo+ "' and source='case' and attach_flag<>'D' and attach_branch='B' ";
            SQL += " order by attach_sqlno ";

            DataTable dt = new DataTable();
            connB.DataTable(SQL,dt);
            for (int i = 0; i < dt.Rows.Count; i++) {
                dt.Rows[i]["preview_path"] = showBRDmtFile(dt.Rows[i].SafeRead("branch", ""), dt.Rows[i].SafeRead("attach_path", ""), dt.Rows[i].SafeRead("attach_name", ""));
            }

            return dt;
        }
    }
    #endregion

    #region GetOptAttach
    private DataTable GetOptAttach(string pOptSqlno) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            SQL = "select * ";
            SQL += ",(Select sc_name from sysctrl.dbo.scode where scode=add_scode) as add_scodenm ";
            SQL += " from attach_opt ";
            SQL += " where opt_sqlno='" + opt_sqlno + "' and attach_flag<>'D' ";
            SQL += " order by opt_sqlno,attach_no ";

            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion
</script>
