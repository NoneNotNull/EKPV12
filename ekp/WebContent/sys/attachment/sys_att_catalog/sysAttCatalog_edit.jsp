<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/attachment/sys_att_catalog/sysAttCatalog.do">
<script>
Com_IncludeFile("jquery.js");
function formCommitMethods(formObj, saveType){
	var fdPath = $('input:text[name="fdPath"]');
	fdPath.val($.trim(fdPath.val()));
	Com_Submit(formObj, saveType);
}
</script>
<div id="optBarDiv">
	<c:if test="${sysAttCatalogForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="formCommitMethods(document.sysAttCatalogForm, 'update');">
	</c:if>
	<c:if test="${sysAttCatalogForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="formCommitMethods(document.sysAttCatalogForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="formCommitMethods(document.sysAttCatalogForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-attachment" key="table.sysAttCatalog"/></p>

<center>
<table class="tb_normal" width=80%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-attachment" key="sysAttCatalog.fdName"/>
		</td><td width="85%">
			<xform:text property="fdName" style="width:50%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-attachment" key="sysAttCatalog.fdPath"/>
		</td><td width="85%">
			<xform:text property="fdPath" style="width:50%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-attachment" key="sysAttCatalog.fdIsCurrent"/>
		</td><td width="85%">
			<xform:checkbox property="fdIsCurrent" value="${sysAttCatalogForm.fdIsCurrent }">
				<xform:simpleDataSource value="true" textKey="message.yes"></xform:simpleDataSource>
			</xform:checkbox>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>