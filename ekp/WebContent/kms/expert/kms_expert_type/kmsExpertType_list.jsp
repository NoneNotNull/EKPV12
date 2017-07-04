<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/expert/kms_expert_type/kmsExpertType.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/expert/kms_expert_type/kmsExpertType.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/expert/kms_expert_type/kmsExpertType.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/expert/kms_expert_type/kmsExpertType.do?method=edit" requestMethod="GET">
			<input type="button" value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/expert/kms_expert_type/kmsExpertType.do" />?method=edit');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/expert/kms_expert_type/kmsExpertType.do?method=delete" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/expert/kms_expert_type/kmsExpertType.do" />?method=delete');">
		</kmss:auth>
		<input type="button" value="<bean:message key="button.refresh"/>" onclick="location.reload();">
		<!--
			<input type="button" value="<bean:message key="button.add"/>" onclick="addCategory();" />
			<input type="button" value="<bean:message key="button.edit"/>" onclick="editCategory();" />
			<input type="button" value="<bean:message key="button.delete"/>" onclick="deleteCategories();" />
			<input type="button" value="<bean:message key="button.refresh"/>" onclick="location.reload();">
		-->
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
		LKSTree.isShowCheckBox=true;
		LKSTree.isMultSel=true;
		var n1,n2,n3,n4,n5;
		n1 = LKSTree.treeRoot;
		n1.AppendBeanData("kmsExpertTypeTreeService",null,null,false);
		LKSTree.Show();
	}
</script>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
