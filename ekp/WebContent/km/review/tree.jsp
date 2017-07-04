<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="kmReview.tree.title" bundle="km-review"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	//=========模块设置========
	//类别设置
	n1.AppendURLChild(
		"<bean:message key="kmReview.tree.categorySet" bundle="km-review" />",
		"<c:url value="/sys/category/sys_category_main/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.km.review.model.KmReviewTemplate&mainModelName=com.landray.kmss.km.review.model.KmReviewMain&templateName=fdTemplate&categoryName=docCategory&authReaderNoteFlag=2" />"
	);
	
	n1.AppendCV2Child("<bean:message key="table.kmReviewTemplate" bundle="km-review" />",
		"com.landray.kmss.km.review.model.KmReviewTemplate",
		"<c:url value="/km/review/km_review_template/kmReviewTemplate.do?method=listChildren&parentId=!{value}&ower=1" />");
	<kmss:authShow roles="ROLE_KMREVIEW_SETTING">
	<% if(com.landray.kmss.sys.number.util.NumberResourceUtil.isModuleNumberEnable("com.landray.kmss.km.review.model.KmReviewMain")){ %>
		n1.AppendURLChild(
			"<bean:message bundle="sys-number" key="sysNumber.config.tree.numberMain"/>",
			"<c:url value="/sys/number/sys_number_main/sysNumberMain.do?method=list&modelName=com.landray.kmss.km.review.model.KmReviewMain" />"
		);
		<%} %>
	//流程模板设置
	n1.AppendURLChild(
		"<bean:message key="tree.workflowTemplate" bundle="km-review" />",
		"<c:url value="/sys/workflow/sys_wf_common_template/sysWfCommonTemplate.do?method=list&fdModelName=com.landray.kmss.km.review.model.KmReviewTemplate&fdKey=reviewMainDoc" />"
	); 
	//表单模板设置
	n1.AppendURLChild(
		"<bean:message key="tree.xform.def" bundle="sys-xform" />",
		"<c:url value="/sys/xform/sys_form_common_template/sysFormCommonTemplate.do">
			<c:param name="method" value="list" />
			<c:param name="fdModelName" value="com.landray.kmss.km.review.model.KmReviewTemplate" />
			<c:param name="fdKey" value="reviewMainDoc" />
			<c:param name="fdMainModelName" value="com.landray.kmss.km.review.model.KmReviewMain" />
		</c:url>"
	);

	// 模块通知机制设置
	n1.AppendURLChild(
		"<bean:message key="kmReview.config.notify" bundle="km-review" />",
		"<c:url value="/sys/appconfig/sys_appconfig/sysAppConfig.do?method=edit&modelName=com.landray.kmss.km.review.model.KmReviewConfigNotify" />"
	);
	// 表单存储设置
	n1.AppendURLChild(
		"<bean:message key="sysFormDb.tree.config" bundle="sys-xform" />",
		"<c:url value="/sys/xform/base/sys_form_db_table/sysFormDbTable.do">
			<c:param name="method" value="list"/>
			<c:param name="fdModelName" value="com.landray.kmss.km.review.model.KmReviewMain"/>
			<c:param name="fdTemplateModel" value="com.landray.kmss.km.review.model.KmReviewTemplate"/>
			<c:param name="fdKey" value="reviewMainDoc"/>
		</c:url>"
	);
	//搜索设置
	n1.AppendURLChild(
		"<bean:message bundle="km-review" key="search.config.tree.title"/>",
		"<c:url value="/sys/search/sys_search_main/sysSearchMain.do?method=list&fdModelName=com.landray.kmss.km.review.model.KmReviewMain&fdKey=reviewMainDoc"/>"
	);
	</kmss:authShow>
	n2 = n1.AppendURLChild("<bean:message key="tree.sysCategory.maintains" bundle="sys-category" />")
	n2.authType="01";
	<kmss:authShow roles="ROLE_KMREVIEW_OPTALL">
	n2.authRole="optAll";
	</kmss:authShow>
	n2.AppendCategoryDataWithAdmin ("com.landray.kmss.km.review.model.KmReviewTemplate","<c:url value="/km/review/km_review_main/kmReviewMain.do?method=manageList&categoryId=!{value}"/>","<c:url value="/km/review/km_review_main/kmReviewMain.do?method=listChildren&type=category&categoryId=!{value}"/>");
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>