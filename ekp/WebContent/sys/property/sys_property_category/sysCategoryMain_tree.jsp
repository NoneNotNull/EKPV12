<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page import="com.landray.kmss.sys.simplecategory.interfaces.SimpleCategoryUtil" %>
<html:form action="${param.actionUrl}">
	<div id="optBarDiv">
		<input type="button" value="<bean:message key="button.add"/>" onclick="addCategory();" />
		<input type="button" value="<bean:message key="button.edit"/>" onclick="editCategory();" />
		<input type="button" value="<bean:message key="button.delete"/>" onclick="deleteCategories();" />
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
</html:form>
	<script type="text/javascript">Com_IncludeFile("treeview.js");</script>
	<script>
	<%
	    String modelName = request.getParameter("modelName");
	    if (StringUtil.isNotNull(modelName)
			&& SimpleCategoryUtil.isAdmin(modelName)) {
	%>
	function SimpleCategory_OnLoad() { 
		generateTree();
	}
	<%  } else {%>
	function NodeFunc_FetchChildrenByXML(){
		var nodesValue = new KMSSData().AddXMLData(Com_ReplaceParameter(this.XMLDataInfo.beanURL, this)).GetHashMapArray();
		for(var i=0; i<nodesValue.length; i++){
			if(SimpleCategory_CheckAuth(nodesValue[i]))
				this.FetchChildrenUseXMLNode(nodesValue[i]);
		}
	}
	function SimpleCategory_CheckAuth(nodeValue){
		if(nodeValue["isShowCheckBox"]!="0"){
			return true;
		}
		var value = nodeValue["value"];
		for(var i=0; i<SimpleCategory_AuthIds.length; i++){
			if(SimpleCategory_AuthIds[i]["v"]==value){
				return true;
			}
		}
		return false;
	}
	var SimpleCategory_AuthIds;
	function SimpleCategory_OnLoad() { // 过滤没权限或者没有模板的分类节点
		SimpleCategory_AuthIds = new KMSSData().AddBeanData("sysSimpleCategoryAuthList&modelName=${param.modelName}&authType=01").GetHashMapArray();
		generateTree();
	}
	<% } %>
window.onload = SimpleCategory_OnLoad;
var LKSTree;
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView("LKSTree", "<bean:message key="tree.sysSimpleCategory.title" bundle="sys-simplecategory"/>", document.getElementById("treeDiv"));
	LKSTree.isShowCheckBox=true;
	LKSTree.isMultSel=true;
	LKSTree.isAutoSelectChildren = false;
	//LKSTree.DblClickNode = viewCategory;
	var n1, n2;
	n1 = LKSTree.treeRoot;	
	var modelName = "${param.modelName}";
	n1.authType = "01"
	n2 = n1.AppendSimpleCategoryData(modelName);
	LKSTree.Show();
}

function addCategory(){
	var url = "<c:url value="${param.actionUrl}" />?method=add";
	var modelName ="${param.modelName}";
	url = Com_SetUrlParameter(url,"fdModelName",modelName);
	var checkedNode = LKSTree.GetCheckedNode();
	if(checkedNode.length>0){
		if(LKSTree.GetCheckedNode().length==1){
			var selectedId = checkedNode[0].value;
			url = Com_SetUrlParameter(url, "parentId", selectedId);
		}else{
			alert("<bean:message key="error.select.message.add" bundle="sys-simplecategory"/>");
			return false;
		}
	}
	Com_OpenWindow(url);
}

function editCategory(){
	var url = "<c:url value="${param.actionUrl}" />?method=edit";
	var modelName = "${param.modelName}";
	url = Com_SetUrlParameter(url,"fdModelName",modelName);
	if(List_CheckSelect()){
		if(LKSTree.GetCheckedNode().length==1){
			var selectedId = LKSTree.GetCheckedNode()[0].value;
			url = Com_SetUrlParameter(url, "fdId", selectedId);
			Com_OpenWindow(url);
		}else{
			alert("<bean:message key="error.select.message.edit" bundle="sys-simplecategory"/>");
			return false;
		}
	}
}

function viewCategory(id) {
	if(id==null) return false;
	var node = Tree_GetNodeByID(this.treeRoot,id);
	if(node!=null && node.value!=null) {
		var url = "<c:url value="${param.actionUrl}" />?method=view&fdModelName=${param.modelName}&fdId="+node.value;
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
		document.${param.formName}.appendChild(input);	
	}
	Com_Submit(document.${param.formName}, 'deleteall');	
}

function updateCateRight(){
	if(!List_CheckSelect()){
		return;
	}
	var selList = LKSTree.GetCheckedNode();
	var c = 0,s="" ;
	for(var i=selList.length-1;i>=0;i--){
		if(c>0){
			s+=";";
		}
		c++;
		s += selList[i].value;
	}
	var url="<c:url value="/sys/right/rightCateChange.do"/>";
	url+="?method=cateRightEdit&cateModelName=${param.modelName}&modelName=${param.mainModelName}";
	<c:if test="${not empty param.authReaderNoteFlag}">
	url+="&authReaderNoteFlag=${param.authReaderNoteFlag}";
	</c:if>
	url+="&fdIds="+s+"&docFkName=${param.docFkName}";
	Com_OpenWindow(url);
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
	var url = "<c:url value="${param.actionUrl}" />?method=copy";
	var modelName = "${param.modelName}";
	url = Com_SetUrlParameter(url,"fdModelName",modelName);
	if(List_CheckSelect()){
		if(LKSTree.GetCheckedNode().length==1){
			var selectedId = LKSTree.GetCheckedNode()[0].value;
			url = Com_SetUrlParameter(url, "fdCopyId", selectedId);
			Com_OpenWindow(url);
		}else{
			alert("<bean:message key="error.select.message.copy" bundle="sys-simplecategory"/>");
			return false;
		}
	}
}
</script>

<c:import url="/sys/workflow/include/sysWfTemplate_auditorBtn.jsp" charEncoding="UTF-8">
	<c:param name="fdModelName" value="${param.modelName}"/>
	<c:param name="isCategory" value="true"/>
</c:import>
<c:import url="/sys/authorization/sys_cate_area_change/cate_area_change_button.jsp"
	charEncoding="UTF-8">
	<c:param name="modelName" value="${param.modelName}"/>
	<c:param name="mainModelName" value="${param.mainModelName}"/>
	<c:param name="docFkName" value="${param.docFkName}"/>
</c:import>
<%@ include file="/resource/jsp/edit_down.jsp"%>
