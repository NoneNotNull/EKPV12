<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/property/sys_property_tree/sysPropertyTree.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/property/sys_property_tree/sysPropertyTree.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>" onclick="addCategory();" />
		</kmss:auth>
		<kmss:auth requestURL="/sys/property/sys_property_tree/sysPropertyTree.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button" value="<bean:message key="button.edit"/>" onclick="editCategory();" />
		</kmss:auth>
		<kmss:auth requestURL="/sys/property/sys_property_tree/sysPropertyTree.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>" onclick="deleteCategories();" />
		</kmss:auth>
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
function generateTree() {
	LKSTree = new TreeView("LKSTree", "${param.fdName}", document.getElementById("treeDiv"));
	LKSTree.isShowCheckBox=true;
	LKSTree.isMultSel=true;
	LKSTree.isAutoSelectChildren = false;
	LKSTree.DblClickNode = viewCategory;
	var n1, n2;
	n1 = LKSTree.treeRoot;	
	n2 = n1.AppendBeanData("sysPropertyTreeListService&parentId=!{value}&treeRootId=${param.fdId}");
	LKSTree.Show();
}
function addCategory(){
	var url = '<c:url value="/sys/property/sys_property_tree/sysPropertyTree.do" />?method=add&treeRootId=${param.fdId}';
	var checkedNode = LKSTree.GetCheckedNode();
	if(checkedNode.length>0){
		if(LKSTree.GetCheckedNode().length==1){
			var selectedId = checkedNode[0].value;
			url = Com_SetUrlParameter(url, "parentId", selectedId);
		}else{
			alert('<bean:message key="error.select.message.add" bundle="sys-property"/>');
			return false;
		}
	}
	Com_OpenWindow(url);
}
function editCategory(){
	var url = '<c:url value="/sys/property/sys_property_tree/sysPropertyTree.do" />?method=edit&treeRootId=${param.fdId}';
	if(List_CheckSelect()){
		if(LKSTree.GetCheckedNode().length==1){
			var selectedId = LKSTree.GetCheckedNode()[0].value;
			url = Com_SetUrlParameter(url, "fdId", selectedId);
			Com_OpenWindow(url);
		}else{
			alert('<bean:message key="error.select.message.edit" bundle="sys-property"/>');
			return false;
		}
	}
}
function viewCategory(id) {
	if(id==null) return false;
	var node = Tree_GetNodeByID(this.treeRoot,id);
	if(node!=null && node.value!=null) {
		var url = '<c:url value="/sys/property/sys_property_tree/sysPropertyTree.do" />?method=view&fdId='+node.value;
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
		document.sysPropertyTreeForm.appendChild(input);	
	}
	Com_Submit(document.sysPropertyTreeForm, 'deleteall');	
}
function List_CheckSelect(){
	var obj = document.getElementsByName("List_Selected");
	if(LKSTree.GetCheckedNode().length>0){
		return true;
	}
	alert('<bean:message key="page.noSelect"/>');
	return false;
}
function List_ConfirmDel(){
	return List_CheckSelect() && confirm('<bean:message key="page.comfirmDelete"/>');
}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
