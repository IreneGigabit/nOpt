using System.Data;
using System.Data.SqlClient;

/// <summary>  
/// 原Server_code.vbs
/// </summary>  
public class Funcs {
    #region formatSeq - 組本所編號
    /// <summary>  
    /// 組本所編號
    /// </summary>  
    public static string formatSeq(string seq, string seq1, string country, string branch, string dept) {
        string lseq = branch + dept + "-" + seq;
        lseq += (seq1 != "_" ? ("-" + seq1) : "");
        lseq += (country != "" ? (" " + country.ToUpper()) : "");
        return lseq;
    }
    #endregion

    #region GetPrTermALL - 抓取爭議組承辦人員，2013/12/25增加判斷scode.end_date,for分案
    /// <summary>  
    /// 抓取爭議組承辦人員
    /// </summary>  
    public static DataTable GetPrTermALL(string submitTask) {
        using (DBHelper cnn = new DBHelper(Conn.Sysctrl, false)) {
            string SQL = "select c.scode,c.sc_name from grpid as a ";
            SQL += " inner join scode_group as b on a.grpclass=b.grpclass and a.grpid=b.grpid ";
            SQL += " inner join scode as c on b.scode=c.scode ";
            SQL += " where a.grpclass='B' and a.grpid='T100'";
            if (submitTask == "A") {
                SQL += "and (c.end_date is null or c.end_date>=getdate()) ";
            }
            DataTable dt = new DataTable();
            cnn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region getdoc_type - 抓取上傳附件種類
    /// <summary>  
    /// 抓取上傳附件種類
    /// </summary>  
    public static DataTable getdoc_type() {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            string SQL = "select cust_code,code_name from cust_code where code_type='Odoc_type' order by sortfld";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region getcust_code_mul - 抓取區所cust_code
    /// <summary>  
    /// 抓取抓取區所cust_code
    /// </summary>  
    public static DataTable getcust_code_mul(string code_type, string pwh2, string sortField) {
        using (DBHelper conn = new DBHelper(Conn.OptB("K"), false)) {
            string SQL = "select cust_code,code_name from cust_code ";
            SQL += " where code_type='" + code_type + "' " + pwh2;
            if (sortField == "")
                SQL += " order by cust_code";
            else
                SQL += " order by " + sortField;
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region getcust_code - 抓取爭救案cust_code
    /// <summary>  
    /// 抓取爭救案cust_code
    /// </summary>  
    public static DataTable getcust_code(string code_type, string pwh2, string sortField) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            string SQL = "select cust_code,code_name from cust_code ";
            SQL += " where code_type='" + code_type + "' " + pwh2;
            if (sortField == "")
                SQL += " order by cust_code";
            else
                SQL += " order by " + sortField;
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region getcountry - 國籍
    /// <summary>  
    /// 抓取國籍
    /// </summary>  
    public static DataTable getcountry() {
        using (DBHelper conn = new DBHelper(Conn.Sysctrl, false)) {
            string SQL = "select coun_code,coun_c from country where markb<>'X' or markb is null order by coun_code";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion

    #region GetBJPrTermALL - 北京聖島承辦人員，2013/12/25增加判斷scode.end_date,for分案
    /// <summary>  
    /// 北京聖島承辦人員
    /// </summary>  
    public static DataTable GetBJPrTermALL(string submitTask) {
        using (DBHelper cnn = new DBHelper(Conn.Sysctrl, false)) {
            string SQL = "select c.scode,c.sc_name from scode_group as a ";
            SQL += " inner join scode as c on a.scode=c.scode ";
            SQL += " where a.grpclass='BJ' and a.grpid='T100' ";
            if (submitTask == "A") {
                SQL += "and (c.end_date is null or c.end_date>=getdate()) ";
            }
            DataTable dt = new DataTable();
            cnn.DataTable(SQL, dt);

            return dt;
        }
    }
    #endregion
}


