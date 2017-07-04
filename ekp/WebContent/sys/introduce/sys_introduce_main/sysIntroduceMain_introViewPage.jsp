<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="auto">

	<template:replace name="title">
		<c:out
			value="${sysIntroduceMainForm.docSubject} - ${ lfn:message('sys-introduce:sysIntroduceMain.fdIntroduceToEssence') }"></c:out>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="3">
			<ui:button text="${lfn:message('button.close')}" order="5"
				onclick="Com_CloseWindow();">

			</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">
	<%@ include file="sysIntroduceMain_VPScript.jsp"%>
		<div class='lui_form_title_frame'>
			<c:if
				test="${ not empty sysIntroduceMainForm.docSubject }">
				<div class='lui_form_subject'><bean:write
					name="sysIntroduceMainForm" property="docSubject" /></div>
				<div class='lui_form_baseinfo'><!--推荐人--> <bean:message
					bundle="sys-introduce" key="sysIntroduceMain.fdIntroducer" />： <span
					class="com_author"><bean:write name="sysIntroduceMainForm"
					property="fdIntroducerName" /></span> <!--推荐时间--> <c:if
					test="${ not empty sysIntroduceMainForm.fdIntroduceTime }">
					<bean:message bundle="sys-introduce"
						key="sysIntroduceMain.fdIntroduceTime" />：
				<span><bean:write name="sysIntroduceMainForm"
						property="fdIntroduceTime" /></span>
				</c:if></div>
			</c:if>
			<c:if
				test="${  empty sysIntroduceMainForm.docSubject }">
				<div class='lui_form_subject'><bean:message
					bundle="sys-introduce" key="sysIntroduceMain.IntroduceDeleted" /></div>
				
			</c:if>
		</div>

		<c:if test="${ not empty sysIntroduceMainForm.fdIntroduceReason }">
			<div class="lui_form_summary_frame" style="margin-bottom: 10px;"><%--推荐来源 --%></br>
			
			<bean:message bundle="sys-introduce"
				key="sysIntroduceMain.fdNewsSourceOnly" />： <a
				href="${KMSS_Parameter_ContextPath}${sysIntroduceMainForm.fdLinkUrl} "
				target="_blank" class='lui_form_subject ' style="font-size: 14px;"><bean:write
				name="sysIntroduceMainForm" property="docSubject" /></a></br>
			<c:if test="${theone =='false'}">
				<bean:message bundle="sys-introduce"
					key="sysIntroduceMain.fdIntroduceReason" />： <font color="#003048"><bean:write
					name="sysIntroduceMainForm" property="fdIntroduceReason" /></font>
			</c:if>
			<c:if test="${theone=='true'}">
				<bean:message bundle="sys-introduce"
					key="sysIntroduceMain.fdIntroduceReason" />：
					  <xform:textarea isLoadDataDict="false" validators="maxLength(1500)" property="fdIntroduceReason" style="width:50% ;height:120px" showStatus="edit"></xform:textarea>
			 <input  type="button"  class="intr_button" onclick="changereason('${param.fdId}');" value="修改" style="height:25px;width: 71px;background-color: rgb(71, 181, 230); border: none;color: white;margin-top: 97px;margin-left: 10px;"/>
			</c:if>
			</div>
		</c:if>
		
		<ui:tabpage expand="false">
			<%--流程机制 --%>
			<c:import url="/sys/workflow/import/sysWfProcess_view.jsp"
				charEncoding="UTF-8">
				<c:param name="formName" value="sysIntroduceMainForm" />
				<c:param name="fdKey" value="introDoc" />
			</c:import>
		</ui:tabpage>
	</template:replace>

</template:include>