<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/km/keydata/project/km_project_main/kmProjectMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmProjectMain.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-keydata-project" key="table.kmProjectMain"/></p>

<center>
<table
	id="Label_Tabel"
	width=95%>
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
			<bean:message bundle="km-keydata-project" key="kmProjectMain.docCreator"/>
		</td><td width="35%">
			<c:out value="${kmProjectMainForm.docCreatorName}" />
		</td>
		
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdCode"/>
		</td><td width="35%" colspan="3">
			<xform:text property="fdCode" style="width:85%" />
		</td>
	</tr>
	<tr>
					<td
						class="td_normal_title"
						width="15%"><bean:message bundle="km-keydata-project" key="kmProjectMain.fdCategoryName"/></td>
					<td colspan="3"><bean:write
						name="kmProjectMainForm"
						property="fdProjectCategoryName" /></td>
	</tr>
	<tr>			
				<td width=15% class="td_normal_title">
					<bean:message bundle="km-keydata-base" key="keydata.fdIsAvailable"/>
				</td><td width="85%" colspan="3">
					<xform:radio property="fdIsAvailable">
								<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio>
				</td>
		</tr>
	
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.docAlterTime"/>
		</td><td width="35%">
			<xform:datetime property="docAlterTime" />
		</td>
	</tr>
	<tr>
	<td colspan="4">
	&nbsp;
	</td>
	</tr>
	<tr>
		
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdExecutiveDept"/>
		</td><td width="35%">
			<c:out value="${kmProjectMainForm.fdExecutiveDeptName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdProjectChargers"/>
		</td><td width="35%" colspan="3">
			<xform:address propertyId="fdProjectChargerIds" propertyName="fdProjectChargerNames" showStatus="view" orgType="ORG_TYPE_PERSON" style="width:85%" mulSelect="true"/>
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdPlanStart"/>
		</td><td width="35%">
			<xform:datetime property="fdPlanStart" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdPlanEnd"/>
		</td><td width="35%">
			<xform:datetime property="fdPlanEnd" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdInfactStart"/>
		</td><td width="35%">
			<xform:datetime property="fdInfactStart" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdInfactEnd"/>
		</td><td width="35%">
			<xform:datetime property="fdInfactEnd" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectMain.fdPlanDays"/>
		</td><td width="35%">
			<xform:text property="fdPlanDays" style="width:85%" />
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
			<xform:select value="${kmProjectMain.fdStatus}" property="fdStatus" showStatus="view">
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
				url="/sys/right/right_view.jsp"
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
<%@ include file="/resource/jsp/view_down.jsp"%>