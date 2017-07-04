<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="no">
	<%--标签页标题--%>
	<template:replace name="title">
		<c:out value="${lfn:message('sys-task:table.sysTaskFeedback')} - ${ lfn:message('sys-task:module.sys.task') }"></c:out>	
	</template:replace>
	
	<%--操作按钮--%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<c:choose>
				<%--add页面的按钮--%>
				<c:when test="${ sysTaskFeedbackForm.method_GET == 'add' || sysTaskFeedbackForm.method_GET=='quoteAdd' }">
					<ui:button text="${lfn:message('button.update') }" order="2" onclick="commitMethod('save');">
					</ui:button>
				</c:when>
				<%--edit页面的按钮--%>
				<c:when test="${ sysTaskFeedbackForm.method_GET == 'edit' }">
					<ui:button text="${lfn:message('button.update') }" order="2" onclick="commitMethod('update');">
					</ui:button>
				</c:when>
			</c:choose>
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
	
	<%--执行反馈表单--%>
	<template:replace name="content"> 
		<html:form action="/sys/task/sys_task_feedback/sysTaskFeedback.do">
			<html:hidden property="fdId"/>
			<html:hidden property="fdTaskId"/>
			<html:hidden property="fdCompleteDate"/>
			<html:hidden property="fdCompleteTime"/>
			<html:hidden property="fdCompleteDateTime"/>
			<html:hidden property="method_GET"/>
			<div class="lui_form_content_frame" >
				<p class="lui_form_subject">
					<bean:message bundle="sys-task" key="tag.feedback" />
				</p>
				<table class="tb_normal" width=95%>
				<tr>
					<%--任务名称--%>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-task" key="sysTaskMain.docSubject"/>
					</td>
					<td width=35%>
						<a  class="com_btn_link" href="../sys_task_main/sysTaskMain.do?method=view&fdId=${sysTaskFeedbackForm.sysTaskMainForm.fdId}"  target="_blank"><c:out value="${sysTaskFeedbackForm.sysTaskMainForm.docSubject}"/></a>		
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
					<td width=85% >
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
							<c:out
							value="${sysTaskFeedbackForm.sysTaskMainForm.fdParentName}" />
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
					<%--当前任务进度--%>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-task" key="sysTaskFeedback.fdProgress"/>
					</td>
					<td width=85% colspan=3>
					
						<%-- #11654 移除“自动根据子任务更新进度 ”,为兼容旧数据,暂时保留字段 --%>
						<html:hidden property="fdProgressAuto" value="true"/>
						
						<%-- 
							1、判断当前任务含有子任务时，在执行反馈中仅可填写完成情况描述，不可修改进度（当前进度加注释 自动根据子任务更新进度
							2、判断当前任务无子任务时，在执行反馈中可填写完成情况描述（隐去自动根据子任务更新进度复选框），可修改进度
						 --%>
						<c:if test="${childSize == 0 }">
							<html:text style="width:40px" property="fdProgress" onchange="setProgress();"/>%
							<div id="sliderProcess" style="height:15px;margin:5px 0px 5px 0px"></div>
						</c:if>
					
						<c:if test="${childSize > 0 }">
							<html:hidden property="fdProgress"/>
							<c:out value="${sysTaskFeedbackForm.fdProgress }"></c:out>%
							(<bean:message bundle="sys-task" key="sysTaskMain.fdProgressAuto" />)
						</c:if>
						
					</td>
				</tr>
				<tr>
					<%--完成情况描述--%>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-task" key="sysTaskFeedback.docContent"/>
					</td>
					<td width=85% colspan=3>
						<kmss:editor property="docContent"  />
					</td>
				</tr>
				<tr>
					<%--附件--%>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-task" key="sysTaskMain.attachment"/>
					</td>
					<td width=85% colspan=3>
						<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
							<c:param name="fdKey" value="attachment"/>
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
					<%--通知人--%>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-task" key="sysTaskFeedback.fdNotifyType"/>
					</td>
					<td width=35%>
						<sunbor:multiSelectCheckbox formName="sysTaskFeedbackForm"  enumsType="sysTaskFreedback_fdNotifyType" property="fdNotifyTypeList"></sunbor:multiSelectCheckbox>
					</td>
					<%-- 通知方式--%>
					<td class="td_normal_title" width="15%">
						<bean:message bundle="sys-task" key="sysTaskFeedback.fdNotifyWay" />
					</td>
					<td width="35%"><kmss:editNotifyType  property="fdNotifyWay" /></td>
				</tr>	
			</table>
				 <style type="text/css" media="all">
					.imageSlider { margin:0;padding:0; height:20px; width:285px; background-image:url("${LUI_ContextPath}/sys/task/images/horizBg.png"); }
					.imageBar    { margin:0;padding:0; height:15px; width:14px; background-image:url("${LUI_ContextPath}/sys/task/images/horizSlider.png"); }
	 			</style>
				<script type="text/javascript" src="${LUI_ContextPath}/sys/task/js/slider_extras.js"></script>
				<script type="text/javascript">
					var progress;
					var currentProgress = "0";
					//没有子任务才可以手动更新进度
					if('${childSize}'== 0){
						//进度条
						var sliderImage = new neverModules.modules.slider({
							targetId: "sliderProcess",
							sliderCss: "imageSlider",
							barCss: "imageBar",
							min: 0,
							max: 100,
							hints: ""
						});
						sliderImage.onstart= function () {
							document.getElementsByName("fdProgress")[0].value = sliderImage.getValue();
						};
						sliderImage.onchange = function () {
							document.getElementsByName("fdProgress")[0].value = sliderImage.getValue();
						};
						sliderImage.onend = function () {
							document.getElementsByName("fdProgress")[0].value = sliderImage.getValue();
						};
						sliderImage.create();
						LUI.ready(function(){
							setTimeout(function(){
								sliderImage.setValue(document.getElementsByName('fdProgress')[0].value);
							},1000);
						});
					}
					//提交表单
					window.commitMethod=function(commitType){
						var fdCompleteTime = document.getElementsByName("fdCompleteTime")[0].value;
						var fdCompleteDate = document.getElementsByName("fdCompleteDate")[0].value;
						document.getElementsByName("fdCompleteDateTime")[0].value = fdCompleteDate+" "+fdCompleteTime;
						Com_Submit(document.sysTaskFeedbackForm, commitType);
					};
					
				</script>	
				<script>
					progress = document.getElementsByName("fdProgress")[0].value;
					currentProgress = progress;

		            function setProgress(){
		                var value = document.getElementsByName('fdProgress')[0].value;
		                var type= /^[0-9]*[1-9][0-9]*$/;
		            	if(!type.test(value)){
		                    alert("请输入有效正整数");
		                    document.getElementsByName('fdProgress')[0].value = "0";
		                }
		            	sliderImage.setValue(document.getElementsByName('fdProgress')[0].value);
		            }
				</script>
			</div>
		</html:form>
	</template:replace>
	
</template:include>