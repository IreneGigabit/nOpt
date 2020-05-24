<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Data"  %>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "Newtonsoft.Json"%>
<%@ Import Namespace = "Newtonsoft.Json.Linq"%>

<script runat="server">
    protected string SQL = "";

    protected string StrUser = "";
    protected string tdate = "";
    protected bool optAuth = false;
    protected DataTable dtOpt = new DataTable();
    protected bool opteAuth = false;
    protected DataTable dtOpte = new DataTable();

    DBHelper cnn = null;//開完要在Page_Unload釋放,否則sql server連線會一直佔用
    DBHelper conn = null;//開完要在Page_Unload釋放,否則sql server連線會一直佔用
    private void Page_Unload(System.Object sender, System.EventArgs e) {
        if (cnn != null) cnn.Dispose();
        if (conn != null) conn.Dispose();
    }

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "Private";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        cnn = new DBHelper(Conn.ODBCDSN, false).Debug(false);
        conn = new DBHelper(Conn.OptK, false).Debug(false);

        StrUser = Sys.GetSession("sc_name");
        tdate = Request["tdate"] ?? DateTime.Today.ToShortDateString();

        QueryOptData();
        QueryOpteData();

        this.DataBind();
    }

    private void QueryOptData() {
        SQL = "select rights ";
        SQL += "from sysctrl.dbo.vrights ";
        SQL += "where branch='" + Session["SeBranch"] + "'";
        SQL += " and dept='" + Session["Dept"] + "'";
        SQL += " and syscode='" + Session["Syscode"] + "'";
        SQL += " and LoginGrp='" + Session["LoginGrp"] + "'";
        SQL += " and scode='" + Session["scode"] + "'";
        SQL += " and apcode='opt62'";
        SQL += " and beg_date<='" + DateTime.Today.ToShortDateString() + " 00:00:00'";
        SQL += " and (end_date>='" + DateTime.Today.ToShortDateString() + " 23:59:59' or end_date is null)";
        using (SqlDataReader dr = cnn.ExecuteReader(SQL)) {
            if (dr.HasRows) {
                optAuth = true;
                SQL = "select Bseq,Bseq1,opt_no,branch,br_source,Bstat_code,last_date,''fseq ";
                SQL += " from vbr_opt a ";
                SQL += " where last_date <= '" + Util.str2Dateime(tdate).AddDays(15).ToShortDateString() + "' ";
                SQL += " and (Bstat_code <>'YS' and Bstat_code<>'XX') and confirm_date is not null";
                SQL += " and Bmark='N' ";
                SQL += " order by a.last_date,a.Bseq,a.Bseq1";
                conn.DataTable(SQL, dtOpt);
                
                for (int i = 0; i < dtOpt.Rows.Count; i++) {
                    //組案號
                    if(dtOpt.Rows[i].SafeRead("br_source", "")=="opt")
                        dtOpt.Rows[i]["fseq"]+="<font color=\"red\">！</font>";
                    
                     dtOpt.Rows[i]["fseq"]+=dtOpt.Rows[i].SafeRead("Branch", "")+Sys.GetSession("dept")+dtOpt.Rows[i].SafeRead("Bseq", "");
                    
                    if(dtOpt.Rows[i].SafeRead("Bseq1", "")!="_")
                        dtOpt.Rows[i]["fseq"]+="-"+dtOpt.Rows[i].SafeRead("Bseq1", "");
                    
                    if(dtOpt.Rows[i].SafeRead("Bstat_code", "")=="YY")
                        dtOpt.Rows[i]["fseq"]+="<font color=\"red\">*</font>";
                }
            }
        }
        optRepeater.DataSource = dtOpt;
        optRepeater.DataBind();
    }

    private void QueryOpteData() {
        SQL = "select rights ";
        SQL += "from sysctrl.dbo.vrights ";
        SQL += "where branch='" + Session["SeBranch"] + "'";
        SQL += " and dept='" + Session["Dept"] + "'";
        SQL += " and syscode='" + Session["Syscode"] + "'";
        SQL += " and LoginGrp='" + Session["LoginGrp"] + "'";
        SQL += " and scode='" + Session["scode"] + "'";
        SQL += " and apcode='opte62'";
        SQL += " and beg_date<='" + DateTime.Today.ToShortDateString() + " 00:00:00'";
        SQL += " and (end_date>='" + DateTime.Today.ToShortDateString() + " 23:59:59' or end_date is null)";
        using (SqlDataReader dr = cnn.ExecuteReader(SQL)) {
            if (dr.HasRows) {
                opteAuth = true;
                SQL = "select Bseq,Bseq1,opt_no,branch,br_source,Bstat_code,last_date,''fseq ";
                SQL += " from vbr_opte a ";
                SQL += " where last_date <= '" + Util.str2Dateime(tdate).AddDays(10).ToShortDateString() + "' ";
                SQL += " and (Bstat_code <>'YY' and Bstat_code<>'YZ') and confirm_date is not null";
                SQL += " and Bmark='N' ";
                SQL += " order by a.last_date,a.Bseq,a.Bseq1";
                conn.DataTable(SQL, dtOpte);

                for (int i = 0; i < dtOpte.Rows.Count; i++) {
                    //組案號
                    if (dtOpte.Rows[i].SafeRead("br_source", "") == "opte")
                        dtOpte.Rows[i]["fseq"] += "<font color=\"red\">！</font>";

                    dtOpte.Rows[i]["fseq"] += dtOpte.Rows[i].SafeRead("Branch", "") + Sys.GetSession("dept") + "E" + dtOpte.Rows[i].SafeRead("Bseq", "");

                    if (dtOpte.Rows[i].SafeRead("Bseq1", "") != "_")
                        dtOpte.Rows[i]["fseq"] += "-" + dtOpte.Rows[i].SafeRead("Bseq1", "");

                    if (dtOpte.Rows[i].SafeRead("Bstat_code", "") == "YY")
                        dtOpte.Rows[i]["fseq"] += "<font color=\"red\">*</font>";
                }
            }
        }

        opteRepeater.DataSource = dtOpte;
        opteRepeater.DataBind();
    }
</script>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>今日工作清單</title>
    <link href="inc/setstyle.css" rel="stylesheet" />
    <script type="text/javascript" src="js/lib/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="js/util.js"></script>
    <script type="text/javascript" src="js/jquery.Snoopy.date.js"></script>
    <script type="text/javascript" src="js/client_chk.js"></script>
    <style type="text/css">
        .enter{cursor:pointer;background-color: #ffffcc;}
    </style>
</head>
<body style="margin:0px 0px 0px 0px;background:url('images/back02.gif');">
    <form method="post" id="reg" name="reg">
        <table style="font-size:16px" >
        <tr>
	        <td colspan=2 align=center><img src="images/hi11.gif"></td></tr>	
        <tr>
        <tr>
            <td width=20%></td>
	        <td valign=buttom><font color=darkblue><%#StrUser%> 您好,</td>
        </tr>
        </table>
        <table border=0 align=center bgcolor=AliceBlue cellspacing=3 cellpadding=0>
        <tr align=center>
	        <td align=center>
	           <img id="prevdate" src="images\arrow_left1.gif" style="cursor:pointer" align="absmiddle">
	           <font size=2 color=darkblue>今天是&nbsp;
               <img id="nextdate" src="images\arrow_right1.gif" style="cursor:pointer" align="absmiddle">
	        </td>
        </tr>
        <tr>
	        <td align=center>
                <font size=2 color=darkblue>&nbsp;
                <input id="tdate" name="tdate" size=10 value="<%#tdate%>">&nbsp;
            </td>
        </tr>
        </table>
    </form>

<asp:Repeater id="optRepeater" runat="server">
<HeaderTemplate>
    <br><center><a href="opt6m/opt67.aspx?prgid=opt67" target="Etop"><img src="images/line9211.gif" border=0></a></center>
    <TABLE id="optList" border=0 class=bluetable cellspacing=1 cellpadding=2 width="100%">
    <thead>
		<TR class=data2 align="center">
			<td nowrap colspan=2>
			<img onclick="opendata(this,'opt')" v1="close" src="images/icon_go_down.gif" valign=bottom>&nbsp;國內爭救案件(共<%#dtOpt.Rows.Count%>筆)
			</td>
		</TR> 
    </thead>
    <tbody style="display:none">
        <TR class=lightbluetable align=left>
			<td nowrap>案號</td>
			<td nowrap title="橘紅表法定期限"><font color=OrangeRed>法定</font></td>
		</TR> 
</HeaderTemplate>
<ItemTemplate>
    	<TR bgcolor="#FFFFFF" v1="&qryseq=<%#Eval("Bseq")%>&qryseq1=<%#Eval("Bseq1")%>&qryopt_no=<%#Eval("opt_no")%>&qryBranch=<%#Eval("Branch")%>&homelist=homelist">
			<td><%#Eval("fseq")%></td>
			<td style="color:OrangeRed;"><%#Convert.ToDateTime(Eval("last_date")).ToShortDateString()%></td>
		</TR> 
</ItemTemplate>
<FooterTemplate>
	    </tbody>
    </table>
    <br />
</FooterTemplate>
</asp:Repeater>


<asp:Repeater id="opteRepeater" runat="server">
<HeaderTemplate>
    <br><center><a href="opte6m/opte67.aspx?prgid=opte67" target="Etop"><img src="images/line9211.gif" border=0></a></center>
    <TABLE id="opteList" border=0 class=bluetable cellspacing=1 cellpadding=2 width="100%">
    <thead>
		<TR class=data2 align="center">
			<td nowrap colspan=2>
			<img onclick="opendata(this,'opte')" v1="close" src="images/icon_go_down.gif" valign=bottom>&nbsp;出口爭救案件(共<%#dtOpte.Rows.Count%>筆)
			</td>
		</TR> 
    </thead>
    <tbody style="display:none">
        <TR class=lightbluetable align=left>
			<td nowrap>案號</td>
			<td nowrap title="橘紅表法定期限"><font color=OrangeRed>法定</font></td>
		</TR> 
</HeaderTemplate>
<ItemTemplate>
    	<TR bgcolor="#FFFFFF" v1="&qryseq=<%#Eval("Bseq")%>&qryseq1=<%#Eval("Bseq1")%>&qryopt_no=<%#Eval("opt_no")%>&qryBranch=<%#Eval("Branch")%>&homelist=homelist">
			<td><%#Eval("fseq")%></td>
			<td style="color:OrangeRed;"><%#Convert.ToDateTime(Eval("last_date")).ToShortDateString()%></td>
		</TR> 
</ItemTemplate>
<FooterTemplate>
	    </tbody>
    </table>
    <br />
</FooterTemplate>
</asp:Repeater>

</body>
</html>


<script type="text/javascript" language="javascript">
    $(function () {
    });

    $("#opendata").click(function (e) {
        var toggle = $(this).attr("v1");//目前狀態
        if (toggle == "close") {
            $(this).attr("v1", "open");
            $(this).attr("src", "images/go_up.gif");
            $("#optList tbody").show();
        } else {
            $(this).attr("v1", "close");
            $(this).attr("src", "images/icon_go_down.gif");
            $("#optList tbody").hide();
        }
    });

    function opendata(obj,tbl){
        var toggle = $(obj).attr("v1");//目前狀態
        if (toggle == "close") {
            $(obj).attr("v1", "open");
            $(obj).attr("src", "images/go_up.gif");
            $("#"+tbl+"List tbody").show();
        } else {
            $(obj).attr("v1", "close");
            $(obj).attr("src", "images/icon_go_down.gif");
            $("#"+tbl+"List tbody").hide();
        }
    };

    $("#optList tbody tr:gt(0),#opteList tbody tr:gt(0)").hover(
        function () {
            $(this).addClass("enter");
        },
        function () {
            $(this).removeClass("enter");
        }
    );

    $("#optList tbody tr").click(function (e) {
        var url = $(this).attr("v1");
        if (url !== undefined && url != "")
            window.parent.frames.Etop.location.href = "opt6m/opt62_list.aspx?prgid=opt62" + url;
    });

    $("#opteList tbody tr").click(function (e) {
        var url = $(this).attr("v1");
        if (url !== undefined && url != "")
            window.parent.frames.Etop.location.href = "opte6m/opte62_list.aspx?prgid=opte62" + url;
    });

    $("#tdate").blur(function (e) {
        if (ChkDate(this)) return false;
        if ($(this).val() == "") {
            alert("日期欄位必須輸入!!!");
            return false;
        }
        goSearch();
    });

    $("#prevdate").click(function (e) {
        var tdate = new Date($("#tdate").val());
        $("#tdate").val(tdate.addDays(-1).format("yyyy/M/d"));
        goSearch(); 
    });

    $("#nextdate").click(function (e) {
        var tdate = new Date($("#tdate").val());
        $("#tdate").val(tdate.addDays(1).format("yyyy/M/d"));
        goSearch();
    });

    function goSearch() {
        reg.submit();
    }
</script>
