<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
	/*******************************************************************************
	 * 功能：处理人“驳回”操作的审批所用JSP，此JSP路径在处理人“驳回”操作扩展点定义的reviewJs参数匹配
	  使用：
	  作者：罗荣飞
	 创建时间：2012-06-06
	 ******************************************************************************/
	( function(operations) {
		operations['admin_changeCurHandler'] = {
			click: OperationClick,
			check: OperationCheck,
			setOperationParam:setOperationParam
		};

		//特权人操作：修改当前处理人
		function OperationClick(operationName){
			var param=lbpm.globals.getOperationParameterJson("curHandlers");
			var curHandlerHTML = [];
			for ( var i = 0; i < param.length; i++) {
				curHandlerHTML.push('<label><input type="checkbox" name="curHandlers" checked value="'
								+ param[i].value
								+ '" username="'+param[i].name+'"">'
								+ param[i].name + '</label>');
			}
			$("#operationsTDTitle").html('<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle.adminOperationTypeChgCurHandler" />');
			$("#operationsTDContent").html(curHandlerHTML.join(''));
			$("#operationsRow").show();
			
			var handlerIds = "";
			var handlerNames = "";
			var html = "<input type='hidden' name='repHandlerIds' alertText='' value='" + handlerIds + "'><input type='text' name='repHandlerNames' alertText='' readonly class='inputSgl' style='width:70%;' value='" + handlerNames + "'>";
			html += '<' + 'a href="javascript:void(0)"';
			html += ' onclick="Com_EventPreventDefault();Dialog_Address(true, \'repHandlerIds\',\'repHandlerNames\', \';\', ORG_TYPE_PERSON|ORG_TYPE_POST, null);"';
			html += '><bean:message key="dialog.selectOrg" />';
			html += '<a>';
			html += "&nbsp;<span class='txtstrong'>*</span>";
			$("#operationsTDTitle_Scope").html('<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle.adminOperationTypeRepCurHandler" />');
			$("#operationsTDContent_Scope").html(html);
			$("#operationsRow_Scope").show();
		};
		//操作提交前检查
		function OperationCheck(){
			var checkedArr=$("[name='curHandlers']:checked");
			if(checkedArr.length==0){
				alert('<bean:message bundle="sys-lbpmservice" key="lbpmNode.flowContent.admin_operation_type.chgcurhandle.mustSelectCurHandler" />');
				return false;
			}
			var currentHandler=$("[name='repHandlerIds']").val();
			if(currentHandler == '' || currentHandler == " "){
				alert('<bean:message bundle="sys-lbpmservice" key="lbpmNode.flowContent.admin_operation_type.chgcurhandle.mustChangeOperator" />');
				return false;
			}
			
			return true;
		};			
		//操作提交的参数
		function setOperationParam(){
			input = $("[name='repHandlerIds']")[0];
			lbpm.globals.setOperationParameterJson(input, "repHandlerIds", "param");	
			//要替换的当前人工作项ID
			var cancelHandlerIds=""
			var cancelHandlerNames=""
			
			$("[name='curHandlers']:checked").each(function(i){
				if(cancelHandlerIds==''){
					cancelHandlerIds=this.value;
					cancelHandlerNames=this.username;
				}	
				else{
					cancelHandlerIds+=";"+this.value;
					cancelHandlerNames+=";"+this.username;
				}	
			});	
			lbpm.globals.setOperationParameterJson(cancelHandlerIds, "taskIds", "param");
			lbpm.globals.setOperationParameterJson(cancelHandlerNames, "taskUserNames", "param");
		};	
	})(lbpm.operations);
