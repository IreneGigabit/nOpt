<%@ Page Language="C#" %>
<%@ Import Namespace = "System.Web.Services"%>
<%@ Import Namespace = "System.Web.Script.Services"%>
<%@ Import Namespace = "Saint.Sysctrl"%>
<%@ Import Namespace = "System.Data"%>
<%@ Import Namespace = "Newtonsoft.Json"%>

<script runat="server">
    //webservice framework須為4.0以上,iis pool也要改成4.0,<system.web> 的節點加入<webServices>...</webServices>內容
    //https://dotblogs.com.tw/kevintan1983/archive/2012/12/26/86013.aspx
    [WebMethod(enableSession: true)]
    [ScriptMethod(UseHttpGet = true, ResponseFormat = ResponseFormat.Json)]
    public static string GetData() {
        //,'" + system.GetSession("Syscode") + "' nowsyscode
        return "aaa";
        string SQL = @"SELECT A.sysserver,A.syspath AS syspath, A.sysnameC, A.syscode 
	                    FROM sysctrl 
	                    INNER JOIN SYScode A ON sysctrl.syscode = A.syscode
                        WHERE sysctrl.scode = 'm1583'";
        List<Sysctrl> sysList = null;
        using (DBHelper conn = new DBHelper(Conn.Sysctrl)) {
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);
            sysList = dt.Mapping<Sysctrl>();
        }

        var result = new {
            nowSyscode = system.GetSession("Syscode"),
            sysList = from s in sysList select s
        };

        //序列化為JSON字串並輸出結果
        return JsonConvert.SerializeObject(result);
    }
</script>

<script src="js/jquery-1.12.4.min.js"></script>
<script>
    $.ajax({
        url: 'WebService.aspx/GetData',
        //url: 'WebService.asmx/GetData',
        type: "get",
        data: {},
        contentType: "application/json; charset=utf-8",
        success: function (rtn) {
            console.log(rtn);
            alert(rtn);
        },
        error: function () {
            alert("err");
        }
    });
</script>