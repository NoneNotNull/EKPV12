<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page import="com.landray.kmss.sys.category.interfaces.CategoryUtil" %>
<html:form action="/sys/category/sys_category_main/sysCategoryMain.do">
	<div id="optBarDiv">
		<input type="button" value="<bean:message key="button.add"/>" onclick="addCategory();" />
		<input type="button" value="<bean:message key="button.edit"/>" onclick="editCategory();" />
		<input type="button" value="<bean:message key="button.delete"/>" onclick="deleteCategories();" />
		<input type="button" value="<bean:message key="button.copy"/>" onclick="copyCategory();" />
		<c:if test="${param.modelName!=null && param.mainModelName!=null}">
			<kmss:authShow roles="ROLE_SYSCATEGORY_MAINTAINER">
			<input type="button" value="<bean:message  bundle="sys-right" key="right.button.changeRightBatch"/>" onclick="updateCateRight();" />
			</kmss:authShow>
		</c:if>
		<input type="button" value="<bean:message key="button.refresh"/>" onclick="location.reload();">
	</div>
	<table class="tb_noborder">
		<tr>
			<td width="10pt"></td>
			<td>
				<div id=treeDiv class="treediv"></div>
			</td>
		</tr>
	</table>
	<input type='hidden' id='fdIds'>
</html:form>
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
		if(nodeValue["isShowCheckBox"]!="0"){
			return true;
		}
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
		Category_AuthIds = new KMSSData().AddBeanData("sysCategoryAuthListService&modelName=${param.modelName}").GetHashMapArray();
		generateTree();
	}
	<% } %>
window.onload = Category_OnLoad;
var LKSTree;
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView("LKSTree", "<bean:message key="tree.sysCategoryMain.title" bundle="sys-category"/>", document.getElementById("treeDiv"));
	LKSTree.isShowCheckBox=true;
	LKSTree.isMultSel=true;
	LKSTree.isAutoSelectChildren = false;
	LKSTree.DblClickNode = viewCategory;
	var n1, n2;
	n1 = LKSTree.treeRoot;	
	var modelName = Com_GetUrlParameter(location.href,"modelName");
	n1.authType = "01"
	n2 = n1.AppendCategoryData(modelName,null,0,0);
	LKSTree.Show();
}

function addCategory(){
	var url = "<c:url value="/sys/category/sys_category_main/sysCategoryMain.do" />?method=add";
	var modelName = Com_GetUrlParameter(location.href,"modelName");
	url = Com_SetUrlParameter(url,"fdModelName",modelName);
	var checkedNode = LKSTree.GetCheckedNode();
	if(checkedNode.length>0){
		if(checkedNode[0].nodeType=="CATEGORY_SON"){
			alert("<bean:message key="error.illegalCreateCategory" bundle="sys-category"/>");
			return false;
		}else{
			if(LKSTree.GetCheckedNode().length==1){
				var selectedId = checkedNode[0].value;
				url = Com_SetUrlParameter(url, "parentId", selectedId);
			}else{
				alert("<bean:message key="error.select.message.add" bundle="sys-category"/>");
				return false;
			}
		}
	}
	Com_OpenWindow(url);
}

function editCategory(){
	var url = "<c:url value="/sys/category/sys_category_main/sysCategoryMain.do" />?method=edit&mainModelName=${param.mainModelName}";
	if(List_CheckSelect()){
		if(LKSTree.GetCheckedNode().length==1){
			var selectedId = LKSTree.GetCheckedNode()[0].value;
			url = Com_SetUrlParameter(url, "fdId", selectedId);
			Com_OpenWindow(url);
		}else{
			alert("<bean:message key="error.select.message.edit" bundle="sys-category"/>");
			return false;
		}
	}
}

function viewCategory(id) {
	if(id==null) return false;
	var node = Tree_GetNodeByID(this.treeRoot,id);
	if(node!=null && node.value!=null) {
		var url = "<c:url value="/sys/category/sys_category_main/sysCategoryMain.do" />?method=view&fdId="+node.value;
		Com_OpenWindow(url);
	}
	
}

function deleteCategories(){
	if(!List_ConfirmDel())return;
	var selList = LKSTree.GetCheckedNode();
	for(var i=selList.length-1;i>=0;i--){
		var input = document.createElement("INPUT");
		input.type="text";
		input.style.display="none";
		input.name="List_Selected";	
		input.value = selList[i].value;
		document.sysCategoryMainForm.appendChild(input);	
	}
	Com_Submit(document.sysCategoryMainForm, 'deleteall');	
}

function List_CheckSelect(){
	var obj = document.getElementsByName("List_Selected");
	if(LKSTree.GetCheckedNode().length>0){
		return true;
	}
	alert("<bean:message key="page.noSelect"/>");
	return false;
} 
function List_ConfirmDel(){
	return List_CheckSelect() && confirm("<bean:message key="page.comfirmDelete"/>");
}

function copyCategory(){
	var url = "<c:url value="/sys/category/sys_category_main/sysCategoryMain.do" />?method=copy&fdModelName=${param.modelName}";
	if(List_CheckSelect()){
		if(LKSTree.GetCheckedNode().length==1){
			var selectedId = LKSTree.GetCheckedNode()[0].value;
			url = Com_SetUrlParameter(url, "fdCopyId", selectedId);
			Com_OpenWindow(url);
		}else{
			alert("<bean:message key="error.select.message.edit" bundle="sys-category"/>");
			return false;
		}
	}
}

function updateCateRight(){
	if(!List_CheckSelect()){
		return;
	}
	var selList = LKSTree.GetCheckedNode();
	var c = 0,s="" ;
	for(var i=selList.length-1;i>=0;i--){
		if(c>0){
			s+=",";
		}
		c++;
		s += selList[i].value;
	}
	document.getElementById('fdIds').value = s;
	var url="<c:url value="/sys/right/cchange_cate_right/cchange_cate_right.jsp"/>";
	url+="?method=cChangeCateRight&tmpModelName=${param.modelName}&mainModelName=${param.mainModelName}";
	url+="&templateName=${param.templateName}&categoryName=${param.categoryName}&authReaderNoteFlag=${param.authReaderNoteFlag}";
	//Com_OpenWindow(url);
	window.open(url);
}
</script>

<c:import url="/sys/workflow/include/sysWfTemplate_auditorBtn.jsp" charEncoding="UTF-8">
	<c:param name="fdModelName" value="${param.modelName}"/>
	<c:param name="byCategory" value="true"/>
</c:import>
<c:import url="/sys/authorization/sys_cate_area_change/cate_area_change_button.jsp"
	charEncoding="UTF-8">
	<c:param name="modelName" value="${param.modelName}"/>
	<c:param name="mainModelName" value="${param.mainModelName}"/>
	<c:param name="templateName" value="${param.templateName}"/>
	<c:param name="categoryName" value="${param.categoryName}"/>
</c:import>
<%@ include file="/resource/jsp/edit_down.jsp"%>
