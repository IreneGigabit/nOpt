<%@ Page Language="C#" %>
<%@ Import Namespace = "System.Web.Services"%>
<%@ Import Namespace = "System.Web.Script.Services"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "Saint.Sysctrl"%>
<%@ Import Namespace = "System.Data"%>
<%@ Import Namespace = "Newtonsoft.Json"%>

<script runat="server">
    protected void Page_PreInit(object sender, EventArgs e) {
        //base.LoginChk = false;//不檢查登入,或不要繼承PageBase即可
    }

    private void Page_Load(Object sender, EventArgs e) {
        Response.CacheControl = "Private";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        this.DataBind();
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
    <link href="<%=ResolveClientUrl("~/inc/setmenu.css")%>" rel="stylesheet" />
    <link href="<%=ResolveClientUrl("~/inc/setstyle.css")%>" rel="stylesheet" />
    <script src="<%=ResolveClientUrl("~/js/lib/jquery-1.12.4.min.js")%>"></script>
    <script src="<%=ResolveClientUrl("~/js/lib/vue.min.js")%>"></script>
    <script src="<%=ResolveClientUrl("~/js/lib/jquery.blockUI.js")%>"></script>
    <script src="<%=ResolveClientUrl("~/js/util.js")%>"></script>
    <script src="<%=ResolveClientUrl("~/js/app/services/employeeService.js")%>"></script>
    <script src="<%=ResolveClientUrl("~/js/app/component/employeeComponent.js")%>"></script>
</head>
<body style="margin: 0px;">
    <div id="app">
         <div id="menu" style="z-index:99">
            <div style="width:20px;float:left;height:20px;">
                <span style="display: inline-block;height:100%;"></span>
                <img id="imgSide" style="cursor: pointer;" alt="" src="images/x-2.gif" height="15">
            </div>
            <ul>
                <li class="apcat">
                  <a href='javascript:void(0)'>xxxxx</a>
                    <ul >
                        <li >
                            <a target='workframe'>
                                {sub.APnameC}
                            </a>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>

        <input type="type" name="name" v-model="name" />
        <input type="button" value="add" v-on:click="add" />
        {{name}}
        <ul>
            <li v-for="item in employees" :key="item.id">
                <input type="button" :value="'remove編號'+item.id" @click="remove(item)" />
                <employee :item="item"></employee> <%--這裡改成使用component的方式--%>
            </li>
        </ul>
    </div>
</body>
</html>

<script language="javascript" type="text/javascript">
var app = new Vue({
    el: '#app',
    data: {
        name:'hello world',
        employees:employeeService.get()//[{ id: 1, name: 'anson' },{ id: 2, name: 'jacky' }]
    },
    methods:{
        add:function(){
            var maxId=this.employees.length+1;
            var employee={
                id:maxId,
                name:this.name
            }
            this.employees.push(employee);
            this.name=null;
        },
        remove:function(ritem){
            //this.employees = this.employees.filter(x=>x !== item);
            this.employees = this.employees.filter(function(item, index, array){
                return item!== ritem;
            });
        }
    }
    /*,
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
            //console.log(self.mainMenu);
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
            window.top.location.href = "http://" + syspath + "/checklogin.asp?tfx_scode=<%#Session["SeScode"]%>&sys_pwd=<%#Session["SeSysPwd"]%>&syscode=" + syscode;
        }
    }*/
});
</script>