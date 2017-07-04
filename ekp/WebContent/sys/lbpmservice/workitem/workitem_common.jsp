<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script language="JavaScript">
lbpm.globals.includeFile("lbpmservice/workitem/workitem_common_modifyflow.js");
lbpm.globals.includeFile("lbpmservice/workitem/workitem_common.js");
if (window.require) {
	lbpm.globals.includeFile("lbpmservice/mobile/workitem/workitem_common_load.js");
	lbpm.globals.includeFile("lbpmservice/mobile/workitem/workitem_common_usage.js");
} else {
	lbpm.globals.includeFile("lbpmservice/workitem/workitem_common_loadworkitemparam.js");
	lbpm.globals.includeFile("lbpmservice/workitem/workitem_common_usage.js");
}
lbpm.globals.includeFile("lbpmservice/workitem/workitem_common_generatenextroute.js");
//定义常量
(function(constant){
	constant.COMMONHANDLERISFORMULA='<bean:message bundle="sys-lbpmservice" key="lbpmSupport.HandlerIsFormula"/>';
	constant.COMMONSELECTADDRESS='<bean:message bundle="sys-lbpmservice" key="lbpmSupport.selectAddress"/>';
	constant.COMMONSELECTFORMLIST='<bean:message bundle="sys-lbpmservice" key="lbpmSupport.selectFormList"/>';
	constant.COMMONSELECTALTERNATIVE='<bean:message bundle="sys-lbpmservice" key="lbpmSupport.selectOptList"/>';
	constant.COMMONLABELFORMULASHOW='<bean:message bundle="sys-lbpmservice" key="label.formula.show"/>';
	constant.COMMONCHANGEPROCESSORSELECT='<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.changeProcessor.select"/>';
	constant.COMMONNODEHANDLERORGEMPTY='<kmss:message bundle="sys-lbpmservice" key="lbpmNode.nodeHandler.orgEmpty"/>';
	constant.COMMONPAGEFIRSTOPTION='<bean:message key="page.firstOption" />';
	constant.COMMONHANDLERUSAGECONTENTDEFAULT='<bean:message bundle="sys-lbpmservice" key="lbpmProcess.handler.usageContent.default" />';
	constant.COMMONUSAGECONTENTNOTNULL='<bean:message bundle="sys-lbpmservice" key="lbpmProcess.handler.usageContent.notNull" />';
	constant.COMMONUSAGES='<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.commonUsages" />';
})(lbpm.workitem.constant);
</script>