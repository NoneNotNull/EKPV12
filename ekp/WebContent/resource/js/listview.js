/*
 * 压缩类型：标准
 * 编码格式：UTF-8
 */
Com_RegisterFile("listview.js");
Com_IncludeFile("listview.css", "style/"+Com_Parameter.Style+"/list/");

/*
 * 说明：通过AJAX方式获取数据
 */
var ListView = new Object(); // === 命名空间
ListView.version = "0.9bate1"; // === 版本

/*
 * 关于 (function(arg){})(obj);写法：
 * 第一个括号内是定义的需要执行的函数，第二个括号表示调用此函数，
 * 并把arg参数传递给前一括号定义的函数。
 * 函数里进行对象，方法，属性等定义就不需要关心自身是要绑定到什么对象（命名空间）。
 * 可以使用比较简短，或者特殊的名称
 *
 * 关于参数：
 * 主要以JSON作为参数，JSON是一种良好的描述性结构，具有很高的可读性。
 *
 * 数据格式：
 * 第一次载入数据时，输出的是JSON，在页面源代码中可以看到输出结果。
 * AJAX请求时，可以输出JSON或者XML。这个可以手动设置。
 * 假如连接中名为_ajaxtest参数不为空，将强制输出JSON或XML
 *
 * 目前问题：
 * 命名比较混乱，希望能在1.1时得到重构
 * 目前文档和说明缺乏，将在1.0版本完善
 * 有的功能并未实现，计划在1.0正式版本中实现
 * 1 shift选择
 * 2 超时设置
 * 3 第一次不载入数据和 pagemodel 的情况 
 * （由于目前每次访问list方法都将进行一次page计算，并返回数据，第一次访问不输出数据，就太消耗性能，
 * 第一次不载入数据最大的好处就是尽早返回了页面，但用户得到数据的时间实际是更长了）注：此特性并不一定实现
 * 4 大视图的支持（在大数据情况下，不进行分页计算，需要框架配合）注：在1.3版本中实现
 * 5 空行显示
 * 6 操作后的返回（在删除后，将无法返回到先前页面，而是会返回到第一页）注：在1.2版本中实现
 * 7 组合排序可能会在1.5版本得到支持，组合排序需要框架支持
 * 8 客户端托管分页计算（第一次计算分页后，第二次服务器端将不再进行计算，这需要修改现有框架）注：在1.3版本中实现
 */
(function($){
	$.Msg = {
		first: "首页",
		prev: "前页",
		next: "后页",
		last: "末页",
		reload: "刷新",
		the: "第",
		page: "页",
		total: "共",
		row: "条",
		rowPerPage: "每页",
		changeTo: "转到",
		to: "到",
		//rownum: "页数",
		mustBeInt: "必须为整数",
		imgUrl: "icons/go.gif",
		imgTitle: "转到",
		loadingHint: "请稍等！数据加载中...",
		loadedHint: "加载完成！",
		loadFailure: "数据加载失败！"
	};
	$.Now = function() {
		return +(new Date);
	};
	$.Each = function(array, fn) {
		if (array == null || fn == null) return;
		for (var i = 0; i < array.length; i ++) {
			var retValue = fn(array[i], i);
			if (retValue == true) break;
		}
	};
	$.Loop = function(array, fn) {
		if (array == null || fn == null) return;
		for (var i = array.length - 1; i >= 0; i --) {
			var retValue = fn(array[i], i);
			if (retValue == true) break;
		}
	};
	$.Extend = function(target, source) {
		if (target != null && source)
			for (var property in source) {
				target[property] = source[property];
			}
		return target;
	};
	$.Extend(String.prototype, {
		trim : function() {return this.replace(/(^\s*)|(\s*$)/g, "");},
		ltrim : function() {return this.replace(/(^\s*)/g, "");},
		rtrim : function() {return this.replace(/(\s*$)/g, "");}
	});
	$.Try = function () {
		var returnValue;
		for (var i = 0; i < arguments.length; i++) {
			var lambda = arguments[i];
			try {
				returnValue = lambda();
				break;
			} catch (e) {
				$.Log(e.toString());
			}
		}
		return returnValue;
	};
	/***** IE 添加事件 无法调用this，特用此代替 **/
	$.IEEventHandler = function(event) {
		event = event || window.event;
		var typeRef = '__' + event.type;
		if (this[typeRef]) {
			for (var ref in this[typeRef]) {
				this[typeRef][ref].call(this, event);
			}
		}
	};
	/***** 添加事件 **/
	$.AddEvent = function(obj, type, fn, useCapture) {
		if (!useCapture) useCapture = false;
		if (obj.addEventListener) {
			obj.addEventListener(type, fn, useCapture);
		} else {
			var typeRef = '__' + type;
			if (!obj[typeRef]){
				obj[typeRef] = [];
				var orgEvent = obj['on' + type];
				if (orgEvent) obj[typeRef][0] = orgEvent;
				obj['on' + type] = $.IEEventHandler;
			} else {
				for (var ref in obj[typeRef]) {
					if (obj[typeRef][ref] === fn) return;
				}
			}
			obj[typeRef][obj[typeRef].length] = fn;
		}
	};
	/****** 转换成数字 ****/
	$.Num = function(num) {
		num = parseInt(num);
		if (isNaN(num) || !(num >= -2147483648 && num <= 2147483647)) {
			alert($.Msg.mustBeInt);
			return null;
		}
		return num;
	};
	/****** 以小写获取节点小写 ****/
	$.TagName = function(dom) {
		return String(dom.tagName).toLowerCase();
	};
	$.NodeIndex = function(dom) {
		var nodes = dom.parentNode.childNodes;
		var index = -1;
		$.Each(nodes, function(node, i) {
			if (node == dom) {
				index = i;
				return true;
			}
			return false;
		});
		return index;
	};
	$.tables = []; // === 容器
	$.getTable = function(id) {
		var table = null;
		$.Each($.tables, function(t) {
			if (t.ID == id) {
				table = t;
				return true;
			}
			return false;
		});
		return table;
	};
	$.ColMaxlengthReader = function(words) {
		if (words) {
			var length = this.maxlength;
			for(var i = 0, len = 0; i < words.length; i++){
				var c = words.charAt(i);
				if(encodeURIComponent(c).length > 6)
					len += 2;
				else
					len ++;
				if(len > length)
					return words.substring(0, i - 2) + "...";
			}
		}
		return words;
	};
})(ListView);

/**
 * 调试日志台
 */
(function($){
	var Logger = function() {
		var view  = document.createElement("DIV");
		view.id = "ListView._logger.view";
		view.style.cssText = "position:absolute;background-color:orange;";
		view.style.display = "none";
		var body = document.body;
		var top = document.createElement("DIV");
		top.appendChild(document.createTextNode("====\u8c03\u8bd5\u65e5\u5fd7===="));
		document.onkeyup = function(event) {
			event = event ? event : window.event;
			if (119 == event.keyCode || 117 == event.keyCode || 118 == event.keyCode) {
				var style = document.getElementById("ListView._logger.view").style;
				style.display = (style.display == "none") ? "" : "none";
			}
		};
		view.appendChild(top);
		body.appendChild(view);
	};
	Logger.prototype = {
		log: function(info) {
			document.getElementById("ListView._logger.view").appendChild(this.getMessage(info));
		},
		getMessage: function(info) {
			var date = "+[" + new Date().toLocaleString() + "]";
			var pre = document.createElement("PRE");
			pre.innerHTML = date + info;
			return pre;
		}
	};
	$._logger = new Logger();
	$.Log = function(s) {
		$._logger.log(s);
	};
})(ListView);

(function($) {
	$.msgBox = document.createElement("div");
	$.msgBox.className = "msgBox";
	$.msgBox.style.display = "none";
	$.ShowLoading = function() {
		window.status = $.Msg.loadingHint;
		$.msgBox.style.display = "";
		$.msgBox.className += " msging";
		$.msgBox.innerHTML = $.Msg.loadingHint;
	};
	$.ShowLoadSuccess = function() {
		window.status = $.Msg.loadedHint;
		$.msgBox.style.display = "";
		$.msgBox.className = $.msgBox.className.replace(/ msging/, "");
		$.msgBox.innerHTML = $.Msg.loadedHint;
	};
	$.ShowLoadError = function() {
		window.status = $.Msg.loadFailure;
		$.msgBox.style.display = "";
		$.msgBox.className = $.msgBox.className.replace(/ msging/, "");
		$.msgBox.innerHTML = $.Msg.loadFailure;
	};
	$.HiddBox = function() {
		$.msgBox.style.display = "none";
		$.msgBox.className = $.msgBox.className.replace(/ msging/, "");
	};
	Com_AddEventListener(window, "load", function() {
		document.body.appendChild($.msgBox);
	});
})(ListView);

(function($) {
	$.Ajax = function(args) {
		return new $.Ajax.Request(args);
	}
	$.Ajax.Request = function(args) {
		$.Extend(this, args);
		this.process();
	}
	$.Ajax.Request.prototype = {
		url: location.href,
		method: "GET",
		dataType: "xml",
		timeout: 0,
		contentType: "application/x-www-form-urlencoded",
		async: true,
		params: null,
		cache: true,
		xhr: null,
		success: null,
		error: null,
		filter: null,
		accepts: {
			xml: "application/xml, text/xml",
			html: "text/html",
			script: "text/javascript, application/javascript",
			json: "application/json, text/javascript",
			text: "text/plain",
			_default: "*/*"
		},
		getXHR: function() {
			return $.Try(
				function() {return new ActiveXObject('Microsoft.XMLHTTP')},
				function() {return new ActiveXObject('Msxml2.XMLHTTP')},
				function() {return new XMLHttpRequest()}
			);
		},
		httpData: function() {
			var data = null;
			var dataType = this.dataType.toLowerCase();
			if (dataType == "xml") {
				//$.Log("[debug] xml = " + this.xhr.responseText);
				data = this.xhr.responseXML;
			} else if (dataType == "json") {
				var d = this.xhr.responseText;
				//$.Log("[debug] json = " + d);
				data = eval("(" + d + ")");
			}
			if (this.filter) {
				data = this.filter( data, dataType );
			}
			return data;
		},
		httpSuccess: function() {
			try {
				return (this.xhr.status == undefined
					|| this.xhr.status == 0
					|| (this.xhr.status >= 200 && this.xhr.status < 300)
					|| this.xhr.status == 304
					|| this.xhr.status == 1223
				);
			} catch (e) {
				$.Log(e.description);
			}
			return false;
		},
		handleError: function(e) {
			if (this.error) {
				this.error( this.xhr, e );
			} else {
				this.defaultEorrer(this.xhr);
			}
		},
		processParam: function(thisData) {
			var s = [];
			if (null == thisData) return null;
			$.Each(thisData, function(p) {
				s.push(encodeURIComponent(p.name) + "=" + encodeURIComponent(p.value));
			});
			return s.join("&");
		},
		processUrl: function() {
			this.method = this.method.toUpperCase();
			if (this.cache === true && this.method == "GET") {
				var ts = $.Now();
				this.url = Com_SetUrlParameter(this.url, "_", ts);
			}
			this.params = this.processParam(this.params);
			if ( this.params && this.method == "GET" ) {
				this.url += (this.url.match(/\?/) ? "&" : "?") + this.params;
				this.params = null;
			}
			$.Log("request url : " + this.url);
		},
		processRequestHeader: function() {
			try {
				this.xhr.setRequestHeader("Content-Type", this.contentType);
				this.xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
				this.xhr.setRequestHeader("Accept",
					(this.dataType && this.accepts[ this.dataType ]) ?
					(this.accepts[this.dataType] + ", */*") : this.accepts._default );
			} catch (e) {}
		},
		defaultEorrer: function(xhr) {
			$.Log("[ERROR]: error fetching data!"
				+ "<br>ReadyState:" + xhr.readyState
				+ "<br>Status:" + xhr.status
				+ "<br>Headers:" + xhr.getAllResponseHeaders()
			);
		},
		process: function() {
			this.processUrl();
			this.xhr = this.getXHR();
			this.xhr.open(this.method, this.url, this.async);
			this.processRequestHeader();

			try {
				var ajax = this;
				this.xhr.onreadystatechange = function() {
					if (ajax.xhr.readyState == 4) {
						if (ajax.httpSuccess()) {
							var d = ajax.httpData();
							ajax.success(d);
						} else {
							ajax.handleError();
						}
					}
				}
				this.xhr.send(this.params);
			} catch(e) {
				this.handleError(e);
			}
		}
	};
})(ListView);

(function($) {
	$.Layout = function() {
	};
	$.Layout.prototype = {
		drawTable: function(dom, model) {
			if (model.width) dom.width = model.width;
			if (model.css) dom.style.cssText = model.css;
			if (model.className) dom.className = model.className;
		},
		drawCol: function(dom, model) {
			var colgroup = document.createElement("COLGROUP");
			$.Each(model, function(cm) {
				var col = document.createElement("COL");
				col.align = cm.align;
				if (cm.width) {
					col.width = cm.width;
					$.Log("[debug] 设置宽 :" + col.width);
				}
				colgroup.appendChild(col);
			});
			dom.appendChild(colgroup);
		},
		drawHead: function(dom, model) {
			var tr = document.createElement("TR");
			tr.className = "tr_listfirst";
			$.Each(model, function(cm) {
				var th = document.createElement("TH");
				if (cm.sortable) { // === 排序 升序 降序
					th.innerHTML = "<a class='th'>" + cm.label + "</a>";
					th.className = cm.sortclass;
					$.Log("[debug] 添加 TH 样式 " + th.className);
				} else {
					th.innerHTML = cm.label;
				}
				if (cm.thalign) {
					th.align = cm.thalign;
				}
				tr.appendChild(th);
			});
			dom.createTHead().appendChild(tr);
		},
		/*
		 * rows 数据结构是二维数组为:
		 * [ attr: {name: value},
		 *   data: ["",""] ]
		 */
		drawBody: function(dom, model, rows) {
			var layout = this;
			$.Each(rows, function(row, i) {
				layout.drawRow(dom, model, row, i);
			});
		},
		drawRow: function(dom, model, row, n) {
			var tr = dom.insertRow(n + 1);
			tr.className = (n % 2 == 0) ? "tr_listrow2" : "tr_listrow1";
			if (row.attr != undefined && row.attr != null) {
				for (var attr in row.attr) {
					tr[attr] = row.attr[attr];
				}
			}
			$.Each(row.data, function(cell, i) {
				var td = tr.insertCell(i);
				if (model[i].reader) {
					td.innerHTML = model[i].reader(cell, n);
				} else {
					td.innerHTML = cell;
				}
			});
		},
		clearTableRows: function(dom) {
			var size = dom.rows.length;
			for (var i = size -1; i > 0; i --) { // === 第一行不能删除
				dom.deleteRow(i);
			}
		},
		clearPageBar: function(dom, page, show) {
			$.Loop(page.topBar.childNodes, function( child , i) {
				$.Log("[debug] topBar 移除 child : " + child + "; index = " + i);
				page.topBar.removeChild(child);
			});
			$.Loop(page.bottomBar.childNodes, function( child , i) {
				$.Log("[debug] bottomBar 移除 child : " + child + "; index = " + i);
				page.bottomBar.removeChild(child);
			});
		},
		drawPageBar: function(dom, page, show) {
			if (!(page || show)) return;
			if (show == "both" || show == "top") {
				this.drawPageLeft(page.topBar, page);
				this.drawPageRight(page.topBar, page);
			}
			if (show == "both" || show == "bottom") {
				this.drawPageLeft(page.bottomBar, page);
				this.drawPageRight(page.bottomBar, page);
			}
		},
		drawPageLeft: function(dom, page) {
			$.Log("[debug] drawPageLeft");
			var div = document.createElement("DIV");
			div.className = "page_left";
			div.appendChild(page.getHome());
			div.appendChild(this.appendBlank());
			div.appendChild(page.getPrev());
			div.appendChild(this.appendBlank());
			div.appendChild(page.getNext());
			div.appendChild(this.appendBlank());
			div.appendChild(page.getLast());
			div.appendChild(this.appendBlank());
			div.appendChild(page.getReload());
			dom.appendChild(div);
		},
		drawPageRight: function(dom, page) {
			$.Log("[debug] drawPageRight");
			var div = document.createElement("DIV");
			div.className = "page_right";
			div.appendChild(page.getNow());
			div.appendChild(this.appendBlank());
			div.appendChild(page.getTotal());
			div.appendChild(this.appendBlank());
			div.appendChild(page.getRowsize());
			div.appendChild(this.appendBlank());
			div.appendChild(page.getRows());
			div.appendChild(this.appendBlank());
			div.appendChild(page.getGo());
			div.appendChild(page.getGoImage());
			dom.appendChild(div);
		},
		appendBlank: function() {
			return document.createTextNode("   ");
		}
	};
})(ListView);

(function($) {
	$.XmlReader = function() {
	};
	$.XmlReader.prototype = {
		read: function(tm, xml) {
			var root = xml.documentElement;
			var page = root.getElementsByTagName("page")[0];
			var rows = root.getElementsByTagName("rows")[0];
			this.readPage(tm, page);
			this.readRows(tm, rows);
		},
		readPage: function(tm, page) {
			var p = {};
			$.Each(page.childNodes, function(node) {
				p[node.nodeName] = $.Num(node.firstChild.nodeValue);
			});
			$.Extend(tm.page, p);
		},
		readRows: function(tm, rows) {
			var rv = [];
			$.Each(rows.childNodes, function(row) {
				if (1 != row.nodeType) return false;
				var attr = {};
				if (row.getElementsByTagName("attr").length > 0) {
					$.Each(row.getElementsByTagName("attr")[0].attributes, function(at) {
						attr[at.nodeName] = at.nodeValue;
						//$.Log(at.nodeName + " = " + at.nodeValue);
					});
				}
				var data = [];
				$.Each(row.getElementsByTagName("cell"), function(node) {
					if (node.firstChild) {
						$.Log(node.firstChild.nodeValue);
						data.push( node.firstChild.nodeValue );
					} else {
						//$.Log(" null value !");
						data.push( "" );
					}
				});
				rv.push({"attr": attr, "data": data});
			});
			tm.page.data = rv;
			$.Log("[debug] XML获取数据 size = " + tm.page.data.length);
		}
	};
	$.JsonReader = function() {
	};
	$.JsonReader.prototype = {
		read: function(tm, json) {
			$.Extend(tm.page, json.page);
			tm.page.data = json.rows;
		}
	};
})(ListView);

(function($) {
	$.ColumnModel = function(args) {
		var ms = [];
		$.Each(args, function(m) {
			if (m instanceof $.ColModel)
				ms.push(m);
			else
				ms.push(new $.ColModel(m));
		});
		this.length = 0;
		Array.prototype.push.apply( this, ms ); // === 转换成数组，方便迭代
		return this;
	};
	$.ColModel = function(args) {
		$.Extend(this, args);
		if (this.maxlength) {
			this.reader = $.ColMaxlengthReader;
		}
	};
	$.ColModel.prototype = {
		tm: null,
//		name: "",
		label: "",
		sortable: false,
		sortclass: "sortable",
		sortname: null,
		sortorder: null,
		align: "left",
		thalign: "center",
		width: null,
		maxlength: 0,
		reader: null,
		sort: function(dom) {
			$.Log("[debug] 执行排序 col = " + this.label);
			var th = dom.parentNode;
			if (!this.sortable) return;
			var t = this.tm;
			t.page.sortable = this.sortable;
			t.page.sortname = this.sortname;
			//  重置样式
			var cm = this;
			$.Each(th.parentNode.cells, function(cell, i) {
				var clm = t.columns[i];
				if (clm.sortable && clm != cm) {
					cell.className = clm.sortclass;
					$.Log("[debug] 重置一个样式！");
				}
			});
			if (this.sortorder == null) {
				this.sortorder = "asc";
				th.className = th.className + " order2";
			} else if ("asc" == this.sortorder) {
				this.sortorder = "desc";
				th.className = th.className.replace(/order2/, "order1");
			} else {
				this.sortorder = "asc";
				th.className = th.className.replace(/order1/, "order2");
			}
			$.Log("[debug] 排序后节点样式 " + th.className);
			t.page.sortorder = this.sortorder;
			t.page.load();
		}
	};
	$.SelectColModel = function() {
		var args = {
			label: "<input type=\"checkbox\" name=\"List_Tongle\">",
			width: "10pt",
			reader: function(value) {
				return "<input type=\"checkbox\" value=\""+value+"\" name=\"List_Selected\">";
			}
		};
		$.ColModel.call(this, args); // === 继承
	};
	$.SelectColModel.prototype = new $.ColModel();
	$.RowNumColModel = function(name) {
		var args = {
			label: name,
			width: "30pt",
			align: "right",
			reader: function(value, row) {
				var page = this.tm.page;
				var rv = (page.page - 1) * page.rowsize;
				return (rv + row + 1);
			}
		};
		$.ColModel.call(this, args); // === 继承
	};
	$.RowNumColModel.prototype = new $.ColModel();
	$.PageModel = function(args) {
		$.Extend(this, args);
		this._init();
	};
	$.PageModel.prototype = {
		tm: null,
		url: location.href,
		rowsize: 15,
		page: 1,
		method: "GET",
		dataType: "xml",
		sortable: false,
		sortname: null,
		sortorder: null,
		total: 0,
		rows: 0,
		data: null, // ========= 需要展现的数据 [{attr: {name: value}, data: ["",""]},{...}]
		reader: null,
		topBar: null,
		bottomBar: null,
		_img: null,
		_createA: function(text, alias) {
			var a = document.createElement("A");
			//a.href = "#";
			if (text) {
				a.appendChild(document.createTextNode(text));
			}
			if (alias) {
				a.alias = alias;
			}
			return a;
		},
		_init: function() {
			if (this.reader == null) {
				if (this.dataType == "json")
					this.reader = new $.JsonReader();
				else
					this.reader = new $.XmlReader();
			}
			this.topBar = document.createElement("DIV");
			this.bottomBar = document.createElement("DIV");

			this.topBar.onclick = this.onclick;
			this.bottomBar.onclick = this.onclick;
			this.topBar.onkeyup = this.onkeyup;
			this.bottomBar.onkeyup = this.onkeyup;
		},
		onclick: function(event) {
			event = event ? event : window.event;
			var target = event.target || event.srcElement;
			var name = $.TagName(target);
			if (name == "a") {
				var p = $.getTable(this.tableId).page;
				if (target.alias == "first") {
					p.page = 1;
					p.load();
				}
				else if (target.alias == "prev") {
					p.page = p.page - 1;
					p.load();
				}
				else if (target.alias == "next") {
					p.page = p.page + 1;
					p.load();
				}
				else if (target.alias == "last") {
					p.page = p.total;
					p.load();
				}
				else if (target.alias == "reload") {
					p.load();
				}
			}
			else if (name == "img" && target.alias == "go") {
				var p = $.getTable(this.tableId).page;
				var inputs = this.getElementsByTagName("input");
				var page = null;
				$.Each(inputs, function(input) {
					if (input.alias == "go") {
						page = $.Num(input.value);
						return true;
					}
					return false;
				});
				$.Log("[debug] GO page = " + page);
				if (page && page > 0 && page <= p.total) {
					p.page = page;
					p.load();
				}
			}
		},
		onkeyup: function(event) {
			event = event ? event : window.event;
			var target = event.target || event.srcElement;
			var name = $.TagName(target);
			$.Log("[debug] onkeyup = " + name);
			if (name == "input" && 13 == event.keyCode) {
				var p = $.getTable(this.tableId).page;
				if (target.alias == "rowsize") {
					var rowsize = $.Num(target.value);
					if (rowsize && rowsize > 0) {
						p.rowsize = rowsize;
						p.load();
					}
				}
				else if (target.alias == "go") {
					var page = $.Num(target.value);
					if (page && page > 0 && page <= p.total) {
						p.page = page;
						p.load();
					}
				}
			}
		},
		getHome: function() {
			if (this.page < 2)
				return document.createTextNode($.Msg.first);
			return this._createA($.Msg.first, "first");
		},
		getPrev: function() {
			if (this.page < 2)
				return document.createTextNode($.Msg.prev);
			return this._createA($.Msg.prev, "prev");
		},
		getNext: function() {
			if (this.total == this.page)
				return document.createTextNode($.Msg.next);
			return this._createA($.Msg.next, "next");
		},
		getLast: function() {
			if (this.total == this.page)
				return document.createTextNode($.Msg.last);
			return this._createA($.Msg.last, "last");
		},
		getReload: function() {
			return this._createA($.Msg.reload, "reload");
		},
		getNow: function() {
			return document.createTextNode($.Msg.the + " " + this.page + " " + $.Msg.page);
		},
		getTotal: function() {
			return document.createTextNode($.Msg.total + " " + this.total + " " + $.Msg.page);
		},
		getRowsize: function() {
			var rowsizeInput = document.createElement("INPUT");
			rowsizeInput.type = "text";
			rowsizeInput.value = this.rowsize;
			rowsizeInput.className = "pagenav_input";
			rowsizeInput.alias = "rowsize";
			rowsizeInput.size = 3;
			var span = document.createElement("SPAN");
			span.appendChild(document.createTextNode($.Msg.rowPerPage));
			span.appendChild(rowsizeInput);
			span.appendChild(document.createTextNode($.Msg.row));
			return span;
		},
		getRows: function() {
			return document.createTextNode($.Msg.total + " " + this.rows + " " + $.Msg.row);
		},
		getGo: function() {
			var goInput = document.createElement("INPUT");
			goInput.type = "text";
			goInput.value = this.page;
			goInput.className = "pagenav_input";
			goInput.alias = "go";
			goInput.size = 3;
			var span = document.createElement("SPAN");
			span.appendChild(document.createTextNode($.Msg.changeTo + $.Msg.the));
			span.appendChild(goInput);
			span.appendChild(document.createTextNode($.Msg.page));
			return span;
		},
		getGoImage: function() {
			if (this._img == null) {
				this._img = new Image();
				this._img.src = Com_Parameter.StylePath + $.Msg.imgUrl;
				this._img.title = $.Msg.imgTitle;
				this._img.alias = "go";
			}
			return this._img.cloneNode(false);
		},
		getUrl: function() {
			this.url = Com_SetUrlParameter(this.url, "rowsize", this.rowsize);
			this.url = Com_SetUrlParameter(this.url, "pageno", this.page);
			if (this.sortable && this.sortname) {
				this.url = Com_SetUrlParameter(this.url, "orderby", this.sortname);
				if (this.sortorder == "desc")
					this.url = Com_SetUrlParameter(this.url, "ordertype", "down");
				else if (this.sortorder == "asc")
					this.url = Com_SetUrlParameter(this.url, "ordertype", "up");
			}
			return this.url;
		},
		load: function() {
			var url = this.getUrl();
			var p = this;
			$.ShowLoading();
			$.Ajax({
				"url": url,
				method: this.method,
				dataType: this.dataType,
				success: function(data) {
					p.reader.read(p.tm, data);
					p.tm.refresh();
					$.ShowLoadSuccess();
					setTimeout($.HiddBox, 700);
				},
				error: function() {
					$.ShowLoadError();
				}
			});
		}
	};
	$.Table = function(args) {
		$.Extend(this, args);
		$.tables.push(this);
		this._init();
	};
	$.Table.prototype = {
		ID: "List_ViewTable",
		table: null,
		className: null,
		width: "100%",
		css: null,
		showEmptyRow: false,
		page: null,
		columns: null,
		layout: null,
		bar: "both", //  both | top | bottom
		_init: function() {
			this.table = document.getElementById(this.ID);
			if (this.layout == null) this.layout = new $.Layout();
			var tm = this;
			$.Each(this.columns, function(cm) {
				cm.tm = tm;
			});
			this.page.tm = tm;
			this.table.parentNode.insertBefore(this.page.topBar, this.table);
			this.table.parentNode.appendChild(this.page.bottomBar, this.table);
			this.page.topBar.tableId = this.ID;
			$.Log("[debug] 设置 topBar.tableId = " + this.page.topBar.tableId);
			this.page.bottomBar.tableId = this.ID;
			$.Log("[debug] 设置 bottomBar.tableId = " + this.page.bottomBar.tableId);
			$.AddEvent(this.table, "mousemove", this.onmouseover);
			$.AddEvent(this.table, "mouseout", this.onmouseout);
			$.AddEvent(this.table, "click", this.onclick);
		},
		show: function() {
			this.layout.drawTable(this.table, this);
			this.layout.drawCol(this.table, this.columns);
			this.layout.drawHead(this.table, this.columns);
			if (this.page) {
				this.layout.drawPageBar(this.table, this.page, this.bar);
				if (this.page.data) {// TODO 增加无数据时，自动发起请求，去获取
					this.layout.drawBody(this.table, this.columns, this.page.data);
				} else {
					page.load();
				}
			}
		},
		refresh: function() {
			$.Log("[debug] 执行 refresh() ");
			this.layout.clearTableRows(this.table);
			this.layout.drawBody(this.table, this.columns, this.page.data);
			this.layout.clearPageBar(this.table, this.page, this.bar);
			this.layout.drawPageBar(this.table, this.page, this.bar);
		},
		onmouseover: function(event) {
			event = event ? event : window.event;
			var target = event.target || event.srcElement;
			var name = $.TagName(target);
			if (name == "td") {
				var tr = target.parentNode;
				if (tr.curCSS)
					return;
				tr.curCSS = tr.className;
				tr.className = tr.className +  " tr_listrowcur";
				if (tr._url)
					tr.style.cursor = "pointer";
				tr = null;
			}
		},
		onmouseout: function(event) {
			event = event ? event : window.event;
			var target = event.target || event.srcElement;
			var name =  $.TagName(target);
			if (name == "td") {
				var tr = target.parentNode;
				if (tr.curCSS) {
					tr.className = tr.curCSS;
					tr.curCSS = null;
				}
				tr = null;
			}
		},
		onclick: function(event) {
			event = event ? event : window.event;
			var target = event.target || event.srcElement;
			var name =  $.TagName(target);
			$.Log("[debug] 点击事件触发 TagName = " + name);
			if (name == "a" && target.className == "th") {
				$.Log("[debug] className = " + target.className);
				var table = $.getTable(this.id);
				var index = $.NodeIndex(target.parentNode);
				$.Log("[debug] NodeIndex = " + index);
				if (index == -1) {
					$.Log("[error] 出错了！ 未找到 ColumnModel index = " + index);
					return;
				}
				var cm = table.columns[index];
				cm.sort(target);
			} else if (name == "input" && target.name == "List_Tongle") {
				$.Log("[debug] 点击事件触发 name = " + target.name);
				var inputs = this.getElementsByTagName("input");
				$.Each(inputs, function(input) {
					if (input.name == "List_Selected") {
						input.checked = target.checked;
					}
				});
			} else if (name == "td" && target.parentNode._url) {
				var tr = target.parentNode;
				Com_OpenWindow(tr._url, tr._target, tr._winstyle, tr._keepurl);
				tr = null;
			}
		}
	};
})(ListView);
