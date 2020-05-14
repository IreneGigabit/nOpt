<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "Newtonsoft.Json"%>
<%@ Import Namespace = "Newtonsoft.Json.Linq"%>

<script runat="server">
    protected string HTProgCap = HttpContext.Current.Request["prgname"];//功能名稱
    protected string HTProgPrefix = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string SQL = "";
    protected string json_data = "";
    protected string json = "";

    protected string submitTask = "";
    protected string your_no = "";
    protected string seq = "";
    protected string seq1 = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        submitTask = Request["submitTask"] ?? "";
        your_no = Request["your_no"] ?? "";
        seq = Request["seq"] ?? "";
        seq1 = Request["seq1"] ?? "";
        json = (Request["json"] ?? "").ToString().ToUpper();

        switch (prgid) {
            case "opt65":
                HTProgCap = "爭救案承辦工作量-明細表";
                break;
            case "opt63":
                HTProgCap = "爭救案交辦品質評分表-明細表";
                break;
            default:
                HTProgCap = "爭救案案件查詢-清單";
                break;
        }
    
        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            if (json=="Y") QueryData();
            
            this.DataBind();
        }
    }

    private void QueryData() {
        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(false)) {
            SQL = "select a.*,''fseq,''optap_cname ";
            SQL += "from vbr_opt a ";
            SQL += "where (a.Bstat_code like 'NN%' or a.Bstat_code like 'NX%') and Bmark='N' ";

            if ((Request["qryPr_scode"] ?? "") != "") {
                SQL += " and a.Pr_scode='" + Request["qryPr_scode"] + "'";
            }
            if ((Request["qryopt_no"] ?? "") != "") {
                SQL += " and a.Opt_no='" + Request["qryopt_no"] + "'";
            }
            if ((Request["qryBranch"] ?? "") != "") {
                SQL += " and a.Branch='" + Request["qryBranch"] + "'";
            }
            if ((Request["qryBSeq"] ?? "") != "") {
                SQL += " and a.Bseq='" + Request["qryBSeq"] + "'";
            }
            if ((Request["qryBSeq1"] ?? "") != "") {
                SQL += " and a.Bseq1='" + Request["qryBSeq1"] + "'";
            }

            if ((Request["SetOrder"] ?? "") != "") {
                SQL += " order by a.pr_scode," + Request["SetOrder"];
            } else {
                SQL += " order by a.pr_scode,a.BSEQ";
            }
    
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            //處理分頁
            int nowPage = Convert.ToInt32(Request["GoPage"] ?? "1"); //第幾頁
            int PerPageSize = Convert.ToInt32(Request["PerPage"] ?? "10"); //每頁筆數
            Paging page = new Paging(nowPage, PerPageSize, string.Join(";", conn.exeSQL.ToArray()));
            page.GetPagedTable(dt);

            //分頁完再處理其他資料才不會虛耗資源
            for (int i = 0; i < page.pagedTable.Rows.Count; i++) {
                //組本所編號
                page.pagedTable.Rows[i]["fseq"] = Funcs.formatSeq(
                    page.pagedTable.Rows[i].SafeRead("Bseq", "")
                    , page.pagedTable.Rows[i].SafeRead("Bseq1", "")
                    , ""
                    , page.pagedTable.Rows[i].SafeRead("Branch", "")
                    , Sys.GetSession("dept"));

                SQL = "select ap_cname from caseopt_ap where opt_sqlno=" + page.pagedTable.Rows[i].SafeRead("opt_sqlno", "");
                string ap_cname = "";
                using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                    while (dr.Read()) {
                        ap_cname += (ap_cname != "" ? "、" : "") + dr.SafeRead("ap_cname", "").Trim();
                    }
                }

                //申請人
                page.pagedTable.Rows[i]["optap_cname"] = ap_cname.CutData(20);
                //案件名稱
                page.pagedTable.Rows[i]["appl_name"] = page.pagedTable.Rows[i].SafeRead("appl_name", "").CutData(20);
            }

            var settings = new JsonSerializerSettings()
            {
                Formatting = Formatting.None,
                ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
                Converters = new List<JsonConverter> { new DBNullCreationConverter(), new TrimCreationConverter() }//dbnull轉空字串且trim掉
            };

            Response.Write(JsonConvert.SerializeObject(page, settings).ToUnicode());
            Response.End();
            //return JsonConvert.SerializeObject(dt, settings).ToUnicode().Replace("\\", "\\\\").Replace("\"", "\\\"");
        }
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
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
</head>

<body>
<table cellspacing="1" cellpadding="0" width="98%" border="0">
    <tr>
        <td class="text9" nowrap="nowrap">&nbsp;【<%=prgid%> <%=HTProgCap%>】</td>
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
    <input type="hidden" id="prgid" name="prgid" value="<%=prgid%>">
    <input type="hidden" id="submittask" name="submittask" value="<%=submitTask%>">
    <input type="hidden" id="your_no" name="your_no" value="<%=your_no%>">
    <input type="hidden" id="seq" name="seq" value="<%=seq%>">
    <input type="hidden" id="seq1" name="seq1" value="<%=seq1%>">
    <label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>

    <div id="divPaging" style="display:none">
    <TABLE border=0 cellspacing=1 cellpadding=0 width="98%" align="center">
	    <tr>
		    <td colspan=2 align=center class=whitetablebg>
			    <font size="2" color="#3f8eba">
				    第<font color="red"><span id="NowPage"></span>/<span id="TotPage"></span></font>頁
				    | 資料共<font color="red"><span id="TotRec"></span></font>筆
				    | 跳至第
				    <select id="GoPage" name="GoPage" style="color:#FF0000"></select>
				    頁
				    <span id="PageUp">| <a href="javascript:void(0)" class="pgU" v1="">上一頁</a></span>
				    <span id="PageDown">| <a href="javascript:void(0)" class="pgD" v1="">下一頁</a></span>
				    | 每頁筆數:
				    <select id="PerPage" name="PerPage" style="color:#FF0000">
					    <option value="10" selected>10</option>
					    <option value="20">20</option>
					    <option value="30">30</option>
					    <option value="50">50</option>
				    </select>
                    <input type="hidden" name="SetOrder" id="SetOrder" />
			    </font>
		    </td>
	    </tr>
    </TABLE>
    </div>
</form>

<div align="center" id="noData" style="display:none">
	<font color="red">=== 目前無資料 ===</font>
</div>

<table style="display:" border="0" class="bluetable" cellspacing="1" cellpadding="2" width="98%" align="center" id="dataList">
	<thead>
        <Tr>
	        <td class="lightbluetable" nowrap align="center" rowspan="2"><u class="setOdr" v1="bseq,bseq1">區所編號</u></td>
	        <td class="lightbluetable" nowrap align="center" rowspan="2">申請人</td> 
	        <td class="lightbluetable" nowrap align="center" rowspan="2">註冊號</td> 
	        <td class="lightbluetable" nowrap align="center" rowspan="2">案件名稱</td> 
	        <td class="lightbluetable" nowrap align="center"><u class="setOdr" v1="Confirm_date">收文日</u></td>
	        <td class="lightbluetable" nowrap align="center"><u class="setOdr" v1="last_date">法定期限</u></td>
	        <td class="lightbluetable" nowrap align="center">案性</td> 
	        <td class="lightbluetable" nowrap align="center" rowspan="2">承辦人</td> 
	        <td class="lightbluetable" nowrap align="center" rowspan="2">承辦狀態</td> 
        </tr>
        <Tr>
	        <td class="lightbluetable" nowrap align="center"><u class="setOdr" v1="Bpr_date">完成日期</u></td>
	        <td class="lightbluetable" nowrap align="center"><u class="setOdr" v1="ap_date">判行日期</u></td>
	        <td class="lightbluetable" nowrap align="center"><u class="setOdr" v1="gs_date">發文日</u></td>
        </tr>
	</thead>
	<tfoot style="display:none">
	    <tr class='{{tclass}}'>
		    <td rowspan="2" align="center">{{fseq}}</td>
		    <td rowspan="2">{{ap_cname}}</td>
		    <td rowspan="2">{{issue_no}}</td>
		    <td rowspan="2">{{appl_name}}</td>
		    <td align="center">{{confirm_date}}</td>
		    <td align="center">{{last_date}}</td>
		    <td nowrap>{{arcase_name}}</td>
		    <td rowspan="2" align="center">{{pr_scode_name}}</td>
		    <td rowspan="2" align="center">{{code_name}}</td>
        </tr>
        <Tr class='{{tclass}}'>
		    <td align="center">{{bpr_date}}</td>
		    <td align="center">{{ap_date}}</td>
		    <td align="center">{{gs_date}}</td>
	    </Tr>
	</tfoot>
	<tbody>
	</tbody>
</table>
<br />
</body>
</html>

<script language="javascript" type="text/javascript">
    $(function () {
        $("#labTest").showFor((<%#HTProgRight%> & 256)).find("input").prop("checked",false).triggerHandler("click");//☑測試

        this_init();
    });

    //初始化
    function this_init() {
        if (!(window.parent.tt === undefined)) {
            if ($("submittask").val() == "Q") {
                window.parent.tt.rows = "30%,70%";
            } else {
                window.parent.tt.rows = "0%,100%";
            }
        }

        goSearch();
    }

    //執行查詢
    function goSearch() {
        $("#divPaging,#noData,#dataList").hide();
        $("#dataList>tbody tr").remove();
        nRow = 0;

        $.ajax({
            url: "opt62_list.aspx?json=Y",
            type: "get",
            async: false,
            cache: false,
            data: $("#reg").serialize(),
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                if (JSONdata.totrow === undefined) {
                    toastr.error("資料載入失敗（" + JSONdata.msg + "）");
                    return false;
                }
                if ($("#chkTest").prop("checked")) toastr.info("<a href='" + this.url + "' target='_new'>Debug！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
                //////更新分頁變數
                var totRow = parseInt(JSONdata.totrow, 10);
                if (totRow > 0) {
                    $("#divPaging").show();
                    $("#dataList").show();
                } else {
                    $("#noData").show();
                }

                var nowPage = parseInt(JSONdata.nowpage, 10);
                var totPage = parseInt(JSONdata.totpage, 10);
                $("#NowPage").html(nowPage);
                $("#TotPage").html(totPage);
                $("#TotRec").html(totRow);
                var i = totPage + 1, option = new Array(i);
                while (--i) {
                    option[i] = ['<option value="' + i + '">' + i + '</option>'].join("");
                }
                $("#GoPage").replaceWith('<select id="GoPage" name="GoPage" style="color:#FF0000">' + option.join("") + '</select>');
                $("#GoPage").val(nowPage);
                nowPage > 1 ? $("#PageUp").show() : $("#PageUp").hide();
                nowPage < totPage ? $("#PageDown").show() : $("#PageDown").hide();
                $("a.pgU").attr("v1", nowPage - 1);
                $("a.pgD").attr("v1", nowPage + 1);
                //$("#id-div-slide").slideUp("fast");

                $.each(JSONdata.pagedtable, function (i, item) {
                    nRow++;
                    //複製一筆
                    $("#dataList>tfoot").each(function (i) {
                        var strLine1 = $(this).html().replace(/##/g, nRow);
                        var tclass = "";
                        if (nRow % 2 == 1) tclass = "sfont9"; else tclass = "lightbluetable3";
                        strLine1 = strLine1.replace(/{{tclass}}/g, tclass);
                        strLine1 = strLine1.replace(/{{nRow}}/g, nRow);

                        strLine1 = strLine1.replace(/{{opt_no}}/g, item.opt_no);
                        strLine1 = strLine1.replace(/{{fseq}}/g, item.fseq);
                        strLine1 = strLine1.replace(/{{ap_cname}}/g, item.optap_cname);
                        strLine1 = strLine1.replace(/{{issue_no}}/g, item.issue_no);
                        strLine1 = strLine1.replace(/{{appl_name}}/g, item.appl_name);
                        strLine1 = strLine1.replace(/{{confirm_date}}/g, dateReviver(item.confirm_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{last_date}}/g, dateReviver(item.last_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{arcase_name}}/g, item.arcase_name);
                        strLine1 = strLine1.replace(/{{pr_scode_name}}/g, item.pr_scode_name);
                        strLine1 = strLine1.replace(/{{code_name}}/g, item.code_name);
                        strLine1 = strLine1.replace(/{{bpr_date}}/g, dateReviver(item.bpr_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{ap_date}}/g, dateReviver(item.ap_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{gs_date}}/g, dateReviver(item.gs_date, "yyyy/M/d"));

                        strLine1 = strLine1.replace(/{{opt_in_date}}/g, dateReviver(item.opt_in_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{ctrl_date}}/g, dateReviver(item.ctrl_date, "yyyy/M/d"));
                        strLine1 = strLine1.replace(/{{opt_sqlno}}/g, item.opt_sqlno);
                        strLine1 = strLine1.replace(/{{Case_no}}/g, item.case_no);
                        strLine1 = strLine1.replace(/{{Branch}}/g, item.branch);
                        strLine1 = strLine1.replace(/{{arcase}}/g, item.arcase);
                        strLine1 = strLine1.replace(/{{scode_name}}/g, item.scode_name);

                        var urlasp = "";
                        if (item.case_no != "") {
                            urlasp = "../opt2m/opt22Edit.aspx?opt_sqlno=" + item.opt_sqlno + "&opt_no=" + item.opt_no + "&branch=" + item.branch + "&case_no=" + item.case_no + "&arcase=" + item.arcase + "&prgid=" + $("#prgid").val() + "&Submittask=Q"
                        } else {
                            urlasp = "../opt2m/opt22EditA.aspx?opt_sqlno=" + item.opt_sqlno + "&opt_no=" + item.opt_no + "&branch=" + item.branch + "&arcase=" + item.arcase + "&prgid=" + $("#prgid").val() + "&Submittask=Q"
                        }
                        strLine1 = strLine1.replace(/{{urlasp}}/g, urlasp);

                        $("#dataList>tbody").append(strLine1);
                    });
                });
            },
            beforeSend: function (jqXHR, settings) {
                jqXHR.url = settings.url;
                //toastr.info("<a href='" + jqXHR.url + "' target='_new'>debug！\n" + jqXHR.url + "</a>");
            },
            error: function (jqXHR, textStatus, errorThrown) {
                toastr.error("<a href='" + jqXHR.url + "' target='_new'>資料擷取剖析錯誤！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
            }
        });
    };

    //每頁幾筆
    $("#PerPage").change(function (e) {
        goSearch();
    });
    //指定第幾頁
    $("#divPaging").on("change", "#GoPage", function (e) {
        goSearch();
    });
    //上下頁
    $(".pgU,.pgD").click(function (e) {
        $("#GoPage").val($(this).attr("v1"));
        goSearch();
    });
    //排序
    $(".setOdr").click(function (e) {
        $("#dataList>thead tr .setOdr span").remove();
        $(this).append("<span>▲</span>");
        $("#SetOrder").val($(this).attr("v1"));
        goSearch();
    });
    //關閉視窗
    $(".imgCls").click(function (e) {
        if (!(window.parent.tt === undefined)) {
            window.parent.tt.rows = "100%,0%";
        } else {
            window.close();
        }
    })
</script>
