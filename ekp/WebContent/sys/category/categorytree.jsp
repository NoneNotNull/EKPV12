<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp" %>
<%@ page import="com.landray.kmss.sys.category.interfaces.CategoryUtil" %>
<div id=treeDiv class="treediv"></div>
<script type="text/javascript">Com_IncludeFile("treeview.js");</script>
<script>
	<%
	    String modelName = request.getParameter("modelName");
	    if (StringUtil.isNotNull(modelName)
			&& CategoryUtil.isAdminRole(modelName)) {
	%>
	function Category_OnLoad() { 
		generateTree();
	}
	<%  } else {%>
	function NodeFunc_FetchChildrenByXML(){
		var nodesValue = new KMSSData().AddXMLData(Com_ReplaceParameter(this.XMLDataInfo.beanURL, this)).GetHashMapArray();
		for(var i=0; i<nodesValue.length; i++){
			if(Category_CheckAuth(nodesValue[i]))
				this.FetchChildrenUseXMLNode(nodesValue[i]);
		}
	}
	function Category_CheckAuth(nodeValue){
		var value = nodeValue["value"];
		for(var i=0; i<Category_AuthIds.length; i++){
			if(Category_AuthIds[i]["v"]==value){
				return true;
			}
		}
		return false;
	}
	var Category_AuthIds;
	function Category_OnLoad() { // 过滤没权限或者没有模板的分类节点
		Category_AuthIds = new KMSSData().AddBeanData("sysCategoryAuthListService&modelName=${param.modelName}&getTemplate=2&getReadCate=true").GetHashMapArray();
		generateTree();
	}
	<% } %>
window.onload = Category_OnLoad;

var LKSTree;
Tree_IncludeCSSFile();
function generateTree()
{
	var para = new Array;
	var href = location.href;
	para[0] = Com_GetUrlParameter(href, "url");
	para[1] = Com_GetUrlParameter(href, "target");
	para[2] = Com_GetUrlParameter(href, "winStyle");
	LKSTree = new TreeView("LKSTree", "<bean:message bundle="sys-category" key="sysCategoryMain.modelName"/>", document.getElementById("treeDiv"));
	var n1 = LKSTree.treeRoot;
	n1.AppendCategoryData(Com_GetUrlParameter(href, "modelName"), para, 0,0,Com_GetUrlParameter(href, "showTemplate"),null, Com_GetUrlParameter(href, "startWith"));
	LKSTree.Show();
}
</script>
<%@ include file="/resource/jsp/view_down.jsp" %>