<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
/*******************************************************************************
 * 功能：已处理人“撤回”操作的审批所用JSP 创建时间：2014-05-12
 ******************************************************************************/
( function(operations) {
	operations['history_handler_back'] = {
		click : OperationClick,
		check : OperationCheck,
		setOperationParam : setOperationParam
	};
	// 处理人操作：通过
	function OperationClick(operationName) {
	}
	// “通过”操作的检查
	function OperationCheck(workitemObjArray) {
		return true;
	}
	// 设置"通过"操作的参数
	function setOperationParam() {
	}
})(lbpm.operations);
