<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/lbpmext/integrate/authorize/lbpm_authorize/lbpmAuthorizeScope.do" onsubmit="return validateSysAuthorizeScopeForm(this);">
<div id="optBarDiv">
	<c:if test="${lbpmAuthorizeScopeForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.lbpmAuthorizeScopeForm, 'update');">
	</c:if>
	<c:if test="${lbpmAuthorizeScopeForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.lbpmAuthorizeScopeForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.lbpmAuthorizeScopeForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
 
<p class="txttitle"><bean:message  bundle="sys-lbpmext-authorize" key="table.lbpmAuthorizeScope"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="table.lbpmAuthorize"/>.<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdId"/>
		</td><td width=35%>
				
			<html:hidden property="fdAuthorizeId"/>
			<a href="#" onclick="alert('请修改这段代码');"><bean:message key="dialog.selectOther"/></a>
				
			<span class="txtstrong">*</span>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorizeScope.fdAuthorizeCateId"/>
		</td><td width=35%>
			<html:text property="fdAuthorizeCateId"/>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorizeScope.fdAuthorizeCateName"/>
		</td><td width=35%>
			<html:text property="fdAuthorizeCateName"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorizeScope.fdAuthorizeCateShowtext"/>
		</td><td width=35%>
			<html:text property="fdAuthorizeCateShowtext"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorizeScope.fdModelName"/>
		</td><td width=35%>
			<html:text property="fdModelName"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorizeScope.fdModuleName"/>
		</td><td width=35%>
			<html:text property="fdModuleName"/>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="lbpmAuthorizeScopeForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>