<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/km/keydata/project/km_project_main/kmProjectMain.do">
<div id="optBarDiv">
	<c:if test="${kmProjectMainForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmProjectMainForm, 'update');">
	</c:if>
	<c:if test="${kmProjectMainForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmProjectMainForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmProjectMainForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-keydata-project" key="table.kmProjectMain"/></p>

<center>
<table
		id="Label_Tabel" 
		width=95%>
		<html:hidden property="fdId" />
		<tr LKS_LabelName="文档">
			<td>
<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdCode"/>
		</td><td width="35%">
			<xform:text property="fdCode" style="width:85%" showStatus="view" />
			<c:if test="${kmProjectMainForm.method_GET=='add'}">
				提交后自动产生
			</c:if>
		</td>
		
	</tr>
	<%--
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.docAlterTime"/>
		</td><td width="35%">
			<xform:datetime property="docAlterTime" showStatus="view" />
		</td>
	</tr>
	 --%>
	 
	<tr>
					<td
						class="td_normal_title"
						width="15%"><bean:message bundle="km-keydata-project" key="kmProjectMain.fdCategoryName"/></td>
					<td><html:hidden property="fdProjectCategoryId" /> <bean:write
						name="kmProjectMainForm"
						property="fdProjectCategoryName" /></td>
					<td class="td_normal_title" width=15%>
				<bean:message bundle="km-keydata-project" key="kmProjectMain.docCreator"/>
				</td><td width="35%">
					<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
				</td>
				</tr>
				<tr>
				<td width=15% class="td_normal_title">
					<bean:message bundle="km-keydata-base" key="keydata.fdIsAvailable"/>
				</td><td width="85%" colspan="3">
					<sunbor:enums property="fdIsAvailable" enumsType="common_yesno" elementType="radio" />
				</td>
	</tr>
	
	<tr>
	<td class="td_normal_title" colspan="4">
	&nbsp;
	</td>
	</tr>
	
	<tr>
		
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdExecutiveDept"/>
		</td><td width="35%">
			<xform:address propertyId="fdExecutiveDeptId" propertyName="fdExecutiveDeptName" required="true" orgType="ORG_TYPE_DEPT" style="width:85%"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdProjectChargers"/>
		</td><td width="35%" colspan="3">
			<xform:address propertyId="fdProjectChargerIds" propertyName="fdProjectChargerNames" required="true" orgType="ORG_TYPE_PERSON" style="width:85%" mulSelect="true"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdPlanStart"/>
		</td><td width="35%">
			<xform:datetime property="fdPlanStart" dateTimeType="date" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdPlanEnd"/>
		</td><td width="35%">
			<xform:datetime property="fdPlanEnd" dateTimeType="date" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdInfactStart"/>
		</td><td width="35%">
			<xform:datetime property="fdInfactStart" dateTimeType="date" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdInfactEnd"/>
		</td><td width="35%">
			<xform:datetime property="fdInfactEnd" dateTimeType="date" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdPlanDays"/>
		</td><td width="35%">
			<xform:text property="fdPlanDays" style="width:85%" validators="digits"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdInfactDays"/>
		</td><td width="35%">
			<xform:text property="fdInfactDays" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdStatus"/>
		</td><td width="35%" colspan="3">
			<xform:select value="${kmProjectMain.fdStatus}" property="fdStatus">
						<xform:enumsDataSource enumsType="km_keydata_project_status" />
			</xform:select>
		</td>
		
	</tr>
	
	
	
		
</table>
</td>
</tr>
<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
			<td>
			<table
				class="tb_normal"
				width=100%>
				<c:import
					url="/sys/right/right_edit.jsp"
					charEncoding="UTF-8">
					<c:param
						name="formName"
						value="kmProjectMainForm" />
					<c:param
						name="moduleModelName"
						value="com.landray.kmss.km.keydata.project.model.KmProjectMain" />
				</c:import>
			</table>
			</td>
		</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("calendar.js");
	Com_IncludeFile("dialog.js");
	$KMSSValidation();
	window.onload = function(){
		document.title="项目";
	}
	
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>