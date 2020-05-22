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

        if (Request.RequestType == "GET") {
            ReqVal = Request.QueryString.ToDictionary();
        } else {
            ReqVal = Request.Form.ToDictionary();
        }

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
        StrFormBtnTop += "<br><a href=\"window.print()\" target=\"myWindowOne\">列印</a>日期："+DateTime.Today.ToShortDateString();

        //根據查詢條件組查詢條件字串(hrefq)
        hrefq += "&qryYear=" + Request["qryYear"];
        hrefq += "&qrysMonth=" + Request["qrysMonth"];
        hrefq += "&qryeMonth=" + Request["qryeMonth"];
        hrefq += "&prgid=" + Request["prgid"];
        hrefq += "&qrykindDate=" + Request["qrykindDate"];
        hrefq += "&qrySTAT_CODE=" + Request["qrySTAT_CODE"];
        hrefq += "&qryPR_branch=" + Request["qryPR_branch"];
        hrefq += "&qrybr_source=" + Request["qrybr_source"];
        hrefq += "&qryend_flag=" + Request["qryend_flag"];

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

        string qryKINDDATE_name = "";
        if ((Request["qryKINDDATE"] ?? "") == "BCase_date") {
            qryKINDDATE_name = "交辦期間";
        } else if ((Request["qryKINDDATE"] ?? "") == "BPR_DATE") {
            qryKINDDATE_name = "承辦完成期間";
        }
        string qryAP_DATE_name = "";
        ReqVal["qrySdate"] = Request["qryYear"] + "/" + Request["qrysMonth"].Trim() + "/1"; //上個月一號
        ReqVal["qryEdate"] = new DateTime(Convert.ToInt32(Request["qryYear"].ToString()), Convert.ToInt32(Request["qryeMonth"].Trim()), 1).AddMonths(1).AddDays(-1).ToShortDateString();
        qryAP_DATE_name = "&nbsp;<font color=blue>◎" + qryKINDDATE_name + "：</font>" + ReqVal["qrySdate"] + "~" + ReqVal["qryEdate"];
        if ((Request["qryend_flag"] ?? "") != "Y") {
            qryAP_DATE_name += "&nbsp;<font color=blue>(含離職人員)";
        }

        titleLabel = "<font color=red>" + qrybr_source_name + qryinclude_name + qrybranch_name + qryAP_DATE_name + "</font>";
    }

    private void QueryData() {
        //using (DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST")) {
            string SQL = "";
            string wSQL = "";
            //x軸
            if ((Request["qryend_flag"] ?? "") == "Y") {//不含離職人員
                wSQL += " and (c.end_date is null or c.end_date>='" + ReqVal["qrySdate"] + "') ";
            }
            if ((Request["qrypr_branch"] ?? "") != "") {//承辦區所
                wSQL += " and a.grpclass='" + Request["qrypr_branch"] + "' ";
            }
            if ((Request["qryPR_SCODE"] ?? "") != "") {//承辦人
                wSQL += " and c.scode='" + Request["qryPR_SCODE"] + "' ";
            }
            SQL = "select c.scode x_scode,c.sc_name x_scodenm,c.sscode ";
            SQL += " from sysctrl.dbo.grpid as a ";
            SQL += " inner join sysctrl.dbo.scode_group as b on a.grpclass=b.grpclass and a.grpid=b.grpid";
            SQL += " inner join sysctrl.dbo.scode as c on b.scode=c.scode " + wSQL;
            SQL+= " where a.grpclass='B' and a.grpid='T100'";
            SQL+= " union ";
            SQL += " select c.scode,c.sc_name,c.sscode ";
            SQL += " from sysctrl.dbo.scode_group as a ";
            SQL += " inner join sysctrl.dbo.scode as c on a.scode=c.scode " + wSQL;
            SQL+= " where a.grpclass='BJ' and a.grpid='T100'";
            SQL += " order by c.sscode ";
            conn.DataTable(SQL, dtx);
            //如果沒有指定承辦人則顯示合計
            if ((Request["qryPR_SCODE"] ?? "") == "") {
                DataRow sumRow = dtx.NewRow();
                sumRow[0] = "";
                sumRow[1] = "總計";
                dtx.Rows.Add(sumRow);
            }

            //y軸(只有by案性要小計)
            SQL = "select 0 sub_Rank,''sub_value,''sub_text,m.cust_code y_value,m.code_name y_text ";
            SQL += "from cust_code m ";
            SQL += "where m.code_type='Omonth' and m.cust_code>=" + Request["qrysMonth"] + " and m.cust_code<=" + Request["qryeMonth"] + " ";
            SQL += " order by m.sortfld ";
            conn.DataTable(SQL, dty);

            //符合條件的所有明細
            SQL = "select month(a." + Request["qrykinddate"] + ")m_ap_date,* from vbr_opte as a ";
            SQL += "where a.Bmark not in ('B','D') and  (a.bstat_code like 'YY%' or a.bstat_code like 'YZ%') ";
            SQL += " and year(a." + Request["qrykinddate"] + ")='" + Request["qryYear"] + "' ";
            SQL += " and month(a." + Request["qrykinddate"] + ")>=" + Request["qrysMonth"] + " ";
            SQL += " and month(a." + Request["qrykinddate"] + ")<=" + Request["qryeMonth"] + " ";
             if ((Request["qryBranch"] ?? "") != "") {//區所
                SQL += " and a.branch='" + Request["qryBranch"] + "' ";
            }
           if ((Request["qrypr_branch"] ?? "") != "") {
                SQL += " and a.pr_branch='" + Request["qrypr_branch"] + "'";
            }
            if ((Request["qryPr_scode"] ?? "") != "") {
                SQL += " and a.Pr_scode='" + Request["qryPr_scode"] + "'";
            }
            if ((Request["qrybr_source"] ?? "") != "") {
                SQL += " and a.br_source='" + Request["qrybr_source"] + "' ";
            }
            conn.DataTable(SQL, dt);

            xRepeater1.DataSource = dtx;
            xRepeater1.DataBind();
            xRepeater2.DataSource = dtx;
            xRepeater2.DataBind();

            yRepeater.DataSource = dty;
            yRepeater.DataBind();
        //}
    }

    protected void yRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e) {
        if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem)) {// For items
            Repeater xRepeater3 = (Repeater)e.Item.FindControl("xRepeater3");
            xRepeater3.DataSource = dtx;
            xRepeater3.DataBind();
        } else if (e.Item.ItemType == ListItemType.Footer) {// For Footer
            Repeater xRepeater4 = (Repeater)e.Item.FindControl("xRepeater4");
            xRepeater4.DataSource = dtx;
            xRepeater4.DataBind();
        }
    }

    //案件數
    protected string GetCount(RepeaterItem Container, bool isSubLine, bool showlink) {
        string rtn = "";
        string x_scode = DataBinder.Eval(Container.DataItem, "x_scode").ToString();
        string y_value = (DataBinder.Eval(((RepeaterItem)Container.Parent.Parent).DataItem, "y_value") ?? "").ToString();
        string sub_value = (DataBinder.Eval(((RepeaterItem)Container.Parent.Parent).DataItem, "sub_value") ?? "").ToString();
        string arug = "";

        string where = " 1=1 ";
            if (sub_value != "") where += " and ''='" + sub_value + "'";
            if (y_value != "" &&!isSubLine) where += " and m_ap_date='" + y_value + "'";
            if (x_scode != "") where += " and bpr_scode='" + x_scode + "'";
            arug = "&month=" + y_value;

        rtn = dt.Compute("count(bpr_scode)", where).ToString();
        rtn = rtn == "" ? "0" : Convert.ToInt32(rtn).ToString("N0");

        if (showlink && rtn != "0")
            rtn = String.Format("<a href='opte62_List.aspx?1=1{0}&submitTask=Q&back_flag=Y&qryPR_SCODE={1}{2}' target='Eblank'>{3}</a>"
                , hrefq, x_scode, arug, rtn);

        return rtn;
    }

    //時數
    protected string GetHour(RepeaterItem Container, bool isSubLine, bool showlink) {
        string rtn = "";
        string x_scode = DataBinder.Eval(Container.DataItem, "x_scode").ToString();
        string y_value = (DataBinder.Eval(((RepeaterItem)Container.Parent.Parent).DataItem, "y_value") ?? "").ToString();
        string sub_value = (DataBinder.Eval(((RepeaterItem)Container.Parent.Parent).DataItem, "sub_value") ?? "").ToString();
        string arug = "";

        string where = " 1=1 ";
        if (sub_value != "") where += " and ''='" + sub_value + "'";
        if (y_value != "" && !isSubLine) where += " and m_ap_date='" + y_value + "'";
        if (x_scode != "") where += " and bpr_scode='" + x_scode + "'";
        arug = "&month=" + y_value;

        decimal pr_hour = Convert.ToDecimal("0"+dt.Compute("sum(pr_hour)", where));
        decimal pry_hour = Convert.ToDecimal("0"+dt.Compute("sum(pry_hour)", where));
        if (pr_hour + pry_hour == 0)
            rtn = "0";
        else
            rtn = pry_hour.ToString("N1") + "(" + pr_hour.ToString("N1") + ")";
        
        if (showlink && rtn != "0")
            rtn = String.Format("<a href='opte62_List.aspx?1=1{0}&submitTask=Q&back_flag=Y&qryPR_SCODE={1}{2}' target='Eblank'>{3}</a>"
                , hrefq, x_scode, arug, rtn);

        return rtn;
    }

    protected string GetXY(RepeaterItem Container) {
        string x_scode = DataBinder.Eval(Container.DataItem, "x_scode").ToString();
        string y_value = (DataBinder.Eval(((RepeaterItem)Container.Parent.Parent).DataItem, "y_value") ?? "").ToString();
        string sub_value = (DataBinder.Eval(((RepeaterItem)Container.Parent.Parent).DataItem, "sub_value") ?? "").ToString();
        string sub_Rank = (DataBinder.Eval(((RepeaterItem)Container.Parent.Parent).DataItem, "sub_Rank") ?? "").ToString();

        return sub_Rank + "_" + sub_value + "(" + x_scode + "," + y_value + ")";
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
<br />
<table width="<%#30+dtx.Rows.Count*10%>%" cellspacing="1" cellpadding="2" class="bluetable" align="center">
    <tr align="left">
        <td align="center" class="lightbluetable" rowspan=2>月份</td>
        <asp:Repeater id="xRepeater1" runat="server">
        <ItemTemplate>
            <td align="center" class="lightbluetable" colspan=2><%#Eval("x_scodenm")%></td>
        </ItemTemplate>
        </asp:Repeater>
    </tr>
    <tr>
        <asp:Repeater id="xRepeater2" runat="server">
        <ItemTemplate>
            <td align="center" class="lightbluetable" nowrap>核准(承辦)時數</td>
            <td align="center" class="lightbluetable" nowrap>件數</td>
        </ItemTemplate>
        </asp:Repeater>
    </tr>

    <asp:Repeater id="yRepeater" runat="server" OnItemDataBound="yRepeater_ItemDataBound">
    <ItemTemplate>
 		<tr class="<%#(Container.ItemIndex+1)%2== 1 ?"sfont9":"lightbluetable3"%>">
            <td align="center"><%#Eval("y_text")%></td>
            <asp:Repeater id="xRepeater3" runat="server">
            <ItemTemplate>
                <td align="center" class="<%#Eval("x_scode")!= "" ?"sfont9":"lightbluetable3"%>" title="<%#GetXY(Container)%>">
                    <%#GetHour(Container,false,true)%>
                </td>
                <td align="center" class="<%#Eval("x_scode")!= "" ?"sfont9":"lightbluetable3"%>" title="<%#GetXY(Container)%>">
                    <%#GetCount(Container,false,true)%>
                </td>
            </ItemTemplate>
            </asp:Repeater>
        </tr>
    </ItemTemplate>
    <FooterTemplate>
        <tr>
            <td align="right" class="lightbluetable">合計</td>
            <asp:Repeater id="xRepeater4" runat="server">
            <ItemTemplate>
                <td align="center" class="lightbluetable" title="<%#GetXY(Container)%>"><%#GetHour(Container,false,true)%></td>
                <td align="center" class="lightbluetable" title="<%#GetXY(Container)%>"><%#GetCount(Container,false,true)%></td>
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
