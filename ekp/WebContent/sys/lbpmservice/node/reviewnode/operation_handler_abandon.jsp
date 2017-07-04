<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script language="JavaScript">
	/*******************************************************************************
	 * 功能：处理人“废弃”操作的审批所用JSP，此JSP路径在处理人“驳回”操作扩展点定义的reviewJs参数匹配
	  使用：
	  作者：罗荣飞
	 创建时间：2012-06-06
	 ******************************************************************************/
	( function(operations) {
		operations['handler_abandon'] = {
			click:OperationClick,
			check:OperationCheck,
			setOperationParam:setOperationParam
		};	

		//处理人操作：废弃
		function OperationClick(operationName){
		};

		//“通过”操作的检查
		function OperationCheck(){
			return lbpm.globals.validateMustSignYourSuggestion();
		}
			
		//设置"通过"操作的参数
		function setOperationParam()
		{

		}
	})(lbpm.operations);
</script>
