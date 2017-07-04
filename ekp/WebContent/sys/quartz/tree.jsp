<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		'<bean:message bundle="sys-quartz" key="table.sysQuartzJob"/>',
		document.getElementById("treeDiv")
	);
	var n1 = LKSTree.treeRoot;
	n1.AppendURLChild(
		'<bean:message bundle="sys-quartz" key="sysQuartzJob.tree.init"/>',
		'<c:url value="/sys/quartz/sys_quartz_job/sysQuartzJob.do?method=systemInit"/>');
	n1.AppendURLChild(
		'<bean:message bundle="sys-quartz" key="sysQuartzJob.sysJob"/>',
		'<c:url value="/sys/quartz/sys_quartz_job/sysQuartzJob.do?method=list&sysJob=1"/>');
	n1.AppendURLChild(
		'<bean:message bundle="sys-quartz" key="sysQuartzJob.normalJob"/>',
		'<c:url value="/sys/quartz/sys_quartz_job/sysQuartzJob.do?method=list&sysJob=0"/>');
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>