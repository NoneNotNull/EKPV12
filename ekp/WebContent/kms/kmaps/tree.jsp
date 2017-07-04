<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="kmsKmaps.tree.title" bundle="kms-kmaps"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;  
	
	//类别设置
   n1.AppendURLChild(
		"<bean:message bundle="kms-kmaps" key="menu.kmsKmaps.categoryconfig"/>",
		"<c:url value="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.kms.kmaps.model.KmsKmapsCategory&actionUrl=/kms/kmaps/kms_kmaps_category/kmsKmapsCategory.do&formName=kmsKmapsCategoryForm&mainModelName=com.landray.kmss.kms.kmaps.model.KmsKmapsMain&docFkName=docCategory"/>"
	); 
	//模版类别设置
	n1.AppendURLChild(
		"<bean:message bundle="kms-kmaps" key="menu.kmsKmapsTemplate.categoryconfig"/>", 
		"<c:url value="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.kms.kmaps.model.KmsKmapsTemplCategory&actionUrl=/kms/kmaps/kms_kmaps_templ_category/kmsKmapsTemplCategory.do&formName=kmsKmapsTemplCategoryForm&mainModelName=com.landray.kmss.kms.kmaps.model.KmsKmapsTemplate&docFkName=docCategory"/>"
	); 
	// 类别导入
	<kmss:auth requestURL="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.kms.kmaps.model.KmsKmapsCategory">
	n1.AppendURLChild(
		"<bean:message bundle="kms-kmaps" key="menu.kmsKmaps.config.category.import"/>",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.kms.kmaps.model.KmsKmapsCategory"/>"
	);
	</kmss:auth>
	//数据导入
	<kmss:auth requestURL="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.kms.kmaps.model.KmsKmapsCategory" requestMethod="GET"> 
	n1.AppendURLChild(
		"<bean:message bundle="kms-kmaps" key="kmsKmapsMain.dataImport"/>",
		"<c:url value="/kms/kmaps/kms_kmaps_import/kmsKmapsDataImport.jsp"/>"
	); 
	</kmss:auth>
	//流程模板设置
	<kmss:authShow roles="ROLE_KMSKMAPS_COMMONWORKFLOW">
		n1.AppendURLChild(
			"<bean:message key="kmsKmaps.tree.mainMeetingFlow" bundle="kms-kmaps" />",
			"<c:url value="/sys/workflow/sys_wf_common_template/sysWfCommonTemplate.do?method=list&fdModelName=com.landray.kmss.kms.kmaps.model.KmsKmapsCategory&fdKey=mainMap" />"
		);
	</kmss:authShow>
	
	n2 = n1.AppendURLChild("<bean:message key="kmsKmapsMain.maps.maintain" bundle="kms-kmaps" />");
	n2.authType="01";
	<kmss:authShow roles="ROLE_KMSKMAPS_CATEGORY_MAINTAINER_EXTENSION">
	n2.authRole="optAll";
	</kmss:authShow>
	n2.AppendSimpleCategoryDataWithAdmin("com.landray.kmss.kms.kmaps.model.KmsKmapsCategory",
		"<c:url value="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=manageList&categoryId=!{value}&status=all" />",
		"<c:url value="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=listChildren&categoryId=!{value}&orderby=docPublishTime&ordertype=down" />");
	
	
	n2 = n1.AppendURLChild("<bean:message key="kmsKmapsTemplate.maps.maintain" bundle="kms-kmaps" />");
	n2.authType="01";
	<kmss:authShow roles="ROLE_KMSKMAPS_CATEGORY_MAINTAINER_EXTENSION">
	n2.authRole="optAll";
	</kmss:authShow>
	n2.AppendSimpleCategoryDataWithAdmin("com.landray.kmss.kms.kmaps.model.KmsKmapsTemplCategory",
		"<c:url value="/kms/kmaps/kms_kmaps_template/kmsKmapsTemplate.do?method=manageList&categoryId=!{value}&status=all" />",
		"<c:url value="/kms/kmaps/kms_kmaps_template/kmsKmapsTemplate.do?method=listChildren&categoryId=!{value}&orderby=docPublishTime&ordertype=down" />");
	
 	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
