﻿<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.tib.common.mapping" bundle="tib-common-mapping"/>",
		document.getElementById("treeDiv")
	);
	var n1_common, n2_common, n3, n4, n5;
	n1_common = LKSTree.treeRoot;
	
	<%-- 应用模块注册 --%>
	n2_common = n1_common.AppendURLChild(
		"<bean:message key="table.tibCommonMappingModule" bundle="tib-common-mapping" />",
		"<c:url value="/tib/common/mapping/tib_common_mapping_module/tibCommonMappingModule.do?method=list" />"
	);
	<%-- 表单流程映射  --%>
	n2_common = n1_common.AppendURLChild(
		"<bean:message key="tree.form.flow.mapping" bundle="tib-common-mapping" />",
		""
	);
	<%--加载模块树--%>
	n2_common = n2_common.AppendBeanData("tibCommonMappingModuleTreeService&id=!{value}"
	);
	//LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
