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

        string type = context.Request["type"] ?? "";
        string mappath_name = Sys.FileDir(type);
        string upfolder = context.Request["upfolder"] ?? "";
        string pattach_path = mappath_name + "/" + upfolder + "/";//虛擬完整路徑+實體檔名
        
        HttpPostedFile uploadedFile = context.Request.Files[0];
        string FName = uploadedFile.FileName;               //使用者端目錄+檔案名稱
        string psource_name = System.IO.Path.GetFileName(FName);      //原始檔名(含Ext)
        string dd = System.IO.Path.GetFileNameWithoutExtension(FName);      //原檔名(不含Ext)
        string sExt = System.IO.Path.GetExtension(FName);   //副檔名
        int pattach_size = uploadedFile.ContentLength;       //檔案大小(bytes)

        string file_path = context.Server.MapPath(pattach_path);//指定儲存路徑
        ////context.Response.ContentType = "text/plain";
        //context.Response.StatusCode = (int)System.Net.HttpStatusCode.InternalServerError;
        //context.Response.Write("<BR>" + file_path);
        //context.Response.Write("<BR>" + uploadedFile.FileName);
        //context.Response.End();
        if (!System.IO.Directory.Exists(file_path)) {
            System.IO.Directory.CreateDirectory(file_path);//如果不存在就建立file資料夾
        }
        string saveFName=dd + sExt;
        uploadedFile.SaveAs(file_path + saveFName);
        
        //實體檔名，虛擬完整路徑+實體檔名，原始檔名，檔案大小，attach_no
        //NP-25484--0001-16626-3m.png#@#/brp/NP/temp/N/_/254/25484/NP-25484--0001-16626-3m.png#@#[立體商標註冊申請書]-TI-54531-IT_[立體商標註冊申請書]_0000.png#@#43758#@#3
        var pvalue = saveFName + "#@#" + pattach_path + saveFName + "#@#" + psource_name + "#@#" + pattach_size + "#@#";// +pattach_no;

        context.Response.Write(pvalue);//回傳值
    }

    public bool IsReusable {
        get {
            return false;
        }
    }
}
