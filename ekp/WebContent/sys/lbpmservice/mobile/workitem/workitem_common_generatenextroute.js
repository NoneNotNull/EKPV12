//取得手工决策节点下的所有节点的信息(routeLines连接集合)
lbpm.globals.getNextRouteInfo=function(routeLines){
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
	return html; 
};