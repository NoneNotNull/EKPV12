<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message bundle="sys-lbpmservice-support" key="module.sys.lbpmservice.support"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4;
	n2 = LKSTree.treeRoot;
<kmss:auth requestURL="/sys/lbpmservice/support/lbpm_oper_main/lbpmOperMain.do?method=list" requestMethod="GET">
	//========== 流程引擎 ==========
	n3 = n2.AppendURLChild(
		"<bean:message key="module.name.workflow" bundle="sys-lbpmservice" />"
	);
	n4 = n3.AppendURLChild(
		"<bean:message key="module.node.paramsSetup.base" bundle="sys-lbpmservice"/>",
		"<c:url value="/sys/appconfig/sys_appconfig/sysAppConfig.do?method=edit&modelName=com.landray.kmss.sys.lbpm.engine.persistence.model.LbpmBaseInfo"/>"
	);
	n4 = n3.AppendURLChild(
		"<bean:message key="module.node.paramsSetup.operations" bundle="sys-lbpmservice"/>",
		"<c:url value="/sys/lbpmservice/support/lbpm_oper_main/lbpmOperMain.do?method=list" />"
	);
	n4 = n3.AppendURLChild(
		"<bean:message key="module.node.paramsSetup.defaultUsage" bundle="sys-lbpmservice"/>",
		"<c:url value="/sys/lbpmservice/support/lbpm_usage/lbpmUsage.do?method=edit&sys=true" />"
	);
</kmss:auth>
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>