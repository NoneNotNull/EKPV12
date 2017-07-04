//创建操作栏
lbpm.globals.createOperationMethodGroups=function(){
	var operMethodsGroup = $("#operationMethodsGroup");
	if (operMethodsGroup.length == 0) {
		return;
	}
	var vtype = operMethodsGroup.attr('view-type');
	var operatorInfo = lbpm.globals.analysisProcessorInfoToObject();
	var view = vtype == 'select' ? (function(oprValue, oprName, oprItem, operInfo) {
		var optionHtml = "<option value='" + oprValue + ":" + oprName + "' ";
		if(oprValue == lbpm.defaultOperationType){
			optionHtml += "selected='true' ";
		}
		optionHtml += ">" + oprName + "</option>";
		return optionHtml;
	}) : (function(oprValue, oprName, oprItem, operInfo) {
		var radioButtonHTML = "<nobr><label style='padding-right:5px;'>"
				+"<input type='radio' alertText='' key='operationType' name='oprGroup' value='" + oprValue + ":" + oprName + "' ";
		if(oprValue == lbpm.defaultOperationType){
			radioButtonHTML += "checked='true' ";
		}
		radioButtonHTML += " onclick='lbpm.globals.clickOperation(this);'>" + oprName + "</label></nobr>";
		radioButtonHTML += " "; // 避免不能换行
		return radioButtonHTML;
	});
	var notify = vtype == 'select' ? (function() {
		$("#operationMethodsGroup").change(function() {
			lbpm.globals.clickOperation(this);
		});
		$("#operationMethodsGroup  option").each(function(){
			var item=this;
			var opt = lbpm.operations[item.value.split(':')[0]];
			if (opt && opt.isPassType) {
				$(item).attr('selected', true);
				return false;
			}
		});
		lbpm.globals.clickOperation($("#operationMethodsGroup")[0].value);
	}) : (function() {
		var radio = $("#operationMethodsGroup input[name='oprGroup']");
		if (radio.length == 1) {
			radio.attr('disabled', true);
			radio.attr('checked', true);
		}
		if (radio.length == 0) {
			return;
		}
		radio.each(function() {
			var thisRadio = this;
			if (this.checked) {
				lbpm.globals.clickOperation(thisRadio);
				return false;
			}
			var opt = lbpm.operations[thisRadio.value.split(':')[0]];
			if (opt && opt.isPassType) {
				$(thisRadio).attr('checked', true);
				lbpm.globals.clickOperation(thisRadio);
				return false;
			}
		});
	});
	var html = '';
	$.each(operatorInfo.operations, function(i, item) {
		html += view(item.id, item.name, item, operatorInfo);
	});
	operMethodsGroup.html(html);
	notify();
};

//流程暂存
lbpm.globals.saveDraftAction=function(btn) {
	var operatorInfo = lbpm.nowProcessorInfoObj;
	if(!operatorInfo) {
		return;
	}
	var fdUsageContent=lbpm.operations.getfdUsageContent();
	if(!fdUsageContent) {
		return;
	}
	//意见长度检查
	if(fdUsageContent.value != "") {
		var maxLength = 2000;
		if (fdUsageContent.value.length > maxLength) {
			//新增审批意见长度判断
			var msg = lbpm.constant.ERRORMAXLENGTH;
			var title = lbpm.constant.CREATEDRAFTCOMMONUSAGES;
			msg = msg.replace(/\{0\}/, title).replace(/\{1\}/, maxLength);
			//alert(msg);
			return ;
		}
	} else {
		//alert(lbpm.workitem.constant.COMMONUSAGECONTENTNOTNULL);
		return ;
	}
	if (btn)
		btn.disabled = true;
	try {
		var url = Com_Parameter.ContextPath + 'sys/lbpmservice/support/lbpm_process/lbpmProcess.do?method=saveDraft&ajax=true';
		var kmssData = new KMSSData();
		var obj = {};
		obj["taskId"] = lbpm.globals.getOperationParameterJson("id");
		obj["processId"] = $("[name='sysWfBusinessForm.fdProcessId']")[0].value;
		obj["auditNote"] = fdUsageContent.value;
		obj["auditNoteFdId"] = $("input[name='sysWfBusinessForm.fdAuditNoteFdId']").val();
		kmssData.AddHashMap(obj);
		kmssData.SendToUrl(url, function(http_request) {
			if (btn) {
				btn.disabled = false;
				alert(http_request.responseText);
			}
		});
	} catch(e) {
		throw e;
		if (btn)
			btn.disabled = false;
	}
};

//设置即将流向处理人
lbpm.globals.setHandlerInfoes=function(handlerSelectType){
	var handlerIdsObj;
	var handlerNamesObj;
	var handlerShowNames;

	if(!lbpm.nowNodeId){
		return;
	}
	handlerIdsObj = document.getElementsByName("handlerIds")[0];
	if(!handlerIdsObj){
		return;
	}

	handlerNamesObj = document.getElementsByName("handlerNames")[0];
	handlerShowNames = document.getElementById("handlerShowNames");
	handlerShowNames.innerHTML = handlerNamesObj.value;

	// 取当前节点的下一个节点ID
	var currentNodeObj=lbpm.globals.getCurrentNodeObj();
	var nextNodeObj=lbpm.globals.getNextNodeObj(currentNodeObj.id);
	nextNodeObj.handlerIds = handlerIdsObj.value;
	nextNodeObj.handlerNames = handlerNamesObj.value;
   
	if(handlerSelectType!=null){
		nextNodeObj.handlerSelectType =handlerSelectType;
	}

	//返回json对象
	var rtnNodesMapJSON= new Array();
	rtnNodesMapJSON.push({
		id:nextNodeObj.id,
		handlerIds:nextNodeObj.handlerIds,
		handlerNames:nextNodeObj.handlerNames
	});
	var param={};
	param.nodeInfos=rtnNodesMapJSON;
	lbpm.events.fireListener(lbpm.constant.EVENT_MODIFYNODEATTRIBUTE,param);
};
/**
 * 功能：判断当前用户是否有修改下一节点处理人的权限（即将流向栏出现：从组织架构选择　从备选列表中选择　使用公式定义器）
 * @param nextNodeId 下一个节点的编号如N1,N2
 */
lbpm.globals.checkModifyNextNodeAuthorization=function(nextNodeId){
	if(lbpm.nowNodeId == null){
		return false;
	}
		
	var currentNodeObj = lbpm.globals.getCurrentNodeObj();
	if(currentNodeObj.canModifyHandlerNodeIds != null && currentNodeObj.canModifyHandlerNodeIds != ""){
		var index = (currentNodeObj.canModifyHandlerNodeIds + ";").indexOf(nextNodeId + ";");
		if(index != -1){
			return true;
		}
	}
	if(currentNodeObj.mustModifyHandlerNodeIds != null && currentNodeObj.mustModifyHandlerNodeIds != ""){
		var index = (currentNodeObj.mustModifyHandlerNodeIds + ";").indexOf(nextNodeId + ";");
		if(index != -1){
			return true;
		}
	}

	return false;
};
 
 /**
  * 功能：展示当前节点的帮助信息
  */
lbpm.globals.getCurrentNodeDescription=function(){
 	var currentNodeObj = lbpm.globals.getCurrentNodeObj();
 	if(currentNodeObj && currentNodeObj.description){
 		var description = currentNodeObj.description;
 		description=description.replace(/(<pre>)|(<\/pre>)/ig,"");
 		$("#currentNodeDescription").html(description);
 	}
 };
 /**
  * 功能：当前用户有多个事务时，切换事务函数
  * @param selectObj 当一个用户有多个工作项，处理事务一栏的多个事务的下拉框对象
  * @param inInit 标识是否是初始加载，区别于用户的手工切换事务
  */
  lbpm.globals.operationItemsChanged=function(selectObj,isInit){
	if(selectObj)	lbpm.nowProcessorInfoObj=lbpm.processorInfoObj[selectObj.selectedIndex];
 	//var operatorInfo = lbpm.globals.analysisProcessorInfoToObject();
	//获取当前节点ID(指当前人所处的节点，当不是处理人，lbpm.nowNodeId不存在)
	var operatorInfo = lbpm.nowProcessorInfoObj;
	lbpm.nowNodeId=operatorInfo.nodeId;
	lbpm.globals.handlerOperationClearOperationsRow();
 	lbpm.globals.createOperationMethodGroups();
 	lbpm.globals.checkModifyAuthorization(lbpm.nowNodeId);
 	//初始化意见
 	//alert(d)
	var saveedArr=WorkFlow_LoadXMLData($("input[name='sysWfBusinessForm.fdCurNodeSavedXML']")[0].value);
	if(saveedArr.tasks && saveedArr.tasks.length>0){
		var tasksArr=$.grep(saveedArr.tasks,function(n,i){
			 return n.id==operatorInfo.id;
		});
		if(tasksArr.length>0){
			var usageContent=lbpm.operations.getfdUsageContent();			
			if(usageContent) usageContent.value=lbpm.globals.htmlUnEscape(tasksArr[0].data);
		}
	}
	if(!isInit){
		lbpm.events.fireListener(lbpm.constant.EVENT_CHANGEWORKITEM,null);
	}
 };

 /**
  * @param obj 操作栏的操作的单选框对象
  * 功能：操作单击事件
  */
lbpm.globals.clickOperation=function(obj)
{
 	var valueAndName = (typeof(obj)=="string"?obj:obj.value).split(":");
 	if (!valueAndName) return;
 	var oprValue = valueAndName[0];
 	var oldOpt = lbpm.currentOperationType;
 	if (oldOpt) {
 		var oldClass = lbpm.operations[oldOpt];
 		if (oldClass && oldClass.blur)
 			oldClass.blur();
 	}
 	var oprClass=lbpm.operations[oprValue];
 	lbpm.globals.handlerOperationClearOperationsRow();
 	if(oprClass){
 		oprClass.click(valueAndName[1], obj);
 	}	
 	// 设置当前操作是哪个
	lbpm.currentOperationType=oprValue;
};

 //设置WorkitemParameter的值
 lbpm.globals.setWorkitemParameterXML=function(obj){
 	
 };
 /*
  * @param obj 对象、也可以是字符串
  * @param key 如果此参数为null ,取obj对象的key属性
  * @param root 根JSON对象
  * @param saveObj 把解析出来的json字符保存的对象，默认为sysWfBusinessForm.fdParameterJson
  * 设置工作项参数的JSON字符串
  */
 lbpm.globals.setOperationParameterJson=function(obj,key,root,saveObj){
	 if(obj == null) {
		 return;
	 }
	 var jsonObj, objValue;
	 if(saveObj){
		 if(typeof(saveObj) == "string") {
			 if (saveObj == '') {
				 jsonObj = null;
			 } else {
				 jsonObj = $.parseJSON(saveObj);
			 }
		 }
		 else {
			 if (saveObj == null || saveObj.value == '') {
				 jsonObj = null;
			 } else {
				 jsonObj = $.parseJSON(saveObj.value);
			 }
		 }
	 } else {
		 saveObj = $("input[name='sysWfBusinessForm.fdParameterJson']")[0];
		 if (saveObj == null || saveObj.value == '') {
			 jsonObj = null;
		 } else {
			 jsonObj = $.parseJSON(saveObj.value);
		 }
	 }
	 
	 if(!jsonObj) 
		 jsonObj = {};
	 if(obj==null){
		 objValue=null;
	 } else if(typeof(obj)=="object"){
		 var qobj = $(obj);
		 key = key || (qobj.attr('key') ? qobj.attr('key') : qobj.attr('name'));
		 if(obj.type == "checkbox"){
			 objValue = obj.checked;
		 }else if(obj.type == "select-one"){
			 if (obj.options.length > 0) {
				 objValue = obj.options[obj.selectedIndex].value;
			 } else {
				 objValue = '';
			 }
		 } else{
			 objValue = obj.value;
		 }
	 }else{
		 objValue=obj;
	 }
	 
	 if(key == null){
		 return;
	 }

	if(root){
		var scriptOut="if(!jsonObj."+root+") jsonObj."+root+"=new Object();jsonObj."+root+"."+key+"=objValue;";
		(new Function("jsonObj","objValue",scriptOut))(jsonObj,objValue);
	}	
	else{
		var scriptOut="jsonObj."+key+"=objValue;";
		(new Function("jsonObj","objValue",scriptOut))(jsonObj,objValue);
	}
	if(typeof(saveObj)=="string") 
		saveObj=lbpm.globals.objectToJSONString(jsonObj);
	else
		saveObj.value=lbpm.globals.objectToJSONString(jsonObj);
 };
 
 //获取当前处理人提交身份
lbpm.globals.getRolesSelectObj=function(){
 	var handlerId = "";
	var defaultRole = function() {
 		var handlerIdentityIdsObj = document.getElementById("sysWfBusinessForm.fdHandlerRoleInfoIds");
 		var rolesIdsArray = handlerIdentityIdsObj.value.split(";");
 		return rolesIdsArray[0];
	};
	if (window.dijit) {
		var rolesSelectObj = dijit.registry.byId('rolesSelectObj');
		if (!rolesSelectObj) {
			return defaultRole();
		}
		handlerId = rolesSelectObj.get('value');
		if (handlerId != null && handlerId != '') {
			return handlerId;
		}
		return defaultRole();
	}
 	var rolesSelectObj = document.getElementsByName("rolesSelectObj")[0];
 	if(rolesSelectObj != null && rolesSelectObj.selectedIndex > -1){
 		handlerId = rolesSelectObj.options[rolesSelectObj.selectedIndex].value;
 	}else{
 		handlerId = defaultRole();
 	}
 	return handlerId;
};
lbpm.globals.validateMustSignYourSuggestion = function() {
	var flag = false;
	lbpm.events.fireListener(lbpm.constant.EVENT_validateMustSignYourSuggestion, null, function(result){
		if(result){
			flag = true;
		}
	});
	if(!flag) {
		alert(lbpm.constant.opt.MustSignYourSuggestion);
		return false;
	}
	return true;
};
$(document).ready( function() {
	lbpm.events.addListener(lbpm.constant.EVENT_validateMustSignYourSuggestion,function() {
		var fdContentObj=lbpm.operations.getfdUsageContent();
		if(fdContentObj && fdContentObj.value != ""){
			return true;
		}
		return false;
	});
});