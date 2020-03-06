<%@ Application Language="C#" %>
<%@Import Namespace = "System.Data"%>
<%@Import Namespace = "System.Data.SqlClient"%>

<script runat="server">

    void Application_Start(object sender, EventArgs e) 
    {
        // 應用程式啟動時執行的程式碼
	}
    
    void Application_End(object sender, EventArgs e) {
        //  應用程式關閉時執行的程式碼

    }
        
    void Application_Error(object sender, EventArgs e)  { 
        // 發生未處理錯誤時執行的程式碼
		// for IIS 6.0 (Windows 2003 Server)
		//Exception exObj = Server.GetLastError();
		//if (exObj is HttpUnhandledException)
		//{
		//	int hcode = ((HttpUnhandledException)exObj).GetHttpCode();
		//	if (hcode == 500) Server.Transfer("~/500-error.aspx");
		//}
	}

    void Session_Start(object sender, EventArgs e) {
        // 啟動新工作階段時執行的程式碼
		//案件系統
        /*
		switch (Request.ServerVariables["HTTP_HOST"].ToString().ToUpper()) {
			case "SIK08"://------------正式環境------------
				//爭救案系統
				Session["optK"] = system.getConnString("prod_optk");
				//爭救案件管理系統用
				Session["optBN"] =system.getConnString("prod_optBN");
				Session["optBC"] =system.getConnString("prod_optBC");
				Session["optBS"] =system.getConnString("prod_optBS");
				Session["optBK"] =system.getConnString("prod_optBK");
				Session["optBM"] =system.getConnString("prod_optBM");
				//帳款資料使用
				Session["Nacc"] =system.getConnString("prod_Nacc");
				Session["Cacc"] =system.getConnString("prod_Cacc");
				Session["Sacc"] =system.getConnString("prod_Sacc");
				Session["Kacc"] =system.getConnString("prod_Kacc");
				//sysctrl
				Session["ODBCDSN"] =system.getConnString("prod_sysctrl");
				break;
			case "WEB10"://------------使用者測試環境------------
				//爭救案系統
				Session["optK"] =system.getConnString("test_optk");
				//爭救案件管理系統用
				Session["optBN"] =system.getConnString("test_optBN");
				Session["optBC"] =system.getConnString("test_optBC");
				Session["optBS"] =system.getConnString("test_optBS");
				Session["optBK"] =system.getConnString("test_optBK");
				Session["optBM"] =system.getConnString("test_optBM");
				//帳款資料使用
				Session["Nacc"] =system.getConnString("test_Nacc");
				//sysctrl
				Session["ODBCDSN"] =system.getConnString("test_sysctrl");
				break;
			default://------------開發環境------------
				//爭救案系統
				Session["optK"] =system.getConnString("dev_optk");
				//爭救案件管理系統用
				Session["optBN"] =system.getConnString("dev_optBN");
				Session["optBC"] =system.getConnString("dev_optBC");
				Session["optBS"] =system.getConnString("dev_optBS");
				Session["optBK"] =system.getConnString("dev_optBK");
				Session["optBM"] =system.getConnString("dev_optBM");
				//帳款資料使用
				Session["Nacc"] =system.getConnString("dev_Nacc");
				//sysctrl
				Session["ODBCDSN"] =system.getConnString("dev_sysctrl");
				break;
		}
         * */
	}

	void Session_End(object sender, EventArgs e) {
        // 工作階段結束時執行的程式碼。 
        // 注意: 只有在 Web.config 檔將 sessionstate 模式設定為 InProc 時，
        // 才會引發 Session_End 事件。如果將工作階段模式設定為 StateServer 
        // 或 SQLServer，就不會引發這個事件。
    }
</script>
