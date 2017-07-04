define(function(require, exports, module) {
	var layout = require('lui/view/layout');
	var env = require('lui/util/env');
	var $ = require('lui/jquery');
	var lang = require('lang!');

	var ___isDrawed = false;
	var getCfg = function() {

		return cfg = {
			click : '___datainitSubmit()',
			styleClass : 'com_export'
		};
	};

	var surroundBtn = function(btn) {
		if (!LUI('top'))
			return;
		btn.startup();
		LUI('top').addButton(btn);
	};

	var getIsDrawed = function() {
		return ___isDrawed;
	}

	var setIsDrawed = function(drawed) {
		___isDrawed = drawed;
	}

	window.___datainitSubmit = function() {
		seajs.use(['lui/dialog', 'lui/jquery'], function(dialog, $) {
			var select = document.getElementsByName("List_Selected");
			var values = [];
			var selected;
			for (var i = 0; i < select.length; i++) {
				if (select[i].checked) {
					values.push(select[i].value);
					selected = true;
				}
			}

			var __url = location.pathname;
			var __cxt = Com_Parameter.ContextPath;
			if (__url.indexOf(__cxt) == 0)
				__url = __url.substring(__cxt.length - 1);
			if (!selected) {
				var __fdId = Com_GetUrlParameter(location.search, 'fdId');
				if (__fdId) {
					values.push(__fdId);
					selected = true;
				}
			}
			if (selected) {
				var loading = dialog.loading();
				var __listview;
				$(select).parents("[data-lui-type]").each(function() {
							var elem = $(this);
							var module = elem.attr('data-lui-type');
							var clazz = module.split("!")[1];
							if ('ListView' == clazz) {
								__listview = LUI(elem.attr('data-lui-cid'));
							}
						});
				if (__listview)
					__url = __listview.source.url;

				require
						.async(
								env.fn
										.formatUrl('/sys/datainit/import/formName.jsp?url=')
										+ __url, function(formName) {
									$
											.post(
													env.fn
															.formatUrl('/sys/datainit/sys_datainit_main/sysDatainitMain.do?method=export&formName='
																	+ formName['formName']),
													$.param({
														"List_Selected" : values
													}, true), function(data,
															textStatus, xhr) {
														loading.hide();
														if (data.status) {
															dialog
																	.success(lang['return.optSuccess']);
														} else {
															dialog
																	.failure(lang['return.optFailure']);
														}
													}, 'json');
								});
			} else {
				dialog.alert(lang['page.noSelect']);
			}
		})
	};

	exports.surroundBtn = surroundBtn;
	exports.getCfg = getCfg;
	exports.getIsDrawed = getIsDrawed;
	exports.setIsDrawed = setIsDrawed;
});