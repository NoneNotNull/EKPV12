<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<html:form action="/km/signature/km_signature_category/kmSignatureCategory.do">
<div id="optBarDiv">
	<c:if test="${kmSignatureCategoryForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmSignatureCategoryForm, 'update');">
	</c:if>
	<c:if test="${kmSignatureCategoryForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmSignatureCategoryForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmSignatureCategoryForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="km-signature" key="table.signatureCategory"/></p>
<center>
<table class="tb_normal" width=70%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="signatureCategory.fdParent"/>
		</td><td >
				<html:hidden property="fdParentId" /> 
				<html:text property="fdParentName" readonly="true" styleClass="inputsgl" style="width:90%" /> 
				<a href="#"
						onclick="Dialog_SimpleCategory('com.landray.kmss.km.signature.model.KmSignatureCategory','fdParentId','fdParentName',false);">
				<bean:message key="dialog.selectOther" /> 
				</a>
				<xform:textarea property="fdHierarchyId" style="width:85%" showStatus="noShow" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="signatureCategory.fdName"/>
		</td><td >
			<xform:text property="fdName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="signatureCategory.fdOrder"/>
		</td><td >
			<xform:text property="fdOrder" style="width:85%" />
		</td>
	</tr>
	
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script type="text/javascript">
	$KMSSValidation();
	Com_IncludeFile("dialog.js");
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>