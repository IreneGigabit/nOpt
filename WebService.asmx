<%@ WebService Language="C#" Class="WebService" %>
using System;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json;

// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
// [System.Web.Script.Services.ScriptService]
[ScriptService]
public class WebService : System.Web.Services.WebService
{
    public class Role
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Pic { get; set; }
        public string Conversation { get; set; }
    }

    private static List<Role> RoleLists = new List<Role>{
        new Role{
            ID=1,
            Name="魏延",
            Pic="http://a0.att.hudong.com/87/83/01300000325544123001835921934_s.jpg",
            Conversation="丞相,下一步該怎麼作?"
        },
        new Role{
            ID=2,
            Name="諸葛亮",
            Pic="http://a1.att.hudong.com/31/77/01300000330120123114771755517.jpg",
            Conversation="..........東風起..."
        }
    };

    [WebMethod]
    public string HelloWorld(string aa) {
        return "Hello World** "+aa+" **";
    }

    [WebMethod(enableSession: true)]
    [ScriptMethod(UseHttpGet = true)]
    public string GetData() {
        IEnumerable<Role> result= RoleLists.OrderBy(x => x.ID);
        //序列化為JSON字串並輸出結果
        return JsonConvert.SerializeObject(result);
    }

}