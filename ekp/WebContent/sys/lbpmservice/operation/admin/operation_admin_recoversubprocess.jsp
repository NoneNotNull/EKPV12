<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
	Com_IncludeFile("dialog.js|doclist.js");
	lbpm.globals.includeFile("lbpmservice/operation/admin/operation_admin_recoversubprocess.js");
	/*******************************************************************************
	 * 功能：处理人“特权人回收子流程”操作的审批所用JSP，此JSP路径在处理人“驳回”操作扩展点定义的reviewJs参数匹配
	  使用：
	  作者：罗荣飞
	 创建时间：2012-06-06
	 ******************************************************************************/
	( function(operations) {
		operations['admin_recoverSubProcess'] = {
			click:OperationClick,
			check:OperationCheck,
			setOperationParam:setOperationParam
		};	

		//特权人操作：回收子流程
		function OperationClick(operationName){
			var operationsRow = document.getElementById("operationsRow");
			var operationsTDTitle = document.getElementById("operationsTDTitle");
			var operationsTDContent = document.getElementById("operationsTDContent");
			operationsTDTitle.innerHTML = '<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle.adminOperationTypeRecover" />';
			operationsTDContent.innerHTML = lbpm.globals.adminOperationTypeRecoverBuildHtml();
			lbpm.globals.hiddenObject(operationsRow, false);
		};
		//“回收子流程”操作的检查
		function OperationCheck(){
			var _recoverProcessIds = document.getElementById("workflowRecoverProcessIds");
			if(_recoverProcessIds && _recoverProcessIds.value) {
				return true;
			}
			alert('<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.adminrecover.alertText" />');
			return false;
		};	
		//"回收子流程"操作的获取参数
		function setOperationParam()
		{
			var _recoverProcessIds = document.getElementById("workflowRecoverProcessIds");
			lbpm.globals.setOperationParameterJson(_recoverProcessIds, "recoverProcessIds", "param");
		};	
})(lbpm.operations);
	