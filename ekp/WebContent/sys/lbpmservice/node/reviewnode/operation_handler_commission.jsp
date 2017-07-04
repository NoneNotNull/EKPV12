<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script language="JavaScript">
//定义常量
(function(constant){
	constant.opt.CommissionPeople='<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle.handlerOperationType.people" />' //转办人员;
	constant.opt.CommissionIsNull="<bean:message bundle='sys-lbpmservice' key='lbpmNode.validate.toOtherHandlerIds.Commission.isNull' />";
})(lbpm.constant);
	/*******************************************************************************
	 * 功能：处理人“转办”操作的审批所用JSP，此JSP路径在处理人“驳回”操作扩展点定义的reviewJs参数匹配
	  使用：
	  作者：罗荣飞
	 创建时间：2012-06-06
	 ******************************************************************************/
	( function(operations) {
		operations['handler_commission'] = {
			click:OperationClick,
			check:OperationCheck,
			setOperationParam:setOperationParam
		};	

		//处理人操作：转办
		function OperationClick(operationName){
			var operationsRow = document.getElementById("operationsRow");
			var operationsTDTitle = document.getElementById("operationsTDTitle");
			var operationsTDContent = document.getElementById("operationsTDContent");
			operationsTDTitle.innerHTML = operationName + lbpm.constant.opt.CommissionPeople;
			var currentOrgIdsObj = document.getElementById("sysWfBusinessForm.fdHandlerRoleInfoIds");

			var options = {
					mulSelect : false,
					idField : 'toOtherHandlerIds',
					nameField : 'toOtherHandlerNames', 
					splitStr : ';',
					selectType : ORG_TYPE_PERSON|ORG_TYPE_POST,
					notNull : true,
					exceptValue : currentOrgIdsObj.value.split(';'),
					text : lbpm.constant.SELECTORG
			};
			var html = lbpm.address.html_build(options);
			if (window.dojo) {
				require(['dojo/query', 'dojo/NodeList-html'], function(query) {
					query('#operationsTDContent').html(html, {parseContent: true});
					lbpm.globals.hiddenObject(operationsRow, false);
				});
			} else {
				operationsTDContent.innerHTML = html;
				lbpm.globals.hiddenObject(operationsRow, false);
			}
		};
		//“转办”操作的检查
		function OperationCheck(){
			var input=$("#toOtherHandlerIds")[0];
			if(input && input.value == ""){
				alert(lbpm.constant.opt.CommissionIsNull);
				return false;
			}
			//sysWfBusinessForm.fdHandlerRoleInfoIds不能选自己或者自己的岗位
			return true;			
		};	
		//设置"转办"操作的参数
		function setOperationParam()
		{
			//转办人员
			var input=$("#toOtherHandlerIds")[0];
			lbpm.globals.setOperationParameterJson(input,null,"param");
			//alert(document.getElementById("sysWfBusinessForm.fdParameterJson").value);
		};
	})(lbpm.operations);
</script>
