<%@ Page Language="C#" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient" %>
<%@ Import Namespace = "System.IO"%>
<%@ Import Namespace = "System.Linq"%>
<%@ Import Namespace = "System.Collections.Generic"%>

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"] ?? "商標爭救案官方發文明細表";//功能名稱
    protected string HTProgPrefix = HttpContext.Current.Request["prgid"] ?? "";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;
    protected string SQL = "";
    
    protected StringBuilder strOut = new StringBuilder();
    DataTable dtRpt = new DataTable();//明細

    protected string branchname = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "Private";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;
        Response.Clear();

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            PageLayout();
            this.DataBind();
        }

    }

    protected int countnum = 0;//小計件數
    protected int fees = 0;//小計規費
    protected int totcnt = 0;//總計件數
    protected int totfees = 0;//總計規費
    
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

            SQL = "select send_cl,send_clnm,branch,Bseq,Bseq1,rs_no,gs_date,rs_detail,apply_no,Bfees,'正本' as sendmark,sortfld,''branchname";
            SQL += " from vbr_opt where Bstat_code='YS' and Bmark='N'";
            SQL += wSQL;
            SQL += " union ";
            SQL += "select send_cl1 as send_cl,send_cl1nm as send_clnm,branch,Bseq,Bseq1,rs_no,GS_date,rs_detail,apply_no,Bfees,'副本' as sendmark,sortfld,''branchname";
            SQL += " from vbr_opt where Bstat_code='YS' and Bmark='N'";
            SQL += wSQL + " and send_cl1 is not null";
            SQL += " group by send_cl,rs_no,send_clnm,send_cl1,send_cl1nm,branch,Bseq,Bseq1,rs_no,GS_date,rs_detail,apply_no,Bfees,sortfld";
            SQL += " order by sortfld,Branch,send_cl,Bseq,Bseq1,rs_no";
            conn.DataTable(SQL, dtRpt);

            for (int i = 0; i < dtRpt.Rows.Count; i++) {
                using (DBHelper cnn = new DBHelper(Conn.Sysctrl).Debug(Request["chkTest"] == "TEST")) {
                    SQL = "select branchname from branch_code where branch='" + dtRpt.Rows[i]["Branch"] + "'";
                    object objResult = cnn.ExecuteScalar(SQL);
                    dtRpt.Rows[i]["branchname"] = (objResult == DBNull.Value || objResult == null ? "" : objResult.ToString());
                }

                //算總計
                //totcnt += 1;
                //if (dtRpt.Rows[i].SafeRead("sendmark","") == "正本") {
                //    totfees += Convert.ToInt32(dtRpt.Rows[i].SafeRead("Bfees",""));
                //}
            }

            DataTable dtBranch = dtRpt.DefaultView.ToTable(true, new string[] { "branch","branchname" });
            branchRepeater.DataSource = dtBranch;
            branchRepeater.DataBind();
        }
    }

    protected void branchRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e){
        if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem)) {
            Repeater clRpt = (Repeater)e.Item.FindControl("clRepeater");

            if ((clRpt != null)) {
                string branch = ((DataRowView)e.Item.DataItem).Row["branch"].ToString();
                DataTable dtCL = dtRpt.Select("branch='" + branch + "'").CopyToDataTable().DefaultView.ToTable(true, new string[] { "branch","send_cl","send_clnm" });
                clRpt.DataSource = dtCL;
                clRpt.DataBind();
            }
        }
    }

    protected void clRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e){
        countnum = 0;
        fees = 0;
        if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem)) {
            Repeater dtlRpt = (Repeater)e.Item.FindControl("dtlRepeater");

            if ((dtlRpt != null)) {
                string branch = ((DataRowView)e.Item.DataItem).Row["branch"].ToString();
                string send_cl = ((DataRowView)e.Item.DataItem).Row["send_cl"].ToString();
                DataTable dtDtl = dtRpt.Select("branch='" + branch + "' and send_cl='" + send_cl + "'").CopyToDataTable();
                dtlRpt.DataSource = dtDtl;
                dtlRpt.DataBind();
            }
        }
    }

    protected void dtlRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e) {
        if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem)) {
            countnum += 1;//小計件數
            totcnt += 1;//總計件數
            
            if (((DataRowView)e.Item.DataItem).Row["sendmark"].ToString() == "正本") {
                fees += Convert.ToInt32(((DataRowView)e.Item.DataItem).Row["Bfees"].ToString());//小計規費
                totfees += Convert.ToInt32(((DataRowView)e.Item.DataItem).Row["Bfees"].ToString());//總計規費
            }
        }
    }

    protected string GetFees(object oItem) {
        if(DataBinder.Eval(oItem, "sendmark").ToString()=="正本")
            return DataBinder.Eval(oItem, "Bfees").ToString();
        else
            return "&nbsp;";
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
    <HeaderTemplate>
        <asp:Label ID="lblEmpty" runat="server" Visible='<%#bool.Parse((branchRepeater.Items.Count!=0).ToString())%>'>
            <B>處理單位：Ｂ＿國內所專案室</B>
        </asp:Label> 
    </HeaderTemplate>
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

	    <asp:Repeater id="clRepeater" runat="server" OnItemDataBound="clRepeater_ItemDataBound">
	    <ItemTemplate>
            <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="100%">	
			    <tr class="lightbluetable3" style="font-size:12pt">
				    <td colspan=7>&nbsp;<b>發文對象：<%#Eval("send_clnm")%></b>&nbsp;</td>
			    </tr>
			    <tr align="center" height="20" class="lightbluetable" style="font-size:12pt">
				    <td nowrap>本所編號</td>
				    <td>發文內容</td>
				    <td nowrap>正副本</td>
				    <td nowrap>發文日期</td>
				    <td nowrap>發文字號</td>
				    <td nowrap>申請案號</td>
				    <td nowrap>規費</td>
			    </tr>
	            <asp:Repeater id="dtlRepeater" runat="server" OnItemDataBound="dtlRepeater_ItemDataBound">
	            <ItemTemplate>
		            <tr class="<%#(Container.ItemIndex+1)%2== 1 ?"sfont9":"lightbluetable3"%>">
			            <td nowrap align="center"><%#GetSeq(Container.DataItem)%></td>
			            <td>&nbsp;<%#Eval("rs_detail")%></td>
			            <td nowrap align="center"><%#Eval("sendmark")%></td>
			            <td nowrap align="center"><%#Util.parseDBDate(Eval("GS_date").ToString(),"yyyy/M/d")%></td>
			            <td nowrap align="center"><%#Eval("rs_no")%></td>
			            <td nowrap align="center">&nbsp;<%#Eval("apply_no")%></td>
			            <td nowrap align="center"><%#GetFees(Container.DataItem)%></td>
		            </tr>
                </ItemTemplate>
                <FooterTemplate>
				    <tr class="lightbluetable" style="font-size:12pt;color:DarkBlue">
					    <td colspan=3>　小　　計：　　<%#countnum%>件
					    </td>
					    <td colspan=4 align=right>規　費：<%#fees%></td>
				    </tr>
                </FooterTemplate>
                </asp:Repeater>
             </table>
        </ItemTemplate>
        </asp:Repeater>
        <BR>
        <FooterTemplate>
            <br>
            <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="100%">	
	            <tr class="lightbluetable" style="font-size:12pt;color:DarkBlue">
		            <td colspan=3>發文總計：　　<%#totcnt%>件</td>
		            <td colspan=4 align=right>規　費：<%#totfees%></td>
	            </tr>
            </table>
        </FooterTemplate>
    </ItemTemplate>
    <FooterTemplate>
        <asp:Label ID="lblEmpty" runat="server" Visible='<%#bool.Parse((branchRepeater.Items.Count==0).ToString())%>'>
            <div align="center"><font color="red" size=2>=== 查無資料===</font></div>
        </asp:Label> 
    </FooterTemplate>
     </asp:Repeater>
</form>

<iframe id="ActFrame" name="ActFrame" src="about:blank" width="100%" height="500" style="display:none"></iframe>
</body>
</html>
