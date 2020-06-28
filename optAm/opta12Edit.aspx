<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Linq" %>

<script runat="server">
    protected string HTProgCap = "";//HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = "opta12";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;
    protected string DebugStr = "";

    protected string submitTask = "";
    protected string opt_no = "";
    protected string htmlattach_type = "";

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
        HTProgCap = myToken.Title;
        DebugStr = myToken.DebugStr;
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

        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            htmlattach_type = Funcs.getcust_code("att_type", "", "").Option("{cust_code}", "{cust_code}_{code_name}");
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
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/jquery.Snoopy.date.js")%>"></script>
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
    <input type="hidden" id="law_sqlno" name="law_sqlno">
	<input type="hidden" id="submittask" name="submittask" value="<%=submitTask%>">
	<input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">

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
                    <input type=button class="QLock cbutton" id="btnedit_opt_pic_path_" name="btnedit_opt_pic_path_" value='上傳' onclick='UploadAttach("")' >
                    <input type=button id="PreviewBtn" name="PreviewBtn" class='cbutton' value='檢視' onclick='PreviewOptAttach("")' >
                    <input type=button class="QLock cbutton" id="xxxxx" name="xxxxx" value='刪除' onclick='DelOptAttach("")' >
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
                    <textarea rows=6 cols=120 id="edit_opt_class_name" name="edit_opt_class_name" class="QLock" ></textarea>
                </td>
            </tr> 
            <tr>
                <td class="lightbluetable" align="right" nowrap>
                    判決要旨 :
                </td>
                 <td class="whitetablebg" align="left" nowrap colspan="3">
                    <input type="text" id="edit_opt_point" name="edit_opt_point" class="QLock" size="100" maxlength="100">                                                                   
                </td>
            </tr> 
            <tr>
                <td class="lightbluetable" align="right" nowrap>
                    判決/決定文號  :
                </td>
                 <td class="whitetablebg" align="left" nowrap colspan="">
                    <input type="text" id="edit_pr_no" name="edit_pr_no" class="QLock" size="40" maxlength="25">
                </td>
                <TD class=lightbluetable align=right nowrap>成立狀態：</TD>
		        <TD class=whitetablebg align=left nowrap>
			        <label><input type="radio" name='edit_opt_comfirm' value='1' >全部成立</labdl>
	                <label><input type="radio" name='edit_opt_comfirm' value='2' >部分成立</labdl>
	                <label><input type="radio" name='edit_opt_comfirm' value='3' >全部不成立</labdl>
		        </td> 
                
            </tr>            
            <tr>
                <td class="lightbluetable" align="right" nowrap>
                    關鍵字 :
                </td>
                 <td class="whitetablebg" align="left" nowrap colspan="">
                    <input type="text" id='edit_opt_mark' name='edit_opt_mark' class="QLock" size="70" maxlength="250"> ( 請用逗號隔開 )        
                </td>
                <TD class=lightbluetable align=right nowrap>生效狀態：</TD>
		        <TD class=whitetablebg align=left nowrap >
			        <label><input type="radio" name='edit_opt_check' value='1' >確定已生效</labdl>
	                <label><input type="radio" name='edit_opt_check' value='2' >確定被推翻</labdl>
	                <label><input type="radio" name='edit_opt_check' value='3' >救濟中或尚未能確定</labdl>
		        </td> 	
            </tr>                                               
            <tr>
                <td class="lightbluetable" align="right" nowrap>
                    建檔人員/日期 :
                </td>
                 <td class="whitetablebg" align="left" nowrap colspan="">
                    <input type="text" id='edit_in_scode' name='edit_in_scode' size="5" maxlength="5" readonly class="SEdit" > / 
                    <input type="text" id="edit_in_date" name="edit_in_date" size="25" maxLength="10" readonly class="SEdit">
                </td>
                <td class="lightbluetable" align="right" nowrap>
                    最近異動人員/日期 :
                </td>
                 <td class="whitetablebg" align="left">
                    <input type="text" id='edit_tran_scode' name='edit_tran_scode' size="5" maxlength="5" readonly class="SEdit" > / 
                    <input type="text" id="edit_tran_date" name="edit_tran_date" size="25" maxLength="10" readonly class="SEdit">
                </td>
            </tr> 
            <tr>
                <td class="whitetablebg" align="right" nowrap colspan="4">
                    <TABLE id=tbl_detail border=0 class="bluetable"  cellspacing=1 cellpadding=2 width="100%">
	                    <thead>
	                        <TR class=whitetablebg align=center>
		                        <TD colspan=3 align=right>
                                    <input type=hidden id=class_num name=class_num value=0><!--進度筆數-->
			                        <input type=button value ="增加一筆法條" class="cbutton QLock" id=Class_Add_button_law name=Class_Add_button_law>
			                        <input type=button value ="減少一筆法條" class="cbutton QLock" id=Class_Del_button_law name=Class_Del_button_law>
		                        </TD>
	                        </TR>
	                        <TR align=center class=lightbluetable>
		                        <TD></TD><TD>引用法條</TD><TD>法條內文</TD>
	                        </TR>
                        </thead>
                        <tfoot style="display:none">
		                    <TR>
			                    <TD class=sfont9 align=center>
		                            <input type=text id='class_num_##' name='class_num_##' class=SEdit readonly size=2 value='##.'>
                                    <input type=hidden id='law_sqlno_##' name='law_sqlno_##'>
			                    </TD>
			                    <TD class=sfont9 align="left">
                                    <select id='law_type_##' name='law_type_##' onchange="law_change('##')" class="QLock"></select>
			                    </TD>
			                    <TD class=sfont9 align="left">
                                    <textarea rows=6 cols=120 id='law_mark_##' name='law_mark_##' class=SEdit readonly ></textarea>
			                    </TD>
		                    </TR>
                        </tfoot>
                        <tbody></tbody>
                    </TABLE>
                </td>
            </tr> 
            <tr>
                <td class="whitetablebg" align="right" nowrap colspan="4">
                    <TABLE id=tabattach border=0 class="bluetable" cellspacing=1 cellpadding=2 width="100%">
	                    <thead>
	                        <TR class=whitetablebg align=center>
		                        <TD align=center colspan=7 class=lightbluetable1>
                                    <input type=hidden id=attachnum name=attachnum value=0><!--進度筆數-->
                                    <input type=hidden id=tAttach_Flag name=tAttach_Flag><!--進度筆數-->            
                                    <font color=white>附&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;件&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;上&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;傳</font>
		                        </TD>
	                        </TR>
	                        <TR class=whitetablebg align=center>
		                        <TD colspan=7 align=right>
			                        <input type="hidden" name="sqlno" id="sqlno">
				                    <input type=button value="增加一筆附件" class="cbutton QLock" id=attach_Add_button name=attach_Add_button>
				                    <input type=button value="減少一筆附件" class="cbutton QLock" id=attach_Del_button name=attach_Del_button>
		                        </TD>
	                        </TR>
	                        <TR align=center class=lightbluetable>
		                        <TD></TD><TD>附件種類</TD><TD>附件名稱</TD><TD>上傳人員/日期</TD><TD>附件說明</TD><TD>停用日期</TD>
	                        </TR>
                        </thead>
                        <tfoot style="display:none">
		                    <TR>
			                    <TD class=sfont9 align=center>
	                                <input type=text id='attachnum##' name='attachnum##' class=SEdit readonly size=2 value='##.'>
	                                <input type=hidden id='attach_sqlno##' name='attach_sqlno##'>
			                    </TD>
			                    <TD class=sfont9 align=center>
	                                <select class="QLock" id='attach_type##' name='attach_type##'><%=htmlattach_type%></select>
			                    </TD>
			                    <TD class=sfont9 align="left">
	                                <input type='hidden' id='edit_opt_pic_path##' name='edit_opt_pic_path##'>
	                                <input type='text' id='edit_opt_pic_path_name##' name='edit_opt_pic_path_name##' size='30' class="Lock SEdit">
	                                <input type='hidden' id='edit_opt_pic_path_size##' name='edit_opt_pic_path_size##'>
	                                <input type='hidden' id='edit_opt_pic_path_source_name##' name='edit_opt_pic_path_source_name##'>
	                                <input type='hidden' id='edit_opt_pic_path_desc##' name='edit_opt_pic_path_desc##'>
	                                <br>
	                                <input type='button' class='cbutton QLock' id='btnedit_opt_pic_path_##' name='btnedit_opt_pic_path_##' value='上傳' onclick="UploadAttach('##')">
	                                <input type='button' class='delbutton QLock' id='btnDelAtt##' name='btnDelAtt##' value='刪除' onclick="DelOptAttach('##')">
	                                <input type='button' class='cbutton' id='btnDisplay##' name='btnDisplay##' value='檢視' onclick="PreviewOptAttach('##')">
			                    </TD>
			                    <TD class=sfont9 align=center>
	                                <input type='text' id='edit_opt_pic_path_add_date##' name='edit_opt_pic_path_add_date##' size='10' class="Lock SEdit">
	                                <input type='text' id='edit_opt_pic_path_add_scode##' name='edit_opt_pic_path_add_scode##' class="Lock SEdit">
			                    </TD>
			                    <TD class=sfont9>
	                                <input type=text id="attach_remark##" name="attach_remark##" size=40 maxlength=80>
			                    </TD>
			                    <TD class=sfont9>
                                    <input type=text id="mEnd_date##" name="mEnd_date##" size=11 maxlength=10 class="Lock QLock ELock">
                                    <input type=hidden id="O_mEnd_date##" name="O_mEnd_date##">
			                    </TD>
		                    </TR>

                        </tfoot>
                        <tbody></tbody>
                    </TABLE>
                </td>
            </tr> 
        </table>
        <%#DebugStr%>
</form>

<table border="0" width="98%" cellspacing="0" cellpadding="0" >
<tr id="tr_button1">
    <td align="center">
        <input type="button" value="新　增" class="cbutton" id="btnAdd">
        <input type="button" value="修　改" class="cbutton" id="btnEdit">
        <input type="button" value="停  用" class="cbutton" id="btnDel">
        <input type="button" value="重　填" class="cbutton" id="btnReset">
    </td>
</tr>
</table>

<iframe id="ActFrame" name="ActFrame" src="about:blank" width="100%" height="500" style="display:none"></iframe>
</body>
</html>

<script language="javascript" type="text/javascript">
    $(function () {
        if (window.parent.tt !== undefined) {
            if ($("#submittask").val() == "A") {
                window.parent.tt.rows = "0%,100%";
            }else{
                window.parent.tt.rows = "50%,50%";
            }
        }

        $("select[name='law_type_##']").getOption({//引用法條
            url: getRootPath() + "/ajax/json_Law.aspx",
            data:{},
            valueFormat: "{law_sqlno}",
            textFormat: "{law_text}"
        });

        this_init();
    });

    var law_data = {};
    //初始化
    function this_init() {
        $("input.dateField").datepick();
        //欄位控制
        $("#btnAdd").showFor($("#submittask").val() == "A");
        $("#btnEdit").showFor($("#submittask").val() == "U");
        $("#btnDel").showFor($("#submittask").val() == "D");
        $("#btnReset").hideFor($("#submittask").val() == "Q");
        $(".Lock").lock();
        $(".QLock").lock(<%#QLock%>);
        $(".DLock").lock(<%#DLock%>);
        $(".ELock").lock(<%#ELock%>);

        if ($("#submittask").val() == "A") {
            $("#edit_opt_no").val("1");
            var searchSql = "select IDENT_CURRENT('law_opt')+1 as opt_no";
            $.ajax({
                type: "get",
                url: getRootPath() + "/ajax/JsonGetSqlData.aspx",
                data: { sql: searchSql },
                async: false,
                cache: false,
                success: function (json) {
                    if ($("#chkTest").prop("checked")) toastr.info("<a href='" + this.url + "' target='_new'>Debug！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
                    var JSONdata = $.parseJSON(json);
                    if (JSONdata.length != 0) {
                        $("#edit_opt_no").val(JSONdata[0].opt_no);
                    }
                },
                error: function () { toastr.error("<a href='" + this.url + "' target='_new'>取得案件流水號失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
            });
        } else {
            //取得案例資料
            $.ajax({
                type: "get",
                url: getRootPath() + "/ajax/_LawData.aspx?opt_no=<%=opt_no%>",
                async: false,
                cache: false,
                success: function (json) {
                    if ($("#chkTest").prop("checked")) toastr.info("<a href='" + this.url + "' target='_new'>Debug！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
                    var JSONdata = $.parseJSON(json);
                    if (JSONdata.length == 0) {
                        toastr.warning("無案例資料可載入！");
                        return false;
                    }
                    law_data = JSONdata;
                },
                error: function () { toastr.error("<a href='" + this.url + "' target='_new'>案件資料載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
            });

            if (law_data.law.length > 0) {
                var jLaw = law_data.law[0];
                $("#edit_opt_no").val(jLaw.opt_no);
                $("#edit_pr_date").val(dateReviver(jLaw.pr_date, "yyyy/M/d"));

                $("#edit_BJTbranch").val(jLaw.bjtbranch);
                $("#edit_BJTSeq").val(jLaw.bjtseq);
                $("#edit_BJTSeq1").val(jLaw.bjtseq1);

                $("#edit_branch").val(jLaw.branch);
                $("#edit_BSeq").val(jLaw.bseq);
                $("#edit_BSeq1").val(jLaw.bseq1);

                $("#edit_opt_pic").val(jLaw.opt_pic);
                $("#edit_opt_pic_path,#edit_opt_pic_path_name").val(jLaw.opt_pic_path);

                $("#edit_Cbranch").val(jLaw.cbranch);
                $("#edit_Cust_no").val(jLaw.cust_no);
                $("#edit_Cust_name").val(jLaw.cust_name);

                $("#edit_opt_class").val(jLaw.opt_class);
                $("#edit_opt_class_name").val(jLaw.opt_class_name);

                $("#edit_opt_point").val(jLaw.opt_point);
                $("#edit_pr_no").val(jLaw.pr_no);
                $("input[name='edit_opt_comfirm'][value='" + jLaw.opt_comfirm + "'").prop("checked", true);
                $("#edit_opt_mark").val(jLaw.opt_mark);
                $("input[name='edit_opt_check'][value='" + jLaw.opt_check + "'").prop("checked", true);

                $("#edit_in_scode").val(jLaw.in_scode);
                $("#edit_in_date").val(dateReviver(jLaw.in_date, "yyyy/M/d t HH:mm:ss"));
                $("#edit_tran_scode").val(jLaw.tran_scode);
                $("#edit_tran_date").val(dateReviver(jLaw.tran_date, "yyyy/M/d t HH:mm:ss"));
            }

            //法條
            var jDetail = law_data.law_detail;
            $("#tbl_detail>tbody").empty();
            if (jDetail.length > 0) {
                $.each(jDetail, function (i, item) {
                    //增加一筆法條
                    appendDetail();
                    //填資料
                    var nRow = $("#class_num").val();
                    $("#law_sqlno_" + nRow).val(item.law_sqlno);
                    $("#law_type_" + nRow).val(item.law_sqlno);
                    $("#law_mark_" + nRow).val(item.law_mark);
                });
            }

            //附件
            var jAttach = law_data.law_attach;
            $("#tabattach>tbody").empty();
            if (jAttach.length > 0) {
                $.each(jAttach, function (i, item) {
                    //增加一筆附件
                    appendAttach();
                    //填資料
                    var nRow = $("#attachnum").val();
                    $("#attach_sqlno" + nRow).val(item.sqlno);
                    $("#attach_type" + nRow).val(item.attach_type);
                    $("#edit_opt_pic_path" + nRow).val(item.attach_path);
                    $("#edit_opt_pic_path_name" + nRow).val(item.attach_name);
                    $("#attach_remark" + nRow).val(item.attach_remark);
                    $("#edit_opt_pic_path_add_date" + nRow).val(dateReviver(item.attach_in_date, "yyyy/M/d"));
                    $("#edit_opt_pic_path_add_scode" + nRow).val(item.attach_scode);
                    $("#mEnd_date" + nRow).val(item.end_date);
                    $("#mEnd_date" + nRow).datepick();
                });
            }
        }
    }

    //增加一筆法條
    $("#Class_Add_button_law").click(function () { appendDetail(); });
    function appendDetail() {
        var nRow = parseInt($("#class_num").val(), 10) + 1;
        //複製樣板
        var copyStr = "";
        $("#tbl_detail>tfoot tr").each(function (i) {
            copyStr += "<tr name='tr_dtl_" + nRow + "'>" + $(this).html().replace(/##/g, nRow) + "</tr>"
        });
        $("#tbl_detail>tbody").append(copyStr);
        $("#class_num").val(nRow)
    }

    //減少一筆法條
    $("#Class_Del_button_law").click(function () { deleteDetail(); });
    function deleteDetail() {
        var nRow = parseInt($("#class_num").val(), 10);
        $("tr[name='tr_dtl_" + nRow + "']").remove();
        $("#class_num").val(Math.max(0, nRow - 1));
    }

    //增加一筆附件
    $("#attach_Add_button").click(function () { appendAttach(); });
    function appendAttach() {
        var nRow = parseInt($("#attachnum").val(), 10) + 1;
        //複製樣板
        var copyStr = "";
        $("#tabattach>tfoot tr").each(function (i) {
            copyStr += "<tr name='tr_attach_" + nRow + "'>" + $(this).html().replace(/##/g, nRow) + "</tr>"
        });
        $("#tabattach>tbody").append(copyStr);
        $("#attachnum").val(nRow)
    }

    //減少一筆附件
    $("#attach_Del_button").click(function () { deleteAttach(); });
    function deleteAttach() {
        var nRow = parseInt($("#attachnum").val(), 10);
        $("tr[name='tr_attach_" + nRow + "']").remove();
        $("#attachnum").val(Math.max(0, nRow - 1));
    }

    //依法條帶內文
    function law_change(pno){
        var searchSql = " SELECT law_mark from law_detail where law_sqlno = '"+$("#law_type_"+ pno).val()+"'";

        $.ajax({
            type: "get",
            url: getRootPath() + "/ajax/JsonGetSqlData.aspx",
            data: { sql:searchSql },
            async: false,
            cache: false,
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                if (JSONdata.length == 0) {
                    $("#law_mark_"+pno).val("");
                } else {
                    $("#law_mark_"+pno).val(JSONdata[0].law_mark);
                }
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>法條內文載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });
    }
    
    //檢視圖檔
    function PreviewOptAttach(nRow){
        var fld = "edit_opt_pic_path";
        if ($("#" + fld + "_name" + nRow).val() == "") {
            alert("請先上傳附件 !!");
            return false;
        }
        var popt_no=$("#edit_opt_no").val();
        var tfolder="attach/"+ popt_no;

        var url = "../sub/display_file.aspx?type=law_opt&folder_name=" + tfolder + "&draw_file=" + $("#" + fld + nRow).val();
        window.open(url, "window", "width=700,height=600,toolbar=yes,menubar=yes,resizable=yes,scrollbars=yes,status=0,top=50,left=80");
    }

    function UploadAttach(nRow) {
        var fld = "edit_opt_pic_path";
        var popt_no = $("#edit_opt_no").val();
        var tfolder = "attach" + "/" + popt_no;

        var url = "../sub/upload_win_file.aspx?type=law_opt" +
            "&folder_name=" + tfolder + "&form_name=" + fld + nRow + "&size_name=" + fld + "_size" + nRow +
            "&file_name=" + fld + "_name" + nRow +
            "&add_date=" + fld + "_add_date" + nRow +
            "&add_scode=" + fld + "_add_scode" + nRow +
            "&btnname=btn" + fld + "_" + nRow +
            "&source_name=" + fld + "_source_name" + nRow +
            "&desc=" + fld + "_desc" + nRow;
        window.open(url, "", "width=700 height=600 top=50 left=50 toolbar=no, menubar=no, location=no, directories=no resizeable=no status=no scrollbars=yes");
    }

    //刪除圖檔上傳
    function DelOptAttach(nRow) {
        var fld = "edit_opt_pic_path";
        var popt_no = $("#edit_opt_no").val();
        var tfolder = "attach" + "/" + popt_no;

        if ($("#" + fld + "_name" + nRow).val() == "") {
            return false;
        }
        if (confirm("確定刪除上傳附件？")) {
            var url = "../sub/del_draw_file.aspx?type=law_opt&folder_name=" + tfolder + "&draw_file=" + $("#" + fld + nRow).val() + "&btnname=btn" + fld + "_" + nRow + "&form_name=" + fld + nRow;
            window.open(url, "myWindowOne1", "width=700 height=600 top=10 left=10 toolbar=no, menubar=no, location=no, directories=no resizeable=no status=no scrollbar=no");

            $("#" + fld + nRow).val("");
            $("#" + fld + "_name" + nRow).val("");
            $("#" + fld + "_add_date" + nRow).val("");
            $("#" + fld + "_add_scode" + nRow).val("");
        }
    }

    //關閉視窗
    $(".imgCls").click(function (e) {
        if (window.parent.tt !== undefined) {
            window.parent.tt.rows = "100%,0%";
        } else {
            window.close();
        }
    })

    //新增/修改
    $("#btnAdd,#btnEdit").click(function () {
        for (var i = 1; i <= parseInt($("#class_num").val(), 10) ; i++) {
            if ($("#law_type_" + i).val() == "") {
                alert("引用法條第" + i + "筆，請選擇 !");
                return false;
            }
            for (var j = 1; j <= parseInt($("#class_num").val(), 10) ; j++) {
                if (i != j) {
                    if ($("#law_type_" + i).val() == $("#law_type_" + j).val()) {
                        alert("引用法條第" + i + "筆，與第" + j + "筆資料重複，請重新選擇 !");
                        $("#law_type_" + j).focus();
                        return false;
                    }
                }
            }
        }

        $("select,textarea,input").unlock();
        $("#btnAdd,#btnEdit,#btnDel,#btnReset").lock(!$("#chkTest").prop("checked"));
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.target = "ActFrame";
        reg.submit();
    });

    //刪除
    $("#btnDel").click(function () {
        $("select,textarea,input").unlock();
        $("#btnAdd,#btnEdit,,#btnDel,#btnReset").lock(!$("#chkTest").prop("checked"));
        reg.action = "<%=HTProgPrefix%>_Update.aspx";
        reg.target = "ActFrame";
        reg.submit();
    });

    //重置
    $("#btnReset").click(function () {
        reg.reset();
        this_init();
    });

    $("#edit_BJTSeq").blur(function () {
        chkNum1($(this)[0],"北京案號");
    });

    $("#edit_BSeq").blur(function () {
        chkNum1($(this)[0],"本所編號");
    });

    $("#edit_pr_date").blur(function () {
        ChkDate($(this)[0]);
    });

    $("#edit_opt_pic").blur(function () {
        fDataLen($(this).val(),50, "商標名稱");
    });

    $("#edit_opt_class").blur(function () {
        fDataLen($(this).val(),50, "類別");
    });

    $("#edit_opt_point").blur(function () {
        fDataLen($(this).val(),500, "判決要旨");
    });

    $("#edit_opt_mark").blur(function () {
        fDataLen($(this).val(),250, "關鍵字");
    });

    $("#edit_pr_no").blur(function () {
        fDataLen($(this).val(),50, "判決/決定文號");
    });
</script>
