<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
	/*******************************************************************************
	 * 功能：处理人“修改流程”操作的审批所用JSP，此JSP路径在处理人“驳回”操作扩展点定义的reviewJs参数匹配
	  使用：
	  作者：罗荣飞
	 创建时间：2012-06-06
	 ******************************************************************************/
	( function(operations) {
		operations['admin_modifyProcess'] = {
			click:OperationClick,
			check:OperationCheck,
			setOperationParam:setOperationParam
		};	

		//特权人操作：修改流程
		function OperationClick(operationName){
			var modifyFlowDIV = document.getElementById("modifyFlowDIV");
			if(modifyFlowDIV){
				lbpm.globals.hiddenObject(modifyFlowDIV, false);
			}
			var checkChangeFlowTR = document.getElementById("checkChangeFlowTR");
			if(checkChangeFlowTR){
				lbpm.globals.hiddenObject(checkChangeFlowTR, false);
			}
		};
		//“修改流程”操作的检查
		function OperationCheck(){
			var fdIsModify=$("input[name='sysWfBusinessForm.fdIsModify']")[0];
			if(fdIsModify==null || fdIsModify.value!="1"){
				alert('<bean:message key="lbpmProcess.privileger.modify.process.error" bundle="sys-lbpmservice-operation-admin"/>');
				return false;
			}
			//lbpm.globals.handlerOperationClearOperationsRow();
			return true;
		};	
		//"修改流程"操作的获取参数
		function setOperationParam()
		{
			//清空附加操作参数(由于修改了流程图syslbpmprocess_submit.js中会组装附加操作，但特权人修改流程图放主操作中执行，所以要清空)
			var additionParamObj=$("input[name='sysWfBusinessForm.fdAdditionsParameterJson']")[0];
			additionParamObj.value="";
			var fdFlowContent=$("[name='sysWfBusinessForm.fdFlowContent']")[0];
			lbpm.globals.setOperationParameterJson(fdFlowContent, "xml", "param");
			fdFlowContent.value="";
		};	

	})(lbpm.operations);
