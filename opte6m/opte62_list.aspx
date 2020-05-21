<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "Newtonsoft.Json"%>
<%@ Import Namespace = "Newtonsoft.Json.Linq"%>

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string SQL = "";

    protected Dictionary<string, string> ReqVal = new Dictionary<string, string>();
    protected string hiddenText = "";
    protected Paging page = new Paging(1,10);
    protected string StrFormBtnTop = "";
    protected string titleLabel = "";
    
    protected string submitTask = "";

    DBHelper conn = null;//開完要在Page_Unload釋放,否則sql server連線會一直佔用
    private void Page_Unload(System.Object sender, System.EventArgs e) {
        if (conn != null) conn.Dispose();
    }

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");

        if (Request.RequestType == "GET") {
            ReqVal = Request.QueryString.ToDictionary();
        } else {
            ReqVal = Request.Form.ToDictionary();
        }
        foreach (KeyValuePair<string, string> p in ReqVal) {
            if (String.Compare(p.Key, "GoPage", true) != 0
                && String.Compare(p.Key, "PerPage", true) != 0
                && String.Compare(p.Key, "SetOrder", true) != 0)
                hiddenText += string.Format("<input type=\"hidden\" id=\"{0}\" name=\"{0}\" value=\"{1}\">\n", p.Key, p.Value);
        }
        
        submitTask = Request["submitTask"] ?? "";

        switch (prgid) {
            case "opte65":
                HTProgCap = "出口爭救案承辦工作量-明細表";
                break;
            default:
                HTProgCap = "爭救案案件查詢-清單";
                break;
        }

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            if (Request["chkTest"] == "TEST") {
                foreach (KeyValuePair<string, string> p in ReqVal) {
                    Response.Write(string.Format("{0}:{1}<br>", p.Key, p.Value));
                }
                Response.Write("<HR>");
            }

            QueryData();
            ListPageLayout();

            this.DataBind();
        }
    }

    private void ListPageLayout() {
        if ((Request["homelist"] ?? "") == "homelist") {
            StrFormBtnTop += "<a href=\"" + HTProgPrefix + ".aspx?prgid=" + prgid + "\"  target=\"Etop\">[查詢]</a>";
        } else {
            if ((Request["SubmitTask"] ?? "") == "Q") {
                StrFormBtnTop += "<a class=\"imgCls\" href=\"javascript:void(0);\" >[關閉視窗]</a>";
            } else {
                StrFormBtnTop += "<a href=\"" + HTProgPrefix + ".aspx?prgid=" + prgid + "\" >[查詢]</a>";
            }
        }

        //顯示查詢條件
        string qrybr_source_name = "";
        if ((Request["qrybr_source"] ?? "") == "br") {
            qrybr_source_name = "&nbsp;<font color=blue>◎交辦來源：</font>區所交辦";
        } else if ((Request["qrybr_source"] ?? "") == "opte") {
            qrybr_source_name = "&nbsp;<font color=blue>◎交辦來源：</font>新增分案";
        }

        string qryinclude_name = "";
        if ((Request["qryinclude"] ?? "") == "Y") {
            qryinclude_name = "&nbsp;<font color=blue>◎包含項目：</font>只印附屬案性";
        } else if ((Request["qryinclude"] ?? "") == "N") {
            qryinclude_name = "&nbsp;<font color=blue>◎包含項目：</font>不含附屬案性";
        }

        string qrybranch_name = "";
        if ((Request["qrybranch"] ?? "") == "N") {
            qrybranch_name = "&nbsp;<font color=blue>◎區所：</font>台北所";
        } else if ((Request["qrybranch"] ?? "") == "C") {
            qrybranch_name = "&nbsp;<font color=blue>◎區所：</font>台中所";
        } else if ((Request["qrybranch"] ?? "") == "S") {
            qrybranch_name = "&nbsp;<font color=blue>◎區所：</font>台南所";
        } else if ((Request["qrybranch"] ?? "") == "K") {
            qrybranch_name = "&nbsp;<font color=blue>◎區所：</font>高雄所";
        }

        string qryBseq_name = "";
        if ((Request["qryBseq"] ?? "") != "") {
            qryBseq_name = "&nbsp;<font color=blue>◎區所編號：</font>" + Request["qryBseq"];
        }
        if ((Request["qryBseq1"] ?? "") != "" && (Request["qryBseq1"] ?? "") != "_") {
            qryBseq_name += "-" + Request["qryBseq1"];
        }

        string qrycust_area_name = "";
        if ((Request["qrycust_seq"] ?? "") != "") {
            using (DBHelper connB = new DBHelper(Conn.OptB(ReqVal.TryGet("qrycust_area", ""))).Debug(Request["chkTest"] == "TEST")) {
                SQL = "Select RTRIM(ISNULL(ap_cname1, '')) + RTRIM(ISNULL(ap_cname2, '')) as cust_name from apcust as c ";
                SQL += " where c.cust_area='" + Request["qrycust_area"] + "' and c.cust_seq='" + Request["qrycust_seq"] + "'";
                object objResult = connB.ExecuteScalar(SQL);
                string cust_name = (objResult == DBNull.Value || objResult == null) ? "" : objResult.ToString();
                qrycust_area_name = "<BR>&nbsp;<font color=blue>◎客戶編號：</font>" + Request["qrycust_area"] + "-" + Request["qrycust_seq"] + "　" + cust_name;
            }
        }

        string qryin_scode_name = "";
        if ((Request["qryin_scode"] ?? "") != "") {
            SQL = "select sc_name from sysctrl.dbo.scode where scode='" + Request["qryin_scode"] + "'";
            object objResult = conn.ExecuteScalar(SQL);
            qryin_scode_name = (objResult == DBNull.Value || objResult == null) ? "" : objResult.ToString();
            qryin_scode_name = "&nbsp;<font color=blue>◎營洽：</font>" + qryin_scode_name;
        }

        string qrypr_scode_name = "";
        if ((Request["qrypr_scode"] ?? "") != "") {
            SQL = "select sc_name from sysctrl.dbo.scode where scode='" + Request["qrypr_scode"] + "'";
            object objResult = conn.ExecuteScalar(SQL);
            qrypr_scode_name = (objResult == DBNull.Value || objResult == null) ? "" : objResult.ToString();
            qrypr_scode_name = "&nbsp;<font color=blue>◎承辦人：</font>" + qrypr_scode_name;
        }

        string qryARCASE_name = "";
        if ((Request["qrypr_rs_code"] ?? "") != "") {
            SQL = "select cust_code+'-'+code_name from cust_code where code_type='bjtrs_code' and cust_code ='" + Request["qrypr_rs_code"] + "'";
            object objResult = conn.ExecuteScalar(SQL);
            qryARCASE_name = (objResult == DBNull.Value || objResult == null) ? "" : objResult.ToString();
            qryARCASE_name = "&nbsp;<font color=blue>◎案性：</font>" + qryARCASE_name;
        }
        if ((Request["qrypr_rs_class"] ?? "") != "") {
            SQL = "select cust_code+'-'+code_name arcase_name from cust_code where code_type='bjtrs_code' and form_name like '%" + Request["qrypr_rs_class"] + "%'";
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                while (dr.Read()) {
                    qryARCASE_name += (qryARCASE_name == "" ? "" : "、") + dr.SafeRead("arcase_name", "");
                }
            }
            qryARCASE_name = "&nbsp;<font color=blue>◎案性：</font>" + qryARCASE_name;
        }

        string qryKINDDATE_name = "";
        if ((Request["qrydtDATE"] ?? "") != "N") {
            if (ReqVal.TryGet("qryKINDDATE", "") == "CONFIRM_DATE") {
                qryKINDDATE_name = "<BR>&nbsp;<font color=blue>◎日期種類：</font>收文期間";
            } else if (ReqVal.TryGet("qryKINDDATE", "") == "BPR_DATE") {
                qryKINDDATE_name = "<BR>&nbsp;<font color=blue>◎日期種類：</font>承辦完成期間";
            } else if (ReqVal.TryGet("qryKINDDATE", "") == "last_date") {
                qryKINDDATE_name = "<BR>&nbsp;<font color=blue>◎日期種類：</font>法定期限";
            } else if (ReqVal.TryGet("qryKINDDATE", "") == "AP_DATE") {
                qryKINDDATE_name = "<BR>&nbsp;<font color=blue>◎日期種類：判行期間";
            } else if (ReqVal.TryGet("qryKINDDATE", "") == "BCase_date") {
                qryKINDDATE_name = "<BR>&nbsp;<font color=blue>◎日期種類：</font>交辦期間";
            }
        }

        string qryDATE_name = "";
        if (ReqVal.TryGet("qrySdate", "") != "" && ReqVal.TryGet("qryEdate", "") != "") {
            qryDATE_name = "&nbsp;<font color=blue>◎日期範圍：</font>" + ReqVal["qrySdate"] + "~" + ReqVal["qryEdate"];
        }

        string qrySTAT_CODE_name = "";
        if ((Request["qrySTAT_CODE"] ?? "") != "") {
            qrySTAT_CODE_name = "<BR>&nbsp;<font color=blue>◎承辦狀態：</font>";
            string[] arrSTAT_CODE = ReqVal.TryGet("qrySTAT_CODE", "").Split(';');
            for (int i = 0; i < arrSTAT_CODE.Length - 1; i++) {
                if (i > 0) qrySTAT_CODE_name += "、";
                if (arrSTAT_CODE[i] == "NA") {
                    qrySTAT_CODE_name += "[承辦中(包含未分案)]";
                } else if (arrSTAT_CODE[i] == "Y") {
                    qrySTAT_CODE_name += "[已結辦]";
                } else {
                    SQL = "select code_name from cust_code where code_type='OEStatCode' and cust_code ='" + arrSTAT_CODE[i] + "'";
                    object objResult = conn.ExecuteScalar(SQL);
                    string code_name = (objResult == DBNull.Value || objResult == null) ? "" : objResult.ToString();
                    qrySTAT_CODE_name += "[" + code_name + "]";
                }
            }
        }

        titleLabel = "<font color=red>" + qrybr_source_name + qryinclude_name +
            qrybranch_name + qryBseq_name + qrycust_area_name +
            qryin_scode_name + qrypr_scode_name + qryARCASE_name +
            qryKINDDATE_name + qryDATE_name + qrySTAT_CODE_name + "</font>";
    }

    private void QueryData() {
        //using (DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST")) {
            if (prgid == "opte65") {
                if (ReqVal.TryGet("qryKINDDATE", "") == "PR_DATE") ReqVal["qryKINDDATE"] = "BPR_DATE";
            }

            SQL = "SELECT Bseq,Bseq1,country,issue_no,appl_name,Confirm_date,your_no,apply_no,ext_seq,ext_seq1,br_source";
            SQL += ",last_date,arcase_name,isnull(Bpr_date,'') as Bpr_date,isnull(pr_hour,0) as pr_hour,isnull(pry_hour,0) as pry_hour";
            SQL += ",ap_date,a.brtran_date,a.pr_scode_name,b.code_name";
            SQL += ",branch,opt_sqlno,opt_no,case_no,emconf_date,email_cnt,bstat_code,pr_branch,pr_rs_code_name";
            SQL += ",''fseq,''fext_seq,''optap_cname,''oappl_name,''oBpr_date,''link";
            SQL += " FROM vbr_opte A ";
            SQL += " Left outer join cust_code as b on B.code_type='Oestatcode' and b.cust_code=a.bstat_code";
            SQL += " where 1=1 ";

            if ((Request["qryopt_no"] ?? "") != "") {
                SQL += " and a.opt_no='" + Request["qryopt_no"] + "'";
            }
            if ((Request["qryap_cname"] ?? "") != "") {
                //SQL += " and (a.ap_cname like '%" + Request["qryap_cname"] + "%' or a.ap_ename like '%" + Request["qryap_cname"] + "%')";
                SQL += " and rtrim(cast(a.opt_sqlno as char)) in (select rtrim(cast(opt_sqlno as char)) from caseopte_ap where ap_cname like '%" + Request["qryap_cname"] + "%')";
            }
            if ((Request["qrypr_branch"] ?? "") != "") {
                SQL += " and a.pr_branch='" + Request["qrypr_branch"] + "'";
            }
            if ((Request["qryPR_SCODE"] ?? "") != "") {
                SQL += " and a.bPR_SCODE='" + Request["qryPR_SCODE"] + "'";
            }
            if ((Request["qrypr_rs_code"] ?? "") != "") {
                SQL += " and a.pr_rs_code='" + Request["qrypr_rs_code"] + "'";
            }
            if ((Request["qrypr_rs_class"] ?? "") != "") {
                SQL += " and a.pr_rs_class='" + Request["qrypr_rs_class"] + "'";
            }

            if (ReqVal.TryGet("qryKINDDATE", "") != "") {
                if ((Request["month"] ?? "") != "") {
                    SQL += " and Year(a." + ReqVal.TryGet("qryKINDDATE", "") + ")='" + Request["qryYear"].Trim() + "' ";
                    SQL += " and month(a." + ReqVal.TryGet("qryKINDDATE", "") + ")='" + Request["month"].Trim() + "' ";
                    ReqVal["qrySdate"] = Request["qryYear"] + "/" + Request["month"].Trim() + "/1"; //上個月一號
                    ReqVal["qryEdate"] = new DateTime(Convert.ToInt32(Request["qryYear"].ToString()), Convert.ToInt32(Request["month"].Trim()), 1).AddMonths(1).AddDays(-1).ToShortDateString();
                } else {
                    if ((Request["submitTask"] ?? "") == "Q") {//從統計表來
                        ReqVal["qrySdate"] = Request["qryYear"] + "/" + Request["qrysMonth"].Trim() + "/1"; //上個月一號
                        ReqVal["qryEdate"] = new DateTime(Convert.ToInt32(Request["qryYear"].ToString()), Convert.ToInt32(Request["qryeMonth"].Trim()), 1).AddMonths(1).AddDays(-1).ToShortDateString();
                    }
                    if (ReqVal.TryGet("qrySdate", "") != "") {
                        SQL += " and a." + ReqVal.TryGet("qryKINDDATE", "") + ">='" + ReqVal.TryGet("qrySdate", "") + "' ";
                    }
                    if (ReqVal.TryGet("qryeDATE", "") != "") {
                        SQL += " and a." + ReqVal.TryGet("qryKINDDATE", "") + "<='" + ReqVal.TryGet("qryeDATE", "") + "' ";
                    }
                }
            }
            if ((Request["qrySTAT_CODE"] ?? "") != "") {
                string strSQL = "";
                string[] arrSTAT_CODE = ReqVal.TryGet("qrySTAT_CODE", "").Split(';');
                for (int i = 0; i < arrSTAT_CODE.Length - 1; i++) {
                    if (i > 0) strSQL += " or ";
                    if (arrSTAT_CODE[i] == "NA") {
                        strSQL += " a.bstat_code like 'R%' or a.bstat_code like 'N%' ";
                    } else if (arrSTAT_CODE[i] == "RR") {
                        strSQL += " a.bstat_code like 'R%' ";
                    } else if (arrSTAT_CODE[i] == "NN") {
                        strSQL += " a.bstat_code like 'NN%' or a.bstat_code like 'NX%' ";
                    } else if (arrSTAT_CODE[i] == "Y") {
                        strSQL += " a.bstat_code like 'NY%' or a.bstat_code like 'YY%' or a.bstat_code like 'YZ%' ";
                    } else {
                        strSQL += " a.Bstat_code like '" + arrSTAT_CODE[i] + "%' ";
                    }
                }
                SQL += "and (" + strSQL + " )";
            }

            if ((Request["qrybranch"] ?? "") != "") {
                SQL += " and a.branch='" + Request["qrybranch"] + "'";
            }
            if ((Request["qryBseq"] ?? "") != "") {
                SQL += " and a.Bseq='" + Request["qryBseq"] + "'";
            }
            if ((Request["qryBseq1"] ?? "") != "") {
                SQL += " and a.Bseq1='" + Request["qryBseq1"] + "'";
            }
            if ((Request["qryext_seq"] ?? "") != "") {
                SQL += " and a.ext_seq='" + Request["qryext_seq"] + "'";
            }
            if ((Request["qryext_seq1"] ?? "") != "") {
                SQL += " and a.ext_seq1='" + Request["qryext_seq1"] + "'";
            }
            if ((Request["qryinclude"] ?? "") == "Y") {
                SQL += " and a.ref_code is not null";
            } else if ((Request["qryinclude"] ?? "") == "N") {
                SQL += " and a.ref_code is  null";
            }
            if ((Request["qrycust_seq"] ?? "") != "") {
                SQL += " and a.cust_area='" + Request["qrycust_area"] + "'";
                SQL += " and a.cust_seq='" + Request["qrycust_seq"] + "'";
            }
            if ((Request["qryin_scode"] ?? "") != "") {
                SQL += " and a.in_scode='" + Request["qryin_scode"] + "'";
            }
            if ((Request["qryappl_name"] ?? "") != "") {
                SQL += " and a.appl_name like '%" + Request["qryappl_name"] + "%'";
            }
            if ((Request["qrykindno"] ?? "") != "" && (Request["qryno"] ?? "") != "") {
                SQL += " and a." + Request["qrykindno"] + " like '%" + Request["qryno"] + "%'";
            }
            //2014/6/23增加交辦(分案)來源
            if ((Request["qrybr_source"] ?? "") != "") {
                SQL += " and a.br_source='" + Request["qrybr_source"] + "'";
            }
            //刪除
            SQL += " and a.bmark not in ('B','D') ";
            if ((Request["SetOrder"] ?? "") != "") {
                SQL += " order by a.pr_scode," + Request["SetOrder"];
            } else {
                SQL += " order by a.pr_scode,a.BSEQ";
            }
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            //處理分頁
            int nowPage = Convert.ToInt32(Request["GoPage"] ?? "1"); //第幾頁
            int PerPageSize = Convert.ToInt32(Request["PerPage"] ?? "10"); //每頁筆數
            page = new Paging(nowPage, PerPageSize, string.Join(";", conn.exeSQL.ToArray()));
            page.GetPagedTable(dt);

            //分頁完再處理其他資料才不會虛耗資源
            for (int i = 0; i < page.pagedTable.Rows.Count; i++) {
                //組本所編號
                page.pagedTable.Rows[i]["fseq"] = Funcs.formatSeq(
                    page.pagedTable.Rows[i].SafeRead("Bseq", "")
                    , page.pagedTable.Rows[i].SafeRead("Bseq1", "")
                    , page.pagedTable.Rows[i].SafeRead("country", "")
                    , page.pagedTable.Rows[i].SafeRead("Branch", "")
                    , Sys.GetSession("dept") + "E");
                //國外所編號
                page.pagedTable.Rows[i]["fext_seq"] = Funcs.formatSeq(
                    page.pagedTable.Rows[i].SafeRead("ext_seq", "")
                    , page.pagedTable.Rows[i].SafeRead("ext_seq1", "")
                    , ""
                    , ""
                    , Sys.GetSession("dept") + "E");

                SQL = "select ap_cname from caseopte_ap where opt_sqlno=" + page.pagedTable.Rows[i].SafeRead("opt_sqlno", "");
                string ap_cname = "";
                using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                    while (dr.Read()) {
                        ap_cname += (ap_cname != "" ? "、" : "") + dr.SafeRead("ap_cname", "").Trim();
                    }
                }

                //申請人
                page.pagedTable.Rows[i]["optap_cname"] = ap_cname.CutData(20);
                //案件名稱
                page.pagedTable.Rows[i]["oappl_name"] = page.pagedTable.Rows[i].SafeRead("appl_name", "").CutData(20);
                //承辦狀態
                if (page.pagedTable.Rows[i].SafeRead("code_name", "") == "") {
                    page.pagedTable.Rows[i]["code_name"] = "未收件";
                }
                if (page.pagedTable.Rows[i].SafeRead("bstat_code", "") == "NN") {
                    if (page.pagedTable.Rows[i].SafeRead("emconf_date", "") == ""
                        && page.pagedTable.Rows[i].SafeRead("pr_branch", "") == "BJ") {
                            page.pagedTable.Rows[i]["code_name"] = "已分案，尚未寄出";
                    }
                } else if (page.pagedTable.Rows[i].SafeRead("bstat_code", "") == "YY") {
                    if (page.pagedTable.Rows[i].SafeRead("br_source", "") == "opte") {
                        page.pagedTable.Rows[i]["code_name"] = "已判行";
                    }
                }
                //完成日期
                page.pagedTable.Rows[i]["oBpr_date"] = Util.parsedate(page.pagedTable.Rows[i].SafeRead("Bpr_date", ""), "yyyy/M/d");
                if (page.pagedTable.Rows[i].SafeRead("oBpr_date", "") == "1900/1/1") {
                    page.pagedTable.Rows[i]["oBpr_date"] = "&nbsp;";
                }
                //連結
                string urlasp = "opt_sqlno=" + page.pagedTable.Rows[i].SafeRead("opt_sqlno", "") +
                        "&opt_no=" + page.pagedTable.Rows[i].SafeRead("opt_no", "") +
                        "&branch=" + page.pagedTable.Rows[i].SafeRead("opt_no", "") +
                        "&case_no=" + page.pagedTable.Rows[i].SafeRead("opt_no", "") +
                        "&prgid=" + prgid + "&submitTask=Q&back_flag=" + Request["back_flag"];
                if (page.pagedTable.Rows[i].SafeRead("case_no", "") != "") {
                    urlasp = "../opte2m/opte22Edit.aspx?" + urlasp;
                } else {
                    urlasp = "../opte2m/opte22EditA.aspx?" + urlasp;
                }
                page.pagedTable.Rows[i]["link"] = "<a href='" + urlasp + "' target='Eblank'>";
            }

            dataRepeater.DataSource = page.pagedTable;
            dataRepeater.DataBind();
        //}
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
<title><%=HTProgCap%></title>
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/inc/setstyle.css")%>" />
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/lib/jquery.datepick.css")%>" />
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/lib/toastr.css")%>" />
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery-1.12.4.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery.datepick.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery.datepick-zh-TW.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/toastr.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/util.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.irene.form.js")%>"></script>
</head>

<body>
<table cellspacing="1" cellpadding="0" width="98%" border="0" align="center">
    <tr>
        <td width="25%" class="text9" nowrap="nowrap">&nbsp;【<%=prgid%> <%=HTProgCap%>】</td>
        <td ><%#titleLabel%></td>
        <td width="15%" class="FormLink" align="right" nowrap="nowrap">
            <%#StrFormBtnTop%>
        </td>
    </tr>
    <tr>
        <td colspan="3"><hr class="style-one"/></td>
    </tr>
</table>

<form style="margin:0;" id="reg" name="reg" method="post">
    <%#hiddenText%>
    <div id="divPaging" style="display:<%#page.totRow==0?"none":""%>">
    <TABLE border=0 cellspacing=1 cellpadding=0 width="98%" align="center">
	    <tr>
		    <td colspan=2 align=center>
			    <font size="2" color="#3f8eba">
				    第<font color="red"><span id="NowPage"><%#page.nowPage%></span>/<span id="TotPage"><%#page.totPage%></span></font>頁
				    | 資料共<font color="red"><span id="TotRec"><%#page.totRow%></span></font>筆
				    | 跳至第
				    <select id="GoPage" name="GoPage" style="color:#FF0000"><%#page.GetPageList()%></select>
				    頁
				    <span id="PageUp" style="display:<%#page.nowPage>1?"":"none"%>">| <a href="javascript:void(0)" class="pgU" v1="<%#page.nowPage-1%>">上一頁</a></span>
				    <span id="PageDown" style="display:<%#page.nowPage<page.totPage?"":"none"%>">| <a href="javascript:void(0)" class="pgD" v1="<%#page.nowPage+1%>">下一頁</a></span>
				    | 每頁筆數:
				    <select id="PerPage" name="PerPage" style="color:#FF0000">
					    <option value="10" <%#page.perPage==10?"selected":""%>>10</option>
					    <option value="20" <%#page.perPage==20?"selected":""%>>20</option>
					    <option value="30" <%#page.perPage==30?"selected":""%>>30</option>
					    <option value="50" <%#page.perPage==50?"selected":""%>>50</option>
				    </select>
                    <input type="hidden" name="SetOrder" id="SetOrder" value="<%#ReqVal.TryGet("SetOrder", "")%>" />
			    </font>
		    </td>
	    </tr>
    </TABLE>
    </div>
</form>

<div align="center" id="noData" style="display:<%#page.totRow==0?"":"none"%>">
	<font color="red">=== 目前無資料 ===</font>
</div>

<asp:Repeater id="dataRepeater" runat="server">
<HeaderTemplate>
    <table style="display:<%#page.totRow==0?"none":""%>" border="0" class="bluetable" cellspacing="1" cellpadding="2" width="98%" align="center" id="dataList">
	    <thead>
            <Tr>
	            <td class="lightbluetable" align='center' nowrap rowspan="2"><u class="setOdr" v1="bseq,bseq1">區所編號</u></td>
	            <td class="lightbluetable" align='center' nowrap rowspan="2">國外所案號</td> 
	            <td class="lightbluetable" align='center' nowrap rowspan="2">對方號</td> 
	            <td class="lightbluetable" align='center' nowrap rowspan="2">申請人</td> 
	            <td class="lightbluetable" align='center' nowrap rowspan="2">註冊號</td> 
	            <td class="lightbluetable" align='center' nowrap rowspan="2">案件名稱</td> 
	            <td class="lightbluetable" align='center' nowrap rowspan="2">交辦案性</td> 
	            <td class="lightbluetable" align='center' nowrap><u class="setOdr" v1="Confirm_date">收文日</u></td>
	            <td class="lightbluetable" align='center' nowrap><u class="setOdr" v1="last_date">法定期限</u></td>
	            <td class="lightbluetable" align='center' nowrap>承辦案性</td> 
	            <td class="lightbluetable" align='center' nowrap>承辦人</td> 
	            <td class="lightbluetable" align='center' nowrap rowspan="2">承辦狀態</td> 
            </tr>
            <Tr>
	            <td class="lightbluetable" align='center' nowrap><u class="setOdr" v1="Bpr_date">完成日期</u></td>
	            <td class="lightbluetable" align='center' nowrap><u class="setOdr" v1="ap_date">判行日期</u></td>
	            <td class="lightbluetable" align='center' nowrap><u class="setOdr" v1="brtran_date">完稿確認日</u></td>
 	            <td class="lightbluetable" align='center' nowrap>核准(承辦)時數</td> 
           </tr>
	    </thead>
	    <tbody>
</HeaderTemplate>
			<ItemTemplate>
 		        <tr class="<%#(Container.ItemIndex+1)%2== 1 ?"sfont9":"lightbluetable3"%>">
		            <td rowspan="2" align="center"><%#Eval("link")%>
                        <%#Eval("fseq")%></a>
		            </td>
		            <td rowspan="2"><%#Eval("link")%><%#Eval("fext_seq")%></a></td>
		            <td rowspan="2"><%#Eval("link")%><%#Eval("your_no")%></a></td>
		            <td rowspan="2"><%#Eval("link")%><%#Eval("optap_cname")%></a></td>
		            <td rowspan="2" title="申請號：<%#Eval("apply_no")%>"><%#Eval("link")%><%#Eval("issue_no")%></a></td>
		            <td rowspan="2" title="<%#Eval("appl_name")%>"><%#Eval("link")%><%#Eval("oappl_name")%></a></td>
		            <td rowSpan="2" align="center" nowrap><%#Eval("link")%><%#Eval("arcase_name")%></a></td>
		            <td align="center"><%#Eval("link")%><%#Eval("confirm_date", "{0:d}")%></a></td>
		            <td align="center"><%#Eval("link")%><%#Eval("last_date", "{0:d}")%></a></td>
		            <td align="center"><%#Eval("link")%><%#Eval("pr_rs_code_name")%></a></td>
		            <td align="center"><%#Eval("link")%><%#Eval("pr_scode_name")%></a></td>
		            <td rowspan="2" align="center" rowSpan=2><%#Eval("link")%><%#Eval("code_name")%></a></td>
				</tr>
 		        <tr class="<%#(Container.ItemIndex+1)%2== 1 ?"sfont9":"lightbluetable3"%>">
		            <td align="center"><%#Eval("link")%><%#Eval("oBpr_date")%></a></td>
		            <td align="center"><%#Eval("link")%><%#Eval("ap_date", "{0:d}")%></a></td>
		            <td align="center"><%#Eval("link")%><%#Eval("brtran_date", "{0:d}")%></a></td>
		            <td align="center"><%#Eval("link")%><%#Eval("pry_hour", "{0:n1}")%>(<%#Eval("pr_hour", "{0:n1}")%>)</a></td>
	            </Tr>
			</ItemTemplate>
<FooterTemplate>
	    </tbody>
    </table>
    <br />
</FooterTemplate>
</asp:Repeater>
</body>
</html>

<script language="javascript" type="text/javascript">
    $(function () {
        if (!(window.parent.tt === undefined)) {
            if ($("#homelist") == "homelist") {
                window.parent.tt.rows = "0%,100%";
            } else {
                if ($("#submitTask").val() == "Q") {
                    window.parent.tt.rows = "30%,70%";
                } else {
                    window.parent.tt.rows = "100%,0%";
                }
            }
        }
        theadOdr();//設定表頭排序圖示
    });

    //執行查詢
    function goSearch() {
        reg.submit();
    };
    //每頁幾筆
    $("#PerPage").change(function (e) {
        goSearch();
    });
    //指定第幾頁
    $("#divPaging").on("change", "#GoPage", function (e) {
        goSearch();
    });
    //上下頁
    $(".pgU,.pgD").click(function (e) {
        $("#GoPage").val($(this).attr("v1"));
        goSearch();
    });
    //排序
    $(".setOdr").click(function (e) {
        //$("#dataList>thead tr .setOdr span").remove();
        //$(this).append("<span class='odby'>▲</span>");
        $("#SetOrder").val($(this).attr("v1"));
        goSearch();
    });
    //設定表頭排序圖示
    function theadOdr() {
        $(".setOdr").each(function (i) {
            $(this).remove("span.odby");
            if ($(this).attr("v1").toLowerCase() == $("#SetOrder").val().toLowerCase()) {
                $(this).append("<span class='odby'>▲</span>");
            }
        });
    }

    //關閉視窗
    $(".imgCls").click(function (e) {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "100%,0%";
        } else {
            window.close();
        }
    })
</script>
