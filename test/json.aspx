<%@ Page Language="C#" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "Newtonsoft.Json"%>
<%@ Import Namespace = "Newtonsoft.Json.Linq"%>

<!DOCTYPE html>

<script runat="server">
    private void Page_Load(System.Object sender, System.EventArgs e) {
        using (DBHelper conn = new DBHelper(Conn.OptK, false)) {
            string SQL = "select * ";
            SQL += ",(select code_name from cust_code  where code_type='ODowhat' and cust_code = a.dowhat) as dowhat_nm ";
            SQL += ",(SELECT sc_name FROM sysctrl.dbo.scode WHERE scode = a.approve_scode) AS approve_scode_nm ";
            SQL += ",(select code_name from cust_code  where code_type='OJOB_STAT' and cust_code = a.job_status) as job_status_nm ";
            SQL += " from todo_opt as a ";
            SQL += " where opt_sqlno =  '2118' ";
            SQL += " and branch =  'K' ";
            SQL += " order by resp_date desc";
            DataTable dt = new DataTable();
            conn.DataTable(SQL, dt);

            var settings = new JsonSerializerSettings() {
                Formatting = Formatting.None,
                ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
                Converters = new List<JsonConverter> { new DBNullCreationConverter(), new TrimCreationConverter() }//dbnull轉空字串且trim掉
            };

            Response.Write(JsonConvert.SerializeObject(dt, settings).ToUnicode());
        }
    }
</script>

<script>
var JSONdata = $.parseJSON("[{\"sqlno\":10801,\"pre_sqlno\":10782,\"syscode\":\"OPT\",\"apcode\":\"opt21\",\"opt_no\":\"\",\"opt_sqlno\":2118,\"branch\":\"K\",\"case_no\":\"\",\"in_scode\":\"admin\",\"in_date\":\"2010-04-27T14:32:33.02\",\"dowhat\":\"PR\",\"job_scode\":\"\",\"job_team\":\"\",\"job_status\":\"XX\",\"approve_scode\":\"\",\"approve_desc\":\"因為發文案性\\\"申請延期\\\"有誤，煩請刪除此二件工作\",\"resp_date\":\"2010-04-27T14:52:14.29\",\"mark\":\"\",\"dowhat_nm\":\"承辦\",\"approve_scode_nm\":\"\",\"job_status_nm\":\"退回\"},{\"sqlno\":10782,\"pre_sqlno\":10781,\"syscode\":\"OPT\",\"apcode\":\"opt22\",\"opt_no\":\"\",\"opt_sqlno\":2118,\"branch\":\"K\",\"case_no\":\"\",\"in_scode\":\"k467\",\"in_date\":\"2010-04-26T10:55:42.353\",\"dowhat\":\"MG_GS\",\"job_scode\":\"\",\"job_team\":\"\",\"job_status\":\"XX\",\"approve_scode\":\"admin\",\"approve_desc\":\"退回\",\"resp_date\":\"2010-04-27T14:32:33.02\",\"mark\":\"\",\"dowhat_nm\":\"官方發文確認\",\"approve_scode_nm\":\"系統管理者\",\"job_status_nm\":\"退回\"},{\"sqlno\":10781,\"pre_sqlno\":10780,\"syscode\":\"OPT\",\"apcode\":\"opt31\",\"opt_no\":\"\",\"opt_sqlno\":2118,\"branch\":\"K\",\"case_no\":\"\",\"in_scode\":\"k467\",\"in_date\":\"2010-04-26T10:55:42.34\",\"dowhat\":\"AP\",\"job_scode\":\"k467\",\"job_team\":\"\",\"job_status\":\"YY\",\"approve_scode\":\"k467\",\"approve_desc\":\"\",\"resp_date\":\"2010-04-26T10:55:42.353\",\"mark\":\"\",\"dowhat_nm\":\"判行\",\"approve_scode_nm\":\"林雪貞\",\"job_status_nm\":\"核准\"},{\"sqlno\":10780,\"pre_sqlno\":\"\",\"syscode\":\"OPT\",\"apcode\":\"opt21\",\"opt_no\":\"\",\"opt_sqlno\":2118,\"branch\":\"K\",\"case_no\":\"\",\"in_scode\":\"k467\",\"in_date\":\"2010-04-26T10:13:00.537\",\"dowhat\":\"PR\",\"job_scode\":\"\",\"job_team\":\"\",\"job_status\":\"YY\",\"approve_scode\":\"k467\",\"approve_desc\":\"\",\"resp_date\":\"2010-04-26T10:55:42.34\",\"mark\":\"\",\"dowhat_nm\":\"承辦\",\"approve_scode_nm\":\"林雪貞\",\"job_status_nm\":\"核准\"},{\"sqlno\":13266,\"pre_sqlno\":10801,\"syscode\":\"OPT\",\"apcode\":\"opt11\",\"opt_no\":\"\",\"opt_sqlno\":2118,\"branch\":\"K\",\"case_no\":\"\",\"in_scode\":\"k467\",\"in_date\":\"2020-03-22T09:00:54.623\",\"dowhat\":\"BR\",\"job_scode\":\"\",\"job_team\":\"\",\"job_status\":\"NN\",\"approve_scode\":\"\",\"approve_desc\":\"\",\"resp_date\":\"\",\"mark\":\"\",\"dowhat_nm\":\"分案\",\"approve_scode_nm\":\"\",\"job_status_nm\":\"未處理\"}]");
</script>
