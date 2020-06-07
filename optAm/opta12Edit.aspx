<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Linq" %>

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opta12";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string submitTask = "";
    protected string opt_no = "";

    protected string QLock = "false";
    protected string DLock = "false";
    protected string ELock = "false";

    protected string SQL = "";
    protected Dictionary<string, object> RS = new Dictionary<string, object>();

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        submitTask = Request["submitTask"] ?? "";
        opt_no = Request["opt_no"] ?? "";

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            PageLayout();
            this.DataBind();
        }
    }

    private void PageLayout() {
        //欄位開關
        if (submitTask=="D") {
            QLock = "true";
            DLock = "true";
        }else if (submitTask=="Q") {
            QLock = "true";
            DLock = "true";
            ELock = "true";
        }
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
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/client_chk.js")%>"></script>
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
    <input type="text" id="law_sqlno" name="law_sqlno">
	<input type="text" id="submittask" name="submittask" value="<%=submitTask%>">
	<input type="text" id="prgid" name="prgid" value="<%=prgid%>">

        <table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="100%">
            <tr>
                <td class="lightbluetable" align="right" nowrap>
                    爭救案例流水號 :
                </td>
                 <td class="whitetablebg" align="left" nowrap colspan="">
                    <input type="text" id='edit_opt_no' name='edit_opt_no' size="30" maxlength="30" readonly class="SEdit">
                </td>
                <td class="lightbluetable" align="right" nowrap>
                    判決/決定日期  :
                </td>
                 <td class="whitetablebg" align="left" nowrap colspan="">
                   <input type="text" id="edit_pr_date" name="edit_pr_date" size="10" maxLength="10" class="QLock dateField" >
                </td>
            </tr>   
            <tr>
                <td class="lightbluetable" align="right" nowrap>
                    北京案號 :
                </td>
                 <td class="whitetablebg" align="left" nowrap colspan="">
                    <Select id="edit_BJTbranch" name="edit_BJTbranch" class="QLock">
				        <option value="" selected>請選擇</option>
　                      <option value="BJT">BJT</option>
　                      <option value="BJTI">BJTI</option>
			        </Select>                                      
                    -<INPUT TYPE=text id=edit_BJTSeq NAME=edit_BJTSeq SIZE=5 MAXLENGTH=5 class="QLock" >
                    -<INPUT TYPE=text id=edit_BJTSeq1 NAME=edit_BJTSeq1 SIZE=3 MAXLENGTH=3 class="QLock" >
                </td>
                <td class="lightbluetable" align="right" nowrap>
                    本所案號  :
                </td>
                 <td class="whitetablebg" align="left" nowrap colspan="">
                    <Select id="edit_branch" name="edit_branch" class="QLock">
				        <option value="" selected>請選擇</option>
　                      <option value="NT">NT</option>
　                      <option value="CT">CT</option>
　                      <option value="ST">ST</option>
　                      <option value="KT">KT</option>
　                      <option value="NTE">NTE</option>
　                      <option value="CTE">CTE</option>
　                      <option value="STE">STE</option>
　                      <option value="KTE">KTE</option>
			        </Select> 
                    -<INPUT TYPE=text id="edit_BSeq" NAME="edit_BSeq" SIZE=5 MAXLENGTH=5 class="QLock" />
                    -<INPUT TYPE=text id="edit_BSeq1" NAME="edit_BSeq1" SIZE=3 MAXLENGTH=3 class="QLock"  >
                </td>
            </tr>
            <tr>
                <td class="lightbluetable" align="right" nowrap>
                    商標名稱 :
                </td>
                 <td class="whitetablebg" align="left" nowrap colspan="3">
                    <input type="text" class="QLock" id='edit_opt_pic' name='edit_opt_pic' size="50" maxlength="50">                                                                                                                 
                    <input type=button class="QLock cbutton" id="btnedit_opt_pic_path_" name="btnedit_opt_pic_path_" value='上傳' onclick='UploadAttach("","N")' >
                    <input type=button id="PreviewBtn" name="PreviewBtn" class='cbutton' value='檢視' onclick='PreviewOptAttach("")' >
                    <input type=button class="QLock cbutton" id="xxxxx" name="xxxxx" value='刪除' onclick='DelOptAttach("","Y")' >                    
                    <input type="hidden" id="edit_opt_pic_path" name="edit_opt_pic_path">
                    <input type="hidden" id="edit_opt_pic_path_size" name="edit_opt_pic_path_size" >
                    <input type="text" id="edit_opt_pic_path_name" name="edit_opt_pic_path_name" size="40" maxlength="200" readonly class="SEdit" >
                    <input type="hidden" id="edit_opt_pic_path_add_date" name="edit_opt_pic_path_add_date" >
                    <input type="hidden" id="edit_opt_pic_path_add_scode" name="edit_opt_pic_path_add_scode">
                    <input type="hidden" id="edit_opt_pic_path_source_name" name="edit_opt_pic_path_source_name" >
                    <input type="hidden" id="edit_opt_pic_path_desc" name="edit_opt_pic_path_desc" >
                </td>
            </tr> 
            <tr>
                <td class="lightbluetable" align="right" nowrap>
                    客戶編號 :
                </td>
                 <td class="whitetablebg" align="left" nowrap colspan="3">                  
                     <Select id="edit_Cbranch" name="edit_Cbranch" class="QLock" >
				        <option value="" selected>請選擇</option>
　                      <option value="N">N</option>
　                      <option value="C">C</option>
　                      <option value="S">S</option>
　                      <option value="K">K</option>
			        </Select>     
                    <input type="text" id='edit_Cust_no' name='edit_Cust_no' class="QLock" size="5" maxlength="5">
                    客戶名稱 : <input type="text" id='edit_Cust_name' name='edit_Cust_name' class="QLock" size="50" maxlength="50">
                </td>
              
            </tr> 
            <tr>
                <td class="lightbluetable" align="right" nowrap>
                    類別 :
                </td>
                 <td class="whitetablebg" align="left" nowrap colspan="3">
                    <input type="text" id="edit_opt_class" name="edit_opt_class" class="QLock" size="50" maxlength="50"> ( 請用逗號隔開 )
                </td>
            </tr> 
            <tr>
                <td class="lightbluetable" align="right" nowrap>
                    商品 :
                </td>
                 <td class="whitetablebg" align="left" nowrap colspan="3">
                    <textarea rows=6 cols=120 id="edit_opt_class_name" name="edit_opt_class_name" class="QLock" >></textarea>
                </td>
            </tr> 
            <tr>
                <td class="lightbluetable" align="right" nowrap>
                    判決要旨 :
                </td>
                 <td class="whitetablebg" align="left" nowrap colspan="3">
                    <input type="text" id="edit_opt_point" name="edit_opt_point" class="QLock" value="<%=edit_opt_point%>" size="100" maxlength="100">                                                                   
                </td>
            </tr> 
            <tr>
                <td class="lightbluetable" align="right" nowrap>
                    判決/決定文號  :
                </td>
                 <td class="whitetablebg" align="left" nowrap colspan="">
                    <input type="text" id="edit_pr_no" name="edit_pr_no" class="QLock" value="<%=edit_pr_no%>" size="40" maxlength="25">
                </td>
                <TD class=lightbluetable align=right nowrap>成立狀態：</TD>
		        <TD class=whitetablebg align=left nowrap>
			        <input type="radio" name='edit_opt_comfirm' value='1' >全部成立
	                <input type="radio" name='edit_opt_comfirm' value='2' >部分成立
	                <input type="radio" name='edit_opt_comfirm' value='3' >全部不成立
		        </td> 
                
            </tr>            
            <tr>
                <td class="lightbluetable" align="right" nowrap>
                    關鍵字 :
                </td>
                 <td class="whitetablebg" align="left" nowrap colspan="">
                    <input type="text" id='edit_opt_mark' name='edit_opt_mark' class="QLock"  value="<%=edit_opt_mark%>" size="70" maxlength="250"> ( 請用逗號隔開 )        
                </td>
                <TD class=lightbluetable align=right nowrap>生效狀態：</TD>
		        <TD class=whitetablebg align=left nowrap  class="QLock">
			        <input type="radio" name='edit_opt_check' value='1' >確定已生效
	                <input type="radio" name='edit_opt_check' value='2' >確定被推翻
	                <input type="radio" name='edit_opt_check' value='3' >救濟中或尚未能確定
		        </td> 	
            </tr>                                               
            <tr>
                <td class="lightbluetable" align="right" nowrap>
                    建檔人員/日期 :
                </td>
                 <td class="whitetablebg" align="left" nowrap colspan="">
                    <input type="text" id='edit_in_scode' name='edit_in_scode' value="<%=in_scode%>" size="5" maxlength="5" readonly class="SEdit" > / 
                    <input type="text" id="edit_in_date" name="edit_in_date" value="<%=in_date%>" size="25" maxLength="10" readonly class="SEdit">
                </td>
                <td class="lightbluetable" align="right" nowrap>
                    最近異動人員/日期 :
                </td>
                 <td class="whitetablebg" align="left" nowrap colspan="">
                    <input type="text" id='edit_tran_scode' name='edit_tran_scode' value="<%=tran_scode%>" size="5" maxlength="5" readonly class="SEdit" > / 
                    <input type="text" id="edit_tran_date" name="edit_tran_date" value="<%=tran_date%>" size="25" maxLength="10" readonly class="SEdit">
                </td>
            </tr> 
            <tr>
                <td class="lightbluetable" align="right" nowrap>
                    <TABLE id=tr_low name=tr_low style="display:" border=0 class="bluetable"  cellspacing=1 cellpadding=2 width="100%">
	                    <TR class=whitetablebg align=center>
		                    <TD colspan=3 align=right>
                                <input type=hidden id=class_num name=class_num value=0><!--進度筆數-->
			                    <input type=button value ="增加一筆法條" class="cbutton QLock" id=Class_Add_button_law name=Class_Add_button_law>			
			                    <input type=button value ="減少一筆法條" class="cbutton QLock" id=Class_Del_button_law name=Class_Del_button_law onclick="vbscript:deletelaw reg.class_num.value">
		                    </TD>
	                    </TR>
	                    <TR align=center class=lightbluetable>
		                    <TD></TD><TD>引用法條</TD><TD>法條內文</TD>
	                    </TR>
                    </TABLE>

                    <TABLE id=tabattach style="display:" border=0 class="bluetable" cellspacing=1 cellpadding=2 width="100%">
	                    <TR class=whitetablebg align=center>
		                    <TD align=center colspan=7 class=lightbluetable1>
                                <input type=hidden id=attachnum name=attachnum value=0><!--進度筆數-->
                                <input type=hidden id=tAttach_Flag name=tAttach_Flag value=<%=tAttach_Flag%>><!--進度筆數-->            
                                <font color=white>附&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;件&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;上&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;傳</font>
		                    </TD>
	                    </TR>
	                    <TR class=whitetablebg align=center>
		                    <TD colspan=7 align=right>
				                <input type=button value="增加一筆附件" class="cbutton QLock" id=attach_Add_button name=attach_Add_button>			
				                <input type=button value="減少一筆附件" class="cbutton QLock" id=attach_Del_button name=attach_Del_button onclick="deleteattach reg.attachnum.value">
			                    <input type="hidden" name="sqlno" id="sqlno">
			                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                    </TD>
	                    </TR>
	                    <TR align=center class=lightbluetable>
		                    <TD></TD><TD>附件種類</TD><TD>附件名稱</TD><TD>上傳人員/日期</TD><TD>附件說明</TD><TD>停用日期</TD>
	                    </TR>
                    </TABLE>                                                              
                </td>
            </tr> 
        </table>
    <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>
</form>

<table border="0" width="98%" cellspacing="0" cellpadding="0" >
<tr id="tr_button1">
    <td align="center">
        <input type=button value="新　增/修　改" class="cbutton" id="btnSubmit">
        <input type=button value="停  用" class="cbutton" id="btnDel">
        <input type=button value="重　填" class="cbutton" id="btnReset">
    </td>
</tr>
</table>

<iframe id="ActFrame" name="ActFrame" src="about:blank" width="100%" height="500" style="display:none"></iframe>
</body>
</html>

<script language="javascript" type="text/javascript">
    $(function () {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "0%,100%";
        }
        $("#chkTest").click(function (e) {
            $("#ActFrame").showFor($(this).prop("checked"));
        });

        this_init();
    });

    var law_data = {};
    //初始化
    function this_init() {
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",true).triggerHandler("click");//☑測試
        $("input.dateField").datepick();
        //欄位控制
        $(".Lock").lock();
        $(".QLock").lock(<%#QLock%>);
        $(".DLock").lock(<%#DLock%>);
        $(".ELock").lock(<%#ELock%>);

        //取得案例資料
        $.ajax({
            type: "get",
            url: getRootPath() + "/ajax/_LawData.aspx?opt_no=<%=opt_no%>",
            async: false,
            cache: false,
            success: function (json) {
                if($("#chkTest").prop("checked"))toastr.info("<a href='" + this.url + "' target='_new'>Debug！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
                var JSONdata = $.parseJSON(json);
                if (JSONdata.length == 0) {
                    toastr.warning("無案例資料可載入！");
                    return false;
                }
                law_data = JSONdata;
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>案件資料載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });

        var jLaw=law_data.law;
        var jAttach=law_data.law_attach;
        if(jLaw.length>0){
            $("#edit_opt_no").html(jLaw.opt_no);
            $("#edit_pr_date").html(dateReviver(jLaw.pr_date, "yyyy/M/d"));
            $("#edit_BJTSeq").html(jLaw.bjtseq);
            $("#edit_BJTSeq1").html(jLaw.bjtseq1);
            $("#edit_BSeq").html(jLaw.bseq);
            $("#edit_BSeq1").html(jLaw.bseq1);
            $("#edit_opt_pic").html(jLaw.opt_pic);
            $("#edit_opt_pic_path,#edit_opt_pic_path_name").html(jLaw.opt_pic_path);
            $("#edit_Cust_no").html(jLaw.cust_no);
            $("#edit_Cust_name").html(jLaw.cust_name);

            $("#edit_opt_class").html(jLaw.opt_class);
            $("#edit_opt_class_name").html(jLaw.opt_class_name);
      }

        $("#btnSubmit,#btnDel,#btnReset").hide();
    }

    //關閉視窗
    $(".imgCls").click(function (e) {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "100%,0%";
        } else {
            window.close();
        }
    })

    //新增/修改
    $("#btnSubmit").click(function () {
        if ($("#edit_law_type").val() == "") {
            alert("請選擇法條大項！");
            $("#edit_law_type").focus();
            return false;
        }
        if ($("#edit_law_no1").val() == "") {
            alert("請輸入條文法規_條！");
            $("#edit_law_no1").focus();
            return false;
        }
        if ($("#edit_law_no2").val() == "") {
            alert("請輸入條文法規_款！");
            $("#edit_law_no2").focus();
            return false;
        }
        if ($("#edit_law_no3").val() == "") {
            alert("請輸入條文法規_項！");
            $("#edit_law_no3").focus();
            return false;
        }
        if ($("#edit_law_mark").val() == "") {
            alert("請輸入法條內文！");
            $("#edit_law_mark").focus();
            return false;
        }
	
        if($("#submittask").val()=="A"){
            if(!Check_law()){
                alert("請輸入法條代碼重複，請重新輸入 ");
                return false;
            }
        }

        $("select,textarea,input").unlock();
        $("#btnSubmit,#btnDel,#btnReset").lock(!$("#chkTest").prop("checked"));
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.target = "ActFrame";
        reg.submit();
    });

    //刪除
    $("#btnDel").click(function () {
        $("select,textarea,input").unlock();
        $("#btnSubmit,#btnDel,#btnReset").lock(!$("#chkTest").prop("checked"));
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.target = "ActFrame";
        reg.submit();
    });

    //重置
    $("#btnReset").click(function () {
        reg.reset();
        this_init();
    });

    function Check_law(){
        var rtn=false;

        var searchSql="SELECT count(*) as count from law_detail where 1=1 ";
        searchSql+= " AND law_type = '" + $("#edit_law_type").val() + "'" ;
        searchSql+= " AND law_no1 = '" + $("#edit_law_no1").val()+ "'" ;
        searchSql+= " AND law_no2 = '" + $("#edit_law_no2").val() + "'" ;
        searchSql+= " AND law_no3 = '" + $("#edit_law_no3").val() + "'";
        $.ajax({
            type: "get",
            url: getRootPath() + "/ajax/JsonGetSqlData.aspx",
            data: { sql:searchSql},
            async: false,
            cache: false,
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                if (JSONdata.length > 0) {
                    if(JSONdata[0].count==0){
                        rtn=true;
                    }
                }
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>檢查法條代碼失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });

        return rtn;
    }
</script>
