/**
 * ERP_parser 工具,主要负责解析webservice xml 模板 结合mustanche.js 跟jquery.treeTable.js
 * base on :jquery.js
 * 
 */
jQuery.ajax({
	type : "GET",
	url : Com_Parameter.ContextPath + "tib/common/resource/js/erp.parser.jsp",
	dataType : "script",
	// 设置同步,待加载完成以后才往下执行
	async : false
});

if (!ERP_parser) {
	var ERP_parser = {
		/***********************************************************************
		 * 节点信息转换成json
		 * 
		 * @param {}
		 *            dom
		 * @param {}
		 *            preName
		 * @param {}
		 *            index
		 * @param {}
		 *            isRoot
		 */
		parseNodeInfo : function(dom, preName, index, isRoot, pMore, parentXpath) {
			var parseNode = this.getEmptyNode();
			var nodeName = dom.nodeName;
			// 节点tagName
			parseNode.extend({
						nodeName : nodeName
					});
			// 节点属性
			var attrs = this.getAttrs(dom);
			parseNode.extend({
						attrs : attrs
					});
			// 获取节点key
			parseNode.extend({
						nodeKey : this.getCurrentKey(preName, index)
					});
			// 获取父节点key
			parseNode.extend({
						parentKey : preName
					});
			// 获取xpath
			var index = nodeName.indexOf(":");
			if (index > -1) {
				nodeName = nodeName.substring(index + 1); 
			}
			if (parentXpath) {
				parseNode.extend({
					xpath : parentXpath +"/"+ nodeName
				});
			} else {
				parseNode.extend({
					xpath : "//"+ nodeName
				});
			}
			
			// 判断是否为跟节点
			if (isRoot) {
				parseNode.extend({
					root : isRoot
				});
			}
			// 获取注解
			var commentStr = this.getCommentString(dom);
			var ekp_comment = this.getCommentInfo(commentStr,
					this.defalutCommentHandler);
			parseNode.extend({
						comment : ekp_comment
					});
			// 是否有下个节点
			var next = this.hasChild(dom);
			parseNode.extend({
						hasNext : next
					});
			var dataTypeValue = this.dataTypeHandler(ekp_comment, dom);
			parseNode.extend({
						dataType : dataTypeValue
					});
			
			// SOAP组件使用
			if (dataTypeValue == "明细表") {
				parseNode.extend({isMore : true, pMore : true});
			} else if (dataTypeValue != "多值字段"){
				// 排除多值字段
				parseNode.extend({
					pMore : pMore
				});
			}
			// 多值字段特殊处理	
			if(parseNode.dataType==TibCommon_lang.sumValue){
				parseNode.extend({
							simpleType : TibCommon_lang.array
						});
				
			}else{
				var simpleType = this.getSimpleType(ekp_comment, dom);
				if (simpleType) {
					parseNode.extend({
								simpleType : simpleType
							});
				}
			}
			parseNode.extend({
							nodeValue :  dom.text||dom.textContent||""
						});
			parseNode.extend({
							isHead : this.isHeadNode(dom)
						});		
						
						
			return parseNode;
		},
		/**
		 * 判断是否为头结点
		 */
		isHeadNode:function(domNode){
			if(!domNode){
			return false;
			}
			var nodeName=domNode.nodeName;
			var str=nodeName.split(":");
			if(str.length==2){
				var h_str="Header".toLowerCase();
				var s_str=str[1].toLowerCase();
				if(s_str==h_str){
					return true;
				}
			}
			return false;
		},
		
		
		
		/***********************************************************************
		 * xml 转化成dom 对象
		 */
		parseXml : function (str) {
			if (!!window.ActiveXObject || "ActiveXObject" in window) {
				var xmlDom = new ActiveXObject("Microsoft.XMLDOM");
				xmlDom.loadXML(str);
				return xmlDom;
			} else
				return new DOMParser().parseFromString(str, "text/xml");
		},
		/***********************************************************************
		 * 获取节点Key值
		 * 
		 * @param {}
		 *            parentKey
		 * @param {}
		 *            index
		 * @return {}
		 */
		getCurrentKey : function(parentKey, index) {
			var c_preName = parentKey + "-" + index;
			return c_preName;
		},
		/***********************************************************************
		 * 获取XML节点属性信息(组装成json信息) <div>[{key:,value}]<div>
		 * 
		 * @param {}
		 *            dom
		 */
		getAttrs : function(dom) {
			var attrs = [];
			if (!dom) {
				return attrs;
			}
			var attrMap = dom.attributes;
			for (var i = 0, len = attrMap.length; i < len; i++) {
				var attribute = dom.attributes.item(i);
				var a_map = {};
				a_map["key"] = attribute.nodeName;
				a_map["value"] = attribute.nodeValue;
				attrs.push(attrs);
			}
		},
		/***********************************************************************
		 * 获取节点tagName
		 * 
		 * @param {}
		 *            dom xml节点
		 * @return {}
		 */
		getNodeName : function(dom) {
			if (dom) {
				return dom.nodeName;
			}
		},
		/***********************************************************************
		 * 获取孩子节点
		 * 
		 * @param {}
		 *            dom
		 */
		getNodeChildren : function(dom) {
			if (dom) {
				return
				$(dom).children();
			}
		},
		/***********************************************************************
		 * 获取节点注析部分字符串(全部)
		 * 
		 * @param {}
		 *            dom
		 * @return {}
		 */
		getCommentString : function(dom) {
			if (this.hasComment(dom)) {
				var preNode = dom.previousSibling;
				// 为了兼容火狐，跳过 一个换行节点
				if (preNode.nodeType != 8) {
					preNode = preNode.previousSibling;
				} 
				return preNode.nodeValue;
			}
		},
		/***********************************************************************
		 * 是否包含注析
		 * 
		 * @param {}
		 *            dom xml节点
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
		 * 节点是否包含子节点
		 * 
		 * @param {}
		 *            dom
		 * @return {Boolean}
		 */
		hasChild : function(dom) {
			if (dom) {
				if ($(dom).children() && $(dom).children().length > 0) {
					return true;
				}
			}
			return false;

		},

		/***********************************************************************
		 * 获取注析中需要的信息
		 * 
		 * @param {}
		 *            str 注析的内容string 类型
		 * @param {}
		 *            handler 解析注析内容方法(根据自己需要扩展不同)
		 */
		getCommentInfo : function(str, handler) {
			var result;
			if (str) {
				result = handler.apply(this, [str]);
			}
			return result;
		},
		/***********************************************************************
		 * 默认注释解析器 用于getCommentInfo
		 * 
		 * @param {}
		 *            str 字符串
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
				}
				else{
						try{
						return eval('(' + str + ')');
						}catch(e){
							return null;
						}
					}
			}
			return null;
		},
		/***********************************************************************
		 * 获取数据类型描述
		 * 
		 * @param {}
		 *            commentObject 注析json对象
		 * @param {}
		 *            dom xml节点
		 * @return {String} 类型描述
		 */
		dataTypeHandler : function(commentObject, dom) {
			// 有ctype属性
			if (commentObject && commentObject["ctype"]) {
				return commentObject["ctype"];
			}
			// 无
			else if (commentObject) {
				// 非叶子节点
				if (this.hasChild(dom)) {
					// 如果存在数量
					if (commentObject["maxOccurs"]) {
						if (commentObject["maxOccurs"] == "unbound"
								|| commentObject["maxOccurs"] > 1) {
							return TibCommon_lang.detailTable;
						} else if (commentObject["maxOccurs"] == 1) {
							return TibCommon_lang.objectType;
						}
					}
				}
				// 叶子节点的情况下
				else {
					if (commentObject["maxOccurs"]) {
						if (commentObject["maxOccurs"] == "unbound"
								|| commentObject["maxOccurs"] > 1) {
							if (commentObject["ctype"]) {
								return TibCommon_lang.sumValue +"(" + commentObject["ctype"] + ")";
							} else {
								return TibCommon_lang.sumValue;
							}
						} else {
							if (commentObject["ctype"]) {
								return commentObject["ctype"];
							} else {
								return TibCommon_lang.doNotKnowSimpleType;
							}
						}
					}
				}
			}
			// 没有判断就
			return "";
		},
		/***********************************************************************
		 * 判断是否叶子 如果叶子节点简单类型返回类型,非叶子undefined
		 * 
		 * @param {}
		 *            commentObject 注析
		 * @param {}
		 *            dom 节点
		 * @return {}
		 */
		getSimpleType : function(commentObject, dom) {
			if (commentObject) {
				if (!this.hasChild(dom)) {
					if (commentObject["maxOccurs"]) {
						if (commentObject["maxOccurs"] == "unbound"
								|| commentObject["maxOccurs"] > 1) {
							if (commentObject["ctype"]) {
								return commentObject["ctype"];
							}
						} else {
							if (commentObject["ctype"]) {
								return commentObject["ctype"];
							}
						}
					}
				}
			}
		},
		/***********************************************************************
		 * 根据dom节点相对路径查找对应节点,如果没有节点,则copy节点创建
		 * 
		 * @param {}
		 *            nodeKey erp-node-1-2-1-1-3
		 * @param {}
		 *            parentKey
		 * @param {}
		 *            nodeInfo
		 * @param {}
		 *            dom
		 * @param {}
		 *            startKey
		 */
		getTargetNodeByKey : function(nodeKey, parentKey, dom, startKey) {
			// JSON.stringify(jsonObj);
			if (nodeKey.lastIndexOf(startKey) >= 0) {
				var curIndex = nodeKey.lastIndexOf(startKey);
				var substr = nodeKey.substring(startKey.length);
				var indexCollection = substr.split("-");
				var curDom = dom;
				for (var i = 0, len = indexCollection.length; i < len; i++) {
					var curDom = this.getTargetChild(curDom, indexCollection[i]
									- 1);
					if (!curDom) {
						return curDom;
					}
				}
				return curDom;
			}
		},
		/***********************************************************************
		 * 获取子节点下的第index个元素
		 * 
		 * @param {}
		 *            dom 当前节点
		 * @param {}
		 *            index
		 * @return {}
		 */
		getTargetChild : function(dom, index) {
			if ($(dom) && $(dom).children() && $(dom).children().length > index) {
				return $(dom).children()[index];
			}
		},
		/**
		 * 设置目标节点值
		 * 
		 * @param {}
		 *            nodeKey 节点相对路径
		 * @param {}
		 *            parentKey 父节点路径
		 * @param {}
		 *            dom 节点
		 * @param {}
		 *            startKey 路径的前缀
		 * @param {}
		 *            nodeInfo ParseNode对象
		 */
		setTargetNode : function(nodeKey, parentKey, dom, startKey, nodeInfo) {
			var node = getTargetNodeByKey(nodeKey, parentKey, dom, startKey);
			// 根据路径找到节点
			if (node) {
				setNodeByNodeInfo(dom, nodeInfo);
			}
		},
		/**
		 * setter 节点值,包括 属性，文本值,注解 nodeInfo==>ParseNode对象
		 */
		setNodeByNodeInfo : function(dom, nodeInfo) {
			//nodeInfo = this.getEmptyNode();
			this.setNodeAttrs(dom, nodeInfo.attrs);
			this.setNodeText(dom, nodeInfo.nodeValue);
			this.setNodeComment(dom, nodeInfo.comment);
		},
		/**
		 * setter 节点文本值
		 */
		setNodeText : function(node, text) {
			 if (!!window.ActiveXObject || "ActiveXObject" in window) {
				 node.text = text || "";
			 } else{
				 node.textContent =text ||"";
			 }
			return node;
		},
		/**
		 * setter xml 节点属性 attrs={key:,value:}
		 */
		setNodeAttrs : function(node, attrs) {
			if (attrs && attrs.length > 0) {
				var len = attrs.length - 1;
				while (len >= 0) {
					node.setAttribute(attrs[len].key, attrs[len].value);
					len--;
				}
			}
			return node;
		},
		/**
		 * seter 注析内容
		 */
		setNodeComment : function(node, commentObject) {
			if (!commentObject) {
				return;
			}

			if (this.hasComment(node)) {
				// 获得当前node 的字符
				var comment_str = this.getCommentString(node);
				var comment_info = this.getCommentInfo(comment_str,
						this.defalutCommentHandler);
				var comment_sum = this.mergeInfo(comment_info, commentObject);
				var str = JSON.stringify(comment_sum);
				var preNode = node.previousSibling;
				var preStr = "";
				if (comment_str.lastIndexOf("|erp_web=") >= 0) {
					var l_index = comment_str.lastIndexOf("|erp_web=");
					preStr = comment_str.substring(0, l_index
									+ "|erp_web=".length);
				} else {
					preStr = comment_str == null ? "|erp_web=" : comment_str +"|erp_web=";
				}
				var all = preStr + str;
				this.setNodeText(preNode, all);
			} else {
				var curDocument=node.ownerDocument;
				var str = JSON.stringify(commentObject);
				var comment=curDocument.createComment(str);
				$(comment).insertBefore($(node));
			}
		},
		/***********************************************************************
		 * 合并2个json
		 * 
		 * @param {}
		 *            source 源json
		 * @param {}
		 *            extend 扩展json
		 * @return {}
		 */
		mergeInfo : function(source, extend) {
			if (!source||!(typeof source == 'object')) {
				source = extend;
			}
			if (!extend||!(typeof extend == 'object')) {
				extend = source;
				return source;
			}
			if (typeof source == 'object' && typeof extend == 'object') {
				for (var p in extend) {
					source[p] = extend[p];
				}
			}
			return source;
		},
		parseDom2Json : function(dom, iniInfo, startKey) {
			var m_info = iniInfo;
			var parseDom = $(dom);
			var inputs = parseDom.children();
			if (inputs.length > 0) {
				for (var i = 0, len = inputs.length; i < len; i++) {
					m_info = this.loopNextDOM(inputs[i], startKey, i + 1,
							m_info, true);
				}
			}
			return m_info;
		},
		/***********************************************************************
		 * 节点json格式定义
		 * 
		 * @param {}
		 *            opts 扩展参数
		 * @return {}
		 */
		getEmptyNode : function ParseNode(opts) {
			var node = {
				extend : function(opts) {
					if (opts && typeof opts == 'object') {
						for (var p in opts) {
							this[p] = opts[p];
						}
					}
				},
				// 节点标签名称
				nodeName : null,
				// 节点标记路径 etc: erp-node-1-1-2-1
				nodeKey : null,
				// 父节点标记路径 etc:erp-node-1-1-2
				parentKey : null,
				// 是否根节点
				root : null,
				// 注析json {min:,max}
				comment : null,
				// 是否存在子节点
				hasNext : null,
				// 数据类型
				dataType : null,
				// 是否为简单类型
				simpleType : null,
				nodeValue : null,
				// xml节点属性集合
				attrs : [],
				isHead:null
			}
			return node;
		},
		// pMore,parentXpath为soap定时任务同步添加
		loopNextDOM : function getNextDOM(dom, preName, index, dataJson, isRoot, pMore, parentXpath) {
			// dom 转换json
			var appendTr = ERP_parser
					.parseNodeInfo(dom, preName, index, isRoot, pMore, parentXpath);
			// 压入总数据栈中
			dataJson.info.tbody.push(appendTr);
			var c_dom = $(dom).children();
			if (c_dom && c_dom.length > 0) {
				if (appendTr.isMore) {
					pMore = true;
				}
				for (var i = 0, len = c_dom.length; i < len; i++) {
					dataJson = this.loopNextDOM(c_dom[i], appendTr.nodeKey, i
									+ 1, dataJson, false, pMore, appendTr.xpath);
				}
			}
			return dataJson;
		}

	}
}
