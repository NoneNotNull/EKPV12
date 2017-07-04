<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<%--标签页标题--%>
	<template:replace name="title">
		<c:out value="${lfn:message('sys-task:table.sysTaskFeedback')} - ${ lfn:message('sys-task:module.sys.task') }"></c:out>	
	</template:replace>
	
	<%--操作按钮--%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<%--提交--%>
			<c:if test="${childSize == 0 }">
				<kmss:auth requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
					<ui:button text="${lfn:message('button.edit')}" 
						onclick="Com_OpenWindow('sysTaskFeedback.do?method=edit&fdId=${param.fdId}','_self');">
					</ui:button>
				</kmss:auth>
			</c:if>
			<%--删除--%>
			<kmss:auth requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.delete')}" 
					onclick="deleteDoc('sysTaskFeedback.do?method=delete&fdId=${param.fdId}');">
				</ui:button>
			</kmss:auth>
			<%--关闭--%> 
			<ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	
	<%--导航路径--%>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-task:module.sys.task') }" href="/sys/task/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-task:table.sysTaskMain') }" href="/sys/task/" target="_self">
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	
	<%--主内容--%>
	<template:replace name="content">
		<script type="text/javascript">
			seajs.use(['lui/jquery','lui/dialog'], function($, dialog) {
				LUI.ready(function(){
					$("input[type=checkbox]",document.forms[0]).each(function(){
						this.disabled="disabled";
				     });
				});
				//删除
				window.deleteDoc = function(delUrl){
					dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(isOk){
						if(isOk){
							Com_OpenWindow(delUrl,'_self');
						}
					});
					return;
				};
			});
		</script>
		<html:form action="/sys/task/sys_task_feedback/sysTaskFeedback.do">
			<html:hidden property="fdId"/>
			<html:hidden property="fdTaskId"/>
			<html:hidden property="fdCompleteDateTime"/>
			<html:hidden property="method_GET"/>
			<div class="lui_form_content_frame" >
				<p class="lui_form_subject">
					<bean:message bundle="sys-task" key="tag.feedback" />
				</p>
				<table class="tb_normal" width=95%>
					<tr>
						<%-- 任务名称--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskMain.docSubject"/>
						</td>
						<td width=35%>
							<a class="com_btn_link" href="../sys_task_main/sysTaskMain.do?method=view&fdId=${sysTaskFeedbackForm.sysTaskMainForm.fdId}"  target="_blank"><c:out value="${sysTaskFeedbackForm.sysTaskMainForm.docSubject}"/></a>			
						</td>
						<%--指派人--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskMain.fdAppoint"/>
						</td>
						<td width=35%>
							<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdAppointName}"/>	
						</td>
						
					</tr>
					<tr>
						<%--接收人--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskMainPerform.fdPerformId"/>
						</td>
						<td width=35%>
							<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdPerformName}"/>	
						</td>
						<%--抄送人--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskMainCc.fdCcId"/>
						</td>
						<td width=35%>
							<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdCcNames}"/>	
						</td>
					</tr>
					<tr>
						<%--要求完成时间--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskMain.fdPlanCompleteTime"/>
						</td>
						<td width=35%>
							<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdPlanCompleteDate}"/>&nbsp;<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdPlanCompleteTime}"/>	
						</td>
						<%--是否过期--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="sys-task" key="sysTaskMain.pastdue.yesno"/>
						</td>
						<td width=35% >
							<sunbor:enumsShow value="${sysTaskFeedbackForm.fdPastDue}" enumsType="sys_task_yesno"></sunbor:enumsShow>
						</td>
					</tr>
					<tr>
						<%--上级任务--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskMain.fdParentId"/>
						</td>
						<td width=35% colspan="3">
						<c:choose> 
							<c:when test="${sysTaskFeedbackForm.sysTaskMainForm.fdParentName != null}">
								<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdParentName}" />
							</c:when>
							<c:otherwise>
								<bean:message bundle="sys-task" key="sysTaskMain.no.message"/>
							</c:otherwise>
						</c:choose>
						</td>
					</tr>
					<tr>
						<%--任务来源--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskMain.fdSourceSubject"/>
						</td>
						<td width=35% colspan="3">
						<c:choose> 
							<c:when test="${not empty sysTaskFeedbackForm.sysTaskMainForm.fdSourceSubject && not empty sysTaskFeedbackForm.sysTaskMainForm.fdSourceUrl}">
								<a href='<c:url value="${sysTaskFeedbackForm.sysTaskMainForm.fdSourceUrl}"/>' target="_blank" >
									<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdSourceSubject}" />
								</a>
							</c:when>
							<c:when test="${not empty sysTaskFeedbackForm.sysTaskMainForm.fdSourceSubject && empty sysTaskFeedbackForm.sysTaskMainForm.fdSourceUrl}">
								<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdSourceSubject}" />
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
							<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.docContent}" escapeXml="false"/>
						</td>
					</tr>
					<tr>
						<%--当前进度--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskFeedback.fdProgress"/>
						</td>
						<td width=85% colspan="3">
							<c:out value="${sysTaskFeedbackForm.fdProgress}"/>%
						</td>
					</tr>
					<tr>
						<%--完成情况描述--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskFeedback.docContent"/>
						</td>
						<td width=85% colspan=3>
							<c:out value="${sysTaskFeedbackForm.docContent}" escapeXml="false" />
						</td>
					</tr>
					<tr>	
						<%--附件--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskMain.attachment"/>
						</td>
						<td width=85% colspan=3>
							<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
								<c:param name="fdKey" value="attachment"/>
								<c:param name="formBeanName" value="sysTaskFeedbackForm"/>
							</c:import>
						</td>
					</tr>
					<tr>
						<%--反馈人--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskFeedback.docCreatorId"/>
						</td>
						<td width=35%>
							<c:out value="${sysTaskFeedbackForm.docCreatorName}"/>
						</td>
						<%--反馈时间--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskFeedback.docCreateTime"/>
						</td>
						<td width=35%>
							<c:out value="${sysTaskFeedbackForm.docCreateTime}"/>
						</td>
					</tr>
					<tr>
						<%--通知类型--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskFeedback.fdNotifyType"/>
						</td>
						<td width=35% >
							<sunbor:multiSelectCheckbox formName="sysTaskFeedbackForm"  enumsType="sysTaskFreedback_fdNotifyType" property="fdNotifyTypeList" htmlElementProperties = "disabled"></sunbor:multiSelectCheckbox>
						</td>
						<%-- 通知方式--%>
						<td class="td_normal_title" width="15%">
							<bean:message bundle="sys-task" key="sysTaskFeedback.fdNotifyWay" />
						</td>
						<td width="35%"><kmss:editNotifyType  property="fdNotifyWay"  /></td>
					</tr>
				</table>
			</div>
		</html:form>
	</template:replace>
	
</template:include>