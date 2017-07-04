<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="config.edit">
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="95%">
			<c:choose>
				<c:when test="${ workCasesCategoryForm.method_GET == 'edit' }">
					<ui:button text="${ lfn:message('button.update') }" onclick="Com_Submit(document.workCasesCategoryForm, 'update');"></ui:button>
				</c:when>
				<c:when test="${ workCasesCategoryForm.method_GET == 'add' }">	
					<ui:button text="${ lfn:message('button.save') }" onclick="Com_Submit(document.workCasesCategoryForm, 'save');"></ui:button>
					<ui:button text="${ lfn:message('button.saveadd') }" onclick="Com_Submit(document.workCasesCategoryForm, 'saveadd');"></ui:button>
				</c:when>
			</c:choose>
			<ui:button text="${ lfn:message('button.close') }" onclick="Com_CloseWindow();"></ui:button>	
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">
	
<html:form action="/work/cases/work_cases_category/workCasesCategory.do">
 
<p class="txttitle"><bean:message bundle="work-cases"  key="table.workCasesCategory"/></p>
<script>
Com_IncludeFile("dialog.js");
</script>

<center>
<table class="tb_normal" id="Label_Tabel" width=95%>
	<%-- <tr LKS_LabelName='${ lfn:message('config.baseinfo') }'>
		<td>
			<table class="tb_normal" width=100%> 
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="work-cases" key="workCasesCategory.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="work-cases" key="workCasesCategory.fdOrder"/>
		</td><td width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="work-cases" key="workCasesCategory.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="work-cases" key="workCasesCategory.fdHierarchyId"/>
		</td><td width="35%">
			<xform:text property="fdHierarchyId" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="work-cases" key="workCasesCategory.docCreator"/>
		</td><td width="35%">
			<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="work-cases" key="workCasesCategory.fdParent"/>
		</td><td width="35%">
			<xform:select property="fdParentId">
				<xform:beanDataSource serviceBean="workCasesCategoryService" selectBlock="fdId,fdName" orderBy="fdOrder" />
			</xform:select>
		</td>
		<td colspan="3">
		<html:hidden property="fdParentId"/>
		<html:text property="fdParentName" readonly="true" styleClass="inputsgl" style="width:85%"/>
		<a href="#" onclick="Dialog_Tree(false, 'fdParentId', 'fdParentName', null, 'workCasesCategoryService&parentId=!{value}', '<bean:message  bundle="work-cases" key="workCasesCategory.fdParent"/>', null, null, '${workCasesCategoryForm.fdId}')">
			<bean:message key="dialog.selectOther"/>
		</a>
	</td>
		
	</tr>
			</table>
		</td>
	</tr> --%>
	<!-- 以下为类别设置 -->
	<c:import url="/sys/simplecategory/include/sysCategoryMain_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="workCasesCategoryForm" />
			<c:param name="requestURL" value="/work/cases/work_cases_category/workCasesCategory.do?method=add" />
			<c:param name="fdModelName" value="${param.fdModelName}" />
			<c:param name="fdKey" value="reviewMainDoc" />
	</c:import>
	<!-- 以上为类别设置 -->
	<%-- 以下代码为嵌入流程模板标签的代码 --%>
		<c:import url="/sys/lbpmservice/include/sysLbpmTemplate_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="workCasesCategoryForm" />
			<c:param name="fdKey" value="reviewMainDoc" />
		</c:import>
	<%-- 以上代码为嵌入流程模板标签的代码 --%>
	 <!-- 关联机制 -->
	 <tr LKS_LabelName="<bean:message bundle="sys-relation" key="sysRelationMain.tab.label" />">
		<c:set var="mainModelForm" value="${workCasesCategoryForm}" scope="request"/>
		<c:set var="currModelName" value="com.landray.kmss.work.cases.model.WorkCasesCategory" scope="request"/>
		<td><%@ include	file="/sys/relation/include/sysRelationMain_edit.jsp"%></td>
	</tr>
	<!-- 权限设置 -->
	<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />"><td>
		 <table class="tb_normal" width=100%>
			<c:import url="/sys/right/tmp_right_edit.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="workCasesCategoryForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.work.cases.model.WorkCasesCategory" />
			</c:import>
		 </table>
	    </td>
 	</tr>
	<!-- 权限设置 -->
	
</table>

</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>

	</template:replace>
</template:include>