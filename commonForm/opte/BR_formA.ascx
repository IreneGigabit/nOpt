<%@ Control Language="C#" ClassName="ext_br_formA" %>

<script runat="server">
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string SQL = "";
    protected string branch = "";
    protected string opt_sqlno = "";
    protected string submitTask = "";
    protected string arcase_type = "";
    
    private void Page_Load(System.Object sender, System.EventArgs e) {
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";
        submitTask = Request["submitTask"] ?? "";
        arcase_type = Funcs.GerArcaseType();
        
        this.DataBind();
    }
</script>

<%=Sys.GetAscxPath(this)%>
<input type="text" id="in_date" name="in_date">
<input type="text" id="apply_no" name="apply_no">
<input type="text" id="apply_date" name="apply_date">
<input type="text" id="issue_no" name="issue_no">
<input type="text" id="issue_date" name="issue_date">
<input type="text" id="renewal_no" name="renewal_no">
<input type="text" id="renewal_date" name="renewal_date">
<input type="text" id="ext_term1" name="ext_term1">
<input type="text" id="ext_term2" name="ext_term2">
<input type="text" id="cust_name" name="cust_name">
<input type="text" id="ap_ename" name="ap_ename">
<input type="text" id="class" name="class">
<input type="text" id="class_count" name="class_count">
<input type="text" id=br_apnum name=br_apnum value=0><!--進度筆數-->
<table id=br_tab border="0" class="bluetable" cellspacing="1" cellpadding="2" width="100%">
	<Tr>
		<TD align=center colspan=4 class=lightbluetable1><font color="white">工&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;作&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;資&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;料</font></TD>
	</TR>
	<tr id="tr_Popt_show1" style="display:none">
		<td class="lightbluetable" valign="top"  align="right"><strong>案件編號：</strong></td>
		<td class="whitetablebg" colspan="7" valign="top">
			<input type="text" size="11" id="Opt_no" name="Opt_no" class="QLock" maxLength="10">
		</td>
	</tr>
	<TR>
		<td class="lightbluetable"  align="right">區所本所編號 :</td>
		<td class="whitetablebg"  align="left"  >
			<Select id="Branch" name="Branch" class="QLock"></Select>
			<input type="text" id="Bseq" name="Bseq" SIZE=5 class="QLock" maxLength="5">-
			<input type="text" id="Bseq1" name="Bseq1" SIZE=1 class="QLock" maxLength="1">
			<input type="text" id="country" name="country" SIZE=2 class="QLock Lock">
			<input type="button" value="確定" class="cbutton QHide" id="btnBseq" name="btnBseq">
			<input type="text" id="keyBseq" name="keyBseq" value="N" class="QHide">
			<input type="text" id="oldBranch" name="oldBranch">
			<input type="text" id="oldBseq" name="oldBseq">
			<input type="text" id="oldBseq1" name="oldBseq1">
		</td>
		<td class="lightbluetable"  align="right">營洽 :</td>
		  <td class="whitetablebg"  align="left">
			<input type="text" id="in_scode" name="in_scode" class="CLock" SIZE=5 >
			<input type="text" id="scode_name" name="scode_name" class="CLock" SIZE=10  >
		</td>
	</TR>
	<tr>
			<td class=lightbluetable align=right>國外所案號：</td>
			<td class=whitetablebg >TE-<INPUT TYPE=text id=ext_seq name=ext_seq SIZE=5 MAXLENGTH=5 class="sedit" readonly>-<INPUT TYPE=text id=ext_seq1 name=ext_seq1 SIZE=3 MAXLENGTH=3  class="sedit" readonly value="_">	
			<td class=lightbluetable align=right>對方號：</td>
			<td class=whitetablebg ><INPUT TYPE=text id=your_no name=your_no SIZE=20 MAXLENGTH=20 >	
			<input type="button" value="查詢" class="cbutton QHide" id="btnyour_no" name="btnyour_no">
	</tr>
	<tr>
		<td class=lightbluetable align=right >代理人編號：</td>
		<td class=whitetablebg colspan=3>
		    <font color=blue>案件代理人</font>
            <input type="text" id="agt_no" name="agt_no" SIZE="4" maxlength="4" class="sedit" readonly>
            <input type="text" id="agt_no1" name="agt_no1" SIZE="1" maxlength="1" class="sedit" readonly><span id="span_agent_name"></span>
		    <font color=blue>延展代理人</font>
            <input type="text" id="renewal_agt_no" name="renewal_agt_no" SIZE="4" maxlength="4" class="sedit" readonly>
            <input type="text" id="renewal_agt_no1" name="renewal_agt_no1" SIZE="1" maxlength="1" class="sedit" readonly><span id="span_renewal_agent_name"></span>
		</td>
	</tr>	
	<TR>
		<td class="lightbluetable"  align="right">案件名稱 :</td>
		<td class="whitetablebg"  align="left" colspan=3>
			<input type="text" id="appl_name" name="appl_name" class="CLock" SIZE=90 maxlength=100>
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right">申請人 :</td>
		<td class="whitetablebg"  align="left" colspan=3>
			<input type="text" id="ap_cname" name="ap_cname" class="CLock" SIZE=60 maxlength=60 >
		    <input type="text" id="cust_seq" name="cust_seq">
		    <input type="text" id="cust_area" name="cust_area">
		    <input type="text" id="att_sql" name="att_sql">
		</td>
	</TR>
	<TR style="display:">
		<td class="lightbluetable"  align="right">交辦案性 :</td>
		  <td class="whitetablebg"  align="left" colspan=3>結構分類：
			    <select id="rs_class" name="rs_class" class="QLock"></select>
			 	案性：
                <span id=span_rs_code>
			 	<select id=Arcase NAME=Arcase SIZE=1 class="QLock"></select>
				</span>
				<input type="text" id="arcase_type" name="arcase_type" value="<%#arcase_type %>">
				<input type="text" id="arcase_class" name="arcase_class" >
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right" nowrap>法定期限 :</td>
		  <td class="whitetablebg"  align="left" colspan=3 >
			<input type="text" id="dfy_last_date" name="dfy_last_date" SIZE=10 class="RLock dateField" maxlength=10>
		</td>
	</TR>
    <Tr>
		<td class="lightbluetable" align="right">工作說明 :</td>
		<TD class=lightbluetable colspan=3>
			<textarea ROWS="6" style="width:90%" id=remark name="remark" class="RLock"></textarea>
		</TD>
	</tr>
    <Tr>
		<td class="lightbluetable" colspan="4">
            <table id="br_aptab"></table>
		</td>
	</Tr>
</table>

<script language="javascript" type="text/javascript">
    var br_formA = {};
    br_formA.init = function () {
        $("#Branch").getOption({//區所別
            url: "../ajax/_GetSqlDataCnn.aspx",
            data: { sql: "select branch,branchname from branch_code where mark='Y' and branch<>'J' order by sort" },
            valueFormat: "{branch}",
            textFormat: "{branch}_{branchname}"
        });
        $("#agt_no").getOption({//出名代理人
            url: "../ajax/LookupDataBranch.aspx",
            data: { type: "getagtdata", branch: "<%#branch%>" },
            valueFormat: "{agt_no}",
            textFormat: "{strcomp_name}{agt_name}"
        });
        $("#Arcase").getOption({//交辦案性
            url: "../ajax/LookupDataBranch.aspx",
            data: { type: "getarcasedata", branch: "<%#branch%>" },
            valueFormat: "{rs_code}",
            textFormat: "{rs_codenm}---{rs_detail}",
            attrFormat: "val1='{rs_type}' val2='{rs_class}'"
        });

        $("#Branch").val("<%#branch%>");

        //$("#tr_Popt_show1").hideFor($("#submittask").val()=="ADD");//新增分案時不顯示案件編號
        //$(".unlockADD").unlock($("#submittask").val()=="ADD");//新增分案解鎖
        //$(".showADD").showFor($("#submittask").val()=="ADD");//新增分案顯示
    }

    //載入爭救案件資料
    br_formA.loadOpt = function () {
        var jOpt = br_opte.opte[0];
        if (jOpt!=null) {
            $("#Branch,#oldBranch").val(jOpt.branch);
            $("#Opt_no").val(jOpt.opt_no);
            $("#Bseq,#oldBseq").val(jOpt.bseq);
            $("#country").val(jOpt.country);
            $("#Bseq1,#oldBseq1").val(jOpt.bseq1);
            $("#Bseq1,#oldBseq1").val(jOpt.bseq1);
            $("#in_scode").val(jOpt.in_scode);
            $("#scode_name").val(jOpt.scode_name);
            $("#appl_name").val(jOpt.appl_name);
            $("#ap_cname").val(jOpt.ap_cname);
            $("#cust_seq").val(jOpt.cust_seq);
            $("#cust_area").val(jOpt.cust_area);
            $("#att_sql").val(jOpt.att_sql);

            //$("#Arcase").val(jOpt.arcase).trigger("change");

            $("#dfy_last_date").val(dateReviver(jOpt.last_date, "yyyy/M/d"));
            $("#remark").val(jOpt.remark);

            $("#in_date").val(dateReviver(jOpt.in_date, "yyyy/M/d"));
            $("#apply_no").val(jOpt.apply_no);
            $("#apply_date").val(dateReviver(jOpt.apply_date, "yyyy/M/d"));
            $("#issue_no").val(jOpt.issue_no);
            $("#issue_date").val(dateReviver(jOpt.issue_date, "yyyy/M/d"));
            $("#renewal_no").val(jOpt.renewal_no);
            $("#renewal_date").val(dateReviver(jOpt.renewal_date, "yyyy/M/d"));
            $("#ext_term1").val(dateReviver(jOpt.ext_term1, "yyyy/M/d"));
            $("#ext_term2").val(dateReviver(jOpt.ext_term2, "yyyy/M/d"));
            $("#cust_name").val(jOpt.cust_name);
            $("#ap_ename").val(jOpt.ap_ename);
        }
    };

    //載入區所案件資料
    $("#btnBseq").click(function () { 
        br_formA.loadDmt(); 
    });
    br_formA.loadDmt = function () {
        var br_dmt = {};
        if ($("#Branch").val()==""){ alert("區所別未輸入!!!"); return false;}
        if ($("#Bseq").val()==""){ alert("區所編號未輸入!!!"); return false;}
        if ($("#Bseq1").val()==""){ alert("區所編號副碼未輸入!!!"); return false;}
        //取得區所案件資料
        $.ajax({
            type: "get",
            url: getRootPath() + "/AJAX/ExtData.aspx?branch=" + $("#Branch").val() + "&seq=" + $("#Bseq").val() + "&seq1=" + $("#Bseq1").val(),
            async: false,
            cache: false,
            success: function (json) {
                if ($("#chkTest").prop("checked")) toastr.info("<a href='" + this.url + "' target='_new'>DmtData Debug！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
                var JSONdata = $.parseJSON(json);
                if (JSONdata.ext.length == 0) {
                    alert($("#Bseq").val()+"-"+$("#Bseq1").val()+"不存在於案件主檔內，請重新輸入!!!");
                    return false;
                }
                var jExt = JSONdata.ext[0];
                if (jExt != null) {
                    if (jExt.end_date != "") {
                        if ($("#submittask").val() != "Q") {
                            if(!confirm("本案件區所已結案，是否確定新增分案？"))
                                return false;
                        }
                    }
                    if ($("#submittask").val() != "Q") {
                        //提醒案件國別是否為大陸
                        if (jExt.country != "CM") {
                            if (!confirm("本案件國別為" + jExt.country + "非大陸案，是否確定新增分案？"))
                                return false;
                        }
                    }
                    $("#appl_name").val(jExt.appl_name);
                    $("#class").val(jExt.class);
                    $("#class_count").val(jExt.class_count);
                    $("#cust_area").val(jExt.cust_area);
                    $("#cust_seq").val(jExt.cust_seq);
                    $("#cust_name").val(jExt.custname);
                    $("#agt_no").val(jExt.agt_no);
                    $("#agt_no1").val(jExt.agt_no1);
                    $("#span_agent_name").html(jExt.agtname);
                    $("#scode_name").val(jExt.scodename);
                    $("#in_scode").val(jExt.scode);
                    $("#apply_date").val(dateReviver(jExt.apply_date, "yyyy/M/d"));
                    $("#apply_no").val(jExt.apply_no);
                    $("#issue_date").val(dateReviver(jExt.issue_date, "yyyy/M/d"));
                    $("#issue_no").val(jExt.issue_no);
                    $("#renewal_date").val(dateReviver(jExt.renewal_date, "yyyy/M/d"));
                    $("#renewal_no").val(jExt.renewal_no);
                    $("#your_no").val(jExt.your_no);
                    $("#ext_term1").val(dateReviver(jExt.term1, "yyyy/M/d"));
                    $("#ext_term2").val(dateReviver(jExt.term2, "yyyy/M/d"));
                    $("#in_date").val(dateReviver(jExt.in_date, "yyyy/M/d"));
                    $("#ext_seq").val(jExt.ext_seq);
                    $("#ext_seq1").val(jExt.ext_seq1);
                    $("#country").val(jExt.country);
                    $("#ap_cname").val(jExt.ap_cname);
                    $("#att_sql").val(jExt.att_sql);
                    $("#renewal_agt_no").val(jExt.renewal_agt_no);
                    $("#renewal_agt_no1").val(jExt.renewal_agt_no1);
                    $("#span_renewal_agent_name").html(jExt.renewal_agtname);

                    $("#br_apnum").val(JSONdata.ext_ap.length);
		            $("#oldBranch").val($("#Branch").val());
		            $("#oldBseq").val($("#Bseq").val());
		            $("#oldBseq1").val($("#Bseq1").val());
                    $("#keyBseq").val("Y"); //有按確定給Y
                }

                var jAp = JSONdata.ext_ap;
                $("#br_aptab").empty();
                $.each(jAp, function (i, item) {
                    var nRow = i + 1;
                    var trHTML = "";
                    trHTML += "<input type=text id='apsqlno_" + nRow + "' name='apsqlno_" + nRow + "' value='"+item.apsqlno+"'>";
                    trHTML += "<input type=text id='apcust_no_" + nRow + "' name='apcust_no_" + nRow + "' value='"+item.apcust_no+"'>";
                    trHTML += "<input type=text id='ap_cname_" + nRow + "' name='ap_cname_" + nRow + "' value='"+item.ap_cname+"'>";
                    trHTML += "<input type=text id='ap_cname1_" + nRow + "' name='ap_cname1_" + nRow + "' value='"+item.ap_cname1+"'>";
                    trHTML += "<input type=text id='ap_cname2_" + nRow + "' name='ap_cname2_" + nRow + "' value='"+item.ap_cname2+"'>";
                    trHTML += "<input type=text id='ap_ename_" + nRow + "' name='ap_ename_" + nRow + "' value='"+item.ap_ename+"'>";
                    trHTML += "<input type=text id='ap_ename1_" + nRow + "' name='ap_ename1_" + nRow + "' value='"+item.ap_ename1+"'>";
                    trHTML += "<input type=text id='ap_ename2_" + nRow + "' name='ap_ename2_" + nRow + "' value='"+item.ap_ename2+"'>";
                    $("#br_aptab").append("<tr><td colspan=4>" + trHTML + "</td></tr>");
                });

                $("#btnBseq").prop("disabled", true);
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>案件資料載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });
    };

    $("#BSeq").blur(function (e) {
        chkNum($(this).val(), "區所案件編號");
    });

    $("#dfy_last_date").blur(function (e) {
        if ($("#dfy_last_date").val() != "") {
            var Adate = (new Date($("#dfy_last_date").val())).addDays(-5);
            if (Adate < (new Date())){
                Adate = (new Date($("#dfy_last_date").val()));
            }else{
                Adate = (new Date());
            }
        }
        //$("#ctrl_date").val(Adate.format("yyyy/M/d")); //不給預設值
    });

    //---查詢對方號
    $("#btnyour_no").click(function (e) {
        if ($("#Branch").val() == "") {
            alert("區所別未輸入!!!");
            $("#Branch").focus();
            return false;
        }
        if ($("#your_no").val() == "") {
            alert("對方號未輸入!!!(可輸入關鍵字)");
            $("#your_no").focus();
            return false;
        }
        var tlink = getRootPath() + "/opte2m/ext_yournolist.aspx?branch=" + $("#Branch").val() + "&your_no=" + $("#your_no").val() + "&prgid=<%=prgid%>";
        window.open(tlink, "mywindow", "width=700,height=480,toolbar=yes,menubar=yes,resizable=yes,scrollbars=yes,status=0,top=50,left=80");
    });
</script>
