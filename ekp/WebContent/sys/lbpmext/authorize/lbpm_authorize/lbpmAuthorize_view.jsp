<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
		<kmss:auth requestURL="/sys/lbpmext/authorize/lbpm_authorize/lbpmAuthorize.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('lbpmAuthorize.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/lbpmext/authorize/lbpm_authorize/lbpmAuthorize.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button" 
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('lbpmAuthorize.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<kmss:windowTitle 
	moduleKey="sys-lbpmext-authorize:table.lbpmAuthorize"/>
<p class="txttitle"><bean:message  bundle="sys-lbpmext-authorize" key="table.lbpmAuthorize"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="lbpmAuthorizeForm" property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdAuthorizeType"/>
		</td><td width=35%>
			<sunbor:enumsShow value="${lbpmAuthorizeForm.fdAuthorizeType}" enumsType="lbpmAuthorize_authorizeType" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdAuthorizer"/>
		</td><td width=35%>
			${lbpmAuthorizeForm.fdAuthorizerName }
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorizeItem.fdAuthorizeOrgId"/>
		</td><td width=35%>
			${lbpmAuthorizeForm.fdLbpmAuthorizeItemNames}
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdAuthorizedPerson"/>
		</td><td width=35%>
			${lbpmAuthorizeForm.fdAuthorizedPersonName}
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.lbpmAuthorizeScope"/>
		</td><td width=85% colspan=3>
			<textarea style="width:90%" readonly>${lbpmAuthorizeForm.fdScopeFormAuthorizeCateShowtexts}</textarea>
		</td>
	</tr>
	<c:if test="${lbpmAuthorizeForm.fdAuthorizeType != 1}">
		<tr id="processTypeRow">
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.authorizationTitle"/>
			</td><td width=85% colspan=3>
				<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.authorizationTitle.from"/>${lbpmAuthorizeForm.fdStartTime}
				<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.authorizationTitle.to"/>${lbpmAuthorizeForm.fdEndTime}
				<br>
				
				<input type="checkbox" 
				<c:if test="${lbpmAuthorizeForm.fdExpireDeleted=='true'}">
				checked
				</c:if>
				disabled="true"><bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdExpireDeleted"/>
			</td>
		</tr>
	</c:if>
	<tr>
		<td class="td_normal_title" width=15%> 
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdCreator"/>
		</td><td width=35%>
			${lbpmAuthorizeForm.fdCreatorName} 
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdCreateTime"/>
		</td><td width=35%>
			${lbpmAuthorizeForm.fdCreateTime} 
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>