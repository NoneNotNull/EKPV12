<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.tib.sys.soap.connector" bundle="tib-sys-soap-connector"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	<!--SOAP服务注册管理节点 -->
	n2 = n1.AppendURLChild(
	   "<bean:message key="tibSysSoapSettCategory.registerManager" bundle="tib-sys-soap-connector" />",
		""
	);
	
	<!-- SOAP服务注册 节点--> 
	n3 = n2.AppendURLChild(
		"<bean:message key="tree.tibSysSoapSetting.register" bundle="tib-sys-soap-connector" />",
		"<c:url value="/tib/sys/soap/connector/tib_sys_soap_setting/tibSysSoapSetting.do?method=list" />"
	);
	<!-- 将目录中的节点添加到n3节点下-->
	  n3.AppendBeanData(
				"tibSysSoapSettCategoryTreeService&parentId=!{value}",
				"<c:url value="/tib/sys/soap/connector/tib_sys_soap_setting/tibSysSoapSetting.do?method=list&categoryId=!{value}" />"
			);
	
	<!-- SOAP 分类配置 节点-->
	n4 = n2.AppendURLChild(
		"<bean:message key="table.tibSysSoapSettCategory" bundle="tib-sys-soap-connector" />",
		"<c:url value="/tib/sys/soap/connector/tib_sys_soap_sett_category/tibSysSoapSettCategory_tree.jsp" />"
	);
	
	
	<!-- SOAP函数管理 --> 
	n2 = n1.AppendURLChild(
		"<bean:message key="tree.tibSysSoapMain.func.manager" bundle="tib-sys-soap-connector" />",
		""
	);
		<!-- 函数配置 -->
		n3 = n2.AppendURLChild(
			"<bean:message key="tibSysSoapMain.func.config" bundle="tib-sys-soap-connector" />",
			"<c:url value="/tib/sys/soap/connector/tib_sys_soap_main/tibSysSoapMain.do?method=list" />"
		);
			n3.AppendBeanData(
				"tibSysSoapCategoryTreeService&parentId=!{value}",
				"<c:url value="/tib/sys/soap/connector/tib_sys_soap_main/tibSysSoapMain.do?method=list&categoryId=!{value}" />"
			);
		<!-- 分类配置 -->
		n2.AppendURLChild(
			"<bean:message key="tibSysSoapMain.category.config" bundle="tib-sys-soap-connector" />",
			"<c:url value="/tib/sys/soap/connector/tib_sys_soap_category/tibSysSoapCategory_tree.jsp" />"
		);
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
