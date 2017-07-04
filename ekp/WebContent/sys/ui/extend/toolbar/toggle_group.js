var topDom = null;
var contentDom = null;
function createFrame() {
	topDom = $("<div class='lui_toolbar_btn_frame_togglegroup'></div>");
	contentDom = $("<div class='lui_toolbar_content'></div>").appendTo(topDom);
}
function createLayout(html) {
	var tr = $("<tr lui-button-group-container='1'/>");
	$("<td/>").append(html).appendTo(tr);
	return tr;
}
function getLayoutTable() {
	var tableObj = contentDom.find("table");
	if (tableObj.length <= 0) {
		tableObj = $("<table class='lui_toolbar_togglegroup_tab'/>").appendTo(
				contentDom);
		$('<tbody class="lui_toolbar_btn_selectTitle" />').appendTo(tableObj);
	}
	return tableObj;
}
function createButton(button, i) {
	var btnLayout = $(
			"<div class='lui_toolbar_btn' data-lui-on-class='lui_toolbar_btn_on '"
					+ " data-lui-status-class='lui_toolbar_btn_toggle_on'></div>")
			.attr('data-lui-group-index', i);
	var btnContent = $(
			"<div class='lui_toolbar_btn_l' data-lui-mark='toolbar_button_inner'></div>")
			.appendTo(btnLayout);
	btnContent = $("<div class='lui_toolbar_btn_r'></div>")
			.appendTo(btnContent);
	btnContent = $(
			"<div class='lui_toolbar_btn_c' data-lui-mark='toolbar_button_content'></div>")
			.appendTo(btnContent);
	button.setLayout(btnLayout);
	button.draw();
	return btnLayout;
}

function _getLayoutTable() {
	var tableObj = contentDom.find("table");
	var tbody = getSelectBox();
	if (tbody.length <= 0) {
		tbody = $('<tbody class="lui_toolbar_btn_selectBox" />').appendTo(
				tableObj);
	}
	return tbody;
}

function addButton(button) {
	createLayout(createButton(button, 0)).appendTo(getLayoutTable());
}

function _addButton(button, i) {
	createLayout(createButton(button, i)).appendTo(_getLayoutTable());
}

function removeButton(button) {
	var tdContent = button.element.parents('tr[lui-button-container="1"]');
	button.erase();
	tdContent.remove();
}

function redrawButton() {
	drawButton();
}

function drawButton() {
	var buttons = layout.toolbar.buttons;
	if (buttons.length > 0) {
		var showButtons = $.grep(buttons, function(button, index) {
			return button.visible;
		});
		var groupButtons = showButtons.sort(function(oneBtn, twoBtn) {
			if (oneBtn.isSelected())
				return -1;
			if (twoBtn.isSelected())
				return 1;
			return oneBtn.groupOrder - twoBtn.groupOrder;
		});
		if (groupButtons.length > 1) {
			addButton(groupButtons[0]);
			for (var i = 1; i < groupButtons.length; i++) {
				_addButton(groupButtons[i], i);
			}
		}
	}
	bindEvent();
}

function bindEvent() {
	bindTitleEvent();
	bindBoxEvent();
	bindGlobalHide();
}

function unBindEvent() {
	unBindBoxEvent();
	unBindTitleEvent();
	unBindGlobalHide();
}

function getSelectBox() {
	return contentDom.find('.lui_toolbar_btn_selectBox');
}

function getSelectTitle() {
	return contentDom.find('.lui_toolbar_btn_selectTitle');
}

function bindGlobalHide() {
	$(window).on('scroll', _boxHide);
	$(document).on('click', _boxHide);
}

function unBindGlobalHide() {
	$(window).unbind('scroll', _boxHide);
	$(document).unbind('click', _boxHide);
}

function _boxHide() {
	var __box = getSelectBox();
	__box.hide();
}

function unBindBoxEvent() {
	var __box = getSelectBox();
	__box.unbind('click');
}

function unBindTitleEvent() {
	var __title = getSelectTitle();
	__title.unbind('click');
}

function bindBoxEvent() {
	var __box = getSelectBox();
	var __title = getSelectTitle();
	__box.on('click', function(evt) {
		var $parent = $(evt.target);
		while ($parent.length > 0) {
			if ($parent.attr('lui-button-group-container') == '1') {
				_boxHide();
				__title.find('[lui-button-group-container = "1"]').prependTo(
						__box);
				$parent.appendTo(__title);
				break;
			}
			$parent = $parent.parent();
		}
	});
}
function bindTitleEvent() {
	var __title = getSelectTitle();
	var __box = getSelectBox();
	__title.on('click', function(evt) {
		var $parent = $(evt.target);
		while ($parent.length > 0) {
			if ($parent.hasClass('lui_toolbar_btn_selectTitle')) {
				if (__box.css('display') == 'none')
					__box.slideDown('fast');
				else
					__box.slideUp();
				evt.stopPropagation();
				break;
			}
			$parent = $parent.parent();
		}
	});
}

// 用于记录下拉位置
seajs.use([ 'lui/topic' ], function(topic) {
	topic.subscribe('toggle.change', function(evt) {
		var buttons = layout.toolbar.buttons, len = buttons.length;
		if (len < 1)
			return;

		var gb = buttons.sort(function(o, t) {
			return o.groupOrder - t.groupOrder;
		});

		for (var i = 0, j = 2; i < gb.length; i++) {
			if (gb[i].cid == evt.cid)
				gb[i].groupOrder = 0;
			else {
				if (gb[i].groupOrder == 0)
					gb[i].groupOrder = 1;
				else {
					gb[i].groupOrder = j;
					j++;
				}
			}
		}
	});
});
createFrame();
drawButton();
layout.toolbar.onErase(function() {
	unBindEvent();
});
layout.toolbar.on("addButton", addButton);
layout.toolbar.on("removeButton", removeButton);
layout.toolbar.on("redrawButton", redrawButton);
layout.toolbar.onErase(function() {
	layout.toolbar.off('addButton', addButton);
	layout.toolbar.off('removeButton', removeButton);
	layout.toolbar.off("redrawButton", redrawButton);
});

if (layout.toolbar.parent) {
	var __layout = layout.toolbar.parent.layout;
	function resizeWidth() {
		if (!layout.toolbar.parentLayoutLoaded)
			return;

		var box = getSelectBox(), w = box.width(), title = getSelectTitle(), _w = title
				.width(), ___w = Math.max(w, _w);
		if (___w == 0)
			return;
		var table = getLayoutTable();
		box.hide();
		box.css({
			'position' : 'absolute',
			'width' : ___w
		});
		table.find('[data-lui-group-index]').css('width', ___w);
		table.css('width', ___w);
	}

	layout.on('html', resizeWidth);
	__layout.on('html', resizeWidth);
	__layout.on('redrawed', resizeWidth);
}
done(topDom);
