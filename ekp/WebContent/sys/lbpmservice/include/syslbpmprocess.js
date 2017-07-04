Com_IncludeFile("dialog.js|formula.js");
if (this.Doc_LabelInfo) {
	Doc_LabelInfo[Doc_LabelInfo.length] = "Label_Tabel_Workflow_Info";
}
lbpm.operations.getfdUsageContent = function() {
	return $('[name=fdUsageContent]')[0];
};
$(document).ready( function() {
	
	lbpm.globals.initialContextParams();
	lbpm.globals.parseXMLObj();
	//设置节点层级，用于排序 #作者：曹映辉 #日期：2013年5月27日 
	lbpm.globals.setNodeLevel();
	lbpm.globals.parseProcessorObj();
	lbpm.events.fireListener(lbpm.constant.EVENT_FILLLBPMOBJATTU,null);
	lbpm.globals.initialSimpleWorkflow();
	lbpm.globals.initialSimpleTagWorkflow();
	lbpm.globals.validateControlItem();
	lbpm.globals.setupAttachmentRow();
});

lbpm.globals.initialContextParams=function(){
	lbpm.globals.getWfBusinessFormModelName();
	lbpm.globals.getWfBusinessFormModelId();
	lbpm.globals.getWfBusinessFormFdKey();
	lbpm.globals.getWfBusinessFormDocStatus();
	
	lbpm.handlerId=$("[name='sysWfBusinessForm.fdCurHanderId']")[0].value;
	lbpm.historyHandlers=$("[name='sysWfBusinessForm.fdFinishedNames']")[0].value;
	lbpm.currentHandlers=$("[name='sysWfBusinessForm.fdCurHanderNames']")[0].value;
	lbpm.draftorName=$("[name='sysWfBusinessForm.fdDraftorName']")[0].value;
};

//解析当前节点XML成对象
lbpm.globals.parseProcessorObj=function(){
	var curNodeXMLObj = WorkFlow_LoadXMLData($("input[name='sysWfBusinessForm.fdCurNodeXML']")[0].value);
	if((!curNodeXMLObj) || !curNodeXMLObj.nodes && !curNodeXMLObj.tasks) return; //流程结束
	//当前节点的详版XML
	if(curNodeXMLObj.nodes){
		for(var i=0,size=curNodeXMLObj.nodes.length;i<size;i++){
			var node = curNodeXMLObj.nodes[i];
			for(o in node){
				if(lbpm.nodes[node.id]){
					lbpm.nodes[node.id][o]=node[o];
				}
			}
		}
	}
	lbpm.drafterInfoObj=lbpm.globals.getDrafterInfoObj(curNodeXMLObj); //当前用户以起草人身份所拥有的信息
	lbpm.authorityInfoObj=lbpm.globals.getAuthorityInfoObj(curNodeXMLObj);//当前用户以特权人身份所拥有的信息
	lbpm.historyhandlerInfoObj=lbpm.globals.getHistoryhandlerInfoObj(curNodeXMLObj);//当前用户以已处理人身份所拥有的信息
	var processorInfoObj = lbpm.globals.getProcessorInfoObj(curNodeXMLObj);
	//processorInfoObj，打开特权人窗口或者起草人窗口处理文档时，此对象跟authorityInfoObj或者drafterInfoObj对象一样
	lbpm.processorInfoObj=processorInfoObj; //当前用户以处理人身份所拥有的信息，如所属哪个工作项
	//当有多个工作项时，也是默认取第一个
	if(processorInfoObj) {
		lbpm.nowProcessorInfoObj=processorInfoObj[0];
		if(lbpm.nowProcessorInfoObj) {
			lbpm.nowNodeId=lbpm.nowProcessorInfoObj.nodeId;
		}
	}
};

lbpm.globals.normalSorter = function(node1, node2) {
	if(node1.y==node2.y)
		return node1.x - node2.x;
	return node1.y - node2.y;
};
//内部方法外部切勿调用 #作者：曹映辉 #日期：2013年5月27日 
lbpm.globals._levelCalc=function(startNodeId,level,allNodes){
	if(!allNodes){
		allNodes=[];
	}
	if(!level){
		level=0;
	}
	
	level++;
	var nodeObj=lbpm.nodes[startNodeId];
	if(!nodeObj) {
		return;
	}
	if(nodeObj.level<level){
		nodeObj.level=level;
	}
	allNodes.push(nodeObj);
	var nextNodes = lbpm.globals.getNextNodeObjs(startNodeId);
	for(var i=0;i<nextNodes.length;i++){
		//防止循环节点 出现死循环
		var isIn=false;
		var nodeDesc = lbpm.nodedescs[nextNodes[i].nodeDescType];
		for(var j=0;j<allNodes.length;j++){
			
			//列表中已经存在的分支节点 后 表示已经形成了环形
			if(allNodes[j].id==nextNodes[i].id && nodeDesc.isBranch(nextNodes[i])){
				isIn=true;
				break;
			}
		}
		if(isIn)
		{
			continue;
		}
		lbpm.globals._levelCalc(nextNodes[i].id,level,allNodes);
	}
}
//修改为层级排序方式 #作者：曹映辉 #日期：2013年5月27日 
lbpm.globals.setNodeLevel=function(){
	lbpm.globals._levelCalc("N1");
}
lbpm.globals.levelSorter = function(node1, node2) {
	return node1.level-node2.level;
};

//系统全局的排序函数
lbpm.globals.getNodeSorter = function() {
	//routingSortNodes=lbpm.globals.getSortNodes();
	return lbpm.globals.levelSorter;
};
/*
 * 解析简版XML成lbpm对象nnn
 */
lbpm.globals.parseXMLObj=function()
{
	//解析流程的XML成对象
	var processData = WorkFlow_LoadXMLData(document.getElementById("sysWfBusinessForm.fdFlowContent").value);
	if(!processData) return;

	//节点排序
	var processNodes=processData.nodes;
	//此时流程图未加载完成，不能使用路由排序，只能使用位置排序 #作者：曹映辉 #日期：2013年5月21日 
	processNodes.sort(lbpm.globals.normalSorter);
	//流程图需要的属性
	for(o in processData){
		if(o!="nodes" && o!="lines"){
			lbpm.flowcharts[o]=processData[o];
		}		
	}
	//节点对象
	for(var i=0,j=processNodes.length; i<j; i++){
		var nodeObj=processNodes[i];
		lbpm.nodes[nodeObj.id]=nodeObj;
		lbpm.nodes[nodeObj.id].startLines=[];
		lbpm.nodes[nodeObj.id].endLines=[];
		lbpm.nodes[nodeObj.id].Status=1;
		lbpm.nodes[nodeObj.id].nodeDescType=lbpm.nodeDescMap[nodeObj.XMLNODENAME];
		lbpm.nodes[nodeObj.id].level=0;                                          //设置默认层级，用于节点排序
	}	
	//连线对象
	for(i=0; i<processData.lines.length; i++){
		var lineObj=processData.lines[i];
		lbpm.lines[lineObj.id]=lineObj;	
		//连线的起始指向的节点
		lbpm.lines[lineObj.id].startNode=lbpm.nodes[lineObj.startNodeId];
		//连线的结束指向的节点
		lbpm.lines[lineObj.id].endNode=lbpm.nodes[lineObj.endNodeId];
		//节点的结束连线
		(lbpm.nodes[lineObj.startNodeId].endLines).push(lineObj);
		//节点的开始连线
		(lbpm.nodes[lineObj.endNodeId].startLines).push(lineObj);
	}	
	//更新历史节点属性
	var processData = WorkFlow_LoadXMLData(document.getElementById("sysWfBusinessForm.fdTranProcessXML").value);
	for(i=0; i<processData.historyNodes.length; i++){
		var hNodeInfo = processData.historyNodes[i];
		var hNode = lbpm.nodes[hNodeInfo.id];
		if(hNode == null) {
			continue;
		}
		hNode.Status=2;
		hNode.targetId = hNodeInfo.targetId;
	}
	//设置节点状态是否为当前节点
	for(i=0; i<processData.runningNodes.length; i++){
		lbpm.nodes[processData.runningNodes[i].id].Status=3;
	}
	lbpm.notifyType=lbpm.flowcharts.notifyType;
	//初始化流程说明
	if(lbpm.flowcharts && lbpm.flowcharts.description) {
		var changedText = lbpm.flowcharts.description;
		changedText=changedText.replace(/&#xD;&#xA;/g,"<br />");
		changedText=changedText.replace(/&#xD;/g," ");
		changedText=changedText.replace(/&#xA;/g,"<br />");
		$("#fdFlowDescription").html(changedText);
	}
};

lbpm.globals.objectToJSONString = function (value, replacer, space) { 
	return JSON.stringify(value, replacer, space);
};

/**
* @param node 节点对象 
* 	JS文件路径
* 功能：根据节点对象获取到节点的类型，用得判断节点的类型的地方
*/
lbpm.globals.checkNodeType=function(nodeType,node){
	if(!node) return false;
	var constObj=lbpm.constant;
	var nodeDescObj=lbpm.nodedescs[node.nodeDescType];
	switch (nodeType){		
		case constObj.NODETYPE_HANDLER: // 是否是有处理人类型的节点
			return nodeDescObj["isHandler"](node);
			break;
		case constObj.NODETYPE_CANREFUSE: //是否可以被驳回（是人工处理节点，不是自动运行，不是分支，且uniqueMark为空）		
			if(nodeDescObj["isHandler"](node) && !nodeDescObj["isAutomaticRun"](node) && !nodeDescObj["isBranch"](node)){
				return true;
			}else {
				return false;
			}
			break;
		case constObj.NODETYPE_SEND: //是否是抄送节点(是人工，是自动运行，不是分支，不是子流程，不是并发，uniqueMark为空)
			if(nodeDescObj["isHandler"](node) && nodeDescObj["isAutomaticRun"](node) && !nodeDescObj["isBranch"](node) && !nodeDescObj["isSubProcess"](node) && !nodeDescObj["isConcurrent"](node) && nodeDescObj["uniqueMark"](node)==null){
				return true;
			}else {
				return false;
			}
			break;
		case constObj.NODETYPE_SPLIT: //并发分支开始（不是人工，是自动运行，是分支，不是子流程，是并发，uniqueMark为空）
		if(!nodeDescObj["isHandler"](node) && nodeDescObj["isAutomaticRun"](node) && nodeDescObj["isBranch"](node) && !nodeDescObj["isSubProcess"](node) && nodeDescObj["isConcurrent"](node) && nodeDescObj["uniqueMark"](node)==null){
				return true;
			}else {
				return false;
			}
			break;
		case constObj.NODETYPE_REVIEW: //审批节点类型（是人工，不是自动运行，不是分支，不是子流程，不是并发，uniqueMark为空）
			if(nodeDescObj["isHandler"](node) && !nodeDescObj["isAutomaticRun"](node) && !nodeDescObj["isBranch"](node) && !nodeDescObj["isSubProcess"](node) && !nodeDescObj["isConcurrent"](node) && nodeDescObj["uniqueMark"](node)==null){
				return true;
			}else {
				return false;
			}
			break;
		case constObj.NODETYPE_STARTSUBPROCESS	: //启动子流程（不是人工，是自动运行，不是分支，是子流程，是并发，uniqueMark为空）
			if(!nodeDescObj["isHandler"](node) && nodeDescObj["isAutomaticRun"](node) && !nodeDescObj["isBranch"](node) && nodeDescObj["isSubProcess"](node) && nodeDescObj["isConcurrent"](node) && nodeDescObj["uniqueMark"](node)==null){
				return true;
			}else {
				return false;
			}
			break;
		case constObj.NODETYPE_RECOVERSUBPROCESS: //结束子流程（不是人工，是自动运行，不是分支，是子流程，不是并发，uniqueMark为空）
			if(!nodeDescObj["isHandler"](node) && nodeDescObj["isAutomaticRun"](node) && !nodeDescObj["isBranch"](node) && nodeDescObj["isSubProcess"](node) && !nodeDescObj["isConcurrent"](node) && nodeDescObj["uniqueMark"](node)==null){
				return true;
			}else {
				return false;
			}
			break;			
		case constObj.NODETYPE_AUTOBRANCH: //自动分支(不是人工，是自动分支，是分支，不是子流程，不是并发，uniqueMark为空)
			if(!nodeDescObj["isHandler"](node) && nodeDescObj["isAutomaticRun"](node) && nodeDescObj["isBranch"](node) && !nodeDescObj["isSubProcess"](node) && !nodeDescObj["isConcurrent"](node) && nodeDescObj["uniqueMark"](node)==null){
				return true;
			}else {
				return false;
			}
			break;		
		case constObj.NODETYPE_MANUALBRANCH: //人工决策(是人工，不是自动运行，是分支，不是子流程，不是并发，uniqueMark为空) 
			if(nodeDescObj["isHandler"](node) && !nodeDescObj["isAutomaticRun"](node) && nodeDescObj["isBranch"](node) && !nodeDescObj["isSubProcess"](node) && !nodeDescObj["isConcurrent"](node) && nodeDescObj["uniqueMark"](node)==null){
				return true;
			}else {
				return false;
			}
			break;
		case constObj.NODETYPE_ROBOT: //机器人(不是人工，是自动运行，不是分支，不是子流程，不是并发，uniqueMark为空) 
			if(!nodeDescObj["isHandler"](node) && nodeDescObj["isAutomaticRun"](node) && !nodeDescObj["isBranch"](node) && !nodeDescObj["isSubProcess"](node) && !nodeDescObj["isConcurrent"](node) && nodeDescObj["uniqueMark"](node)==null){
				return true;
			}else {
				return false;
			}
			break;			
		default: //其他固定写死的节点（签字节点、并发分支结束节点、起草节点、开始节点、结束节点）
			if(node.nodeDescType==nodeType) return true;
   	  		break;
	};
	return false;
};
/**
* @param fileUrl 
* 	JS文件路径
* 功能：动态加载JS
*/
lbpm.globals.loadJs=function(url){ 
    var result = $.ajax({ 
    	  url: url, 
    	  async: false 
    	}).responseText; 
    if ( ( result != null ) && ( !document.getElementById( url ) ) ){ 
        var oHead = document.getElementsByTagName('HEAD').item(0); 
        var oScript = document.createElement( "script" );
        oScript.language = "javascript"; 
        oScript.type = "text/javascript"; 
        oScript.id = url; 
        oScript.defer = true; 
        oScript.text = result; 
        oHead.appendChild( oScript ); 
    } 		     
} ;
lbpm.globals.includeFile=function(fileList, contextPath, extendName){
	var i, j, fileType;
	if(contextPath==null)
		contextPath = Com_Parameter.ContextPath+"sys/";
	
	fileList = fileList.split("|");
	for(i=0; i<fileList.length; i++){
		if(fileList[i].indexOf(".jsp")==-1)
			fileList[i] = contextPath+(fileList[i]).toLowerCase();
		else
			fileList[i] = contextPath+(fileList[i]);
		if(Com_ArrayGetIndex(lbpm.jsfilelists, fileList[i])==-1){
			lbpm.jsfilelists[lbpm.jsfilelists.length] = fileList[i];
			if(extendName==null){
				j = fileList[i].lastIndexOf(".");
				if(j>-1)
					fileType = fileList[i].substring(j+1);
				else
					fileType = "js";
			}else{
				fileType = extendName;
			}
			if(Com_Parameter.Cache && fileList[i].indexOf('s_cache=')<0){
				if(fileList[i].indexOf("?")>=0){
					fileList[i] += "&s_cache=" + Com_Parameter.Cache;
				}else{
					fileList[i] += "?s_cache=" + Com_Parameter.Cache;
				}
			}
			switch(fileType){
			case "js":
				document.writeln("<script src="+fileList[i]+"></script>");
				break;
			case "css":
				document.writeln("<link rel=stylesheet href="+fileList[i]+">");
			}
		}
	}
}  ;  
lbpm.globals.initialSimpleWorkflow=function(){	
	
	//动态加载简版审批界面JS add by luorf 20120627
	if($("tr[id=simpleWorkflowRow]").size()>0)
		lbpm.globals.loadJs(Com_Parameter.ContextPath+"sys/lbpmservice/include/syslbpmprocess_simple.js");
};
//加载审批标签js
lbpm.globals.initialSimpleTagWorkflow=function(){	
	//动态加载简版审批界面JS add by luorf 20120627
	lbpm.globals.loadJs(Com_Parameter.ContextPath+"sys/lbpmservice/include/syslbpmprocess_simple_tag.js");
};
lbpm.globals.validateControlItem=function(){
 	var saveDraftButton = document.getElementById("saveDraftButton");
 	var updateButton = document.getElementById("updateButton");

 	var operationItemsRow = document.getElementById("operationItemsRow");
 	var operationMethodsRow = document.getElementById("operationMethodsRow");
 	//var operationsRow = document.getElementById("operationsRow");
 	// var commonUsagesRow = document.getElementById("commonUsagesRow");
 	var descriptionRow = document.getElementById("descriptionRow");
 	//显示隐藏签章
 	var showSignature = document.getElementById("showSignature");
 	
 	var notifyTypeRow = document.getElementById("notifyTypeRow");
 	var attachmentRow = document.getElementById("attachmentRow");
 	var notifyOptionTR = document.getElementById("notifyOptionTR");
 	var checkChangeFlowTR = document.getElementById("checkChangeFlowTR");
	//var oprNames=lbpm.globals.getOperationParameterJson("oprNames");
 	var oprNames=lbpm.globals.getOperationParameterJson("operations");

 	var notifyLevelRow = document.getElementById("notifyLevelRow");

 	if(oprNames == null || oprNames.length==0){
 		//隐藏操作行
 		lbpm.globals.hiddenObject(operationItemsRow, true);
 		lbpm.globals.hiddenObject(operationMethodsRow, true);
 		// lbpm.globals.hiddenObject(commonUsagesRow, true);
 		lbpm.globals.hiddenObject(showSignature, true);
 		lbpm.globals.hiddenObject(descriptionRow, true);
 		lbpm.globals.hiddenObject(notifyTypeRow, true);
 		lbpm.globals.hiddenObject(attachmentRow, true);
 		lbpm.globals.hiddenObject(notifyOptionTR, true);
 		lbpm.globals.hiddenObject(checkChangeFlowTR, true);
 		lbpm.globals.hiddenObject(saveDraftButton, true);
 		lbpm.globals.hiddenObject(updateButton, true);

 		lbpm.globals.hiddenObject(notifyLevelRow, true);

 	}else{
 		// 根据处理人的身份显示不同的操作项
 		lbpm.globals.hiddenObject(operationMethodsRow, false);
 		// lbpm.globals.hiddenObject(commonUsagesRow, false);
 		lbpm.globals.hiddenObject(showSignature, false);
 		lbpm.globals.hiddenObject(descriptionRow, false);
 		lbpm.globals.hiddenObject(notifyTypeRow, false);
 		lbpm.globals.hiddenObject(attachmentRow, false);
 		lbpm.globals.hiddenObject(notifyOptionTR, false);
 		lbpm.globals.hiddenObject(saveDraftButton, false);
 		lbpm.globals.hiddenObject(updateButton, false);
 		lbpm.globals.hiddenObject(checkChangeFlowTR, false);

 		lbpm.globals.hiddenObject(notifyLevelRow, false);

 	}
 	lbpm.globals.controlProcessStatusRow();
 	
 	if (window.OptBar_Refresh) {
 		OptBar_Refresh(true);
 	}
 	if(!lbpm.nowProcessorInfoObj){
 		$('#lbpm_highLevelTab').each(function() {
			lbpm.globals.setNotionPopedomTRHidden(this);
		});
	}
	lbpm.globals.showHistoryOperationInfos();
 };

// 控制流程状态行
lbpm.globals.controlProcessStatusRow=function(){
	var fdProcessStatus = $("input[name='sysWfBusinessForm.fdProcessStatus']").val();
	if(fdProcessStatus) {
		$("#processStatusRow").show();
		$("#processStatusLabel").html("<font color=red>"+fdProcessStatus+"</font>");
	}
}
 
//对附件机制的显示行的控制
 lbpm.globals.setupAttachmentRow=function(){
 	var assignmentRow = document.getElementById("assignmentRow");
 	if(assignmentRow == null){
 		return;
 	}
 	if(!lbpm.nowProcessorInfoObj){
 		lbpm.globals.hiddenObject(assignmentRow, true);
 		return;
 	}
 	lbpm.globals.hiddenObject(assignmentRow, false);
 }

lbpm.globals.hiddenObject=function(obj, flag){
	if(obj != null){
		if(flag){
			$(obj).hide();
		}else{
			$(obj).show();
		}
	}
};
//校验
lbpm.globals.validateNumber=function(obj){
	var value = obj.value;
	if(value == ""){
		alert(obj.validateKey + lbpm.constant.VALIDATEISNULL);
		return false;
	}else if(isNaN(value-0)){
		alert(obj.validateKey + lbpm.constant.VALIDATEISNAN);
		return false;
	}
	return true;
};

//取得当前节点的对象信息
lbpm.globals.getNodeObj=function(nodeId){
	if (nodeId == '' || nodeId == null) {
		return {};
	}
	return lbpm.nodes[nodeId];
};

//取得当前节点的连线对象信息
lbpm.globals.getLineObj=function(nodeId, showStartNode){
	var nodeObj=lbpm.nodes[nodeId];
	if(showStartNode == null || showStartNode == true){
		return nodeObj.startLines[0];
	}else{
		return nodeObj.endLines[0];
	}
};

//取得下一个节点的对象
lbpm.globals.getNextNodeObj=function(nodeId){
	var nodeObj=lbpm.nodes[nodeId];
	return nodeObj.endLines[0].endNode;
};

//获取当前主文档类型
lbpm.globals.getWfBusinessFormModelName=function() {
	
	var modelName = lbpm.modelName;
	var fdModelName = document.getElementsByName('sysWfBusinessForm.fdModelName');
	//#2202 修改为 优先取 sysWfBusinessForm.fdModelName 中的modelName #曹映辉 日期 2014.08.19
	if(fdModelName && fdModelName.length > 0){
		modelName = lbpm.modelName = fdModelName[0].value;
	}
	return modelName;
};
//获取当前主文档ID
lbpm.globals.getWfBusinessFormModelId=function() {
	var modelId = lbpm.modelId;
	var fdModelId = document.getElementsByName('sysWfBusinessForm.fdModelId');
	if (fdModelId && fdModelId.length>0) {
			modelId = lbpm.modelId = fdModelId[0].value;
	}
	return modelId;
};
//获取当前主文档fdkey
lbpm.globals.getWfBusinessFormFdKey=function() {
	var fdkey = lbpm.constant.FDKEY;
	var _fdkey = document.getElementsByName('sysWfBusinessForm.fdKey');
	if (_fdkey && _fdkey.length > 0) {
		fdkey = lbpm.constant.FDKEY = _fdkey[0].value;
	}
	return fdkey;
};
//获取当前主文档ID
lbpm.globals.getWfBusinessFormDocStatus=function() {
	var docStatus = lbpm.constant.DOCSTATUS;
	var _docStatus = document.getElementsByName('docStatus');
	if (_docStatus && _docStatus.length > 0) {
		docStatus = lbpm.constant.DOCSTATUS = _docStatus[0].value;
	}
	return docStatus;
};

lbpm.globals.checkModifyNodeAuthorization=function(nodeObj, allowModifyNodeId){
	if(nodeObj.mustModifyHandlerNodeIds != null && nodeObj.mustModifyHandlerNodeIds != ""){
		var index = (nodeObj.mustModifyHandlerNodeIds + ";").indexOf(allowModifyNodeId + ";");
		if(index != -1){
			return true;
		}
	}
	return false;
};

//从组织架构中选择并添加默认的备选列表
lbpm.globals.dialog_Address=function(mulSelect, idField, nameField, splitStr, selectType, action, startWith, isMulField, notNull, winTitle, treeTitle, exceptValue, nodeId, defaultOptionBean){
	var dialog = new KMSSDialog(mulSelect);
	dialog.winTitle = winTitle;
	dialog.treeTitle = treeTitle;
	dialog.addressBookParameter = new Array();
	
	if(selectType==null || selectType==0)
		selectType = ORG_TYPE_ALL;
	dialog.addressBookParameter.exceptValue = exceptValue;
	dialog.addressBookParameter.selectType = selectType;
	dialog.addressBookParameter.startWith = startWith;
	dialog.BindingField(idField, nameField, splitStr, isMulField);
	dialog.SetAfterShow(action);

	if(defaultOptionBean!=null){
		dialog.AddDefaultOptionBeanData(defaultOptionBean);
	}
	if(notNull!=null)
		dialog.notNull = notNull;
	dialog.URL = Com_Parameter.ResPath + "jsp/address_main.jsp";
	dialog.Show(640, 480);
};

//解析当前处理人的Info，返回当前操作对象
lbpm.globals.analysisProcessorInfoToObject=function(){
	return lbpm.nowProcessorInfoObj;
};

//清除操operationsRow信息，保证没有不必要的提示信息
lbpm.globals.handlerOperationClearOperationsRow=function() {
	if (lbpm.globals.destroyOperations) {
		lbpm.globals.destroyOperations();
	}
	$("[lbpmMark='operation']").each(function () {
		$(this).find("[lbpmDetail]").each(function() {
			this.innerHTML='';
		});
		$(this).find("td").each(function () {
			this.innerHTML='';
		});
		lbpm.globals.hiddenObject(this, true);
    });
	$("[lbpmMark='hide']").each(function () {
		lbpm.globals.hiddenObject(this, true);
    });
};
//是公式的情况下，为不让在对话框中出现公式，清除公式信息
lbpm.globals.clearFormulaValueForFurtureHandler=function() {
	var futureNodeObjs = document.getElementsByName("futureNode");
	var index = 0;
	for(var i = 0; i < futureNodeObjs.length; i++){
		if(futureNodeObjs[i].checked){
			index = futureNodeObjs[i].index;
			break;
		}
	}
	var handlerIdsObj = document.getElementById("handlerIds[" + index + "]");
	var handlerNamesObj = document.getElementById("handlerNames[" + index + "]");
	if (handlerIdsObj.getAttribute("isFormula") == 'true') {
		handlerIdsObj.value = '';
		handlerNamesObj.value = '';
	}
};

//显示流转日志
lbpm.globals.showHistoryDisplay=function(checkObj){
	var historyTableTR = document.getElementById("historyTableTR");
	if(checkObj.checked){
		lbpm.globals.hiddenObject(historyTableTR, false);
	}else{
		lbpm.globals.hiddenObject(historyTableTR, true);
	}
};

//显示、隐藏更多信息
lbpm.globals.showDetails=function(checked){
	var detailsRow = document.getElementById("showDetails");
	if(checked){
		lbpm.globals.hiddenObject(detailsRow, false);
	}else{
		lbpm.globals.hiddenObject(detailsRow, true);
	}
};

//取得下一节点的对象数组
lbpm.globals.getNextNodeObjs=function (nodeId){
	var nodeObj=lbpm.nodes[nodeId];
	var nextNodeObjs = new Array();
	for(var i = 0,j=nodeObj.endLines.length; i < j; i++){
		nextNodeObjs.push(nodeObj.endLines[i].endNode);
	}	
	return nextNodeObjs;	
};

//取得上一节点的对象组
lbpm.globals.getPreviousNodeObjs=function(nodeId){
	var nodeObj=lbpm.nodes[nodeId];
	var preNodeObjs = new Array();
	for(var i = 0,j=nodeObj.startLines.length; i < j; i++){
		preNodeObjs.push(nodeObj.startLines[i].startNode);
	}	
	return preNodeObjs;	
};


//取得上一节点的对象
lbpm.globals.getPreviousNodeObj=function(nodeId){
	return lbpm.globals.getPreviousNodeObjs(nodeId)[0];
};


//获取当前节点对象
lbpm.globals.getCurrentNodeObj=function(){
	if(lbpm.nowNodeId && lbpm.nowNodeId!="")
		return lbpm.nodes[lbpm.nowNodeId];
	else
		return null;
};
lbpm.globals.parseTasksInfo=function(curNodeXMLObj,taskFrom,identity){
	var tasksArr=$.grep(curNodeXMLObj.tasks,function(n,i){
		 return n.taskFrom==taskFrom;
	});
	if(tasksArr.length==0) return tasksArr;
	var _tasksArr = $.extend(true, [], tasksArr); // clone对象
	var rtnArr=$.grep(_tasksArr,function(task,i){
		if(task.operations){
			//过滤操作
			var arr=$.grep(task.operations,function(n,i){
				 return n.operationHandlerType==identity;
			});
			if(arr.length==0){
				return false;
			}
			task.operations=arr;
			return true;
		}
		return false;
	});
	return rtnArr;
}

lbpm.globals.getDrafterInfoObj=function(curNodeXMLObj){
	if(curNodeXMLObj==null) return lbpm.drafterInfoObj;
	return lbpm.globals.parseTasksInfo(curNodeXMLObj,"node","drafter");
};

lbpm.globals.getAuthorityInfoObj=function(curNodeXMLObj){
	if(curNodeXMLObj==null) return lbpm.authorityInfoObj;
	return lbpm.globals.parseTasksInfo(curNodeXMLObj,"node","admin");
};
lbpm.globals.getHistoryhandlerInfoObj=function(curNodeXMLObj){
	if(curNodeXMLObj==null) return lbpm.historyhandlerInfoObj;
	return lbpm.globals.parseTasksInfo(curNodeXMLObj,"node","historyhandler");
};
//获取当前用户的对当前流程的信息
lbpm.globals.getProcessorInfoObj=function(curNodeXMLObj){
	//LBPM当前节点的XML信息解析
	var roleType = lbpm.constant.ROLETYPE;
	if(roleType == lbpm.constant.DRAFTERROLETYPE){
		return lbpm.globals.getDrafterInfoObj(curNodeXMLObj);
	}else if(roleType == lbpm.constant.AUTHORITYROLETYPE){
		return lbpm.globals.getAuthorityInfoObj(curNodeXMLObj);
	}else if(roleType == lbpm.constant.HISTORYHANDLERROLETYPE) {
		return lbpm.globals.getHistoryhandlerInfoObj(curNodeXMLObj);
	}
	if(curNodeXMLObj==null)	return lbpm.processorInfoObj;
	return lbpm.globals.parseTasksInfo(curNodeXMLObj,"workitem","handler");
};

//跳转页面
lbpm.globals.redirectPage=function(successOrFailure){
	if(successOrFailure != lbpm.constant.SUCCESS && successOrFailure != lbpm.constant.FAILURE){
		return;
	}
	var url= Com_Parameter.ContextPath+'sys/lbpmservice/support/lbpm_process/lbpmProcess.do?method=' + successOrFailure;
	document.forms[0].action=url;
	document.forms[0].submit();
};


lbpm.globals.redirectToEditPage=function(secs){ 
	if(--secs>0){
		setTimeout("lbpm.globals.redirectToEditPage("+secs+")",10); 
	}else{
		var href = location.href;
		href = href.replace("method=view", "method=edit");
		location.href=href;
	}
} ;

/*
 是否有特权人权限
*/
lbpm.globals.outer_HasAuthorityRole=function(){
	var authorityInfoObj = lbpm.globals.getAuthorityInfoObj();
	if(authorityInfoObj != null && authorityInfoObj.length > 0){
		return true;
	}
	return false;	
};

/*
 是否有起草人权限
*/
lbpm.globals.outer_HasDrafterRole=function(){
	var drafterInfoObj = lbpm.globals.getDrafterInfoObj();
	if(drafterInfoObj != null && drafterInfoObj.length > 0){
		return true;
	}
	return false;	
};

lbpm.globals.setHandlerFormulaDialog_=function(idField, nameField, modelName, action) {
	//var getFormFieldListFunc="lbpm.globals.getFormFieldList_"+lbpm.constant.FDKEY;
	//var fieldList = (new Function('return (' + getFormFieldListFunc + '());'))();
	var fieldList = lbpm.globals.getFormFieldList();
	Formula_Dialog(idField,
			nameField,
			fieldList, 
			"com.landray.kmss.sys.organization.model.SysOrgElement[]",
			action,
			"com.landray.kmss.sys.workflow.engine.formula.WorkflowFunction",
			modelName);
};

lbpm.globals.loading_Show=function() {
	document.body.appendChild(WorkFlow_Loading_Div);
	WorkFlow_Loading_Div.style.top = 200 + document.body.scrollTop;
	WorkFlow_Loading_Div.style.left = document.body.clientWidth / 2 + document.body.scrollLeft -50;
}
lbpm.globals.loading_Hide=function() {
	WorkFlow_Loading_Div.style.display = "none";
	var div = document.getElementById('WorkFlow_Loading_Div');
	if (div)
		document.body.removeChild(WorkFlow_Loading_Div);
};

lbpm.globals.load_Frame=function(td, url) {
	var tdObj = null;
	if(typeof(td)=="string"){
		tdObj = document.getElementById(td);
	}else{
		tdObj = td;
	}
	lbpm.globals.loading_Show();
	if(tdObj!=null){
		Doc_LoadFrame(tdObj, url);
		Com_AddEventListener(tdObj.getElementsByTagName('iframe')[0], 'load', function() {
			lbpm.globals.loading_Hide();
		});
	}else{
		lbpm.globals.loading_Hide();
	}
};

// 隐藏高级页签
lbpm.globals.setNotionPopedomTRHidden=function(highLevelTR) {
	if (highLevelTR.getAttribute("LKS_LabelName") == null) {
		var highLevelTABLE = document.getElementById("Label_Tabel_Workflow_Info");
		Doc_SetCurrentLabel("Label_Tabel_Workflow_Info", 2);
		var btn = document.getElementById("Label_Tabel_Workflow_Info_Label_Btn_1");
		btn.parentNode.style.display = 'none'; // <nobr>
		highLevelTR = highLevelTABLE.rows[1];
		highLevelTR.cells[0].innerHTML = '';
	} else {
		highLevelTR.parentNode.removeChild(highLevelTR);
	}
};

//转换数组为字符串 add by limh 2010年9月24日
lbpm.globals.arrayToStringByKey=function(arr,key){
	var str="";
	if(arr){
		for(var index=0;index<arr.length;index++){
			str=str+";"+arr[index][key];
		}
		str = str.substring(1);
	}
	return str;	
};

/***********************************************
功能：获取URL中的参数（调用该函数不需要考虑编码的问题）
参数：
	url：URL
	param：参数名
返回：参数值
***********************************************/
lbpm.globals.getResponseParameter=function(url, param){
	var re = new RegExp();
	re.compile("[\\?&]"+param+"=([^&]*)", "i");
	var arr = re.exec(url);
	if(arr==null)
		return null;
	else
		return decodeURIComponent(arr[1]);
};


lbpm.globals.isPassedSubprocessNode=function() {
	var rtnValue=false;
	$.each(lbpm.nodes, function(index, nodeData) {
		if(nodeData.Status==lbpm.constant.STATUS_PASSED){
			if (lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_STARTSUBPROCESS,nodeData)) {
				rtnValue=true;
				return false; // 中断循环
			}
		}	
	})	
	return rtnValue;
};

//取得有效的当前节点
lbpm.globals.getAvailableRunningNodes=function(){
	var RunningNodesArr = new Array();
	$.each(lbpm.nodes, function(index, nodeData) {
		if(nodeData.Status==lbpm.constant.STATUS_RUNNING)
			RunningNodesArr.push(nodeData);
	});
	return RunningNodesArr;
};
//取得有效的历史节点
lbpm.globals.getAvailableHistoryNodes=function(){
	var HistoryNodesArr = new Array();
	$.each(lbpm.nodes, function(index, nodeData) {
		if(nodeData.Status==lbpm.constant.STATUS_PASSED)
			HistoryNodesArr.push(nodeData);
	});
	return HistoryNodesArr;
};

//***************以下为对外函数，提供流程的数据*****************

/*lbpm.globals.setHandlerFormulaDialog=function(idField, nameField, modelName) {
	var action = function(rtv){lbpm.globals.afterChangeHandlerInfoes(rtv,lbpm.constant.ADDRESS_SELECT_FORMULA);};
	lbpm.globals.setHandlerFormulaDialog_(idField, nameField, modelName, action);
};*/

WorkFlow_Loading_Msg = lbpm.constant.LOADINGMSG;
WorkFlow_Loading_Img = document.createElement('img');
WorkFlow_Loading_Img.src = Com_Parameter.ContextPath + "resource/style/common/images/loading.gif";
WorkFlow_Loading_Div = document.createElement('div');
WorkFlow_Loading_Div.id = "WorkFlow_Loading_Div";
WorkFlow_Loading_Div.style.position = "absolute";
WorkFlow_Loading_Div.style.padding = "5px 10px";
WorkFlow_Loading_Div.style.fontSize = "12px";
WorkFlow_Loading_Div.style.backgroundColor = "#F5F5F5";
WorkFlow_loading_Text = document.createElement("label");
WorkFlow_loading_Text.id = 'WorkFlow_loading_Text_Label';
WorkFlow_loading_Text.appendChild(document.createTextNode(WorkFlow_Loading_Msg));
WorkFlow_loading_Text.style.color = "#00F";
WorkFlow_loading_Text.style.height = "16px";
WorkFlow_loading_Text.style.margin = "5px";
WorkFlow_Loading_Div.appendChild(WorkFlow_Loading_Img);
WorkFlow_Loading_Div.appendChild(WorkFlow_loading_Text);

var concurrencyBranchSelect = lbpm.constant.CONCURRENCYBRANCHSELECT;
var concurrencyBranchTitle = lbpm.constant.CONCURRENCYBRANCHTITLE;

//显示审批记录
lbpm.globals.showHistoryOperationInfos=function(){
	var historyInfoTable = document.getElementById("historyTableTR");
	if(historyInfoTable != null){
		if(lbpm.constant.SHOWHISTORYOPERS == null || lbpm.constant.SHOWHISTORYOPERS == 'false'){
			lbpm.globals.hiddenObject(historyInfoTable, true);
			if(lbpm.constant.PRIVILEGERFLAG == 'true'){
				lbpm.globals.hiddenObject(historyInfoTable, false);
			}
		}else{
			lbpm.globals.hiddenObject(historyInfoTable, false);
		}
	}
};

//获取主文档和表单数据字典
lbpm.globals.getFormFieldList=function() {
	var fdKey = lbpm.constant.FDKEY ? lbpm.constant.FDKEY : $("[name='sysWfBusinessForm.fdKey']").val();
	var func="XForm_getXFormDesignerObj_"+fdKey;
	if(window[func]){
		return window[func]();
	} else if (window.parent 
			&& parent.dialogArguments 
			&& parent.dialogArguments.Window
			&& parent.dialogArguments.Window[func]) {
		return parent.dialogArguments.Window[func]();
	} else if (window.parent 
			&& parent.opener && parent.opener.Com_Parameter
			&& parent.opener.Com_Parameter.Dialog
			&& parent.opener.Com_Parameter.Dialog.Window
			&& parent.opener.Com_Parameter.Dialog.Window[func]) {
		return parent.opener.Com_Parameter.Dialog.Window[func]();
	}else{
		return Formula_GetVarInfoByModelName(lbpm.globals.getWfBusinessFormModelName());
	}
};
//获取后台参数
lbpm.globals.getOperationParameterJson=function(params,fromWorkitem,nodeObj){
	var processorObj=lbpm.nowProcessorInfoObj;
	var rtnObject =new Object();
	var arr=params.split(":");
	var arrNotValue=lbpm.globals.getNullParamArr(arr,processorObj);
	if(arrNotValue.length>0){
		lbpm.globals.getOperationParameterFromAjax(arrNotValue,fromWorkitem,processorObj,nodeObj);
	}
	
	for(var i=0,l=arr.length;i<l;i++){	
		var param=arr[i];
		if (!processorObj) rtnObject[param]=null;
		else{
			if(processorObj[param]!=null)
				rtnObject[param]=processorObj[param];
			else{	
				rtnObject[param]="";
				processorObj[param]="";
			}
		}
	}
	//如果传递过来是一个参数，直接返回值，不返回数组对象了
	if(arr.length==1) return rtnObject[arr[0]];
	return rtnObject;
};
//获取没有缓存的参数数组
lbpm.globals.getNullParamArr=function(arr,processorObj){
	var rtnArr=new Array();
	if(!processorObj) return rtnArr;
	for(var i=0,size=arr.length;i<size;i++){
		if(processorObj[arr[i]]==null) rtnArr.push(arr[i]);
	}
	return rtnArr;
};
//通过AJAX方式获取参数值
lbpm.globals.getOperationParameterFromAjax=function(arr,fromWorkitem,processorObj,nodeObj){
	if(!processorObj) return;
	var jsonObj = {};
	if(fromWorkitem){
		jsonObj.taskType=processorObj.type;
		jsonObj.taskId=processorObj.id;
	}else{
		//如果传递了节点对象，直接取传的节点对象，否则取当前节点对象
		if(nodeObj){
			jsonObj.nodeId=nodeObj.id;
			jsonObj.nodeType=nodeObj.XMLNODENAME;
		}else{
			jsonObj.nodeId=lbpm.nowNodeId;
			jsonObj.nodeType=lbpm.globals.getCurrentNodeObj().XMLNODENAME;
		}
	}
	jsonObj.params=arr.join(":");
	var jsonRtnObj = lbpm.globals._getOperationParameterFromAjax(jsonObj);
	if(jsonRtnObj!=null){
		for(o in jsonRtnObj){
			if(jsonRtnObj[o]!=null)
				processorObj[o]=jsonRtnObj[o];
			else
				processorObj[o]="";
		}
	}else{
		for(var i=0,size=arr.length;i<size;i++){ 
			processorObj[arr[i]]="";
		}
	};
}
lbpm.globals._getOperationParameterFromAjax = function(jsonObj) {
	var jsonUrl=Com_Parameter.ContextPath+"sys/lbpmservice/include/sysLbpmdata.jsp" + "?m_Seq="+Math.random();
	jsonUrl += "&processId=" + $("[name='sysWfBusinessForm.fdProcessId']")[0].value;
	jsonUrl += "&modelName=" + lbpm.modelName;
	$.ajaxSettings.async = false;
	var jsonRtnObj=null;
	$.getJSON(jsonUrl,jsonObj, function(json){
		jsonRtnObj = json;
	});
	return jsonRtnObj;
}
/***********************************************
功能：替换HTML代码中的敏感字符
***********************************************/
lbpm.globals.htmlUnEscape=function(s){
  	if(s==null || s=="")
  		return "";
  	var re = /&amp;/g;
  	s = s.replace(re, "&");
  	re = /&quot;/g;
  	s = s.replace(re, "\"");
  	re = /&#39;/g;
  	s = s.replace(re, "'");
  	re = /&lt;/g;
  	s = s.replace(re, "<");
  	re = /&gt;/g;
  	return s.replace(re, ">");
};

//载入流转日志
lbpm.globals.showAuditNodeLoadIframe=function(){
	var iframe = document.getElementById("auditNodeTD").getElementsByTagName("IFRAME")[0];
	if(iframe.src){
		iframe.src = Com_Parameter.ContextPath+'sys/lbpmservice/support/lbpm_audit_note/lbpmAuditNote.do?method=listFlowLog&fdModelId='+lbpm.modelId;
	}
};

lbpm.globals.showReadLogLoadIframe=function(){
	var iframe = document.getElementById("loadReadLogTD").getElementsByTagName("IFRAME")[0];
	if(iframe.src){
		iframe.src = Com_Parameter.ContextPath+'sys/workflow/sys_wf_read_log/sysWfReadLog.do?method=list&fdModelId='+lbpm.modelId;
	}
};

//加载其他JS
(function(lbpm){
	var dir="lbpmservice/include/";
	var jsPath=dir+"syslbpmprocess_event.js|"+dir+"syslbpmprocess_submit.js|"+dir+"syslbpmprocess_nodes_filter.js";
	lbpm.globals.includeFile(jsPath);
	if (!window.dojo) { // 移动不需要此文件
		lbpm.globals.includeFile(dir+"syslbpmbuildnextnodehandler.js");
	}
})(lbpm);

// 获取当前选中审批操作
lbpm.globals.getCurrentOperation = function() {
	$("[name='oprGroup']").each(function() {
		if (this.checked || this.type == 'select' || this.type == 'select-one') {
			var oprArr = (this.value).split(":");
			lbpm.currentOperationType=oprArr[0];
			lbpm.currentOperationName=oprArr[1];
			return false;
		}
	});
	if (lbpm.currentOperationType == null) {
		return null;
	}
	return {
		type: lbpm.currentOperationType,
		name: lbpm.currentOperationName,
		operation: lbpm.operations[lbpm.currentOperationType]
	};
};

lbpm.globals.initShortReview = function(text) {
	var div = document.createElement('div');// com_approval_bar2
	div.className = 'com_approval_bar2';
	div.innerHTML = '<div class="com_ap_bar2_bottom"><div class="com_ap_bar2_centre"><span>'+text+'</span></div></div>';
	document.body.appendChild(div);
	$(div).bind('click', function(event) {
		// 标签页是否展开
		var tab = LUI('process_review_tabcontent');
		if (tab != null) {
			if (!tab.isShow) {
				var panel = tab.parent;
				$.each(panel.contents, function(i) {
					if (this == tab) {
						panel.onToggle(i, false, false);
						return false;
					}
				});
			}
		}
		$('html, body').animate({
	        scrollTop: $("#operationMethodsRow").offset().top - 45
	    }, 800); // scrollIntoView
	});
	// 快速审批
	function reviewBtnLocating() {
		var form = document.forms[0];
		var left = 0;
		if(form!=null){
			left = ($(form).offset().left - 50);
			if (left < 0) left = 0;
		}
		div.style.left = left + 'px';
	}
	LUI.ready(reviewBtnLocating);
	$(window).bind({
		"scroll":function(){ 
			//reviewBtnLocating();
		},
		"resize":function(){ 
			reviewBtnLocating();
		}
	});
};
