<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>Com_IncludeFile("dialog.js");</script>
<kmss:windowTitle
	subject="${sysPropertyTreeForm.fdName}"
	subjectKey="sys-property:table.sysPropertyTree"
	moduleKey="sys-property:module.sys.property" />
<html:form action="/sys/property/sys_property_tree/sysPropertyTree.do">
<div id="optBarDiv">
	<c:if test="${sysPropertyTreeForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysPropertyTreeForm, 'update');">
	</c:if>
	<c:if test="${sysPropertyTreeForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysPropertyTreeForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysPropertyTreeForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-property" key="table.sysPropertyTree"/></p>
<center>
<table class="tb_normal" width=95%>
	<c:if test="${not empty sysPropertyTreeForm.fdTreeRootId}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyTree.fdParent"/>
		</td><td colspan="3" width="85%">
			<html:hidden property="fdParentId" />
			<html:text property="fdParentName" readonly="true" styleClass="inputsgl" style="width:85%" />
			<a href="javascript:void(0);" onclick="Dialog_Tree(false, 'fdParentId', 'fdParentName', ',', 'sysPropertyTreeListService&parentId=!{value}&treeRootId=${sysPropertyTreeForm.fdTreeRootId}', 
				'<c:out value="${sysPropertyTreeForm.fdTreeRootName}" />', null, null, '${param.fdId}');">
			<bean:message key="dialog.selectOther" /></a>
		</td>
	</tr>
	</c:if>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyTree.fdName"/>
		</td><td colspan="3" width="85%">
			<xform:text property="fdName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyTree.fdOrder"/>
		</td><td colspan="3" width="85%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyTree.fdDescription"/>
		</td><td colspan="3" width="85%">
			<xform:textarea property="fdDescription" style="width:85%" />
		</td>
	</tr>
	<%-- 所属场所 --%>
	<% if(ISysAuthConstant.IS_AREA_ENABLED) { %> 
		<input type="hidden" name="authAreaId" value="${sysPropertyTreeForm.authAreaId}"> 
	<% } %>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>