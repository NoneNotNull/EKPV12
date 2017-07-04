/*
 * 流程主页面因应流程对象的变化更新相应的显示
 *
 */
lbpm.events.addListener=function (name, fun) {
	var evt = lbpm.events[name];
	if (evt == null) {
		evt = [];
		lbpm.events[name] = evt;
	}
	evt.push(fun);
};

lbpm.events.removeListener=function (name, fun) {
	var evt = lbpm.events[name];
	if (evt != null) {
		for (var i = 0; i < evt.length; i ++) {
			if (fun === evt[i]) {
				evt.splice(i, 1);
				return;
			}
		}
	}
};

lbpm.events.fireListener=function (name,param,callback) {
	var evt = lbpm.events[name];
	if (evt != null) {
		for (var i = 0; i < evt.length; i ++) {
			var res = evt[i](param);
			if(callback && res) {
				callback(res);
			}
		}
	}
};
//局部修改节点属性发布的事件
lbpm.events.modifyNodeAttributeListener=function (param){
	if(!param)	return;

	if(!lbpm.modifys) {
		lbpm.modifys={};
	}
	for(var i=0,k=param.nodeInfos.length;i<k;i++){
		var nodeId=param.nodeInfos[i].id;
		var nodeData=param.nodeInfos[i];
		for(nodeField in param.nodeInfos[i]){
			if(!lbpm.modifys[nodeId])	lbpm.modifys[nodeId]=new Object();
			if(nodeField=='orgattr'){
				lbpm.events.setOrgAttr(nodeData[nodeField],nodeId);
			}else{
				lbpm.modifys[nodeId][nodeField]=nodeData[nodeField];
				lbpm.nodes[nodeId][nodeField]=nodeData[nodeField];
			}
			//处理人和处理人姓名（人员特性的属性存储到节点定义流程人表中）
			if(nodeField=='handlerIds'){
				lbpm.events.setOrgAttr("handlerIds:handlerNames",nodeId);
			}
		}
	}
	lbpm.events.mainFrameSynch();	
};
//设置组织架构属性
lbpm.events.setOrgAttr=function(attr,nodeId){
	if(lbpm.modifys[nodeId]["orgAttributes"] && lbpm.modifys[nodeId]["orgAttributes"]!=""){
		if((lbpm.modifys[nodeId]["orgAttributes"]).indexOf(attr)==-1)
			lbpm.modifys[nodeId]["orgAttributes"]=lbpm.modifys[nodeId]["orgAttributes"]+";"+attr;
	}else{
		lbpm.modifys[nodeId]["orgAttributes"]=attr;
	}	
};
//修改流程图发布的事件
lbpm.events.modifyProcessListener=function (param){
	if(!param)	return;
	var processXMLObj=document.getElementsByName("sysWfBusinessForm.fdFlowContent")[0];
	processXMLObj.value=param.xml;
	lbpm.globals.parseXMLObj();
	lbpm.events.fireListener(lbpm.constant.EVENT_FILLLBPMOBJATTU,null);
	lbpm.modifys={};
	$("input[name='sysWfBusinessForm.fdIsModify']")[0].value="1";
	lbpm.events.mainFrameSynch();
};
//选择了人工分支的事件监听
lbpm.events.selectedManualListener=function (param){
	param = $(param);
	//所有被选中的起草人分支
	var nextNodeObj = lbpm.globals.getNextNodeObj(lbpm.nowNodeId);
	//如果选择的分支不是下一节点的直接返回
	if(param.attr('manualBranchNodeId')!=nextNodeObj.id) return;
	var startLines=lbpm.nodes[param.val()].startLines;
	var routeLine=new Array();
	for(var i=0,size=startLines.length;i<size;i++){
		if(startLines[i].startNode.id==param.attr('manualBranchNodeId')){
			routeLine[0]=startLines[i];
			break;
		}
	}
	if(routeLine.length==0) return;
	var html=lbpm.globals.getNextRouteInfo(routeLine);
	var operationsTDContent = $("#nextNodeTD")[0];
	if(operationsTDContent) operationsTDContent.innerHTML = html;
	var futureArr=$("input[value='"+param.val()+"'][key='futureNodeId']");
	if(futureArr.length>0) futureArr[0].click();
};
lbpm.events.addListener(lbpm.constant.EVENT_MODIFYNODEATTRIBUTE,lbpm.events.modifyNodeAttributeListener);
lbpm.events.addListener(lbpm.constant.EVENT_MODIFYPROCESS,lbpm.events.modifyProcessListener);
lbpm.events.addListener(lbpm.constant.EVENT_SELECTEDMANUAL,lbpm.events.selectedManualListener);
//更新即将流向那一行信息
lbpm.events.mainFrameSynch=function(param){
		var currentOperationType = lbpm.currentOperationType;
		//只有通过操作是才需要更新相应的域	
		if(lbpm.operations[currentOperationType].isPassType){
			var operatorInfo = lbpm.globals.analysisProcessorInfoToObject();
			var operationsTDContent = document.getElementById("operationsTDContent");
			var nextNodeTD = document.getElementById("nextNodeTD");
			var nodeObj = lbpm.globals.getNextNodeObj(lbpm.nowNodeId);
			var html = lbpm.globals.generateNextNodeInfo();
			if(operatorInfo != null){
				if (window.dojo) {
					var futureNodeValue = dojo.query("input[name='futureNodes']").val();
					var cb = function(widgets) {
						var widgets = dijit.registry.findWidgets(widgets[0].domNode);
						for (var i = 0; i < widgets.length; i ++) {
							if (futureNodeValue == widgets[i].value) {
								widgets[i].set('checked', true);
								break;
							}
						}
					};
					if(nextNodeTD != null){
						lbpm.globals.innerHTMLGenerateNextNodeInfo(html, nextNodeTD, cb);
					} else if(operationsTDContent != null){
						lbpm.globals.innerHTMLGenerateNextNodeInfo(html, operationsTDContent, cb);
					}
				} else {
					var futureNode=$("input[name='futureNode']:checked");
					var futureNodeValue=(futureNode.length>0?futureNode[0].value:"");
					if (nextNodeTD != null){
						nextNodeTD.innerHTML = html;
					} else if(operationsTDContent != null){
						operationsTDContent.innerHTML = html;
					}
					if (futureNodeValue!=""){
						futureNode=$("input[name='futureNode'][value='"+futureNodeValue+"']")
						if(futureNode.length>0){
							futureNode[0].click();
						}
					}
				}
			}
		}
};