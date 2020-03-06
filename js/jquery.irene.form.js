(function ($) {
	//#region $maskStart 
	$maskStart = function (msg) {
		var w = Math.max($(window).width(), $(document).width());
		var h = Math.max($(window).height(), $(document).height());

		if ($("body").find("#divProgress").length == 0) {
			$("body").append("<div id=\"divProgress\" style=\"display:none;\">" +
			"<img id=\"imgLoading\" src=\"../images/loading.gif\" style=\"border-width:0px;\" /><br />" +
			"<font color=\"#1B3563\">" + msg + "</font>" +
			"</div>");
		}

		if ($("body").find("#divMaskFrame").length == 0) {
			$("body").append("<div id=\"divMaskFrame\" style=\"display:none;\"></div>");
		}

		$("#divMaskFrame").css({
			'overflow': 'hidden',
			'background-color': '#F2F4F7',
			'width': w,
			'height': h,
			'position': 'absolute',
			'z-index': '999998',
			'opacity': '0.7',
			'-moz-opacity': '0.7',
			'-khtml-opacity': '0.7',
			'filter': 'alpha(opacity=70)',
			'top': '0',
			'left': '0'
		});

		var t = (h / 2) - ($("#divProgress").height() / 2);
		$("#divProgress").css({
			'text-align': 'center',
			'position': 'absolute',
			'top': t,
			'left': '50%',
			//'background-color': '#88bbff',
			'opacity': '0.9',
			'-moz-opacity': '0.9',
			'-khtml-opacity': '0.9',
			'filter': 'alpha(opacity=90)',
			'z-index': '999999'
		});


		$("body").css("cursor", "wait");
		$("#divMaskFrame").show();
		if (msg != "" && msg != undefined && msg != null) {
			$("#divProgress").show();
		}
	}
	//#endregion

	//#region $maskStop 
	$maskStop = function (msg) {
		$("#divMaskFrame").fadeOut(500);
		$("#divProgress").fadeOut(500);
		$("body").css("cursor", "default");
	}
	//#endregion

	//#region BLen 
	$.BLen = function (str) {
		var arr = str.match(/[^\x00-\xff]/ig);
		return arr == null ? str.length : str.length + arr.length;
	}
	//#endregion

	//#region labelfor 
	$.fn.labelfor = function () {
		return this.each(function () {
			if (this.type == "radio" || this.type == "checkbox") {
				if ($(this).attr("id") != "") {
					$(this).next("label").attr("for", $(this).attr("id"));
				}
			}
		});
	}
	//#endregion

	//#region lock 
	$.fn.lock = function () {
		return this.each(function () {
			if ($(this).hasClass("dateField")) {
				$(this).datepick("option", "showOnFocus", false).next(".datepick-trigger:first").hide();
				//xx$(this).next(".datepick-trigger:first").prop('disabled', true);
				//$(this).datepick("disable");
			}
			if (this.type == "text" || this.type=="textarea") {
				$(this).prop('readonly', true).addClass('SEdit');
			} else {
				$(this).prop('disabled', true);
			}
		});
	}
	//#endregion

	//#region unlock 
	$.fn.unlock = function () {
		return this.each(function () {
			if ($(this).hasClass("dateField")) {
				$(this).datepick("option", "showOnFocus", true).next(".datepick-trigger:first").show();
				//xx$(this).next(".datepick-trigger:first").prop('disabled', false);
				//$(this).datepick("enable");
			}
			$(this).prop('readonly', false).removeClass('SEdit').prop('disabled', false);
		});
	}
	//#endregion

	//#region chkRequire
	$.fn.extend({
		chkRequire: function (option) {
			var defaults = {
				msg: "",
				br: false,
				depend: null
			};

			var settings = $.extend(defaults, option || {});
			var errflag = false;

			this.each(function () {
				var errmsg = "";

				if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").length == 0) {
					$(this).parents("td:first").append("<span class='errlog'></span>");
				}

				//$(this).nextAll(".errlog:eq(0)").html("");
				//$(this).parents("td:first").children(":gt("+$(this).index()+").errlog:first").html("");

				if (settings.depend != null && settings.depend != undefined && settings.depend != "") {
					//if (this.type == "radio" || this.type == "checkbox") {
					//	if ($(this).prop("checked") == false) {
					//		return false;
					//	}
					//} else
					if ($(settings.depend).val() == "") {
						return false;
					}
				}

				if (this.type == "select-one") {
					if ($(this).val() == "") {
						errmsg = settings.msg || "須選擇";
						errflag = true;
					}
				} else if (this.type == "textarea") {
					if ($(this).val() == "") {
						errmsg = settings.msg || "不可空白";
						errflag = true;
					}
				} else if (this.type == "radio") {
					if ($(this).prop("checked") == false) {
						errmsg = settings.msg || "radio須勾選";
						errflag = true;
					}
				} else if (this.type == "checkbox") {
					if ($(this).prop("checked") == false) {
						errmsg = settings.msg || "check須選擇";
						errflag = true;
					}
				} else {
					if ($(this).val() == "") {
						errmsg = settings.msg || "不可空白";
						errflag = true;
					}
				}
				//console.log($(this).index());
				//console.log($(this).parents("td:first").find(".errlog").index());
				//console.log($(this).parents("td:first").children(":gt("+$(this).index()+").errlog:first").length+",errmsg="+errmsg);

				if (errmsg != "") {
					//$(this).parents("td:first").find(".errlog").html(errmsg);
					//$(this).nextAll(".errlog:eq(0)").html(errmsg);
					$(this).addClass("chkError");
					$(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html((settings.br ? "<BR>" : "") + errmsg);
				} else {
					if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html() == "") {
						$(this).removeClass("chkError");
					}
				}
			});
			return errflag;
		}
	});
	//#endregion

	//#region chkNumber 
	$.fn.extend({
		chkNumber: function (option) {
			var defaults = {
				msg: "",
				br: false,
				min: null,
				max: null,
				require: false
			};

			var settings = $.extend(defaults, option || {});
			var errflag = false;

			this.each(function () {
				var errmsg = "";
				if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").length == 0) {
					$(this).parents("td:first").append("<span class='errlog'></span>");
				}

				if (this.type == "text") {
					if (settings.require && $(this).val() == "") {
						errmsg = settings.msg || "須輸入數值";
						errflag = true;
					} else if (isNaN($(this).val())) {
						errmsg = settings.msg || "須為數值";
						errflag = true;
					} else if (settings.min != null && parseFloat($(this).val()) < settings.min) {
						errmsg = settings.msg || "須>=" + settings.min;
						errflag = true;
					}
				}

				if (errmsg != "") {
					$(this).addClass("chkError");
					$(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html((settings.br ? "<BR>" : "") + errmsg);
				} else {
					if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html() == "") {
						$(this).removeClass("chkError");
					}
				}
			});
			return errflag;
		}
	});
	//#endregion

	//#region chkDate
	$.fn.extend({
		chkDate: function (option) {
			var defaults = {
				msg: "",
				br: false,
				require: false
			};

			var settings = $.extend(defaults, option || {});
			var errflag = false;

			this.each(function () {
				var errmsg = "";
				if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").length == 0) {
					$(this).parents("td:first").append("<span class='errlog'></span>");
				}
				if (this.type == "text") {
					if ($(this).val() != "") {
						if (!$.isDate($(this).val())) {
							errmsg = settings.msg || "日期格式錯誤，請重新輸入!!! 日期格式:YYYY/MM/DD";
							errflag = true;
						}
					} else {
						if (settings.require) {
							errmsg = settings.msg || "日期格式錯誤，請重新輸入!!! 日期格式:YYYY/MM/DD";
							errflag = true;
						}
					}
				}

				if (errmsg != "") {
					$(this).addClass("chkError");
					$(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html((settings.br ? "<BR>" : "") + errmsg);
				} else {
					if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html() == "") {
						$(this).removeClass("chkError");
					}
				}
			});
			return errflag;
		}
	});
	//#endregion

	//#region chkRequireGrp
	$.fn.extend({
		chkRequireGrp: function (option) {
			var defaults = {
				msg: "",
				br: false,
				alert: true,
				extcheck: function (hasFlag) { }
			};

			var settings = $.extend(defaults, option || {});
			var errflag = false;
			var errmsg = "";
			var hasFlag = false;

			hasFlag = settings.extcheck(hasFlag);
			this.each(function () {
				//if (this.type == "radio" || this.type == "checkbox") {
				//	if ($(this).prop("checked") != true) {
				//		hasFlag = hasFlag || true;
				//	}
				//} else
				//alert($(this).val());
				if ($(this).val() != "") {
					hasFlag = hasFlag || true;
				}
				//if (window.console) {
				//	console.log(this.type + "..hasFlag.." + hasFlag);
				//}
			});

			if (!hasFlag) {
				errflag = true;
				if (settings.alert) {
					alert(settings.msg || "至少輸入一項!!");
				} else {
					this.each(function () {
						if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").length == 0) {
							$(this).parents("td:first").append("<span class='errlog'></span>");
						}

						errmsg = settings.msg || "至少輸入一項!!";
						//console.log(errmsg);
						$(this).addClass("chkError");
						$(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html((settings.br ? "<BR>" : "") + errmsg);
					});
				}
			} else {
				this.each(function () {
					if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html() == "") {
						$(this).removeClass("chkError");
					}
				});
			}
			return errflag;
		}
	});
	//#endregion

	//#region chkLength
	$.fn.extend({
		chkLength: function (option) {
			var defaults = {
				msg: "",
				br: false,
				max:0
			};

			var settings = $.extend(defaults, option || {});
			var errflag = false;

			this.each(function () {
				var errmsg = "";

				if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").length == 0) {
					$(this).parents("td:first").append("<span class='errlog'></span>");
				}

				if ($.BLen($(this).val()) > settings.max) {
					errmsg = settings.msg || "長度過長，請檢查！";
				}
				
				if (errmsg != "") {
					//$(this).parents("td:first").find(".errlog").html(errmsg);
					//$(this).nextAll(".errlog:eq(0)").html(errmsg);
					$(this).addClass("chkError");
					$(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html((settings.br ? "<BR>" : "") + errmsg);
				} else {
					if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html() == "") {
						$(this).removeClass("chkError");
					}
				}

			});
			return errflag;
		}
	});
	//#endregion

	//#region chkErrorExt
	$.fn.extend({
		chkErrorExt: function (option) {
			var defaults = {
				msg: "資料有誤，請檢查!!",
				br: false,
				alert: false,
				checkErr: function (extFlag) { }
			};

			var settings = $.extend(defaults, option || {});
			var errflag = false;

			errflag = settings.checkErr(settings);

			if (errflag) {
				if (settings.alert) {
					alert(settings.msg);
				} else {
					this.each(function () {
						if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").length == 0) {
							$(this).parents("td:first").append("<span class='errlog'></span>");
						}
						$(this).addClass("chkError");
						$(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html((settings.br ? "<BR>" : "") + settings.msg);
					});
				}
			} else {
				this.each(function () {
					if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html() == "") {
						$(this).removeClass("chkError");
					}
				});
			}

			return errflag;
		}
	});
	//#endregion

	//#region getOption
	$.fn.extend({
		getOption: function (option) {
			var obj = $(this);
			var defaults = {
				debug: false,
				url: "",
				type: "post",
				dataType: "xml",
				data: null,
				async: false,
				showEmpty: true,
				valPartSymbol:";",
				value: [0],
				textPartSymbol: "_",
				text: [1],
				firstOpt: "",
				lastOpt: "",
				preValue: ""
			};
			var settings = $.extend(defaults, option || {});  //初始化
			var debugurl = settings.url + "?" + unescape(unescape($.param(settings.data)));

			if (settings.debug) window.open(debugurl);

			return this.each(function () {
				$.ajax({
					url: settings.url,
					type: settings.type,
					dataType: settings.dataType,
					data: settings.data,
					async: settings.async,
					success: function (xml) {
						var opt = "";
						if (settings.firstOpt!="") {
							opt += settings.firstOpt;
						}
						if (settings.showEmpty) {
							opt += '<option value="" style="COLOR:blue">請選擇</option>';
						}

						var rows = $(xml).find("XMLRoot");
						for (var i = 0 ; i < rows.length; i++) {
							var value = "";
							$.each(settings.value, function (idx, v) {
								if (jQuery.type(v) === "number") {
									value += (value != "" ? settings.valPartSymbol : "") + $(rows[i]).find(":eq(" + v + ")").text();
								} else if (jQuery.type(v) === "string") {
									value += (value != "" ? settings.valPartSymbol : "") + $(rows[i]).find(v).text();
								}
							});

							var txt = "";
							$.each(settings.text, function (idx, v) {
								if (jQuery.type(v) === "number") {
									txt += (txt != "" ? settings.textPartSymbol : "") + $(rows[i]).find(":eq(" + v + ")").text();
								} else if (jQuery.type(v) === "string") {
									txt += (txt != "" ? settings.textPartSymbol : "") + $(rows[i]).find(v).text();
								}
							});
							var selected = "";
							if (settings.preValue == value) {
								selected = " selected";
							}
							opt += '<option value="' + value + '"'+selected+'>' + txt + '</option>';
						}
						if (settings.lastOpt != "") {
							opt += settings.lastOpt;
						}
						obj.html(opt);
					},
					error: function (xhr) {
						//window.open(debugurl);
						alert("載入查詢清單發生錯誤!!");
					}
				});
			});
		}
	});
	//#endregion
})(jQuery);

