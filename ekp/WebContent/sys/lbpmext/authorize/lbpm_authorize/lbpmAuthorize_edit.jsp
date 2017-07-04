<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/sys/lbpmext/authorize/lbpm_authorize/lbpmAuthorize_script.jsp"%>
<html:form action="/sys/lbpmext/authorize/lbpm_authorize/lbpmAuthorize.do" onsubmit="return validateLbpmAuthorizeForm(this);">
<%
	String currentUserId = UserUtil.getUser().getFdId();
	pageContext.setAttribute("currentUserId", currentUserId);
%>
<div id="optBarDiv"> 
	<c:if test="${lbpmAuthorizeForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="validateSubmitForm('update');">
	</c:if>
	<c:if test="${lbpmAuthorizeForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="validateSubmitForm('save');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<kmss:windowTitle 
	moduleKey="sys-lbpmext-authorize:table.lbpmAuthorize"/>

<p class="txttitle"><bean:message  bundle="sys-lbpmext-authorize" key="table.lbpmAuthorize"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
		<html:hidden property="currentUserRoleIds"/>	
		<html:hidden property="currentUserRoleNames"/>
		<html:hidden property="fdLbpmAuthorizeItemIds"/>	
		<html:hidden property="fdLbpmAuthorizeItemNames"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdAuthorizeType"/>
		</td>
		<td width=35%>
			<xform:radio property="fdAuthorizeType" htmlElementProperties="onClick=authorizeTypeChanged(this);">
				<xform:enumsDataSource enumsType="lbpmAuthorize_authorizeType"/>
			</xform:radio>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdAuthorizer"/>
		</td>
		<td width=35%>
			<c:if test="${lbpmAuthorizeForm.canChangeAuthorizerAuth != 'true'}">
				<html:hidden property="fdAuthorizerId"/>
				<xform:text property="fdAuthorizerName" showStatus="hidden"/>
				${lbpmAuthorizeForm.fdAuthorizerName}
			</c:if>
			<c:if test="${lbpmAuthorizeForm.canChangeAuthorizerAuth == 'true'}">
				<xform:address propertyId="fdAuthorizerId" propertyName="fdAuthorizerName" orgType="ORG_TYPE_PERSON"
					showStatus="edit" onValueChange="showAuthorizeItems" style="width:90%">
				</xform:address>
			</c:if>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorizeItem.fdAuthorizeOrgId"/>
		</td>
		<td width=35%>
			<div id="fdLbpmAuthorizeItemDiv"></div>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdAuthorizedPerson"/>
		</td>
		<td width=35%>
			<xform:address propertyId="fdAuthorizedPersonId" propertyName="fdAuthorizedPersonName" orgType="ORG_TYPE_PERSON" 
				showStatus="edit" onValueChange="showAuthorizeItems"  required="true" style="width:90%">
			</xform:address>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.lbpmAuthorizeScope"/>
		</td>
		<td width=85% colspan=3>
			<html:hidden property="fdScopeFormAuthorizeCateIds"/>
			<html:hidden property="fdScopeFormAuthorizeCateNames"/>
			<html:hidden property="fdScopeFormModelNames"/>
			<html:hidden property="fdScopeFormModuleNames"/>
			<html:hidden property="fdScopeFormTemplateIds"/>
			<html:hidden property="fdScopeFormTemplateNames"/>
			<input type="hidden" name="scopeTempValues">
			<textarea style="width:90%" readonly name="fdScopeFormAuthorizeCateShowtexts">${lbpmAuthorizeForm.fdScopeFormAuthorizeCateShowtexts}</textarea>
			<br>
			<a href="#"
				onclick="importAuthorizeCateDialog();">
				<bean:message key="dialog.selectOther" /></a><bean:message key="lbpmAuthorize.lbpmAuthorizeScope.note" bundle="sys-lbpmext-authorize"/>
		</td>
	</tr>
	<tr id="processTypeRow">
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.authorizationTitle"/>
		</td>
		<td width=85% colspan=3>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.authorizationTitle.from"/>
				<xform:datetime property="fdStartTime" dateTimeType="datetime" required="true" style="width:20%;">
				</xform:datetime>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.authorizationTitle.to"/>
				<xform:datetime property="fdEndTime" dateTimeType="datetime" required="true" style="width:20%;">
				</xform:datetime>
			<br>
			<label>
			<xform:checkbox property="fdExpireDeleted">
				<xform:simpleDataSource value="true" bundle="sys-lbpmext-authorize" textKey="lbpmAuthorize.fdExpireDeleted"/>
			</xform:checkbox>
			</label>
		</td>
	</tr>
	<c:if test="${lbpmAuthorizeForm.method_GET=='edit'}">
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdCreator"/>
			</td>
			<td width=35%>
				<html:hidden property="fdCreatorName"/>
				${lbpmAuthorizeForm.fdCreatorName}
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdCreateTime"/>
			</td>
			<td width=35%>
				<html:hidden property="fdCreateTime"/>
				${lbpmAuthorizeForm.fdCreateTime} 
			</td>
		</tr>
	</c:if>
	<tr>
		<td colspan="4" style="color:red">
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.authorize.description"/>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="lbpmAuthorizeForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>