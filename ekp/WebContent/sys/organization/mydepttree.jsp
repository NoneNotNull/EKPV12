<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
<%@page import="com.landray.kmss.util.UserUtil,
	com.landray.kmss.sys.organization.model.SysOrgPerson" %>
<%
	SysOrgPerson person = UserUtil.getUser(request);
	if(person.getFdParent()!=null)
		pageContext.setAttribute("startWith", ",\""+person.getFdParent().getFdId()+"\"");
%>
function generateTree()
{
	var para = new Array;
	var href = location.href;
	para[0] = Com_GetUrlParameter(href, "url");
	para[1] = Com_GetUrlParameter(href, "target");
	para[2] = Com_GetUrlParameter(href, "winStyle");
	LKSTree = new TreeView("LKSTree", "<bean:message bundle="sys-organization" key="organization.moduleName"/>", document.getElementById("treeDiv"));
	var n1 = LKSTree.treeRoot;
	if(Com_GetUrlParameter(href, "noRoot")!="true")
		n1.parameter = para;
	n1.AppendOrgData(Com_GetUrlParameter(href, "orgType"), para, null ${startWith});
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>