<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/organization/sys_org_quick_sort/SysOrgQuickSort.do">
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.forms[0], 'saveSort');">
	<input type="button" value="<bean:message key="button.close"/>" onClick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-organization" key="sysOrgQuickSort.title"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td width="40pt"><bean:message key="page.serial" /></td>
		<td width="30%">
			<bean:message bundle="sys-organization" key="sysOrgQuickSort.fdOrder" />
		</td>
		<td>
			<bean:message bundle="sys-organization" key="sysOrgQuickSort.fdName" />
		</td>						
	</tr>
	<c:forEach items="${sysOrgQuickSortForm.elements}" var="element" varStatus="vstatus">
	<tr>
		<td>
			${vstatus.index+1}
		</td>
		<td>
			<input type="hidden" name="elements[${vstatus.index}].fdId" value="${element.fdId}"/>
			<xform:text property="elements[${vstatus.index}].fdOrder" required="false" style="width:150px" showStatus="edit" value="${element.fdOrder}" validators="number"/>
		</td>
		<td>
			<xform:text property="elements[${vstatus.index}].fdName" required="false" showStatus="view" value="${element.fdName}"/>
		</td>				
	</tr>
	</c:forEach>
</table>
</center>
</html:form>
<script>
$KMSSValidation();
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>