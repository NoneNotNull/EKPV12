<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		'<bean:message bundle="sys-relation" key="title.sysRelationMain.manager"/>',
		document.getElementById("treeDiv")
	);
	var n1 = LKSTree.treeRoot;
	n1.AppendURLChild(
		'<bean:message bundle="sys-relation" key="title.sysRelationMain.Template.Setting"/>',
		'<c:url value="/sys/relation/sys_relation_main/sysRelationMain.do?method=add"/>');
	n1.AppendURLChild(
		'<bean:message bundle="sys-relation" key="title.sysRelationForeignModule.Setting"/>',
		'<c:url value="/sys/relation/sys_relation_foreign_module/sysRelationForeignModule.do?method=list"/>');
	<kmss:authShow roles="ROLE_SYSRELATION_MANAGER">
	n1.AppendURLChild(
		'<bean:message bundle="sys-relation" key="title.sysRelationMain.overView"/>',
		'<c:url value="/sys/relation/import/sysRelationMain_over_view.jsp"/>');
	</kmss:authShow>
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>