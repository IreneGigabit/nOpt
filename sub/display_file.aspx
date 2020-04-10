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
        file_path = "/nopt/opt_file";
        if (strtype == "law_opt") {
            file_path = "/nopt/law_opt";
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
            //Response.Write("folder_name="+folder_name+"<HR>");
            //Response.Write("file_name="+file_name+"<HR>");
            //Response.End();

            if (chkFolderExist(file_path)) {
                if (chkFileExist(file_path + "/" + folder_name + "/" + file_name)) {
                    show_photo(file_path + "/" + folder_name + "/" + file_name);
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

        //StringBuilder strOut = new StringBuilder();
        //strOut.AppendLine("<html>");
        //strOut.AppendLine("<head>");
        //strOut.AppendLine("<title>商標圖檔資料顯示</title>");
        //strOut.AppendLine("</head>");
        //strOut.AppendLine("<body onload='window.focus()'>");
        //strOut.AppendLine("<br><br>");
        //strOut.AppendLine("<p><img border='0' src='"+ImagePath+"'></p>");
        //strOut.AppendLine("</body>");
        //strOut.AppendLine("</html>");
        //
        //Response.Write(strOut.ToString());
        //Response.End();
    }
</script>
