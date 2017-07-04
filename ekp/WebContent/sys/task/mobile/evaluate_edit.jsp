<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.edit" compatibleMode="true">
	<template:replace name="title">
		<c:out value="${lfn:message('sys-task:button.evaluate') }"></c:out>
	</template:replace>
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/sys/task/mobile/resource/css/edit.css" />
	</template:replace>
	<template:replace name="content"> 
		<html:form action="/sys/task/sys_task_evaluate/sysTaskEvaluate.do">
			<html:hidden property="fdId"/>
			<html:hidden property="fdTaskId"/>
			<html:hidden property="method_GET"/>
			<div class="gray" data-dojo-type="mui/view/DocScrollableView" id="scrollView" data-dojo-mixins="mui/form/_ValidateMixin">
				<div class="muiTaskTitle">
					<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.docSubject}"/>
				</div>
				<div class="muiImportBox">
					<div data-dojo-type="mui/form/Editor" 
						data-dojo-props="name:'docContent',placeholder:'评价说明',fdModelId:'${sysTaskEvaluateForm.fdId }',fdModelName:'com.landray.kmss.sys.task.model.SysTaskEvaluate'"
						id="docContent" class="muiEditor">
					</div>
					<%--
					<xform:rtf property="docContent" mobile="true" placeholder="评价说明"></xform:rtf>
					 --%>
					
				</div>
				<div class="muiEvaluateBox">
					<c:import url="/sys/task/mobile/import/status.jsp">
						<c:param name="status" value="${sysTaskEvaluateForm.sysTaskMainForm.fdStatus}"></c:param>
					</c:import>
					
					<div class="EvaluateApprove">
						<kmss:radioTag property="fdApproveId"  serviceBean="sysTaskApproveService" mobile="true"
							selectBlock ="sysTaskApprove.fdId,sysTaskApprove.fdApprove" whereBlock = "sysTaskApprove.fdIsAvailable = 1" orderBy="sysTaskApprove.fdOrder asc"></kmss:radioTag>
					</div>
				</div>
					
				<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom" data-dojo-props='fill:"grid"'>
				  	<li data-dojo-type="mui/back/BackButton"></li>
				  	<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnSubmit " 
				  		data-dojo-props='colSize:2,href:"javascript:window.commitMethod(\"save\");",transition:"slide"'>
				  			<i class="mui mui-right"></i>提交
				  	</li>
				   	<li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:'mui mui-more'">
				    	<div data-dojo-type="mui/back/HomeButton"></div>
				   	</li>
				</ul>
			</div>
		</html:form>
	</template:replace>
</template:include>
<script type="text/javascript">
require(["mui/form/ajax-form!sysTaskEvaluateForm"]);
require(['dojo/query','dojo/date/locale','dojo/date','dojo/topic','dijit/registry','dojo/ready','mui/dialog/Tip'],
		function(query,locale,date,topic,registry,ready,Tip){
		
	//提交表单
	window.commitMethod=function(commitType){
		var content=registry.byId('docContent').get('value');
		content=content.replace(/(\s*$)/g, "");
		if(content == null || content == ""){
			Tip.fail({
				text:"<bean:message key='errors.required' argKey0='sys-task:sysTaskEvaluate.docContent'/>"
			});
			return ;
		}
		Com_Submit(document.sysTaskEvaluateForm, commitType);
	};
	//提交后返回查看页面
	Com_Submit.ajaxAfterSubmit=function(){
		setTimeout(function(){
			window.location='${LUI_ContextPath}/sys/task/sys_task_main/sysTaskMain.do?method=view&fdId=${sysTaskEvaluateForm.fdTaskId}';
		},2000);
		
		
	};
	
});
</script>