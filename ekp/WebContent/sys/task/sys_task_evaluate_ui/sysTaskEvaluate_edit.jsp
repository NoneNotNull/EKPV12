<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="no">
	<%--标签页标题--%>
	<template:replace name="title">
		<c:out value="${lfn:message('sys-task:table.sysTaskEvaluate')} - ${ lfn:message('sys-task:module.sys.task') }"></c:out>	
	</template:replace>
	
	<%--操作按钮--%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<%--提交--%>
			<c:if test="${sysTaskEvaluateForm.method_GET=='add'}">
				<ui:button text="${lfn:message('button.update') }"onclick="submitForm('save');">
				</ui:button>
			</c:if>
			<%--关闭--%>
			<ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	
	<%--导航路径--%>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" >
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-task:module.sys.task') }">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-task:table.sysTaskMain') }">
			</ui:menu-item>
		</ui:menu>
	</template:replace>	
	
	<%--满意度评价表单--%>
	<template:replace name="content"> 
		<html:form action="/sys/task/sys_task_evaluate/sysTaskEvaluate.do" >
			<html:hidden property="fdId"/>
			<html:hidden property="fdTaskId"/>
			<html:hidden property="method_GET"/>
			<div class="lui_form_content_frame" >
				<p class="lui_form_subject">
					<bean:message bundle="sys-task" key="table.sysTaskEvaluate" />
				</p>
				<table class="tb_normal" width=95%>
				<tr>
					<%--任务名称--%>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-task" key="sysTaskMain.docSubject"/>
					</td>
					<td width=85% colspan=3>
						<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.docSubject}"/>				
					</td>
				</tr>
				<tr>
					<%--指派人--%>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-task" key="sysTaskMain.fdAppoint"/>
					</td>
					<td width=35%>
						<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.fdAppointName}"/>	
					</td>
					<%--接收人--%>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-task" key="sysTaskMainPerform.fdPerformId"/>
					</td>
					<td width=35%>
						<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.fdPerformName}"/>	
					</td>
				</tr>
				<tr>
					<%--上级任务--%>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-task" key="sysTaskMain.fdParentId"/>
					</td>
					<td width=35%>
					<c:choose> 
						<c:when test="${sysTaskEvaluateForm.sysTaskMainForm.fdParentName != null}">
							<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.fdParentName}"/>	
						</c:when>
						<c:otherwise>
							<bean:message bundle="sys-task" key="sysTaskMain.no.message"/>
						</c:otherwise>
					</c:choose>
					</td>
					<%--任务来源--%>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-task" key="sysTaskMain.fdSourceSubject"/>
					</td>
					<td width=35%>
					<c:choose> 
						<c:when test="${not empty sysTaskEvaluateForm.sysTaskMainForm.fdSourceSubject && not empty sysTaskEvaluateForm.sysTaskMainForm.fdSourceUrl}">
							<a href='<c:url value="${sysTaskEvaluateForm.sysTaskMainForm.fdSourceUrl}"/>' target="_blank" >
								<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.fdSourceSubject}" />
							</a>
						</c:when>
						<c:when test="${not empty sysTaskEvaluateForm.sysTaskMainForm.fdSourceSubject && empty sysTaskEvaluateForm.sysTaskMainForm.fdSourceUrl}">
							<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.fdSourceSubject}" />
						</c:when>
						<c:otherwise>
							<bean:message bundle="sys-task" key="sysTaskMain.no.message"/>
						</c:otherwise>
					</c:choose>			
					</td>
				</tr>
				<tr>
					<%--要求完成时间--%>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-task" key="sysTaskMain.fdPlanCompleteTime"/>
					</td>
					<td width=35%>
						<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.fdPlanCompleteDate}"/>&nbsp;<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.fdPlanCompleteTime}"/>	
					</td>
					<%--实际完成时间--%>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-task" key="sysTaskMain.realCompleteDateTime"/>
					</td>
					<td width=35%>
						<c:choose> 
							<c:when test="${sysTaskEvaluateForm.fdRealFinishDateTime != null}">
								<c:out value="${sysTaskEvaluateForm.fdRealFinishDateTime}" />
							</c:when>
							<c:otherwise>
								<bean:message bundle="sys-task" key="sysTaskMain.no.message"/>
							</c:otherwise>
						</c:choose>	
					</td>
				</tr>
				<tr>
					<%--任务内容描述--%>
					<td class="td_normal_title" width=15% valign="middle">
						<bean:message  bundle="sys-task" key="sysTaskMain.docContent"/>
					</td>
					<td width=85% colspan=3>
						<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.docContent}" escapeXml="false"/>
					</td>
				</tr>
				<tr>
					<%--任务状态--%>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-task" key="sysTaskMain.fdStatus"/>
					</td>
					<td width=85% colspan=3>
						<kmss:showTaskStatus taskStatus = "${sysTaskEvaluateForm.sysTaskMainForm.fdStatus}" showText="true"></kmss:showTaskStatus>
					</td>
				</tr>
				<tr>
					<%--满意度--%>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-task" key="sysTaskEvaluate.fdApprove"/>
					</td>
					<td width=85% colspan="3">
						<kmss:radioTag property="fdApproveId"  serviceBean="sysTaskApproveService" selectBlock ="sysTaskApprove.fdId,sysTaskApprove.fdApprove" whereBlock = "sysTaskApprove.fdIsAvailable = 1" orderBy="sysTaskApprove.fdOrder asc"></kmss:radioTag>
					</td>
				</tr>
				<tr>
					<%--评价内容--%>
					<td class="td_normal_title" width=15% valign="middle">
						<bean:message  bundle="sys-task" key="sysTaskEvaluate.docContent" />
					</td>
					<td width=85% colspan=3>
						<kmss:editor property="docContent" />
					</td>
				</tr>		
				</table>
			</div>
		</html:form>
		<script type="text/javascript">
			Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js|xform.js");
		</script>
		<script type="text/javascript">
			$KMSSValidation(document.forms['sysTaskEvaluateForm']);//加载校验框架
			seajs.use(['lui/dialog'],function(dialog){
				//提交评价
				window.submitForm=function(method){
					var rtf = RTF_GetContent('docContent'); 
					rtf=rtf.replace(/(\s*$)/g, "");
					if(rtf == null || rtf == ""){
						dialog.alert("<bean:message key='errors.required' argKey0='sys-task:sysTaskEvaluate.docContent'/>");
						return;						
					}
					else{
						Com_Submit(document.sysTaskEvaluateForm, method);
					}
				};
			});
		</script>
	</template:replace>
</template:include>