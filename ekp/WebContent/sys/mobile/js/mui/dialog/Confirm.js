define([ "dojo/_base/declare", "dojo/dom-construct", "mui/dialog/Dialog" ],
		function(declare, domConstruct, Dialog) {
			return function(html, title, callback) {
				var _title = title ? title : "提示";
				var _html = html ? html : "";
				var contentNode = domConstruct.create('div', {
					className : 'muiConfirmDialogElement',
					innerHTML : '<div>' + _html + '</div>'
				});

				var options = {
					'title' : title ? title : '提示',
					'showClass' : 'muiConfirmDialogShow',
					'element' : contentNode,
					'scrollable' : false,
					'parseable' : false,
					'buttons' : [ {
						title : "取消",
						fn : function(dialog) {
							dialog.hide();
							callback(false, dialog);

						}
					}, {
						title : "确定",
						fn : function(dialog) {
							dialog.hide();
							callback(true, dialog);
						}
					} ]
				};
				return Dialog.element(options);
			};
		});