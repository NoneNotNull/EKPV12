﻿<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.tib.common" bundle="tib-common"/>",
		document.getElementById("treeDiv")
	);
	var n1_common, n2_common, n1_log,n3, n4, n5;
	n1_common = LKSTree.treeRoot;
	
	n_mapping=n1_common.AppendURLChild("<bean:message key="module.tib.common.mapping" bundle="tib-common-mapping" />","");
	
	n1_log=n1_common.AppendURLChild("<bean:message key="tib.common.log.manager" bundle="tib-common-log" />","");
	
	<%-- 导入导出 --%>
	var n1_imExport= n1_common.AppendURLChild(
		"<bean:message key="module.tib.common.inoutdata" bundle="tib-common-inoutdata" />",
		""
	);
	
	
	
	<%-- 应用模块注册 --%>
	n1_mapping = n_mapping.AppendURLChild(
		"<bean:message key="table.tibCommonMappingModule" bundle="tib-common-mapping" />",
		"<c:url value="/tib/common/mapping/tib_common_mapping_module/tibCommonMappingModule.do?method=list" />"
	);
	<%-- 表单流程映射  --%>
	n2_mapping = n_mapping.AppendURLChild(
		"<bean:message key="tree.form.flow.mapping" bundle="tib-common-mapping" />",
		""
	);
	<%--加载模块树--%>
	n3_common = n2_mapping.AppendBeanData("tibCommonMappingModuleTreeService&id=!{value}"
	);
	
	<%-- 日志配置tibCommonManage --%>
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
	
	
	<%-- 导出 --%>
	n2_export = n1_imExport.AppendURLChild(
		"<bean:message key="imExport.dataExport" bundle="tib-common-inoutdata" />",
		"<c:url value="/tib/common/inoutdata/tibCommonInoutdata_export.jsp" />"
	);
	
	<%-- 导入 --%>
	n2_import = n1_imExport.AppendURLChild(
		"<bean:message key="imExport.dataImport" bundle="tib-common-inoutdata" />",
		"<c:url value="/tib/common/inoutdata/tibCommonInoutdata_upload.jsp" />"
	);

	<%-- 数据初始化 --%>
	var n1_init = n1_common.AppendURLChild(
		"<bean:message key="module.init.data" bundle="tib-common-init" />",
		"<c:url value="/tib/common/init/tibCommonInit.do?method=showInit" />"
	);

	//LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
