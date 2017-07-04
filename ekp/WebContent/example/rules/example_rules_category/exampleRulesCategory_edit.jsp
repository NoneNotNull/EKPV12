<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="config.edit">
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="95%">
			<c:choose>
				<c:when test="${ exampleRulesCategoryForm.method_GET == 'edit' }">
					<ui:button text="${ lfn:message('button.update') }" onclick="Com_Submit(document.exampleRulesCategoryForm, 'update');"></ui:button>
				</c:when>
				<c:when test="${ exampleRulesCategoryForm.method_GET == 'add' }">	
					<ui:button text="${ lfn:message('button.save') }" onclick="Com_Submit(document.exampleRulesCategoryForm, 'save');"></ui:button>
					<ui:button text="${ lfn:message('button.saveadd') }" onclick="Com_Submit(document.exampleRulesCategoryForm, 'saveadd');"></ui:button>
				</c:when>
			</c:choose>
			<ui:button text="${ lfn:message('button.close') }" onclick="Com_CloseWindow();"></ui:button>	
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">
	
<html:form action="/example/rules/example_rules_category/exampleRulesCategory.do">
 
<p class="txttitle"><bean:message bundle="example-rules" key="table.exampleRulesCategory"/></p>

<center>
<table class="tb_normal" id="Label_Tabel" width=95%>
<%-- 	<tr LKS_LabelName='${ lfn:message('config.baseinfo') }'>
		<td>
			<table class="tb_normal" width=100%> 
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="example-rules" key="exampleRulesCategory.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="example-rules" key="exampleRulesCategory.fdOrder"/>
		</td><td width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="example-rules" key="exampleRulesCategory.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="example-rules" key="exampleRulesCategory.fdParent"/>
		</td><td width="35%">
			<xform:select property="fdParentId">
				<xform:beanDataSource serviceBean="exampleRulesCategoryService" selectBlock="fdId,fdName" orderBy="fdOrder" />
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="example-rules" key="exampleRulesCategory.docCreator"/>
		</td><td width="35%">
			<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
		</td>
	</tr>
			</table>
		</td>
	</tr> --%>
	<!-- 简单分类设置 -->
 	<c:import url="/sys/simplecategory/include/sysCategoryMain_edit.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="exampleRulesCategoryForm" />
			<c:param name="requestURL" value="/example/rules/example_rules_category/exampleRulesCategory.do?method=add" />
			<c:param name="fdModelName" value="${param.fdModelName}" />
			<c:param name="fdKey" value="exampleRulesCategoryForm" />
	</c:import> 
	<%-- 以下代码为嵌入流程模板标签的代码    权限（默认阅读者、默认编辑者） --%>
  	<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />"><td>
		 <table class="tb_normal" width=100%>
			<c:import url="/sys/right/tmp_right_edit.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="exampleRulesCategoryForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.example.rules.model.ExampleRulesCategory" />
			</c:import>
		 </table>
	    </td>
	 </tr>  
	<%--  	<c:import url="/sys/lbpmservice/include/sysLbpmTemplate_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="exampleRulesCategoryForm" />
			<c:param name="fdKey" value="exampleRulesCategory" />
		</c:import> --%>
	 
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