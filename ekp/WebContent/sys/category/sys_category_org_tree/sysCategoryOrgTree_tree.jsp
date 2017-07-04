<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/category/sys_category_org_tree/sysCategoryOrgTree.do">
	<div id="optBarDiv">
		<input type="button" value="<bean:message key="button.add"/>" onclick="addCategory();" />
		<input type="button" value="<bean:message key="button.edit"/>" onclick="editCategory();" />
		<input type="button" value="<bean:message key="button.delete"/>" onclick="deleteCategories();" />
		<input type="button" value="<bean:message key="button.copy"/>" onclick="copyCategory();" />
		<input type="button" value="<bean:message key="button.refresh"/>" onclick="location.reload();;">
	</div>
	<table class="tb_noborder">
		<tr>
			<td width="10pt"></td>
			<td>
				<div id=treeDiv class="treediv"></div>
			</td>
		</tr>
	</table>
	<script type="text/javascript">Com_IncludeFile("treeview.js");</script>
	<script>
window.onload = generateTree;
var LKSTree;
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView("LKSTree", "<bean:message key="tree.sysCategoryOrgTree.title" bundle="sys-category"/>", document.getElementById("treeDiv"));
	LKSTree.isShowCheckBox=true;
	LKSTree.isMultSel=false;
	LKSTree.isAutoSelectChildren = false;
	LKSTree.DblClickNode = viewCategory;
	var n1, n2;
	n1 = LKSTree.treeRoot;
	n1.authType="01";
	n2 = n1.AppendOrgTreeData();
	LKSTree.Show();
}


function addCategory(){
	var url = "<c:url value="/sys/category/sys_category_org_tree/sysCategoryOrgTree.do" />?method=add";
	if(LKSTree.GetCheckedNode() != null){
		var selectedId = LKSTree.GetCheckedNode().value;
		var selectedName = LKSTree.GetCheckedNode().text;
		url = Com_SetUrlParameter(url, "parentId", selectedId);
	}
	Com_OpenWindow(url);
}

function editCategory(){
	var url = "<c:url value="/sys/category/sys_category_org_tree/sysCategoryOrgTree.do" />?method=edit";
	if(List_CheckSelect()){
		var selectedId = LKSTree.GetCheckedNode().value;
		url = Com_SetUrlParameter(url, "fdId", selectedId);
		Com_OpenWindow(url);
	}
}

function deleteCategories(){
	if(!List_ConfirmDel())return;
	var input = document.createElement("INPUT");
	input.type="text";
	input.style.display="none";
	input.name="List_Selected";
	input.value=LKSTree.GetCheckedNode().value
	document.sysCategoryOrgTreeForm.appendChild(input);
	Com_Submit(document.sysCategoryOrgTreeForm, 'deleteall');	
}

function viewCategory(id) {
	if(id==null) return false;
	var node = Tree_GetNodeByID(this.treeRoot,id);
	if(node!=null && node.value!=null) {
		var url = "<c:url value="/sys/category/sys_category_org_tree/sysCategoryOrgTree.do" />?method=view&fdId="+node.value;
		Com_OpenWindow(url);
	}
	
}
function List_CheckSelect(){
	var obj = document.getElementsByName("List_Selected");
	if(LKSTree.GetCheckedNode() != null){
		return true;
	}
	alert("<bean:message key="page.noSelect"/>");
	return false;
}
function List_ConfirmDel(){
	return List_CheckSelect() && confirm("<bean:message key="page.comfirmDelete"/>");
}

function copyCategory(){
	var url = "<c:url value="/sys/category/sys_category_org_tree/sysCategoryOrgTree.do" />?method=copy";
	if(List_CheckSelect()){
		var selectedId = LKSTree.GetCheckedNode().value;
		url = Com_SetUrlParameter(url, "fdId", selectedId);
		Com_OpenWindow(url);
	}
}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
