<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	/*******************************************************************************
	 * 功能：处理人“驳回”操作的审批所用JSP，此JSP路径在处理人“驳回”操作扩展点定义的reviewJs参数匹配
	  使用：
	  作者：罗荣飞
	 创建时间：2012-06-06
	 ******************************************************************************/
	( function(operations) {
		operations['admin_abandon'] = {
			click:OperationClick,
			check:OperationCheck,
			setOperationParam:setOperationParam
		};	


		//特权人操作：直接废弃
		function OperationClick(operationName){
			$("#rerunIfErrorRow").show();
		};
		//“驳回”操作的检查
		function OperationCheck(){
			return true;
		};	
		//"驳回"操作的获取参数
		function setOperationParam(){
			if ($('#rerunIfError').length > 0) {
				lbpm.globals.setOperationParameterJson($("#rerunIfError").attr("checked"), "rerunIfError", "param");
			}
		};	

	})(lbpm.operations);