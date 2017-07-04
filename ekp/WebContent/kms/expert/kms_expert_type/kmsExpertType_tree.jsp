<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/expert/kms_expert_type/kmsExpertType.do">
	<div id="optBarDiv">
		<kmss:authShow roles="ROLE_KMSEXPERTTYPE_ADMIN">
			<input type="button" value="<bean:message key="button.add"/>" onclick="addExpertType();" />
			<input type="button" value="<bean:message key="button.edit"/>" onclick="editExpertType();" />
			<input type="button" value="<bean:message key="button.delete"/>" onclick="deleteExpertType();" />
		</kmss:authShow>
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
	function generateTree(){
		LKSTree = new TreeView("LKSTree","<bean:message key="tree.kmsExpertTepy.title" bundle="kms-expert"/>",document.getElementById("treeDiv"));
		LKSTree.isShowCheckBox=false;
		LKSTree.isMultSel=false;
		LKSTree.isAutoSelectChildren = false;
		var n1,n2;
		n1 = LKSTree.treeRoot;
		n2 = n1.AppendBeanData("kmsExpertTypeTreeService&expertTypeId=!{value}", null, setNodeSelected);
		LKSTree.Show();
	}

function setNodeSelected(){
}

function addExpertType(){
	var url = "<c:url value="/kms/expert/kms_expert_type/kmsExpertType.do" />?method=add";
	if(LKSTree.GetCurrentNode() != null){
		var selectedId = LKSTree.GetCurrentNode().value;
		var selectedName = LKSTree.GetCurrentNode().text;
		url = Com_SetUrlParameter(url, "parentId", selectedId);
		url = Com_SetUrlParameter(url, "parentName", selectedName);
	}
	
	//如果有知识互助的爱问就显示 只允许领域专家作答
	url = Com_SetUrlParameter(url,"answer",${param.answer});
	Com_OpenWindow(url);
}

function editExpertType(){
	var url = "<c:url value="/kms/expert/kms_expert_type/kmsExpertType.do" />?method=edit";
	if(LKSTree.GetCurrentNode() == null){
		alert("<bean:message bundle="kms-expert" key="error.unSelectedRecord.edit"/>");
		return;
	}
	var selectedId = LKSTree.GetCurrentNode().value;
	url = Com_SetUrlParameter(url, "fdId", selectedId);
	
	//如果有知识互助的爱问就显示 只允许领域专家作答
	url = Com_SetUrlParameter(url,"answer",${param.answer});
	Com_OpenWindow(url);
}

function deleteExpertType(){
	if(!List_ConfirmDel())return;
	var url = "<c:url value="/kms/expert/kms_expert_type/kmsExpertType.do" />?method=delete";
	if(LKSTree.GetCurrentNode() != null){
		var selectedId = LKSTree.GetCurrentNode().value;
		url = Com_SetUrlParameter(url, "fdId", selectedId);
	}
	Com_OpenWindow(url, '_blank');
	window.location.reload();
}

function List_CheckSelect(){
	var obj = document.getElementsByName("List_Selected");
	if(LKSTree.GetCurrentNode() != null){
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
