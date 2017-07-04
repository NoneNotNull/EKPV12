<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
		var del = confirm('<bean:message key="page.comfirmDelete"/>');
		return del;
	}
</script>
<kmss:windowTitle
	subject="${sysPropertyTreeForm.fdName}"
	subjectKey="sys-property:table.sysPropertyTree"
	moduleKey="sys-property:module.sys.property" />
<html:form action="/sys/property/sys_property_tree/sysPropertyTree.do">
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/property/sys_property_tree/sysPropertyTree.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('sysPropertyTree.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/sys/property/sys_property_tree/sysPropertyTree.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysPropertyTree.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-property" key="table.sysPropertyTree"/></p>
<center>
<table class="tb_normal" width=95%>
	<c:if test="${not empty sysPropertyTreeForm.fdTreeRootId}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyTree.fdParent"/>
		</td><td colspan="3" width="85%">
			<c:out value="${sysPropertyTreeForm.fdParentName}" />
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
</table>
</center>
</html:form>
<%@ include file="/resource/jsp/view_down.jsp"%>