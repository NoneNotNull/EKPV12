<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="${param.actionUrl}">
	<div id="optBarDiv">
		<input type="button" value="<bean:message key="button.add"/>" onclick="addCategory();" />
		<input type="button" value="<bean:message key="button.edit"/>" onclick="editCategory();" />
		<input type="button" value="<bean:message key="button.delete"/>" onclick="deleteCategories();" />
		<input type="button" value="<bean:message key="button.refresh"/>" onclick="history.go(0);">
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
	LKSTree = new TreeView("LKSTree", 
			"<bean:message key="tree.sysSimpleCategory.title" bundle="sys-simplecategory"/>",
			document.getElementById("treeDiv"));
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
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
