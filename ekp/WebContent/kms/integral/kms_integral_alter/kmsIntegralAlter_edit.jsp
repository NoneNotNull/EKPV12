<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript"
	src="/ekp/resource/ckeditor/ckeditor.js">
</script>
<html:form action="/kms/integral/kms_integral_alter/kmsIntegralAlter.do">
<div id="optBarDiv">
	<c:if test="${kmsIntegralAlterForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="if(checkPersonIsNull())Com_Submit(document.kmsIntegralAlterForm, 'update');">
	</c:if>
	<c:if test="${kmsIntegralAlterForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="if(checkPersonIsNull())Com_Submit(document.kmsIntegralAlterForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="if(checkPersonIsNull())Com_Submit(document.kmsIntegralAlterForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-integral" key="table.kmsIntegralAlter"/></p>

<center>
<table class="tb_normal" width=70% >
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message bundle="kms-integral" key="kmsIntegralCommon.docSubject"/>
		</td><td width="80%">
			<xform:text property="fdSubject" style="width:85%" required="true"/>
		</td>
</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdPerson"/>
		</td><td width="85%"  colspan="3">
			<input type="hidden" name="fdDeptIds" value="${kmsIntegralAlterForm.fdDeptIds }"> 
			<html:textarea property="fdDeptNames"  readonly="true" style="width:90%;height:90px" onclick="Dialog_Address(true, 'fdDeptIds','fdDeptNames', ';', null);"/>
			<a href="#" onclick="Dialog_Address(true, 'fdDeptIds','fdDeptNames', ';', null);">
				<bean:message key="dialog.selectOrg" /></a>	
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdType"/>
		</td><td width="85%"  colspan="3">
			<xform:radio property="fdType" required="true">
				<xform:enumsDataSource enumsType="kms_integral_alter_type"  />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdValue"/>
		</td><td width="85%"  colspan="3">
			<xform:text property="fdValue" style="width:20%" required="true" validators="required number maxLength(200)"/>&nbsp;&nbsp;&nbsp;&nbsp;<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdValue.Tagging"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdDescription"/>
		</td><td width="85%" colspan="3">
			<xform:textarea property="fdDescription" required="true" style="width:90%;height:90px"></xform:textarea>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<html:hidden property="fdDescription"/>
<script>
	Com_IncludeFile("calendar.js");
	Com_IncludeFile("dialog.js");
	$KMSSValidation();

	function checkPersonIsNull(){
		var fdDeptIds = document.getElementsByName("fdDeptIds")[0].value ;
		if(null == fdDeptIds || "" == fdDeptIds || fdDeptIds.length < 32){
			alert("<bean:message bundle='kms-integral' key='kmsIntegralCommon.person.isNull'/>") ;
			return false ;
		}
		return true ;
	}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>