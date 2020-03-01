using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Saint.Sysctrl;
using System.Data;

public class SysctrlService
{
    /// <summary>
    /// 取得系統清單
    /// </summary>
    public IEnumerable<SYScode> GetSyscode() {
        string SQL = "SELECT * FROM Syscode ORDER BY Syscode";
        using (DBHelper conn = new DBHelper(Conn.ODBCDSN)) {
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            List<SYScode> returnData = dt.Mapping<SYScode>().ToList();
            return returnData;
         }
    }

    /// <summary>
    /// 取得使用者可用系統
    /// </summary>
    /// <param name="scode">薪號</param>
    public IEnumerable<Dictionary<string, object>> GetUserSystemData(string scode, string excludeSys) {
        string SQL = @"SELECT A.sysserver,A.syspath, A.sysnameC, A.syscode 
                     FROM sysctrl 
                     INNER JOIN SYScode A ON sysctrl.syscode = A.syscode
                        WHERE sysctrl.scode = '" + scode + "'";
        SQL += (excludeSys != "" ? " and a.syscode not in('" + excludeSys + "')" : "");
        using (DBHelper conn = new DBHelper(Conn.ODBCDSN)) {
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);
            IEnumerable<Dictionary<string, object>> rtn = dt.ToDictionary();
            return rtn;
        }
    }

    /// <summary>
    /// 取得群組系統選單
    /// </summary>
    /// <param name="scode">薪號</param>
    public IEnumerable<Dictionary<string, object>> GetSystemMenu(string syscode, string loginGrp) {
        string SQL = "select row_number() OVER( PARTITION BY c.APseq,substring(a.APorder,1,1) ORDER BY a.APorder, a.APcode) AS GrpNum " +
         ",a.APcode, a.APnameC, a.APorder, a.APserver, a.APpath, a.Remark " +
         ",b.LoginGrp, b.Rights, c.APcatCName, c.APCatID " +
         " FROM AP AS a" +
         " INNER JOIN LoginAP AS b ON a.APcode = b.APcode AND a.SYScode = b.SYScode" +
         " INNER JOIN APcat AS c ON a.APcat = c.APcatID AND a.SYScode = c.SYScode " +
         " WHERE b.LoginGrp = '" + loginGrp + "'" +//BTBRTADMIN
         " AND b.SYScode = '" + syscode + "'" +//NBRP
         " AND (b.Rights & 1) > 0 " +
         " ORDER BY c.APseq,a.APorder, a.APcode";
        using (DBHelper conn = new DBHelper(Conn.ODBCDSN)) {
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);
            IEnumerable<Dictionary<string, object>> rtn = dt.ToDictionary();

            IEnumerable<Dictionary<string, object>> returnData = null;
            returnData = rtn.Select(x => x["APcatCName"].ToString()).Distinct()
                        .Select(r => new Dictionary<string, object>
                        {
                            {"APcatCName", r},
                            {"CatLength" , rtn.Where(i => i["APcatCName"].ToString() == r).Max(itm => System.Text.Encoding.Default.GetBytes(itm["APnameC"].ToString()).Length) * 8},//*7.2,
                            {"submenu" , rtn.Where(i => i["APcatCName"].ToString() == r)
                                .Select(s => new Dictionary<string, object>
                                {
                                    {"APcode", s["APcode"]},
                                    {"APnameC" , s["APnameC"]},
                                    {"APserver" , s["APserver"]},
                                    {"APpath" , s["APpath"].ToString().Replace(".htm",".asp")},
                                    {"APorder" , s["APorder"]},
                                    {"GrpNum" , s["GrpNum"]},
                                    {"Remark" , s["Remark"]},
                                    {"APCatID" , s["APCatID"]},
                                    {"APcatCName" , s["APcatCName"]}
                                })}
                        });
            return returnData;
        }
    }
}