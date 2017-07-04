<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.UserUtil" %>
<%@ include file="/resource/jsp/tree_top.jsp" %>
function generateTree(){
	LKSTree = new TreeView(
		"LKSTree", 
		"<bean:message bundle='sys-tag' key='sysTag.tree.title'/>", 
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5, n6;
	n1 = LKSTree.treeRoot;
	
	//标签排行
	n2 = n1.AppendURLChild(
		"<bean:message key="sysTag.tree.top" bundle="sys-tag" />",
		"<c:url value="/sys/tag/sys_tag_top_log/sysTagTopLog.do?method=searchTop" />","_blank"
	);
	//所有标签
	n2 = n1.AppendURLChild(
		"<bean:message key="sysTag.tree.all" bundle="sys-tag" />",
		"<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=list" />"
	);
	//公有标签
	n2 = n1.AppendURLChild(
		"<bean:message key="sysTag.tree.public" bundle="sys-tag" />",
		"<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdIsPrivate=1" />"
	);		
	//按状态
	n3 = n2.AppendURLChild(
		"<bean:message key="sysTag.tree.status" bundle="sys-tag" />"
	);
	//生效
	n4 = n3.AppendURLChild(
		"<bean:message key="sysTag.tree.status.true" bundle="sys-tag" />",
		"<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdStatus=1&fdIsPrivate=1" />"
	);	
	//失效
	n4 = n3.AppendURLChild(
		"<bean:message key="sysTag.tree.status.false" bundle="sys-tag" />",
		"<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdStatus=0&fdIsPrivate=1" />"
	);	
	//按类别
	n3 = n2.AppendURLChild(
		"<bean:message key="sysTag.tree.category" bundle="sys-tag" />"
	);
	n4 = n3.AppendBeanData(
		"sysTagCategoryListService",
		"<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdCategoryId=!{value}&fdIsPrivate=1" />"
	);
	<kmss:auth
	requestURL="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdCategoryId=null"
	requestMethod="GET">
	//无类别
	n3 = n2.AppendURLChild(
		"<bean:message key="sysTag.tree.category.none" bundle="sys-tag" />",
		"<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdCategoryId=null&fdIsPrivate=1" />"
	);
	</kmss:auth>
	
	//私有标签		
	n2 = n1.AppendURLChild(
		"<bean:message key="sysTag.tree.private" bundle="sys-tag" />",
		"<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdIsPrivate=0" />"
	); 	
	//按状态
	n3 = n2.AppendURLChild(
		"<bean:message key="sysTag.tree.status" bundle="sys-tag" />"
	);
	//生效
	n4 = n3.AppendURLChild(
		"<bean:message key="sysTag.tree.status.true" bundle="sys-tag" />",
		"<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdStatus=1&fdIsPrivate=0" />"
	);	
	//失效
	n4 = n3.AppendURLChild(
		"<bean:message key="sysTag.tree.status.false" bundle="sys-tag" />",
		"<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdStatus=0&fdIsPrivate=0" />"
	);	
	//按类别
	n3 = n2.AppendURLChild(
		"<bean:message key="sysTag.tree.category" bundle="sys-tag" />"
	);
	n4 = n3.AppendBeanData(
		"sysTagCategoryListService",
		"<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdCategoryId=!{value}&fdIsPrivate=0" />"
	);
	<kmss:auth
	requestURL="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdCategoryId=null"
	requestMethod="GET">
	//无类别
	n3 = n2.AppendURLChild(
		"<bean:message key="sysTag.tree.category.none" bundle="sys-tag" />",
		"<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdCategoryId=null&fdIsPrivate=0" />"
	);	
	</kmss:auth>
	
	
	//个人标签
	n2 = n1.AppendURLChild(
		"<bean:message key="sysTag.tree.person" bundle="sys-tag" />",
		"<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdIsPrivate=2" />"
	);		
	//按状态
	n3 = n2.AppendURLChild(
		"<bean:message key="sysTag.tree.status" bundle="sys-tag" />"
	);
	//生效
	n4 = n3.AppendURLChild(
		"<bean:message key="sysTag.tree.status.true" bundle="sys-tag" />",
		"<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdStatus=1&fdIsPrivate=2" />"
	);	
	//失效
	n4 = n3.AppendURLChild(
		"<bean:message key="sysTag.tree.status.false" bundle="sys-tag" />",
		"<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdStatus=0&fdIsPrivate=2" />"
	);	
	//按类别
	n3 = n2.AppendURLChild(
		"<bean:message key="sysTag.tree.category" bundle="sys-tag" />"
	);
	n4 = n3.AppendBeanData(
		"sysTagCategoryListService",
		"<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdCategoryId=!{value}&fdIsPrivate=2" />"
	);
	<kmss:auth
	requestURL="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdCategoryId=null"
	requestMethod="GET">
	//无类别
	n3 = n2.AppendURLChild(
		"<bean:message key="sysTag.tree.category.none" bundle="sys-tag" />",
		"<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=list&fdCategoryId=null&fdIsPrivate=2" />"
	);
	</kmss:auth>
	
	//系统设置
	n2 = n1.AppendURLChild(
		"<bean:message key="sysTag.tree.system" bundle="sys-tag" />"
	);
	//标签类别管理
	n3 = n2.AppendURLChild(
		"<bean:message key="sysTag.tree.system.category" bundle="sys-tag" />",
		"<c:url value="/sys/tag/sys_tag_category/sysTagCategory.do?method=list" />"
	);
	//标签云设置
	n3 = n2.AppendURLChild(
		"<bean:message key="sysTag.tags.cloud.setting" bundle="sys-tag"/>",
      " <c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=tagCloudSetting" />"
	);
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
  
<%@ include file="/resource/jsp/tree_down.jsp" %>
