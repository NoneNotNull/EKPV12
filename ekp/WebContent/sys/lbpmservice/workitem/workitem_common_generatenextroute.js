//生成即将流向节点的HTML信息
lbpm.globals.generateNextNodeInfo=function(){
	//如果发现即将处理人在缓存中有时，直接获取缓存中的记录（不用重新计算）
	if(lbpm.nowProcessorInfoObj["lbpm_nextHandlerName"]!=null && lbpm.nowProcessorInfoObj["lbpm_nextHandlerNameId"]!=null  && lbpm.nowProcessorInfoObj["lbpm_nextNodeId"]!=null){
		var node = lbpm.nodes[lbpm.nowProcessorInfoObj["lbpm_nextNodeId"]];
		var nextShowHandlerName=lbpm.nowProcessorInfoObj["lbpm_nextHandlerName"];
		html = '<label id="nextNodeName"><b>' + node.id + "." + node.name + '</b></label>';
		html += '（<input type="hidden" id="handlerIds" name="handlerIds" value="' +lbpm.nowProcessorInfoObj["lbpm_nextHandlerNameId"]+ '">';
		html += '<input type="hidden" id="handlerNames" name="handlerNames" readonly class="inputSgl" onChange="lbpm.globals.setHandlerInfoes();" value="' + Com_HtmlEscape(nextShowHandlerName) + '">';
		html += '<label id="handlerShowNames" class=handlerNamesLabel nodeId="' + node.id + '">' + Com_HtmlEscape(nextShowHandlerName.replace(/;/g, '; ')) + '</label>';
		html += '）';
		return html;
	};
	//判断即将流向的处理人是否还是同一节点：
	var currentNodeObj = lbpm.nodes[lbpm.nowNodeId];
	/*
	 * currNodeNextHandlersId:当前节点处理人的下一处理人(串行)
	 * currNodeNextHandlersName:当前节点处理人的下一处理人名称(串行)
	 * toRefuseThisNodeId:驳回时如果选择重新回到本节点时，驳回时节点的的ID（如N1,N2）
	 * toRefuseThisHandlerIds:驳回时如果选择重新回到本节点时，驳回时未处理人的ID集
	 * toRefuseThisHandlerNames:驳回时如果选择重新回到本节点时，驳回时未处理人名称集
	 */
	var operatorInfo=lbpm.globals.getOperationParameterJson(
			"currNodeNextHandlersId"
			+":currNodeNextHandlersName"
			+":toRefuseThisNodeId"
			+":toRefuseThisHandlerIds"
			+":toRefuseThisHandlerNames"
			+":futureNodeId");
	
	var html = '';
	// 是则显示同一节点下一个处理人并不允许编辑。
	// 不是则显示下一个节点的所有处理人并根据权限显示是否编辑
	if(operatorInfo.currNodeNextHandlersId && currentNodeObj.processType == lbpm.constant.PROCESSTYPE_SERIAL){
		if (window.dojo) {
			html = '<div class="lbpmNextRouteInfoRow "><div id="nextNodeName">' + currentNodeObj.id + "." + currentNodeObj.name + '</div>';
			html += '<input type="hidden" id="handlerIds" name="handlerIds" value="' +operatorInfo.currNodeNextHandlersId+ '">';
			html += '<input type="hidden" id="handlerNames" name="handlerNames" readonly class="inputSgl" onChange="lbpm.globals.setHandlerInfoes();" value="' + Com_HtmlEscape(operatorInfo.currNodeNextHandlersName) + '">';
			html += '<div id="handlerShowNames" class=handlerNamesLabel nodeId="' + currentNodeObj.id + '">' + Com_HtmlEscape(operatorInfo.currNodeNextHandlersName.replace(/;/g, '; ')) + '</div></div>';
		} else {
			html = '<label id="nextNodeName"><b>' + currentNodeObj.id + "." + currentNodeObj.name + '</b></label>';
			html += '（<input type="hidden" id="handlerIds" name="handlerIds" value="' +operatorInfo.currNodeNextHandlersId+ '">';
			html += '<input type="hidden" id="handlerNames" name="handlerNames" readonly class="inputSgl" onChange="lbpm.globals.setHandlerInfoes();" value="' + Com_HtmlEscape(operatorInfo.currNodeNextHandlersName) + '">';
			html += '<label id="handlerShowNames" class=handlerNamesLabel nodeId="' + currentNodeObj.id + '">' + Com_HtmlEscape(operatorInfo.currNodeNextHandlersName.replace(/;/g, '; ')) + '</label>';
			html += '）';
		}
	}else if(operatorInfo.toRefuseThisNodeId){
		html=lbpm.globals.generateRefuseThisNodeIdInfo(
				operatorInfo.toRefuseThisNodeId,
				operatorInfo.toRefuseThisHandlerIds,
				operatorInfo.toRefuseThisHandlerNames,
				operatorInfo.currNodeNextHandlersId,
				operatorInfo.currNodeNextHandlersName);
	}else{
		var nextNodeObj = lbpm.globals.getNextNodeObj(lbpm.nowNodeId);
		var routeLines=lbpm.nodedescs[nextNodeObj.nodeDescType].getLines(lbpm.globals.getCurrentNodeObj(),nextNodeObj, true);
		html = lbpm.globals.getNextRouteInfo(routeLines);
	}
	return html; 
};

//点击通过时，当前节点如果是某个节点驳回过来的时，下个节点的即将流程向应该是那个驳回过来的节点
lbpm.globals.generateRefuseThisNodeIdInfo=function(
			toRefuseThisNodeId,
			toRefuseThisHandlerIds,
			toRefuseThisHandlerNames,
			nextShowHandlerId,
			nextShowHandlerName)
{
	var nodeObj = lbpm.globals.getNodeObj(toRefuseThisNodeId);
	var nextHandlerIds = toRefuseThisHandlerIds || "";
	var nextHandlerNames = toRefuseThisHandlerNames || "";
	if (nextHandlerIds) {
		// 审批路由类型为串行、串行时，返回驳回时第一个未处理人
		if(nodeObj.processType == lbpm.constant.PROCESSTYPE_SERIAL || nodeObj.processType == lbpm.constant.PROCESSTYPE_SINGLE) {
			nextHandlerIds = nextHandlerIds.split(";")[0];
			nextHandlerNames = nextHandlerNames.split(";")[0];
		}
	} else if(nextShowHandlerId != null){
		// 不可到达
		nodeObj = lbpm.globals.getCurrentNodeObj();
		nextHandlerIds = nextShowHandlerId;
		nextHandlerNames = nextShowHandlerName;
	}
	html = '<label id="nextNodeName"><b>' + nodeObj.id + "." + nodeObj.name + '</b></label>';
	html += '（<input type="hidden" id="handlerIds" name="handlerIds" value="' + nextHandlerIds + '">';
	html += '<input type="hidden" id="handlerNames" name="handlerNames" readonly class="inputSgl" onChange="lbpm.globals.setHandlerInfoes();" value="' + Com_HtmlEscape(nextHandlerNames) + '">';
	html += '<label id="handlerShowNames" nodeId="' + nodeObj.id + '">' + Com_HtmlEscape(nextHandlerNames.replace(/;/g, '; ')) + '</label>';
	html += '）';
	return html;
};
lbpm.globals.setFutureHandlerFormulaDialog=function(idField, nameField, modelName) {
	var action = function(rtv){lbpm.globals.afterChangeFurtureHandlerInfoes(rtv,lbpm.constant.ADDRESS_SELECT_FORMULA);};
	lbpm.globals.setHandlerFormulaDialog_(idField, nameField, modelName, action);
};
//显示或隐藏即将流向节点选项框
lbpm.globals.showFutureNodeSelectedLink=function(futureNodeObj) {
	var index = futureNodeObj.getAttribute("index");
	$("#operationsTDContent, #nextNodeTD").find('.divselect').each(function() {
		var self = $(this);
		if (self.attr("index") == index) {
			self.show();
		} else {
			self.hide();
		}
	});
	var futureNodeLinkObjs = futureNodeObj.parentNode.parentNode.getElementsByTagName("a");
	for(var i = 0; i < futureNodeLinkObjs.length; i++){
		var futureNodeLinkObj = futureNodeLinkObjs[i];
		if(futureNodeLinkObj.getAttribute("index") != null) {
			if(futureNodeLinkObj.getAttribute("index") == futureNodeObj.getAttribute("index")){
				futureNodeLinkObj.parentNode.style.display = '';
			} else {
				futureNodeLinkObj.parentNode.style.display = 'none';
			}
		}
	}
	lbpm.events.fireListener(lbpm.constant.EVENT_SELECTEDFUTURENODE,null);
};
lbpm.globals.innerHTMLGenerateNextNodeInfo = function(html, dom, cb) {
	if (!window.require) {
		dom.innerHTML = html;
		if (cb) {
			cb();
		}
		return;
	}
	require(['dojo/query', 'dojo/ready', 'dojo/_base/array'], function(query, ready, array) {
		ready(function() {
			lbpm.globals.destroyOperations();
			query(dom).html(html, {parseContent: true, onEnd: function() {
				this.inherited("onEnd", arguments);
				if (this.parseDeferred && cb) {
					this.parseDeferred.then(cb);
				}
			}});
		});
	});
};
//取得手工决策节点下的所有节点的信息(routeLines连接集合)
lbpm.globals.getNextRouteInfo=function(routeLines){
	if (window.dojo) {
		return '<div data-dojo-type="sys/lbpmservice/mobile/workitem/FutureNodes" class="lbpmNextRouteInfoRow" data-dojo-props="name:\'futureNodes\'"></div>';
	}
	var html = "";
	var onlyOneSelect=false;//只有一个选择框
	if(routeLines.length==1) onlyOneSelect=true;
	var futureNodeId = lbpm.globals.getOperationParameterJson("futureNodeId");
	$.each(routeLines, function(i, lineObj) {
		var nodeObj=lineObj.endNode;
		var lineName = lineObj.name == null?"":lineObj.name + " ";
		html += "<div class='lbpmNextRouteInfoRow'><label style='line-height:26px;' id='nextNodeName[" + i + "]'>";
		//如果连线的开始节点为人工分支类节点则显示单选框
		if(lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_MANUALBRANCH,lineObj.startNode)){
			html += "<input "+(onlyOneSelect==true?"style='display:none' checked=true ":(nodeObj.id == futureNodeId ? "checked=true " :""))+"type='radio' manualBranchNodeId='"+lineObj.startNode.id+"'name='futureNode' key='futureNodeId' index='" + i + "' value='" + nodeObj.id 
			+ "' onclick='lbpm.globals.showFutureNodeSelectedLink(this)'>" ;
		}
		html += "<b>" + lineName + nodeObj.id + "." + nodeObj.name + "</b></label>";
		if(!lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_END,nodeObj)){
			var handlerIds, handlerNames, isFormulaType = (nodeObj.handlerSelectType == lbpm.constant.ADDRESS_SELECT_FORMULA);
			handlerIds = nodeObj.handlerIds==null?"":nodeObj.handlerIds;
			handlerNames = nodeObj.handlerNames==null?"":
				(isFormulaType?lbpm.workitem.constant.COMMONHANDLERISFORMULA:nodeObj.handlerNames);
			var hiddenIdObj = "<input type='hidden' name='handlerIds[" + i + "]' value='" + handlerIds + "' isFormula='" + isFormulaType.toString() +"' />";
			html += hiddenIdObj; 
			var hiddenNameObj = "<input type='hidden' name='handlerNames[" + i + "]' value='" + Com_HtmlEscape(handlerNames) + "' />";
			
			//如果是处理人为公式计算则不显示原公式改为显示“公式计算” modify by limh 2010年11月29日
			var dataNextNodeHandler;
			var nextNodeHandlerNames4View="";
			if(nodeObj.handlerSelectType){
				if(nodeObj.handlerSelectType=="formula"){
					dataNextNodeHandler=lbpm.globals.formulaNextNodeHandler(handlerIds,true,lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SEND,nodeObj));
				}else{
					dataNextNodeHandler=lbpm.globals.parseNextNodeHandler(handlerIds,true,lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SEND,nodeObj));
				}
				for(var j=0;j<dataNextNodeHandler.length;j++){
					if(nextNodeHandlerNames4View==""){
						nextNodeHandlerNames4View=dataNextNodeHandler[j].name;
					}else{
						nextNodeHandlerNames4View+=";"+dataNextNodeHandler[j].name;
					}
				}
			}
			if(nextNodeHandlerNames4View!=""){
				html += "（";
			}
			html += hiddenNameObj;
			html += "<label id='handlerShowNames[" + i + "]' class='handlerNamesLabel'";
			html += " nodeId='" + nodeObj.id + "'>" + (nextNodeHandlerNames4View.replace(/;/g, '; ')) + "</label>";
			if(nextNodeHandlerNames4View!="")
				html += "）";
			if(lbpm.globals.checkModifyNextNodeAuthorization(nodeObj.id) && !lbpm.address.is_pda()){
				html += lbpm.globals.getModifyHandlerHTML(nodeObj,i,(onlyOneSelect==true?false:true),"lbpm.globals.afterChangeFurtureHandlerInfoes",null,null,"handlerIds["+i+"]","handlerNames["+i+"]");
			}
		}
		html += "</div>"; 
	});
//	if(html.lastIndexOf("<br>") == (html.length - 4)){
//		html = html.substring(0, html.length - 4);
//	};
	return html; 

};
//获取当前节点选择的人工决策节点（[{NodeName:N3, NextRoute:N4},{NodeName:N9, NextRoute:N11}]）
lbpm.globals.getSelectedFurtureNode=function(){
	var furtureNodeSelect = new Array();
	$("input[name='futureNode']:checked").each(function(index, input){
    	var json = {};
    	input = $(input);
		json.NodeName = input.attr('manualBranchNodeId');
		json.NextRoute = input.val();
		furtureNodeSelect.push(json);
    });
	return furtureNodeSelect;
};
//人工决策节点设置即将流向处理人
lbpm.globals.setFurtureHandlerInfoes=function(rtv,handlerSelectType){
	var isNull = (rtv == null);
	var handlerIdsObj;
	var handlerNamesObj;
	var handlerShowNames;
	var nextNodeId; 
	var futureNodeObj=$("input[name='futureNode']:checked");
	var futureIndex=null;
	if(futureNodeObj.length>0){
		nextNodeId = futureNodeObj[0].value;
		futureIndex=futureNodeObj[0].getAttribute("index");
	}else{	
		var currentNodeObj=lbpm.globals.getCurrentNodeObj();
		var nextNodeObj=lbpm.globals.getNextNodeObj(currentNodeObj.id);
		nextNodeId=nextNodeObj.id;
		futureIndex="0";
	}
	handlerIdsObj = document.getElementsByName("handlerIds[" + futureIndex + "]")[0];
	handlerNamesObj = document.getElementsByName("handlerNames[" + futureIndex + "]")[0];
	handlerShowNames = document.getElementById("handlerShowNames[" + futureIndex + "]");
	if (isNull) {
			handlerIdsObj.value = handlerIdsObj.getAttribute("defaultValue");
			handlerNamesObj.value = handlerNamesObj.getAttribute("defaultValue");
		return;
	}
	if(handlerSelectType==lbpm.constant.ADDRESS_SELECT_FORMULA){
		handlerIdsObj.setAttribute("isFormula", "true");
	}
	else{
		handlerIdsObj.setAttribute("isFormula", "false");
	}
	handlerIdsObj.setAttribute("defaultValue", handlerIdsObj.value);
	handlerNamesObj.setAttribute("defaultValue", handlerNamesObj.value);
	handlerShowNames.innerHTML = handlerNamesObj.value;
	var operatorInfo = lbpm.globals.analysisProcessorInfoToObject();
	if(operatorInfo == null){
		return;
	}	
	var currentNodeId = lbpm.nowNodeId; 
	//返回json对象
	var rtnNodesMapJSON= new Array();
	var nodeObj=new Object();
	nodeObj.id=nextNodeId;
	nodeObj.handlerIds=handlerIdsObj.value;
	nodeObj.handlerNames=handlerNamesObj.value;
	if(handlerSelectType!=null){
		nodeObj.handlerSelectType=handlerSelectType;
	}
	rtnNodesMapJSON.push(nodeObj);
	var param={};
	param.nodeInfos=rtnNodesMapJSON;
	lbpm.events.fireListener(lbpm.constant.EVENT_MODIFYNODEATTRIBUTE,param);
};

//人工选择节点修改处理人后设置即将流向处理人 limh 2011年3月30日
lbpm.globals.afterChangeFurtureHandlerInfoes=function(rtv,handlerSelectType){
	var handlerIdsObj ;
	var handlerNamesObj ;
	var handlerShowNames;
	if(rtv){
		var rtvArray = rtv.GetHashMapArray();
		if(rtvArray){
			var futureNodeObj=$("input[name='futureNode']:checked");
			var futureIndex=null;
			if(futureNodeObj.length>0){
				futureIndex=futureNodeObj[0].getAttribute("index");
			}else{
				futureIndex="0";
			}
			handlerIdsObj = document.getElementsByName("handlerIds[" + futureIndex + "]")[0];
			handlerNamesObj = document.getElementsByName("handlerNames[" + futureIndex + "]")[0];
			handlerShowNames = document.getElementById("handlerShowNames[" + futureIndex + "]");
			var idValue = "";
			var nameValue = "";
			for(var i=0;i<rtvArray.length;i++){
				idValue += ";"+rtvArray[i]["id"];
				nameValue += ";"+rtvArray[i]["name"];
			}
			handlerIdsObj.value = idValue.substring(1);
			handlerNamesObj.value =  nameValue.substring(1);
			lbpm.globals.setFurtureHandlerInfoes(rtv,handlerSelectType);
		}
	}
};

