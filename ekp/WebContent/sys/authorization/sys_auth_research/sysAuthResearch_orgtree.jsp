<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.UserUtil" %>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
<%request.setAttribute("currentUser", UserUtil.getKMSSUser(request)); %>
function generateTree()
{
	var para = new Array;
	var href = location.href;
	<% if(ISysAuthConstant.IS_AREA_ENABLED) { %>
	para[0] = '<c:url value="/sys/authorization/sys_auth_research/sysAuthResearch.do?method=researchPerson"/>&personId=!{value}&type=0';
	<% } else { %>
	para[0] = '<c:url value="/sys/authorization/sys_auth_research/sysAuthResearch.do?method=researchPerson"/>&personId=!{value}';	
	<% } %>
	para[1] = Com_GetUrlParameter(href, "target");
	para[2] = Com_GetUrlParameter(href, "winStyle");
	LKSTree = new TreeView("LKSTree", "<bean:message bundle="sys-organization" key="organization.moduleName"/>", document.getElementById("treeDiv"));
	var n1 = LKSTree.treeRoot;
	n1.AppendBeanData("sysAuthAreaOrgTreeService&areaId=${currentUser.authAreaId}&parent=!{value}&orgType="+Com_GetUrlParameter(href, "orgType"), para, null, true);
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>