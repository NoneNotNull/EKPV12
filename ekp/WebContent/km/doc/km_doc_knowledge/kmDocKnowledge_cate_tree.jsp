<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
function generateTree()
{
	var para = new Array;
	var href = location.href;
	para[0] = Com_GetUrlParameter(href, "url");
	para[1] = Com_GetUrlParameter(href, "target");
	para[2] = Com_GetUrlParameter(href, "winStyle");
	LKSTree = new TreeView("LKSTree", "<bean:message bundle="sys-category" key="sysCategoryMain.modelName"/>", document.getElementById("treeDiv"));
	var n1 = LKSTree.treeRoot;	
	
	n1.AppendCategoryData(
		"com.landray.kmss.km.doc.model.KmDocTemplate",
		"<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=listChildren&type=category&pink=true&categoryId=!{value}&isShowAll=false" />",
		true
	);
	
//	n1.AppendBeanData("sysCategoryTreeService&categoryId=!{value}",
//		"<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=listChildren&pink=true&parentId=!{value}&isShowAll=false"/>"
//	);	
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>