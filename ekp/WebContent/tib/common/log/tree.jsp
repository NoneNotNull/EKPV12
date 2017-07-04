<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.tib.common.log" bundle="tib-common-log"/>",
		document.getElementById("treeDiv")
	);
	var n1_log, n2_log, n3_log, n4, n5;
	n1_log = LKSTree.treeRoot;
	
	<%-- 日志配置tibCommonLogManage --%>
	n2_log = n1_log.AppendURLChild(
		"<bean:message key="table.tibCommonLogManage" bundle="tib-common-log" />",
		"<c:url value="/tib/common/log/tib_common_log_manage/tibCommonLogManage.do?method=edit" />"
	);
	<%-- 操作日志 --%>
	n2_log = n1_log.AppendURLChild(
		"<bean:message key="table.tibCommonLogOpt" bundle="tib-common-log" />",
		"<c:url value="/tib/common/log/tib_common_log_opt/tibCommonLogOpt.do?method=list" />"
	);
	<%-- 日志管理 --%>
	n2_log = n1_log.AppendURLChild(
		"<bean:message key="tib.common.log.manager" bundle="tib-common-log" />"
	);
	n2_log_type = n2_log.AppendBeanData("tibCommonLogTypeTreeService&id=!{value}");
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>