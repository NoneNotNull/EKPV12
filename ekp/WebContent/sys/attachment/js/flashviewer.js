document.writeln("<link rel=stylesheet href='" + Com_Parameter.ContextPath
		+ "sys/attachment/js/popup.css'/>");
function _popup_(setting) {

	var vbody = this;
	var opts = {
		width : 200,
		height : 100,
		title : "&nbsp;",
		content : "",
		url : "",
		autoOpen : true,
		showClose : true,
		showMini : false,
		status : null,
		handler : function(but) {
		}
	};
	var markHtml = '<iframe style="filter:alpha(opacity=0);-moz-opacity:0;opacity: 0;" width="100%" height="100%" frameborder="0" scrolling="no" src=""></iframe>';
	var markMini = "<span id='_popup_restore' style='line-height:50px;width:100px;display:block;height:50px;color:red;text-align:center'>"
			+ Attachment_MessageInfo["opt.return"] + "</span>";

	(function(target, source) {
		if (Object.prototype.toString.call(source) === '[object Array]') {
			var i = 0, len = source.length;
			for (; i < len; i++) {
				target[i] = arguments.callee(source[i]);
			}
			return target;
		}
		if (typeof source === 'object') {
			var i;
			for (i in source) {
				target[i] = arguments.callee(source[i]);
			}
			return target;
		}
		return target;
	}(opts, setting));

	var exists = function(o) {
		return (typeof(o) != "undefined" && o != null);
	};
	var hello = function(e) {
		alert(e);
	};
	var pageWidth = function() {
		return window.innerWidth != null
				? window.innerWidth
				: document.documentElement
						&& document.documentElement.clientWidth
						? document.documentElement.clientWidth
						: document.body != null
								? document.body.clientWidth
								: null;
	};
	var pageHeight = function() {
		return window.innerHeight != null
				? window.innerHeight
				: document.documentElement
						&& document.documentElement.clientHeight
						? document.documentElement.clientHeight
						: document.body != null
								? document.body.clientHeight
								: null;
	};
	var posLeft = function() {
		return typeof window.pageXOffset != 'undefined'
				? window.pageXOffset
				: document.documentElement
						&& document.documentElement.scrollLeft
						? document.documentElement.scrollLeft
						: document.body.scrollLeft
								? document.body.scrollLeft
								: 0;
	};
	var posTop = function() {
		return typeof window.pageYOffset != 'undefined'
				? window.pageYOffset
				: document.documentElement
						&& document.documentElement.scrollTop
						? document.documentElement.scrollTop
						: document.body.scrollTop ? document.body.scrollTop : 0;
	};

	// /////////////////////////////////////
	var relocation = function() {
		var _popup_mask = document.getElementById('_popup_mask');
		if (_popup_mask != null
				&& (_popup_mask.style.display == 'block' || _popup_mask.style.display == "")) {

			if (opts.status == "open") {
				_popup_mask.style.width = pageWidth() + posLeft() + "px";
				_popup_mask.style.height = pageHeight() + posTop() + "px";
				_popup_mask.style.top = "0px";
				_popup_mask.style.left = "0px";
				_popup_mask.style.display = '';

				var _popup_ = document.getElementById('_popup_');
				_popup_.style.display = '';
				_popup_.style.height = pageHeight() + posTop() + "px";
				_popup_.style.left = (pageWidth() - opts.width) / 2 + posLeft()
						+ "px";
				_popup_.style.top = (pageHeight() - opts.height) / 2 + posTop()
						+ "px";
				_popup_.style.width = opts.width + "px";
				_popup_.style.height = opts.height + "px";
			}
			if (opts.status == "mini") {
				_popup_mask.style.left = "2px";
				_popup_mask.style.top = pageHeight() + posTop() - 52 + "px";
			}
		}
	};
	var close = function() {
		if (opts.onClose) {
			opts.onClose();
		}
		var _popup_mask = document.getElementById('_popup_mask'), _popup_ = document
				.getElementById('_popup_');
		_popup_mask.parentNode.removeChild(_popup_mask);
		// 关闭div优先清除iframe中flash对象
		var _iframe = _popup_.getElementsByTagName('iframe')[0];
		var _objs = _iframe.contentWindow.document
				.getElementsByTagName('object');
		for (var i = 0; i < _objs.length; i++)
			_objs[i].parentNode.removeChild(_objs[i]);

		_popup_.parentNode.removeChild(_popup_);
	};
	var restore = function() {
		var _popup_mask = document.getElementById('_popup_mask');
		_popup_mask.innerHTML = markHtml;
		opts.status = "open";
		relocation();
	};
	var mini = function() {
		var _popup_mask = document.getElementById('_popup_mask');
		var _popup_ = document.getElementById('_popup_');
		_popup_.style.display = "none";
		_popup_mask.style.left = "2px";
		_popup_mask.style.top = pageHeight() + posTop() - 52 + "px";
		_popup_mask.style.height = "50px";
		_popup_mask.style.width = "100px";
		_popup_mask.innerHTML = markMini;
		if (document.getElementById('_popup_restore')) {
			document.getElementById('_popup_restore').onclick = function() {
				restore();
			};
		}
		opts.status = "mini";
	};
	var show = function() {
		var divmark = document.getElementById('_popup_mask'), divpopup = document
				.getElementById('_popup_'), divtitle = document
				.getElementById('_popup_title'), divcontent = document
				.getElementById('_popup_content');
		divtitle.innerHTML = opts.title;
		if (opts.url != null) {
			divcontent.innerHTML = [
					"<iframe frameborder='0' width='100%' scrolling='no' height='",
					opts.height, //
					"' src='", //
					opts.url, //
					"'></iframe>"].join('');
		} else {
			divcontent.innerHTML = opts.content;
		}
		divcontent.style.height = opts.height + "px";
		if (opts.width == 0) {
			opts.width = 300;
		}
		if (opts.height == 0) {
			opts.height = 160;
		}
		opts.height = opts.height + 25;
		divmark.style.width = pageWidth() + posLeft() + "px";
		divmark.style.height = pageHeight() + posTop() + "px";
		divmark.style.display = 'block';
		divpopup.style.left = (pageWidth() - opts.width) / 2 + posLeft() + "px";
		divpopup.style.top = (pageHeight() - opts.height) / 2 + posTop() + "px";
		divpopup.style.width = opts.width + "px";
		divpopup.style.display = 'block';

		if (document.getElementById('_popup_close')) {
			document.getElementById('_popup_close').onclick = function() {
				close();
			};
		}

		if (document.getElementById('_popup_mini')) {
			document.getElementById('_popup_mini').onclick = function() {
				mini();
			};
		}
		window.onresize = relocation;
		window.onscroll = relocation;
		opts.status = "open";
	};
	var initApp = function() {
		// ///alert(vbody.selector)
		if (document.getElementById('_popup_mask') == null) {
			var _popup_mask_div_ = document.createElement('div');
			_popup_mask_div_.setAttribute("id", "_popup_mask");
			_popup_mask_div_.style.cssText = ['position:absolute;',
					'z-index:99999999;', 'top:0px;', 'left:0px;',
					'opacity:0.4;', 'background-color:#000;', 'display:none;',
					'filter:alpha(opacity=40);'].join('');
			_popup_mask_div_.innerHTML = markHtml;
			document.body.appendChild(_popup_mask_div_);
		}
		if (document.getElementById('_popup_') != null) {
			var _popup_ = document.getElementById('_popup_');
			_popup_.parentNode.removeChild(_popup_);
		}
		var _popup_div_ = document.createElement('div');
		_popup_div_.setAttribute("id", "_popup_");
		_popup_div_.style.cssText = ["position:absolute;",
				"z-index:100000000;", "background-color:#ffffff;",
				"display:none"].join('');
		var _popup_div_html = "<div id='_popup_header' style='height:25px;cursor:move;'>"
				+ "<span id='_popup_title' style='float: left;height:25px;line-height:25px;padding-left:5px;'>"
				+ "</span>";
		if (opts.showClose) {
			_popup_div_html += "<span id='_popup_close' class='popup_close' style='float: right;cursor:pointer;height:25px;width:40px;text-align: right;'><a href='#'></a></span>";
		}
		if (opts.showMini) {
			_popup_div_html += "<span id='_popup_mini' class='popup_mini' style='float: right;cursor:pointer;height:25px;width:40px;text-align: right;'><a href='#'></a></span>";
		}
		_popup_div_html += "</div><div id='_popup_content' style=\"height: 30px; line-height: 30px; text-align: center;\"></div>";

		_popup_div_.innerHTML = _popup_div_html;
		document.body.appendChild(_popup_div_);
		if (opts.autoOpen) {
			show();
		}
	};
	// /////////////////////////////////////
	initApp();
	return {
		hello : hello,
		exists : exists,
		show : show,
		close : close
	};
}

function mouseWheel(evt) {
	evt = window.event || evt;
	try {
		document.getElementById("att_swf_viewer")
				.mouseWheelScroll(evt.wheelDelta);
	} catch (e) {
	}
	if (evt.preventDefault) {
		evt.preventDefault();
	} else {
		evt.returnValue = false;
	}
}

function createFlashViewer(divid, swfUrl, pageCount) {
	var htmlArray = new Array();
	if (Com_Parameter.IE) {
		htmlArray
				.push('<object id="att_swf_viewer" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" style="cursor:pointer;width:100%">');
		htmlArray.push('<param name="wmode" value="window">');
		htmlArray.push('<param name="allowFullScreen" value="true">');
		htmlArray.push('<param name="movie" value="'
				+ Com_Parameter.ContextPath
				+ 'sys/attachment/swf/viewer.swf" />');
		htmlArray.push('<param name="flashVars" value="docurl=', swfUrl,
				'&pagecount=', pageCount, '&pageType=swf"/>');
		htmlArray.push('<param name="quality" value="high" />');
		htmlArray.push('</object>');
	} else {
		htmlArray
				.push('<embed id="att_swf_viewer" src="'
						+ Com_Parameter.ContextPath
						+ 'sys/attachment/swf/viewer.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" style="width:100%;height:350px;"');
		htmlArray.push(' allowFullScreen=true ');
		htmlArray.push(' flashVars="docurl=', swfUrl, '&pagecount=', pageCount,
				'&pageType=swf"></embed>');
	}
	document.getElementById(divid).innerHTML = htmlArray.join("");

	var objViewer = document.getElementById('att_swf_viewer');
	if (objViewer) {
		if (objViewer.addEventListener) {
			objViewer.addEventListener("mousewheel", mouseWheel, false);
			// firefox不支持mousewheel--替代方案是DOMMouseScroll
			objViewer.addEventListener("DOMMouseScroll", mouseWheel, false);
		} else if (objViewer.attachEvent) {
			objViewer.attachEvent("onmousewheel", mouseWheel);
		}
	}
}

// aop
function aopConstructor(object) {
	object.setupAopConstructor = function(method) {
		// alert(! ('original_' + method in object));
		if (!(object['original_' + method])) {
			object['original_' + method] = object[method];
			object['before_' + method] = [];
			object['after_' + method] = [];
			object[method] = function() {
				var i;
				var b = this['before_' + method];
				var a = this['after_' + method];
				var rv, flag = true;// 是否停止元方法执行
				// alert( b.length);
				for (i = 0; i < b.length; i++) {
					flag = b[i].call(this, arguments);
				}
				if (flag) {
					rv = this['original_' + method](arguments);
					for (i = 0; i < a.length; i++) {
						a[i].call(this, arguments);
					}
				}
				return rv;
			}
		}
	};
	object.before = function(method, f) {
		object.setupAopConstructor(method);
		object['before_' + method].unshift(f);
	};

	object.after = function(method, f) {
		object.setupAopConstructor(method);
		object['after_' + method].push(f);
	};
	object.start = true;
}

var flasview = {
	original : function(args) {
		var win = new _popup_({
					"isPopUp" : true,
					"width" : 600,
					"height" : 500,
					"title" : args[0],
					"url" : args[1]
				});
	}
}
function attachmentDocShow(xtitle, xurl, fdId) {
	// 对象绑定
	aopConstructor(flasview);
	// 注册元方法
	flasview.setupAopConstructor('original');
	// 前后切面
	if (typeof(flashviewr_before) != 'undefined') {
		flasview.before('original', flashviewr_before);
	}
	if (typeof(flashviewr_after) != 'undefined') {
		flasview.before('original', flashviewr_after);
	}
	// 调用代理对象
	flasview.original(xtitle, xurl, fdId);

}