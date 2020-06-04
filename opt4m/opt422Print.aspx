<%@ Page Language="C#" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient" %>
<%@ Import Namespace = "System.IO"%>
<%@ Import Namespace = "System.Linq"%>
<%@ Import Namespace = "System.Collections.Generic"%>

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"] ?? "商標爭救案官方發文規費明細表";//功能名稱
    protected string HTProgPrefix = HttpContext.Current.Request["prgid"] ?? "";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;
    protected string SQL = "";
    
    protected StringBuilder strOut = new StringBuilder();
    DataTable dtRpt = new DataTable();//明細

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "Private";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;
        Response.Clear();

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            PageLayout();
            this.Page.DataBind();
        }

    }

    protected string branch = "";//區所別
    protected string branchname = "";//區所別
    
    protected int countnum = 0;//小計件數
    protected int fees = 0;//小計規費
    protected int service = 0;//小計服務費
    protected int totcnt = 0;//總計件數
    protected int totfees = 0;//總計規費
    protected int totservice = 0;//總計服務費
    
    protected void PageLayout() {
        string wSQL = "";
        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(Request["chkTest"] == "TEST")) {
            if ((Request["send_way"] ?? "") != "") wSQL += " and send_way='" + Request["send_way"] + "'";
            if ((Request["sdate"] ?? "") != "") wSQL += " and GS_date>='" + Request["sdate"] + "'";
            if ((Request["edate"] ?? "") != "") wSQL += " and GS_date<='" + Request["edate"] + "'";
            if ((Request["srs_no"] ?? "") != "") wSQL += " and rs_no>='" + Request["srs_no"] + "'";
            if ((Request["ers_no"] ?? "") != "") wSQL += " and rs_no<='" + Request["ers_no"] + "'";
            if ((Request["qryBranch"] ?? "") != "") wSQL += " and branch='" + Request["eseq"] + "'";
            if ((Request["sseq"] ?? "") != "") wSQL += " and seq>=" + Request["sseq"];
            if ((Request["eseq"] ?? "") != "") wSQL += " and seq<=" + Request["eseq"];
            if ((Request["cust_area"] ?? "") != "") wSQL += " and cust_area='" + Request["cust_area"] + "'";
            if ((Request["scust_seq"] ?? "") != "") wSQL += " and cust_seq>=" + Request["scust_seq"];
            if ((Request["ecust_seq"] ?? "") != "") wSQL += " and cust_seq<=" + Request["ecust_seq"];
            if ((Request["qrysend_dept"] ?? "") != "") wSQL += " and send_dept='" + Request["qrysend_dept"] + "'";

            SQL = "select distinct send_cl,send_clnm,sortfld,branch,Bseq,Bseq1,cust_area,cust_seq,ap_cname,rs_no,GS_date,rs_code,rs_detail";
            SQL += ",Bfees,Service,in_scode,appl_name,case_no,scode_name,rs_no";
            SQL += ",(select ar_mark from case_opt where opt_sqlno=a.opt_sqlno and a.mark='N') as ar_mark";
            SQL += ",''branchname,''cust_name";
            SQL += " from vbr_opt a where a.Bstat_code='YS' and a.Bmark='N' ";
            SQL += wSQL + " and Bfees>0";
            SQL += " order by send_cl,sortfld,Bseq,Bseq1,a.rs_no";
            conn.DataTable(SQL, dtRpt);

            for (int i = 0; i < dtRpt.Rows.Count; i++) {
                using (DBHelper cnn = new DBHelper(Conn.Sysctrl).Debug(Request["chkTest"] == "TEST")) {
                    SQL = "select branchname from branch_code where branch='" + dtRpt.Rows[i]["Branch"] + "'";
                    object objResult = cnn.ExecuteScalar(SQL);
                    dtRpt.Rows[i]["branchname"] = (objResult == DBNull.Value || objResult == null ? "" : objResult.ToString());
                }

                using (DBHelper connB = new DBHelper(Conn.OptB(dtRpt.Rows[i].SafeRead("Branch", ""))).Debug(Request["chkTest"] == "TEST")) {
                    SQL = "Select RTRIM(ISNULL(ap_cname1, '')) + RTRIM(ISNULL(ap_cname2, ''))  as cust_name from apcust as c ";
                    SQL += " where c.cust_area='" + dtRpt.Rows[i]["cust_area"] + "' and c.cust_seq='" + dtRpt.Rows[i]["cust_seq"] + "'";
                    using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                        if (dr.Read()) {
                            dtRpt.Rows[i]["cust_name"] = dr.SafeRead("cust_name", "");
                        }
                    }

                }
            }

            DataTable dtBranch = dtRpt.DefaultView.ToTable(true, new string[] { "branch", "branchname" });
            branchRepeater.DataSource = dtBranch;
            branchRepeater.DataBind();
        }
    }

    protected void branchRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e) {
        totcnt = 0;
        totfees = 0;
        totservice = 0;

        if ((e.Item.ItemType == ListItemType.Header)) {
            //Response.Write("<span style='color:red'>branchRepeater_HeaderDataBound</span><BR>");
        }
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem) { 
            //Response.Write("<span style='color:red'>branchRepeater_ItemDataBound</span>"+e.Item.ItemIndex+"<BR>");

            Repeater clRpt = (Repeater)e.Item.FindControl("clRepeater");
            if ((clRpt != null)) {
                branch = ((DataRowView)e.Item.DataItem).Row["branch"].ToString();
                DataTable clDtl = dtRpt.DefaultView.ToTable(true, new string[] { "branch", "branchname", "send_cl", "send_clnm" }).Select("branch='" + branch + "'").CopyToDataTable();
                clRpt.DataSource = clDtl;
                clRpt.DataBind();
            }
        }
        if ((e.Item.ItemType == ListItemType.Footer)) {
            //Response.Write("<span style='color:red'>branchRepeater_FooterDataBound</span><BR>");
        }
    }

    protected void clRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e) {
        countnum = 0;
        fees = 0;
        service = 0;

        if ((e.Item.ItemType == ListItemType.Header)) {
            //Response.Write("<span style='color:green'>clRepeater_HeaderDataBound</span><BR>");
        }
        if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem)) {
            //Response.Write("<span style='color:green'>clRepeater_ItemDataBound</span><BR>");

            Repeater dtlRpt = (Repeater)e.Item.FindControl("dtlRepeater");
            if ((dtlRpt != null)) {
                string send_cl = ((DataRowView)e.Item.DataItem).Row["send_cl"].ToString();
                DataTable dtlDtl = dtRpt.Select("branch='" + branch + "' and send_cl='" + send_cl + "'").CopyToDataTable();
                dtlRpt.DataSource = dtlDtl;
                dtlRpt.DataBind();
            }
        }
        if ((e.Item.ItemType == ListItemType.Footer)) {
            //Response.Write("<span style='color:green'>clRepeater_FooterDataBound</span><BR>");
        }
    }

    protected void dtlRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e) {
        if ((e.Item.ItemType == ListItemType.Header)) {
            //Response.Write("dtlRepeater_HeaderDataBound<BR>");
        }
        if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem)) {
            //Response.Write("dtlRepeater_ItemDataBound_" + ((DataRowView)e.Item.DataItem).Row["branch"].ToString() + "_" + ((DataRowView)e.Item.DataItem).Row["send_cl"].ToString() + "<BR>");
            countnum += 1;
            fees += Convert.ToInt32(((DataRowView)e.Item.DataItem).Row["Bfees"].ToString());
            service += Convert.ToInt32(((DataRowView)e.Item.DataItem).Row["service"].ToString());
            totcnt += 1;
            totfees += Convert.ToInt32(((DataRowView)e.Item.DataItem).Row["Bfees"].ToString());
            totservice += Convert.ToInt32(((DataRowView)e.Item.DataItem).Row["service"].ToString());
        }
        if ((e.Item.ItemType == ListItemType.Footer)) {
            //Response.Write("dtlRepeater_FooterDataBound<BR>");
        }
    }

    protected string GetSeq(object oItem) {
        string rtn = DataBinder.Eval(oItem, "branch").ToString() + Sys.GetSession("dept") + DataBinder.Eval(oItem, "Bseq").ToString();
        if (DataBinder.Eval(oItem, "Bseq1").ToString() != "_")
            rtn += "-" + DataBinder.Eval(oItem, "Bseq1").ToString();

        return rtn;
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="x-ua-compatible" content="IE=10">
<title><%=HTProgCap%></title>
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/inc/setstyle.css")%>" />
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/lib/jquery.datepick.css")%>" />
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/lib/toastr.css")%>" />
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery-1.12.4.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery.datepick.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery.datepick-zh-TW.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/toastr.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/util.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.Snoopy.date.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.irene.form.js")%>"></script>
</head>

<body>
<form id="reg" name="reg" method="post">
	<asp:Repeater id="branchRepeater" runat="server" OnItemDataBound="branchRepeater_ItemDataBound">
        <FooterTemplate>
            <asp:Label ID="lblEmpty" runat="server" Visible='<%#bool.Parse((branchRepeater.Items.Count==0).ToString())%>'>
                <div align="center"><font color="red" size=2>=== 查無資料===</font></div>
            </asp:Label> 
        </FooterTemplate>
	    <ItemTemplate>
            <table border="0" width="100%" cellspacing="1" cellpadding="0" align="center">
		        <tr>
                    <td width="100%" style="font-size:20px" colspan="3" align=center><%#Eval("branchname")%><%#HTProgCap%></td>
		        </tr>
		        <tr style="font-size:12pt">
			        <td width="20%" align=left></td>
			        <td width="60%" align=center>發文日期：<%#Request["sdate"]%>～<%#Request["edate"]%></td>
			        <td width="20%" align=right><a href="javascript:window.print();void(0);">列印</a>日期：<%#DateTime.Today.ToShortDateString()%></td>
		        </tr>
            </table>
            <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="100%">	
		        <tr align="center" height="20" class="lightbluetable" style="font-size:12pt">
			        <td nowrap rowspan=2>本所編號</td>
			        <td>案件名稱</td>
			        <td colspan=4>發文內容</td>
		        </tr>
		        <tr align="center" height="20" class="lightbluetable" style="font-size:12pt">
			        <td nowrap>客戶名稱</td>
			        <td nowrap>交辦單號</td>
			        <td nowrap>服務費</td>
			        <td nowrap>規費</td>
			        <td nowrap>營洽</td>
		        </tr>
	<asp:Repeater id="clRepeater" runat="server" OnItemDataBound="clRepeater_ItemDataBound">
	<ItemTemplate>
		        <tr class="lightbluetable3" style="font-size:12pt">
			        <td colspan=6>&nbsp;<b>對象：<%#Eval("send_clnm")%></b></td>
		        </tr>
	<asp:Repeater id="dtlRepeater" runat="server" OnItemDataBound="dtlRepeater_ItemDataBound">
	<ItemTemplate>
                <tr class="<%#(Container.ItemIndex+1)%2== 1 ?"sfont9":"lightbluetable3"%>">
			        <td nowrap align="center" rowspan=2 title="<%#Eval("rs_no")%>"><%#GetSeq(Container.DataItem)%></td>
			        <td>&nbsp;<%#Eval("appl_name")%></td>
			        <td colspan=4>&nbsp;<%#Eval("rs_code")%>-<%#Eval("rs_detail")%></td>
		        </tr>
                <tr class="<%#(Container.ItemIndex+1)%2== 1 ?"sfont9":"lightbluetable3"%>">
			        <td>&nbsp;<%#Eval("cust_area")%><%#Eval("cust_seq").ToString().PadLeft(5,'0')%><%#Eval("cust_name")%></td>
			        <td align="center"><%#Eval("case_no").ToString()!="" ?Eval("case_no").ToString():"&nbsp;"%></td>
			        <td nowrap align="center">
                        <%#Eval("service").ToString()!="" ?Eval("service").ToString():"0"%>
                        <%#Eval("ar_mark").ToString()=="D" ?"(D)":""%>
			        </td>
			        <td nowrap align="center"><%#Eval("Bfees")%></td>
			        <td nowrap align="center"><%#Eval("scode_name").ToString()!="" ?Eval("scode_name").ToString():"&nbsp;"%></td>
		        </tr>
    </ItemTemplate>
    <FooterTemplate>
	            <tr class="lightbluetable" style="font-size:12pt;color:DarkBlue">
		            <td colspan=2>　小　　計：　　<%#countnum%>件</td>
		            <td colspan=2>服務費：<%#service%></td>
		            <td colspan=2>規　費：<%#fees%></td>
	            </tr>
    </FooterTemplate>
    </asp:Repeater>
    </ItemTemplate>
    <FooterTemplate>
	            <tr class="lightbluetable" style="font-size:12pt;color:DarkBlue">
		            <td colspan=2>　總　　計：　　<%#totcnt%>件</td>
		            <td colspan=2>服務費：<%#totservice%></td>
		            <td colspan=2>規　費：<%#totfees%></td>
	            </tr>
            </table>
    </FooterTemplate>
    </asp:Repeater>
        </ItemTemplate>
     </asp:Repeater>
</form>
</body>
</html>
