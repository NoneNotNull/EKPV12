<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.tib.sys.core.provider" bundle="tib-sys-core-provider"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	<%-- 导入初始化数据 --%>
	n2_init = n1.AppendURLChild(
		"<bean:message key="tibSysCoreIface.importInit" bundle="tib-sys-core-provider" />",
		"<c:url value="/tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do?method=importInit" />"
	);
	<%-- provider接口定义 --%>
	n2_iface = n1.AppendURLChild(
		"<bean:message key="table.tibSysCoreIface" bundle="tib-sys-core-provider" />",
		"<c:url value="/tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do?method=list" />"
	);
	<%-- provider接口实现 --%>
	n2_impl = n1.AppendURLChild(
		"<bean:message key="table.tibSysCoreIfaceImpl" bundle="tib-sys-core-provider" />",
		"<c:url value="/tib/sys/core/provider/tib_sys_core_iface_impl/tibSysCoreIfaceImpl.do?method=list" />"
	);
	<%-- 节点信息
	n2 = n1.AppendURLChild(
		"<bean:message key="table.tibSysCoreNode" bundle="tib-sys-core-provider" />",
		"<c:url value="/tib/sys/core/provider/tib_sys_core_node/tibSysCoreNode.do?method=list" />"
	); --%>
	<%-- 标签信息
	n2 = n1.AppendURLChild(
		"<bean:message key="table.tibSysCoreTag" bundle="tib-sys-core-provider" />",
		"<c:url value="/tib/sys/core/provider/tib_sys_core_tag/tibSysCoreTag.do?method=list" />"
	); --%>
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>