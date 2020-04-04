<%@ Page Language="C#" CodePage="65001"%>

<script runat="server">
    protected string strtype = "";
    protected string draw_file = "";
    protected string file_name = "";
    protected string folder_name = "";
    protected string gs_date = "";
    protected string file_path = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        strtype = (Request["type"] ?? "").ToLower();
        draw_file = Request["draw_file"] ?? "";
        draw_file = draw_file.Replace("\\", "/");
        file_name = draw_file.Substr((draw_file.LastIndexOf("/")+1));
        folder_name = Request["folder_name"] ?? "";
        gs_date = Request["gs_date"] ?? "";

        if (strtype != "doc" && strtype != "law_opt") {
            Response.Write("<script language=javascript>\n");
            Response.Write("alert('錯誤,請重新查詢!');\n");
            Response.Write("window.close();\n");
            Response.Write("<" + "/script>\n");
            Response.End();
        }

        PageLayout();
        this.DataBind();
    }

    private void PageLayout() {
        file_path = "/opt/opt_file";
        if (strtype == "law_opt") {
            file_path = "/opt/law_opt";
        }

        if (gs_date != "") {
            //Response.Write("file_path="+file_path+"<HR>");
            //Response.Write("folder_name="+folder_name+"<HR>");
            //Response.Write("file_name="+file_name+"<HR>");
            //Response.End();

            DateTime dgs_date1 = DateTime.ParseExact(gs_date, "yyyy/MM/dd", System.Globalization.CultureInfo.InvariantCulture);
            DateTime dgs_date2 = DateTime.ParseExact("2009/3/9", "yyyy/MM/dd", System.Globalization.CultureInfo.InvariantCulture);

            if (dgs_date1 <= dgs_date2) {
                if (chkFolderExist(file_path + "/" + folder_name)) {
                    if (chkFileExist(file_path + "/" + folder_name + "/" + file_name)) {
                        show_photo(file_path + "/" + folder_name + "/" + file_name);
                    } else {
                        error_msg("圖檔");
                    }
                } else {
                    error_msg("圖檔目錄");
                }
            } else {
                if (chkFolderExist(file_path)) {
                    if (chkFileExist(file_path + "/" + file_name)) {
                        show_photo(file_path + "/" + file_name);
                    } else {
                        error_msg("圖檔");
                    }
                } else {
                    error_msg("圖檔目錄");
                }
            }
        } else {
            //Response.Write("file_path="+file_path+"<HR>");
            //Response.Write("file_name="+file_name+"<HR>");
            //Response.End();

            if (chkFolderExist(file_path)) {
                if (chkFileExist(file_path + "/" + file_name)) {
                    show_photo(file_path + "/" + file_name);
                } else {
                    error_msg("圖檔");
                }
            } else {
                error_msg("圖檔目錄");
            }
        }
    }

    //檢查目錄是否存在
    private bool chkFolderExist(string strFolder) {
        return System.IO.Directory.Exists(Server.MapPath(strFolder));
    }

    //檢查檔案是否存在
    private bool chkFileExist(string strFile) {
        return System.IO.File.Exists(Server.MapPath(strFile));
    }

    private void error_msg(string a) {
        StringBuilder strOut = new StringBuilder();
        strOut.AppendLine("<script language=javascript>");
        strOut.AppendLine("alert('◎此"+a+"不存在，請確認之後再查!');");
        strOut.AppendLine("window.close();");
        strOut.AppendLine("<" + "/script>");

        Response.Write(strOut.ToString());
        Response.End();
    }

    private void show_photo(string a) {
        string ImagePath = "http://" + Request.ServerVariables["SERVER_NAME"] + a;
        Response.Redirect(ImagePath);
        Response.End();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<title>文件上傳</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<body bgcolor="#FFFFFF">
    <p align="center"><big><font face="標楷體" color="#004000"><strong><big><big><%=cont%></big></big></strong></font></big></p>
    <center>
      <form name="AttachForm" action="upload_winact_file.asp" method="Post" enctype="multipart/form-data">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
            <tr>
                <td align="left">
          　         上傳檔案到本資料欄位:<br>
          　         <input type="file" name="theFile" size="25">
          　         <input type="hidden" name="hidFile" size="25">
          　         <input type="hidden" name="hidoverwrite" size="25">
          　         <input type="hidden" name="send_type" value="<%=send_type%>">
          　         <input type="hidden" name="nfilename" size="<%=Request("nfilename")%>">
                    <br>&nbsp;
                    <span style="display:none">
                        <font size="2" color="red"><input type="checkbox" id="chkoverwrite" name="chkoverwrite">覆蓋已存在的檔案<br></font>
                    </span>
                    <br>
                    <table width="95%" border="0">
                        <tr> 
                            <td align="center">
                                <font size="2" color="#009900">使用方式：</font><br>
                                <table border="0" width="100%">
                                <tr>
                                    <td width="9%" align="right" valign="top"><font size="2" color="black">◎</font></td>
                                    <td width="91%"><font size="2" color="black">
                                        欲上傳檔案至本欄位，請點選上方之『瀏覽』按鈕後會出現一個『選擇檔案』小視窗，然後請選擇您電腦中欲上傳之檔案。</font>
                                    </td>
                                </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="center">
                    <input type="button" value="上傳" onclick="AttachFile()" id="button1" name="button1" class="cbutton">
                    <input type="button" value="關閉視窗" onclick="javascript:parent.close()" id="button2" name="button2" class="cbutton">
                </td>
            </tr>
        </table>
    </form>
    </center>
</body>
</html>
