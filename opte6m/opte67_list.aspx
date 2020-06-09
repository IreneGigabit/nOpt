<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "Newtonsoft.Json"%>
<%@ Import Namespace = "Newtonsoft.Json.Linq"%>

<script runat="server">
    protected string HTProgCap = "出口爭救到期案件查詢-清單";// HttpContext.Current.Request["prgname"];//功能名稱
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

        ReqVal = Util.GetRequestParam(Context,Request["chkTest"] == "TEST");
        foreach (KeyValuePair<string, string> p in ReqVal) {
            if (String.Compare(p.Key, "GoPage", true) != 0
                && String.Compare(p.Key, "PerPage", true) != 0
                && String.Compare(p.Key, "SetOrder", true) != 0)
                hiddenText += string.Format("<input type=\"hidden\" id=\"{0}\" name=\"{0}\" value=\"{1}\">\n", p.Key, p.Value);
        }

        submitTask = Request["submitTask"] ?? "";

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            QueryData();
            ListPageLayout();

            this.DataBind();
        }
    }

    private void ListPageLayout() {
        if ((Request["homelist"] ?? "") == "homelist") {
            StrFormBtnTop += "<a href=\"" + HTProgPrefix + ".aspx?prgid=" + prgid + "\"  target=\"Etop\">[查詢]</a>";
        } else {
            if ((Request["homelist"] ?? "") == "homelist") {
                StrFormBtnTop += "<a class=\"imgCls\" href=\"javascript:void(0);\" >[關閉視窗]</a>";
            } else {
                StrFormBtnTop += "<a href=\"" + HTProgPrefix + ".aspx?prgid=" + prgid + "\" >[查詢]</a>";
            }
        }

        //顯示查詢條件
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

        string qryKINDDATE_name = "";
        if (ReqVal.TryGet("qryKINDDATE", "") == "confirm_date") {
            qryKINDDATE_name = "&nbsp;<font color=blue>◎日期種類：</font>收文日期";
        } else if (ReqVal.TryGet("qryKINDDATE", "") == "ctrl_date") {
            qryKINDDATE_name = "&nbsp;<font color=blue>◎日期種類：</font>承辦期限";
        } else if (ReqVal.TryGet("qryKINDDATE", "") == "last_date") {
            qryKINDDATE_name = "&nbsp;<font color=blue>◎日期種類：</font>法定期限";
        }

        string qryDay_name = "";
        if (ReqVal.TryGet("qryDay", "") != "") {
            qryDay_name = "&nbsp;<font color=blue>◎抓取天數：</font>前" + Request["qryDay"] + "天";
        }

        string qryOrder_name = "";
        if (ReqVal.TryGet("qryOrder", "") == "confirm_date") {
            qryOrder_name = "<BR>&nbsp;<font color=blue>◎排序方式：</font>收文日期";
        } else if (ReqVal.TryGet("qryOrder", "") == "ctrl_date") {
            qryOrder_name = "<BR>&nbsp;<font color=blue>◎排序方式：</font>承辦期限";
        } else if (ReqVal.TryGet("qryOrder", "") == "last_date") {
            qryOrder_name = "<BR>&nbsp;<font color=blue>◎排序方式：</font>法定期限";
        }

        titleLabel = "<font color=red>" + qrybranch_name + qrybranch_name + qryKINDDATE_name + qryDay_name + qryOrder_name + "</font>";
    }

    private void QueryData() {
        //using (DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST")) {
            SQL = "SELECT Bseq,Bseq1,country,apply_no,issue_no,appl_name,Confirm_date,your_no,ext_seq,ext_seq1";
            SQL += ",last_date,arcase_name,isnull(Bpr_date,'') as Bpr_date";
            SQL += ",a.pr_scode_name,b.code_name,ctrl_date";
            SQL += ",branch,opt_sqlno,opt_no,case_no ";
            SQL += ",''fseq,''fext_seq,''optap_cname,''oappl_name,''oBpr_date,''link";
            SQL += " FROM vbr_opte A ";
            SQL += " Left outer join cust_code as b on B.code_type='Oestatcode' and b.cust_code=a.bstat_code";
            SQL += " where Bmark='N' and confirm_date is not null and Bstat_code <>'YZ'";

            if ((Request["qryBranch"] ?? "") != "") {
                SQL += " and branch='" + Request["qryBranch"] + "'";
            }
            if ((Request["qryDay"] ?? "") != "") {
                SQL += " and " + Request["qrykinddate"] + "<='" + DateTime.Today.AddDays(Convert.ToInt32(ReqVal.TryGet("qryDay", "0"))).ToShortDateString() + "'";
            }
            //2014/6/23增加交辦(分案)來源
            if ((Request["qrybr_source"] ?? "") != "") {
                SQL += " and a.br_source='" + Request["qrybr_source"] + "'";
            }

            ReqVal["qryOrder"] = ReqVal.TryGet("SetOrder", ReqVal.TryGet("qryOrder", ""));
            if (ReqVal.TryGet("qryOrder", "") != "") {
                SQL += " order by " + ReqVal.TryGet("qryOrder", "");
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
                page.pagedTable.Rows[i]["oBpr_date"] = Util.parseDBDate(page.pagedTable.Rows[i].SafeRead("Bpr_date", ""), "yyyy/M/d");
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
                    <input type="hidden" name="SetOrder" id="SetOrder" value="<%#ReqVal.TryGet("qryOrder", "")%>" />
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
	            <td class="lightbluetable" nowrap align="center">區所編號</td>
	            <td class="lightbluetable" nowrap align="center">對方號</td> 
	            <td class="lightbluetable" nowrap align="center">申請人</td> 
	            <td class="lightbluetable" nowrap align="center">註冊號</td> 
	            <td class="lightbluetable" nowrap align="center">案件名稱</td> 
	            <td class="lightbluetable" nowrap align="center"><u class="setOdr" v1="confirm_date">收文日期</u></td>
	            <td class="lightbluetable" nowrap align="center"><u class="setOdr" v1="ctrl_date">承辦期限</u></td>
	            <td class="lightbluetable" nowrap align="center"><u class="setOdr" v1="last_date">法定期限</u></td>
	            <td class="lightbluetable" nowrap align="center">承辦人</td> 
	            <td class="lightbluetable" nowrap align="center">承辦狀態</td> 
            </tr>
	    </thead>
	    <tbody>
</HeaderTemplate>
			<ItemTemplate>
 		        <tr class="<%#(Container.ItemIndex+1)%2== 1 ?"sfont9":"lightbluetable3"%>">
		            <td align="center" title="國外所案號：<%#Eval("fext_seq")%>"><%#Eval("link")%><%#Eval("fseq")%></a></td>
		            <td align="center"><%#Eval("link")%><%#Eval("your_no")%></a></td>
		            <td ><%#Eval("link")%><%#Eval("optap_cname")%></a></td>
		            <td align="center" title="申請號：<%#Eval("apply_no")%>"><%#Eval("link")%><%#Eval("issue_no")%></a></td>
		            <td title="<%#Eval("appl_name")%>"><%#Eval("link")%><%#Eval("oappl_name")%></a></td>
		            <td align="center"><%#Eval("link")%><%#Eval("confirm_date", "{0:d}")%></a></td>
		            <td align="center"><%#Eval("link")%><%#Eval("ctrl_date", "{0:d}")%></a></td>
		            <td align="center"><%#Eval("link")%><%#Eval("last_date", "{0:d}")%></a></td>
		            <td align="center"><%#Eval("link")%><%#Eval("pr_scode_name")%></a></td>
		            <td align="center"><%#Eval("link")%><%#Eval("code_name")%></a></td>
				</tr>
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
            window.parent.tt.rows = "100%,0%";
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
