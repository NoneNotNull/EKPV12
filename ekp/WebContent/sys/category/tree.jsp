<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="com.landray.kmss.util.UserUtil"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.landray.kmss.sys.config.design.*"%>

<%
	request.setAttribute("userId", UserUtil.getUser(request).getFdId());
%>
<%@ include file="/resource/jsp/tree_top.jsp" %>

//Com_Parameter.XMLDebug = true;
function generateTree() { 
	LKSTree = new TreeView("LKSTree", "<bean:message key="menu.sysCategory.title" bundle="sys-category" />", document.getElementById("treeDiv"));
 	var n1, n2, n3;
 	n1 =LKSTree.treeRoot; //分类首页

	//组织目录树设置
	//n2 = n1.AppendURLChild("<bean:message key="menu.sysCategory.orgtree" bundle="sys-category" />" ,"<c:url	value="/sys/category/sys_category_org_tree/sysCategoryOrgTree.do?method=list" />");
 	//n3 = n2.AppendBeanData("sysCategoryOrgTreeTreeService&categoryId=!{value}", "<c:url	value="/sys/category/sys_category_org_tree/sysCategoryOrgTree.do?method=list&parentId=!{value}" />"); 
	//n2 = n1.AppendURLChild("<bean:message key="menu.sysCategory.orgtree" bundle="sys-category" />" ,"<c:url value="/sys/category/sys_category_org_tree/sysCategoryOrgTree_tree.jsp" />")
	
 	//分类设置
 	n2 = n1.AppendURLChild("分类设置","");
 	//n2 = n1.AppendURLChild("<bean:message key="menu.sysCategory.main" bundle="sys-category" />" ,"<c:url	value="/sys/category/sys_category_main/sysCategoryMain.do?method=list" />");
 	//n3 = n2.AppendBeanData("sysCategoryTreeService&modelName=com.landray.catetory&categoryId=!{value}", "<c:url	value="/sys/category/sys_category_main/sysCategoryMain.do?method=list&modelName=com.landray.catetory&parentId=!{value}" />");
 	<%
 		SysConfigs cateConfig = SysConfigs.getInstance();
	 	Iterator categoryMng = cateConfig.getCategoryMngs().values().iterator();
		while (categoryMng.hasNext()) {
			SysCfgCategoryMng category = (SysCfgCategoryMng) categoryMng.next();
	%>	
		n3 = n2.AppendURLChild("<kmss:message key="<%=category.getMessageKey()%>" />" ,"<c:url value="/sys/category/sys_category_main/sysCategoryMain_tree.jsp" />?modelName=<%=category.getModelName()%>")
	<%			
		}	 	
 	%> 
 	//n3 = n2.AppendURLChild("<bean:message key="menu.sysCategory.main" bundle="sys-category" />" ,"<c:url value="/sys/category/sys_category_main/sysCategoryMain_tree.jsp?modelName=com.landray.catetory" />")
 	
 	n2 = n1.AppendURLChild("<bean:message key="menu.sysCategory.property" bundle="sys-category" />" ,"<c:url value="/sys/category/sys_category_property/sysCategoryProperty_tree.jsp" />")
 	//辅类别设置
 	//n2 = n1.AppendURLChild("<bean:message key="menu.sysCategory.property" bundle="sys-category" />" ,"<c:url	value="/sys/category/sys_category_property/sysCategoryProperty.do?method=list" />");
 	//n3 = n2.AppendBeanData("sysCategoryPropertyTreeService&categoryId=!{value}", "<c:url	value="/sys/category/sys_category_property/sysCategoryProperty.do?method=list&parentId=!{value}" />"); 
 		
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp"%>
