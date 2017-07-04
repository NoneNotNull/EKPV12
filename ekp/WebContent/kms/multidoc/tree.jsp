<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="kmsMultidoc.tree.title" bundle="kms-multidoc"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	
	// 文档导入
	<kmss:authShow roles="ROLE_KMSMULTIDOC_EXCEL_IMPORT">
	n1.AppendURLChild(
		"<bean:message bundle="kms-multidoc" key="kmsMultidoc.config.main.import"/>",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge"/>"
	);
	</kmss:authShow>
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
