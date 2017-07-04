<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<kmss:windowTitle
	subjectKey="kms-kmaps:table.kmsMapsCategory.view"
	moduleKey="kms-kmaps:table.kmsMaps" />
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
		<kmss:auth requestURL="/kms/kmaps/kms_kmaps_templ_category/kmsKmapsTemplCategory.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('kmsKmapsTemplCategory.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/kmaps/kms_kmaps_templ_category/kmsKmapsTemplCategory.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('kmsKmapsTempCategory.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="kms-kmaps" key="table.kmsKmapsCategory"/></p>
<center> 
	<table class="tb_normal" width="95%">
		<tr><%--类别名称--%> 
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.fdName"/>
			</td>
			<td width=35%>
				<c:out value="${kmsKmapsTemplCategoryForm.fdName}" />
			</td>
			<%--排序号--%>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.fdOrder"/>
			</td>
			<td width=35%>
				<c:out value="${kmsKmapsTemplCategoryForm.fdOrder}" />
			</td>
		</tr>
	 	<%--类别维护者--%>
		<tr>  
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.authEditorIds"/> 
			</td>
			<td width=35% colspan="3">  
				 <c:out value="${kmsKmapsTemplCategoryForm.authEditorNames}" />
			</td> 
		</tr>  
		<%--类别可使用者--%>
		<tr>  
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.authReaderIds"/> 
			</td>
			<td width=35% colspan="3">  
				 <c:out value="${kmsKmapsTemplCategoryForm.authReaderNames}" />
			</td> 
		</tr>  
		<%--默认编辑者--%>
		<tr>  
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.authTmpEditorIds"/> 
			</td>
			<td width=35% colspan="3">  
				 <c:out value="${kmsKmapsTemplCategoryForm.authTmpEditorNames}" />
			</td> 
		</tr> 
		<%--默认阅读者--%>
		<tr>  
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.authTmpReaderIds"/> 
			</td>
			<td width=35% colspan="3">  
				 <c:out value="${kmsKmapsTemplCategoryForm.authTmpReaderNames}" />
			</td> 
		</tr>    
		<tr><%---创建者--%>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.docCreatorId"/>
			</td>
			<td width=35%>
				<c:out value="${kmsKmapsTemplCategoryForm.docCreatorName}" />
			</td>
			<%--创建时间--%>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.docCreateTime"/>
			</td>
			<td width=35%>
				 <c:out value="${kmsKmapsTemplCategoryForm.docCreateTime}" />
			</td> 
		</tr> 
		<tr>
			<%--最后编辑者--%>
			<td class="td_normal_title" width=15%> 
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.docAlterorId"/> 
			</td>
			<td width=35%>
				<c:out value="${kmsKmapsTemplCategoryForm.docAlterorName}" />
			</td>
			<%--最后编辑时间--%>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.docAlterTime"/>
			</td>
			<td width=35%>
				 <c:out value="${kmsKmapsTemplCategoryForm.docAlterTime}" />
			</td>
		</tr>  
	</table>		
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
