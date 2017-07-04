<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.cluster.interfaces.ClusterDiscover"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView("LKSTree", "<bean:message bundle="sys-cluster" key="sysCluster.tree"/>", document.getElementById("treeDiv"));
	var n1, n2, n3,n4;
	n1 = LKSTree.treeRoot;
	
<kmss:authShow roles="SYSROLE_ADMIN">
	//========== 系统初始化 ==========
	<% if(ClusterDiscover.getInstance().isMultiSystemEnabled()){ %>
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-cluster" key="table.sysClusterGroup"/>",
		"<c:url value="/sys/cluster/sys_cluster_group/sysClusterGroup.do?method=list"/>"
	);
	<% } %>
	//========== 系统初始化 ==========
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-cluster" key="table.sysClusterServer"/>",
		"<c:url value="/sys/cluster/sys_cluster_server/sysClusterServer.do?method=list"/>"
	);
</kmss:authShow>
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>