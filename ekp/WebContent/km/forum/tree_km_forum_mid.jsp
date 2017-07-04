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
	LKSTree = new TreeView("LKSTree", "<bean:message key="menu.kmForum.manage" bundle="km-forum"/>", document.getElementById("treeDiv"));
	var n1, n2, n3;
	n1 = LKSTree.treeRoot;

	//========== 论坛设置 ==========
	n1.AppendBeanData(
		"kmForumCategoryTreeService",
		null,
		opFormula,
		false
	);

	LKSTree.Show();
}

function opFormula(param){
	LKSTree.ExpandNode(this);
	Com_OpenWindow('<c:url value="/km/forum/km_forum_cate/kmForumCategory.do?method=manage&fdId=" />' + this.value);
}
<%@ include file="/resource/jsp/tree_down.jsp" %>