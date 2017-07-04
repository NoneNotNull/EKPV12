<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script language="JavaScript">
lbpm.globals.includeFile("lbpmservice/operation/operation_common_passtype.js");
/*******************************************************************************
 * 功能：处理人“签字”操作的审批所用JSP，此JSP路径在处理人“通过”操作扩展点定义的reviewJs参数匹配 使用： 作者：罗荣飞
 * 创建时间：2012-06-06
 ******************************************************************************/
( function(operations) {
	operations['handler_sign'] = {
			isPassType:true,
			click:OperationClick,
			check:OperationCheck,
			setOperationParam:setOperationParam
	};		

	// 处理人操作：签字
	function OperationClick(operationName) {
		var operationsRow = document.getElementById("operationsRow");
		var operationsTDTitle = document.getElementById("operationsTDTitle");
		var operationsTDContent = document
				.getElementById("operationsTDContent");
		operationsTDTitle.innerHTML = '<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle.handlerOperationTypepass" />';
		lbpm.globals.hiddenObject(operationsRow, false);
		var operatorInfo = lbpm.globals.analysisProcessorInfoToObject();
		if (operatorInfo != null) {
			var html = lbpm.globals.generateNextNodeInfo();
			operationsTDContent.innerHTML = html;
		}
	};
	//“通过”操作的检查
	function OperationCheck(){
		if(!lbpm.globals.validateMustSignYourSuggestion()) {
			return false;
		}
		return lbpm.globals.common_operationCheckForPassType();
	};	
	//设置"通过"操作的参数
	function setOperationParam()
	{

	};
})(lbpm.operations);

</script>
