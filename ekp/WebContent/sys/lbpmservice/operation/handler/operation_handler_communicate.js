$(document).ready(
		function() {
			if (lbpm.processorInfoObj == null && lbpm.drafterInfoObj == null
					&& lbpm.authorityInfoObj == null) {
				//隐藏多级沟通操作界面
				lbpm.globals.hidden_Communicate_Scope();
			}
		});
/*******************************************************************************
 * 功能：处理人“沟通”操作的审批所用JSP，此JSP路径在处理人“驳回”操作扩展点定义的reviewJs参数匹配 使用： 作者：罗荣飞
 * 创建时间：2012-06-06
 ******************************************************************************/
( function(operations) {
	operations['handler_communicate'] = {
		click : OperationClick,
		check : OperationCheck,
		setOperationParam : setOperationParam
	};

	// 处理人操作：沟通
	function OperationClick(operationName) {
		/*
		 * relations当前工作项关联的工作项XML(多级沟通的XML)
		 * relationWorkitemId,关联的工作项ID(指父级工作项ID)
		 * relationScope,沟通范围
		 */
		lbpm.globals.getOperationParameterJson("relationWorkitemId:relationScope:relations:isMutiCommunicate",true); // 加载后端数据
		lbpm.globals.handlerOperationTypeCommunicate(operationName);
	}

	//“沟通”操作的检查
	function OperationCheck() {
		var input = $("#toOtherHandlerIds")[0];
		if (input && input.value == "") {
			alert(input.getAttribute("alertText"));
			return false;
		}
		return lbpm.globals.validateMustSignYourSuggestion();
	}
	;
	// 设置"沟通"操作的参数
	function setOperationParam() {
		//沟通人员
		var input = $("#toOtherHandlerIds")[0];
		lbpm.globals.setOperationParameterJson(input, null, "param");
		//沟通人员名称
		input = $("#toOtherHandlerNames")[0];
		lbpm.globals.setOperationParameterJson(input, null, "param");
		
		if (window.dojo) {
			require(["dijit/registry"], function(registry) {
				var widget = registry.byId("isMutiCommunicate");
				if (widget) {
					lbpm.globals.setOperationParameterJson(widget.get("checked"),
							"isMutiCommunicate", "param");
				}
				input = $("input[key='communicateScopeHandlerIds']")[0];
				if (input) {
					lbpm.globals.setOperationParameterJson(input,
							"communicateScopeHandlerIds", "param");
				}
				widget = registry.byId("isHiddenNoteCheckbox");
				if (widget) {
					lbpm.globals.setOperationParameterJson(widget.get("checked"),
							"isHiddenNote", "param");
				}
			});
		} else {
			// 是否允许多级沟通
			input = $("input[key='isMutiCommunicate']")[0];
			if (input) {
				lbpm.globals.setOperationParameterJson(input, null, "param");
			}
			// 限制子级沟通范围
			input = $("input[key='communicateScopeHandlerIds']")[0];
			if (input) {
				lbpm.globals.setOperationParameterJson(input,
						"communicateScopeHandlerIds", "param");
			}
			// 隐藏沟通意见
			input = $("input[key='isHiddenNote']")[0];
			if(input) {
				lbpm.globals.setOperationParameterJson(input,
						"isHiddenNote", "param");
			}
		}
	}
	;

})(lbpm.operations);

// 处理人操作：沟通
lbpm.globals.handlerOperationTypeCommunicate = function(operationName,isACommunicate) {

	//清除所有operationsRow_ALL信息
	//lbpm.globals.handlerOperationClearOperationsRow();
	var html = "";

	// 设置显示当前正在沟通人员
	var relationInfoObj = lbpm.globals.getCurrRelationInfo();
	var ids = "";
	var names = "";
	if (relationInfoObj.length > 0) {

		for ( var i = 0; i < relationInfoObj.length; i++) {
			ids += relationInfoObj[i].userId + ";";
			names += relationInfoObj[i].userName + ";";
		}
		if (ids) {
			ids = ids.substr(0, ids.lastIndexOf(";"));
		}
		if (names) {
			names = names.substr(0, names.lastIndexOf(";"));
		}
		html += "<input type='hidden' name='currentCommunicateIds' value='"
				+ ids + "'/>";
		html += "<label>" + names + "</label><br/>";
	}
	var operationsRow = document.getElementById("operationsRow");
	var operationsTDTitle = document.getElementById("operationsTDTitle");
	var operationsTDContent = document.getElementById("operationsTDContent");
	operationsTDTitle.innerHTML = operationName
			+ lbpm.constant.opt.CommunicatePeople;

	var operatorInfo = lbpm.globals
			.getOperationParameterJson("relationWorkitemId:relationScope");
	var currentOrgIdsObj = document
			.getElementById("sysWfBusinessForm.fdHandlerRoleInfoIds");
	
	var options = {
			mulSelect : true,
			idField : 'toOtherHandlerIds',
			nameField : 'toOtherHandlerNames', 
			splitStr : ';',
			selectType : ORG_TYPE_PERSON|ORG_TYPE_POST,
			notNull : ids.length < 1, //如果已存在沟通人员则当前沟通人员不一定为必选的
			alertText : (lbpm.constant.opt.CommunicateIsNull + operationName + lbpm.constant.opt.CommunicatePeople),
			text : lbpm.constant.SELECTORG
	};
	// 判断是否为节点处理的第一个沟通发起者
	if (!operatorInfo.relationWorkitemId) {
		//获取所有已选的范围
		var exceptValue = lbpm.globals
				.stringConcat(currentOrgIdsObj.value, ids);
		options.exceptValue = exceptValue.split(';');
	}

	else {
		// 被沟通对象被限定范围时
		if (operatorInfo.relationScope) {
			if (lbpm.address.is_pda()) {
				operationsTDContent.innerHTML = lbpm.constant.opt.EnvironmentUnsupportOperation;
				lbpm.globals.hiddenObject(operationsRow, false);
				return;
			}
			var dataBean = "lbpmCommunicateScopeService&scopeHandles="
					+ operatorInfo.relationScope;
			var searchBean = dataBean + "&keyword=!{keyword}";
			options.onclick = "Dialog_List(true,'toOtherHandlerIds','toOtherHandlerNames',';','"
				+ dataBean
				+ "',null,'"
				+ searchBean
				+ "','','',lbpm.constant.opt.CommunicateCheckObj)";
		}
	}
	
	html += lbpm.address.html_build(options);

	//判断是否为节点处理的第一个沟通发起者,设置是否允许多级沟通
	if (!isACommunicate && (operatorInfo.isMutiCommunicate==true || operatorInfo.isMutiCommunicate==null)) {
		if (window.dojo) {
			html += "<div class='isMutiCommunicateCheckbox'>";
			html += '<div id="isMutiCommunicate" alertText="" key="isMutiCommunicate" data-dojo-type="mui/form/CheckBox"';
			html += ' data-dojo-props="name:\'isMutiCommunicate\', value:\'true\', mul:false, text:\'';
			html += lbpm.constant.opt.CommunicateScopeAllowMuti + operationName + '\'';
			html += '"></div></div>';
			if (!lbpm.globals.setCommunicateScope.listener) {
				require(["dojo/topic"], function(topic) {
					lbpm.globals.setCommunicateScope.listener = topic.subscribe('mui/form/checkbox/valueChange', function(checkbox, args) {
						if (args.name == 'isMutiCommunicate') {
							lbpm.globals.setCommunicateScope({checked:checkbox.checked, operationName: operationName});
						}
					});
				});
			}
		} else {
			html += "<label style='margin-left: 5px;'>";
			html += "<input type='checkbox' key='isMutiCommunicate' onclick='lbpm.globals.setCommunicateScope(this);' operationName='"+operationName+"' >";
			html += lbpm.constant.opt.CommunicateScopeAllowMuti + operationName;
			html += "</label>";
		}
		lbpm.globals.setCommunicateScope({checked:false}); // hack
	}
	if (!operatorInfo.relationWorkitemId) {
		// 是否隐藏沟通意见
		if (window.dojo) {
			html += "<div class='isHiddenNoteCheckbox'>";
			html += '<div id="isHiddenNoteCheckbox" alertText="" key="isHiddenNoteCheckbox" data-dojo-type="mui/form/CheckBox"';
			html += ' data-dojo-props="name:\'isHiddenNoteCheckbox\', value:\'true\', mul:false, text:\'';
			html += lbpm.constant.opt.CommunicateHiddenNote + '\'';
			html += '"></div></div>';
		} else {
			html += "<label style='margin-left: 5px;'>";
			html += "<input type='checkbox' key='isHiddenNote' value='true'>" + lbpm.constant.opt.CommunicateHiddenNote + "</label>";
		}
	}
	if (window.dojo) {
		require(['dojo/query', 'dojo/ready', 'dijit/registry', 'dojo/_base/array', 'dojo/NodeList-html'], 
				function(query, ready, registry, array) {
			ready(function() {
				query('#operationsTDContent').html(html, {parseContent: true});
				lbpm.globals.hiddenObject(operationsRow, false);
			});
		});
	} else {
		operationsTDContent.innerHTML = html;
		lbpm.globals.hiddenObject(operationsRow, false);
	}
};

lbpm.globals.hidden_Communicate_Scope = function() {
	var operationsRow_Scope = document.getElementById("operationsRow_Scope");

	if (operationsRow_Scope)
		operationsRow_Scope.style.display = "none";
};
//限定沟通范围处理
lbpm.globals.setCommunicateScope = function(sel) {
	var operationsRow_Scope = document.getElementById("operationsRow_Scope");
	// 不限定范围处理情况
	if (!sel.checked) {
		operationsRow_Scope.style.display = "none";
		lbpm.globals.handlerOperationClearOperationsRow_Scope();
	}
	//勾选限定范围处理情况
	else {
		operationsRow_Scope.style.display = "";
//		var operationsRow_Scope = document
//				.getElementById("operationsRow_Scope");
		var operationsTDTitle_Scope = document
				.getElementById("operationsTDTitle_Scope");
		var operationsTDContent_Scope = document
				.getElementById("operationsTDContent_Scope");
		// 范围包括沟通人员及 (限制子级沟通范围)
		operationsTDTitle_Scope.innerHTML = lbpm.constant.opt.CommunicateScopeLimitSub
				+ ($(sel).attr('operationName') || sel.operationName)
				+ lbpm.constant.opt.CommunicateScopeLimitScope;
		var htmlContent = "";
		var currentOrgIdsObj = document
				.getElementById("sysWfBusinessForm.fdHandlerRoleInfoIds");
		// alert(document.getElementById("currentCommunicateIds").value);
		var exceptValue = currentOrgIdsObj.value;
		if (document.getElementById("currentCommunicateIds")) {
			exceptValue = lbpm.globals.stringConcat(exceptValue, document
					.getElementById("currentCommunicateIds").value);

		}
		exceptValue = lbpm.globals.stringConcat(exceptValue, document
				.getElementById("toOtherHandlerIds").value);
		
		var options = {
				mulSelect : true,
				idField : 'communicateScopeHandlerIds',
				nameField : 'communicateScopeHandlerNames', 
				splitStr : ';',
				selectType : ORG_TYPE_PERSON|ORG_TYPE_POST,
				notNull : false,
				exceptValue : exceptValue.split(';'),
				text : lbpm.constant.SELECTORG
		};
		htmlContent += lbpm.address.html_build(options);
		htmlContent += lbpm.constant.opt.CommunicateScopeIsNullNoLimit;
		if (window.dojo) {
			dojo.query(operationsTDContent_Scope).html(htmlContent, {parseContent: true});
		} else {
			operationsTDContent_Scope.innerHTML = htmlContent;
		}
	}
};

lbpm.globals.getCurrRelationInfo = function() {
	var relationInfoObj = lbpm.globals.getRelationInfoByWorkitemId(lbpm.nowProcessorInfoObj.id);
	return relationInfoObj;
};

lbpm.globals.getRelationInfoByWorkitemId = function(id) {
	var relationInfoObj = lbpm.globals.getRelationInfo();
	if(relationInfoObj==null) return [];
	var rtn = [];
	for ( var i = 0; i < relationInfoObj.length; i++) {
		if (relationInfoObj[i].srcId == id) {
			rtn.push(relationInfoObj[i]);
		}
	}
	return rtn;
};

lbpm.globals.getRelationInfo = function() {
	var relationInfoXML=lbpm.globals.getOperationParameterJson("relations",true);
	if(relationInfoXML==null) return null;
	var relationInfoObj = WorkFlow_LoadXMLData(relationInfoXML);
	return relationInfoObj;
};

lbpm.globals.showCommunicateInfo = function(node, ShowInfoDialog) {
	//alert(ShowInfoDialog);
	ShowInfoDialog.setBodyUrl(Com_Parameter.ContextPath
			+ 'sys/lbpm/communicate/communicate_view.html?nodeId='
			+ node.Data.id);
	// ShowInfoDialog.show();
};

//清除operationsRow_Scope信息
lbpm.globals.handlerOperationClearOperationsRow_Scope = function() {
	var operationsTDTitle_Scope = document
			.getElementById("operationsTDTitle_Scope");
	var operationsTDContent_Scope = document
			.getElementById("operationsTDContent_Scope");
	if (operationsTDTitle_Scope)
		operationsTDTitle_Scope.innerHTML = '';
	if (operationsTDContent_Scope)
		operationsTDContent_Scope.innerHTML = '';
};
/**
 * 字符查连接方法
 */
lbpm.globals.stringConcat = function(str1, str2, splitChar) {
	var str1;
	var str2;
	var splitChar;
	if (!str1) {
		str1 = ";a;c";
	}
	if (!str2) {
		str2 = ";b;";
	}
	if (!splitChar) {
		splitChar = ";";
	}

	if (str1.lastIndexOf(splitChar) == str1.length - 1 && str1) {
		str1 = str1.substr(0, str1.lastIndexOf(splitChar));
	}
	if (str2.indexOf(splitChar) == 0 && str2) {
		str2 = str2.substr(1);
	}
	var str = str1 + splitChar + str2;

	if (str == splitChar) {
		str = "";

		return str;
	}
	if (str.lastIndexOf(splitChar) == str.length - 1) {
		str = str.substr(0, str.lastIndexOf(splitChar));
	}
	if (str.indexOf(splitChar) == 0) {
		str = str.substr(1);
	}
	return str;

};