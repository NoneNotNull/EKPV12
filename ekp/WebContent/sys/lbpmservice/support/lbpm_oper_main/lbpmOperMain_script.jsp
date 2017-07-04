<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
var drafterOpers=[];
var handlerOpers=[];
var historyhandlerOpers=[];

// 根据节点类型返回操作集合
function getOperationsByNode(nodeType) {
	var data = new KMSSData();
	data.AddBeanData('getOperationsByNodeService&nodeType='+nodeType);
	var operation = eval("("+data.GetHashMapArray()[0]['operation']+")");
	drafterOpers = operation.drafter;
	handlerOpers = operation.handler;
	historyhandlerOpers = operation.historyhandler;
}

// 设置操作组
function selectOperationsGroup(nodeType){
	getOperationsByNode(nodeType);
	deleteRows("TABLE_DocList_Draft");
	deleteRows("TABLE_DocList_Processor");
	deleteRows("TABLE_DocList_Historyhandler");
	if (drafterOpers.length > 0) {
		document.getElementById("drafterGroup").style.display = "";
	} else {
		document.getElementById("drafterGroup").style.display = "none";
	}
	if (handlerOpers.length > 0) {
		document.getElementById("processorGroup").style.display = "";
	} else {
		document.getElementById("processorGroup").style.display = "none";
	}
	if (historyhandlerOpers.length > 0) {
		document.getElementById("historyhandlerGroup").style.display = "";
	} else {
		document.getElementById("historyhandlerGroup").style.display = "none";
	}
}

// 删除动态表格内容行
function deleteRows(tableId){
    var optTB = document.getElementById(tableId);
    var rowLen = optTB.rows.length;
    for(var i = rowLen; i > 1; i--){
	    DocList_DeleteRow(optTB.rows[i-1]);
    }
}

// 添加起草人动态行时初始化操作下拉框
function AddRow_InitDrafterSelect() {
	DocList_AddRow();
	var tb = document.getElementById("TABLE_DocList_Draft");
	var index = tb.rows.length-2;
	var fdOperType = "drafterOperations["+index+"].fdOperType";
	var selectObj = document.getElementsByName(fdOperType)[0];
	for (var i = 0; i < drafterOpers.length; i++) {
		selectObj.options.add(new Option(drafterOpers[i].name, drafterOpers[i].type));
	}
}

// 添加处理人动态行时初始化操作下拉框
function AddRow_InitHandlerSelect() {
	DocList_AddRow();
	var tb = document.getElementById("TABLE_DocList_Processor");
	var index = tb.rows.length-2;
	var fdOperType = "handlerOperations["+index+"].fdOperType";
	var selectObj = document.getElementsByName(fdOperType)[0];
	for (var i = 0; i < handlerOpers.length; i++) {
		selectObj.options.add(new Option(handlerOpers[i].name, handlerOpers[i].type));
	}
}

//添加已处理人动态行时初始化操作下拉框
function AddRow_InitHistoryhandlerSelect() {
	DocList_AddRow();
	var tb = document.getElementById("TABLE_DocList_Historyhandler");
	var index = tb.rows.length-2;
	var fdOperType = "historyhandlerOperations["+index+"].fdOperType";
	var selectObj = document.getElementsByName(fdOperType)[0];
	for (var i = 0; i < historyhandlerOpers.length; i++) {
		selectObj.options.add(new Option(historyhandlerOpers[i].name, historyhandlerOpers[i].type));
	}
}

// 设置同一行操作名称
function selectOperType(operType, selectObj){
	var selectText = selectObj.options[selectObj.selectedIndex].innerText||selectObj.options[selectObj.selectedIndex].textContent;
	var operNameObj = selectObj.parentNode.parentNode.childNodes[1].getElementsByTagName("input")[0];
	operNameObj.value = selectText;
}

// 校验是否至少选择了一个通过操作
function validateForm() {
	var tb = document.getElementById("TABLE_DocList_Processor");
	var index = tb.rows.length-1;
	for (var i = 0; i < index; i++) {
		var fdOperType = "handlerOperations["+i+"].fdOperType";
		var selectObj = document.getElementsByName(fdOperType)[0];
		for (var j = 0, size = handlerOpers.length; j < size; j++) {
			if (handlerOpers[j].isPass && handlerOpers[j].type == selectObj.value) {
				return true;
			}
		}
	}
	var message = null;
	var message1 = '<bean:message key="lbpmOperations.processor.fdOperType.mustSelect.1" bundle="sys-lbpmservice-support" />';
	var message2 = '<bean:message key="lbpmOperations.processor.fdOperType.mustSelect.2" bundle="sys-lbpmservice-support" />';
	for (var i = 0, size = handlerOpers.length; i < size; i++) {
		if (handlerOpers[i].isPass) {
			message = message1 + handlerOpers[i].name + message2;
		}
	}
	if(message) {
		alert(message);
		return false;
	}
	return true;
}

// 页面加载时判断起草人、处理人操作是否显示, 编辑页面时获取节点操作
function initialContext(){
	<c:if test="${lbpmOperMainForm.method_GET=='edit'}">
	    getOperationsByNode("${lbpmOperMainForm.fdNodeType}");
	</c:if>
	if (drafterOpers.length > 0) {
	    document.getElementById("drafterGroup").style.display = "";
	}
	if (handlerOpers.length > 0) {
	    document.getElementById("processorGroup").style.display = "";
	}
	if (historyhandlerOpers.length > 0) {
	    document.getElementById("historyhandlerGroup").style.display = "";
	}
}
Com_AddEventListener(window, "load", initialContext);

</script>
