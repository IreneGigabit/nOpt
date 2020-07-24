<%@ WebHandler Language="C#" Class="UpLoaded" %>

using System;
using System.Web;
using System.IO;
using System.Collections.Generic;

public class UpLoaded : IHttpHandler
{

    public void ProcessRequest(HttpContext context) {
        string QueryString = context.Request.ServerVariables["QUERY_STRING"];
        Dictionary<string, string> ReqVal = Util.GetRequestParam(context, context.Request["chkTest"] == "TEST");

        HttpPostedFile uploadedFile = context.Request.Files[0];
        string FName = uploadedFile.FileName;               //使用者端目錄+檔案名稱
        string dd = System.IO.Path.GetFileNameWithoutExtension(FName);      //原檔名(不含Ext)
        string sExt = System.IO.Path.GetExtension(FName);   //副檔名
        int attach_size = uploadedFile.ContentLength;       //檔案大小(bytes)

        string file_path = context.Server.MapPath("~/opt_file/");//指定儲存路徑
        ////context.Response.ContentType = "text/plain";
        //context.Response.StatusCode = (int)System.Net.HttpStatusCode.InternalServerError;
        //context.Response.Write("<BR>" + file_path);
        //context.Response.Write("<BR>" + uploadedFile.FileName);
        //context.Response.End();
        if (!System.IO.Directory.Exists(file_path)) {
            System.IO.Directory.CreateDirectory(file_path);//如果不存在就建立file資料夾
        }

        uploadedFile.SaveAs(file_path + dd + sExt);
        context.Response.Write("true." + dd + sExt);
    }

    public bool IsReusable {
        get {
            return false;
        }
    }
}
