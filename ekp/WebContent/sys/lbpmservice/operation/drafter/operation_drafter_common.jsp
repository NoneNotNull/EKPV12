<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
( function(operations) {
	operations['drafter_press'] = {
			click:commonDrafterOperationClick,
			check:OperationCheck,
			setOperationParam:setOperationParam
	};	
	operations['drafter_return'] = {
			click:commonDrafterOperationClick,
			check:OperationCheck,
			setOperationParam:setOperationParam
	};	
	operations['drafter_abandon'] = {
			click:commonDrafterOperationClick,
			check:OperationCheckForAbandon,
			setOperationParam:setOperationParam
	};	
	//起草人操作：催办、撤回、废弃
	function commonDrafterOperationClick(operationName){
	};

	//“驳回”操作的检查
	function OperationCheck(){	
		return true;
	};	
	//"驳回"操作的获取参数
	function setOperationParam(){

	};	
	function OperationCheckForAbandon(){
		return window.confirm('<bean:message bundle="sys-lbpmservice" key="lbpmNode.validate.abandon.confirm" />');
	}
})(lbpm.operations);