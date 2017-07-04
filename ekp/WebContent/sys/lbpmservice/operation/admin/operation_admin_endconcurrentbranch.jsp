<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
	/*******************************************************************************
	 * 功能：特权人“结束并发分支”操作的审批所用JSP，此JSP路径在特权人“结束并发分支”操作扩展点定义的reviewJs参数匹配
	  使用：
	  作者：龚健
	 创建时间：2013-01-17
	 ******************************************************************************/
	(function(operations) {
		operations['admin_endconcurrentbranch'] = {
			click:OperationClick,
			check:OperationCheck,
			setOperationParam:setOperationParam
		};	
		//特权人操作：结束并发分支
		function OperationClick(operationName) {
		};
		//“结束并发分支”操作的检查
		function OperationCheck() {
			return true;
		};	
		//"结束并发分支"操作的获取参数
		function setOperationParam() {};
	})(lbpm.operations);