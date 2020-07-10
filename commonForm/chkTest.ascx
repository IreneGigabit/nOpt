<%@ Control Language="C#" ClassName="test_form" %>

<script runat="server">
    public int HTProgRight = 0;//權限

    private void Page_Load(System.Object sender, System.EventArgs e) {
        this.DataBind();
    }
</script>

<label id="labTest" style="display:none"><input type="checkbox" id="chkTest" name="chkTest" value="TEST" />測試</label>

<script language="javascript" type="text/javascript">
    //$(function () {
    //    //if((<%#HTProgRight%> & 256)){
    //    if ("<%#Sys.IsDebug()%>" == "True") {//☑測試
    //        $("#labTest").show();
    //        $("#chkTest").prop("checked",true).triggerHandler("click");
    //    }
    //});
    //
    //$("#chkTest").click(function (e) {
    //    $("#ActFrame").showFor($(this).prop("checked"));
    //});
</script>
