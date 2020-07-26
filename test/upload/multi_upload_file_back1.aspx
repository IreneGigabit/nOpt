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
    <%--<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css" integrity="sha384-Zug+QiDoJOrZ5t4lssLdxGhVrurbmBWopoEl+M6BdEfwnCJZtKxi1KgxUyJq13dy" crossorigin="anonymous">--%>
    <link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/lib/bootstrap.min.css")%>" />
    <link rel="stylesheet" type="text/css" href="<%=Page.ResolveUrl("~/js/lib/jquery.dm-uploader.css")%>" />
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery-1.12.4.min.js")%>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery.dm-uploader.js")%>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/util.js")%>"></script>
    <%--<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/lib/jquery.dm-config.js")%>"></script>--%>
 </head>

  <body>
    <div class="dm-uploader">

        <div class="row">
            <div id="drag-and-drop-zone" class="col-md-12 col-sm-12">
                <div class="card text-center" style="min-height: 30vh">
                  <div class="card-header">
                    多檔上傳
                  </div>
                  <div class="card-body p-2">
                    <ul class="list-unstyled p-0 d-flex flex-column col" id="files">
                        <li class="text-muted text-center empty">No files uploaded.</li>
                    </ul>
                  </div>
                  <div class="card-footer">
                      <div class="btn btn-primary btn-block">
                            <span>瀏覽...</span>
                            <input type="file" title='Click to add Files' />
                        </div>
                  </div>
                </div>

            </div>
        </div><!-- /file list -->

        <br /><br />

        <div class="fieldset" style="display:none">
            <span class="legend">Debug Messages</span>
            <ul class="list-group list-group-flush" id="debug">
                <li class="list-group-item text-muted empty">Loading plugin....</li>
            </ul>
        </div><!-- /debug -->
    </div>

    <!-- File item template -->
    <script type="text/html" id="files-template">
      <li>
        <div class="mb-1">
          <p class="mb-0">
            <strong>%%filename%%</strong> - 狀態: <span class="text-muted">Waiting</span>
          </p>
          <div class="progress">
            <div class="progress-bar progress-bar-striped progress-bar-animated bg-primary" 
              role="progressbar"
              style="width: 0%" 
              aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">
            </div>
          </div>
          <hr class="mt-0 mb-1" />
        </div>
      </li>
    </script>

    <!-- Debug item template -->
    <script type="text/html" id="debug-template">
        <li class="list-group-item text-%%color%%"><strong>%%date%%</strong>: %%message%%</li>
    </script>
  </body>
</html>

<script type="text/javascript" language="javascript">
$(function () {
    $(document).unbind();//上傳時畫面會一直閃

    /*
    * For the sake keeping the code clean and the examples simple this file
    * contains only the plugin configuration & callbacks.
    * 
    * UI functions ui_* can be located in: demo-ui.js
    */
    $('#drag-and-drop-zone').dmUploader({ //
        url: getRootPath() + '/sub/UpLoadFile.ashx',
        maxFileSize: 41943040, // 40 Megs 
        onDragEnter: function () {
            // Happens when dragging something over the DnD area
            this.addClass('active');
        },
        onDragLeave: function () {
            // Happens when dragging something OUT of the DnD area
            this.removeClass('active');
        },
        onInit: function () {
            // Plugin is ready to use
            ui_add_log('Penguin initialized :)', 'info');
        },
        onComplete: function () {
            // All files in the queue are processed (success or error)
            ui_add_log('All pending tranfers finished');
        },
        onNewFile: function (id, file) {
            // When a new file is added using the file selector or the DnD area
            ui_add_log('New file added #' + id);
            ui_multi_add_file(id, file);
        },
        onBeforeUpload: function (id) {
            // about tho start uploading a file
            ui_add_log('Starting the upload of #' + id);
            ui_multi_update_file_status(id, 'uploading', '上傳中...');
            ui_multi_update_file_progress(id, 0, '', true);
        },
        onUploadCanceled: function (id) {
            // Happens when a file is directly canceled by the user.
            ui_multi_update_file_status(id, 'warning', 'Canceled by User');
            ui_multi_update_file_progress(id, 0, 'warning', false);
        },
        onUploadProgress: function (id, percent) {
            // Updating file progress
            ui_multi_update_file_progress(id, percent);
        },
        onUploadSuccess: function (id, data) {
            // A file was successfully uploaded
            ui_add_log('Server Response for file #' + id + ': ' + JSON.stringify(data));
            ui_add_log('Upload of file #' + id + ' COMPLETED', 'success');
            ui_multi_update_file_status(id, 'success', '上傳成功');
            ui_multi_update_file_progress(id, 100, 'success', false);
        },
        onUploadError: function (id, xhr, status, message) {
            //console.log(message);//Internal Server Error
            ui_multi_update_file_status(id, 'danger', message + xhr.responseText);
            ui_multi_update_file_progress(id, 0, 'danger', false);
        },
        onFallbackMode: function () {
            // When the browser doesn't support this plugin :(
            ui_add_log('Plugin cant be used here, running Fallback callback', 'danger');
        },
        onFileSizeError: function (file, maxFileSize) {
            ui_multi_add_file(file.id, file);
            ui_multi_update_file_status(file.id, 'danger', "超過大小限制(" + maxFileSize / 1024 / 1024 + "MB)");
            ui_add_log('File \'' + file.name + '\' cannot be added: size excess limit', 'danger');
        }
    });
});

/*
* Some helper functions to work with our UI and keep our code cleaner
*/

// Adds an entry to our debug area
function ui_add_log(message, color) {
    var d = new Date();

    var dateString = (('0' + d.getHours())).slice(-2) + ':' +
        (('0' + d.getMinutes())).slice(-2) + ':' +
        (('0' + d.getSeconds())).slice(-2);

    color = (typeof color === 'undefined' ? 'muted' : color);

    var template = $('#debug-template').text();
    template = template.replace('%%date%%', dateString);
    template = template.replace('%%message%%', message);
    template = template.replace('%%color%%', color);

    $('#debug').find('li.empty').fadeOut(); // remove the 'no messages yet'
    $('#debug').prepend(template);
}

// Creates a new file and add it to our list
function ui_multi_add_file(id, file) {
    var template = $('#files-template').text();
    template = template.replace('%%filename%%', file.name);

    template = $(template);
    template.prop('id', 'uploaderFile' + id);
    template.data('file-id', id);

    $('#files').find('li.empty').fadeOut(); // remove the 'no files yet'
    $('#files').prepend(template);
}

// Changes the status messages on our list
function ui_multi_update_file_status(id, status, message) {
    $('#uploaderFile' + id).find('span').html(message).prop('class', 'status text-' + status);
}

// Updates a file progress, depending on the parameters it may animate it or change the color.
function ui_multi_update_file_progress(id, percent, color, active) {
    color = (typeof color === 'undefined' ? false : color);
    active = (typeof active === 'undefined' ? true : active);

    var bar = $('#uploaderFile' + id).find('div.progress-bar');

    bar.width(percent + '%').attr('aria-valuenow', percent);
    bar.toggleClass('progress-bar-striped progress-bar-animated', active);

    if (percent === 0) {
        bar.html('');
    } else {
        bar.html(percent + '%');
    }

    if (color !== false) {
        bar.removeClass('bg-success bg-info bg-warning bg-danger');
        bar.addClass('bg-' + color);
    }
}
</script>