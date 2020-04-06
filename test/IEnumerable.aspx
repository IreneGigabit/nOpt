<%@ Page Language="C#" CodePage="65001" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
	private void Page_Load(Object sender, EventArgs e) {
        string SQL = "select row_number() OVER( PARTITION BY c.APseq,substring(a.APorder,1,1) ORDER BY a.APorder, a.APcode) AS grpnum " +
         ",a.APcode, a.APnameC, a.APorder, a.APserver, a.APpath, a.ReMark " +
         ",b.LoginGrp, b.Rights, c.APcatCName, c.APCatID,b.SYScode " +
         " FROM AP AS a" +
         " INNER JOIN LoginAP AS b ON a.APcode = b.APcode AND a.SYScode = b.SYScode" +
         " INNER JOIN APcat AS c ON a.APcat = c.APcatID AND a.SYScode = c.SYScode " +
         " WHERE b.LoginGrp = 'BTBRTADMIN'" +//BTBRTADMIN
         " AND b.SYScode = 'NBRP'" +//NBRP
         " AND (b.Rights & 1) > 0 " +
         " ORDER BY c.APseq,a.APorder, a.APcode";
        using (DBHelper conn = new DBHelper(Conn.Sysctrl)) {
            try {
                DataTable dt = new DataTable();
                conn.DataTable(SQL, dt);
                
                var dyo = dt.ToDictionary().Where(x => x["SYScode"] != "OPT").First();
                Response.Write("<font color=orange>datatable row:" + dyo["grpnum"] + "," + dyo["APcode"] + "," + dyo["APnameC"] + "</font><br/>");
                Response.Write("<HR>");

                var dyx = dt.ToDictionary().Where(x => x["SYScode"] != "OPT");
                foreach (var V in dyx) {
                    Response.Write("<font color=brown>datatable row:" + V["grpnum"] + "," + V["APcode"] + "," + V["APnameC"] + "</font><br/>");
                }
                Response.Write("<HR>");

                //var dy = dt.AsDynamicEnumerable();
                var dy = dt.AsEnumerable();
                foreach (var V in dy) {
                    Response.Write("<font color=red>datatable row:" + V["grpnum"] + "," + V["apcode"] + "," + V["apnamec"] + "</font><br/>");
                }
                Response.Write("<HR>");

                SqlDataReader dr = conn.ExecuteReader(SQL);
                var dy1 = dr.GetEnumerator();
                foreach (var V in dy) {
                    Response.Write("<font color=blue>datatable row:" + V["grpnum"] + "," + V["apcode"] + "," + V["apnamec"] + "</font><br/>");
                }
                Response.Write("<HR>");
                dr.Close();
            }
            catch (Exception ex) {
                //system.errorLog(ex, conn.exeSQL, "test");
                throw;
            }
        }
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
<link rel="icon" type="image/ico" href="./icon/myfarm.ico" />
<link rel="shortcut icon" href="./icon/myfarm.ico" />
<title></title>
</head>
<body></body>
</html>