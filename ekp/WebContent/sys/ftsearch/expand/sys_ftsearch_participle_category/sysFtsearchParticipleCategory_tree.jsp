<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/ftsearch/expand/sys_ftsearch_participle_category/sysFtsearchParticipleCategory.do">
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_participle_category/sysFtsearchParticipleCategory.do?model=com.landray.kmss.sys.ftsearch.expand.model.SysFtsearchParticipleCategory">
	<input type="button" value="<bean:message key="button.add"/>" onclick="addCategory();" />
	<input type="button" value="<bean:message key="button.edit"/>" onclick="editCategory();" />
	<input type="button" value="<bean:message key="button.delete"/>" onclick="deleteCategory();" />
	</kmss:auth>
	<input type="button" value="<bean:message key="button.refresh"/>" onclick="history.go(0);" />
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
<%--
	采用树型结构来展现分类的维护界面。
--%>
<script type="text/javascript">
Com_IncludeFile("treeview.js");
window.onload = generateTree;
var LKSTree;
<%-- Com_Parameter.XMLDebug = true; --%>
function generateTree() {
	LKSTree = new TreeView("LKSTree", 
		'搜索设置', 
		document.getElementById("treeDiv")
	);
	
	LKSTree.isShowCheckBox = true;
	LKSTree.isMultSel = true;//是否多选
	LKSTree.isAutoSelectChildren = false;
	LKSTree.DblClickNode = viewCategory;

	var n1;
	n1 = LKSTree.treeRoot;
	n1.AppendBeanData("sysFtsearchParticipleCategoryTreeService&parentId=!{value}",null,null,null);
	
	LKSTree.Show();
}
function addCategory() {
	var url = '<c:url value="/sys/ftsearch/expand/sys_ftsearch_participle_category/sysFtsearchParticipleCategory.do" />?method=add';
	var checkedNode = LKSTree.GetCheckedNode();
	if(List_CheckSelectMore()){
	if (checkedNode.length>0){
		if (checkedNode.nodeType=="CATEGORY_SON"){
			alert('<bean:message key="error.illegalCreateCategory" bundle="sys-category"/>');
			return false;
		} else {
			var selectedId = checkedNode[0].value;
			url = Com_SetUrlParameter(url, "parentId", selectedId);
		}
	}
	Com_OpenWindow(url);
	}
	
}
function editCategory() {
	var url = '<c:url value="/sys/ftsearch/expand/sys_ftsearch_participle_category/sysFtsearchParticipleCategory.do" />?method=edit';
	if (List_CheckSelect() && List_CheckSelectMore()){
		var checkedNode = LKSTree.GetCheckedNode();
		var selectedId = LKSTree.GetCheckedNode()[0].value;
		url = Com_SetUrlParameter(url, "fdId", selectedId);
		Com_OpenWindow(url);
	}
}	
	
function deleteCategory() {
	if (!List_ConfirmDel()) return;
	var selList = LKSTree.GetCheckedNode();
	for(var i=selList.length-1;i>=0;i--){
		var input = document.createElement("INPUT");
		input.type = "text";
		input.style.display = "none";
		input.name = "List_Selected";	
		input.value = selList[i].value;
		document.sysFtsearchParticipleCategoryForm.appendChild(input);
	}
	Com_Submit(document.sysFtsearchParticipleCategoryForm, 'deleteall');
}

function viewCategory(id) {
	if (id == null) return false;
	var node = Tree_GetNodeByID(this.treeRoot, id);
	if (node != null && node.value != null) {
		var url = '<c:url value="/sys/ftsearch/expand/sys_ftsearch_participle_category/sysFtsearchParticipleCategory.do" />?method=view';
		url = Com_SetUrlParameter(url, "fdId", node.value);
		Com_OpenWindow(url);
	}
}

function List_CheckSelect(){
	if (LKSTree.GetCheckedNode().length > 0) {
		return true;
	}
	alert('对不起，您只能选择一个进行操作！');
	return false;
}

function List_CheckSelectMore(){
	if (LKSTree.GetCheckedNode().length < 2) {
		return true;
	}
	alert('对不起，您只能选择一个进行操作！');
	return false;
}

function List_ConfirmDel() {
	return List_CheckSelect() && confirm('<bean:message key="page.comfirmDelete"/>');
}
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>