
(function() {
	if (window.$ == null) {
		seajs.use(['lui/jquery'], function($) {
			SysPersonUtils($);
			window.$ = $;
		});
	} else {
		SysPersonUtils($);
	}
})();

function SysPersonUtils($) {
	var SysPersonEvents = [];
	function SysPersonEventRegister(selector, event, fun) {
		SysPersonEvents.push({
			'selector' : selector,
			'event' : event,
			'fun' : fun
		});
	}

	// 初始化绑定函数
	$(document).ready(function() {
		if ($('#list_div').length > 0) {
			$.each(SysPersonEvents, function() {
				$(document).delegate(this.selector, this.event, this.fun);
			});
		}
	});

	// 注音多个表个在一个页面的情况
	// 全选
	SysPersonEventRegister('[name="List_Tongle"]', 'click', function(event) {
		var checked = this.checked;
		$(this).closest('table').find('[name="List_Selected"]').each(function() {
			this.checked = checked;
		});
	});
	// 单选
	SysPersonEventRegister('[name="List_Selected"]', 'click', function(event) {
		var allSelected = true;
		var table = $(this).closest('table');
		table.find('[name="List_Selected"]').each(function() {
			if (!this.checked) {
				allSelected = false;
				return false;
			}
		});
		table.find('[name="List_Tongle"]').each(function() {
			this.checked = allSelected;
		});
	});
	function updateByAjax(action, method, _data, cb) {
		var data = {"method": method, "List_Selected": null, "ajax": "true"};
		if (_data) {
			for (var k in _data) {
				data[k] = _data[k];
			}
		}
		if (data["List_Selected"] == null) {
			data["List_Selected"] = [];
			var selected = $('input[name="List_Selected"]:checked');
			selected.each(function() {
				data["List_Selected"].push(this.value);
			});
		}
		function _callback(result, dialogType, loading) {
			if (window.seajs) {
				seajs.use(['lui/dialog'], function(dialog) {
					dialog[dialogType](result.msg || result.responseJSON.msg, $('#lui_list_body_frame_div'));
				});
			}
			else {
				alert(result.msg);
			}
			if (cb) {
				try {
					cb(dialogType, selected);
				} catch (e) {
					if (window.console) {
						console.error(e);
					}
				}
			}
			PersonRefreshList(loading);
		}
		function doAjax(loading) {
			$.ajax({
				type : "POST",
				url : action,
				data : $.param(data, true),
				dataType : 'json',
				success : function(result) {
					_callback(result, 'success', loading);
				},
				error : function(result) {
					_callback(result, 'failure', loading);
				}
			});
		}
		
		if (window.seajs) {
			seajs.use(['lui/dialog'], function(dialog) {
				var loading = dialog.loading('', $('#list_div'));
				doAjax(loading);
			});
		} else {
			doAjax();
		}
	}
	window.PersonCheckSelect = function() {
		if ($('input[name="List_Selected"]:checked').length == 0) {
			if (window.seajs) {
				seajs.use(['lui/dialog'], function(dialog) {
					dialog.alert(window.placeSelectOptionDatas ? placeSelectOptionDatas : "您没有选择需要操作的数据!");
				});
			} else {
				alert(window.placeSelectOptionDatas ? placeSelectOptionDatas : "您没有选择需要操作的数据!");
			}
			return false;
		}
		return true;
	};
	function checkDeleteSysLink() {
		if ($('[data-syslink] input[name="List_Selected"]:checked').length > 0) {
			seajs.use(['lui/dialog'], function(dialog) {
				dialog.alert(sysDelInfo);
			});
			return false;
		}
		return true;
	}
	function comfirmDelete(doDel) {
		var info = window.comfirmDeleteInfo ? comfirmDeleteInfo : "确认删除选中数据？";
		if (window.seajs) {
			seajs.use(['lui/dialog'], function(dialog) {
				dialog.confirm(info, function(flag) {
					if (flag)
						doDel();
				});
			});
		} else if (confirm(info)) {
			doDel();
		}
	}
	window.PersonRefreshList = function(loading) {
		loading = loading || null;
		if (window.seajs && loading == null) {
			seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
				loading = dialog.loading('', $('#list_div'));
				doRefresh(loading);
			});
		} else {
			doRefresh(loading);
		}
		function doRefresh(loading) {
			var method = $('#list_div').attr('data-refresh') || 'list';
			var path = document.forms[0].action;
			path = Com_SetUrlParameter(path, 'method', method);
			$.ajax({
				url: path,
				dataType: "html",
				data: {'forward': 'fragment'},
				success: function(html) {
					$('#list_div').html(html);
				},
				complete: function() {
					if (loading) {
						loading.hide();
					}
				}
			});
		}
	};
	window.PersonOnDeleteAll = function(ajax) {
		function doDel() {
			if (ajax === true)
				updateByAjax(document.forms[0].action, 'deleteall', {});
			else
				Com_Submit(document.forms[0], 'deleteall');
		}
		if (PersonCheckSelect() && checkDeleteSysLink()) {
			comfirmDelete(doDel);
		}
	};
	window.PersonOnUpdateStatus = function(status, ajax) {
		if (!PersonCheckSelect()) {
			return;
		}
		if ($('[name="status"]').length > 0) {
			$('[name="status"]').val(status);
		} else {
			$('<input type="hidden" name="status" value="' + status +'">').appendTo(document.forms[0]);
		}
		if (ajax === true) {
			updateByAjax(document.forms[0].action, 'updateStatus', {"status": status});
		} else
			Com_Submit(document.forms[0], 'updateStatus');
	};
	// 行url
	SysPersonEventRegister('.detail_table tr[data-url]', 'click', function(event) {
		var target = event.target;
		if (target.tagName == 'TD' && $(target).has('input[name="List_Selected"]').length) {
			$(target).find('input[name="List_Selected"]').each(function() {
				$(this).click();
			});
			return false;
		}
		if (target.tagName == 'TD') {
			Com_OpenWindow($(this).attr('data-url'), '_blank');
		}
	});
	// 换色
	SysPersonEventRegister('.detail_table tr[data-url]', 'mouseenter', function(event) {
		$(this).css({'background': '#6fb2eb', 'color': '#fff'});
	});
	SysPersonEventRegister('.detail_table tr[data-url]', 'mouseleave', function(event) {
		$(this).css({'background': '', 'color': ''});
	});
	
	function _GetSelectedRow() {
		var rows = [];
		$('input[name="List_Selected"]:checked').each(function(i) {
			var row = $(this).closest('tr')[0];
			rows.push(row);
		});
		return rows;
	}
	var eventObj = {};
	function SysPersonUpRow() {
		if (!PersonCheckSelect()) {
			return;
		}
		var rows = _GetSelectedRow();
		if (rows.length == 0) {
			return;
		}
		var preRow = $(rows[0]).prev();
		if (preRow.length == 0 || preRow.attr('data-url') == null) {
			return;
		}
		var tb = preRow.parent()[0];
		$.each(rows, function() {
			tb.insertBefore(this, preRow[0]);
		});
		$(eventObj).trigger("orderUpdate");
	}
	function SysPersonDownRow() {
		if (!PersonCheckSelect()) {
			return;
		}
		var rows = _GetSelectedRow();
		if (rows.length == 0) {
			return;
		}
		var nextRow = $(rows[rows.length - 1]).next();
		if (nextRow.length == 0 || nextRow.attr('data-url') == null) {
			return;
		}
		var tb = nextRow.parent()[0];
		var preRow = nextRow.next();
		if (preRow.length == 0) {
			$.each(rows, function() {
				tb.appendChild(this);
			});
			$(eventObj).trigger("orderUpdate");
			return;
		}
		$.each(rows, function() {
			tb.insertBefore(this, preRow[0]);
		});
		$(eventObj).trigger("orderUpdate");
	}
	function SysPersonUpdataOrder(ajax) {
		if (ajax === true)
			updateByAjax(document.forms[0].action, 'updateOrder', {"List_Selected": (function() {
				var result = [];
				$('input[name="List_Selected"]').each(function() {
					result.push(this.value);
				});
				return result;
			})()}, function() {
				$("#orderSaveBtn").hide();
			});
		else
			Com_Submit(document.forms[0], 'updateOrder');
	}
	function resizeOrderSaveBtn() {
		var offset = $('#upRowButton').offset();
		$('#orderSaveBtn').css({
			position:'absolute',
			left: offset.left,
			top: offset.top + $('#upRowButton').height() + 20
		});
	}
	function ShowSaveOrderBtn() {
		resizeOrderSaveBtn();
		$("#orderSaveBtn").show();
	}
	if ($('#orderSaveBtn').length > 0) {
		$(window).resize(resizeOrderSaveBtn);
		$(window).scroll(resizeOrderSaveBtn);
		$(eventObj).bind("orderUpdate", ShowSaveOrderBtn);
	}
	
	window.SysPersonUpRow = SysPersonUpRow;
	window.SysPersonDownRow = SysPersonDownRow;
	window.SysPersonUpdataOrder = SysPersonUpdataOrder;
}
