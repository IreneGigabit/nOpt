<%@ Page Language="C#" CodePage="65001"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    protected string HTProgCap = "編修權限群組-入檔";//功能名稱
    protected string HTProgPrefix = "EditRegSys";//程式檔名前綴
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected string SQL = "";
    protected string msg = "";

    protected string submitTask = "";
    protected string syscode = "";
    protected string apcode = "";

    protected Dictionary<string, string> ReqVal = new Dictionary<string, string>();
    protected StringBuilder strOut = new StringBuilder();

    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;

        submitTask = (Request["submittask"] ?? "");
        syscode = (Request["syscode"] ?? "");
        apcode = (Request["apcode"] ?? "");

        ReqVal = Util.GetRequestParam(Context,Request["chkTest"] == "TEST");

        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe();
        if (HTProgRight >= 0) {
            DBHelper cnn = new DBHelper(Conn.ODBCDSN).Debug(Request["chkTest"] == "TEST");
            try {
                doUpdate(cnn);

                cnn.Commit();
                //cnn.RollBack();

                if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.parent.Etop.goSearch();");
            }
            catch (Exception ex) {
                cnn.RollBack();
                Sys.errorLog(ex, cnn.exeSQL, prgid);

                //throw new Exception(msg, ex);
            }
            finally {
                cnn.Dispose();
            }

            this.DataBind();
        }
    }

    private void doUpdate(DBHelper cnn) {
        SQL = "DELETE FROM LoginAP WHERE SYScode='" + syscode + "' AND Apcode = '" + apcode + "'";
        cnn.ExecuteNonQuery(SQL);
   
        SQL = "select C.*,D.LoginGrp from ap As C ";
		SQL += "LEFT JOIN LoginGrp As D ON D.SYScode = C.SYScode ";
        SQL += "Where C.SYScode = '" + syscode + "' And C.Apcode = '" + apcode + "'";
        using (SqlDataReader dr = cnn.ExecuteReader(SQL)) {
            while (dr.Read()) {
                string logingrp = dr.SafeRead("LoginGrp", "");
                int rights = 0;
                string rwid = "";
                string sBgn = "";
                string sEnd = "";

                for (int z = 0; z <= 9; z++) {
                    //Response.Write("2的" + z + "次方=" + Math.Pow(2, z) + "<BR>");
                    int pow = Convert.ToInt32(Math.Pow(2, z));
                    rwid = "chk_" + logingrp + "_" + pow.ToString().PadLeft(3, '0');
                    if (Request[rwid] != null) rights += int.Parse(Request[rwid]);
                }

                if (rights > 0) {
                    rwid = "Bgn_" + logingrp;
                    if (string.IsNullOrEmpty(Request[rwid]))
                        sBgn = "1970/1/1";
                    else
                        sBgn = Request[rwid];

                    rwid = "End_" + logingrp;
                    if (string.IsNullOrEmpty(Request[rwid]))
                        sEnd = "2079/6/6";
                    else
                        sEnd = Request[rwid];

                    SQL += "INSERT INTO LoginAP (SYScode,LoginGrp, Apcode,Rights,beg_date,end_date,tran_date,Tran_scode";
                    SQL += ") VALUES ('" + syscode + "','" + logingrp + "','" + apcode + "'";
                    SQL += ",'" + rights + "','" + sBgn + "','" + sEnd + "',getdate(),'" + Session["scode"] + "');";
                }
            }
        }
                 
        SQL = " Update APcat set";
        SQL += " apcatcname = " + Util.dbnull(Request["tfx_APcatCName"].ToBig5()) + "";
        SQL += ",apcatename = " + Util.dbnull(Request["tfx_APcatEName"].ToBig5()) + "";
        SQL += ",apseq = " + Util.dbnull(Request["nfx_APseq"].ToBig5()) + "";
        SQL += " where syscode='" + syscode + "' AND APcatID='" + APcatID + "'";
        cnn.ExecuteNonQuery(SQL);
        
        msg = "資料更新成功!!!";
        strOut.AppendLine("alert('" + msg + "');");
        if (Request["chkTest"] != "TEST") strOut.AppendLine("window.parent.location.reload();");
    }
</script>

<script language="javascript" type="text/javascript">
    <%Response.Write(strOut.ToString());%>
</script>
