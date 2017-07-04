//提交表单事件
lbpm.globals.submitFormEvent=function(){
	//当简易流程界面是直接返回true,因为逻辑在lbpm.globals.simpleFlowSubmitEvent函数中
	//var commonSimpleUsages = document.getElementById("commonSimpleUsages");
	//if(commonSimpleUsages != null){
		//return true;
	//}
	var docStatus = lbpm.constant.DOCSTATUS;
	if(parseInt(docStatus) >= lbpm.constant.STATE_COMPLETED){
		return true;
	}
	var canStartProcess = document.getElementById("sysWfBusinessForm.canStartProcess");
	var operatorInfo = lbpm.globals.analysisProcessorInfoToObject();
	if(operatorInfo == null){
		canStartProcess.value = "false";
		return true;
	}
	//下以注释代码为忽视当前处理人不是流程处理人时的校验
	var currentHandlerIds = document.getElementById("sysWfBusinessForm.fdHandlerRoleInfoIds").value;
	if(lbpm.constant.METHOD == lbpm.constant.METHODEDIT && canStartProcess != null){
		var currentIdArray = currentHandlerIds.split(";");
		var flag = false;
		for(var i = 0; i < currentIdArray.length; i++){
			if(lbpm.handlerId.indexOf(currentIdArray[i]) != -1){
				flag = true;
				break;
			}
		}
		if(!flag){
			canStartProcess.value = "false";
			return true;
		}
	}
	//检查是否有一个通知方式被选择
	var systemNotifyTypeObj = document.getElementById("sysWfBusinessForm.fdSystemNotifyType");
	if(systemNotifyTypeObj != null){
		if(systemNotifyTypeObj.value == ""){
			alert(lbpm.constant.VALIDATENOTIFYTYPEISNULL);
			return false;
		}
	}
	
	//检验是否选择了操作项
	var oprGroup = $("[name='oprGroup']");
	var checkFlag = false;
	oprGroup.each(function() {
		if (this.checked || this.type == 'select' || this.type == 'select-one') {
			checkFlag = true;
			var oprArr=(this.value).split(":");
			lbpm.currentOperationType=oprArr[0];
			lbpm.currentOperationName=oprArr[1];
			return false;
		}
	});
	if((oprGroup.length > 0) && !checkFlag){
		alert(lbpm.constant.VALIDATEOPERATIONTYPEISNULL);
		return false;	
	}
	//意见长度检查
	var fdUsageContent=lbpm.operations.getfdUsageContent();
	if (fdUsageContent != null && fdUsageContent.value != "") {
		var maxLength = 2000;
		if (fdUsageContent.value.length > maxLength) {
			//新增审批意见长度判断
			var msg = lbpm.constant.ERRORMAXLENGTH;
			var title = lbpm.constant.CREATEDRAFTCOMMONUSAGES;
			msg = msg.replace(/\{0\}/, title).replace(/\{1\}/, maxLength);
			alert(msg);
			return false;
		}
	};
	lbpm.globals.setParameterOnSubmit();

	if(lbpm.currentOperationType){
		var oprClass=lbpm.operations[lbpm.currentOperationType];
		if(oprClass!=null){
			if(!oprClass.check()) return false;
			if(oprClass.setOperationParam) oprClass.setOperationParam();
		}	
	}
	//alert(document.getElementById("sysWfBusinessForm.fdParameterJson").value);
	return true;
};

//设置标准的参数项在提交前,此函数一定要在操作的setOperationParam函数前运行，方便操作扩展的时候可以覆盖一些标准的参数
lbpm.globals.setParameterOnSubmit=function(){
	var operatorInfo = lbpm.nowProcessorInfoObj;
	//var operatorInfo = lbpm.globals.getOperationParameterJson("workitemId:handlerId");
	var taskId = lbpm.globals.getOperationParameterJson("id");
 	//设置Json参数
 	lbpm.globals.setOperationParameterJson(taskId==null?"":taskId,"taskId"); //工作项ID
 	//lbpm.globals.setOperationParameterJson(lbpm.handlerId==null?"":lbpm.handlerId,"handlerId"); //处理人ID
 	//流程实例ID
 	lbpm.globals.setOperationParameterJson($("[name='sysWfBusinessForm.fdProcessId']")[0].value,"processId"); 
 	//活动类型
 	lbpm.globals.setOperationParameterJson(operatorInfo.type,"activityType");
	//设置操作类型
	if(lbpm.currentOperationType)
		lbpm.globals.setOperationParameterJson(lbpm.currentOperationType.toString(),"operationType");
	//设置操作名称
	if(lbpm.currentOperationName)
		lbpm.globals.setOperationParameterJson(lbpm.currentOperationName,"operationName", "param");
	
	//如果有分支设置分支
	$("input[name='futureNode']:checked").each(function(i){
		lbpm.globals.setOperationParameterJson(this,null,"param");
	});
	//通知方式
	$("input[name='sysWfBusinessForm.fdSystemNotifyType']").each(function(i){
		lbpm.globals.setOperationParameterJson(this,"notifyType", "param");
	});

	//通知方式优先级 add by wubing date:2014-09-18
	$("input[name='sysWfBusinessForm.fdNotifyLevel']:checked").each(function(i){
		lbpm.globals.setOperationParameterJson(this,"notifyLevel","param");
	});

	//流程结束后 --notifyOnFinish
	$("#notifyOnFinish").each(function(i){
		lbpm.globals.setOperationParameterJson(this,"notifyOnFinish", "param");
	});

	//意见--auditNode
	var auditNodeObj=lbpm.operations.getfdUsageContent();
	if(auditNodeObj) lbpm.globals.setOperationParameterJson(auditNodeObj,"auditNote", "param");
	$("input[name='sysWfBusinessForm.fdAuditNoteFdId']").each(function(i){
		lbpm.globals.setOperationParameterJson(this,"auditNoteFdId", "param");
	});
	$("input[name='sysWfBusinessForm.fdAuditNoteFrom']").each(function(i){
		lbpm.globals.setOperationParameterJson(this, "auditNoteFrom", "param");
	});
	
	lbpm.globals.setModifyParameterOnSubmit();
};

lbpm.globals.setModifyParameterOnSubmit = function() {
	if(lbpm.modifys){
		var fdFlowContent=$("[name='sysWfBusinessForm.fdFlowContent']")[0];
		var fdIsModify=$("input[name='sysWfBusinessForm.fdIsModify']")[0];
		var jsonArr=new Array();
		if(fdIsModify.value!="1"){
			var nodesModifyXML="";
			$.each(lbpm.modifys, function(index, nodeData) {
				nodesModifyXML+=WorkFlow_BuildXMLString(nodeData,lbpm.nodes[index].XMLNODENAME);
			});
			if(nodesModifyXML!=""){
				nodesModifyXML="<process><nodes>"+nodesModifyXML+"</nodes></process>";
				//fdFlowContent.value=nodesModifyXML;
				//附加操作类型
				var jsonObj={};
				jsonObj.type="additions_modifyNodeAttribute";
				jsonObj.param=nodesModifyXML;
				jsonArr.push(jsonObj);
			}
			 
		}else{		
			fdFlowContent.value=lbpm.globals.getProcessXmlString();	
			//附加操作类型
			var jsonObj={};
			jsonObj.type="additions_modifyProcess";
			jsonObj.field="fdFlowContent";
			jsonArr.push(jsonObj); 			
		}
		if(jsonArr.length>0) {
			var additionParamObj=$("input[name='sysWfBusinessForm.fdAdditionsParameterJson']")[0];
			additionParamObj.value=lbpm.globals.objectToJSONString(jsonArr);
		}
	}
};
Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = lbpm.globals.submitFormEvent;
