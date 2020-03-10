<%@ Control Language="C#" Classname="attent_form" %>

<script runat="server">
    protected string prgid = HttpContext.Current.Request["prgid"];//功能權限代碼
    protected string SQL = "";

    protected string branch = "";
    protected string opt_sqlno = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";

        this.DataBind();
    }
</script>

<table border="0" class="bluetable" cellspacing="1" cellpadding="2" style="font-size: 9pt" width="100%">
	<TR>
		<td class="lightbluetable" align="right">客戶編號：</td>
		<td class="whitetablebg" colspan=3>
		<input TYPE="text" id="tfy_cust_area" name="tfy_cust_area" SIZE="1" class="Lock">-
		<input TYPE="text" id="tfy_cust_seq" name="tfy_cust_seq" size="8" class="Lock"></td>
	</TR>
	<TR>
		<td class="lightbluetable" align="right">聯絡人：</td>
		<td class="whitetablebg">
            <select id=tfy_att_sql name=tfy_att_sql class="Lock"></select>
        </td>
		<TD class=lightbluetable align=right>所屬部門：</TD>
		<TD class=whitetablebg><INPUT TYPE=text id=dept name=dept class="Lock"></TD>
	</TR>
	<TR>
		<TD class=lightbluetable align=right>職稱：</TD>
		<TD class=whitetablebg><INPUT TYPE=text id=att_title SIZE=11 MAXLENGTH=10 class="Lock"></TD>		
		<TD class=lightbluetable align=right>聯絡部門：</TD>
		<TD class=whitetablebg><INPUT TYPE=text id=att_dept SIZE=22 MAXLENGTH=20 class="Lock"></TD>
	</TR>
	<TR>
		<TD class=lightbluetable align=right>聯絡電話：</TD>
		<TD class=whitetablebg colspan=3>
            (<INPUT TYPE=text id=att_tel0 name=att_tel0 SIZE=4 MAXLENGTH=4 class="Lock" />)
		    <INPUT TYPE=text id=att_tel SIZE=16 MAXLENGTH=15 class="Lock">-<INPUT TYPE=text id=att_tel1 SIZE=5 MAXLENGTH=5 class="Lock">
		</TD>
	</TR>
	<TR>
		<TD class=lightbluetable align=right>行動電話：</TD>
		<TD class=whitetablebg><INPUT TYPE=text id=att_mobile SIZE=11 MAXLENGTH=10 class="Lock"></TD>		
		<TD class=lightbluetable align=right>傳真號碼：</TD>
		<TD class=whitetablebg><INPUT TYPE=text id=att_fax SIZE=16 MAXLENGTH=15 class="Lock"></TD>
	</TR>
	<TR>
		<TD class=lightbluetable align=right>聯絡地址：</TD>
		<TD class=whitetablebg colspan=3>
		    <INPUT TYPE=text id=att_zip SIZE=5 MAXLENGTH=5 class="Lock">
		    <INPUT TYPE=text id=att_addr1 SIZE=33 MAXLENGTH=30 class="Lock">
		    <INPUT TYPE=text id=att_addr2 SIZE=33 MAXLENGTH=30 class="Lock">
		</TD>
	</TR>
	<TR>
		<TD class=lightbluetable align=right>電子郵件：</TD>
		<TD class=whitetablebg colspan=3><INPUT TYPE=text id=Att_email SIZE=44 MAXLENGTH=40 class="Lock"></TD>
	</TR>
	<TR>
		<TD class=lightbluetable align=right>郵寄雜誌：</TD>
		<TD class=whitetablebg colspan=3><INPUT TYPE=text id=att_mag size=22 class="Lock"></TD>				  
	</TR>		
</table>
<script language="javascript" type="text/javascript">
    var attent = {};
    attent.init = function () {
        $("#tfy_att_sql").getOption({//聯絡人
            url: getRootPath() + "/AJAX/DmtData.aspx",
            data: { type: "brattlist", branch: "<%#branch%>", opt_sqlno: "<%#opt_sqlno%>" },
            valueFormat: "{att_sql}",
            textFormat: "{att_sql}---{attention}"
        });

        $.ajax({
            type: "get",
            url: getRootPath() + "/AJAX/DmtData.aspx?type=bratt&branch=<%#branch%>&opt_sqlno=<%#opt_sqlno%>",
            async: false,
            cache: false,
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                if (JSONdata.length == 0) {
                    toastr.warning("無聯絡人資料可載入！");
                    return false;
                }
                var j = JSONdata[0];
                $("#tfy_cust_area").val(j.cust_area);
                $("#tfy_cust_seq").val(j.cust_seq);
                $("#tfy_att_sql").val(j.att_sql);
                $("#dept").val(j.deptnm);
                $("#att_title").val(j.att_title);
                $("#att_dept").val(j.att_dept);
                $("#att_tel0").val(j.att_tel0);
                $("#att_tel").val(j.att_tel);
                $("#att_tel1").val(j.att_tel1);
                $("#att_mobile").val(j.att_mobile);
                $("#att_fax").val(j.att_fax);
                $("#att_zip").val(j.att_zip);
                $("#att_addr1").val(j.att_addr1);
                $("#att_addr2").val(j.att_addr2);
                $("#Att_email").val(j.att_email);
                $("#att_mag").val(j.magnm);
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>資料載入失敗！<BR>點擊顯示詳細訊息</a>"); }
        });
    };
</script>
