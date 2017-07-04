<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/bookmark/sys_bookmark_person_category/sysBookmarkPersonCategory.do">
</html:form>
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
	<script type="text/javascript">Com_IncludeFile("treeview.js");</script>
	<script>
window.onload = generateTree;
var LKSTree;
<%--
	采用树型结构来展现分类的维护界面。
	Com_Parameter.XMLDebug = true;
--%>
function generateTree()
{
	LKSTree = new TreeView("LKSTree", 
		'<bean:message key="cate.tree.root" bundle="sys-bookmark"/>', 
		document.getElementById("treeDiv")
	);
	LKSTree.isShowCheckBox=true;
	LKSTree.isMultSel=true;
	LKSTree.isAutoSelectChildren = false;
	LKSTree.DblClickNode = viewCategory;
	
	var n1;
	n1 = LKSTree.treeRoot;
	n1.AppendBeanData("sysBookmarkCategoryTreeService&parentId=!{value}&type=person");
	
	LKSTree.Show();
}

function addCategory(){
	var url = '<c:url value="/sys/bookmark/sys_bookmark_person_category/sysBookmarkPersonCategory.do" />?method=add';
	var checkedNode = LKSTree.GetCheckedNode();
	if(checkedNode.length > 0){
		if(checkedNode[0].nodeType=="CATEGORY_SON"){
			alert("<bean:message key="error.illegalCreateCategory" bundle="sys-category"/>");
			return false;
		} else {
			var selectedId = checkedNode[0].value;
			url = Com_SetUrlParameter(url, "parentId", selectedId);
		}
	}
	Com_OpenWindow(url);
}

function editCategory(){
	var url = '<c:url value="/sys/bookmark/sys_bookmark_person_category/sysBookmarkPersonCategory.do" />?method=edit';
	if(List_CheckSelect()){
		var selectedId = LKSTree.GetCheckedNode()[0].value;
		url = Com_SetUrlParameter(url, "fdId", selectedId);
		Com_OpenWindow(url);
	}
}

function viewCategory(id) {
	if(id==null) return false;
	var node = Tree_GetNodeByID(this.treeRoot,id);
	if(node!=null && node.value!=null) {
		var url = '<c:url value="/sys/bookmark/sys_bookmark_person_category/sysBookmarkPersonCategory.do" />?method=view';
		url = Com_SetUrlParameter(url, "fdId", node.value);
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
		document.sysBookmarkPersonCategoryForm.appendChild(input);	
	}
	Com_Submit(document.sysBookmarkPersonCategoryForm, 'deleteall');	
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
</script>

<%@ include file="/resource/jsp/edit_down.jsp"%>
