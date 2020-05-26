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
    protected string y_title = "";
    protected string y_align = "center";
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
        StrFormBtnTop += "<br><a href=\"window.print()\" target=\"myWindowOne\">列印</a>日期："+DateTime.Today.ToShortDateString();

        //根據查詢條件組查詢條件字串(hrefq)
        hrefq += "&qryKind=" + Request["qryKind"];
        hrefq += "&qryinclude=" + Request["qryinclude"];
        hrefq += "&qrystatus=" + Request["qrystatus"];
        hrefq += "&qrykindDate=" + Request["qrykindDate"];
        hrefq += "&qrypr_scode=" + Request["qrypr_scode"];
        hrefq += "&qrysdate=" + ReqVal["qrysdate"];
        hrefq += "&qryedate=" + ReqVal["qryedate"];
        hrefq += "&qryYear=" + Request["qryYear"];
        hrefq += "&qrysMonth=" + Request["qrysMonth"];
        hrefq += "&qryeMonth=" + Request["qryeMonth"];
        hrefq += "&qryClass=" + Request["qryClass"];
        hrefq += "&qryPClass=" + Request["qryPClass"];
        hrefq += "&qryPClassA=" + Request["qryPClassA"];
        hrefq += "&qrybr_source=" + Request["qrybr_source"];
        hrefq += "&prgid=" + Request["prgid"];

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
            y_title = "類別";
            y_align = "center";
        } else if ((Request["qrykind"] ?? "") == "rs_code") {
            qrykind_name = "&nbsp;<font color=blue>◎統計依據：</font>案性";
            y_title = "案性";
            y_align = "left";
        } else if ((Request["qrykind"] ?? "") == "month") {
            qrykind_name = "&nbsp;<font color=blue>◎統計依據：</font>月份";
            ReqVal["qrySdate"] = Request["qryYear"] + "/" + Request["qrysMonth"].Trim() + "/1"; //上個月一號
            ReqVal["qryEdate"] = new DateTime(Convert.ToInt32(Request["qryYear"].ToString()), Convert.ToInt32(Request["qryeMonth"].Trim()), 1).AddMonths(1).AddDays(-1).ToShortDateString();
            y_title = "月份";
            y_align = "center";
        }

        string qrycode_name = "";
        if ((Request["qryPClassA"] ?? "") == "") {
            SQL = "select code_name from cust_code where code_type='OClass' and cust_code in('" + Request["qryClass"].Replace(";", "','") + "')";
            string PClassnm = "";
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                while (dr.Read()) {
                    PClassnm += (PClassnm != "" ? "、" : "") + dr.SafeRead("code_name", "");
                }
            }
            qrycode_name = "&nbsp;<font color=blue>◎統計類別：</font>" + PClassnm;
        }

        string qryinclude_name = "";
        if ((Request["qryinclude"] ?? "") == "Y") {
            qryinclude_name = "<br>&nbsp;<font color=blue>◎包含項目：</font>只印附屬案性";
        } else if ((Request["qryinclude"] ?? "") == "N") {
            qryinclude_name = "<br>&nbsp;<font color=blue>◎包含項目：</font>不含附屬案性";
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
            qrypr_scode_name = "<br>&nbsp;<font color=blue>◎承辦人：</font>" + qrypr_scode_name;
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
                qryAP_DATE_name = "<br>&nbsp;<font color=blue>◎收文期間：</font>";
            } else if ((Request["qrykinddate"] ?? "") == "ap_date") {
                qryAP_DATE_name = "<br>&nbsp;<font color=blue>◎判行期間：</font>";
            }
            qryAP_DATE_name += ReqVal["qrySdate"] + "~" + ReqVal["qryEdate"];
        }

        titleLabel = "<font color=red>" + qrybr_source_name + qrykind_name + qrycode_name + qryinclude_name + qrybranch_name +
            qrypr_scode_name + qrystatus_name + qryAP_DATE_name + "</font>";
    }

    private void QueryData() {
        //using (DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST")) {
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

            //y軸(只有by案性要小計)
            if ((Request["qrykind"] ?? "") == "rs_class") {//類別
                SQL = "select 0 sub_Rank,''sub_value,''sub_text,cust_code y_value,code_name y_text ";
                SQL += "from cust_code ";
                SQL += "where code_type='OClass' ";
                if ((Request["qryClass"] ?? "") != "") {
                    SQL += "and cust_code in('" + Request["qryClass"].Replace(";", "','") + "')";
                }
                SQL += "order by cust_code ";
            } else if ((Request["qrykind"] ?? "") == "rs_code") {//案性
                SQL = "select row_number() OVER (PARTITION BY t.form_name ORDER BY t.cust_code desc) AS sub_Rank ";
                SQL += ",t.form_name sub_value,o.code_name sub_text,t.cust_code y_value,o.code_name+'－'+t.code_name y_text ";
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
                SQL += "order by t.form_name,t.cust_code ";
            } else if ((Request["qrykind"] ?? "") == "month") {//月份
                SQL = "select 0 sub_Rank,''sub_value,''sub_text,m.cust_code y_value,m.code_name y_text ";
                SQL += "from cust_code m ";
                SQL += "where m.code_type='Omonth' and m.cust_code>=" + Request["qrysMonth"] + " and m.cust_code<=" + Request["qryeMonth"] + " ";
                SQL += " order by m.sortfld ";
            }
            conn.DataTable(SQL, dty);

            //符合條件的所有明細
            SQL = "select month(a." + Request["qrykinddate"] + ")m_ap_date,* from vopt_641 as a ";
            SQL += "where a.Bmark<>'B' and a.form_name is not null ";
            if ((Request["qrykind"] ?? "") == "rs_class") {//類別
                SQL += " and a." + Request["qrykinddate"] + ">='" + ReqVal["qrySdate"] + "'";
                SQL += " and a." + Request["qrykinddate"] + "<='" + ReqVal["qryEdate"] + "'";
            } else if ((Request["qrykind"] ?? "") == "rs_code") {//案性
                SQL += " and a." + Request["qrykinddate"] + ">='" + ReqVal["qrySdate"] + "'";
                SQL += " and a." + Request["qrykinddate"] + "<='" + ReqVal["qryEdate"] + "'";
            } else if ((Request["qrykind"] ?? "") == "month") {//月份
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
            if ((Request["qryClass"] ?? "") != "") {
                SQL += "and a.form_name in('" + Request["qryClass"].Replace(";", "','") + "')";
            }
            conn.DataTable(SQL, dt);


            branchRepeater1.DataSource = dtx;
            branchRepeater1.DataBind();
            branchRepeater2.DataSource = dtx;
            branchRepeater2.DataBind();

            yRepeater.DataSource = dty;
            yRepeater.DataBind();
        //}
    }

    protected void yRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e) {
        if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem)) {// For items
            Repeater branchRepeater3 = (Repeater)e.Item.FindControl("branchRepeater3");
            branchRepeater3.DataSource = dtx;
            branchRepeater3.DataBind();
            Repeater branchRepeater5 = (Repeater)e.Item.FindControl("branchRepeater5");
            branchRepeater5.DataSource = dtx;
            branchRepeater5.DataBind();
        } else if (e.Item.ItemType == ListItemType.Footer) {// For Footer
            Repeater branchRepeater4 = (Repeater)e.Item.FindControl("branchRepeater4");
            branchRepeater4.DataSource = dtx;
            branchRepeater4.DataBind();
        }
    }

    //案件數
    protected string GetCount(RepeaterItem Container, bool isSubLine, bool showlink) {
        string rtn = "";
        string x_branch = DataBinder.Eval(Container.DataItem, "x_branch").ToString();
        string y_value = (DataBinder.Eval(((RepeaterItem)Container.Parent.Parent).DataItem, "y_value") ?? "").ToString();
        string sub_value = (DataBinder.Eval(((RepeaterItem)Container.Parent.Parent).DataItem, "sub_value") ?? "").ToString();
        string arug = "";

        string where = " 1=1 ";
        if ((Request["qrykind"] ?? "") == "rs_class") {//依類別
            if (sub_value != "") where += " and ''='" + sub_value + "'";
            if (y_value != "" &&!isSubLine) where += " and form_name='" + y_value + "'";
            if (x_branch != "") where += " and branch='" + x_branch + "'";

            arug = "&form_name=" + y_value;
        } else if ((Request["qrykind"] ?? "") == "rs_code") {//依案性
            if (sub_value != "") where += " and form_name='" + sub_value + "'";
            if (y_value != ""&&!isSubLine) where += " and arcase='" + y_value + "'";
            if (x_branch != "") where += " and branch='" + x_branch + "'";

            if (isSubLine)//小計列
                arug = "&PClass=" + sub_value;
            else
                arug = "&arcase=" + y_value;
        } else if ((Request["qrykind"] ?? "") == "month") {//依月份
            if (sub_value != "") where += " and ''='" + sub_value + "'";
            if (y_value != "" &&!isSubLine) where += " and m_ap_date='" + y_value + "'";
            if (x_branch != "") where += " and branch='" + x_branch + "'";
            arug = "&month=" + y_value;
        }

        rtn = dt.Compute("count(branch)", where).ToString();
        rtn = rtn == "" ? "0" : Convert.ToInt32(rtn).ToString("N0");

        if (showlink && rtn != "0")
            rtn = String.Format("<a href='opt64_3List.aspx?1=1{0}&submitTask=Q&qryBranch={1}{2}' target='Eblank'>{3}</a>"
                , hrefq, x_branch, arug, rtn);

        return rtn;
    }

    //服務費
    protected string GetFees(RepeaterItem Container, bool isSubLine, bool showlink) {
        string rtn = "";
        string x_branch = DataBinder.Eval(Container.DataItem, "x_branch").ToString();
        string y_value = (DataBinder.Eval(((RepeaterItem)Container.Parent.Parent).DataItem, "y_value") ?? "").ToString();
        string sub_value = (DataBinder.Eval(((RepeaterItem)Container.Parent.Parent).DataItem, "sub_value") ?? "").ToString();
        string arug = "";

        string where = " 1=1 ";
        if ((Request["qrykind"] ?? "") == "rs_class") {//依類別
            if (sub_value != "") where += " and ''='" + sub_value + "'";
            if (y_value != ""&&!isSubLine) where += " and form_name='" + y_value + "'";
            if (x_branch != "") where += " and branch='" + x_branch + "'";

            arug = "&form_name=" + y_value;
        } else if ((Request["qrykind"] ?? "") == "rs_code") {//依案性
            if (sub_value != "") where += " and form_name='" + sub_value + "'";
            if (y_value != ""&&!isSubLine) where += " and arcase='" + y_value + "'";
            if (x_branch != "") where += " and branch='" + x_branch + "'";

            arug = "&arcase=" + y_value;

        } else if ((Request["qrykind"] ?? "") == "month") {//依月份
            if (sub_value != "") where += " and ''='" + sub_value + "'";
            if (y_value != ""&&!isSubLine) where += " and m_ap_date='" + y_value + "'";
            if (x_branch != "") where += " and branch='" + x_branch + "'";
            arug = "&month=" + y_value;
        }

        rtn = dt.Compute("sum(service)", where).ToString();
        rtn = rtn == "" ? "0" : Convert.ToInt32(rtn).ToString("N0");

        if (showlink && rtn != "0")
            rtn = String.Format("<a href='opt64_3List.aspx?1=1{0}&submitTask=Q&qryBranch={1}{2}' target='Eblank'>{3}</a>"
                , hrefq, x_branch, arug, rtn);

        return rtn;
    }

    //平均金額
    protected string GetAvg(RepeaterItem Container, bool isSubLine) {
        decimal fees = Convert.ToDecimal(GetFees(Container, isSubLine, false));
        decimal count = Convert.ToDecimal(GetCount(Container, isSubLine, false));

        decimal avg = 0;
        if (fees != 0 && count != 0) {
            avg = fees / count;
        }

        return avg.ToString("N0");
    }

    protected string GetXY(RepeaterItem Container) {
        string x_branch = DataBinder.Eval(Container.DataItem, "x_branch").ToString();
        string y_value = (DataBinder.Eval(((RepeaterItem)Container.Parent.Parent).DataItem, "y_value") ?? "").ToString();
        string sub_value = (DataBinder.Eval(((RepeaterItem)Container.Parent.Parent).DataItem, "sub_value") ?? "").ToString();
        string sub_Rank = (DataBinder.Eval(((RepeaterItem)Container.Parent.Parent).DataItem, "sub_Rank") ?? "").ToString();

        return sub_Rank + "_" + sub_value + "(" + x_branch + "," + y_value + ")";
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
<br />
<table width="100%" cellspacing="1" cellpadding="2" class="bluetable" align="center">
    <tr align="left">
        <td align="center" class="lightbluetable" rowspan=2><%#y_title%></td>
        <asp:Repeater id="branchRepeater1" runat="server">
        <ItemTemplate>
            <td align="center" class="lightbluetable" colspan=3><%#Eval("x_branchnm")%></td>
        </ItemTemplate>
        </asp:Repeater>
    </tr>
    <tr>
        <asp:Repeater id="branchRepeater2" runat="server">
        <ItemTemplate>
            <td align="center" class="lightbluetable" nowrap>案件數</td>
            <td align="center" class="lightbluetable" nowrap>服務費</td>
            <td align="center" class="lightbluetable" nowrap>平均金額</td>
        </ItemTemplate>
        </asp:Repeater>
    </tr>

    <asp:Repeater id="yRepeater" runat="server" OnItemDataBound="yRepeater_ItemDataBound">
    <ItemTemplate>
        <tr>
            <td align="<%#y_align%>" class="lightbluetable3"><%#Eval("y_text")%></td>
            <asp:Repeater id="branchRepeater3" runat="server">
            <ItemTemplate>
                <td align="center" class="<%#Eval("x_branch")!= "" ?"sfont9":"lightbluetable3"%>" title="<%#GetXY(Container)%>">
                    <%#GetCount(Container,false,true)%>
                </td>
                <td align="center" class="<%#Eval("x_branch")!= "" ?"sfont9":"lightbluetable3"%>" title="<%#GetXY(Container)%>">
                    <%#GetFees(Container,false,false)%>
                </td>
                <td align="center" class="<%#Eval("x_branch")!= "" ?"sfont9":"lightbluetable3"%>" title="<%#GetXY(Container)%>">
                    <%#GetAvg(Container,false)%>
                </td>
            </ItemTemplate>
            </asp:Repeater>
        </tr>
        <tr style="display:<%#Eval("sub_Rank").ToString()=="1"?"":"none"%>">
            <td class="Yellowtable" align="right"><%#Eval("sub_text")%>-小計</td>
            <asp:Repeater id="branchRepeater5" runat="server">
            <ItemTemplate>
                <td align="center" class="Yellowtable" title="<%#GetXY(Container)%>">
                    <%#GetCount(Container,true,true)%>
                </td>
                <td align="center" class="Yellowtable" title="<%#GetXY(Container)%>">
                    <%#GetFees(Container,true,false)%>
                </td>
                <td align="center" class="Yellowtable" title="<%#GetXY(Container)%>">
                    <%#GetAvg(Container,true)%>
                </td>
            </ItemTemplate>
            </asp:Repeater>
        </tr>
    </ItemTemplate>
    <FooterTemplate>
        <tr>
            <td align="right" class="lightbluetable">總計</td>
            <asp:Repeater id="branchRepeater4" runat="server">
            <ItemTemplate>
                <td align="center" class="lightbluetable" title="<%#GetXY(Container)%>"><%#GetCount(Container,false,true)%></td>
                <td align="center" class="lightbluetable" title="<%#GetXY(Container)%>"><%#GetFees(Container,false,false)%></td>
                <td align="center" class="lightbluetable" title="<%#GetXY(Container)%>"><%#GetAvg(Container,false)%></td>
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
