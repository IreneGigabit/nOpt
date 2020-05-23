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
        tdate = Request["tdate"]??DateTime.Today.ToShortDateString();

        string json = (Request["json"] ?? "").ToString().ToUpper();
        string type = (Request["type"] ?? "").ToString().ToLower();

        if (json == "Y") {
            var jsonSettings = new JsonSerializerSettings() {
                Formatting = Formatting.None,
                ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
                Converters = new List<JsonConverter> { new DBNullCreationConverter(), new TrimCreationConverter() }//dbnull轉空字串且trim掉
            };

            if (type == "opt") QueryOptData(jsonSettings);
            if (type == "opte") QueryOpteData(jsonSettings);

            Response.End();
        }

        this.DataBind();
    }

    private void QueryOptData(JsonSerializerSettings jsonSettings ) {
        DataTable dt = new DataTable();
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
                SQL = "select * from vbr_opt a ";
                SQL += " where last_date <= '" + Util.str2Dateime(tdate).AddDays(15).ToShortDateString() + "' ";
                SQL += " and (Bstat_code <>'YS' and Bstat_code<>'XX') and confirm_date is not null";
                SQL += " and Bmark='N' ";
                SQL += " order by a.last_date,a.Bseq,a.Bseq1";
                conn.DataTable(SQL, dt);

                Response.Write("{");
                Response.Write("\"auth\":\"Y\"\n");
                Response.Write(",\"opt\":" + JsonConvert.SerializeObject(dt, jsonSettings).ToUnicode() + "\n");
                Response.Write("}");
            }else {
                Response.Write("{");
                Response.Write("\"auth\":\"N\"\n");
                Response.Write(",\"opt\":[]\n");
                Response.Write("}");
            }
        }
    }

    private void QueryOpteData(JsonSerializerSettings jsonSettings ) {
        DataTable dt = new DataTable();
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
                SQL = "select * from vbr_opte a ";
                SQL += " where last_date <= '" + Util.str2Dateime(tdate).AddDays(10).ToShortDateString() + "' ";
                SQL += " and (Bstat_code <>'YY' and Bstat_code<>'YZ') and confirm_date is not null";
                SQL += " and Bmark='N' ";
                SQL += " order by a.last_date,a.Bseq,a.Bseq1";
                conn.DataTable(SQL, dt);

                Response.Write("{");
                Response.Write("\"auth\":\"Y\"\n");
                Response.Write(",\"opt\":" + JsonConvert.SerializeObject(dt, jsonSettings).ToUnicode() + "\n");
                Response.Write("}");
            }else {
                Response.Write("{");
                Response.Write("\"auth\":\"N\"\n");
                Response.Write(",\"opt\":[]\n");
                Response.Write("}");
            }
        }
    }
</script>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf8" />
    <title>今日工作清單</title>
    <link href="inc/setstyle.css" rel="stylesheet" />
    <script type="text/javascript" src="js/lib/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="js/lib/toastr.min.js"></script>
    <script type="text/javascript" src="js/util.js"></script>
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
                <input id="tdate" name="tdate" size=10 onblur="chk_date(reg.tdate)">&nbsp;
            </td>
        </tr>
        </table>
    </form>
    <div id="optList">

    </div>
</body>
</html>


<script type="text/javascript" language="javascript">
    $(function () {
        $("#tdate").val((new Date()).format("yyyy/M/d"));
        goSearch();
    });

    //執行查詢
    function goSearch() {
        $("#divPaging,#noData,#dataList").hide();
        $("#dataList>tbody tr").remove();
        nRow = 0;

        $.ajax({
            url: "leftmenu.aspx?json=Y&type=opt",
            type: "get",
            async: true,
            cache: false,
            data: $("#reg").serialize(),
            success: function (json) {
                var JSONdata = $.parseJSON(json);
                if (JSONdata.length == 0) {
                    $("#optList").append("<br><div align=center size=3 style=\"color:blue\">無使用權限</div>");
                } else {
                    $.each(JSONdata, function (i, item) {
                        nRow++;
                        //複製一筆
                        $("#dataList>tfoot").each(function (i) {
                            var strLine1 = $(this).html().replace(/##/g, nRow);
                            var tclass = "";
                            if (nRow % 2 == 1) tclass = "sfont9"; else tclass = "lightbluetable3";
                            strLine1 = strLine1.replace(/{{tclass}}/g, tclass);
                            strLine1 = strLine1.replace(/{{nRow}}/g, nRow);

                            strLine1 = strLine1.replace(/{{fseq}}/g, item.fseq);
                            strLine1 = strLine1.replace(/{{seq}}/g, item.seq);
                            strLine1 = strLine1.replace(/{{seq1}}/g, item.seq1);
                            strLine1 = strLine1.replace(/{{fext_seq}}/g, item.fext_seq);
                            strLine1 = strLine1.replace(/{{class}}/g, item.fclass);
                            strLine1 = strLine1.replace(/{{appl_name}}/g, item.appl_name);
                            strLine1 = strLine1.replace(/{{your_no}}/g, item.your_no);

                            $("#dataList>tbody").append(strLine1);
                        });
                    });
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                toastr.error("<a href='" + jqXHR.url + "' target='_new'>國內案到期案件資料載入失敗！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
            }
        });
    }
</script>
