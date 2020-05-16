<%@ Control Language="C#" ClassName="ext_send_form" %>

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

<%=Sys.GetAscxPath(this)%>
<table border="0" id=tabSend class="bluetable" cellspacing="1" cellpadding="2" width="100%">		
	<Tr>
		<TD align=center colspan=6 class=lightbluetable1>
            <font color="white">回&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;稿&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;交&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;辦&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;事&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;項</font>
		</TD>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right" nowrap>回稿代碼 :</td>
		<td class="whitetablebg"  align="left" colspan=5>
			<SELECT name="send_code" id="send_code" class="SLock"></SELECT>
		</td>
	</TR>
	<TR>
		<td class="lightbluetable"  align="right" nowrap>回稿說明 :</td>
		<td class="whitetablebg"  align="left" colspan=5>
			<textarea ROWS="6" style="width:90%" id=send_remark name="send_remark" class="SLock"></textarea>
		</td>
	</TR>
</table>

<script language="javascript" type="text/javascript">
    var send_form = {};
    send_form.init = function () {
        $("#send_code").getOption({//回稿代碼
            url: getRootPath() + "/ajax/JsonGetSqlData.aspx",
            data: { branch: "<%#branch%>", sql: "Select tf_code,tf_name from tfcode_opt where tf_class='send_br' order by tf_code" },
            valueFormat: "{tf_code}",
            textFormat: "{tf_name}"
        });

        send_form.loadOpt();
    }

    send_form.loadOpt = function () {
        var jOpt = br_opte.opte[0];

        $("#send_remark").val(jOpt.send_remark);
    }

    //依回稿代碼帶回稿說明
    $("#send_code").change(function () {
        var searchSql="SELECT  tf_content from tfcode_opt WHERE tf_class='send_br' And tf_code= '" +$(this).val()+ "' ";
        //規費收費標準
        $.ajax({
            type: "get",
            url: getRootPath() + "/ajax/JsonGetSqlData.aspx",
            data: { sql:searchSql},
            async: false,
            cache: false,
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                if (JSONdata.length == 0) {
                    $("#send_remark").val("");
                } else {
                    $("#send_remark").val(JSONdata[0].tf_content);
                }
            },
            error: function () { toastr.error("<a href='" + this.url + "' target='_new'>回稿說明準載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>"); }
        });
    });

</script>
