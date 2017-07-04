// 选择所属服务弹出框
function dialog_list_tibSysSoapSetting() {
/*
 * function Dialog_List(mulSelect, idField, nameField, splitStr, dataBean, action, searchBean, isMulField, notNull, winTitle)
	Dialog_List(false, "wsServerSettingId", "wsServerSettingName", ";",
			"tibSysSoapFindSettingService", after_dialogSoapuiSetting,
			"tibSysSoapFindSettingService&keyword=!{keyword}", null, null,
			Res_Properties.selectService);
*/	

	Dialog_TreeList(false,"wsServerSettingId","wsServerSettingName",";",
		           "tibSysSoapFindSettingService&selectId=!{value}&type=cate",
		           titleValue,
		           "tibSysSoapFindSettingService&selectId=!{value}&type=func",
		           after_dialogSoapuiSetting,
		           "tibSysSoapFindSettingService&type=search&keyword=!{keyword}",
		           null,null,null,
		           Res_Properties.selectService);
}

/**
 * 选择所属服务之后需要调用的方法
 */
function after_dialogSoapuiSetting(rtn, soapVersionValue) {
	if (!rtn) {
		return;
	}
	
	var data = rtn.GetHashMapArray();
	if (data && data.length > 0) {
		var soapResult = data[0]["soap"];
		var soapVersionTd = $("#soapVersionTd");
		// 清空子元素
		soapVersionTd.empty();
		var str ="<input type='radio'  name='wsSoapVersion' value='!{value}'><label>!{displayName}</label>"; 
		// 如果节点不为空
		if (soapResult && soapResult.split(";")) {
			var radios = soapResult.split(";");
			for (var i = 0; i < radios.length; i++) {
				if(!radios[i]){
					continue;
				}
				var child = str.replace("!{value}", radios[i]).replace(
						"!{displayName}", radios[i]);
				// 是否编辑状态下
				if (soapVersionValue != null) {
					if (soapVersionValue == radios[i])
						//child = child.replace("!{checked}", "checked");
						child=$(child).attr('checked',true);
				} else {
					if (i == 0) {
						//child = child.replace("!{checked}", "checked");
						child=$(child).attr('checked',true);
					} else {
						child = child.replace("!{checked}", "");
						
					}
					try{
						$('select[name="wsBindFunc"]').empty();
						$('select[name="wsBindFunc"]').append($("<option value=''>=="+ Res_Properties.pleaseSelect +"==</option>"));
					}catch(e){
					}
					// 清除函数模版(非编辑状态清除)
					bindFuncChange();
				}
				
				soapVersionTd.append($(child));
			}
		}
	}
}

/**
 * 清除某个Wsdl的缓存
 * 
 * @serviceId 所属服务ID
 */
function cleanCache(serviceId) {
	if (serviceId == "") {
		return;
	}
	// 添加加载等候图片
	FUN_AppendLoadImg("wsServerSettingId");
	var data = new KMSSData();
	data.SendToBean("tibSysSoapCleanCache&serviceId=" + serviceId,
			after_cleanCache);
}

/**
 * 清理缓存后回调
 */
function after_cleanCache(rtnData) {
	var data = rtnData.GetHashMapArray();
	// 取消加载等候图片
	FUN_RemoveLoadImg("wsServerSettingId");
	if (data && data.length > 0) {
		alert(Res_Properties.cleanFail);
	} else {
		alert(Res_Properties.cleanSuccess);
	}
	_$("wsBindFunc").options.length = 1;
	bindFuncChange();
}

/**
 * 取出函数
 */
function takeOutFunc() {
	loadOptions();
}

/**
 * 加入绑定函数
 * 
 * @param rtnData
 * @param soapValue
 */
function loadOptions() {
	//var soapVersons = $(document.getElementsByName("wsSoapVersion")[0]).val();
	var check_radio=$('input:radio[name="wsSoapVersion"]:checked');
	if(!check_radio){
		return ;
	}
	// 添加加载等候图片
	FUN_AppendLoadImg("wsServerSettingId");
	// 移除错误图片
	FUN_RemoveValidMsg("wsServerSettingId");
	// 获取数据并校验
	var serviceId = $("input[name='wsServerSettingId']").val();
	var soapVerson = $(check_radio).val();
	var data = new KMSSData();
	var bean_str = "tibSysSoapSelectOptionsBean&serviceId=!{serviceId}&soapversion=!{soapversion}";
	bean_str = bean_str.replace("!{serviceId}", serviceId).replace(
			"!{soapversion}", soapVerson);
	data.SendToBean(bean_str, function(rtnVal) {
		var options = [];
				if (!rtnVal || rtnVal == "") {
					// 取消加载等候图片
					FUN_RemoveLoadImg("wsServerSettingId");
					FUN_AppendValidMsg("wsServerSettingId!"+Res_Properties.exception);
					return;
				}
				options = rtnVal.GetHashMapArray();
				refreshOption(document.getElementsByName("wsBindFunc")[0],
						options, true, $(document.getElementsByName("wsBindFunc")[0]).val());
			});

}

function refreshOption(dom, options, isempty, defVal) {
	// 取消加载等候图片
	FUN_RemoveLoadImg("wsServerSettingId");
	// 移除错误提示信息
	FUN_RemoveValidMsg("wsBindFunc");
	if (dom == null) {
		return;
	}
	$(dom).empty();
	var str = "<option !{selected} value='!{key}'>!{name}</option>";
	if (isempty) {
		var n_str = str.replace("!{key}", "").replace("!{name}", "=="+ Res_Properties.pleaseSelect +"==");
		$(dom).append(n_str);
	}
	for (var i = 0, len = options.length; i < len; i++) {
		var c_str = str.replace("!{key}", options[i]["key"]).replace("!{name}",
				options[i]["name"]);
		if (defVal && options[i]["key"] == defVal) {
			c_str = c_str.replace("!{selected}", "selected");
		} else {
			c_str = c_str.replace("!{selected}", "");
		}
		$(dom).append(c_str);
	}

}

/** ******************************************************************* */
function loadFuncInfo() {

	var b_func = $("select[name=wsBindFunc]").val();
	if (b_func == "") {
		FUN_AppendValidMsg("wsBindFunc!" + Res_Properties.selectFuncError);
		return;
	}
	$("#erp_loading_bar").show();
	var serviceId = $("input[name='wsServerSettingId']").val();
	var fdId = $("input[name='fdId']").val();
	var soapVerson =$("input[name=wsSoapVersion]:checked").val();  //   $(document.getElementsByName("wsSoapVersion")[0]).val();
	var data = new KMSSData();
	var beanStr = "tibSysSoapBindFuncImpl&serviceId=!{serviceId}&wsBindFunc=!{wsBindFunc}&soapversion=!{soapVerson}&curId=!{fdId}";
	beanStr = beanStr.replace("!{serviceId}", serviceId).replace(
			"!{wsBindFunc}", b_func).replace("!{soapVerson}", soapVerson)
			.replace("!{fdId}", fdId);
	data.SendToBean(beanStr, func_mapper_callback);

}

function hiddenTarget(domId) {
	if (domId) {
		$("#" + domId).hidde();
	}
}

function func_mapper_callback(rtnData) {
	$("#erp_loading_bar").hide();
	$("#wsMapperTemplateIn").empty();
	$("#wsMapperTemplateOut").empty();
	$("#wsMapperTemplateFault").empty();
	document.getElementsByName("wsMapperTemplate")[0].value = "";
	if ((!rtnData) || rtnData == "") {
		FUN_AppendValidMsg("wsBindFunc!" + Res_Properties.selectFuncError);
		FUN_RemoveLoadImg("wsBindFunc");
		return;
	}
	var rtnXml = rtnData.GetHashMapArray()[0]["xml"];
	if (!rtnXml) {
		return;
	}
	$(document.getElementsByName("wsMapperTemplate")[0]).val(rtnXml);
	var xmldom = createXml(rtnXml);
	reloadInfo(xmldom, true);

}

function reloadInfo(xmldom, flag) {
	/**
	 * 使用资源文件
	 */
	var spanNode = document.createElement("span");
	spanNode.id = "Include_Span_Id";
	document.body.appendChild(spanNode);
	$("#Include_Span_Id")
			.load(
					Com_Parameter.ContextPath
							+ "tib/sys/soap/connector/resource/js/resource_properties.jsp",
					function(rtnData) {
						callBackLoad(xmldom, flag);
					});
}

function callBackLoad(xmldom, flag) {
	// 防止新建时xmldom为null而继续执行
	if (xmldom == null)
		return;
		
	var m_info_in = {
		info : {
			caption : "",
			thead : [{
						th : Res_Properties.inputParam,
						width : "35%"
					}, {
						th : Res_Properties.enabled,
						width : "10%"
					}, {
						th : Res_Properties.dataType,
						width : "15%"
					}, {
						th : Res_Properties.numbers,
						width : "16%"
					}, {
						th : Res_Properties.descs,
						width : "25%"
					}],
			tbody : []
		}
	};

	var m_info_out = {
		info : {
			caption : "",
			thead : [{
						th : Res_Properties.outputParam,
						width : "35%"
					}, {
						th : Res_Properties.disp,
						width : "10%"
					}, {
						th : Res_Properties.dataType,
						width : "10%"
					}, {
						th : Res_Properties.numbers,
						width : "16%"
					}, {
						th : Res_Properties.descs,
						width : "15%"
					}, {
						th : Res_Properties.businessHandler,
						width : "15%"
					}],
			tbody : []
		}
	};
	// 错误信息
	var m_info_fault = {
		info : {
			caption : "",
			thead : [{
						th : Res_Properties.faultParam,
						width : "35%"
					}, {
						th : Res_Properties.dataType,
						width : "12%"
					}, {
						th : Res_Properties.numbers,
						width : "15%"
					}, {
						th : Res_Properties.descs,
						width : "19%"
					}],
			tbody : []
		}
	};

	var template = $("#tree_template").html();
	if (!template) {
		return;
	}

	var template_out = $("#tree_out_template").html();
	if (!template_out) {
		return;
	}
	
	var template_fault = $("#tree_fault_template").html();
	if (!template_fault) {
		return;
	}
	

	// 输入参数
	var input = $(xmldom).find("Input");
	var m_input = parseJson(input, m_info_in);
	var in_html = Mustache.render(template, m_input);

	// 输出参数
	var output = $(xmldom).find("Output");
	var m_output = parseJson(output, m_info_out);
	// var template = template_out;
	var out_html = Mustache.render(template_out, m_info_out);

	// 错误信息
	var fault = $(xmldom).find("Fault");
	var m_fault = parseJson(fault, m_info_fault);
	var fault_html = Mustache.render(template_fault, m_fault);

	$("#wsMapperTemplateIn").append($(in_html));
	$("#wsMapperTemplateOut").append($(out_html));
	$("#wsMapperTemplateFault").append($(fault_html));
	$(".erp_template").treeTable({
				initialState : "expanded"
			});
	// 为true则代表是重新抽取的，重新抽取的启用全选中
	if (flag) {
		$("input[name='nodeEnable']").prop("checked", true);
		$("input[name='allChecked']").prop("checked", true);
	}
	// 最后移除错误提示信息
	FUN_RemoveValidMsg("wsBindFunc");
	// 初始化顺序字段
	var dispObjs = $("select[name='disp']");
	var len = $(dispObjs).length;
	var optionArray = new Array();
	optionArray.push("<option value=''>="+ Res_Properties.pleaseSelect +"=</option>");
	for (var i = 1; i <= len; i++) {
		if (i == 1) {
			optionArray.push("<option value='1'>1("+ Res_Properties.showValue +")</option>");
		} else if (i == 2) {
			optionArray.push("<option value='2'>2("+ Res_Properties.actualValue +")</option>");
		} else if (i == 3) {
			optionArray.push("<option value='3'>3("+ Res_Properties.descValue +")</option>");
		} else {
			optionArray.push("<option value='"+ i +"'>"+ i +"</option>");
		}
	}
	$(dispObjs).html(optionArray);
	$("select[name='disp'][defaultValue!='']").each(function(){
		var defaultValue = $(this).attr("defaultValue");
		$(this).val(defaultValue);
	});
}

function parseJson(dom, iniInfo) {
	var m_info = iniInfo;

	var parseDom = $(dom);
	var inputs = parseDom.children();
	if (inputs.length > 0) {
		for (var i = 0, len = inputs.length; i < len; i++) {
			m_info = getNextDOM(inputs[i], "erp-node", i + 1, m_info, true);
		}
	}

	return m_info;

}

/*******************************************************************************
 * 
 * @param {}
 *            dom
 * @param {}
 *            preName
 * @param {}
 *            index
 * @param {}
 *            dataJson { info: caption:, thead: [ {th:''} ] tbody:[ {
 *            {nodeName:, nodeKey: attrs:[ key:, value: ] } } ] }
 * 
 * 
 * 
 * @return {}
 */
function getNextDOM(dom, preName, index, dataJson, isRoot) {
	var parseNode = new ParseNode({});

	// dom 转换json
	var appendTr = ERP_parser.parseNodeInfo(dom, preName, index, isRoot);
	// 压入总数据栈中
	dataJson.info.tbody.push(appendTr);
	var c_dom = $(dom).children();
	if (c_dom && c_dom.length > 0) {
		for (var i = 0, len = c_dom.length; i < len; i++) {
			dataJson = getNextDOM(c_dom[i], appendTr.nodeKey, i + 1, dataJson);
		}
	}
	return dataJson;
}

/*******************************************************************************
 * 节点json格式定义
 * 
 * @param {}
 *            opts 扩展参数
 * @return {}
 */
function ParseNode(opts) {
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
		attrs : []
	};
	return node;
}

// 把xmlString转化为对象
function createXml(str) {
	if (document.all) {
		var xmlDom = new ActiveXObject("Microsoft.XMLDOM");
		xmlDom.loadXML(str);
		return xmlDom;
	} else
		return new DOMParser().parseFromString(str, "text/xml");
}

function Erp_reset_xml(dom, elements, rootTagName) {
	var tardom = $(dom).find(rootTagName);

	$(elements).each(function(index, element) {
		var nodeKey = $(element).attr("nodeKey");
		var commentName = $(element).attr("commentNode");
		var node = ERP_parser.getTargetNodeByKey(nodeKey, null, tardom,
				"erp-node-");
		// 获取注析代码
		var comment_str = ERP_parser.getCommentString(node);
		// alert(comment_str);
		// 注析代码修改成对象
		var comment_info = ERP_parser.getCommentInfo(comment_str,
				ERP_parser.defalutCommentHandler);
		// 增加title属性
		if (commentName) {
			if(!comment_info){
				comment_info={};
			}
			var type = $(element).attr("type");
			// 增加注释属性
			if ("checkbox" == type) {
				comment_info[commentName] = $(element).prop("checked") ? "checked" : "";
			} else {
				comment_info[commentName] = $(element).val();
			}
		}
		// 设置注释代码
		ERP_parser.setNodeComment(node, comment_info);
	});

}

function Erp_webSubmit(form, type) {
	var inValue = $("#wsMapperTemplateIn").html();
	if (inValue == "") {
		FUN_AppendValidMsg("wsBindFunc!" + Res_Properties.pleaseExtraceFunc);
		return;
	}

	var keyElements = $("#wsMapperTemplateIn").find("input[nodeKey]");
	var outElements = $("#wsMapperTemplateOut").find("*[nodeKey]");
	var faultElements = $("#wsMapperTemplateFault").find("input[nodeKey]");
	var xmlstr = $(document.getElementsByName("wsMapperTemplate")[0]).val();
	var xmldom = createXml(xmlstr);

	Erp_reset_xml(xmldom, keyElements, "Input");
	Erp_reset_xml(xmldom, outElements, "Output");
	Erp_reset_xml(xmldom, faultElements, "Fault");
	$(document.getElementsByName("wsMapperTemplate")[0]).val(xmldom.xml);
	Com_Submit(form, type);
}

function erp_toggle(elem, nodekey) {
	// edit_searchRange save_searchRange
	var classname = $(elem).attr('class');
	if (classname == 'edit_searchRange') {
		$(elem).attr("class", "save_searchRange");
		// $("#"+nodekey+"_flag")[0].display="block";//.show("fast");
		document.getElementById(nodekey + "_flag").style.display = "block";
		$("#" + nodekey + "_link").html(Res_Properties.save);
	} else {
		$(elem).attr("class", "edit_searchRange");
		// $("#"+nodekey+"_flag")[0].display="none";//.hide("fast");
		document.getElementById(nodekey + "_flag").style.display = "none";
		$("#" + nodekey + "_link").html(Res_Properties.edit);
	}

}

function partCheckedClick(thisObj, nodeKeyBefore) {
	if ($(thisObj).prop("checked")) {
		$("input[nodeKey^='"+ nodeKeyBefore +"']").prop("checked", true);
	} else {
		$("input[nodeKey^='"+ nodeKeyBefore +"']").prop("checked", false);
	}
	checkedParent(thisObj, $(thisObj).parent());
}

/**
 * 删除所有子节点
 */
function removeAllChild(elementObj) {
	while (elementObj.hasChildNodes()) {
		elementObj.removeChild(elementObj.firstChild);
	}
}

