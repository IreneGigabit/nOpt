<%@ Page Language="C#" Inherits="PageBase" %>
<%@ Import Namespace = "System.Web.Services"%>
<%@ Import Namespace = "System.Web.Script.Services"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "Saint.Sysctrl"%>
<%@ Import Namespace = "System.Data"%>
<%@ Import Namespace = "Newtonsoft.Json"%>

<script runat="server">
    protected string StrProjectName = system.getAppSetting("Project");
    protected string Syscode ="";
    protected string StrUser = "";
    protected string StrMenus = "";
    protected string SIServer = "sin32";//聖島人主機
    protected string SystemList = "";//使用者其他系統選項

    protected void Page_PreInit(object sender, EventArgs e) {
        //base.LoginChk = false;//不檢查登入,或不要繼承PageBase即可
    }

    private void Page_Load(Object sender, EventArgs e) {
        Response.CacheControl = "Private";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;
        
        switch (Request.ServerVariables["HTTP_HOST"].ToString().ToLower().Substring(0, 1)) {
            case "w":
            case "b":
            case "l":
                SIServer = Request.ServerVariables["HTTP_HOST"];
                break;
        }
        CareteMenu();
        this.DataBind();
    }

    //webservice framework須為4.0以上,iis pool也要改成4.0,<system.web> 的節點加入<webServices>...</webServices>內容
    //https://dotblogs.com.tw/kevintan1983/archive/2012/12/26/86013.aspx
    [WebMethod(enableSession: true)]
    [ScriptMethod(UseHttpGet = true, ResponseFormat = ResponseFormat.Json)]
    public static string GetUserSystem() {
        string nowSyscode = system.GetSession("Syscode");
        string Scode = system.GetSession("SeScode");
        
        /*
        List<SYScode> sysList = new SysctrlService().GetUserSystemData(Scode).ToList();
        var result = new {
            nowSyscode = nowSyscode,
            sysList = sysList.Where(x=>x.syscode!=nowSyscode)
        };

        //序列化為JSON字串並輸出結果
        return JsonConvert.SerializeObject(result);
        */
        return "";
    }
    /*
        [WebMethod(enableSession: true)]
        [ScriptMethod(UseHttpGet = true, ResponseFormat = ResponseFormat.Json)]
        public static string GetUserSystem() {
            string SQL = @"SELECT A.sysserver,A.syspath AS syspath, A.sysnameC, A.syscode 
                         FROM sysctrl 
                         INNER JOIN SYScode A ON sysctrl.syscode = A.syscode
                            WHERE sysctrl.scode = '"+system.GetSession("SeScode")+"'";
            List<SYScode> sysList = null;
            using (DBHelper conn = new DBHelper(Conn.Sysctrl)) {
                DataTable dt = new DataTable();
                conn.DataTable(SQL, dt);
                sysList = dt.Mapping<SYScode>();
            }

            var result = new {
                nowSyscode = system.GetSession("Syscode"),
                sysList = from s in sysList select s
            };

            //序列化為JSON字串並輸出結果
            return JsonConvert.SerializeObject(result);
       }
    */

    private void CareteMenu() {
        if (Convert.ToBoolean(Session["Password"])) {
            StrUser = Session["sc_name"].ToString() + "/" + Session["GrpName"].ToString();

            SqlConnection cnn = new SqlConnection(Conn.Sysctrl);
            string SQL = "select distinct c.APseq,c.APcatCName, c.APCatID, max(DATALENGTH(a.apnamec))maxbyte " +
                     " FROM AP AS a" +
                     " INNER JOIN LoginAP AS b ON a.APcode = b.APcode AND a.SYScode = b.SYScode" +
                     " INNER JOIN APcat AS c ON a.APcat = c.APcatID AND a.SYScode = c.SYScode " +
                     " WHERE b.LoginGrp = '" + Session["LoginGrp"].ToString() + "'" +//BTBRTADMIN
                     " AND b.SYScode = '" + Session["Syscode"].ToString() + "'" +//NBRP
                     " AND (b.Rights & 1) > 0 " +
                     " GROUP BY c.APseq,c.APcatCName, c.APCatID " +
                     " ORDER BY c.APseq";

            //Response.Write(SQL + "<br/><br/>");
            SqlCommand cmd = new SqlCommand(SQL, cnn);
            cnn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            StrMenus="";
            while (dr.Read()) {
                StrMenus += "<li class='apcat'>";
                StrMenus += "<a href='javascript:void(0)'>" + dr["APcatCName"] + "</a>";

                SQL = "select row_number() OVER( PARTITION BY c.APseq,substring(a.APorder,1,1) ORDER BY a.APorder, a.APcode) AS GROUPNUM " +
                 ", a.APcode, a.APnameC, a.APorder, a.APserver, a.APpath, a.ReMark " +
                 ", b.LoginGrp, b.Rights" +
                 ", c.APcatCName, c.APCatID" +
                 " FROM AP AS a" +
                 " INNER JOIN LoginAP AS b ON a.APcode = b.APcode AND a.SYScode = b.SYScode" +
                 " INNER JOIN APcat AS c ON a.APcat = c.APcatID AND a.SYScode = c.SYScode " +
                 " WHERE b.LoginGrp = '" + Session["LoginGrp"].ToString() + "'" +//BTBRTADMIN
                 " AND b.SYScode = '" + Session["Syscode"].ToString() + "'" +//NBRP
                 " AND (b.Rights & 1) > 0 " +
                 " AND c.APCatID='" + dr["APCatID"] + "' " +
                 " ORDER BY c.APseq, a.APorder, a.APcode";
                //Response.Write(SQL + "<HR>");

                SqlConnection cnn1 = new SqlConnection(Conn.Sysctrl);
                SqlCommand cmd1 = new SqlCommand(SQL, cnn1);
                cnn1.Open();
                SqlDataReader dr1 = cmd1.ExecuteReader();

                if (dr1.HasRows) {
                    StrMenus += "<ul style='width:" + (Convert.ToInt32(dr["maxbyte"])*7.2) + "px;'>\n";
                    int i = 0;
                    while (dr1.Read()) {
                        bool bar = (i != 0 && dr1["GROUPNUM"].ToString() == "1") ? true : false;
                        StrMenus += "<li >\n";
                        string barclass = bar ? "class='bar'" : "";
                        //StrMenus += "<a href='/" + dr1["APpath"] + "?prgid=" + dr1["APcode"] + "&prgname=" + dr1["APNameC"] + dr1["ReMark"] + "'>" + dr1["APNameC"] + "</a>\n";
                        //StrMenus += "<a " + barclass + " href='/" + dr1["APpath"] + "?prgid=" + dr1["APcode"] + "&prgname=" + dr1["APNameC"] + dr1["ReMark"] + "' target='workframe'>" + dr1["APNameC"] + "</a>\n";
                        StrMenus += "<a " + barclass + " href='/" + dr1["APpath"] + "x?prgname=" + dr1["APNameC"] + dr1["ReMark"] + "' target='workframe'>" + dr1["APNameC"] + "</a>\n";
                        StrMenus += "</li>\n";
                        i++;
                    }
                    StrMenus += "</ul>\n";
                }
                cnn1.Close();

                StrMenus += "</li>";
            }

            dr.Close();
            cnn.Close();



            SQL = "SELECT A.sysserver,A.syspath AS syspath, A.sysnameC, A.syscode ";
            SQL += "FROM sysctrl ";
            SQL += "INNER JOIN SYScode A ON sysctrl.syscode = A.syscode ";
            SQL += "WHERE sysctrl.scode = '" + system.GetSession("SeScode") + "' ";
            SQL += "and sysctrl.syscode<>'" + system.GetSession("Syscode") + "' ";
            using (DBHelper conn = new DBHelper(Conn.Sysctrl)) {
                DataTable dt = new DataTable();
                conn.DataTable(SQL, dt);
                SystemList=dt.Option("{sysserver}{syspath}", "◎{sysnamec}", "", "請選擇其他網路作業系統 ...");
            }
        }
    }

</script>

<%--<!DOCTYPE HTML>--%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="x-ua-compatible" content="IE=9">
    <%--<meta name="viewport" content="width=device-width" />--%>
    <title><%#StrProjectName%></title>
    <link href="inc/setmenu.css" rel="stylesheet" />
    <link href="inc/setstyle.css" rel="stylesheet" />
    <script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="js/vue.min.js"></script>
    <%--<script type="text/javascript"  src="js/json2.js"></script>--%>
    <script type="text/javascript" src="js/jquery.blockUI.js"></script>
    <script type="text/javascript" src="js/util.js"></script>
    <style type="text/css">
        html {
            overflow: hidden;
            /*overflow-y:scroll;*/
        }
        body {
            margin: 0px;
        }
        #bottom{
            position: absolute;
            width: 100%;
            z-index:0;
        }
        #left {
            width: 200px;
            overflow: auto;
            height:100%;
            float: left;
        }
        #main {
            overflow: auto;
            height:100%;
            float: left;
        }
        #main .content {
            margin: 0px;
        }
        #workframe {
            margin:0px;
            position: absolute;
            z-index:0;
            overflow: auto; width: 80%; height: 100%;
        }
    </style>
</head>
<body style="margin: 0px;">
    <table id="toptable" cellspacing="0" cellpadding="0" width="100%" border="0" style="background-color: #fff;">
        <tr>
            <td>
                <div style="width:20px;float:left">&nbsp;
                    <!--img id="imgSide" style="cursor: pointer" alt="" src="images/x-2.gif" width="13" height="13"-->
                </div>
                <div style="float:left;background-image: url(images/top/w02.png); background-repeat: no-repeat;background-size:contain; padding-left: 65px;line-height:20px;">
                    <%#StrProjectName%>　　　　　
                    <img class="headImg" onclick="javascript:gosite('list')" style="cursor:pointer;" title="回系統首頁" alt="回系統首頁" border="0" src="images/top/head05-list.gif">
                    <img class="headImg" onclick="javascript:gosite('menu')" style="cursor:pointer;" title="回主功能表" alt="回主功能表" border="0" src="images/top/head05-menu.gif">
                    <img class="headImg" onclick="javascript:gosite('home')" style="cursor:pointer;" title="登出回首頁" alt="登出回首頁" border="0" src="images/top/head05-home.gif">
                </div>
                <div style="float:right">
                    <%#StrUser%><img src="images/top/go-1.gif">
                    <select size="1" id="goweb0">
                        <%#SystemList%>
                    </select>
                    <select id="goweb" v-on:change="goWeb($event)">
                        <option style="color: darkslateblue" value="">請選擇其他網路作業系統 ...</option>
                        <option v-for="item in sysList" v-bind:value="item.sysserver+item.syspath" v-bind:value1="item.syscode" v-if="item.syscode!=nowSyscode">
                            ◎{{ item.sysnameC }}
                        </option>
                    </select>
                </div>
            </td>
        </tr>
    </table>
    <div id="menu" style="z-index:99">
        <div style="width:20px;float:left;height:20px;">
            <span style="display: inline-block;height:100%;"></span>
            <img id="imgSide" style="cursor: pointer;" alt="" src="images/x-2.gif" height="15">
        </div>
        <ul>
            <%#StrMenus%>
        </ul>
    </div>
    <div id="bottom">
        <div id="left">
            <div class="content"></div>
        </div>
        <div id="main">
            <div class="content">
		        <iframe name="workframe" id="workframe" frameborder="1" src="homelist.aspx"></iframe>
            </div>
        </div>
    </div>
    <form method="post" name="reg" id="reg" target="_top">
    <input type="hidden" name="syscode" value="<%=Syscode%>">
    <input type="hidden" name="tfx_scode" value="<%=Session["SeScode"]%>">
    <input type="hidden" name="sys_pwd" value="<%=Session["SeSysPwd"]%>">
    <input type="hidden" name="toppage" value="<%=Session["SeTopPage"]%>">
    <input type="hidden" name="ctrlleft" value="<%=Request["ctrlleft"]%>">
    <input type="hidden" name="ctrltab" value="<%=Request["ctrltab"]%>">
    <input type="hidden" name="ctrlhomelist" value="<%=Request["ctrlhomelist"]%>">
    <input type="hidden" name="ctrlhomelistshow" value="<%=Request["ctrlhomelistshow"]%>">
    </form>
</body>
</html>

<script language="javascript" type="text/javascript">
var sideClosed = false;
$(function () {
    //框架大小
    setIframe();
    changeSide();
    $(window).resize(function () { setIframe(); changeSide() });
    //下拉控制
    $(".apcat ul").mouseover(function (e) { $(this).show(); });
    $(".apcat ul").mouseout(function (e) { $(this).hide(); });
    $(".apcat").click(function () {
        $(".apcat ul").hide();
        $("ul", $(this)).show();
    });
    //標題按鈕
    $(".headImg").mouseover(function(e) { $(this).css("background-color","#ffffcc") });
    $(".headImg").mouseout(function (e) { $(this).css("background-color", "#ffffff") });
    //側邊欄
    $("#imgSide").click(function () {
        sideClosed = !sideClosed;;
        changeSide();
    });
});
function ParseDate(jsonDate) {
    var date = new Date(parseInt(jsonDate.substr(6)));
    return date.toLocaleString();
}
function setIframe(e) {
    var menuHeight = parseInt($("#menu ul").get(0).offsetHeight);
    var tTableHeight = parseInt($("#toptable").get(0).offsetHeight);
    $("#bottom").css('margin-top', menuHeight - 19);
    $("#bottom").height(($(window).height() - menuHeight - tTableHeight)-3 + 'px');//-14
}
function changeSide(e) {
    if (sideClosed) {
        $("#imgSide").attr("src", "images/x-1.gif");

        $('#left').css("width", "0px");
        var mainWidth = $(window).width();
        $("#main").css("width", (mainWidth) + 'px');
        $("#workframe").css("width", (mainWidth) + 'px');
    } else {
        $("#imgSide").attr("src", "images/x-2.gif");

        $('#left').css("width", "200px");
        var mainWidth = $(window).width();
        $("#main").css("width", (mainWidth - 200) + 'px');
        $("#workframe").css("width", (mainWidth - 200) + 'px');
    }
}
function gosite(pType){
    switch (pType){
        case "list"://回系統首頁
            reg.action = "default.aspx";
            reg.submit();
            break;
        case "menu"://回主功能表(各系統清單)
            reg.action = "http://<%#SIServer%>/system/sys_main.asp";
            reg.submit();
            break;
        case "home"://聖島人
            //reg.action = "http://<%#SIServer%>";
            //reg.submit();
            alert('聖島人');
            break;
    }
}

var app = new Vue({
    el: '#goweb',
    data: {
        nowSyscode: "OPT",    //目前系統
        sysList: []//系統選單
    },
    created: function () {
        var self = this;
        showBlockUI("");
        ajaxByGet('Default.aspx/GetUserSystem', {})
        .success(function (rtn) {
            var Result = $.parseJSON(rtn.d)//JSON.parse(rtn.d)//webservice會多帶d
            self.sysList = Result.sysList;
            //$.each(Result.sysList, function (i, item) {
            //    console.log(item.sysserver, item.syspath, item.sysnameC, item.syscode);
            //})
            $.unblockUI();
        })
        .error(function (error) {
            $.unblockUI();
            alert(error);
        });
        /*
        $.ajax({
            url: 'Default.aspx/GetUserSystem',
            //url: 'WebService.asmx/GetData',
            type: "get",
            data: {},
            contentType: "application/json; charset=utf-8",
            dataType: "json",//回傳json
            success: function (result) {
                jj = $.parseJSON(result.d);//JSON.parse(result.d)//webservice會多帶d
                console.log(jj)
                $.each(jj.sysList, function (i, item) {
                    console.log(item.sysserver);
                    console.log(item.syspath);
                    console.log(item.sysnameC);
                    console.log(item.syscode);
                })
            },
            error: function () {
                alert("err");
            }
        });
        */
    },
    methods: {
        goWeb: function (e) {
            var element = $(e.target);
            var syspath = element.val();
            var syscode = $('option:selected', element).attr('value1');
            window.top.location.href = "http://" + syspath + "/checklogin.asp?tfx_scode=<%#Session["SeScode"]%>&sys_pwd=<%#Session["SeSysPwd"]%>&syscode=" + syscode;
        }
    }
});
</script>