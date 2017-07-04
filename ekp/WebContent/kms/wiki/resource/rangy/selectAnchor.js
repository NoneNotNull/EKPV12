/**
 * [文本锚点事件操作]
 * 
 * @param {[type]} eleShare [浮动div]
 * @param {[type]} eleContainer [事件范围]
 */
var selectAnchor = function(eleShare, eleContainer, share) {
	eleContainer = [].concat(eleContainer);
	for (var j = 0; j < eleContainer.length; j++) {
		eleContainer[j].onmouseup = function(e) {
			e = e || window.event;
			var txt = funGetSelectTxt(), sh = window.pageYOffset
					|| document.documentElement.scrollTop
					|| document.body.scrollTop || 0;
			var left = e.clientX, top = e.clientY + sh + 20;
			if (txt) {
				if ($(eleShare).css('display') == 'none') {
					$(eleShare).slideDown();
					$(eleShare).css({
								'left' : left,
								'top' : top
							});
				}
			} else {
				if ($(eleShare).css('display') == 'block')
					$(eleShare).hide();
			}
		};
		eleContainer[j].onmousedown = function(e) {
			if ($(eleShare).css('display') == 'block')
				$(eleShare).hide();
		};
	}

	// 滚动自动隐藏分享框
	$(window).scroll(function() {
				if (eleShare.style.display == "block") {
					eleShare.style.display = "none";
				}
			});

	for (var i = 0; i < share.length; i++) {
		$('#' + share[i].id)[0].onclick = share[i].func;
	}
};

// 为选中文本后面新增dom节点
var funSetSelectTxt = function(cons) {
	var UNDEF = "undefined", CHAR = "character", STE = "StartToEnd", ETE = "EndToEnd";

	// 在某个已存在的对象后面插入节点--参考fckeditor实现
	function insertAfterNode(existingNode, newNode) {
		return existingNode.parentNode.insertBefore(newNode,
				existingNode.nextSibling);
	}

	// 返回元素的根节点
	function getDocument(node) {
		if (node.nodeType == 9) {
			return node;
		} else if (typeof node.ownerDocument != UNDEF) {
			return node.ownerDocument;
		} else if (typeof node.document != UNDEF) {
			return node.document;
		} else if (node.parentNode) {
			return getDocument(node.parentNode);
		} else {
		}
	}

	// 获取节点在统计的索引
	function getNodeIndex(node) {
		var i = 0;
		while ((node = node.previousSibling)) {
			i++;
		}
		return i;
	}

	/**
	 * [insertAfterRange 根据range在后面插入元素con--ie专用]
	 * 
	 * @param {[type]}
	 *            range，cons [事件范围，插入对象]
	 * @return {[type]} [description]
	 */

	function insertAfterRange(range, cons) {
		range.collapse(false);
		var workingRange = range.duplicate(), comparison;
		var containerElement = range.parentElement();
		var node = getDocument(containerElement).createElement('span');

		do {
			containerElement.insertBefore(node, node.previousSibling);
			workingRange.moveToElementText(node);
		} while ((comparison = workingRange.compareEndPoints(STE, range)) > 0
				&& node.previousSibling);
		var container = node.nextSibling;
		if (comparison == -1 && container && container.nodeType === 3) {

			workingRange.setEndPoint(ETE, range);
			var offset;
			if (/[\r\n]/.test(node.data)) {
				var tempRange = workingRange.duplicate();
				var rangeLength = tempRange.text.replace(/\r\n/g, "\r").length;
				offset = tempRange.moveStart(CHAR, rangeLength);
				while ((comparison = tempRange.compareEndPoints(STE, tempRange)) == -1) {
					offset++;
					tempRange.moveStart(CHAR, 1);
				}
			} else {
				offset = workingRange.text.length;
			}
			container.splitText(offset);
			insertAfterNode(container, cons);
		} else {
			if (node.previousSibling) {
				insertAfterNode(node.previousSibling, cons);
			} else {
				container.insertBefore(cons, container[getNodeIndex(node)])
			}
		}
		node.parentNode.removeChild(node);
	}

	var txt = "", range;
	if (document.selection) {
		range = document.selection.createRange();
		insertAfterRange(range, cons);
		// range.collapse(false);
		// range.pasteHTML(cons.outerHTML);
	} else {
		txt = document.getSelection();
		range = txt.getRangeAt(0);
		var pos = range.endOffset, container = range.endContainer;
		if (container.nodeType === 3) { // 文本类型需要分割为两块text再进行dom节点插入
			container.splitText(pos);
			var obj = container.nextSibling;
			// if (obj.nodeType === 3 && obj.data === '') {
			// obj = obj.nextSibling();
			// }
			// if (obj.nodeType === 1 && obj.getAttribute('e_id') != null) {
			// return;
			// }
			insertAfterNode(container, cons);
		} else {
			var n = container.childNodes[pos];
			// if (n.getAttribute('e_id') == null) {
			container.insertBefore(cons, n);
			// }
		}
	}
	return cons;
}

// 获取选中区域的文本
var funGetSelectTxt = function() {
	var txt = "";
	if (document.selection) {
		txt = document.selection.createRange().text; // IE
	} else {
		txt = document.getSelection();
	}
	return txt.toString();
};