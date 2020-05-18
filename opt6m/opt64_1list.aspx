<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Linq" %>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "Newtonsoft.Json"%>
<%@ Import Namespace = "Newtonsoft.Json.Linq"%>

<script runat="server">
    protected string HTProgCap = "爭救案性統計表-統計表";// HttpContext.Current.Request["prgname"];//功能名稱
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

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

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

        //根據查詢條件組查詢條件字串(hrefq)
        hrefq += "&qryKind=" + Request["qryKind"];
        hrefq += "&qryinclude=" + Request["qryinclude"];
        hrefq += "&qrystatus=" + Request["qrystatus"];
        hrefq += "&qrykindDate=" + Request["qrykindDate"];
        hrefq += "&qrypr_scode=" + Request["qrypr_scode"];
        hrefq += "&qrysdate=" + Request["qrysdate"];
        hrefq += "&qryedate=" + Request["qryedate"];
        hrefq += "&qryYear=" + Request["qryYear"];
        hrefq += "&qrysMonth=" + Request["qrysMonth"];
        hrefq += "&qryeMonth=" + Request["qryeMonth"];
        hrefq += "&qryClass=" + Request[" qryClass"];
        hrefq += "&qryPClass=" + Request["qryPClass"];
        hrefq += "&qrybr_source=" + Request["qrybr_source"];
        hrefq += "&prgid=" + Request["prgid"];
    }

    private void QueryData() {
        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST")) {
            string SQL = "";
            //x軸
            SQL = "select b.cust_code x_branch,b.code_name x_branchnm ";
            SQL += "from cust_code b ";
            SQL += "where b.code_type='OBranch' and cust_code in ('N','C','S','K') ";
            if ((Request["qryBranch"] ?? "") != "") {//區所
                SQL += " and b.cust_code='" + Request["qryBranch"] + "' ";
            }
            SQL += " order by b.sortfld ";
            conn.DataTable(SQL, dtx);
            //如果沒有指定區所則顯示合計
            if ((Request["qryBranch"] ?? "") == "") {
                DataRow sumRow = dtx.NewRow();
                sumRow[0] = "";
                sumRow[1] = "合計";
                dtx.Rows.Add(sumRow);
            }

            //y軸
            if ((Request["qrykind"] ?? "") == "rs_class") {//類別
                SQL = "select cust_code,code_name from cust_code ";
                SQL += "where code_type='OClass' ";
                if ((Request["qryClass"] ?? "") != "") {
                    SQL += "and cust_code in('" + Request["qryClass"].Replace(";", "','") + "')";
                }
                SQL += "order by cust_code ";
            } else if ((Request["qrykind"] ?? "") == "rs_code") {//案性
                 SQL = "select t.form_name,o.code_name,t.cust_code,t.code_name ";
                 SQL += "from cust_code t  ";
                 SQL += "inner join cust_code o on o.code_type='OClass' and t.form_name=o.cust_code ";
                 SQL += "where t.code_type='T92'  ";
                if ((Request["qryClass"] ?? "") != "") {
                    SQL += "and t.form_name in('" + Request["qryClass"].Replace(";", "','") + "')";
                }
                if ((Request["qryinclude"] ?? "") == "Y") {
                    SQL += " and t.ref_code is not null";
                } else if ((Request["qryinclude"] ?? "") == "N") {
                    SQL += " and t.ref_code is  null";
                }
                SQL += "order by t.form_name ";
            } else if ((Request["qrykind"] ?? "") == "month") {//月份
                SQL = "select m.cust_code y_month,m.code_name y_monthnm ";
                SQL += "from cust_code m ";
                SQL += "where m.code_type='Omonth' and m.cust_code>=" + Request["qrysMonth"] + " and m.cust_code<=" + Request["qryeMonth"] + " ";
                SQL += " order by m.sortfld ";
            }
            conn.DataTable(SQL, dty);
            DataRow totRow = dty.NewRow();

            //符合條件的明細
            SQL = "select month(a.ap_date)m_ap_date,* from vopt_641 as a ";
            SQL += "where a.mark<>'B'and score_flag='Y' ";
            SQL += " and year(a.ap_date)='" + Request["qryYear"] + "' ";
            SQL += " and month(a.ap_date)>=" + Request["qrysMonth"] + " ";
            SQL += " and month(a.ap_date)<=" + Request["qryeMonth"] + " ";
            if ((Request["qrykind"] ?? "") == "rs_class") {//類別
                SQL += " and  and a.form_name=c.cust_code and a.Bmark<>'B'  and a.form_name is not null ";
                SQL += " and a." + Request["qrykinddate"] + ">='" + Request["qrySdate"] + "'";
                SQL += " and a." + Request["qrykinddate"] + "<='" + Request["qryEdate"] + "'";
            } else if ((Request["qrykind"] ?? "") == "rs_code") {//案性
                SQL += " and a.arcase=c.cust_code and a.Bmark<>'B'   and a.form_name is not null ";
                SQL += " and a." + Request["qrykinddate"] + ">='" + Request["qrySdate"] + "'";
                SQL += " and a." + Request["qrykinddate"] + "<='" + Request["qryEdate"] + "'";
            } else if ((Request["qrykind"] ?? "") == "month") {//月份
                SQL += " and a.Bmark<>'B'   and a.form_name is not null ";
                SQL += " and year(a." + Request["qrykinddate"] + ")='" + Request["qryYear"] + "' ";
                SQL += " and month(a." + Request["qrykinddate"] + ")>=" + Request["qrysMonth"] + " ";
                SQL += " and month(a." + Request["qrykinddate"] + ")<=" + Request["qryeMonth"] + " ";
            }
            if ((Request["qryinclude"] ?? "") == "Y") {
                SQL += " and a.ref_code is not null";
            } else if ((Request["qryinclude"] ?? "") == "N") {
                SQL += " and a.ref_code is  null";
            }
            if ((Request["qryPr_scode"] ?? "") != "") {
                SQL += " and a.Pr_scode='" + Request["qryPr_scode"] + "'";
            }
            if ((Request["qryStatus"] ?? "") == "NA") {//承辦中(包含未分案)
                SQL += " and ( a.bstat_code like 'N%' or a.Bstat_code like 'R%')";
            } else if ((Request["qryStatus"] ?? "") == "Y") {//判行完成
                SQL += " and ( a.bstat_code like 'Y%')";
            }
            if ((Request["qrybr_source"] ?? "") != "") {
                SQL += " and a.br_source='" + Request["qrybr_source"] + "' ";
            }
            if ((Request["qryBranch"] ?? "") != "") {//區所
                SQL += " and a.branch='" + Request["qryBranch"] + "' ";
            }
            conn.DataTable(SQL, dt);


            branchRepeater1.DataSource = dtx;
            branchRepeater1.DataBind();
            branchRepeater2.DataSource = dtx;
            branchRepeater2.DataBind();

            monthRepeater.DataSource = dty;
            monthRepeater.DataBind();


            //顯示查詢條件
            string qrybr_source_name = "";
            if ((Request["qrybr_source"] ?? "") == "br") {
                qrybr_source_name = "&nbsp;<font color=blue>◎交辦來源：</font>區所交辦";
            } else if ((Request["qrybr_source"] ?? "") == "opt") {
                qrybr_source_name = "&nbsp;<font color=blue>◎交辦來源：</font>新增分案";
            }

            string qrykind_name = "";
            if ((Request["qrykind"] ?? "") == "rs_class") {
                qrykind_name = "&nbsp;<font color=blue>◎統計依據：</font>類別";
            } else if ((Request["qrykind"] ?? "") == "rs_code") {
                qrykind_name = "&nbsp;<font color=blue>◎統計依據：</font>案性";
            } else if ((Request["qrykind"] ?? "") == "month") {
                qrykind_name = "&nbsp;<font color=blue>◎統計依據：</font>月份";
            }

            string qrycode_name = "";
            if ((Request["SubmitTask"] ?? "") == "Q") {
                if ((Request["qryPClass"] ?? "") != "") {
                    SQL = "select code_name from cust_code where code_type='OClass' and cust_code in('" + Request["qryClass"].Replace(";", "','") + "')";
                    string PClassnm = "";
                    using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                        while (dr.Read()) {
                            PClassnm += (PClassnm != "" ? "、" : "") + dr.SafeRead("code_name", "");
                        }
                    }
                    qrycode_name = "&nbsp;<font color=blue>◎統計類別：</font>" + PClassnm;
                }
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

            string qrypr_scode_name = "";
            if ((Request["qrypr_scode"] ?? "") != "") {
                SQL = "select sc_name from sysctrl.dbo.scode where scode='" + Request["qrypr_scode"] + "'";
                object objResult = conn.ExecuteScalar(SQL);
                qrypr_scode_name = (objResult == DBNull.Value || objResult == null) ? "" : objResult.ToString();
                qrypr_scode_name = "&nbsp;<font color=blue>◎承辦人：</font>" + qrypr_scode_name;
            }

            string qrystatus_name = "";
            if ((Request["qrystatus"] ?? "") == "NA") {
                qrystatus_name = "&nbsp;<font color=blue>◎承辦狀態：</font>承辦中(包含未分案)";
            } else if ((Request["qrystatus"] ?? "") == "Y") {
                qrystatus_name = "&nbsp;<font color=blue>◎承辦狀態：</font>判行完成";
            }

            string qryAP_DATE_name = "";
            if ((ReqVal["qrykinddate"] ?? "") != "") {
                if ((Request["qrykinddate"] ?? "") == "Confirm_date") {
                    qryAP_DATE_name = "&nbsp;<font color=blue>◎收文期間：</font>";
                } else if ((Request["qrykinddate"] ?? "") == "ap_date") {
                    qryAP_DATE_name = "&nbsp;<font color=blue>◎判行期間：</font>";
                }
                qryAP_DATE_name += ReqVal["qrySdate"] + "~" + ReqVal["qryEdate"];
            }

            titleLabel = "<font color=red>" + qrybr_source_name + qrykind_name + qrycode_name + qryinclude_name + qrybranch_name +
                qrypr_scode_name + qrystatus_name + qryAP_DATE_name + "</font>";
        }
    }

    protected void monthRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e) {
		if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem)) {// For items
            Repeater branchRepeater3 = (Repeater)e.Item.FindControl("branchRepeater3");
            branchRepeater3.DataSource = dtx;
            branchRepeater3.DataBind();
        } else if (e.Item.ItemType == ListItemType.Footer) {// For Footer
            Repeater branchRepeater4 = (Repeater)e.Item.FindControl("branchRepeater4");
            branchRepeater4.DataSource = dtx;
            branchRepeater4.DataBind();
            Repeater branchRepeater5 = (Repeater)e.Item.FindControl("branchRepeater5");
            branchRepeater5.DataSource = dtx;
            branchRepeater5.DataBind();
        }
    }
    
    //案件數
    protected string GetCount(RepeaterItem Container, bool showlink) {
        string rtn = "";

        string month = (DataBinder.Eval(((RepeaterItem)Container.Parent.Parent).DataItem, "y_month") ?? "").ToString();
        string branch = DataBinder.Eval(Container.DataItem, "x_branch").ToString();
        string where = " 1=1";
        if (month != "") where += " and m_ap_date='" + month + "'";
        if (branch != "") where += " and branch='" + branch + "'";

        rtn = dt.Compute("count(branch)", where).ToString();
        rtn = rtn == "" ? "0" : Convert.ToInt32(rtn).ToString("N0");

        if (showlink && rtn != "0")
            rtn = "<a href='opt63_2List.aspx?1=1" + hrefq + "&submitTask=Q&qryBranch=" + branch + "&month=" + month + "' target='Eblank'>" + rtn + "</a>";
        return rtn;
    }
    
    //得分
    protected string GetScore(RepeaterItem Container, bool showlink) {
        string rtn = "";
        string month = (DataBinder.Eval(((RepeaterItem)Container.Parent.Parent).DataItem, "y_month") ?? "").ToString();
        string branch = DataBinder.Eval(Container.DataItem, "x_branch").ToString();

        string where = " 1=1";
        if (month != "") where += " and m_ap_date='" + month + "'";
        if (branch != "") where += " and branch='" + branch + "'";

        rtn = dt.Compute("Sum(score)", where).ToString();
        rtn = rtn == "" ? "0" : Convert.ToInt32(rtn).ToString("N0");

        if (showlink && rtn != "0")
            rtn = "<a href='opt63_2List.aspx?1=1" + hrefq + "&submitTask=Q&qryBranch=" + branch + "&month=" + month + "' target='Eblank'>" + rtn + "</a>";
        return rtn;
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
<table width="100%" cellspacing="1" cellpadding="2" class="bluetable" align="center">
    <tr align="left">
        <td align="center" class="lightbluetable" rowspan=2>月份</td>
        <asp:Repeater id="branchRepeater1" runat="server">
        <ItemTemplate>
            <td align="center" class="lightbluetable" colspan=2><%#Eval("x_branchnm")%></td>
        </ItemTemplate>
        </asp:Repeater>
    </tr>
    <tr>
        <asp:Repeater id="branchRepeater2" runat="server">
        <ItemTemplate>
            <td align="center" class="lightbluetable" nowrap>案件數</td>
            <td align="center" class="lightbluetable" nowrap>得　分</td>
        </ItemTemplate>
        </asp:Repeater>
    </tr>

    <asp:Repeater id="monthRepeater" runat="server" OnItemDataBound="monthRepeater_ItemDataBound">
    <ItemTemplate>
        <tr>
            <td align="center" class="lightbluetable3"><%#Eval("y_monthnm")%></td>
            <asp:Repeater id="branchRepeater3" runat="server">
            <ItemTemplate>
                <td align="center" class="<%#Eval("x_branch")!= "" ?"sfont9":"lightbluetable3"%>">
                    <%#GetCount(Container,true)%>
                    <!--GetCount(((RepeaterItem)Container.Parent.Parent).DataItem,Eval("x_branch"))-->
                </td>
                <td align="center" class="<%#Eval("x_branch")!= "" ?"sfont9":"lightbluetable3"%>">
                    <%#GetScore(Container,false)%>
                    <!--GetScore(((RepeaterItem)Container.Parent.Parent).DataItem,Eval("x_branch"))-->
                </td>
            </ItemTemplate>
            </asp:Repeater>
        </tr>
    </ItemTemplate>
    <FooterTemplate>
        <tr>
            <td align="center" class="lightbluetable">總計</td>
            <asp:Repeater id="branchRepeater4" runat="server">
            <ItemTemplate>
                <td align="center" class="lightbluetable"><%#GetCount(Container,true)%></td>
                <td align="center" class="lightbluetable"><%#GetScore(Container,false)%></td>
            </ItemTemplate>
            </asp:Repeater>
        </tr>
        <tr>
            <td align="center" class="lightbluetable">平均得分</td>
            <asp:Repeater id="branchRepeater5" runat="server">
            <ItemTemplate>
                <td align="center" class="lightbluetable" colspan="2">
                    
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

    //執行查詢
    function goSearch() {
        reg.submit();
    };

    //關閉視窗
    $(".imgCls").click(function (e) {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "100%,0%";
        } else {
            window.close();
        }
    })
</script>
