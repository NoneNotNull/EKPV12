var VAR_EventUtil = new Object;
VAR_EventUtil.addEvent = function(oTarget, sEventType, funName) {
	if (oTarget.addEventListener) {// for DOM;
		oTarget.addEventListener(sEventType, funName, false);
	} else if (oTarget.attachEvent) {
		oTarget.attachEvent("on" + sEventType, funName);
	} else {
		oTarget["on" + sEventType] = funName;
	}
};
	
var TIB_SysUtil = {
	extend : function(target, exts) {
		if (!exts)
			return target;
		for (var name in exts) {
			target[name] = exts[name];
		}
		return target;
	},
	tibTreeDialog : function(opts) {
		var defaults = {
			mulSelect : false,
			idField : "",
			nameField : "",
			splitStr : ";",
			treeBean : "",
			treeTitle : "",
			dataBean : "",
			action : null,
			searchBean : "",
			exceptValue : null,
			isMulField : false,
			notNull : true,
			winTitle : ""
		};
		var data = this.extend(defaults, opts);
		Dialog_TreeList(data.mulSelect, data.idField, data.nameField,
				data.splitStr, data.treeBean, data.treeTitle, data.dataBean,
				data.action, data.searchBean, data.exceptValue,
				data.isMulField, data.notNull, data.winTitle);
	},
	tag_toggle : function(tarId, flag) {
		var elem = document.getElementById(tarId);
		if (flag && elem) {
			//elem.style.display = "block";
			$("#"+(tarId)+"").show();
		} else if (elem) {
			//elem.style.display = "none";
			$("#"+(tarId)+"").hide();
		}
	},
	tag_isFocus : function(tarId) {
		var focusId = document.activeElement.id;
		if ("tagNameListId" != focusId) {
			$("#"+(tarId)+"").hide();
		}
	},
	tag_click : function(tagElement, bindName) {
		var elements = document.getElementsByName(bindName);
		if (elements && elements.length > 0) {
			var e_value = elements[0].value;
			var a_value = tagElement.innerHTML;
			if (e_value) {
				var e_array=e_value.split(" ");
				if(!this.contains(a_value,e_array)) {
					elements[0].value = e_value + " " + a_value;
				}
			} else {
				elements[0].value = a_value;
			}
		}
	},
	tag_callBack : function(rtn, bindId, bindName) {
		if(!rtn){
			return ;
		}
		var idElem = bindId ? $("input[name=" + bindId + "]") : null;
		var nameElem = bindName ? $("input[name=" + bindName + "]") : null;
		// 收集数据
		var idVal = [];
		var nameVal = [];
		if (idElem) {
			idVal = $(idElem).val().split(" ");
		};
		if (nameElem) {
			nameVal = $(nameElem).val().split(" ");
		};
		var that = this;
		var data = rtn.GetHashMapArray()[0];
		// $(data).each(function(index, elem) {
		var iVal = data["name"];
		var nVal = data["name"];
		if (!that.contains(idVal, [iVal])) {
			idVal.push(iVal);
		}
		if (!that.contains(nameVal, [nVal])) {
			nameVal.push(nVal);
		}
		// })
		var str_val = idVal.join(" ");
		var str_name = nameVal.join(" ");
		idElem.val(str_val);
		nameElem.val(str_name);
	},
	contains : function(obj, targets) {
		if (obj == null){
			return false;
		}
		if(!(Object.prototype.toString.call(obj) === '[object Array]')){
				for (var i = 0, len = targets.length; i < len; i++) {
					if (targets[i] == obj) {
						return true;
					}
				}
		}
		else if (targets && targets.length > 0) {
			for (var i = 0, len = targets.length; i < len; i++) {
				for (var j = 0, j_len = obj.length; j < j_len; j++) {
					if (targets[i] == obj[j]) {
						return true;
					}
				}
	
			}
		}
		return false;
	},
	// 组合参数
	createUrlByParams : function(bean, params) {
		var paramUrl = "";
		if (params != null) {
			for (var name in params) {
				paramUrl += "&"+ name +"="+ params[name];
			}
		}
		return bean + paramUrl;
	},
	/***************************
	 * 发送到后台bean
	 * @bean     serviceBean
	 * @params   需要传的参数JSON格式
	 * @action   回调函数
	 */
	tibDataSendToBean : function(bean, params, action) {
		var url = this.createUrlByParams(bean, params);
		var data = new KMSSData();
		data.SendToBean(url, action);
	},
	/***********************************************
	 * 获取节点注析部分字符串(全部)
	 * @param {}    dom
	 * @return {}
	 */
	getCommentStr : function(dom) {
		if (this.hasComment(dom)) {
			var preNode = dom.previousSibling;
			// 为了兼容火狐，跳过 一个换行节点
			if (preNode.nodeType != 8) {
				preNode = preNode.previousSibling;
			} 
			return preNode.nodeValue;
		}
	},
	/***********************************************
	 * 是否包含注析
	 * @param {}   dom xml节点
	 * @return {Boolean}
	 */
	hasComment : function(dom) {
		if (dom) {
			var preNode = dom.previousSibling;
			if (preNode) {
				// 为了兼容火狐
				if (preNode.nodeType == 3) {
					preNode = preNode.previousSibling;
					if (preNode && preNode.nodeType == 8) {
						return true;
					}
				} else if (preNode.nodeType == 8) {
					return true;
				}
			}
		}
		return false;
	},
	/***********************************************************************
	 * 默认注释解析器 用于getCommentInfo
	 * @param {}     dom
	 */
	defalutCommentHandler : function(str) {
		var def_begin = "|erp_web=";
		if (str) {
			if (str.lastIndexOf(def_begin) > 0) {
				var start = str.lastIndexOf(def_begin) + def_begin.length;
				var result = str.substring(start, str.length);
				if (result) {
					return eval('(' + result + ')');
				}
			} else {
				try {
					return eval('(' + str + ')');
				} catch(e) {
					return null;
				}
			}
		}
		return null;
	},
	/****************************
	 * 获取注析中需要的信息
	 * @param {}   dom
	 * @param {}   handler 解析注析内容方法(根据自己需要扩展不同)
	 */
	 getCommentJson : function(dom, handler) {
		var str = this.getCommentStr(dom);
		var result;
		if (str) {
			result = handler.apply(this, [str]);
		}
		return result;
	},
	/*******************
	 * xml 转化成dom 对象
	 */
	createXmlObj : function (xmlStr) {
		if (document.all) {
			var xmlDom = new ActiveXObject("Microsoft.XMLDOM");
			xmlDom.loadXML(xmlStr);
			return xmlDom;
		} else
			return new DOMParser().parseFromString(xmlStr, "text/xml");
	},
	/**
	 * xml转化为String字符串
	 */
	XML2String : function (xmlObject) {
		// for IE
		if (!!window.ActiveXObject || "ActiveXObject" in window) {
			return xmlObject.xml;
		} else {
			// for other browsers
			return (new XMLSerializer()).serializeToString(xmlObject);
		}
	},
	/**
	 * 创建DOC
	 */
	initXMLDoc : function () {
		var doc;
		try {
			// Internet Explorer
			doc = new ActiveXObject("Microsoft.XMLDOM");
		} catch(e) {
			try {
				// Firefox, Mozilla, Opera, etc.
				doc = document.implementation.createDocument("","",null);
		    } catch(e) {alert(e.message)}
		}
		doc.async = false;
		return doc;
	},
	/**
	 * 在节点之后插入
	 */
	insertAfter : function(newElement,targetElement) {
		var parent = targetElement.parentNode;
        if(parent.lastChild == targetElement) {
			parent.appendChild(newElement);   
        } else {
            parent.insertBefore(newElement,targetElement.nextSibling);
        }
	},
	/**
	 * 格式化xml
	 */
	formatXml : function(text, pattern) {
		// 去掉多余的空格
		text = '\n' + text.replace(/(<\w+)(\s.*?>)/g,function($0, name, props) {
			return name + ' ' + props.replace(/\s+(\w+=)/g," $1");
		}).replace(/>\s*?</g,">\n<");
		
		// 把注释编码
		text = text.replace(/\n/g,'\r').replace(/<!--(.+?)-->/g,function($0, text) {
			var ret = '<!--' + escape(text) + '-->';
			// alert(ret);
			return ret;
		}).replace(/\r/g,'\n');
		
		// 调整格式
		var rgx = /\n(<(([^\?]).+?)(?:\s|\s*?>|\s*?(\/)>)(?:.*?(?:(?:(\/)>)|(?:<(\/)\2>)))?)/mg;
		var nodeStack = [];
		var output = text.replace(rgx,function($0,all,name,isBegin,isCloseFull1,isCloseFull2 ,isFull1,isFull2){
			var isClosed = (isCloseFull1 == '/') || (isCloseFull2 == '/' ) || (isFull1 == '/') || (isFull2 == '/');
			// alert([all,isClosed].join('='));
			var prefix = '';
			if(isBegin == '!') {
				prefix = getPrefix(nodeStack.length, pattern);
			} else {
				if(isBegin != '/') {
					prefix = getPrefix(nodeStack.length, pattern);
					if(!isClosed) {
						nodeStack.push(name);
					}
				} else {
					nodeStack.pop();
					prefix = getPrefix(nodeStack.length, pattern);
				}
			}
			var ret =  '\n' + prefix + all;
			return ret;
		});
		
		var outputText = output.substring(1);
		// 把注释还原并解码，调格式
		outputText = outputText.replace(/\n/g,'\r').replace(/(\s*)<!--(.+?)-->/g,function($0, prefix,  text) {
			//alert(['[',prefix,']=',prefix.length].join(''));
			if(prefix.charAt(0) == '\r')
				prefix = prefix.substring(1);
			text = unescape(text).replace(/\r/g,'\n');
			var ret = '\n' + prefix + '<!--' + text.replace(/^\s*/mg, prefix ) + '-->';
			return ret;
		});
		return outputText.replace(/\s+$/g,'').replace(/\r/g,'\r');
	}
		
};

function getPrefix(prefixIndex, pattern) {
	var span = pattern;
	var output = [];
	for(var i = 0 ; i < prefixIndex; ++i) {
		output.push(span);
	}
	return output.join('');
}  