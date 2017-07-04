<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/resource/jsp/jsperror.jsp"%>
<%@ page import="com.landray.kmss.sys.lbpm.engine.manager.operation.OperationType,
	com.landray.kmss.sys.lbpm.engine.manager.operation.OperationTypeManager,
	com.landray.kmss.util.ResourceUtil,
	java.util.*" %>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("jquery.js|docutil.js|doclist.js|dialog.js");
</script>

<script>
DocList_Info.push("drafterOptList", "handlerOptList", "historyhandlerOptList");

function operationDataCheck(data) {
	data.operations = new Array();
	var optTypeField = document.getElementsByName("operationType")[0];
	if(optTypeField.selectedIndex==-1 || optTypeField.options[optTypeField.selectedIndex].value==""){
		switch(nodeDataCheckOperation(data, "drafter")){
			case 1:
				alert('<kmss:message key="FlowChartObject.Lang.Operation.checkCreatorOptNameEmpty" bundle="sys-lbpmservice" />');
				return false;
			case 2:
				alert('<kmss:message key="FlowChartObject.Lang.Operation.checkCreatorOptTypeEmpty" bundle="sys-lbpmservice" />');
				return false;
		}
		switch(nodeDataCheckOperation(data, "handler", true)){
			case 1:
				alert('<kmss:message key="FlowChartObject.Lang.Operation.checkHandlerOptNameEmpty" bundle="sys-lbpmservice" />');
				return false;
			case 2:
				alert('<kmss:message key="FlowChartObject.Lang.Operation.checkHandlerOptTypeEmpty" bundle="sys-lbpmservice" />');
				return false;
			case 3:
				alert('<kmss:message key="FlowChartObject.Lang.Operation.checkHandlerOptTypePass" bundle="sys-lbpmservice" arg0="${param.passOperationType}" />');
				return false;
		}
		switch(nodeDataCheckOperation(data, "historyhandler")){
			case 1:
				alert('<kmss:message key="FlowChartObject.Lang.Operation.checkHistoryhandlerOptNameEmpty" bundle="sys-lbpmservice" />');
				return false;
			case 2:
				alert('<kmss:message key="FlowChartObject.Lang.Operation.checkHistoryhandlerOptTypeEmpty" bundle="sys-lbpmservice" />');
				return false;
		}
	}else{		
		data.operations.refId =  optTypeField.options[optTypeField.selectedIndex].value;
	}
	return true;
}
AttributeObject.CheckDataFuns.push(operationDataCheck);

function initOperationData(data) {
	var NodeData = data || AttributeObject.NodeData;
	// 1 ajax填充选择项 2 JSP加载可选择操作 3 ajax加载选中的数据、显示操作编辑列表
	var data = new KMSSData(), i, selectedIndex;
	data.AddBeanData("getOperTypesByNodeService&nodeType=${param.nodeType}");
	data = data.GetHashMapArray();
	var field = document.getElementsByName("operationType")[0];
	field.options.length = 0;
	field.options[field.options.length] = new Option('<kmss:message key="FlowChartObject.Lang.Operation.operationCustom" bundle="sys-lbpmservice" />', "");
	for(i=0; i<data.length; i++){
		field.options[field.options.length] = new Option(data[i].label, data[i].value);
		if(NodeData.operations && data[i].value == NodeData.operations.refId){
			selectedIndex = field.options.length - 1;
		}
		else if(data[i].isDefault=="true"){
			selectedIndex = field.options.length - 1;
		}
	}
	if(NodeData.operations && NodeData.operations.refId==null){
		selectedIndex = 0;
	}
	if(selectedIndex > -1){
		field.selectedIndex = selectedIndex;
	}
	refreshOperationList(NodeData, true);
}
AttributeObject.Init.AllModeFuns.push(initOperationData);


//修改操作方式后，刷新界面显示
function refreshOperationList(data, isInit){
	var NodeData = data || AttributeObject.NodeData;
	var drafterOptList = document.getElementById("drafterOptList"),
		handlerOptList = document.getElementById("handlerOptList"),
		historyhandlerOptList = document.getElementById("historyhandlerOptList");
	var field = document.getElementsByName("operationType")[0];
	if(field.options[field.selectedIndex].value==""){
		if(isInit && NodeData.operations!=null){
			for(var i=0; i<NodeData.operations.length; i++)
				addOperationRow(NodeData.operations[i], NodeData.operations[i].XMLNODENAME);
		}
		refreshOperationDisabled(drafterOptList, !AttributeObject.isNodeCanBeEdit);
		refreshOperationDisabled(handlerOptList, !AttributeObject.isNodeCanBeEdit);
		refreshOperationDisabled(historyhandlerOptList, !AttributeObject.isNodeCanBeEdit);
	}else{
		deleteAllOperationRow(drafterOptList);
		deleteAllOperationRow(handlerOptList);
		deleteAllOperationRow(historyhandlerOptList);
		var data = new KMSSData();
		data.AddBeanData("getOperationsByDefinitionService&fdId="+field.options[field.selectedIndex].value);
		data = data.GetHashMapArray();
		if (data.length > 0) {
			var operations = data[0].operation;
			operations = (new Function("return ("+operations+");"))();
			for(var i=0; i<operations.length; i++)
				addOperationRow({name:operations[i].name, type:operations[i].type}, operations[i].handlerType);
		}
		refreshOperationDisabled(drafterOptList, true);
		refreshOperationDisabled(handlerOptList, true);
		refreshOperationDisabled(historyhandlerOptList, true);
	}
}

//设置操作的disabled属性
function refreshOperationDisabled(obj, disabled){
	var i, fields;
	for(i=0; i<obj.rows.length; i++)
		obj.rows[i].cells[2].style.display = disabled?"none":"";
	fields = obj.getElementsByTagName("INPUT");
	for(i=0; i<fields.length; i++)
		fields[i].disabled = disabled;
	fields = obj.getElementsByTagName("SELECT");
	for(i=0; i<fields.length; i++)
		fields[i].disabled = disabled;
}

//添加操作行
function addOperationRow(obj, person){
	var index = person.indexOf("Operation");
	if (index > 0) {
		person = person.substring(0, index);
	}
	if (person == 'creator') {
		person = 'drafter';
	}
	var fieldValues = new Object();
	fieldValues[person+"Operation_name"] = obj.name;
	fieldValues[person+"Operation_type"] = obj.type;
	DocList_AddRow(person+"OptList", null, fieldValues);
}
//删除操作行
function deleteAllOperationRow(handlerOptList){
	for(var i=handlerOptList.rows.length-1; i>0; i--)
		DocList_DeleteRow(handlerOptList.rows[i]);
}

//选择操作的时候更新操作名
function changeOperationType(obj){
	var fieldName = obj.name;
	fieldName = fieldName.substring(0, fieldName.length-4)+"name";
	var fields = document.getElementsByName(fieldName);
	var index = Com_ArrayGetIndex(document.getElementsByName(obj.name), obj);
	if(obj.selectedIndex>0)
		fields[index].value = obj.options[obj.selectedIndex].text;
}

//操作数据校验
function nodeDataCheckOperation(data, person, required){
	var nameFields = document.getElementsByName(person+"Operation_name");
	var typeFields = document.getElementsByName(person+"Operation_type");
	var typeFound = false;
	if(required && nameFields.length == 0){
		data.operations.length = 0;
		return 3;
	}
	for(var i=0; i<nameFields.length; i++){
		if(nameFields[i].value == "")
			return 1;
		var selectedOpt = typeFields[i].options[typeFields[i].selectedIndex];
		var optType = selectedOpt.value;
		if(optType=="")
			return 2;
		if(selectedOpt.getAttribute('isPass') == 'true')
			typeFound = true;
		data.operations[data.operations.length] = {
				XMLNODENAME:person+"Operation",
				name:nameFields[i].value,
				type:optType};
	}
	return typeFound?0:3;
}


</script>

<table class="tb_normal" width="100%" id="TB_Operation">
	<tr>
		<td width="100px"><kmss:message key="FlowChartObject.Lang.Operation.operationRefer" bundle="sys-lbpmservice" /></td>
		<td>
			<select name="operationType" onChange="refreshOperationList();">
				<option value=""><kmss:message key="FlowChartObject.Lang.Operation.operationCustom" bundle="sys-lbpmservice" /></option>
			</select>
		</td>
	</tr>
	<tr>
		<td width="100px">
			<kmss:message key="FlowChartObject.Lang.Node.creator" bundle="sys-lbpm-engine" /><br>
			<kmss:message key="FlowChartObject.Lang.Operation.creatorOperationHelp" bundle="sys-lbpmservice" />
		</td>
		<td style="vertical-align:top">
			<table id="drafterOptList" class="tb_normal" width="100%">
				<tr>
					<td width="120px"><kmss:message key="FlowChartObject.Lang.Operation.operationType" bundle="sys-lbpmservice" /></td>
					<td width="228px"><kmss:message key="FlowChartObject.Lang.Operation.operationName" bundle="sys-lbpmservice" /></td>
					<td width="100px">
						<a href="#" onclick="DocList_AddRow();"><kmss:message key="FlowChartObject.Lang.Operation.operationAdd" bundle="sys-lbpmservice" /></a>
					</td>
				</tr>
				<tr KMSS_IsReferRow="1" style="display:none">
					<td>
 						<select name="drafterOperation_type" onchange="changeOperationType(this);">
 							<option value=""><kmss:message key="FlowChartObject.Lang.pleaseSelect" bundle="sys-lbpm-engine" /></option>
 						<%
 						List operList = OperationTypeManager.getInstance().getOperationsByNode(
 					    	request.getParameter("nodeType"), request.getParameter("modelName"), OperationType.HANDLERTYPE_DRAFTER);
 						for (int i = 0; i < operList.size(); i ++) {
 							OperationType operType = (OperationType) operList.get(i);
 						%>
							<option value="<%=operType.getType() %>">
							<c:out value="<%=ResourceUtil.getString(operType.getMessageKey()) %>" />
							</option>
						<%} %>
						</select>
					</td>
					<td><input name="drafterOperation_name" class="inputsgl" style="width:100%"></td>
					<td>
						<a href="#" onclick="DocList_DeleteRow();"><kmss:message key="FlowChartObject.Lang.Operation.operationDelete" bundle="sys-lbpmservice" /></a>
						<a href="#" onclick="DocList_MoveRow(-1);"><kmss:message key="FlowChartObject.Lang.Operation.operationMoveUp" bundle="sys-lbpmservice" /></a>
						<a href="#" onclick="DocList_MoveRow(1);"><kmss:message key="FlowChartObject.Lang.Operation.operationMoveDown" bundle="sys-lbpmservice" /></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td width="100px">
			<kmss:message key="FlowChartObject.Lang.Node.handler" bundle="sys-lbpm-engine" /><br>
			<kmss:message key="FlowChartObject.Lang.Operation.handlerOperationHelp" bundle="sys-lbpmservice" />
		</td>
		<td style="vertical-align:top">
			<table id="handlerOptList" class="tb_normal" width="100%">
				<tr>
					<td width="120px"><kmss:message key="FlowChartObject.Lang.Operation.operationType" bundle="sys-lbpmservice" /></td>
					<td width="228px"><kmss:message key="FlowChartObject.Lang.Operation.operationName" bundle="sys-lbpmservice" /></td>
					<td width="100px">
						<a href="#" onclick="DocList_AddRow();"><kmss:message key="FlowChartObject.Lang.Operation.operationAdd" bundle="sys-lbpmservice" /></a>
					</td>
				</tr>
				<tr KMSS_IsReferRow="1" style="display:none">
					<td>
						<select name="handlerOperation_type" onchange="changeOperationType(this);">
							<option value=""><kmss:message key="FlowChartObject.Lang.pleaseSelect" bundle="sys-lbpm-engine" /></option>
							<%
 							operList = OperationTypeManager.getInstance().getOperationsByNode(
 					                request.getParameter("nodeType"), request.getParameter("modelName"), OperationType.HANDLERTYPE_HANDLER);
 							for (int i = 0; i < operList.size(); i ++) {
 								OperationType operType = (OperationType) operList.get(i);
 							%>
								<option value="<%=operType.getType() %>" isPass="<%=operType.isPassType() %>">
								<c:out value="<%=ResourceUtil.getString(operType.getMessageKey()) %>" />
								</option>
							<%} %>
						</select>
					</td>
					<td><input name="handlerOperation_name" class="inputsgl" style="width:100%"></td>
					<td>
						<a href="#" onclick="DocList_DeleteRow();"><kmss:message key="FlowChartObject.Lang.Operation.operationDelete" bundle="sys-lbpmservice" /></a>
						<a href="#" onclick="DocList_MoveRow(-1);"><kmss:message key="FlowChartObject.Lang.Operation.operationMoveUp" bundle="sys-lbpmservice" /></a>
						<a href="#" onclick="DocList_MoveRow(1);"><kmss:message key="FlowChartObject.Lang.Operation.operationMoveDown" bundle="sys-lbpmservice" /></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td width="100px">
			<kmss:message key="FlowChartObject.Lang.Node.historyhandler" bundle="sys-lbpm-engine" /><br>
			<kmss:message key="FlowChartObject.Lang.Operation.historyhandlerOperationHelp" bundle="sys-lbpmservice" />
		</td>
		<td style="vertical-align:top">
			<table id="historyhandlerOptList" class="tb_normal" width="100%">
				<tr>
					<td width="120px"><kmss:message key="FlowChartObject.Lang.Operation.operationType" bundle="sys-lbpmservice" /></td>
					<td width="228px"><kmss:message key="FlowChartObject.Lang.Operation.operationName" bundle="sys-lbpmservice" /></td>
					<td width="100px">
						<a href="#" onclick="DocList_AddRow();"><kmss:message key="FlowChartObject.Lang.Operation.operationAdd" bundle="sys-lbpmservice" /></a>
					</td>
				</tr>
				<tr KMSS_IsReferRow="1" style="display:none">
					<td>
 						<select name="historyhandlerOperation_type" onchange="changeOperationType(this);">
 							<option value=""><kmss:message key="FlowChartObject.Lang.pleaseSelect" bundle="sys-lbpm-engine" /></option>
 						<%
 						operList = OperationTypeManager.getInstance().getOperationsByNode(
 					    	request.getParameter("nodeType"), request.getParameter("modelName"), OperationType.HANDLERTYPE_HISTORY_HANDLER);
 						for (int i = 0; i < operList.size(); i ++) {
 							OperationType operType = (OperationType) operList.get(i);
 						%>
							<option value="<%=operType.getType() %>">
							<c:out value="<%=ResourceUtil.getString(operType.getMessageKey()) %>" />
							</option>
						<%} %>
						</select>
					</td>
					<td><input name="historyhandlerOperation_name" class="inputsgl" style="width:100%"></td>
					<td>
						<a href="#" onclick="DocList_DeleteRow();"><kmss:message key="FlowChartObject.Lang.Operation.operationDelete" bundle="sys-lbpmservice" /></a>
						<a href="#" onclick="DocList_MoveRow(-1);"><kmss:message key="FlowChartObject.Lang.Operation.operationMoveUp" bundle="sys-lbpmservice" /></a>
						<a href="#" onclick="DocList_MoveRow(1);"><kmss:message key="FlowChartObject.Lang.Operation.operationMoveDown" bundle="sys-lbpmservice" /></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>