<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script language="JavaScript">
lbpm.globals.includeFile("lbpmservice/operation/operation_common_passtype.js");
/*******************************************************************************
 * 功能：处理人“通过”操作的审批所用JSP，此JSP路径在处理人“通过”操作扩展点定义的reviewJs参数匹配 使用： 作者：罗荣飞
 * 创建时间：2012-06-06
 ******************************************************************************/
( function(operations) {
	operations['handler_pass'] = {
			isPassType:true,
			click:OperationClick,
			check:OperationCheck,
			blur:OperationBlur,
			setOperationParam:setOperationParam
	};		
	
	function OperationBlur() {
		lbpm.globals.clearDefaultUsageContent();
	}

	// 处理人操作：通过
	function OperationClick(operationName) {
		//点击通过操作时用户没有 输入审批内容时设置默认审批内容 @作者：曹映辉 @日期：2011年12月15日
		if (window.dojo) {
			require(["dojo/ready"], function(ready) {
				ready(function() {lbpm.globals.setDefaultUsageContent();});
			});
		} else
			lbpm.globals.setDefaultUsageContent();

		var operationsRow = document.getElementById("operationsRow");
		var operationsTDTitle = document.getElementById("operationsTDTitle");
		var operationsTDContent = document
				.getElementById("operationsTDContent");
		if(operationsTDContent){		
			operationsTDTitle.innerHTML = '<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle.handlerOperationTypepass" />';
			lbpm.globals.hiddenObject(operationsRow, false);
			var operatorInfo = lbpm.globals.analysisProcessorInfoToObject();
			if (operatorInfo != null) {
				var html = lbpm.globals.generateNextNodeInfo();
				if (window.dojo) {
					lbpm.globals.innerHTMLGenerateNextNodeInfo(html, operationsTDContent);
				} else {
					operationsTDContent.innerHTML = html;
				}
			}
		}	
	};
	//“通过”操作的检查
	function OperationCheck(workitemObjArray){
		return lbpm.globals.common_operationCheckForPassType(workitemObjArray);
	};	
	//设置"通过"操作的参数
	function setOperationParam()
	{

	};
})(lbpm.operations);

</script>
