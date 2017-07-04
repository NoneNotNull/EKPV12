(function(){
	
	var chartsMap = {};
	var chartsArray = [];
	
	//------------------------------
	//
	// 全局静态属性
	//
	//------------------------------
	
	window.KANVAS = {};
	KANVAS.width = 0;
	KANVAS.height = 0;	

	//事件
	KANVAS.event = {};
	KANVAS.event.READY = "ready"; 
	KANVAS.event.LINK_BTN_CLICKED = 'linkBtnClicked';
	KANVAS.event.LINK_CLICKED = 'linkClicked';
	KANVAS.event.UNSELECTED = "unselected";
	
	KANVAS.navigatorType = {};
	KANVAS.navigatorType.IE = "ie";
	KANVAS.navigatorType.FIREFOX = "firefox";
	KANVAS.navigatorType.CHROME = "chrome";
	KANVAS.navigatorType.OPERA = "opera";
	KANVAS.navigatorType.SAFARI = "safari";

	
	//---------------------------------------
	//
	// Flash回调API, 每个图表（JS对象）必须指定唯一的ID，
	// 通过这个ID与Flash对象关联，Flash的回调方法通过此ID
	// 定位到对应的JS对象
	//
	//----------------------------------------
	
	//图表完成初始化
	KANVAS.ready = function(id) {

		
		var chart = getChartByID(id);
		if (chart.swf == null)
			chart.swf = document.getElementById(chart.id);
			
		if (chart.transparent) {
			registerMouseWheelEvt(chart.swf);
			
		}
			
		chart.ready();

	};
	
	KANVAS.unselected = function(id) {
		var chart = getChartByID(id);
		if (chart.swf == null)
			chart.swf = document.getElementById(chart.id);
		
		chart.unselected();
	};
	
	//关联按钮按点击时
	KANVAS.linkBtnClicked = function(id, value) {
		getChartByID(id).linkBtnClicked(value);
	};
	
	//含有关联信息的节点按点击时
	KANVAS.linkClicked = function(id, value) {
		getChartByID(id).linkClicked(value);
	};
	
	
	
	
	
	
	//------------------------------------------------------------
	//
	// Kanvas编辑器和KPlayer阅读器的基类
	//
	//------------------------------------------------------------
	
	function kvsBase(){
		var that = {};
		
		//------------------------------
		//
		// 初始化
		//
		//------------------------------
		
		// 初始化图表的基本属性；
		init = function(chart, arg, transparent){
			
			var chartW = KANVAS.width;
			var chartH = KANVAS.height;
			
			if (hasProp(arg.id)){
				chart.id = arg.id;
			}
			
			// id 参数为必选项， 可以只传递id， 此时arg为字符类型；
			if (typeof arg === "string"){
				
				var args = arg.split(",");
				
				if (args.length == 1){
					chart.id = args[0];
				}else if (args.length == 3){
					chart.id = args[0];
					chartW = args[1];
					chartH = args[2];
				}
			};
			
			chart.width = hasProp(arg.width) ? arg.width : chartW;
			chart.height = hasProp(arg.height) ? arg.height : chartH;
			
			registerChart(chart.id, chart);
			
			// 传递图表ID到Flash对象内部，Flash回调时会附上此ID
			// 从而便于将消息分发至对应的图表对象(JS)
			var flashvars = {};
			flashvars.id = chart.id;
			
			initSWF(chart, flashvars, transparent);
				
		};
		
		that.dispose = function() {
			this.id = null;		
			this.swf = null;
			removeSWF(this.id);
		};
		
		
		
		//--------------------------------------------------
		//
		// 事件处理
		//
		//--------------------------------------------------
		that.addEventListener = function(event, callback) {
	        if (this.listeners == null) this.listeners = {};
	        if (this.listeners[event] == null) this.listeners[event] = [];
	        this.listeners[event].push(callback);
			
			return this;
	    };
	
	    that.removeEventListener = function(event, callback) {
	        if (this.listeners == null || this.listeners[event] == null) return;
	
	        var index = -1;
	        for (var i = 0; i < this.listeners[event].length; i++) {
	            if (this.listeners[event][i] == callback) {
	                index = i;
	                break;
	            }
	        }
	        if (index != -1)
	            this.listeners[event].splice(index, 1);
				
			return this;
	    };
	
	    that.dispatchEvent = function(e) {
	        if (e == null || e.type == null) return;
	        e.target = this;
	        if (this.listeners == null || this.listeners[e.type] == null) return;
	        var len = this.listeners[e.type].length;
			
	        for (var i = 0; i < len; i++) {
	            this.listeners[e.type][i](e);
	        }
	    };
		
		
		//----------------------------------------
		//
		// 为了简化事件的添加，定义了一些简便的方法；
		//
		//----------------------------------------
		
		that.onReady = function(callback) {
			return this.addEventListener(KANVAS.event.READY, callback);
		};
		
		//设置图表的尺寸
		that.setSize = function(width, height) {
			if (this.ifReady) {
				this.swf.width = width;
				this.swf.height = height;
			} else {
				this.width = width;
				this.height = height;
			};
			
			return this;
		};
		
		return that;
	};
	
	
	
	
	//------------------------------
	//
	// Kanvas编辑器
	//
	//------------------------------
	
	window.Kanvas = function(arg){
		this.constructor(arg);
		return this;
    };
    
	Kanvas.swfURL = "Kanvas.swf";
	Kanvas.prototype = function() {
		
		//继承至基类
		var that = kvsBase();
		
		//重写构造函数
		that.constructor = function(arg) {
			this.swfURL = getSWFURL(Kanvas.swfURL);
			init(this, arg, false);
		};
		
		
		
		//---------------------------------------------以下是常用API-----------------------------------
		// 此方法在Kanvas完成整个初始化后被创建
		that.ready = function() {
			
		    this.ifReady = true;
		    
		    if (this.imgServerChanged){
		    	this.setImgUploadServer(this.imgServer);
		    	this.imgServerChanged = false;
		    };
		    
			this.dispatchEvent({type: KANVAS.event.READY, target: this});
		};
		
		//添加关联按钮事件
		that.onLinkBtnClicked = function(callback) {
			return this.addEventListener(KANVAS.event.LINK_BTN_CLICKED, callback);
		};
		
		//
		that.linkBtnClicked = function(value) {
			this.dispatchEvent({type: KANVAS.event.LINK_BTN_CLICKED, target: this, data: value});
		};
		
		//设置图片接收服务，插入图片时会将图片数据发送至此服务，成功后服务端返回图片的URL至客户端
		that.setImgUploadServer = function(url) {
			if (this.ifReady){
				this.swf.setImgUploadServer(url);
			}else{
				this.imgServerChanged = true;
			}
			
			this.imgServer = url;
			return this;
		};
		
		//获取图片URL列表，经Base64编码
		that.getImgURLList = function(){
			if (this.ifReady){
				return this.swf.getImgURLList();
			}
		};
		
		that.getShotCut = function(w, h) {
			if (this.ifReady) {
				return this.swf.getShotCut(w, h);
			}
		};
		
		//获取拥有property的元素ID列表
		that.getOwnPropertyIDList = function() {
			if (this.ifReady){
				return this.swf.getOwnPropertyIDList();
			}
		};
		
		//获取数据，数据为base64编码
		that.getBase64Data = function(){
			if (this.ifReady){
				return this.swf.getBase64Data();
			}
			
			return null;
		};
		
		//设定数据，数据格式为Baes64编码的字符串
		that.setBase64Data = function(data){
			if (this.ifReady){
				this.swf.setBase64Data(data);
			};
			
		};
		
		//给当前选中的节点设置关联信息
		that.setLinkData = function(data){
			if (this.ifReady){
				this.swf.setLinkData(data);
			};
		};
		
		return that;
		
	}();
	
	
	
	
	//------------------------------
	//
	// KPlayer 阅读器
	//
	//-----------------------------
	window.KPlayer = function(arg, swfUrl){
		KPlayer.swfURL=swfUrl;
		this.constructor(arg);
		return this;
    };
    
	
	KPlayer.prototype = function() {
		
		var that = kvsBase();
		that.constructor = function(arg){
			this.swfURL = getSWFURL(KPlayer.swfURL);
			init(this, arg, true);
		};
		
		
		
		//---------------------------------------------以下是常用API-------------------------------------------
		// 此方法在KPlayer完成整个初始化后被创建
		that.ready = function(){
		    this.ifReady = true;
		    
			this.dispatchEvent({type: KANVAS.event.READY, target: this});
		};
		
		//设定数据
		that.setBase64Data = function(data){
			if (this.ifReady){
				this.swf.setBase64Data(data);
			};
		};
		
		//从服务器加载数据流
		that.loadDataFromServer = function(url){
			if (this.ifReady){
				this.swf.loadDataFromServer(url);
			}
		};
		
		
		that.onUnselected = function(callback) {
			return this.addEventListener(KANVAS.event.UNSELECTED, callback);
		};
		
		
		that.unselected = function() {
			this.dispatchEvent({type: KANVAS.event.UNSELECTED, target: this});
		};
		
		//添加元素点击监听
		that.onLinkClicked = function(callback) {
			return this.addEventListener(KANVAS.event.LINK_CLICKED, callback);
		};
		
		//
		that.linkClicked = function(value) {
			this.dispatchEvent({type: KANVAS.event.LINK_CLICKED, target: this, data: value});
		};
		
		return that;
		
	}();
	
	
	
	
	
	
	
	
	
	
	//-------------------------------以下是基础函数库可掠过，无需关注----------------------------------------------------------------------------
	//-----------------------------------------------------------------------------------------------------------------------------------------
	
	
	function checkNavigator() {
		var Sys = {};
		var ua = navigator.userAgent.toLowerCase();
		Sys.ie = ua.indexOf("msie") != -1;
		Sys.firefox = ua.indexOf("firefox") != -1;
		Sys.chrome = ua.indexOf("chrome") != -1;
		Sys.opera = ua.indexOf("opera") != -1;
		Sys.safari = ua.indexOf("version") != -1;
		//以下进行测试
		var str = KANVAS.navigatorType.IE;
		if(Sys.firefox) str = KANVAS.navigatorType.FIREFOX;
		if(Sys.chrome) str = KANVAS.navigatorType.CHROME;
		if(Sys.opera) str = KANVAS.navigatorType.OPERA;
		if(Sys.safari) str = KANVAS.navigatorType.SAFARI;
		return str;
	};
	
	//鼠标滚轮监听
	function registerMouseWheelEvt(target){
		
		var navigatorType = checkNavigator();
		
		var onMouseWheel = function(){
			var evt = window.event || arguments[0];
			if (navigatorType == KANVAS.navigatorType.IE) {
				evt.cancelBubble = true;
			    evt.returnValue = false;
			    
			    target.onWebMouseWheel(evt.wheelDelta);
			} else {
				evt.preventDefault();
				evt.stopPropagation();
				if (navigatorType == KANVAS.navigatorType.FIREFOX || navigatorType == KANVAS.navigatorType.CHROME) {
					target.onWebMouseWheel(-evt.detail);
				} else {
					target.onWebMouseWheel(evt.detail);
				}
			}
			return false;
		};
		
		var mouseWheelRegisted = false;
		var registMouseWheel = function() {
			mouseWheelRegisted = true;
			if (navigatorType == KANVAS.navigatorType.FIREFOX){
				doc.addEventListener('DOMMouseScroll', onMouseWheel, false);
			}else{
				doc.onmousewheel = onMouseWheel;
			}
		};
		
		var removeMouseWheel = function() {
			mouseWheelRegisted = false;
			if (navigatorType == KANVAS.navigatorType.FIREFOX){
				doc.removeEventListener('DOMMouseScroll', onMouseWheel, false);
			}else{
				doc.onmousewheel = null;
			}
		};
		
		registMouseWheel();
		
		target.onmouseover = function(){
			if (mouseWheelRegisted == false)
				registMouseWheel();
		};
		
		target.onmouseout = function(){
			if (mouseWheelRegisted == true)
				removeMouseWheel();
		};
	};

	//键盘事件的监听 , IE下面的ctrl组合键在Flash中实效
	// 这里通过JS处理，调用Flash对应接口
	function registerKeyBoard(target){
		if (ua.ie){
			document.onkeydown = function(){
			    
				if (event.ctrlKey == 1){
					if (event.keyCode == 67){
						target.copy();
					}else if (event.keyCode == 88){
						target.cut();
					}else if (event.keyCode == 86){
						target.paste();
					}else if (event.keyCode == 90){
						target.undo();
					}
			    }
			};
		}
	};
	
	
	
	
	
	
	//------------------------------
	//
	// 根据图表属性，生成Flash对象
	//
	//------------------------------
	function initSWF(chart, flashvars, transparent) {
		addDomLoadEvent(function() {
				var attributes = {}; // 每构建一个新实例则创建一个新私有属性对象
	            attributes.id = chart.id;
	            attributes.name = chart.id;
	            attributes.align = "middle";
				attributes.width = chart.width.toString().replace(/\%$/,"%25");
				attributes.height = chart.height.toString().replace(/\%$/,"%25");
				attributes.data = chart.swfURL;

				var params = {};
	            params.quality = "high";
	            params.allowscriptaccess = "*";
	            params.allowFullScreenInteractive = "true";
	            params.allowFullScreen = "true";
	            if (transparent) {
	            	params.wmode = "transparent";
	            }
	            
				
				chart.transparent = (params.wmode == "transparent");
				chart.swf = generateSWF(attributes, params, flashvars);
		});
	};
	
	
	
	
	
	//------------------------------------
	//
	// 浏览器与播放器信息
	//
	//------------------------------------
	
	var UNDEF = "undefined",
		OBJECT = "object",
		SHOCKWAVE_FLASH = "Shockwave Flash",
		SHOCKWAVE_FLASH_AX = "ShockwaveFlash.ShockwaveFlash",
		FLASH_MIME_TYPE = "application/x-shockwave-flash",
		ON_READY_STATE_CHANGE = "onreadystatechange",
		
		win = window,
		doc = document,
		nav = navigator,
		
		plugin = false,
		isDomLoaded = false,
		domLoadFnArr = [],
		listenersArr = [];
	
	var ua = function() {
    	
		var w3cdom = typeof doc.getElementById != UNDEF && typeof doc.getElementsByTagName != UNDEF && typeof doc.createElement != UNDEF,
			u = nav.userAgent.toLowerCase(),
			p = nav.platform.toLowerCase(),
			windows = p ? /win/.test(p) : /win/.test(u),
			mac = p ? /mac/.test(p) : /mac/.test(u),
			webkit = /webkit/.test(u) ? parseFloat(u.replace(/^.*webkit\/(\d+(\.\d+)?).*$/, "$1")) : false, // returns either the webkit version or false if not webkit
			ie = !+"\v1", 
			playerVersion = [0,0,0],
			d = null;
			
		if (typeof nav.plugins != UNDEF && typeof nav.plugins[SHOCKWAVE_FLASH] == OBJECT) {
			d = nav.plugins[SHOCKWAVE_FLASH].description;
			if (d && !(typeof nav.mimeTypes != UNDEF && nav.mimeTypes[FLASH_MIME_TYPE] && !nav.mimeTypes[FLASH_MIME_TYPE].enabledPlugin)) { // navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin indicates whether plug-ins are enabled or disabled in Safari 3+
				plugin = true;
				ie = false; 
				d = d.replace(/^.*\s+(\S+\s+\S+$)/, "$1");
				playerVersion[0] = parseInt(d.replace(/^(.*)\..*$/, "$1"), 10);
				playerVersion[1] = parseInt(d.replace(/^.*\.(.*)\s.*$/, "$1"), 10);
				playerVersion[2] = /[a-zA-Z]/.test(d) ? parseInt(d.replace(/^.*[a-zA-Z]+(.*)$/, "$1"), 10) : 0;
			}
		}
		else if (typeof win.ActiveXObject != UNDEF) {
			try {
				var a = new ActiveXObject(SHOCKWAVE_FLASH_AX);
				if (a) { 
					d = a.GetVariable("$version");
					if (d) {
						ie = true; 
						d = d.split(" ")[1].split(",");
						playerVersion = [parseInt(d[0], 10), parseInt(d[1], 10), parseInt(d[2], 10)];
					}
				}
			}
			catch(e) {}
		}
		return { w3:w3cdom, pv:playerVersion, wk:webkit, ie:ie, win:windows, mac:mac };
	}();
	
	
	
	//----------------------------------------
	//
	// Dom 加载与页面初始化
	//
	//----------------------------------------
	
	var onDomLoad = function() {
		if (!ua.w3) { return; }
		if ((typeof doc.readyState != UNDEF && doc.readyState == "complete") || (typeof doc.readyState == UNDEF && (doc.getElementsByTagName("body")[0] || doc.body))) { // function is fired after onload, e.g. when script is inserted dynamically 
			callDomLoadFunctions();
		}
		if (!isDomLoaded) {
			if (typeof doc.addEventListener != UNDEF) {
				doc.addEventListener("DOMContentLoaded", callDomLoadFunctions, false);
			}		
			if (ua.ie && ua.win) {
				doc.attachEvent(ON_READY_STATE_CHANGE, function() {
					if (doc.readyState == "complete") {
						doc.detachEvent(ON_READY_STATE_CHANGE, arguments.callee);
						callDomLoadFunctions();
					}
				});
				if (win == top) { 
					(function(){
						if (isDomLoaded) { return; }
						try {
							doc.documentElement.doScroll("left");
						}
						catch(e) {
							setTimeout(arguments.callee, 0);
							return;
						}
						callDomLoadFunctions();
					})();
				}
			}
			if (ua.wk) {
				(function(){
					if (isDomLoaded) { return; }
					if (!/loaded|complete/.test(doc.readyState)) {
						setTimeout(arguments.callee, 0);
						return;
					}
					callDomLoadFunctions();
				})();
			}
			addLoadEvent(callDomLoadFunctions);
		}
	}();
	
	function callDomLoadFunctions() {
		if (isDomLoaded) { return; }
		try { 
			var t = doc.getElementsByTagName("body")[0].appendChild(doc.createElement("span"));
			t.parentNode.removeChild(t);
		}
		catch (e) { return; }
		isDomLoaded = true;
		var dl = domLoadFnArr.length;
		for (var i = 0; i < dl; i++) {
			domLoadFnArr[i]();
		}
	};
	
	function addDomLoadEvent(fn) {
		if (isDomLoaded) {
			fn();
		}
		else { 
			domLoadFnArr[domLoadFnArr.length] = fn; 
		}
	};
	
	function addLoadEvent(fn) {
		if (typeof win.addEventListener != UNDEF) {
			win.addEventListener("load", fn, false);
		}
		else if (typeof doc.addEventListener != UNDEF) {
			doc.addEventListener("load", fn, false);
		}
		else if (typeof win.attachEvent != UNDEF) {
			addListener(win, "onload", fn);
		}
		else if (typeof win.onload == "function") {
			var fnOld = win.onload;
			win.onload = function() {
				fnOld();
				fn();
			};
		}
		else {
			win.onload = fn;
		}
	};
	
	
	
	
	//------------------------------------------------
	//
	// 嵌入Flash对象到网页中
	//
	//------------------------------------------------
	
	function generateSWF(attributes, params, flashVars) {
		var r, el = doc.getElementById(attributes.id);
		if (flashVars && typeof flashVars === OBJECT) {
			for (var k in flashVars) { 
				if (typeof params.flashvars != UNDEF) {
					params.flashvars += "&" + k + "=" + flashVars[k];
				}
				else {
					params.flashvars = k + "=" + flashVars[k];
				}
			}
		}
					
		if (ua.wk && ua.wk < 312) { return r;};
		if (!hasPlayerVersion('10.0.0')) {
			addLoadEvent(function() {
				el.innerHTML = '<a href="http://get.adobe.com/cn/flashplayer/?no_redirect">需要安装Flash播放器<a/>';
			});
			
			return r;
		}else {
			if (el) {
				if (ua.ie && ua.win) { 
					var att = "";
					for (var i in attributes) {
						if (attributes[i] != Object.prototype[i]) { 
							if (i.toLowerCase() == "data") {
								params.movie = attributes[i];
							}
							else if (i.toLowerCase() == "styleclass") { 
								att += ' class="' + attributes[i] + '"';
							}
							else if (i.toLowerCase() != "classid") {
								att += ' ' + i + '="' + attributes[i] + '"';
							}
						}
					}
					
					var par = "";
					for (var j in params) {
						if (params[j] != Object.prototype[j]) { 
							par += '<param name="' + j + '" value="' + params[j] + '" />';
						}
					}
					
					el.outerHTML = '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"' + att + '>' + par + '<embed allowFullScreenInteractive="true"/></object>';
					r = doc.getElementById(attributes.id);	
					
				}else { 
					var o = doc.createElement(OBJECT);
					o.setAttribute("type", FLASH_MIME_TYPE);
					for (var m in attributes) {
						if (attributes[m] != Object.prototype[m]) {
							if (m.toLowerCase() == "styleclass") { 
								o.setAttribute("class", attributes[m]);
							}
							else if (m.toLowerCase() != "classid") { 
								o.setAttribute(m, attributes[m]);
							}
						}
					}
					for (var n in params) {
						if (params[n] != Object.prototype[n] && n.toLowerCase() != "movie") { 
							createObjParam(o, n, params[n]);
						}
					}
					el.parentNode.replaceChild(o, el);
					r = o;
				}
			}
			
			return r;
		}
		
	};
	
	function createObjParam(el, pName, pValue) {
		var p = doc.createElement("param");
		p.setAttribute("name", pName);	
		p.setAttribute("value", pValue);
		el.appendChild(p);
	};
	
	function hasPlayerVersion(rv) {
		var pv = ua.pv, v = rv.split(".");
		v[0] = parseInt(v[0], 10);
		v[1] = parseInt(v[1], 10) || 0; // supports short notation, e.g. "9" instead of "9.0.0"
		v[2] = parseInt(v[2], 10) || 0;
		return (pv[0] > v[0] || (pv[0] == v[0] && pv[1] > v[1]) || (pv[0] == v[0] && pv[1] == v[1] && pv[2] >= v[2])) ? true : false;
	}
	
	// 回收
	var cleanup = function() {
		if (ua.ie && ua.win) {
			window.attachEvent("onunload", function() {
				
				var ll = listenersArr.length;
				for (var i = 0; i < ll; i++) {
					listenersArr[i][0].detachEvent(listenersArr[i][1], listenersArr[i][2]);
				}
				
				var il = chartsArray.length;
				for (var j = 0; j < il; j++) {
					removeChart(chartsArray[j]);
					chartsArray[j] = null;
				}
				
				chartsMap = chartsArray = null;
				
				for (var k in ua) {
					ua[k] = null;
				}
				
				ua = null;
			});
		}
	}();
	
	
	
	//-------------------------------
	//
	// 供内部使用的私有方法
	//
	//-------------------------------
	
	function getSWFURL(swfURL) {
		var url;
		var items = doc.getElementsByTagName('script');
		var length = items.length;
		var src;
		for (var i = 0; i < length; i ++)
		{
			src = items[i].src;
			if (src.indexOf('KANVAS.js') != - 1)
			{
				src = src.slice(0, src.indexOf('KANVAS.js'));
				url = src + swfURL;
			}
		}
		
		if (hasProp(url))
			return url;
		else
			return swfURL;
	};
	
	function getChartByID(id){
		return chartsMap[id];
	};
	
	function registerChart(id, chart){
		chartsMap[id] = chart;
		chartsArray[chartsArray.length] = chart;
	};
	
	function removeChart(chart){
		chart.dispose();
		chartsMap[chart.id] = null;
	};
	
	function removeSWF(id) {
		var obj = doc.getElementById(id);
		if (obj && obj.nodeName == "OBJECT") {
				obj.style.display = "none";
				(function(){
					if (obj.readyState == 4) {
						for (var i in obj) {
							if (typeof obj[i] == "function") {
								obj[i] = null;
							}
						}
						obj.parentNode.removeChild(obj);
					}else {
						setTimeout(arguments.callee, 10);
					}
				})();
		}
	};
	
	function hasProp(target) {
		 return typeof target != "undefined"; 
	};
	
	function addListener(target, eventType, fn) {
		target.attachEvent(eventType, fn);
		listenersArr[listenersArr.length] = [target, eventType, fn];
	};
	
})();
