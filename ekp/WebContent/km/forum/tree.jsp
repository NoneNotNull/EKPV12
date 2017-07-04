<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.landray.kmss.util.UserUtil" %>
<%
	request.setAttribute("userId",UserUtil.getUser(request).getFdId());
%>
    
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView("LKSTree", "<bean:message key="home.nav.kmForum" bundle="km-forum"/>", document.getElementById("treeDiv"));
	var n1, n2, n3;
	n1 = LKSTree.treeRoot;
	
	//========== 我的论坛 ==========
	n2 = n1.AppendURLChild("<bean:message key="menu.kmForum.myForum" bundle="km-forum"/>");
	//发表的帖子
	n2.AppendURLChild("<bean:message key="menu.kmForum.myTopic" bundle="km-forum"/>",
	 "<c:url value="/km/forum/km_forum/kmForumTopic.do?method=list&myPost=true" />");
	//参与的讨论
	n2.AppendURLChild("<bean:message key="menu.kmForum.myPost" bundle="km-forum"/>",
	 "<c:url value="/km/forum/km_forum/kmForumTopic.do?method=list&MyJoin=true"/>");
	//个人信息
	n2.AppendURLChild("<bean:message key="menu.kmForum.userInfo" bundle="km-forum"/>",
	 "<c:url value="/km/forum/km_forum_score/kmForumScore.do?method=view&owner=true"/>");
	//草稿帖子
	n2.AppendURLChild("<bean:message key="menu.kmForum.draftForum" bundle="km-forum"/>",
	 "<c:url value="/km/forum/km_forum/kmForumTopic.do?method=draftList&isDraft=true"/>");	
	 
	//所有帖子
	n2=n1.AppendURLChild("<bean:message key="menu.kmForum.allTopic" bundle="km-forum"/>",
	 "<c:url value="/km/forum/km_forum/kmForumTopic.do?method=list&all=true"/>");
	
	//论坛首页
	n2 = n1.AppendURLChild("<bean:message key="menu.kmForum.main" bundle="km-forum"/>"
		,"<c:url value="/km/forum/km_forum_cate/kmForumCategory.do?method=main"/>");
	n3 = n2.AppendBeanData("kmForumCategoryTeeService&categoryId=!{value}");
	
	
	//精华区
	n2 = n1.AppendURLChild("<bean:message key="menu.kmForum.pink" bundle="km-forum"/>"
	,"<c:url value="/km/forum/km_forum/kmForumTopic.do?method=list&fdPinked=1"/>");
	n3 = n2.AppendBeanData("kmForumCategoryTeeService&categoryId=!{value}&fdPinked=1");
		
	//============ 搜索换为机制 modify by zhouchao 20090525==================
	//论坛搜索
	// n2 = n1.AppendURLChild("<bean:message key="menu.kmForum.search" bundle="km-forum"/>"
	//	 ,"<c:url value="/sys/ftsearch/searchBuilder.do?method=searchPage&modelName=com.landray.kmss.km.forum.model.KmForumPost"/>");
	
	//-------------搜索换为机制 modify by zhouchao 20090525------------------
	//搜索
    n2 = n1.AppendURLChild(
		"<bean:message bundle="km-forum" key="KmForumPost.search.title"/>",
		"<c:url value="/sys/search/search.do?method=condition&fdModelName=com.landray.kmss.km.forum.model.KmForumTopic" />"
	);
	
	
	 
	//========== 论坛设置 ==========
	n2 = n1.AppendURLChild("<bean:message bundle="km-forum" key="menu.kmForum.config"/>");
	<kmss:authShow roles="ROLE_KMFORUMCONFIG_ADMIN">
	n3 = n2.AppendURLChild("<bean:message bundle="km-forum" key="menu.kmForum.global"/>");
	n4 = n3.AppendURLChild("<bean:message bundle="km-forum" key="menu.kmForum.config"/>",
		 "<c:url value="/km/forum/km_forum_config/kmForumConfig.do?method=edit" />");
	n4 = n3.AppendURLChild("<bean:message bundle="km-forum" key="menu.kmForum.directory"/>",
		 "<c:url value="/km/forum/km_forum_cate/kmForumCategory.do?method=list&type=directory" />");
	</kmss:authShow> 
	<kmss:authShow roles="ROLE_KMFORUMCATE_ADMIN">
	n4 = n3.AppendURLChild("<bean:message bundle="km-forum" key="menu.kmForum.category"/>",
		 "<c:url value="/km/forum/km_forum_cate/kmForumCategory.do?method=list&type=forum" />");
	</kmss:authShow>
	n3 = n2.AppendURLChild("<bean:message bundle="km-forum" key="menu.kmForum.manage"/>");
	n3.AppendBeanData("kmForumCategoryTeeService&categoryId=!{value}&isManage=true");
	LKSTree.EnableRightMenu();	
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>