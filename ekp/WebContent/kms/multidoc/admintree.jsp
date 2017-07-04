<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
	<%-- 知识仓库 --%>
	n2 = n1.AppendURLChild(
		"知识库设置"
	);
	<%-- 分类设置 --%>
	n3 = n2.AppendURLChild(
		"<bean:message bundle="kms-multidoc" key="menu.kmdoc.categoryconfig"/>",
		"<c:url value="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate&actionUrl=/kms/multidoc/kms_multidoc_template/kmsMultidocTemplate.do&formName=kmsMultidocTemplateForm&mainModelName=com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge&docFkName=docCategory" />"
	);
	<%-- 辅类别设置/即文档类型设置 --%>
	n3 = n2.AppendURLChild(
		"文档类型设置",
		"<c:url value="/sys/category/sys_category_property/sysCategoryProperty_tree.jsp" />"
	);
	<%-- 通用流程模板设置 --%>
	<kmss:authShow roles="ROLE_KMSMULTIDOC_COMMONWORKFLOW">
	n2.AppendURLChild(
		"<bean:message key="tree.workflowTemplate" bundle="kms-multidoc" />",
		"<c:url value="/sys/workflow/sys_wf_common_template/sysWfCommonTemplate.do?method=list&fdModelName=com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate&fdKey=mainDoc" />"
	); 
	</kmss:authShow>
	<%-- 类别导入 --%>
	n3 = n2.AppendURLChild(
		"类别导入",
		"<c:url value="/kms/multidoc/kms_multidoc_template/kmsMultidocTemplate.do?method=importTemplate" />"
	);
	
	// 筛选设置
	n3 = n2.AppendURLChild(
		"<bean:message bundle="kms-multidoc" key="table.kmsMultidocFilterConfigMain"/>",
		"<c:url value="/kms/multidoc/kms_multidoc_filter_config/kmsMultidocFilterConfigMain.do?method=list&orderby=fdOrder" />"
	);