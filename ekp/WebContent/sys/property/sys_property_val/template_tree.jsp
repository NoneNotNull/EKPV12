<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView("LKSTree", "分类树", document.getElementById("treeDiv"));
	var n1, n2, n3, n4, n5;
	var modelName= "${param.modelName}" ; 
	n1 = LKSTree.treeRoot;
	n1.AppendBeanData(
		"sysPropertyValTree&templateId=!{value}"+"&modelName="+modelName
	);
	// n2 = n1.AppendURLChild("导入属性值模板下载","<c:url value="/sys/property/sys_property_val/sql-template.xls" />");
	// n2 = n1.AppendURLChild("导入模板","<c:url value="/sys/property/sys_property_val/sysPropertyValAddExcel.jsp" />");
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>