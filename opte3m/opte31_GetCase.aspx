<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"] ?? "出口爭救案區所交辦資料複製";//功能名稱
    protected string HTProgPrefix = HttpContext.Current.Request["prgid"] ?? "";//程式檔名前綴
    protected string HTProgCode = (HttpContext.Current.Request["prgid"] ?? "");//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;
    protected string SQL = "";

    protected string Branch = "";
    protected string Seq = "";
    protected string Seq1 = "";
    protected string Case_no = "";
    protected string opt_sqlno = "";
    protected string opt_no = "";
    protected string qshowall = "";

    protected string br_source = "";
    protected string bstep_grade = "";
    protected string in_no = "";
    protected string in_scode = "";
    protected string Fappl_name = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        Branch = (Request["qBranch"] ?? "").Trim();
        Seq = (Request["qSeq"] ?? "").Trim();
        Seq1 = (Request["qSeq1"] ?? "").Trim();
        Case_no = (Request["qCase_no"] ?? "").Trim();
        opt_sqlno = (Request["qopt_sqlno"] ?? "").Trim();
        opt_no = (Request["qopt_no"] ?? "").Trim();
        qshowall = (Request["qshowall"] ?? "").Trim();
        
        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            PageLayout();
            this.DataBind();
        }
    }
    
    private void PageLayout() {
        SQL = "Select a.appl_name,a.country,a.br_source,a.bstep_grade from vbr_opte a where opt_sqlno='" + opt_sqlno + "'";
        string appl_name = "";
        using(DBHelper conn=new DBHelper(Conn.OptK, false)) {
            string country = "";
            using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                if (dr.Read()) {
                    appl_name = dr.SafeRead("appl_name", "").CutData(20);
                    country = dr.SafeRead("country", "");
                    br_source = dr.SafeRead("br_source", "");
                    bstep_grade = dr.SafeRead("bstep_grade", "");
                }
            }
            Fappl_name=Funcs.formatSeq(Seq, Seq1, country, Branch, Sys.GetSession("dept")+"E");
            Fappl_name += " " + appl_name;
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="x-ua-compatible" content="ie=10">
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
<table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td class="text9" nowrap="nowrap">&nbsp;【<%=prgid%> <%=HTProgCap%>】
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
		    <td  class="whitetablebg" nowrap align="center">
                案件：<font color="blue"><%=Fappl_name%></font>&nbsp;爭救案件編號：<font color="blue"><%=opt_no%></font>
		    </td>
	    </tr>
    </Table>
    <br>
    <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="50%" align="center">
      <Tr>
	    <td class="lightbluetable" nowrap align="center" width="10%" Onclick="checkall()" style="cursor:pointer">
		    全選
	    </td>
	    <td  class="lightbluetable" nowrap width="40%">複製項目</td>
      </Tr>
      <Tr class="src_br">
	    <td class="whitetablebg" nowrap align="center" width="10%">
		    <input type="checkbox" value="cust" name=CItem>
	    </td>
	    <td  class="whitetablebg" nowrap width="40%">案件客戶、聯絡人</td>
      </Tr>
      <Tr class="src_br">
	    <td  class="whitetablebg" nowrap align="center" width="10%">
		    <input type="checkbox" value="apcust" name=CItem>
	    </td>
	    <td  class="whitetablebg" nowrap width="40%">案件申請人</td>
      </Tr>
      <Tr class="src_br">
	    <td  class="whitetablebg" nowrap align="center">
		    <input type="checkbox" value="ext" name=CItem>
	    </td>
	    <td  class="whitetablebg" nowrap>案件主檔(含對方號)</td>
      </Tr>
      <Tr class="src_br">
	    <td  class="whitetablebg" nowrap align="center">
		    <input type="checkbox" value="remark" name=CItem>
	    </td>
	    <td  class="whitetablebg" nowrap>交辦內容</td>
      </Tr>
	  <Tr class="src_opte">
	    <td  class="whitetablebg" nowrap align="center">
		    <input type="checkbox" value="seq_ext" name=CItem>
	    </td>
	    <td  class="whitetablebg" nowrap>區所案件主檔(含對方號)、申請人資料</td>
      </Tr>
	  <Tr class="tr_your_no">
	    <td  class="whitetablebg" nowrap align="center">
		    <input type="checkbox" value="opte_detail" name=CItem>
	    </td>
	    <td  class="whitetablebg" nowrap>
            補入對方號：<input type="text" name="your_no" id="your_no" size=20 maxlength=50>
	    </td>
      </Tr>
     </table>
    <br />
    <div style="text-align:center">
		<input type=button value="確定" class="cbutton" id="btnSubmit" name="btnSubmit">
		<input type=button value="取消" class="cbutton" id="btnreset" name="btnreset">
		<input type="hidden" id="submittask" name="submittask">
    </div>
    <input type="text" id="Seq" name="Seq" value="<%=Seq%>">
    <input type="text" id="Seq1" name="Seq1" value="<%=Seq1%>">
    <input type="text" id="Branch" name="Branch" value="<%=Branch%>">
    <input type="text" id="Case_no" name="Case_no" value="<%=Case_no%>">
    <input type="text" id="opt_sqlno" name="opt_sqlno" value="<%=opt_sqlno%>">
    <input type="text" id="opt_no" name="opt_no" value="<%=opt_no%>">
    <input type="text" id="br_source" name="br_source" value="<%=br_source%>">
    <input type="text" id="step_grade" name="step_grade" value="<%=bstep_grade%>">
    <input type="text" id="prgid" name="prgid" value="<%=prgid%>">
    <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>
</form>

<iframe id="ActFrame" name="ActFrame" src="about:blank" width="100%" height="500" style="display:none"></iframe>
</body>
</html>

<script language="javascript" type="text/javascript">
    $(function () {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "20%,80%";
        }
        this_init();
    });

    $("#chkTest").click(function (e) {
        $("#ActFrame").showFor($(this).prop("checked"));
    });

    //初始化
    function this_init() {
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",true).triggerHandler("click");//☑測試

        //欄位控制
        $(".src_br").showFor($("#br_source").val() == "br");//區所交辦
        $(".src_opte").showFor($("#br_source").val() == "opte");//自行新增分案
        
        if("<%#qshowall%>"=="N"){
            //「已判行」或「已發文」或「註銷中」只能補對方號
            $(".src_br,.src_opte").hide();
        }
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
        $(".src_"+$("#br_source").val()+" input[name='CItem'],.tr_your_no input[name='CItem']").prop("checked",true);
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

        if ($("input[name='CItem'][value='opte_detail']").prop("checked")){
            if ($("#your_no").val()==""){
                alert("請輸入對方號或取消勾選「補入對方號」！")
                return false;
            }
        }

        var qBrMsg="";
        if ($("#br_source").val()=="br")
            qBrMsg="區所交辦";
        else
            qBrMsg="區所案件";

        if (confirm("注意！！確定要以"+qBrMsg+"資料或補入資料覆蓋，並更新資料庫嗎？(按是，之前所輸入資料將會被清除)")) {
		    $("select,textarea,input").unlock();
		    $("#btnSubmit").lock(!$("#chkTest").prop("checked"));
		    //reg.action = "opte31_GetCase_act.aspx";
		    //reg.target = "ActFrame";
		    //reg.submit();

		    $("input[name='CItem']:checked").each(function() 
		    {
		        var datasource=$(this).val();
		        if (datasource=="opte_detail"){
		            reg.action = "opte31_GetCase_act.aspx";
		            reg.target = "ActFrame";
		            //alert("submit");
		            reg.submit();
		        }else{
		            var url=getRootPath() + "/ajax/get_branchdata.aspx?prgid=<%=prgid%>&datasource=" +datasource+ 
                        "&branch="+$("#Branch").val()+"&case_no="+$("#Case_no").val()+"&opt_sqlno="+$("#opt_sqlno").val()+
                        "&step_grade="+$("#step_grade").val()+"&seq="+$("#Seq").val()+"&seq1="+$("#Seq1").val();
		            //alert(url);
		            window.open(url ,"", "width=800 height=600 top=100 left=100 toolbar=no, menubar=no, location=no, directories=no resizeable=no status=no scrollbars=yes");
		        }
		    });
		}
    });

    //取消
    $("#btnreset").click(function () {
        $("input[name='CItem']").prop("checked",false);
    });
</script>
