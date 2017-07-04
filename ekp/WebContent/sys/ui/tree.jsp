<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Collection"%>
﻿<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Comparator"%>
<%@page import="com.landray.kmss.util.comparator.ChinesePinyinComparator"%>
<%@page import="edu.emory.mathcs.backport.java.util.Collections"%>
<%@page import="java.util.Collection"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.SysUiAssembly"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"UI管理",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	n2 = n1.AppendURLChild(
		"扩展资源","<c:url value="/sys/ui/help/lui-ext/index.jsp" />"
	);
	n2 = n1.AppendURLChild(
		"主题样式","<c:url value="/sys/ui/help/theme/index.jsp" />"
	);
	n2 = n1.AppendURLChild(
		"图标列表","<c:url value="/sys/ui/help/theme/icon.jsp" />"
	);
	n2 = n1.AppendURLChild(
		"框架模板","<c:url value="/sys/ui/help/template/index.jsp" />"
	);
	n2 = n1.AppendURLChild(
		"变量类型","<c:url value="/sys/ui/help/varkind/index.jsp" />"
	);
	<%-- 部件 --%>
	n2 = n1.AppendURLChild(
		"部件类型"
	);
	
	LKSTree.ExpandNode(n2);
	
	<%
	List list = new ArrayList(SysUiPluginUtil.getAssemblies().values());
	Collections.sort(list,new Comparator(){
		public int compare(Object a, Object b) {
		 	SysUiAssembly a1 = (SysUiAssembly)a;
			SysUiAssembly a2 = (SysUiAssembly)b;  
			return ChinesePinyinComparator.compare(a1.getFdName(),a2.getFdName());			 
		}
	});
	Map xxx = new HashMap();
	for(int i=0;i<list.size();i++){
		String category = ((SysUiAssembly)list.get(i)).getFdCategory();
		if(!xxx.containsKey(category)){
			List xlist = new ArrayList();
			xlist.add(list.get(i));
			xxx.put(category,xlist);
		}else{
			((List)xxx.get(category)).add(list.get(i));
		}
	} 
	request.setAttribute("list",xxx);
	%>
	<c:forEach items="${list}" var="xcategory" > 
		n3 = n2.AppendURLChild('${xcategory.key }');
		
		<c:forEach items="${ xcategory.value }" var="assembly">			
			n4 = n3.AppendURLChild(
				"${ assembly.fdName }",
				"<%= request.getContextPath() %>${empty assembly.fdHelp ? '/sys/ui/help/assembly-help.jsp' : assembly.fdHelp}?fdId=${ assembly.fdId }"
			);	 
		</c:forEach>
		LKSTree.ExpandNode(n3);
	</c:forEach>
	n3 = n2.AppendURLChild(
		"其它组件",
		"<c:url value="/sys/ui/help/combine/index.jsp" />"
	);
	
	<%-- 部件 --%>
	n2 = n1.AppendURLChild(
		"重新加载xml定义","<c:url value="/sys/ui/help/xml.jsp" />"
	);
	n2 = n1.AppendURLChild(
		"更新缓存参数","<c:url value="/sys/ui/help/cache.jsp" />"
	);
	n2 = n1.AppendURLChild(
		"重新加载图标CSS","<c:url value="/sys/ui/help/theme/reloadIcon.jsp" />"
	);
	LKSTree.ExpandNode(n2);
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>