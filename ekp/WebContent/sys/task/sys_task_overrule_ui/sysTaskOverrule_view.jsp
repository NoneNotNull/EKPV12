<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<%--标签页标题--%>
	<template:replace name="title">
		<c:out value="${lfn:message('sys-task:table.sysTaskOverrule')} - ${ lfn:message('sys-task:module.sys.task') }"></c:out>	
	</template:replace>
	
	<%--操作按钮--%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
		  <c:if test="${fdStatus != '6' }">
			    <kmss:auth
					requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&flag=${param.flag}&fdTaskId=${sysTaskOverruleForm.fdTaskId}"
					requestMethod="GET">
					<ui:button text="${lfn:message('sys-task:button.feedback')}" order="3" id="feedback"
						onclick="Com_OpenWindow('${LUI_ContextPath}/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&flag=${param.flag}&fdTaskId=${sysTaskOverruleForm.fdTaskId}','_blank');">
					</ui:button>
				</kmss:auth>
			</c:if>
			<%--删除--%>
			<kmss:auth requestURL="/sys/task/sys_task_overrule/sysTaskOverrule.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.delete')}" 
					onclick="deleteDoc('sysTaskOverrule.do?method=delete&fdId=${param.fdId}');">
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
			seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog,topic) {
				
				
				//任务反馈后会发回刷新事件，在这个事件中再查找上一级页面刷新待办
				topic.subscribe('successReloadPage', function() {
					try{
						if(window.opener!=null) {
							try {
								if (window.opener.LUI) {
									window.opener.LUI.fire({ type: "topic", name: "successReloadPage" });
									return;
								}
							} catch(e) {}
							if (window.LUI) {
								LUI.fire({ type: "topic", name: "successReloadPage" }, window.opener);
							}
							var hrefUrl= window.opener.location.href;
							var localUrl = location.href;
							if(hrefUrl.indexOf("/sys/notify/")>-1 && localUrl.indexOf("/sys/notify/")==-1)
								window.opener.location.reload();
						}
					}catch(e){}
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
		<html:form action="/sys/task/sys_task_overrule/sysTaskOverrule.do">
 			<html:hidden property="fdId"/>
			<html:hidden property="fdTaskId"/>
 			<html:hidden property="method_GET"/>
 			<div class="lui_form_content_frame" >
 				<p class="lui_form_subject">
					<bean:message bundle="sys-task" key="tag.overrule" />
				</p>
				<table class="tb_normal" width=95%>
					<tr>	
						<%--任务名称--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskMain.docSubject"/>
						</td>
						<td width=85% colspan=3>
							<a class="com_btn_link" href="<c:url value="/sys/task/sys_task_main/sysTaskMain.do"/>?method=view&fdId=${sysTaskOverruleForm.fdTaskId}"  target="_self">
								<c:out value="${sysTaskOverruleForm.fdTaskName}"/>	
							</a>			
						</td>
					</tr>
					<tr>
						<%--驳回理由--%>
						<td class="td_normal_title" width=15% valign="middle">
							<bean:message  bundle="sys-task" key="sysTaskOverrule.fdReason"/>
						</td>
						<td width=85% colspan=3>
							<c:out value="${sysTaskOverruleForm.fdReason}"/>
						</td>
					</tr>
					<tr>
						<%--通知方式--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskOverrule.fdNotifyType"/>
						</td>
						<td width=85% colspan=3>
							<kmss:showNotifyType value="${sysTaskOverruleForm.fdNotifyType}" />
						</td>
					</tr>
					<tr>
						<%--驳回人--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskOverrule.docCreator"/>
						</td>
						<td width=35%>
							<c:out value="${sysTaskOverruleForm.docCreatorName}"/>
						</td>
						<%--驳回时间--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskOverrule.docCreateTime"/>
						</td>
						<td width=35%>
							<c:out value="${sysTaskOverruleForm.docCreateTime}"/>
						</td>
					</tr>
				</table>
 			</div>
 		</html:form>
	</template:replace>
	
</template:include>