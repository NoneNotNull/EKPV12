<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="no">
	<%--标签页标题--%>
	<template:replace name="title">
		<c:out value="${lfn:message('sys-task:table.sysTaskOverrule')} - ${ lfn:message('sys-task:module.sys.task') }"></c:out>	
	</template:replace>
	
	<%--操作按钮--%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<c:choose>
				<%--add页面的按钮--%>
				<c:when test="${ sysTaskOverruleForm.method_GET == 'add' }">
					<ui:button text="${lfn:message('button.update') }" order="2" onclick="Com_Submit(document.sysTaskOverruleForm, 'save');">
					</ui:button>
				</c:when>
				<%--edit页面的按钮--%>
				<c:when test="${ sysTaskOverruleForm.method_GET == 'edit' }">
					<ui:button text="${lfn:message('button.update') }" order="2" onclick="Com_Submit(document.sysTaskOverruleForm, 'update');">
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
	
	<%--驳回表单--%>
	<template:replace name="content"> 
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
						<c:out value="${sysTaskOverruleForm.fdTaskName}"/>				
					</td>
				</tr>
				<tr>
					<%--任务进度--%>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-task" key="sysTaskOverrule.fdProgress"/>
					</td>
					<td width=85% colspan=3>
						<html:text style="width:25px" property="fdProgress" onchange="sliderImage.setValue(document.getElementsByName('fdProgress')[0].value)"/>%
						<div id="sliderProcess" style="height:15px;"></div>	
					</td>
				</tr>
				<tr>
					<%--驳回理由--%>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-task" key="sysTaskOverrule.fdReason"/>
					</td>
					<td width=85% colspan=3>
						<xform:textarea property="fdReason" validators="maxLength(1000000)" style="width:97%" required="true" isLoadDataDict="false"
							subject="${lfn:message('sys-task:sysTaskOverrule.fdReason')}" ></xform:textarea>
					</td>
				</tr>
				<tr>
					<%--通知类型--%>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-task" key="sysTaskOverrule.fdNotifyType"/>
					</td>
					<td width=85% colspan=3>
						<kmss:editNotifyType property="fdNotifyType" />
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
				<style type="text/css" media="all">
					.imageSlider { margin:0;padding:0; height:20px; width:285px; background-image:url("${LUI_ContextPath}/sys/task/images/horizBg.png"); }
					.imageBar    { margin:0;padding:0; height:15px; width:14px; background-image:url("${LUI_ContextPath}/sys/task/images/horizSlider.png"); }
				</style>
				<script type="text/javascript" src="${LUI_ContextPath}/sys/task/js/slider_extras.js"></script>
				<script type="text/javascript">
					Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js|xform.js",null,"js");
					var sliderImage = new neverModules.modules.slider({
						targetId: "sliderProcess",
						sliderCss: "imageSlider",
						barCss: "imageBar",
						min: 0,
						max: 100,
						hints: ""
					});
					sliderImage.onstart  = function () {
						document.getElementsByName('fdProgress')[0].value = sliderImage.getValue();
					};
					sliderImage.onchange = function () {
						document.getElementsByName('fdProgress')[0].value = sliderImage.getValue();
					};
					sliderImage.onend = function () {
						document.getElementsByName('fdProgress')[0].value = sliderImage.getValue();
					};
					sliderImage.create();
				</script>
				<script>
					LUI.ready(function(){
						setTimeout(function(){
							sliderImage.setValue(document.getElementsByName('fdProgress')[0].value);
						},1000);
					});
					$KMSSValidation(document.forms['sysTaskOverruleForm']);//加载校验框架
				</script>
			</div>
 		</html:form>
 	
	</template:replace>
	
</template:include>