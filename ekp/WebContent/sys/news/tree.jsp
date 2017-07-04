<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="news.tree.title" bundle="sys-news"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
		
	//=========模块设置========
	n2 = n1.AppendURLChild(
		"<bean:message key="news.tree.moduleSet" bundle="sys-news" />"
	);
	
	//类别设置
	n3 = n2.AppendURLChild(
		"<bean:message key="news.category.set" bundle="sys-news" />",
		"<c:url value="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.sys.news.model.SysNewsTemplate&actionUrl=/sys/news/sys_news_template/sysNewsTemplate.do&formName=sysNewsTemplateForm&mainModelName=com.landray.kmss.sys.news.model.SysNewsMain&docFkName=fdTemplate" />"
	);
	<kmss:authShow roles="ROLE_SYSNEWS_CATEGORY_MAINTAINER">
		n2.AppendURLChild(
		"<bean:message bundle="sys-news" key="sysNewsMain.param.config"/>",
		"<c:url value="/sys/news/sys_news_main/sysNewsConfig.do?method=edit&modelName=com.landray.kmss.sys.news.model.SysNewsConfig" />"
	);
	</kmss:authShow>
	<kmss:authShow roles="ROLE_SYSNEWS_COMMONWORKFLOW">
		n2.AppendURLChild(
			"<bean:message key="Template.tree.fdIsDefault" bundle="sys-news" />",
			"<c:url value="/sys/workflow/sys_wf_common_template/sysWfCommonTemplate.do?method=list&fdModelName=com.landray.kmss.sys.news.model.SysNewsTemplate&fdKey=newsMainDoc" />"
		);
	</kmss:authShow>
	n2 = n1.AppendURLChild("<bean:message key="tree.sysCategory.maintains" bundle="sys-category" />")
	n2.authType="01";
	<kmss:authShow roles="ROLE_SYSNEWS_OPTALL">
	n2.authRole="optAll";
	</kmss:authShow>
	n2.AppendSimpleCategoryDataWithAdmin ("com.landray.kmss.sys.news.model.SysNewsTemplate",
	"<c:url value="/sys/news/sys_news_main/sysNewsMain.do?method=manageList&categoryId=!{value}&showDocStatus=true" />",
	"<c:url value="/sys/news/sys_news_main/sysNewsMain.do?method=listChildren&type=category&categoryId=!{value}"/>");
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>