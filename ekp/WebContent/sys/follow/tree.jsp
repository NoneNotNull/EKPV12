<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.sys.follow" bundle="sys-follow"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	<kmss:authShow roles="SYSROLE_ADMIN">
	<%-- 订阅基础配置 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.sysFollowConfig" bundle="sys-follow" />",
		"<c:url value="/sys/follow/sys_follow_config/sysFollowConfig.do?method=edit" />"
	);
	</kmss:authShow>
	
	<%-- 个人订阅配置 
	n2 = n1.AppendURLChild(
		"<bean:message key="table.sysFollowPersonConfig" bundle="sys-follow" />",
		"<c:url value="/sys/follow/sys_follow_person_config/sysFollowPersonConfig.do?method=list" />"
	);--%>
	<%-- 所有订阅文档
	n2 = n1.AppendURLChild(
		"<bean:message key="sysFollow.allFollowDoc" bundle="sys-follow" />",
		"<c:url value="/sys/follow/sys_follow_doc/sysFollowDoc.do?method=list" />"
	);--%>
	<%-- 个人订阅文档关联表
	n2 = n1.AppendURLChild(
		"<bean:message key="sysFollow.myFollowDoc" bundle="sys-follow" />",
		"<c:url value="/sys/follow/sys_follow_person_doc_related/sysFollowPersonDocRelated.do?method=list" />"
	); --%>
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>