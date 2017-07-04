<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="config.view">
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="95%">
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
			<kmss:auth requestURL="/work/cases/work_cases_category/workCasesCategory.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${ lfn:message('button.edit') }" onclick="Com_OpenWindow('workCasesCategory.do?method=edit&fdId=${param.fdId}','_self');">
				</ui:button>
			</kmss:auth>
			<kmss:auth requestURL="/work/cases/work_cases_category/workCasesCategory.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${ lfn:message('button.delete') }" onclick="if(!confirmDelete())return;Com_OpenWindow('workCasesCategory.do?method=delete&fdId=${param.fdId}','_self');">
				</ui:button>
			</kmss:auth>
			<ui:button text="${ lfn:message('button.close') }" onclick="Com_CloseWindow();"></ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">
	
<p class="txttitle"><bean:message bundle="work-cases" key="table.workCasesCategory"/></p>

<center>
<table class="tb_normal" id="Label_Tabel" width=95%>

	<tr LKS_LabelName="${ lfn:message('config.baseinfo') }">
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
			<xform:datetime property="docCreateTime" />
		</td>
		<%-- <td class="td_normal_title" width=15%>
			<bean:message bundle="work-cases" key="workCasesCategory.fdHierarchyId"/>
		</td><td width="35%">
			<xform:text property="fdHierarchyId" style="width:85%" />
		</td> --%>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="work-cases" key="workCasesCategory.docCreator"/>
		</td><td width="35%">
			<c:out value="${workCasesCategoryForm.docCreatorName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="work-cases" key="workCasesCategory.fdParent"/>
		</td><td width="35%">
			<c:out value="${workCasesCategoryForm.fdParentName}" />
		</td>
	</tr>
			</table>
		</td>
	</tr>
	<%-- 以下代码为嵌入流程模板标签的代码 --%>
	<c:import url="/sys/lbpmservice/include/sysLbpmTemplate_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="workCasesCategoryForm" />
		<c:param name="fdKey" value="reviewMainDoc" />
	</c:import>
	<%-- 以上代码为嵌入流程模板标签的代码 --%>
	
	<c:import url="/sys/simplecategory/include/sysCategoryMain_view.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="workCasesCategoryForm" />
		<c:param name="fdModelName" value="com.landray.kmss.work.cases.model.WorkCasesCategory" /> 
		<c:param name="fdKey" value="reviewMainDoc" />
	</c:import>

	<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />"><td>
		 <table class="tb_normal" width=100%>
			<c:import url="/sys/right/tmp_right_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="workCasesCategoryForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.work.cases.model.WorkCasesCategory" />
			</c:import>
		 </table>
	    </td>
	 </tr>
	
</table>
	
</table>
</center>

	</template:replace>
</template:include>