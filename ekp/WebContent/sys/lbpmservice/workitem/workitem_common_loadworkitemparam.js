$(document).ready(function(){ 
	if(lbpm.nowProcessorInfoObj==null) return;
	lbpm.globals.loadWorkflowInfo();
	lbpm.globals.loadDefaultParameters();
	lbpm.globals.initialWorkitemParams();
	setTimeout("lbpm.globals.getThroughNodes()",200);
});   

lbpm.globals.loadWorkflowInfo=function(){
	var processorInfoObj = lbpm.globals.getProcessorInfoObj();
	if(processorInfoObj != null){
		var operationItemsRow = $("#operationItemsRow")[0];
		if(operationItemsRow != null){
			var operationItemsSelect = $("[name='operationItemsSelect']")[0];
		  	if(operationItemsSelect != null){
			  	while(operationItemsSelect.childNodes.length > 0){
			  		operationItemsSelect.removeChild(operationItemsSelect.childNodes[0]);
	 		 	}
				for(var i=0; i < processorInfoObj.length; i++){
					var processInfoShowText = "";
					var parentHandlerName=(processorInfoObj[i].parentHandlerName?processorInfoObj[i].parentHandlerName+"：":"");
					if(processorInfoObj[i].expectedName){
						processInfoShowText=processorInfoObj[i].nodeId +"."+ parentHandlerName + lbpm.nodes[processorInfoObj[i].nodeId].name+"("+processorInfoObj[i].expectedName+")";
					}else{
						processInfoShowText=processorInfoObj[i].nodeId +"."+ parentHandlerName + lbpm.nodes[processorInfoObj[i].nodeId].name;
					}
					
					option = document.createElement("option");
					option.appendChild(document.createTextNode(processInfoShowText));
					option.value=i;
					operationItemsSelect.appendChild(option);								
				}
		  	}
		  	if(processorInfoObj.length == 1) lbpm.globals.hiddenObject(operationItemsRow, true); else lbpm.globals.hiddenObject(operationItemsRow, false);
		}	
	}
};

//设置WorkitemXML的初使值
lbpm.globals.loadDefaultParameters=function(){
	var operatorInfo = lbpm.globals.getProcessorInfoObj();
	//lbpm.globals.controlIdentifyInformation();
	if(operatorInfo == null){
		lbpm.globals.validateControlItem();//当没有工作项时隐藏相关按钮 20120627 by luorf
		return;
	}
	lbpm.globals.getCurrentNodeDescription();
	var operationItemsSelect = $("[name='operationItemsSelect']")[0];
	lbpm.globals.operationItemsChanged(operationItemsSelect,true);
}

//初使化WorkitemParameter
lbpm.globals.initialWorkitemParams=function(){	
	
	var processorInfo = lbpm.globals.analysisProcessorInfoToObject();
	if(processorInfo == null){
		return;
	}
	//流程结束后通知审批人
	var notifyOnFinishObj = $("#notifyOnFinish")[0];
	if(notifyOnFinishObj != null && lbpm.flowcharts["notifyOnFinish"]){
		notifyOnFinishObj.checked = lbpm.flowcharts["notifyOnFinish"] == "true"?true:false;
	}
	
	//流程结束后通知起草人
	var notifyDraftOnFinishObj = $("#notifyDraftOnFinish")[0];
	if(notifyDraftOnFinishObj != null && lbpm.flowcharts["notifyDraftOnFinish"]){
		notifyDraftOnFinishObj.checked = lbpm.flowcharts["notifyDraftOnFinish"] == "true"?true:false;
	}

	//系统通知方式
	var systemNotifyTypeTD = document.getElementById("systemNotifyTypeTD");
	if(systemNotifyTypeTD != null && lbpm.notifyType != undefined){
		WorkFlow_RefreshNotifyType("systemNotifyTypeTD", lbpm.notifyType);
		var systemNotifyTypeObj = document.getElementsByName("sysWfBusinessForm.fdSystemNotifyType")[0];
		if(systemNotifyTypeObj != null){
			systemNotifyTypeObj.value = lbpm.notifyType;
		}
	}	
	if (systemNotifyTypeTD != null) { 
		// 如果是一个选项，就隐藏
		var fields = systemNotifyTypeTD.getElementsByTagName("INPUT");
		if (fields.length <= 2) {
			systemNotifyTypeTD.parentNode.style.display = 'none';
		}
	}
	
	//通知方式优先级 add by wubing date:2014-09-18
	var notifyLevelTD = document.getElementById("notifyLevelTD");
	if(notifyLevelTD != null){
		var fdNotifyLevelObj = document.getElementsByName("sysWfBusinessForm.fdNotifyLevel");
		if(fdNotifyLevelObj[0] != null){
			var levelObj = lbpm.globals._getProcessParameterFromAjax({paramName:"notifyLevel"});
			var levelValue = levelObj["notifyLevel"];
			if(levelValue==""){
				levelValue = 3;
			}

			for(var i=0;i<fdNotifyLevelObj.length;i++){
				if(fdNotifyLevelObj[i].value==levelValue){
					fdNotifyLevelObj[i].checked=true;
				}
			}
		}
	
		//repeat init notifyType
		var notifyTypes=["","todo;email;mobile","todo;email","todo"];
		var systemNotifyTypeTD = document.getElementById("systemNotifyTypeTD");
		if(systemNotifyTypeTD != null){
			WorkFlow_RefreshNotifyType("systemNotifyTypeTD",notifyTypes[levelValue]);
			var systemNotifyTypeObj = document.getElementsByName("sysWfBusinessForm.fdSystemNotifyType")[0];
			if(systemNotifyTypeObj != null){
				systemNotifyTypeObj.value =notifyTypes[levelValue];
			}
		}	

	}	

	//=================

};

//add by wubing date:2014-09-28，获取流程参数值(如jsonObj:{paramName:"notifyLevel"})
lbpm.globals._getProcessParameterFromAjax = function(jsonObj) {
	var jsonUrl=Com_Parameter.ContextPath+"sys/lbpmservice/include/sysLbpmParamdata.jsp" + "?m_Seq="+Math.random();
	jsonUrl += "&processId=" + $("[name='sysWfBusinessForm.fdProcessId']")[0].value;
	$.ajaxSettings.async = false;
	var jsonRtnObj=null;
	$.getJSON(jsonUrl,jsonObj, function(json){
		jsonRtnObj = json;
	});
	return jsonRtnObj;
}

//当操作人的角色发生变时，隐藏某些信息
lbpm.globals.controlIdentifyInformation=function(){
	var processorInfoObj = lbpm.processorInfoObj;
	var drafterInfoObj = lbpm.drafterInfoObj;
	var authorityInfoObj = lbpm.authorityInfoObj;
	var saveDraftButton = document.getElementById("saveDraftButton");
	var updateButton = document.getElementById("updateButton");
	var checkChangeFlowTR = document.getElementById("checkChangeFlowTR");
	var notifyOptionTR = document.getElementById("notifyOptionTR");
	//增加意见权限控制行 add by limh 2010年9月24日
	var nodeCanViewCurNodeTR = document.getElementById("nodeCanViewCurNodeTR");
	var otherCanViewCurNodeTR = document.getElementById("otherCanViewCurNodeTR");
	
 	var notifyLevelRow = document.getElementById("notifyLevelRow");

	if(processorInfoObj == null && drafterInfoObj == null && authorityInfoObj == null){
		//隐藏操作行
		var identifyRoleRow = document.getElementById("identifyRoleRow");
		lbpm.globals.hiddenObject(identifyRoleRow, true);
		var operationItemsRow = document.getElementById("operationItemsRow");
		lbpm.globals.hiddenObject(operationItemsRow, true);
		var operationMethodsRow = document.getElementById("operationMethodsRow");
		lbpm.globals.hiddenObject(operationMethodsRow, true);
		var operationsRow = document.getElementById("operationsRow");
		lbpm.globals.hiddenObject(operationsRow, true);
//		var commonUsagesRow = document.getElementById("commonUsagesRow");
//		lbpm.globals.hiddenObject(commonUsagesRow, true);
		var descriptionRow = document.getElementById("descriptionRow");
		lbpm.globals.hiddenObject(descriptionRow, true);
		var notifyTypeRow = document.getElementById("notifyTypeRow");
		lbpm.globals.hiddenObject(notifyTypeRow, true);
		var attachmentRow = document.getElementById("attachmentRow");
		lbpm.globals.hiddenObject(attachmentRow, true);
		var notifyOptionTR = document.getElementById("notifyOptionTR");
		lbpm.globals.hiddenObject(notifyOptionTR, true);
		//增加意见权限控制行 add by limh 2010年9月24日
		var nodeCanViewCurNodeTR = document.getElementById("nodeCanViewCurNodeTR");
		lbpm.globals.hiddenObject(nodeCanViewCurNodeTR, true);
		var otherCanViewCurNodeTR = document.getElementById("otherCanViewCurNodeTR");
		lbpm.globals.hiddenObject(otherCanViewCurNodeTR, true);
		
		lbpm.globals.hiddenObject(saveDraftButton, true);
		lbpm.globals.hiddenObject(updateButton, true);

 		lbpm.globals.hiddenObject(notifyLevelRow, true);

		//TODO 隐藏多级沟通放沟通操作JS中
	}else if(processorInfoObj != null){
		lbpm.globals.hiddenObject(saveDraftButton, false);
		lbpm.globals.hiddenObject(notifyOptionTR, false);	
		
 		lbpm.globals.hiddenObject(notifyLevelRow, false);

	}
	OptBar_Refresh(true);
};