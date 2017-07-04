<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"${param.moduleName}",
		document.getElementById("treeDiv")
	);
	var n1;
	n1 = LKSTree.treeRoot;
	//0为简单分类
	<c:if test="${ param.cateType=='0'}">
		n1.AppendSimpleCategoryData("${param.templateName}","<c:url value="/tib/common/mapping/tib_common_mapping_main/tibCommonMappingMain.do?method=add&templateId=!{value}&name=!{text}&templateName=${param.templateName}&cateType=0&mainModelName=${param.mainModelName}&settingId=${param.settingId} " />");
	</c:if>
	
	//1为全局分类
	<c:if test="${ param.cateType=='1'}">
	n1.AppendCategoryData("${param.templateName}","<c:url value="/tib/common/mapping/tib_common_mapping_main/tibCommonMappingMain.do?method=listTemplate&parentId=!{value}&templateName=${param.templateName}&cateType=1&mainModelName=${param.mainModelName}&settingId=${param.settingId}" />",0,null);
</c:if>
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
