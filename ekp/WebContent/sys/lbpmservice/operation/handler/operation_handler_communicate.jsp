<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script language="JavaScript">
(function(){
	var path="lbpmservice/operation/handler/";
	lbpm.globals.includeFile(path+"operation_handler_communicate.js");
	if (window.require) {
		lbpm.globals.includeFile("lbpmservice/mobile/operation/handler/operation_handler_cancelcommunicate.js");
	} else {
		lbpm.globals.includeFile(path+"operation_handler_cancelcommunicate.js");
	}
	lbpm.globals.includeFile(path+"operation_handler_returncommunicate.js");
})();

//定义常量
(function(constant){
	constant.opt.CommunicatePeople='<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle.handlerOperationType.people" />'; //沟通人员;
	constant.opt.CommunicateIsNull='<bean:message bundle="sys-lbpmservice" key="lbpmNode.validate.toOtherHandlerIds.Communicate.isNull" />';
	constant.opt.CommunicateScopeAllowMuti='<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle_Scope.allow.muti" />';
	constant.opt.CommunicateScopeLimitSub='<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle_Scope.Limit.sub" />';
	constant.opt.CommunicateScopeLimitScope='<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle_Scope.Limit.scope" />';
	constant.opt.CommunicateScopeIsNullNoLimit='<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle_Scope.isNull.NoLimit" />';
	constant.opt.CommunicateCheckObj='<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle.check.communicate.obj" />';
	constant.opt.CommunicateNeedSelectCanceler='<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.communicate.NeedSelectCanceler" />';
	constant.opt.CommunicateMustSignYourSuggestion='<bean:message bundle="sys-lbpmservice" key="lbpmNode.mustSignYourSuggestion" />';
	constant.opt.CommunicateHiddenNote='<bean:message bundle="sys-lbpmservice-operation-communicate" key="lbpmOperations.communicate.hiddenNote" />';
})(lbpm.constant);

</script>

