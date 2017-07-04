<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@ page import="com.landray.kmss.sys.authorization.interfaces.SysAuthAreaUtils"%>
<%@ page import="com.landray.kmss.sys.category.forms.SysCategoryMainForm"%>
<%
String fdModelName = "";
Object obj = request.getAttribute("sysCategoryMainForm");
if(obj != null) {
	SysCategoryMainForm form = (SysCategoryMainForm)obj;
	fdModelName = form.getFdModelName();	
}
%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv"><kmss:auth
	requestURL="/sys/category/sys_category_main/sysCategoryMain.do?method=edit&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('sysCategoryMain.do?method=edit&fdId=${param.fdId}','_self');">
</kmss:auth> <kmss:auth
	requestURL="/sys/category/sys_category_main/sysCategoryMain.do?method=delete&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('sysCategoryMain.do?method=delete&fdId=${param.fdId}','_self');">
</kmss:auth> <input type="button" value="<bean:message key="button.close"/>"
	onclick="Com_CloseWindow();"></div>
<p class="txttitle"><bean:message bundle="sys-category"
	key="table.sysCategoryMain" /></p>
<center>
	<table class="tb_normal" width=95%>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-category" key="sysCategoryMain.fdParentName" /></td>
			<td colspan="3"><bean:write name="sysCategoryMainForm" property="fdParentName"/></td>
		</tr>		
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-category" key="sysCategoryMain.fdName" /></td>
			<td colspan="3"><bean:write name="sysCategoryMainForm" property="fdName"/></td>
		</tr>
		<% if(SysAuthAreaUtils.isAreaEnabled(fdModelName)	){ %>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-category" key="sysCategoryMain.fdOrgTreeName" /></td>
			<td width=35%>
				<c:out value="${sysCategoryMainForm.authAreaName}" />
			</td>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdOrder" /></td>
			<td width=35%><bean:write name="sysCategoryMainForm" property="fdOrder"/></td>
		</tr>		
		<% } else { %>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdOrder" /></td>
			<td colspan="3"><bean:write name="sysCategoryMainForm" property="fdOrder"/></td>
		</tr>		
		<% } %>

		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.tempEditorName" /></td>
			<td colspan="3"><bean:write name="sysCategoryMainForm" property="authEditorNames"/></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.tempReaderName" /></td>
			<td colspan="3"><bean:write name="sysCategoryMainForm" property="authReaderNames"/></td>
		</tr>
		<tr style="display:none">
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-category" key="sysCategory.fdIsinheritMaintainer" /></td>
			<td width=35%>
			<sunbor:enumsShow value="${sysCategoryMainForm.fdIsinheritMaintainer}" enumsType="common_yesno" />
			</td>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-category" key="sysCategory.fdIsinheritUser" /></td>
			<td width=35%>
			<sunbor:enumsShow value="${sysCategoryMainForm.fdIsinheritUser}" enumsType="common_yesno" />
			</td>			
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdCreator" /></td>
			<td width=35%><bean:write name="sysCategoryMainForm" property="docCreatorName"/></td>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdCreateTime" /></td>
			<td width=35%><bean:write name="sysCategoryMainForm" property="docCreateTime"/></td>			
		</tr>
		<c:if test="${sysCategoryMainForm.docAlterorName!=''}">
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.docAlteror" /></td>
			<td width=35%><bean:write name="sysCategoryMainForm" property="docAlterorName"/></td>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdAlterTime" /></td>
			<td width=35%><bean:write name="sysCategoryMainForm" property="docAlterTime"/></td>
		</tr>
		</c:if>
	</table>
	</center>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
