var employeeService = (function () {
    var service = {
        get: get
    }

    function get() {
        //return $.get('../Default.aspx/GetViewData', {}, function (data) {
        //    alert(data);
        //})
        var rtn = {};
        $.get({
            url: '../Default.aspx/GetViewData',
            data: {},
            contentType: "application/json; charset=utf-8",//要加這行才能呼叫到Webservice
            dataType: "json",//回傳json
        }).done(function (rr) {
            //alert("ok");
            rtn= $.parseJSON(rr.d).sysList;
        });
        //alert("rtn");
        return rtn;
        /*ajaxByGet('../Default.aspx/GetViewData', {})
        .success(function (rtn) {
            //var Result = $.parseJSON(rtn.d);
            var Result = rtn.d;
            //console.log(Result.sysList);
            return Result.sysList;
        });*/
        /*
        return $.parseJSON($.ajax({
            cache: false,
            url: '../Default.aspx/GetViewData',
            contentType: "application/json; charset=utf-8",
            dataType: "json",//回傳json
            type: "get",
            data: {}
        }).d);*/
        /*
        return [
            { id: 1, name: 'anson' },
            { id: 2, name: 'jacky' }
        ]*/
    }
    return service;
})();