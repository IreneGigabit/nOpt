<%@ Page Language="C#" Inherits="PageBase" %>
<%@ Import Namespace = "System.Web.Services"%>
<%@ Import Namespace = "System.Web.Script.Services"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "Saint.Sysctrl"%>
<%@ Import Namespace = "System.Data"%>
<%@ Import Namespace = "Newtonsoft.Json"%>

<script runat="server">
    //protected string StrProjectName = system.getAppSetting("Project");
    //protected string Syscode ="";
    //protected string StrUser = "";
    //protected string SIServer = system.SIServer;//聖島人主機
    //https://www.jianshu.com/p/192552cb6a45
    protected void Page_PreInit(object sender, EventArgs e) {
        //base.LoginChk = false;//不檢查登入,或不要繼承PageBase即可
    }

    private void Page_Load(Object sender, EventArgs e) {
        Response.CacheControl = "Private";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;
       
        this.DataBind();
    }

    //webservice framework須為4.0以上,iis pool也要改成4.0,<system.web> 的節點加入<webServices>...</webServices>內容
    //https://dotblogs.com.tw/kevintan1983/archive/2012/12/26/86013.aspx
    [WebMethod(enableSession: true)]
    [ScriptMethod(UseHttpGet = true, ResponseFormat = ResponseFormat.Json)]
    public static string GetViewData() {
        string NowSyscode = Sys.GetSession("Syscode");
        string ProjectName = Sys.getAppSetting("Project");
        string Scode = Sys.GetSession("scode");
        string ScName = Sys.GetSession("sc_name");
        string LoginGrp = Sys.GetSession("LoginGrp");
        string GrpName = Sys.GetSession("GrpName");
        
        var result = new {
            siServer = Sys.SIServer,
            titleUser = ScName + "/" + LoginGrp,
            projectName = ProjectName,
            nowSyscode = NowSyscode,
            sysList = new SysctrlService().GetUserSystemData(Scode, NowSyscode).ToList(),//下拉選單
            mainMenu = new SysctrlService().GetSystemMenu(NowSyscode, LoginGrp).ToList()//功能選單
        };
        
        //序列化為JSON字串並輸出結果
        return JsonConvert.SerializeObject(result);
    }
</script>

<%--<!DOCTYPE HTML>--%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="x-ua-compatible" content="IE=9">
    <%--<meta name="viewport" content="width=device-width" />--%>
    <title></title>
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
            overflow-x: hidden;
            overflow-y: auto;
            height:100%;
            float: left;
        }
        #main .content {
            margin: 0px;
            height:100%;
        }
        #workframe {
            margin:0px;
            position:relative;
            z-index:0;
            overflow: auto;
            height:100%;
        }
    </style>
</head>
<body style="margin: 0px;">
    <div id="homeapp">
        <table id="toptable" cellspacing="0" cellpadding="0" width="100%" border="0" style="background-color: #fff;">
            <tr>
                <td>
                    <div style="width:20px;float:left">&nbsp;
                        <!--img id="imgSide" style="cursor: pointer" alt="" src="images/x-2.gif" width="13" height="13"-->
                    </div>
                    <div style="float:left;background-image: url(images/top/w02.png); background-repeat: no-repeat;background-size:contain; padding-left: 65px;line-height:20px;">
                        {{projectName}}　　　　　
                        <img class="headImg" onclick="javascript:gosite('list')" style="cursor:pointer;" title="回系統首頁" alt="回系統首頁" border="0" src="images/top/head05-list.gif">
                        <img class="headImg" onclick="javascript:gosite('menu')" style="cursor:pointer;" title="回主功能表" alt="回主功能表" border="0" src="images/top/head05-menu.gif">
                        <img class="headImg" onclick="javascript:gosite('home')" style="cursor:pointer;" title="登出回首頁" alt="登出回首頁" border="0" src="images/top/head05-home.gif">
                    </div>
                    <div style="float:right">
                        {{titleUser}}<img src="images/top/go-1.gif">
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
                <li v-for="main in mainMenu" class="apcat">
                  <a href='javascript:void(0)'>{{ main.APcatCName }}</a>
                    <ul v-bind:style="{ width: main.CatLength + 'px' }">
                        <li v-for="(sub,idx) in main.submenu">
                            <a v-bind:class="[(sub.GrpNum == 1&& idx!=0) ? 'bar' : '']" v-bind:href="'/'+sub.APpath + 'x?prgname=' + sub.APnameC+sub.Remark" target='Etop'>
                                {{sub.APnameC}}
                            </a>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
        <div id="bottom">
            <div id="left">
                <div class="content"></div>
            </div>
            <div id="main">
                <div class="content">
		            <iframe name="workframe" id="workframe" frameborder="0" src="mainFrame.aspx"></iframe>
                </div>
            </div>
        </div>
    </div>
    <form method="post" name="reg" id="reg" target="_top">
    <input type="hidden" name="syscode" value="">
    <input type="hidden" name="tfx_scode" value="<%=Session["scode"]%>">
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

var app = new Vue({
    el: '#homeapp',
    data: {
        siServer:"",//聖島人主機
        titleUser: "",//目前使用者/群組
        projectName:"",//系統名稱
        nowSyscode: "",//目前系統
        sysList: [],//系統下拉選單
        mainMenu: []//作業選單
    },
    created: function () {
        var self = this;
        showBlockUI("");
        ajaxByGet('Default.aspx/GetViewData', {})
        .success(function (rtn) {
            var Result = $.parseJSON(rtn.d)//JSON.parse(rtn.d)//webservice會多帶d
            document.title = Result.projectName;
            self.siServer = Result.siServer;
            self.titleUser = Result.titleUser;
            self.projectName = Result.projectName;
            self.sysList = Result.sysList;
            self.mainMenu = Result.mainMenu;
            //$.each(Result.sysList, function (i, item) {
            //    console.log(item.sysserver, item.syspath, item.sysnameC, item.syscode);
            //})
            $.unblockUI();
        })
        .error(function (error) {
            $.unblockUI();
            alert(error.status + "\n" + error.responseJSON.Message + "\n" + error.responseJSON.StackTrace);
        });
    },
    updated:function(){
        setIframe();
    },
    methods: {
        goWeb: function (e) {
            var element = $(e.target);
            var syspath = element.val();
            var syscode = $('option:selected', element).attr('value1');
            window.top.location.href = "http://" + syspath + "/checklogin.asp?tfx_scode=<%#Session["scode"]%>&sys_pwd=<%#Session["SeSysPwd"]%>&syscode=" + syscode;
        }
    }
});

$(function () {
    //框架大小
    setIframe();
    changeSide();
    //$("#workframe").css("height", '70%');
    //$("#eBlank").css("height", '30%');

    $(window).resize(function () { setIframe(); changeSide() });
    //標題按鈕
    $(".headImg").mouseover(function(e) { $(this).css("background-color","#ffffcc") });
    $(".headImg").mouseout(function (e) { $(this).css("background-color", "#ffffff") });
    //側邊欄
    $("#imgSide").click(function () {
        sideClosed = !sideClosed;;
        changeSide();
    });
    //下拉控制
    $(document).on("mouseover", ".apcat ul",function (e) { $(this).show(); });
    $(document).on("mouseout", ".apcat ul",function (e) { $(this).hide(); });
    $(document).on("click", ".apcat", function () {
        $(".apcat ul").hide();
        $("ul", $(this)).show();
    });
});
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
        $("#eBlank").css("width", (mainWidth) + 'px');
    } else {
        $("#imgSide").attr("src", "images/x-2.gif");

        $('#left').css("width", "200px");
        var mainWidth = $(window).width();
        $("#main").css("width", (mainWidth - 200) + 'px');
        $("#workframe").css("width", (mainWidth - 200) + 'px');
        $("#eBlank").css("width", (mainWidth - 200) + 'px');
    }
}
function gosite(pType){
    switch (pType){
        case "list"://回系統首頁
            reg.action = "default.aspx";
            reg.submit();
            break;
        case "menu"://回主功能表(各系統清單)
            reg.action = "http://"+app.siServer+"/system/sys_main.asp";
            reg.submit();
            break;
        case "home"://聖島人
            reg.action = "http://" + app.siServer;
            reg.submit();
            break;
    }
}
</script>
