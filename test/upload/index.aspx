<%@ Page Language="C#"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script runat="server">
    private void Page_Load(System.Object sender, System.EventArgs e) {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="x-ua-compatible" content="IE=11">

    <title>多檔上傳</title>

    <!-- Custom styles -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css" integrity="sha384-Zug+QiDoJOrZ5t4lssLdxGhVrurbmBWopoEl+M6BdEfwnCJZtKxi1KgxUyJq13dy" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/lib/jquery.dm-uploader.css")%>" />
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery-1.12.4.min.js")%>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery.dm-uploader.js")%>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery.dm-config.js")%>"></script>
 </head>

  <body>
    <div class="dm-uploader">
        <!-- Our markup, the important part here! -->
        <div id="drag-and-drop-zone">
           <div class="fieldset flash" id="fsUploadProgress2">
                <span class="legend">多檔上傳</span>
                <ul class="list-unstyled p-2 d-flex flex-column col" id="files">
                    <li class="text-muted text-center empty">No files uploaded.</li>
                </ul>
            </div>
            <div class="btn btn-primary btn-block">
                <span>瀏覽...</span>
                <input type="file" title='Click to add Files' />
            </div>
        </div><!-- /uploader -->
        <br /><br />

        <div class="fieldset">
            <span class="legend">Debug Messages</span>
            <ul class="list-group list-group-flush" id="debug">
                <li class="list-group-item text-muted empty">Loading plugin....</li>
            </ul>
        </div><!-- /debug -->
    </div>

    <!-- File item template -->
    <script type="text/html" id="files-template">
      <li class="media">
        <div class="media-body mb-1">
          <p class="mb-2">
            <strong>%%filename%%</strong> - 狀態: <span class="text-muted">Waiting</span>
          </p>
          <div class="progress mb-2">
            <div class="progress-bar progress-bar-striped progress-bar-animated bg-primary" 
              role="progressbar"
              style="width: 0%" 
              aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">
            </div>
          </div>
          <hr class="mt-1 mb-1" />
        </div>
      </li>
    </script>

    <!-- Debug item template -->
    <script type="text/html" id="debug-template">
        <li class="list-group-item text-%%color%%"><strong>%%date%%</strong>: %%message%%</li>
    </script>
  </body>
</html>
