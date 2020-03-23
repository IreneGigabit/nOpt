<%@ Control Language="C#" ClassName="send_form" %>

<script runat="server">
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string SQL = "";
    protected string branch = "";
    protected string opt_sqlno = "";
    protected string case_no = "";
   
    private void Page_Load(System.Object sender, System.EventArgs e) {
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";
        case_no = Request["case_no"] ?? "";
        
        this.DataBind();
    }
</script>

<%=Sys.GetAscxPath(this,MapPathSecure(TemplateSourceDirectory))%>
<table border="0" id=tabSend class="bluetable" cellspacing="1" cellpadding="2" width="100%">
	<Tr>
		<TD align=center colspan=6 class=lightbluetable1><font color="white">發&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;文&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;資&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;料</font></TD>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right" nowrap>發文單位 :</td>
		<td class="whitetablebg"  align="left" colspan=5>
			<input type="radio" name="send_dept" class="SClass" value="B">自行發文
			<input type="radio" name="send_dept" class="SClass" value="L">轉法律處發文
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right" nowrap>預計發文日期 :</td>
		<td class="whitetablebg"  align="left">
			 	<input type="text" name="GS_date" SIZE=10  maxlength="10" class="SClass" value="<%=gs_date%>" class="dateField">
		</td>
		<td class="lightbluetable"  align="right" nowrap>總收發文日期 :</td>
		<td class="whitetablebg"  align="left" colspan=3>
			<input type="text" name="mp_date" SIZE=10  maxlength="10" class="SClass" value="<%=mp_date%>" class="dateField">
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right" nowrap>發文對象 :</td>
		<td class="whitetablebg"  align="left">
			<SELECT id=send_cl name=send_cl value="<%=send_cl%>" class="SClass"></SELECT>
		</td>
		<td class="lightbluetable"  align="right" nowrap>單位副本 :</td>
		<td class="whitetablebg"  align="left">
			<SELECT id=send_cl1 name=send_cl1 value="<%=send_cl1%>" class="SClass"></SELECT>
		</td>
		<td class="lightbluetable"  align="right" nowrap>官方號碼 :</td>
		<td class="whitetablebg"  align="left">
			<SELECT id=send_sel name=send_sel value="<%=send_sel%>" class="SClass"></SELECT>
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right" nowrap>發文代碼 :</td>
		<td class="whitetablebg"  align="left" colspan=5>
			結構分類：
			<input type="text" name="rs_type" id="rs_type">
			<span id=span_rs_class>
				<select id="rs_class" name="rs_class" class="SEClass"></select>
			</span>
			案性：
			<span id=span_rs_code>
				<select id="rs_code" name="rs_code" onchange='rs_code_onchange1()' class="SEClass"></select>
			</span><br>
			處理事項：
			<input type="hidden" id="act_sqlno" name="act_sqlno" value="<%=act_sqlno%>">
			<span id=span_act_code>
				<select id="act_code" name="act_code" class="SClass" ></select>
			</span>	
		</td>
		<input type="hidden" name="code_br_agt_no">
		<input type="hidden" name="code_br_agt_nonm">
		<input type="hidden" name="rs_agt_no">
	</TR>
	<TR>
		<td class="lightbluetable"  align="right" nowrap>發文內容 :</td>
		<td class="whitetablebg"  align="left" colspan=5>
			<input type="text" name="rs_detail" SIZE=60  maxlength="60" class="SClass" value="<%=rs_detail%>">
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right" nowrap>規費支出 :</td>
		<td class="whitetablebg"  align="left" colspan=5>
			<input type="text" name="Send_Fees" SIZE=10  maxlength="10" class="SEClass" value="<%=send_Fees%>">
			<input type="hidden" name="old_Send_Fees" SIZE=10  maxlength="10" class="SEClass" value="<%=send_Fees%>">
		</td>
	</TR>
	<TR id="tr_score_flag">
		<td class="lightbluetable"  align="right" nowrap>是否輸入評分 :</td>
		<td class="whitetablebg"  align="left" colspan=5>
			<input type="radio" name="score_flag" class="SClass" value="Y">是
			<input type="radio" name="score_flag" class="SClass" value="N">>否
		</td>
	</TR>
</table>

<script language="javascript" type="text/javascript">
    $("#send_cl,#send_cl1").getOption({//發文對象/單位副本
        url: "../ajax/_GetSqlDataBranch.aspx",
        data: { branch: "<%#branch%>", sql: "select cust_code,code_name from cust_code where code_type='SEND_CL'" },
        valueFormat: "{cust_code}",
        textFormat: "{code_name}",
    });
    $("#send_sel").getOption({//官方號碼
        url: "../ajax/_GetSqlDataBranch.aspx",
        data: { branch: "<%#branch%>", sql: "select cust_code,code_name from cust_code where code_type='SEND_SEL'" },
        valueFormat: "{cust_code}",
        textFormat: "{code_name}",
    });

    var send_form = {};
    send_form.init = function () {
        send_form.loadOpt();
        $(".LockB").lock($("#Back_flag").val() == "B"||$("#submittask").val() == "Q");
    }

    send_form.loadOpt = function () {
        var jOpt = br_opt.opt[0];

        $("#rs_type").val(jOpt.rs_type);
        if($("#rs_type").val()=="")$("#rs_type").val(jOpt.arcase_type);

        $("#rs_class").getOption({//結構分類
            url: "../ajax/_GetSqlDataBranch.aspx",
            data: { branch: "<%#branch%>"
                , sql: "select cust_code,code_name from cust_code where code_type='"+$("#rs_type").val()+"' and mark is null and mark1='B' "+
				      " and cust_code in (select rs_class from vcode_act where cg ='G' and rs = 'S' and rs_type='" +$("#rs_type").val()+ "') order by cust_code"
            },
            valueFormat: "{cust_code}",
            textFormat: "{code_name}",
        });

        $("input[name='score_flag'][value='" + jOpt.score_flag + "']").prop("checked", true);
        $("#tr_score_flag").hideFor($("#prgid").val().indexOf("opt31") > -1);//承辦結辦作業不顯示

    }

    //依結構分類帶案性代碼
    $("#rs_class").change(function () { send_form.setRsCode(); });
    send_form.setRsCode = function () {
        $("#rs_code").getOption({//案性代碼
            url: "../ajax/RsCode.aspx",
            data: { branch: "<%#branch%>", cgrs: "GR", rs_class: $("#rs_class").val() },
            valueFormat: "{cust_code}",
            textFormat: "{code_name}",
        });
    }

    //依案性帶處理事項/規費收費標準
    $("#rs_code").change(function () { send_form.setActCode(); });
    send_form.setActCode = function () {
        $("#act_code").getOption({//處理事項
            url: "../ajax/ActCode.aspx",
            data: { branch: "<%#branch%>", cgrs: "GS", rs_class: $("#rs_class").val(), rs_code: $("#rs_code").val() },
            valueFormat: "{cust_code}",
            textFormat: "{code_name}",
        });
        $("#act_code").getOption({//處理事項
            url: "../ajax/ActCode.aspx",
            data: { branch: "<%#branch%>", cgrs: "GS", rs_class: $("#rs_class").val(), rs_code: $("#rs_code").val() },
            valueFormat: "{cust_code}",
            textFormat: "{code_name}",
        });
    }


    //是否輸入評分
    $("input[name='score_flag']").click(function () { send_form.setTabQu(); });
    send_form.setTabQu = function () {
        $("#tabQu").showFor$("input[name='score_flag']:checked").val()=="Y"();
    }
</script>
