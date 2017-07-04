<%@page import="com.landray.kmss.tib.common.mapping.constant.Constant"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.common.dao.HQLInfo"%>
<%@page import="com.landray.kmss.tib.common.mapping.service.ITibCommonMappingModuleService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<template:include file="/tib/common/tib_ui_list.jsp">
	<template:replace name="title">${ lfn:message('tib-common:module.tib.manage') }</template:replace>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("doclist.js|jquery.js|json2.js");
</script>
<script type="text/javascript">
/**
 * 加上流程驳回，数组加1
 */
	for(var i=0;i<7;i++){
		DocList_Info[i]="TABLE_DocList"+i;//改写DocList_Info数组，使用6个动态表格
	}
</script>
	<c:if test="${param.cateType == '0'}">
	<template:replace name="path">
		<ui:combin ref="menu.path.tib.simplecategory">
			<ui:varParams 
				id="simplecategoryId"
				moduleTitle="${ lfn:message('tib-common:module.tib.common') }" 
				cateTitle="${ lfn:message('tib-common-mapping:tree.form.flow.mapping') }" 
				href="javascript:parent.tibLoadList('/tib/common/mapping/tib_common_mapping_main/tibCommonMappingMain.do?method=add&templateId=!{value}&name=!{text}&templateName=${param.templateName }&mainModelName=${param.mainModelName }&settingId=${param.settingId }&cateType=0');" 
				modelName="${param.templateName}" 
				categoryId="${param.templateId }" />
		</ui:combin>
	</template:replace>
	</c:if>
	<template:replace name="content">
	<p class="txttitle">${param.name }</p>
<html:form action="/tib/common/mapping/tib_common_mapping_main/tibCommonMappingMain.do">
<%-- 显示列表按钮行 --%>
<c:if test="${param.cateType == '0'}">
<div class="lui_list_operation">
	<table width="100%">
		<tr>
			<td align="right">
				<ui:toolbar>
					<ui:button text="${lfn:message('tib-common-mapping:tibCommonMappingMain.lang.lookFlowTemplate')}" order="4" onclick="Com_OpenWindow('tibCommonMappingMain.do?method=redirectToTemplate&fdModelName=${tibCommonMappingMainForm.fdTemplateName}&fdModelId=${tibCommonMappingMainForm.fdTemplateId}','_blank');"></ui:button>
				<c:if test="${tibCommonMappingMainForm.method_GET=='edit'}">
					<ui:button text="${lfn:message('button.update')}" order="4" onclick="Com_Submit(document.tibCommonMappingMainForm, 'update');"></ui:button>
					<c:set var="fdFormFileName" value="${param.fdFormFileName}" /><!-- add和edit得到该参数不一样，所以设置一个页面变量统一 -->
				</c:if>
				<c:if test="${tibCommonMappingMainForm.method_GET=='add'}">
					       <c:set var="fdFormFileName" value="${fdFormFileName}" />
					<ui:button text="${lfn:message('button.save')}" order="4" onclick="Com_Submit(document.tibCommonMappingMainForm, 'save');"></ui:button>
				</c:if>
				</ui:toolbar>						
			</td>
		</tr>
	</table>
</div>
</c:if>
<c:if test="${param.cateType != '0'}">
<div id="optBarDiv">
	<input type="button" value="<bean:message bundle="tib-common-mapping" key="tibCommonMappingMain.lang.lookFlowTemplate"/>" onclick="Com_OpenWindow('tibCommonMappingMain.do?method=redirectToTemplate&fdModelName=${tibCommonMappingMainForm.fdTemplateName}&fdModelId=${tibCommonMappingMainForm.fdTemplateId}','_blank');">
	<c:if test="${tibCommonMappingMainForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.tibCommonMappingMainForm, 'update');">
				<c:set var="fdFormFileName" value="${param.fdFormFileName}" /><!-- add和edit得到该参数不一样，所以设置一个页面变量统一 -->
	</c:if>
	<c:if test="${tibCommonMappingMainForm.method_GET=='add'}">
		       <c:set var="fdFormFileName" value="${fdFormFileName}" />
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.tibCommonMappingMainForm, 'save');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
</c:if>
	<center>
		<table id="td_normal" <c:if test="${param.cateType == '0'}">width="100%"</c:if><c:if test="${param.cateType != '0'}">width="90%"</c:if>>
			<!-- 函数信息 -->
			<tr>
				<td align="center">
					<!-- 表单事件 --> 
					<%@ include
						file="../tib_common_mapping_func/tibCommonMappingFuncFormEvent_view.jsp"%>
					<!-- 机器人节点 --> 
					<%@ include
						file="../tib_common_mapping_func/tibCommonMappingFuncRobot_view.jsp"%>
					
					<%
						//检查是否有模块注册SAP			
						String settingId =request.getParameter("settingId");
						ITibCommonMappingModuleService eSettingService=(ITibCommonMappingModuleService)SpringBeanUtil.getBean("tibCommonMappingModuleService");
						boolean check=eSettingService.checkModuleContainType(settingId, Constant.FD_TYPE_SAP);
						if(check)	{	
					%>
					<c:import url="/tib/sap/mapping/plugins/controls/tibSapMappingFuncFormControl_view_bak.jsp"
									charEncoding="UTF-8">
						<c:param name="fdFuncForms" value="fdFormControlFunctionListForms" />
						<c:param name="fdOrder" value="5" />
						<c:param name="fdFormFileName" value="${fdFormFileName}" />
					</c:import> 
						<%--@ include file="../../../sap/mapping/plugins/controls/tibSapMappingFuncFormControl_view.jsp"--%>		
					<%
						}
					%>			
					<%-- 流程驳回 --%>
					<c:import url="../tib_common_mapping_func/tibCommonMappingFuncFlowReject_view.jsp"
									charEncoding="UTF-8">
						<c:param name="fdFuncForms" value="fdFlowRejectListForms" />
						<c:param name="fdOrder" value="6" />
						<c:param name="fdFormFileName" value="${fdFormFileName}" />
					</c:import> 
					<%-- include
						file="../tib_common_mapping_func/tibCommonMappingFuncFlowReject_view.jsp"--%>	
				</td>
			</tr>
		</table>
	</center>
<html:hidden property="fdId" />
<!-- 统一从url传递参数中取，而不是从form中读，因都是一致的 -->
<html:hidden property="fdTemplateId"  value="${param.templateId }"/>
<html:hidden property="fdTemplateName"  value="${param.templateName }"/>
<html:hidden property="fdMainModelName"  value="${param.mainModelName}"/>
<!-- 应用注册ID -->
<html:hidden property="settingId"  value="${param.settingId}"/>

<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
</template:replace>
</template:include>
