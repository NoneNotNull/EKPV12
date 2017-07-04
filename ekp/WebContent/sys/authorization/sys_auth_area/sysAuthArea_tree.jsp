<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/authorization/sys_auth_area/sysAuthArea.do">
	<div id="optBarDiv">
		<input type="button" value="<bean:message key="button.add"/>" onclick="addAuthArea();" />
		<input type="button" value="<bean:message key="button.edit"/>" onclick="editAuthArea();" />
		<!-- 
		<input type="button" value="<bean:message key="button.delete"/>" onclick="deleteAuthAreas();" />
		 -->
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
	
	<script type="text/javascript">Com_IncludeFile("treeview.js");Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");</script>
	<script type="text/javascript">
window.onload = generateTree;
var LKSTree;
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView("LKSTree", "<bean:message bundle="sys-authorization" key="table.sysAuthArea" />", document.getElementById("treeDiv"));
	LKSTree.isShowCheckBox=true;
	LKSTree.isMultSel=false;
	//LKSTree.isAutoSelectChildren = false;
	//LKSTree.DblClickNode = viewAuthArea;
	var n1, n2;
	n1 = LKSTree.treeRoot;	
	var modelName = Com_GetUrlParameter(location.href,"modelName");
	n1.authType = "01";
	n2 = n1.AppendBeanData("sysAuthAreaTreeService&parentId=!{value}&modelName="+modelName);

	LKSTree.Show();
}

function addAuthArea(){
	var url = "<c:url value="/sys/authorization/sys_auth_area/sysAuthArea.do" />?method=add";
	var modelName = Com_GetUrlParameter(location.href,"modelName");
	url = Com_SetUrlParameter(url,"fdModelName",modelName);
	var checkedNode = LKSTree.GetCheckedNode();
	if(checkedNode != null){
		var selectedId = checkedNode.value;
		url = Com_SetUrlParameter(url, "parentId", selectedId);
	}
	Com_OpenWindow(url);
}

function editAuthArea(){
	var url = "<c:url value="/sys/authorization/sys_auth_area/sysAuthArea.do" />?method=edit&mainModelName=${param.mainModelName}";
	if(List_CheckSelect()){
		var selectedId = LKSTree.GetCheckedNode().value;
		url = Com_SetUrlParameter(url, "fdId", selectedId);
		Com_OpenWindow(url);
	}
}

function viewAuthArea(id) {
	if(id==null) return false;
	var node = Tree_GetNodeByID(this.treeRoot,id);
	if(node!=null && node.value!=null) {
		var url = "<c:url value="/sys/authorization/sys_auth_area/sysAuthArea.do" />?method=view&fdId="+node.value;
		Com_OpenWindow(url);
	}
}

function deleteAuthAreas(){
	if(!List_ConfirmDel())return;
	var selList = LKSTree.GetCheckedNode();
	var input = document.createElement("INPUT");
	input.type="text";
	input.style.display="none";
	input.name="List_Selected";	
	input.value = selList[i].value;
	document.sysAuthAreaForm.appendChild(input);	
	Com_Submit(document.sysAuthAreaForm, 'deleteall');	
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
/*
function addAuthArea(){
	var url = "<c:url value="/sys/authorization/sys_auth_area/sysAuthArea.do" />?method=add";
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

function editAuthArea(){
	var url = "<c:url value="/sys/authorization/sys_auth_area/sysAuthArea.do" />?method=edit&mainModelName=${param.mainModelName}";
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

function viewAuthArea(id) {
	if(id==null) return false;
	var node = Tree_GetNodeByID(this.treeRoot,id);
	if(node!=null && node.value!=null) {
		var url = "<c:url value="/sys/authorization/sys_auth_area/sysAuthArea.do" />?method=view&fdId="+node.value;
		Com_OpenWindow(url);
	}
	
}

function deleteAuthAreas(){
	if(!List_ConfirmDel())return;
	var selList = LKSTree.GetCheckedNode();
	for(var i=selList.length-1;i>=0;i--){
		var input = document.createElement("INPUT");
		input.type="text";
		input.style.display="none";
		input.name="List_Selected";	
		input.value = selList[i].value;
		document.sysAuthAreaForm.appendChild(input);	
	}
	Com_Submit(document.sysAuthAreaForm, 'deleteall');	
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
*/
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
