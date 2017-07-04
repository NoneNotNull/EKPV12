XMLParseUtil = {};

XMLParseUtil.apply = function(o, c, defaults) {
	if (defaults) {
		// no "this" reference for friendly out of scope calls
		XMLParseUtil.apply(o, defaults);
	}
	if (o && c && typeof c == 'object') {
		for (var p in c) {
			o[p] = c[p];
		}
	}
	return o;
};

(function() {
	XMLParseUtil.apply(XMLParseUtil, {

		// ========XMLDOM相关======================

		// 浏览器信息
		browerInfo : {
			brower : "",
			version : "",
			IsStandard : false
		},
		// XMLDOM对象
		xmlDoc : null,
		// 获取浏览器信息
		initBrowerInfo : function() {
			// Useragent RegExp
			var rwebkit = /(webkit)[ \/]([\w.]+)/;
			var ropera = /(opera)(?:.*version)?[ \/]([\w.]+)/;
			var rmsie = /(msie) ([\w.]+)/;
			var rmozilla = /(mozilla)(?:.*? rv:([\w.]+))?/;
			var navigator = window.navigator;
			var userAgent = navigator.userAgent;
			var ua = userAgent.toLowerCase();
			var match = rwebkit.exec(ua) || ropera.exec(ua) || rmsie.exec(ua)
					|| ua.indexOf("compatible") < 0 && rmozilla.exec(ua) || [];
			var browerInfo = {};
			browerInfo.brower = match[1] || "";
			browerInfo.version = match[2] || "0";
			browerInfo.IsStandard = browerInfo.brower == "msie" ? false : true;
			this.browerInfo = browerInfo;
			return browerInfo;
		},
		// 如果mozilla火狐则修改XMLDOM原型,统一xpath调用
		initDomByMozilla : function() {
			if (XMLParseUtil.brower != "mozilla")
				return;
			XMLDocument.PRototype.__proto__.__defineGetter__("xml", function() {
						try {
							return new XMLSerializer().serializeToString(this);
						} catch (ex) {
							var d = document.createElement("div");
							d.appendChild(this.cloneNode(true));
							return d.innerHTML;
						}
					});
			Element.prototype.__proto__.__defineGetter__("xml", function() {
						try {
							return new XMLSerializer().serializeToString(this);
						} catch (ex) {
							var d = document.createElement("div");
							d.appendChild(this.cloneNode(true));
							return d.innerHTML;
						}
					});
			XMLDocument.prototype.__proto__.__defineGetter__("text",
					function() {
						return this.firstChild.textContent
					});
			Element.prototype.__proto__.__defineGetter__("text", function() {
						return this.textContent
					});

			XMLDocument.prototype.selectSingleNode = Element.prototype.selectSingleNode = function(
					XPath) {
				var x = this.selectNodes(xpath)
				if (!x || x.length < 1)
					return null;
				return x[0];
			}
			XMLDocument.prototype.selectNodes = Element.prototype.selectNodes = function(
					xpath) {
				var xpe = new XPathEvaluator();
				var nsResolver = xpe
						.createNSResolver(this.ownerDocument == null
								? this.documentElement
								: this.ownerDocument.documentElement);
				var result = xpe.evaluate(xpath, this, nsResolver, 0, null);
				var found = [];
				var res;
				while (res = result.iterateNext())
					found.push(res);
				return found;
			}
		},
		// 字符串转XMLDOM对象,
		parseXML : function(data) {
			var xml, tmp; 
			try {
				// IE
				if (!!window.ActiveXObject || "ActiveXObject" in window) { // Standard
					xml = new ActiveXObject("Microsoft.XMLDOM");
					xml.async = "false";
					xml.loadXML(data);
				} else { 
					tmp = new DOMParser();
					xml = tmp.parseFromString(data, "text/xml");
				}
			} catch (e) {
				xml = undefined;
			}
			if (!xml || !xml.documentElement
					|| xml.getElementsByTagName("parsererror").length) {
				alert("Invalid XML error: " + data);
			}

			this.xmlDoc = xml;
			return xml;
		},
		// 根据文件路径获取XMLDOM对象
		loadXML : function(path) {
			var xmlDoc = null;
			if (!!window.ActiveXObject || "ActiveXObject" in window) {
				xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
			} else if (document.implementation
					&& document.implementation.createDocument) {
				xmlDoc = document.implementation.createDocument("", "", null);
			} else {
				alert('Your browser cannot handle this script');
			}
			xmlDoc.async = false;
			xmlDoc.load(path);
			this.xmlDoc = xmlDoc;
			return xmlDoc;
		},
		// 获取node 节点 名字为name 节点,没有name则返回所有节点
		getChildren : function(node, name) {
			var nodes = [];
			if (!node)
				return nodes;
			for (var i = 0; i < node.childNodes.length; i++) {
				if (node.childNodes[i]
						&& (node.childNodes[i].nodeName == name || !name)) {
					if (node.childNodes[i].nodeType == 1) {
						nodes[nodes.length] = node.childNodes[i];
					}
				}
			}
			return nodes;
		},
		getXMLRootNode : function(doc) {
			if (doc == null)
				doc = this.xmlDoc;
			return doc.documentElement;
		},
		// 根据xpath 获取单个node 子节点
		selectSingleNode : function(path) {
			if (!this.xmlDoc)
				return null;
			if (!typeof path == 'string')
				return null;
			path = path.replace(/[,'"]/g, "");
			return getCurrentNode(this.xmlDoc,path);//Custom_selectNodes(this.xmlDoc, path);//this.xmlDoc.documentElement.selectSingleNode(path);
			// return node.selectSingleNode(path);

		},
		// 根据xpath 获取node 子节点
		selectNodes : function(node, path) {
			if (!node)
				return null;
			if (!typeof path == 'string')
				return null;
			path = path.replace(/[,'"]/g, "");
			return node.selectNodes(path);
		},
		// 删除节点
		emptyNodes : function(parentNode, nodes) {
			if (!nodes)
				return;
			if (this.isArray(nodes)) {
				while (nodes.length > 0) {
					parentNode.removeChild(nodes[nodes.length - 1]);
				}

			} else if (typeof node == "object") {
				parentNode.removeChild(nodes);
			}
		},
		// 删除所有子节点
		emptyAllNodes : function(parentNode) {
			while (elem.firstChild) {
				elem.removeChild(elem.firstChild);
			}
		},
		createNode : function(tagName, attrs, text) {
			if (!tagName)
				return null;
			var elem = this.xmlDoc.createElement(tagName);
			elem = this.setNodeAttrs(elem, attrs);
			elem = this.setNodeText(elem, text);
			return elem;
		},
		// 设置attrs ,attrs 为{name:,val:} or [{name:,val:},{name:,val:}]
		setNodeAttrs : function(node, attrs) {
			if (this.isArray(attrs)) {
				var len = attrs.length - 1;
				while (len >= 0) {
					node.setAttribute(attrs[len].name, attrs[len].val);
					len--;
				}
			} else if (typeof attrs == 'object') {
				node.setAttribute(attrs.name ? attrs.name : "", attrs.val
								? attrs.val
								: "");
			}
			return node;
		},

		setNodeText : function(node, text) {
			node.text = text || "";
			return node;
		},
		getAttrByName : function(node, attrName, defaultValue) {
			var attNode="";
			if(node){
				attNode= node.getAttributeNode(attrName);
			}
			if (attNode == null)
				return defaultValue;
			else
				return attNode.value;
		},
		addXpath : function(xpath, nodeName, index) {
			// var xpath;
			if (index || index == 0) {
				xpath = [xpath, "/", nodeName, "[", index, "]"].join("")
			} else {
				xpath = [xpath, "/", nodeName].join("");
			}
			return xpath;

			// return
			// (index || index == 0) ? xpath = [xpath, "/", nodeName, "[",
			// index, "]"].join("") : xpath = [xpath, "/", nodeName]
			// .join("");
		},

		parseNode4Json : function(node, parentXpath, index, defAttrs) {
			var nodeInfo = {};
			if (!node)
				return null;

			nodeInfo.nodeName = node.nodeName;
			nodeInfo.nodeValue = node.text;// 取得文本值;
			nodeInfo.nodeType = node.nodeType;
			nodeInfo.xpath = this.addXpath(parentXpath, node.nodeName, index);
			if (node.attributes.length > 0) {
				nodeInfo["attr"] = defAttrs || {};
				for (var j = 0; j < node.attributes.length; j++) {
					var attribute = node.attributes.item(j);
					nodeInfo["attr"][attribute.nodeName] = attribute.nodeValue;
				}
			}
			return nodeInfo;

		},

		// ==========下面是跟html dom
		// 相关==================================================
		createHTMLElement : function(tagName, attrs, text, events, children) {
			if (!tagName || tagName == "")
				return;
			var element = window.document.createElement(tagName);
			element = this.setNodeAttrs(element, attrs);
			if (text && text != "") {
				element.innerHTML = text;
			}
			if (events) {
				if (this.isArray(events)) {
					this.addMultiEventHandler(element, evnets)
				} else if (typeof events == 'object') {
					this.addEventHandler(element, events.name, events.fn);

				}
			}
			// 子节点
			if (children) {
				if (this.isArray(children)) {
					for (var i = 0, len = children.length; i < len; i++) {
						var c_element = this.createHTMLElement(
								children[i].tagName, children[i].attrs,
								children[i].text, children[i].events,
								children[i].children);
						element.appendChild(c_element);
					}
				} else if (typeof children == 'object') {
					var c_element = this.createHTMLElement(children.tagName,
							children.attrs, children.text, children.events,
							children.children);
					element.appendChild(c_element);
				}
			}
			return element;
		},

		addMultiEventHandler : function(oTarget, events) {
			if (!oTarget)
				return;
			if (this.isArray(events)) {
				var len = events.length - 1;
				while (len >= 0) {
					addEventHandler(oTarget, events[len].name, events[len].fn);
					len--;
				}
			}

		},

		/*
		 * 为某个DOM对象动态绑定事件 @oTarget 被绑定事件的DOM对象 @sEventType 被绑定的事件名，注意，不加on的事件名，如
		 * 'click' @fnHandler 被绑定的事件处理函数
		 */
		addEventHandler : function(oTarget, sEventType, fnHandler, argsObject) {
			var eventHandler = fnHandler;
			if (oTarget) {
				eventHander = function() {
					fnHandler.call(oTarget, argsObject);
				}
			}
			if (oTarget.addEventListener) {
				oTarget.addEventListener(sEventType, eventHandler, false);
			} else if (oTarget.attachEvent) // for IEs
			{
				oTarget.attachEvent("on" + sEventType, eventHandler);
			} else {
				oTarget["on" + sEventType] = eventHandler;
			}
		},

		/*
		 * 从某个DOM对象中去除某个事件 @oTarget 被绑定事件的DOM对象 @sEventType
		 * 被绑定的事件名，注意，不加on的事件名，如 'click' @fnHandler 被绑定的事件处理函数
		 */

		removeEventHandler : function(oTarget, sEventType, fnHandler) {
			if (oTarget.removeEventListener) {
				oTarget.removeEventListener(sEventType, fnHandler, false);
			} else if (oTarget.detachEvent) // for IEs
			{
				oTarget.detachEvent(sEventType, fnHandler);
			} else {
				oTarget['on' + sEventType] = undefined;
			}
		},
		insertAfter : function(newElement, targetElement) {
			var parent = targetElement.parentNode;
			if (parent.lastChild == targetElement) {
				parent.appendChild(newElement);
			} else {
				parent.insertBefore(newElement, targetElement.nextSibling);
			}
		},

		REGX_HTML_DECODE : function() {
			var reg = /&\w+;|&#(\d+);/g;
			return reg;
		},
		HTML_DECODE : 
			 {
				"&lt;" : "<",
				"&gt;" : ">",
				"&amp;" : "&",
				"&nbsp;" : " ",
				"&quot;" : "\"",
//				"&copy;" : "©",
				"&#39;" : "'"
			
		},
		decodeHtml : function(s) {
			return (typeof s != "string") ? s : s.replace(
					/&\w+;|&#(\d+);/g, function($0, $1) {
						var c = XMLParseUtil.HTML_DECODE[$0]; // 尝试查表
						if (c === undefined) {
							// Maybe is Entity Number
							if (!isNaN($1)) {
								c = String.fromCharCode(($1 == 160) ? 32 : $1);
							} else {
								// Not Entity Number
								c = $0;
							}
						}
						return c;
					});
		},

		isArray : function(obj) {
			return Object.prototype.toString.call(obj) === '[object Array]';
		}

	});
	XMLParseUtil.initBrowerInfo();
	XMLParseUtil.initDomByMozilla();
})();


function Custom_selectNodes(xmlDoc, elementPath) {
    if(!!window.ActiveXObject || "ActiveXObject" in window) {
    	xmlDoc.setProperty("SelectionLanguage","XPath");
	    return xmlDoc.selectNodes(elementPath);
	} else {
	    var xpe = new XPathEvaluator();
	    var nsResolver = xpe.createNSResolver( xmlDoc.ownerDocument == null ? xmlDoc.documentElement : xmlDoc.ownerDocument.documentElement);
	    var result = xpe.evaluate(elementPath, xmlDoc, nsResolver, 0, null);
	    var found = [];
	    var res;
	    while (res = result.iterateNext())
	         found.push(res);
	    return found;
	}
}

function getCurrentNode(xmlData,xpath){
	var reg = /\[(\d+)\]/g;;
	var _xpath =reg.exec(xpath);
	if (_xpath != null) {
//		var num = new Number(_xpath[1]);
		xpath = xpath.replace(reg,function($0, $1, $2){
			return "["+ (++$1) +"]";
		});
	}
	var currentNodes= Custom_selectNodes(xmlData,xpath);
	return currentNodes;
}
