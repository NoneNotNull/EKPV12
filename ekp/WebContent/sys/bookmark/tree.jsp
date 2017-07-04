<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="tree.node.root" bundle="sys-bookmark"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3;
	n1 = LKSTree.treeRoot;
	
	<%-- 按分类 --%>
	<%-- n2 = n1.AppendURLChild(
		"<bean:message key="tree.node.view.category" bundle="sys-bookmark" />",
		"<c:url value="/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do" />?method=list"
	);
	n2.AppendBeanData("sysBookmarkCategoryTreeService&parentId=!{value}&type=all&href=true");
	n2.AppendURLChild(
		"<bean:message key="tree.node.view.other" bundle="sys-bookmark" />",
		"<c:url value="/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do" />?method=list&category=null"
	); --%>
	<%-- 按来源 --%>
	<%-- n2 = n1.AppendURLChild(
		"<bean:message key="tree.node.view.source" bundle="sys-bookmark" />"
	);
	n3 = n2.AppendURLChild(
		"<bean:message key="tree.node.view.modelSource" bundle="sys-bookmark" />",
		"<c:url value="/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do" />?method=list&modelName=all"
	);
	n3.AppendBeanData(
		"sysBookmarkSourceTreeService",
		"<c:url value="/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do" />?method=list&modelName=!{value}"
	);
	n2.AppendURLChild(
		"<bean:message key="tree.node.view.otherSource" bundle="sys-bookmark" />",
		"<c:url value="/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do" />?method=list&modelName=null"
	); --%>
	<%-- 搜索 --%>
	<%-- n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-bookmark" key="SysBookmarkMain.search"/>",
		"<c:url value="/sys/search/search.do?method=condition&fdModelName=com.landray.kmss.sys.bookmark.model.SysBookmarkMain" />"
	); --%>
	<%-- 全文检索取消
	n3 = n2.AppendURLChild(
		"<bean:message bundle="sys-bookmark" key="SysBookmarkMain.ftSearch"/>",
		"<c:url value="/sys/ftsearch/searchBuilder.do?method=searchPage&modelName=com.landray.kmss.sys.bookmark.model.SysBookmarkMain" />"
	); --%>

	<%-- 分类设置 --%>
	<%-- n2 = n1.AppendURLChild(
		"<bean:message key="tree.node.config.category" bundle="sys-bookmark" />"
	);
	<kmss:authShow roles="ROLE_BOOKMARK_ADMIN">
	n2.AppendURLChild(
		"<bean:message key="tree.node.config.category.public" bundle="sys-bookmark" />",
		"<c:url value="/sys/bookmark/sys_bookmark_public_category/sysBookmarkPublicCategory_tree.jsp" />"
	);
	</kmss:authShow>
	n2.AppendURLChild(
		"<bean:message key="tree.node.config.category.person" bundle="sys-bookmark" />",
		"<c:url value="/sys/bookmark/sys_bookmark_person_category/sysBookmarkPersonCategory_tree.jsp" />"
	); --%>
	
	<kmss:authShow roles="ROLE_BOOKMARK_ADMIN">
	n1.AppendURLChild(
		"<bean:message key="tree.node.view.other" bundle="sys-bookmark" />",
		"<c:url value="/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do" />?method=list&category=null"
	);
	
	n1.AppendURLChild(
		"<bean:message key="tree.node.config.category.public" bundle="sys-bookmark" />",
		"<c:url value="/sys/bookmark/sys_bookmark_public_category/sysBookmarkPublicCategory_tree.jsp" />"
	);
	</kmss:authShow>
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
