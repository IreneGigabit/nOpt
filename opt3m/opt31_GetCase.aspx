<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"] ?? "爭救案區所交辦資料複製";//功能名稱
    protected string HTProgPrefix = HttpContext.Current.Request["prgid"] ?? "";//程式檔名前綴
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected int HTProgRight = 0;
    protected string SQL = "";

    protected string qBranch = "";
    protected string qSeq = "";
    protected string qSeq1 = "";
    protected string qCase_no = "";
    protected string qArcase = "";
    protected string qopt_sqlno = "";
    protected string qopt_no = "";
    protected string qBr = "";
    protected string qBrMsg = "";

    protected string in_no = "";
    protected string in_scode = "";
    protected string Fappl_name = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        qBranch = (Request["qBranch"] ?? "").Trim();
        qSeq = (Request["qSeq"] ?? "").Trim();
        qSeq1 = (Request["qSeq1"] ?? "").Trim();
        qCase_no = (Request["qCase_no"] ?? "").Trim();
        qArcase = (Request["qArcase"] ?? "").Trim();
        qopt_sqlno = (Request["qopt_sqlno"] ?? "").Trim();
        qopt_no = (Request["qopt_no"] ?? "").Trim();
        qBr = (Request["qBr"] ?? "").Trim();//N代表區所交辦　//Y代表自行分案

        Token myToken = new Token(prgid);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            PageLayout();
            this.DataBind();
        }
    }


    private void PageLayout() {
        if (qBr == "N")
            qBrMsg = "區所交辦";
        else
            qBrMsg = "區所案件";

        SQL = "Select * from Case_dmt where Case_no='" + qCase_no + "'";
        using (DBHelper connB = new DBHelper(Conn.OptB(qBranch), false)) {
            using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    in_no = dr.SafeRead("in_no", "").Trim();
                    in_scode = dr.SafeRead("in_scode", "").Trim();
                }
            }
        }

        SQL = "Select * from vbr_opt where opt_sqlno='" + qopt_sqlno + "'";
        string appl_name = "";
        using(DBHelper conn=new DBHelper(Conn.OptK, false)) {
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    appl_name = dr.SafeRead("appl_name", "").CutData(20);
                }
            }
            Fappl_name=Sys.formatSeq(qSeq, qSeq1, "", qBranch, Sys.GetSession("dept"));
            Fappl_name += " " + appl_name;
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=HTProgCap%></title>
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/inc/setstyle.css")%>" />
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/jquery.datepick.css")%>" />
<link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/toastr.css")%>" />
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery-1.12.4.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.datepick.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.datepick-zh-TW.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/toastr.min.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/util.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.Snoopy.date.js")%>"></script>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.irene.form.js")%>"></script>
</head>

<body>
<table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td class="text9" nowrap="nowrap">&nbsp;【<%=prgid%><%=HTProgCap%>】
        </td>
        <td class="FormLink" valign="top" align="right" nowrap="nowrap">
            <a class="imgCls" href="javascript:void(0);" >[關閉視窗]</a>
        </td>
    </tr>
    <tr>
        <td colspan="2"><hr class="style-one"/></td>
    </tr>
</table>
<br>
<form id="reg" name="reg" method="post">
    <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="50%" align="center">
	    <Tr>
		    <td  class="whitetablebg" nowrap align="center">案件：<font color="blue"><%=Fappl_name%></font></td>
	    </tr>
    </Table>
    <br>
    <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="50%" align="center">
      <Tr class="qBrN">
	    <td class="lightbluetable" nowrap align="center" width="10%" Onclick="checkall()" style="cursor:pointer">
		    全選
	    </td>
	    <td  class="lightbluetable" nowrap width="40%">複製項目</td>
      </Tr>
      <Tr class="qBrN">
	    <td  class="whitetablebg" nowrap align="center" width="10%">
		    <input type="checkbox" value="vcustlist" name=CItem>
	    </td>
	    <td  class="whitetablebg" nowrap width="40%">案件客戶、聯絡人</td>
      </Tr>
      <Tr class="qBrN">
	    <td  class="whitetablebg" nowrap align="center" width="10%">
		    <input type="checkbox" value="apcust" name=CItem>
	    </td>
	    <td  class="whitetablebg" nowrap width="40%">案件申請人</td>
      </Tr>
      <Tr class="qBrN">
	    <td  class="whitetablebg" nowrap align="center">
		    <input type="checkbox" value="caseitem_dmt" name=CItem>
	    </td>
	    <td  class="whitetablebg" nowrap>收費與接洽事項</td>
      </Tr>
      <Tr class="qBrN">
	    <td  class="whitetablebg" nowrap align="center">
		    <input type="checkbox" value="dmt_temp" name=CItem>
	    </td>
	    <td  class="whitetablebg" nowrap>交辦內容</td>
      </Tr>
	    <Tr class="qBrY">
	    <td  class="whitetablebg" nowrap align="center">
		    <input type="checkbox" value="dmt" name=CItem>
	    </td>
	    <td  class="whitetablebg" nowrap>區所案件之營洽、出名代理人、案件名稱、申請人等資料</td>
      </Tr>
     </table>
    <br />
    <div style="text-align:center">
		<input type=button value="確定" class="cbutton" id="btnSubmit" name="btnSubmit">
		<input type=button value="取消" class="cbutton" id="btnreset" name="btnreset">
		<input type="hidden" id="submittask" name="submittask">
    </div>
    <input type="hidden" id="qSeq" name="qSeq" value="<%=qSeq%>">
    <input type="hidden" id="qSeq1" name="qSeq1" value="<%=qSeq1%>">
    <input type="hidden" id="qBranch" name="qBranch" value="<%=qBranch%>">
    <input type="hidden" id="qCase_no" name="qCase_no" value="<%=qCase_no%>">
    <input type="hidden" id="qArcase" name="qArcase" value="<%=qArcase%>">
    <input type="hidden" id="qopt_sqlno" name="qopt_sqlno" value="<%=qopt_sqlno%>">
    <input type="hidden" id="qopt_no" name="qopt_no" value="<%=qopt_no%>">
    <input type="hidden" id="qBr" name="qBr" value="<%=qBr%>">
    <input type="hidden" id="in_no" name="in_no" value="<%=in_no%>">
    <input type="hidden" id="in_scode" name="in_scode" value="<%=in_scode%>">
    <input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">
    <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>
</form>
</body>
</html>

<script language="javascript" type="text/javascript">
    $(function () {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "20%,80%";
        }
        this_init();
    });

    //初始化
    function this_init() {
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",true);//☑測試

        //欄位控制
        $(".qBrN").showFor($("#qBr").val() == "N");
        $(".qBrY").showFor($("#qBr").val() == "Y");
    }

    //關閉視窗
    $(".imgCls").click(function (e) {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "100%,0%";
        } else {
            window.close();
        }
    })

    //全選
    function checkall(){
        $(".qBr"+$("#qBr").val()+" input[name='CItem']").prop("checked",true);
    }

    //確定
    $("#btnSubmit").click(function () {
        var errMsg = "";
        
        var check=$("input[name='CItem']:checked").length;
        if (check==0){
            errMsg+="尚未選定!!\n";
        }

        if (errMsg!="") {
            alert(errMsg);
            return false;
        }

		if (confirm("注意！！確定要以<%#qBrMsg%>資料覆蓋，並更新資料庫嗎？(按是，所輸入資料將會被清除)")) {
		    $("select,textarea,input").unlock();
		    $("#btnSubmit").lock(!$("#chkTest").prop("checked"));
		    reg.action = "opt31_GetCase_act.aspx";
		    reg.submit();
		}
    });

    //取消
    $("#btnreset").click(function () {
        $("input[name='CItem']").prop("checked",false);
    });
</script>
