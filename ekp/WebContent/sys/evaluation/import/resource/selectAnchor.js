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
			var left = e.clientX - 120, top = e.clientY + sh + 20;
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

	// 在某个已存在的对象后面插入节点--参考fckeditor实现
	function insertAfterNode(existingNode, newNode) {
		return existingNode.parentNode.insertBefore(newNode,
				existingNode.nextSibling);
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
		if (_____comparison == -1 && _____container && _____container.nodeType === 3) {
			insertAfterNode(_____container, cons);
		} else {
			if (_____node.previousSibling) {
				var outHTML = _____node.previousSibling.outerHTML;
				var node = _____node.previousSibling;
				if(outHTML && (outHTML == "<br>" || outHTML == "</br>")){//IE中，避免插入在换行符后
					node = _____node.previousSibling.previousSibling;
				}
				insertAfterNode(node, cons);
			} else {
				_____container.insertBefore(cons, _____container[getNodeIndex(_____node)])
			}
		}
		_____node.parentNode.removeChild(_____node);
	}

	var txt = "", range;
	if (document.selection) {
		range = document.selection.createRange();
		insertAfterRange(range, cons);
		// range.collapse(false);
		// range.pasteHTML(cons.outerHTML);
	} else {
		//获取全局选中节点
		var pos = _posOther, container = _endContainerOther;
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

var _____node ;
var _____container;
var _____comparison;
//包含范围的结束点的 Document 节点
var _endContainerOther;
//选中文字结束点位置
var _posOther;

var UNDEF = "undefined", CHAR = "character", STE = "StartToEnd", ETE = "EndToEnd";
//获取选中区域
var funGetSelect = function() {
	if (document.selection) {
		var range = document.selection.createRange(); // IE
		range.collapse(false);
		var workingRange = range.duplicate(), comparison;
		var containerElement = range.parentElement();
		_____node= getDocument(containerElement).createElement('span');
		
		do {
			containerElement.insertBefore(_____node, _____node.previousSibling);
			workingRange.moveToElementText(_____node);
		} while ((_____comparison = workingRange.compareEndPoints(STE, range)) > 0
				&& _____node.previousSibling);
		_____container = _____node.nextSibling;
		if (_____comparison == -1 && _____container && _____container.nodeType === 3) {

			workingRange.setEndPoint(ETE, range);
			var offset;
			if (/[\r\n]/.test(_____node.data)) {
				var tempRange = workingRange.duplicate();
				var rangeLength = tempRange.text.replace(/\r\n/g, "\r").length;
				offset = tempRange.moveStart(CHAR, rangeLength);
				while ((_____comparison = tempRange.compareEndPoints(STE, tempRange)) == -1) {
					offset++;
					tempRange.moveStart(CHAR, 1);
				}
			} else {
				offset = workingRange.text.length;
			}
			_____container.splitText(offset);
		}

	} else {//其他标准浏览器
		var _rangeOther = document.getSelection().getRangeAt(0);
		 _posOther = _rangeOther.endOffset;
		 _endContainerOther = _rangeOther.endContainer;
	}
};


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


