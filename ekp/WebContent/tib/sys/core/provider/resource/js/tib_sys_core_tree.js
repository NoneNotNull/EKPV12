// 可操作状态，（可编辑、删除、新增）
	function operationStatus(locaId, nodeName, parID) {
		removeSpan();
		// Span元素
		var nodeObj = document.getElementById("sd"+ locaId);
		var newSpan = document.createElement("SPAN");
		newSpan.id = "oprationSpanId";
		// 删除节点图片
		var newDel = document.createElement("IMG");
		newDel.title = TibTree_Lang.deleteNode;
		newDel.id = "deleteId";
		newDel.src = Com_Parameter.ContextPath +"tib/sys/core/provider/resource/tree/img/delete.gif";
		newDel.style.cursor = "pointer";
		VAR_EventUtil.addEvent(newDel, "click", function(){
			if (popup != null) {
				popup.close.binding(popup)();
			}
			deleteNode();
		});
		// 编辑节点图片
		var newEdit = document.createElement("IMG");
		newEdit.id = "editId";
		newEdit.title = TibTree_Lang.editNode;
		newEdit.src = Com_Parameter.ContextPath +"tib/sys/core/provider/resource/tree/img/edit.gif";
		newEdit.style.cursor = "pointer";
		VAR_EventUtil.addEvent(newEdit, "click", function() {
			// 设置节点名称与属性
			setNodeAttrs(nodeName);
		});
		// 新增节点图片
		var newAdd = document.createElement("IMG");
		newAdd.title = TibTree_Lang.addChildNode;
		newAdd.src = Com_Parameter.ContextPath +"tib/sys/core/provider/resource/tree/img/add.gif";
		newAdd.style.cursor = "pointer";
		VAR_EventUtil.addEvent(newAdd,"click", addNode);
		// 排除in节点改名移除等操作
		if ("0" != parID) {
			newSpan.appendChild(newEdit);
			newSpan.appendChild(newDel);
		}
		newSpan.appendChild(newAdd);
		TIB_SysUtil.insertAfter(newSpan, nodeObj);	
		// 显示之前被隐藏的位置
		var nodeObj = document.getElementById("sd"+ nodeLocaId);
		if (nodeObj != null) {
			nodeObj.style.display = "";
		}
		if (popup != null) {
			popup.close.binding(popup)();
		}
		// 绑定编辑节点
		popup = new PopupLayer({trigger:"#editId",popupBlk:"#blk3",closeBtn:"#close3",
			offsets:{x:0, y:0}
		});
		// 先解绑onclick事件，再重新绑定
		$("#saveId").unbind("click");
		$("#saveId").bind("click", function(){
			// 修改保存节点名称等信息
			var newNodeName = updateNode();
			if (newNodeName != "") {
				// 关闭弹出框
				popup.close.binding(popup)();
				//operationStatus(locaId, newNodeName);
			}
		});
	}
	
	// 设置节点名称与属性
	function setNodeAttrs(nodeName) {
		var index = nodeName.indexOf("(");
		if (index != -1) {
			var nodeAttrStr = nodeName.substring(index + 1, nodeName.length - 1);
			nodeName = nodeName.substring(0, index);
			var nodeAttrs = nodeAttrStr.split(",");
			var dataTypeLength = nodeAttrs[0];
			var dtIndex = dataTypeLength.indexOf("(");
			// 检查是否存在长度
			if (dtIndex != "-1" ) {
				$("#dataType").val(dataTypeLength.substring(0, dtIndex));
				$("#length").val(dataTypeLength.substring(dtIndex + 1, dataTypeLength.length - 1));
				$("#length").attr("disabled", false);
			} else {
				$("#dataType").val(dataTypeLength);
				$("#length").val("");
				$("#length").attr("disabled", true);
			}
			// jquery1.6 attr关于true、false使用prop
			if ("null" == nodeAttrs[1]) {
				$("#required").attr("checked", false);
			} else {
				$("#required").attr("checked", true);
			}
			if (nodeAttrs.length > 2) {
				$("#multi").attr("checked", true);
			} else {
				$("#multi").attr("checked", false);
			}
		}
		$("#nodeTagName").val(nodeName);
	}

	// 删除节点
	function deleteNode() {
		var title = "删除节点";
		var content = "此节点下存在子节点，是否要删？";
		var boxParam = {
			height : 110,
			content : "当前节点下拥有子节点，是否一并删除所有子节点？只删除该节点选择否！",
			buttons : new Array("是:yesFun","否:noFun","取消")
		};
		Tib_Confirm(title, content, goConfirm, boxParam);
	}
	
	/**
	 * 点确认时操作
	 * @return
	 */
	function goConfirm() {
		var flag = isExistChild(nodeID);
		if (!flag) {
			// 不存在子节点时，直接删除，无需再次判定
			d.del('treeDiv',nodeID);
			// 预览
			dTree2Xml();
			return true;
		}
		return false;
	}
	
	// 是：仅删除父节点，子节点往上移
	function yesFun() {
		d.del('treeDiv',nodeID);
		// 预览
		dTree2Xml();
		Tib_CloseBox();
	}
	
	// 否：父子节点全部删除
	function noFun() {
		moveNode(nodeID, nodePareID);
		d.del('treeDiv',nodeID);
		// 预览
		dTree2Xml();
		Tib_CloseBox();
	}
	
	// 再次确认删除
//	function deleteNodeConfirm(curNodeID, curNodeParentId){
//		$("#delete_confirm_again").dialog({
//			autoOpen: true,
//			height: 170,
//			width: 250,
//			buttons: [
//				{
//					text: "是",
//					click: function() {
//						moveNode(curNodeID, curNodeParentId);
//						d.del('treeDiv',curNodeID);
//						$(this).dialog("close");
//					}
//				},
//				{
//					text: "否",
//					click: function() {
//						d.del('treeDiv',curNodeID);
//						$(this).dialog("close");
//					}
//				},
//				{
//					text: "取消",
//					click: function() {
//						$(this).dialog("close");
//					}
//				}
//			]
//		});
//	}
	
	// 删除父节点，子节点向上移
	function moveNode(curNodeId, curParentId) {
		var allo = d.aNodes;
		for(var i = 0; i < allo.length; i++) { 
			if (allo[i].pid == curNodeId) {
				d.update("treeDiv", allo[i].id, curParentId, allo[i].name, allo[i].name, '', '', '', '', true);
			}
		}
	}

	function isExistChild(cuurNodeId) {
		var allo = d.aNodes;
		for(var i = 0; i < allo.length; i++) { 
			if (allo[i].pid == cuurNodeId) {
				return true;
			}
		}
		return false;
	}
	
	function addNode() {
		if (popup != null) {
			popup.close.binding(popup)();
		}
		removeSpan();
		// 生成ID
		var childId = getMaxId();
		//d.config.inOrder = true;
		var newName = "xxx"+ childId +"(string(200),null)";
	    d.add(childId, nodeID, newName, 'urlValue', "", "", "", "", true);
	    d.draw("treeDiv");		
		// 设置好当前新增节点的属性，来到编辑保存状态并获取焦点
	    nodePareID = nodeID;
		nodeID = childId;
		nodeLocaId = getLocaId(childId);
		//operationSave(nodeLocaId, "xxx");
		operationStatus(nodeLocaId, newName, nodePareID);
		$("#editId").trigger("click");
		document.getElementById("nodeTagName").focus();
		// 获取阴影
		d.s(nodeLocaId);
		// 预览
		dTree2Xml();
	}

	// 求最大的ID+1(防止ID重复)
	function getMaxId(dObj) {
		var allo = d.aNodes;
		var max = 0;
		for(var i=0;i<allo.length;i++) { 
			if (allo[i].id > max) {
				max = allo[i].id;
			}
		}
		if (parseInt(max) > 0) {
			return max + 1;
		} else {
			return 0;
		}
	}

	/**
	 * 获取当前节点位置
	 * @param id
	 * @return
	 */
	function getLocaId(id) {
		var allo = d.aNodes;
		for(var i=0;i<allo.length;i++) { 
			if (allo[i].id == id) {
				return allo[i]._ai;
			}
		}
		return "";
	}
	
	/**
	 * 修改节点信息
	 * @return
	 */
	function updateNode() {
		// 获取保存信息对象
		var nodeNameObj = $("#nodeTagName");
		var dataTypeObj = $("#dataType");
		var lengthObj = $("#length");
		var requiredObj = $("#required");
		var multiObj = $("#multi");
		var nodeName = "";
		if (nodeNameObj != null) {
			nodeName = nodeNameObj.val();
			if(isExistNodeName(nodeID, nodePareID, nodeName)) {
				alert(TibTree_Lang.nodeNameRepeat);
				return "";
			}
			if(nodeName == ""){
				alert(TibTree_Lang.nodeNameRequired);
				return "";
			} else if (!lengthObj.attr("disabled") && lengthObj.val() == "") {
				alert(TibTree_Lang.lengthRequired);
				return "";
			} else {
				// 拼串节点名
				nodeName += "("+ dataTypeObj.val();
				var length = lengthObj.val();
				if (length != "") {
					nodeName += "("+ length +")";
				}
				var required = requiredObj.attr("checked");
				if (required) {
					nodeName += ",notnull";
				} else {
					nodeName += ",null";
				}
				var multi = multiObj.attr("checked");
				if (multi) {
					nodeName +=",multi)";
				} else {
					nodeName +=")";
				}
				d.update("treeDiv",nodeID,nodePareID,nodeName, 
					'javascript:click(\''+nodeID+'\',\''+nodePareID+'\',\''+nodeName+'\');', '', '', '', '', true);
				// 预览
				dTree2Xml();
				return nodeName;
			}
		}
		return "";   
	}
	
	// 检查是否存在该节点名称
	function isExistNodeName(curNodeId, curParentId, nodeName) {
		var allo = d.aNodes;
		for(var i=0; i < allo.length; i++) { 
			if (allo[i].pid == curParentId && allo[i].id != curNodeId) {
				var allName = allo[i].name;
				allName = allName.substring(0, allName.indexOf("("));
				if (nodeName == allName) {
					return true;
				}
			}
		}
		return false;
	}

	// 移除显示信息
	function removeSpan() {
		var oprationSpan = document.getElementById("oprationSpanId");
		if (oprationSpan != null && oprationSpan != undefined) {
			oprationSpan.parentNode.removeChild(oprationSpan);
		}
	}

	// 树转XML
	function dTree2Xml(tibEditXml) {
		var doc = TIB_SysUtil.initXMLDoc();
		var allo = d.aNodes;
		var root = doc.createElement("tib");
		var fdIfaceKey = $("input[name=fdIfaceKey]").val();
		var fdControlPattern = $("select[name=fdControlPattern]").val();
		// 获取右边xml对象属性
		var tibXmlObj = document.getElementById("tibXml");
		var tibXmlStr = $(tibXmlObj).text();
		if (tibEditXml) {
			tibXmlStr = tibEditXml;
		}
		var tibXmlDoc = TIB_SysUtil.createXmlObj(tibXmlStr);
		var tibNodeObj = $(tibXmlDoc).find("tib");
		var tibId = tibNodeObj.attr("id");
		var tibModelname = tibNodeObj.attr("modelname");
		var tibTagdb = tibNodeObj.attr("tagdb");
		
		root.setAttribute("key", fdIfaceKey);
		root.setAttribute("control", fdControlPattern);
		root.setAttribute("id", tibId ? tibId : TibTree_Lang.tibId);
		root.setAttribute("modelname", tibModelname ? tibModelname : TibTree_Lang.tibModelClassName);
		root.setAttribute("tagdb", tibTagdb ? tibTagdb : TibTree_Lang.tagdb);
		findChildNode('0', allo, root);
		doc.appendChild(root);
		var headDefinition = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
		$("#fdIfaceXml").text((headDefinition + TIB_SysUtil.XML2String(doc)).replace(/\"/g, "\\\""));
		$("#tibXml").text(TIB_SysUtil.formatXml(headDefinition + TIB_SysUtil.XML2String(doc), "   "));
		window.activeobj = tibXmlObj;
		tibXmlObj.clock=setInterval(function(){activeobj.style.height=activeobj.scrollHeight+'px';},0);
	}

	// 递归遍历从父节点往下找
	function findChildNode(parentId, allo, parentNode) {
		for(var i=0;i<allo.length;i++) { 
			if (parentId == allo[i].pid) {
				// 解析节点名
				var nodeName = allo[i].name;
				// 创建节点
				var childNode = null;
				var index = nodeName.indexOf("(");
				if (index != -1) {
					// 开始拆分节点名
					var nodeAttrStr = nodeName.substring(index + 1, nodeName.length - 1);
					nodeName = nodeName.substring(0, index);
					childNode = parentNode.ownerDocument.createElement(nodeName);
					var nodeAttrs = nodeAttrStr.split(",");
					var dataType = nodeAttrs[0];
					var required = nodeAttrs[1];
					var dataTypeInd = dataType.indexOf("(");
					if (dataTypeInd != -1) {
						var length = dataType.substring(dataTypeInd + 1, dataType.length - 1);
						dataType = dataType.substring(0, dataTypeInd);
						childNode.setAttribute("ctype", dataType);
						childNode.setAttribute("length", length);
					} else {
						childNode.setAttribute("ctype", dataType);
					}
					if ("null" == required) {
						childNode.setAttribute("required", "0");
					} else {
						childNode.setAttribute("required", "1");
					}
					if (nodeAttrs.length > 2) {
						childNode.setAttribute("multi", "1");
					} else {
						childNode.setAttribute("multi", "0");
					}
				} else {
					childNode = parentNode.ownerDocument.createElement(nodeName);
				}
				parentNode.appendChild(childNode);
				var childNodeId = allo[i].id;
				// 移除数组中元素（避免重复遍历，增加效率）
				//allo.splice(i, 1);
				// 一层一层往下找
				findChildNode(childNodeId, allo, childNode);
			}
		}
	}
	
	/**
	 * 数据类型onchange方法
	 * @param value
	 * @return
	 */
	function dataTypeChange(value) {
		if ("string" == value || "int" == value || "double" == value) {
			$("#length").attr("disabled", false);
		} else {
			$("#length").val("");
			$("#length").attr("disabled", true);
		}
	}
	
	/**
	 * 递归，为xml转树调用
	 * @param d
	 * @param obj
	 * @param parentId
	 * @return
	 */
	function loopNode(dObj, obj, parentId) {
		if (obj.length > 0) {
			var pid = parentId;
			obj.each(function(){
				var tagName = $(this)[0].tagName;
				if ("in" != tagName) {
					//alert(xpath);
					var ctype = $($(this)[0]).attr("ctype");
					var nodeName = tagName;
					if (ctype != undefined) {
						nodeName += "("+ ctype;
						var length = $($(this)[0]).attr("length");
						if (length != undefined) {
							nodeName += "("+ length +")";
						}
						var required = $($(this)[0]).attr("required");
						if (required != undefined && required == "0") {
							nodeName += ",null"; 
						} else {
							nodeName += ",notnull"; 
						}
						var multi = $($(this)[0]).attr("multi");
						if (multi != undefined && multi == "1") {
							nodeName += ",multi";
						}
						nodeName += ")";
					}
					//alert("tagName="+tagName+",ctype="+ctype);
					var id = getMaxId(dObj);
					dObj.add(id, pid, nodeName,'url', '', '' ,'', '', true);
					parentId = id;
				}
				loopNode(dObj, $(this).children(), parentId);
			});
		}
	}
	 
	function xml2DTree(){
		d = null;
		d = new dTree("d");
		d.add(0,-1,'tib');
		d.add(1,0,'in','in', "", "", "", "", true);
		var xmlStr = $("#tibXml").text();
		if (xmlStr != "") {
			var doc = TIB_SysUtil.createXmlObj(xmlStr);
			var inObjs = $(doc).find("tib in");
			loopNode(d, $(inObjs), 1);
			document.getElementById("treeDiv").innerHTML = d;
		}
		dTree2Xml();
	}
	 