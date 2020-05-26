<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Linq" %>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "Newtonsoft.Json"%>
<%@ Import Namespace = "Newtonsoft.Json.Linq"%>

<script runat="server">
    protected string HTProgCap = "爭救案交辦品質評分表-統計表";// HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string SQL = "";

    protected Dictionary<string, string> ReqVal = new Dictionary<string, string>();
    protected string StrFormBtnTop = "";
    protected string titleLabel = "";

    protected string submitTask = "";

    protected DataTable dtx = new DataTable();
    protected DataTable dty = new DataTable();
    protected DataTable dt = new DataTable();
    protected string hrefq = "";

    DBHelper conn = null;//開完要在Page_Unload釋放,否則sql server連線會一直佔用
    private void Page_Unload(System.Object sender, System.EventArgs e) {
        if (conn != null) conn.Dispose();
    }

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST");

        ReqVal = Util.GetRequestParam(Context);
        submitTask = Request["submitTask"] ?? "";

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
        StrFormBtnTop += "<a href=\"" + HTProgPrefix + ".aspx?prgid=" + prgid + "\" >[查詢]</a>";

        //根據查詢條件組查詢條件字串(hrefq)
        hrefq += "&qryinclude=" + Request["qryinclude"];
        hrefq += "&qryYear=" + Request["qryYear"];
        hrefq += "&qrysMonth=" + Request["qrysMonth"];
        hrefq += "&qryeMonth=" + Request["qryeMonth"];
        hrefq += "&qrybr_source=" + Request["qrybr_source"];
        hrefq += "&prgid=" + Request["prgid"];
        hrefq += "&qryKINDDATE=" + Request["qryKINDDATE"];
        hrefq += "&qrySTAT_CODE=" + Request["qrySTAT_CODE"];

        //顯示查詢條件
        string qrybr_source_name = "";
        if ((Request["qrybr_source"] ?? "") == "br") {
            qrybr_source_name = "&nbsp;<font color=blue>◎交辦來源：</font>區所交辦";
        } else if ((Request["qrybr_source"] ?? "") == "opt") {
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

        string qryKINDDATE_name = "";
        if ((Request["qryKINDDATE"] ?? "") == "BCase_date") {
            qryKINDDATE_name = "交辦期間";
        } else if ((Request["qryKINDDATE"] ?? "") == "BPR_DATE") {
            qryKINDDATE_name = "承辦完成期間";
        } else if ((Request["qryKINDDATE"] ?? "") == "GS_DATE") {
            qryKINDDATE_name = "預計發文期間";
        }
        string qryAP_DATE_name = "";
        ReqVal["qrySdate"] = Request["qryYear"] + "/" + Request["qrysMonth"].Trim() + "/1"; //上個月一號
        ReqVal["qryEdate"] = new DateTime(Convert.ToInt32(Request["qryYear"].ToString()), Convert.ToInt32(Request["qryeMonth"].Trim()), 1).AddMonths(1).AddDays(-1).ToShortDateString();
        qryAP_DATE_name = "&nbsp;<font color=blue>◎" + qryKINDDATE_name + "：</font>" + ReqVal["qrySdate"] + "~" + ReqVal["qryEdate"];

        titleLabel = "<font color=red>" + qrybr_source_name + qryinclude_name + qrybranch_name + qryAP_DATE_name + "</font>";
    }

    private void QueryData() {
        //using (DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST")) {
            string SQL = "";
            //x軸
            SQL = "select c.scode x_scode,c.sc_name x_scodenm";
            SQL += " from sysctrl.dbo.grpid as a ";
            SQL += " inner join sysctrl.dbo.scode_group as b on a.grpclass=b.grpclass and a.grpid=b.grpid";
            SQL += " inner join sysctrl.dbo.scode as c on b.scode=c.scode ";
            SQL += " where a.grpclass='B' and a.grpid='T100'";
            if ((Request["qryPR_SCODE"] ?? "") != "") {//承辦人
                SQL += " and c.scode='" + Request["qryPR_SCODE"] + "' ";
            }
            conn.DataTable(SQL, dtx);
            //如果沒有指定承辦人則顯示合計
            if ((Request["qryPR_SCODE"] ?? "") == "") {
                DataRow sumRow = dtx.NewRow();
                sumRow[0] = "";
                sumRow[1] = "合計";
                dtx.Rows.Add(sumRow);
            }

            //y軸
            SQL = "select m.cust_code y_month,m.code_name y_monthnm ";
            SQL += "from cust_code m ";
            SQL += "where m.code_type='Omonth' and m.cust_code>=" + Request["qrysMonth"] + " and m.cust_code<=" + Request["qryeMonth"] + " ";
            SQL += " order by m.sortfld ";
            conn.DataTable(SQL, dty);
            DataRow totRow = dty.NewRow();

            //符合條件的明細
            SQL = "select month(a." + Request["qrykinddate"] + ")m_ap_date,* from vbr_opt as a ";
            SQL += "where a.mark<>'B' ";
            SQL += " and (a.bstat_code like 'NY%'  or a.bstat_code like 'YY%' or a.bstat_code like 'YS%') ";
            if ((Request["qrybr_source"] ?? "") != "") {
                SQL += " and a.br_source='" + Request["qrybr_source"] + "' ";
            }
            if ((Request["qryinclude"] ?? "") == "Y") {
                SQL += " and a.ref_code is not null";
            } else if ((Request["qryinclude"] ?? "") == "N") {
                SQL += " and a.ref_code is  null";
            }
            if ((Request["qryBranch"] ?? "") != "") {//區所
                SQL += " and a.branch='" + Request["qryBranch"] + "' ";
            }
            SQL += " and year(a." + Request["qrykinddate"] + ")='" + Request["qryYear"] + "' ";
            SQL += " and month(a." + Request["qrykinddate"] + ")>=" + Request["qrysMonth"] + " ";
            SQL += " and month(a." + Request["qrykinddate"] + ")<=" + Request["qryeMonth"] + " ";
            conn.DataTable(SQL, dt);

            xRepeater1.DataSource = dtx;
            xRepeater1.DataBind();

            monthRepeater.DataSource = dty;
            monthRepeater.DataBind();
        //}
    }

    protected void monthRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e) {
        if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem)) {// For items
            Repeater xRepeater3 = (Repeater)e.Item.FindControl("xRepeater3");
            xRepeater3.DataSource = dtx;
            xRepeater3.DataBind();
        } else if (e.Item.ItemType == ListItemType.Footer) {// For Footer
            Repeater xRepeater4 = (Repeater)e.Item.FindControl("xRepeater4");
            xRepeater4.DataSource = dtx;
            xRepeater4.DataBind();
            Repeater xRepeater5 = (Repeater)e.Item.FindControl("xRepeater5");
            xRepeater5.DataSource = dtx;
            xRepeater5.DataBind();
        }
    }

    //案件數
    protected string GetCount(RepeaterItem Container, bool showlink) {
        string rtn = "";

        string y_month = (DataBinder.Eval(((RepeaterItem)Container.Parent.Parent).DataItem, "y_month") ?? "").ToString();
        string x_scode = DataBinder.Eval(Container.DataItem, "x_scode").ToString();
        string where = " 1=1";
        if (x_scode != "") where += " and pr_scode='" + x_scode + "'";
        if (y_month != "") where += " and m_ap_date='" + y_month + "'";

        rtn = dt.Compute("count(pr_scode)", where).ToString();
        rtn = rtn == "" ? "0" : Convert.ToInt32(rtn).ToString("N0");

        if (showlink && rtn != "0")
            rtn = "<a href='opt62_List.aspx?1=1" + hrefq + "&submitTask=Q&qrypr_scode=" + x_scode + "&month=" + y_month + "' target='Eblank'>" + rtn + "</a>";
        return rtn;
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
        <td class="text9" nowrap="nowrap">&nbsp;【<%=prgid%> <%=HTProgCap%>】</td>
        <td class="FormLink" valign="top" align="right" nowrap="nowrap">
            <%#StrFormBtnTop%>
        </td>
    </tr>
    <tr>
        <td colspan="2"><hr class="style-one"/></td>
    </tr>
    <tr>
        <td colspan="2"><%#titleLabel%></td>
    </tr>
</table>
<br />
<table width="<%#10+dtx.Rows.Count*10%>%" cellspacing="1" cellpadding="2" class="bluetable" align="center">
    <tr align="left">
        <td align="center" class="lightbluetable">月份</td>
        <asp:Repeater id="xRepeater1" runat="server">
        <ItemTemplate>
            <td align="center" class="lightbluetable"><%#Eval("x_scodenm")%></td>
        </ItemTemplate>
        </asp:Repeater>
    </tr>
    <asp:Repeater id="monthRepeater" runat="server" OnItemDataBound="monthRepeater_ItemDataBound">
    <ItemTemplate>
        <tr>
            <td align="center" class="lightbluetable3"><%#Eval("y_monthnm")%></td>
            <asp:Repeater id="xRepeater3" runat="server">
            <ItemTemplate>
                <td align="center" class="<%#Eval("x_scode")!= "" ?"sfont9":"lightbluetable3"%>">
                    <%#GetCount(Container,true)%>
                </td>
            </ItemTemplate>
            </asp:Repeater>
        </tr>
    </ItemTemplate>
    <FooterTemplate>
        <tr>
            <td align="center" class="lightbluetable">總計</td>
            <asp:Repeater id="xRepeater4" runat="server">
            <ItemTemplate>
                <td align="center" class="lightbluetable"><%#GetCount(Container,true)%></td>
            </ItemTemplate>
            </asp:Repeater>
        </tr>
        <tr>
            <td align="center" class="lightbluetable">平均件數</td>
            <asp:Repeater id="xRepeater5" runat="server">
            <ItemTemplate>
                <td align="center" class="lightbluetable">
                    <%#(Convert.ToDecimal(GetCount(Container,false))/dty.Rows.Count).ToString("#0.##")%>
                </td>
            </ItemTemplate>
            </asp:Repeater>
        </tr>
    </FooterTemplate>
    </asp:Repeater>
</table>
</body>
</html>

<script language="javascript" type="text/javascript">
    $(function () {
        if (!(window.parent.tt === undefined)) {
            if ($("#submittask").val() == "Q") {
                window.parent.tt.rows = "30%,70%";
            } else {
                window.parent.tt.rows = "100%,0%";
            }
        }
    });

    //關閉視窗
    $(".imgCls").click(function (e) {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "100%,0%";
        } else {
            window.close();
        }
    })
</script>
