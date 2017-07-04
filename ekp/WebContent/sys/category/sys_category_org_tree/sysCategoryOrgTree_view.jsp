<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv"><kmss:auth
	requestURL="/sys/category/sys_category_org_tree/sysCategoryOrgTree.do?method=edit&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('sysCategoryOrgTree.do?method=edit&fdId=${param.fdId}','_self');">
</kmss:auth> <kmss:auth
	requestURL="/sys/category/sys_category_org_tree/sysCategoryOrgTree.do?method=delete&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('sysCategoryOrgTree.do?method=delete&fdId=${param.fdId}','_self');">
</kmss:auth> <input type="button" value="<bean:message key="button.close"/>"
	onclick="Com_CloseWindow();"></div>
<p class="txttitle"><bean:message bundle="sys-category"
	key="table.sysCategoryOrgTree" /></p>
<center>
<table class="tb_normal" width=95%>
	<html:hidden name="sysCategoryOrgTreeForm" property="fdId" />
		<tr>
			<td class="td_normal_title" width=15%><bean:message
					bundle="sys-category" key="sysCategoryOrgTree.fdParentName" /></td>
			<td colspan="3"><bean:write name="sysCategoryOrgTreeForm" property="fdParentName"/></td>
		</tr>
		<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="sys-category" key="sysCategoryOrgTree.fdName" /></td>
				<td colspan="3"><bean:write name="sysCategoryOrgTreeForm" property="fdName"/></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-category" key="sysCategoryOrgTree.fdOrgName" /></td>
			<td colspan="3"><bean:write name="sysCategoryOrgTreeForm" property="fdOrgNames"/></a>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdOrder" /></td>
			<td colspan="3"><bean:write name="sysCategoryOrgTreeForm" property="fdOrder"/></td>
		</tr>			
			<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.tempEditorName" /></td>
			<td colspan="3"><bean:write name="sysCategoryOrgTreeForm" property="authEditorNames"/></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.tempReaderName" /></td>
			<td colspan="3"><bean:write name="sysCategoryOrgTreeForm" property="authReaderNames"/></td>
		</tr>
		<tr  style="display:none">
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-category" key="sysCategory.fdIsinheritMaintainer" /></td>
			<td width=35%>
			<sunbor:enumsShow value="${sysCategoryOrgTreeForm.fdIsinheritMaintainer}" enumsType="common_yesno" />
			</td>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-category" key="sysCategory.fdIsinheritUser" /></td>
			<td width=35%>
			<sunbor:enumsShow value="${sysCategoryOrgTreeForm.fdIsinheritUser}" enumsType="common_yesno" />
			</td>			
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdCreator" /></td>
			<td width=35%><bean:write name="sysCategoryOrgTreeForm" property="docCreatorName"/></td>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdCreateTime" /></td>
			<td width=35%><bean:write name="sysCategoryOrgTreeForm" property="docCreateTime"/></td>			
		</tr>
		<c:if test="${sysCategoryOrgTreeForm.docAlterorName!=''}">
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.docAlteror" /></td>
			<td width=35%><bean:write name="sysCategoryOrgTreeForm" property="docAlterorName"/></td>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdAlterTime" /></td>
			<td width=35%><bean:write name="sysCategoryOrgTreeForm" property="docAlterTime"/></td>
		</tr>
		</c:if>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
