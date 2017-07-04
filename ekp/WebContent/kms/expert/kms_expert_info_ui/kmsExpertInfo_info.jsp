<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="head">
		<template:super />
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/expert/kms_expert_info_ui/style/view.css">
		<script>
			seajs.use(['theme!form', 'theme!panel']);
		</script>
	</template:replace>
	<template:replace name="body">		
		<div class="lui_expert_content" id="expert_content">	
			<div style="height:25px;">
				<kmss:auth requestURL="/kms/expert/kms_expert_info/kmsExpertInfo.do?method=edit&fdId=${kmsExpertInfoForm.fdId}"
						   requestMethod="GET">
					<a  href="javascript:void(0);"
						class="lui_expert_info_edit" 
						onclick="top.open('kmsExpertInfo.do?method=edit&fdId=${kmsExpertInfoForm.fdId}&expert=true&fdPersonId=${kmsExpertInfoForm.fdPersonId}','_self');">
				     	${lfn:message('kms-expert:kmsExpert.edit.info')}
				    </a>
				</kmss:auth>
			</div>	   
			<%--专家属性 --%>
			<c:if test="${not empty kmsExpertInfoForm.extendFilePath}">
				<div class="lui_expert_title_info">
					<span>${lfn:message('kms-expert:kmsExpert.expertInfo.property')}</span>
				</div>
				<div style="padding-top: 10px;">
					<table class="tb_simple" width=100%>
						<c:import url="/sys/property/include/sysProperty_view.jsp" charEncoding="UTF-8">
								<c:param name="formName" value="kmsExpertInfoForm" />
								<c:param name="fdDocTemplateId" value="${kmsExpertInfoForm.kmsExpertTypeId}" />
						</c:import>
					</table>
				</div>
			</c:if>
			<%--个人简介 --%>
			<div class="lui_expert_title_info">
				<span>${lfn:message('kms-expert:table.kmsExpertInfo.background')}</span>
			</div>
			<div class="lui_expert_info_content">
				<xform:textarea property="fdBackground"></xform:textarea>
			</div>
			<%--详细介绍 --%>
			<c:if test="${not empty kmsExpertInfoForm.fdDetails }">
				<div class="lui_expert_title_info">
					<span>${lfn:message('kms-expert:table.kmsExpertInfo.fdDetails')}</span>
				</div>
				<div class="lui_expert_info_content">									
					<xform:rtf property="fdDetails"/>
				</div>
			</c:if>	
		</div>
		<%@ include file="/kms/expert/kms_expert_info_ui/kmsExpertInfo_info_js.jsp" %>
	</template:replace>
</template:include>