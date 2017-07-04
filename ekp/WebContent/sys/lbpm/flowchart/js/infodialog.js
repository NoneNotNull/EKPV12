/**
 * 详细信息对话框
 */

FlowChartObject.InfoDialog = function() {
};

( function(Dialog) {
	Dialog.$ = function(name) {
		return document.getElementById(name);
	};
	Dialog.AddEventListener = function(obj, eventType, func) {
		if (obj.addEventListener) {
			obj.addEventListener(eventType, func, false);
		} else {
			obj.attachEvent("on" + eventType, func);
		}
	};
	Dialog.removeEventListener = function(obj, eventType, func) {
		if (obj.removeEventListener) {
			obj.removeEventListener(eventType, func, false);
		} else {
			obj.detachEvent("on" + eventType, func);
		}
	};
	Dialog.getMousePosition = function(event) {
		if (event.pageX || event.pageY) {
			return {
				x : event.pageX,
				y : event.pageY
			};
		}
		return {
			x : event.clientX + document.body.scrollLeft
					- document.body.clientLeft,
			y : event.clientY + document.body.scrollTop
					- document.body.clientTop
		};
	};
	Dialog.absPosition = function(node, stopNode) {
		var x = y = 0;
		for ( var pNode = node; pNode != null && pNode !== stopNode; pNode = pNode.offsetParent) {
			x += pNode.offsetLeft - pNode.scrollLeft;
			y += pNode.offsetTop - pNode.scrollTop;
		}
		x = x + document.body.scrollLeft;
		y = y + document.body.scrollTop;
		return {
			'x' : x,
			'y' : y
		};
	};
	Dialog.AddStyle = function(url) {
		var head = document.getElementsByTagName('HEAD')[0];
		var style = document.createElement('link');
		style.href = url;
		style.rel = 'stylesheet';
		style.type = 'text/css';
		head.appendChild(style);
		return style;
	};
	Dialog.resetSize = function(d, frame) {
		var height, width;
		if (frame.contentDocument && frame.contentDocument.body.offsetHeight) {
			if (window.opera) {
				height = frame.contentWindow.document.body.scrollHeight; // Opera
				width = frame.contentWindow.document.body.scrollWidth; // Opera
			} else {
				height = frame.contentDocument.body.offsetHeight + 20; // FF NS
				width = frame.contentDocument.body.offsetWidth;
			}
		} else if (frame.Document && frame.Document.body.scrollHeight) {
			height = frame.Document.body.scrollHeight + 10;// IE
			width = frame.Document.body.scrollWidth + 20;// IE
		}
		if (height != null) {
			frame.width = width + 'px';
			frame.height = height + 'px';
			d.style.width = width + 'px';
		}
	};
	Dialog.cancelBubble = function(event) {
		if(window.event) {
			window.event.cancelBubble = true;
		} else {
			if(!event) {
				event = Com_GetEventObject();
			}
			event.stopPropagation();
		}
		return false;
	};

	Dialog._initDnD = function(dialog, moveArea) {
		moveArea.style.cursor = 'move';
		Dialog.AddEventListener(moveArea, "mousedown", function() {
			if (Dialog.moveArea == null) {
				Dialog.moveArea = new Dialog.MoveArea();
			}
			var mode = FlowChartObject.Mode.Current;
			if (mode) {
				if (mode.EventChain) {
					mode.EventChain.Cancel(mode);
				}
				Dialog.curr = dialog;
				mode.EventChain = Dialog.moveArea;
				mode.EventChain.Start(mode);
			}
		});
	};
})(FlowChartObject.InfoDialog);

( function(Dialog) {
	Dialog.MoveArea = function() {
		var newElem = document.createElement("div");
		newElem.className = "infoDialog_moveArea";
		newElem.style.display = "none";
		document.body.appendChild(newElem);
		this.DOMObject = newElem;
		this.Show = false;
		this.Pos = {
			x : 0,
			y : 0
		};
	};
	Dialog.MoveArea.prototype = {
		Start : function(mode) {
			window.getSelection ? window.getSelection().removeAllRanges()
					: document.selection.empty();

			var dialog = Dialog.curr;
			var obj = this.DOMObject;
			var area = Dialog.absPosition(dialog);
			this.Pos.x = EVENT_X - area.x;
			this.Pos.y = EVENT_Y - area.y;
			
			obj.style.left = dialog.style.left;
			obj.style.top = dialog.style.top;
			obj.style.width = dialog.style.width;
			obj.style.height = dialog.style.height;
			obj.style.display = "";

			this.Show = true;
		},
		Move : function(mode) {
			if (this.Show) {
				var obj = this.DOMObject;
				obj.style.display = '';
				var x = (EVENT_X - this.Pos.x);
				var y = (EVENT_Y - this.Pos.y);
				obj.style.left = x + 'px';
				obj.style.top = y + 'px';
			}
		},
		End : function(mode) {
			if (this.Show) {
				var dialog = Dialog.curr;
				var obj = this.DOMObject;
				dialog.style.left = obj.style.left;
				dialog.style.top = obj.style.top;
				this.Cancel(mode);
			}
		},
		Cancel : function(mode) {
			if (this.Show) {
				var obj = this.DOMObject;
				obj.style.display = "none";
			}
			this.Show = false;
			Dialog.curr = null;
			mode.EventChain = null;
		}
	};
})(FlowChartObject.InfoDialog);

( function(Dialog) {
	Dialog.prototype = {
		initElement : function() {
			this.element = document.createElement("div");
			var div = this.element;
			div.className = 'showInfoDialog';
			div.innerHTML = '<div class="showInfoDialog_topbar"><div class="showInfoDialog_title">title</div>'
				+ '<div class="showInfoDialog_close">&times;</div></div>'
				+ '<iframe width="100%" height="100%" name="showInfoDialogIframe" frameborder=0></iframe>';
			div.style.display = 'none';
			this.frameElement = div.getElementsByTagName('iframe')[0];
			this.titleElement = div.getElementsByTagName('div')[0];
			document.body.appendChild(div);

			Dialog._initDnD(this.element, this.titleElement);

			var self = this;
			var close = this.titleElement.getElementsByTagName('div')[1];
			close.onmousedown = function(e) {
				self.hide();
				Dialog.cancelBubble(e);
			};
			Dialog.AddStyle('../css/infodialog.css');
		},
		setUrl : function(url) {
			this.url = url;
		},
		show : function(url) {
			if (url != null) {
				this.setUrl(url);
			}
			if (this.element == null) {
				this.initElement();
			}
			this.frameElement.src = this.url;
			this.element.style.display = '';
		},
		isShow : function() {
			return (this.element != null && this.element.style.display != 'none');
		},
		hide : function() {
			this.element.style.display = 'none';
		},
		resetSize : function() {
			Dialog.resetSize(this.element, this.frameElement);
		},
		position : function(x, y) {
			if (this.element) {
				this.element.style.top = y + 'px';
				this.element.style.left = x + 'px';
			}
		},
		size : function(w, h) {
			if (this.element) {
				this.element.style.width = w + 'px';
				this.element.style.height = h + 'px';
			}
		},
		setTitle : function(title) {
			this.titleElement.getElementsByTagName('div')[0].innerHTML = title;
		}
	};

})(FlowChartObject.InfoDialog);
