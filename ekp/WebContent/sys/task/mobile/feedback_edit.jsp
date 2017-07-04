<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.edit" compatibleMode="true">
	<template:replace name="title">
		<c:out value="${lfn:message('sys-task:tag.feedback') }"></c:out>
	</template:replace>
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/sys/task/mobile/resource/css/edit.css" />
	</template:replace>
	<template:replace name="content"> 
		<html:form action="/sys/task/sys_task_feedback/sysTaskFeedback.do">
			<html:hidden property="fdId"/>
			<html:hidden property="fdTaskId"/>
			<html:hidden property="fdCompleteDateTime"/>
			<html:hidden property="method_GET"/>
			<div style="display: none">
				<sunbor:multiSelectCheckbox formName="sysTaskFeedbackForm"  enumsType="sysTaskFreedback_fdNotifyType" property="fdNotifyTypeList"></sunbor:multiSelectCheckbox>
				<kmss:editNotifyType  property="fdNotifyWay" />
			</div>
			
			<div class="gray" data-dojo-type="mui/view/DocScrollableView" id="scrollView" data-dojo-mixins="mui/form/_ValidateMixin">
				<div class="muiTaskTitle">
					<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.docSubject}"/>
				</div>
				<div class="muiImportBox">
					
					<%-- rtf --%>
					<div data-dojo-type="mui/form/Editor" 
						 data-dojo-props="name:'docContent',placeholder:'完成情况描述',plugins:['face','image','${LUI_ContextPath}/sys/task/mobile/resource/js/RtfAttachmentPlugin.js']" 
						 class="muiEditor" >
					</div>
					<%-- 附件区域,嵌入rtf的操作栏中 --%>
					<div id='attachmentView' class="attachmentView">
						<c:import url="/sys/attachment/mobile/import/edit.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="sysTaskFeedbackForm"></c:param>
							<c:param name="fdKey" value="attachment"></c:param>
						</c:import> 
					</div>
					
				</div>
				<div class="muiProgressBox">
					<c:import url="/sys/task/mobile/import/status.jsp">
						<c:param name="status" value="${fdStatus}"></c:param>
					</c:import>
					<%-- 超期X天 --%>
					<div class="overday">
						超期<span class="overdayDuration numberBox"></span>天
					</div>
					<%-- 截止时间 --%>
					<div class="time"></div>
					<div class="progressAuto">
						<%-- #11654 移除“自动根据子任务更新进度 ”,为兼容旧数据,暂时保留字段 --%>
						<html:hidden property="fdProgressAuto" value="true"/>
					</div>
					<%-- 进度 --%>
					<input data-dojo-type="dojox/mobile/Slider" 
						data-dojo-mixins="sys/task/mobile/resource/js/_ProgressSliderMixin"
						data-dojo-props="valueText:${sysTaskFeedbackForm.fdProgress }"
						id="progress" name="fdProgress" class="progress"/>
					<div class="progressAutoText">
						<i class="mui mui-Bulb"></i>
						<bean:message bundle="sys-task" key="sysTaskMain.fdProgressAuto" />
					</div>
					<div style="display: none;">
						<sunbor:multiSelectCheckbox formName="sysTaskFeedbackForm"  enumsType="sysTaskFreedback_fdNotifyType" property="fdNotifyTypeList"></sunbor:multiSelectCheckbox>
						<kmss:editNotifyType  property="fdNotifyWay" />
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
require(["mui/form/ajax-form!sysTaskFeedbackForm"]);
require(['dojo/query','dojo/date/locale','dojo/date','dojo/topic','dijit/registry','dojo/ready','dojo/dom-style','dojo/dom-construct'],
		function(query,locale,date,topic,registry,ready,domStyle,domConstruct){
		
	//提交表单
	window.commitMethod=function(commitType){
		query('[name="fdCompleteDateTime"]')[0].value='${sysTaskFeedbackForm.fdCompleteDate}'+' '+'${sysTaskFeedbackForm.fdCompleteTime}';
		Com_Submit(document.sysTaskFeedbackForm, commitType);
	};
	//提交后返回查看页面
	Com_Submit.ajaxAfterSubmit=function(){
		setTimeout(function(){
			window.location='${LUI_ContextPath}/sys/task/sys_task_main/sysTaskMain.do?method=view&fdId=${sysTaskFeedbackForm.fdTaskId}';
		},2000)
	};
	
	ready(function(){
		if('${childSize}' > 0 ){
			//不可滑动
			var progressWidget=registry.byId('progress');
			progressWidget.setDisabled();
		}else{
			domStyle.set(query('.progressAutoText')[0],'display','none');
		}
	});
	
	
	//完成时间
	var fdPlanComplete='${sysTaskFeedbackForm.sysTaskMainForm.fdPlanCompleteDate}'+' '+'${sysTaskFeedbackForm.sysTaskMainForm.fdPlanCompleteTime}';//截止时间
	fdPlanComplete=parseDate(fdPlanComplete);
	
	//是否显示超期X天
	if('${fdStatus}'!= '3' && '${fdStatus}'!= '6'){
		var now=new Date(),
		duration=date.difference(fdPlanComplete,now,'millisecond');
		if(duration>0){
			if(duration<1000*60*60*24){
				duration=1000*60*60*24;
			}
			duration=parseInt( duration/(24*60*60*1000) );
			query('.overdayDuration')[0].innerHTML=duration;
		}else{
			domStyle.set(query('.overday')[0],'display','none');
		}
	}else{
		domStyle.set(query('.overday')[0],'display','none');
	}
	
	//截止日期倒计时
	var Timer=setInterval(_setInterval,1000);
	function _setInterval(){
		var now=new Date(),
			duration=date.difference(now,fdPlanComplete,'millisecond');
		domConstruct.empty(query('.time')[0]);
		if(duration >= 1000*60){
			var day=parseInt( duration/(24*60*60*1000) ),
				hour=parseInt( duration % (24*60*60*1000) /(60*60*1000) ),
				minute=parseInt (duration % (60*60*1000) / (60*1000) ),
				second=parseInt (duration % (60*1000) / 1000 );
			domConstruct.create('span',{innerHTML:'还有'},query('.time')[0]);
			if(day > 0){
				domConstruct.create('span',{className:'numberBox',innerHTML:day},query('.time')[0]);
				domConstruct.create('span',{innerHTML:'天'},query('.time')[0]);
			}
			if(hour < 10){
				hour="0"+hour;
			}
			domConstruct.create('span',{className:'numberBox',innerHTML:hour},query('.time')[0]);
			domConstruct.create('span',{innerHTML:':'},query('.time')[0]);
			if(minute < 10){
				minute="0"+minute;
			}
			domConstruct.create('span',{className:'numberBox',innerHTML:minute},query('.time')[0]);
			domConstruct.create('span',{innerHTML:':'},query('.time')[0]);
			if(second <10){
				second="0"+second;
			}
			domConstruct.create('span',{className:'numberBox',innerHTML:second},query('.time')[0]);
		}else{
			Timer=null;
		}
	}
	_setInterval();
	
	//String类型转化为Date类型
	function parseDate(/*String*/ date){
		return locale.parse(date,{
			selector : 'time',
			timePattern : 'yyyy-MM-dd HH:mm'//先写死,不考虑国际化
		});
	}
});
</script>