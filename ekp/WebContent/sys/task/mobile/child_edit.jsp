<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.edit" compatibleMode="true">
	<%--标签页标题--%>
	<template:replace name="title">
		<c:choose>
			<c:when test="${ sysTaskMainForm.method_GET == 'addChildTask' }">
				<c:out value="${ lfn:message('sys-task:button.sub.task') }"></c:out>	
			</c:when>
			<c:otherwise>
				<c:out value="${sysTaskMainForm.docSubject}"></c:out>
			</c:otherwise>
		</c:choose>
	</template:replace>
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/sys/task/mobile/resource/css/edit.css" />
		<link rel="Stylesheet" href="${LUI_ContextPath}/sys/mobile/css/themes/default/header.css" />
		<link rel="Stylesheet" href="${LUI_ContextPath}/sys/mobile/css/themes/default/nav.css" />
	</template:replace>
	<template:replace name="content"> 
		<html:form action="/sys/task/sys_task_main/sysTaskMain.do">
			<html:hidden property="fdId" />
			<html:hidden property="docStatus" />
			<html:hidden property="fdRootId" />
			<html:hidden property="docCreatorId" />
			<html:hidden property="docCreateTime"/>
			<html:hidden property="fdWorkId" />
			<html:hidden property="fdPhaseId" />
			<html:hidden property="fdModelId" /> 
			<html:hidden property="fdModelName" />
			<html:hidden property="fdKey" />
			<html:hidden property="fdStatus" />
			
			<div data-dojo-type="mui/view/DocScrollableView" id="scrollView" class="gray" data-dojo-mixins="mui/form/_ValidateMixin">
				<div class="muiImportBox">
					<%-- rtf --%>
					<div data-dojo-type="mui/form/Editor"
						 data-dojo-mixins="sys/task/mobile/resource/js/EditorMixin" 
						 data-dojo-props="name:'docContent',placeholder:'任务内容',plugins:['face','image','${LUI_ContextPath}/sys/task/mobile/resource/js/RtfAttachmentPlugin.js']" 
						 class="muiEditor" >
					</div>
					<%-- 附件区域,嵌入rtf的操作栏中 --%>
					<div id='attachmentView' class="attachmentView">
						<c:import url="/sys/attachment/mobile/import/edit.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="sysTaskMainForm"></c:param>
							<c:param name="fdKey" value="attachment"></c:param>
						</c:import> 
					</div>
				</div>
				<div class="muiHeader muiTaskHeader">
					<div
						data-dojo-type="mui/nav/MobileCfgNavBar" 
						data-dojo-mixins="sys/task/mobile/resource/js/NavBarMixin"
						data-dojo-props="defaultUrl:'/sys/task/mobile/edit_nav.jsp',height:'6rem',scrollDir:''"
						class="muiTaskNavBar">
					</div>
				</div>
				
				<%-- 时间 --%>
				<div id="dateView" data-dojo-type="dojox/mobile/View">
				
					<div data-dojo-type="mui/nav/MobileCfgNavBar" 
						data-dojo-props="defaultUrl:'/sys/task/mobile/edit_date_nav.jsp'"
						class="sysTaskNavBar">
					</div>
					<div class="muiTaskDatetimeContainer">
						<div class="muiTaskDatetime">	
							<xform:datetime property="fdPlanCompleteDate" dateTimeType="date" mobile="true" showStatus="edit" required="true"
								htmlElementProperties="id='fdPlanCompleteDate'"></xform:datetime>
						</div>
						<div class="muiTaskWeek"></div>
						<div class="muiTaskDatetime">	
							<xform:datetime property="fdPlanCompleteTime" dateTimeType="time" mobile="true" showStatus="edit" required="true"
								htmlElementProperties="id='fdPlanCompleteTime'"></xform:datetime>
						</div>
					</div>
				</div>
				
				<%-- 人员 --%>
				<div id="personView" data-dojo-type="dojox/mobile/View">
					<ul class="muiSettingPeopleList">
						<%--负责人--%>
						<li>
							<bean:message bundle="sys-task" key="sysTaskMainPerform.fdPerformId" />
							<xform:address propertyId="fdPerformId" propertyName="fdPerformName" style="width:80%" showStatus="edit" 
								subject="${lfn:message('sys-task:sysTaskMainPerform.fdPerformId') }"
								orgType='ORG_TYPE_PERSON' mulSelect="true" mobile="true" required="true"></xform:address>
						</li>
						<%--指派人--%>
						<li>
							<bean:message bundle="sys-task" key="sysTaskMain.fdAppoint" />
							<xform:address propertyId="fdAppointId" propertyName="fdAppointName" style="width:80%" showStatus="edit"
								orgType='ORG_TYPE_PERSON' mobile="true"></xform:address>
						</li>
						<%--抄送人--%>
						<li>
							<bean:message bundle="sys-task" key="sysTaskMainCc.fdCcId" />
							<xform:address propertyId="fdCcIds" propertyName="fdCcNames" style="width:80%" showStatus="edit"
								orgType='ORG_TYPE_ALL' mulSelect="true" mobile="true"></xform:address>
						</li>
					</ul>
				</div>
				
				<%-- 同步 --%>
				<div id="syncView" class="syncView" data-dojo-type="dojox/mobile/View">
					 <xform:radio property="syncDataToCalendarTime" showStatus="edit" mobile="true">
			       		<xform:enumsDataSource enumsType="sysTaskMain_syncDataToCalendarTime" />
					</xform:radio>
					<c:import url="/sys/agenda/mobile/general_edit.jsp"	charEncoding="UTF-8">
				    	<c:param name="formName" value="sysTaskMainForm" />
				    	<c:param name="fdKey" value="taskMainDoc" />
				    	<c:param name="fdPrefix" value="sysAgendaMain_general_edit" />
				    	<c:param name="fdModelName" value="com.landray.kmss.sys.task.model.SysTaskMain" />
				    	<%--可选字段 1.syncTimeProperty:同步时机字段； 2.noSyncTimeValues:当syncTimeProperty为此值时，隐藏同步机制 --%>
						<c:param name="syncTimeProperty" value="syncDataToCalendarTime" />
						<c:param name="noSyncTimeValues" value="noSync" />
				 	</c:import>
				</div>
				
				<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom" data-dojo-props='fill:"grid"'>
				  	<li data-dojo-type="mui/back/BackButton"
				  		data-dojo-props="edit:true"></li>
					<%--addChildTask页面的按钮--%>
					<c:if test="${ sysTaskMainForm.method_GET == 'addChildTask' }">
						<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnSubmit " 
					  		data-dojo-props='colSize:2,href:"javascript:commitMethod(\"save\",\"false\");",transition:"slide"'>
					  		<i class="mui mui-right"></i>提交
					  	</li>
					</c:if>
					<%--edit页面的按钮--%>
					<c:if test="${ sysTaskMainForm.method_GET == 'edit' }">
						<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnSubmit " 
					  		data-dojo-props='colSize:2,href:"javascript:commitMethod(\"update\",\"false\");",transition:"slide"'>
					  		<i class="mui mui-right"></i>更新
					  	</li>
					</c:if>
				   	<li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:'mui mui-more'">
				    	<div data-dojo-type="mui/back/HomeButton"></div>
				   	</li>
				</ul>
			</div>
			
			
			<!-- 移动端先不考虑这些选项 -->
			<html:hidden property="isDivide" />
			<html:hidden property="fdResolveFlag" />
			<html:hidden property="fdProgressAuto" />
			<html:hidden property="fdProgress" />
			
			<html:hidden property="fdParentId"/>
			<c:choose> 
				<%--任务来源 --%>
				<c:when test="${not empty sysTaskMainForm.fdSourceSubject && not empty sysTaskMainForm.fdSourceUrl}">
					<html:hidden property="fdSourceSubject"/>
					<html:hidden property="fdSourceUrl"/>
				</c:when>
				<c:when test="${not empty sysTaskMainForm.fdSourceSubject && empty sysTaskMainForm.fdSourceUrl}">
					<html:hidden property="fdSourceSubject"/>
					<html:hidden property="fdSourceUrl"/>
				</c:when>
			</c:choose>
			<c:choose>
				<%--任务类型--%>
				<c:when test="${sysTaskMainForm.fdParentId != null}">
					<html:hidden property="fdCategoryId"/>
					<%--权重--%>
					<html:hidden property="fdWeights"/>
					<html:hidden property="fdOtherChildWeights" />
				</c:when>
				<c:otherwise>
					<html:hidden property="fdCategoryId"/>
				</c:otherwise>
			</c:choose>
			<%--通知方式 --%>
			<span style="display: none;">
				<kmss:editNotifyType property="fdNotifyType" />
			</span>
			
		</html:form>
	</template:replace>
</template:include>
<script type="text/javascript">
require(["mui/form/ajax-form!sysTaskMainForm"]);
require(['dojo/ready','dojo/date/locale','dojo/query','dojo/topic','dijit/registry','dojo/date','mui/dialog/Tip'],
		function(ready,locale,query,topic,registry,dateClz,Tip){
	//校验对象
	var validorObj=null;
	
	ready(function(){
		//初始化星期
		_setWeek();
		validorObj=registry.byId('scrollView');
	});
	
	//提交
	window.commitMethod=function(commitType, saveDraft){
		if(validorObj.validate() && validateTime()){
			var formObj = document.sysTaskMainForm;
			var docStatus = document.getElementsByName("docStatus")[0];
			if(saveDraft=="true"){
				docStatus.value="10";
			}else{
				docStatus.value="20";
			}
			if('save'==commitType){
				Com_Submit(formObj, commitType,'fdId');
		    }else{
		    	Com_Submit(formObj, commitType); 
		    }
		}
	};
	//提交后返回查看页面
	Com_Submit.ajaxAfterSubmit=function(){
		setTimeout(function(){
			window.location='${LUI_ContextPath}/sys/task/sys_task_main/sysTaskMain.do?method=view&fdId=${sysTaskMainForm.fdParentId}';
		},2000);
		
	};
	
	function validateTime(){
		var dateStr=query('[name="fdPlanCompleteDate"]')[0].value+' '+query('[name="fdPlanCompleteTime"]')[0].value,
			date=locale.parse(dateStr,{selector : 'time',timePattern : 'yyyy-MM-dd HH:mm'});
		//完成时间不能早于今天
		if(dateClz.compare(date,new Date()) <= 0){
			Tip.fail({text: '<bean:message key="sys-task:sysTaskMain.min" argKey0="sys-task:sysTaskMain.fdPlanCompleteTime" argKey1="sys-task:sysTaskMain.fdCurrentTime" />'});
			return false;
		}
		//完成时间不能晚于父任务完成时间
		var parentDateStr='${sysTaskMainForm.fdParentPlanCompleteDate}'+' '+'${sysTaskMainForm.fdParentPlanCompleteTime}',
			parentDate=locale.parse(parentDateStr,{selector : 'time',timePattern : 'yyyy-MM-dd HH:mm'});
		if(dateClz.compare(date,parentDate) >= 0){
			var tipText='<bean:message bundle="sys-task" key="sysTaskMain.ChildNotLateThanFather"/><br/>'+
						'(<bean:message bundle="sys-task" key="sysTaskMain.parent.fdPlanCompleteTime"/>:'+parentDateStr+')';
			Tip.fail({ text:tipText,time:5000 });
			return false;
		}
		return true;
	}
	
	//设置星期
	function _setWeek(){
		var dateStr=query('[name="fdPlanCompleteDate"]')[0].value+' '+query('[name="fdPlanCompleteTime"]')[0].value;
		var date=locale.parse(dateStr,
			{
				selector : 'time',
				timePattern : 'yyyy-MM-dd HH:mm'
			});
		query('.muiTaskWeek')[0].innerHTML=calendarNameArray[date.getDay()];
	}
	
	//设置日期
	var calendarNameArray='${lfn:message("calendar.week.names")}'.split(',');//calendar.week.shortNames=日,一,二,三,四,五,六
	function _setDate(datetype){
		var date=new Date();
		switch(datetype){
			case 1:date.setDate(date.getDate());break;
			case 2:date.setDate(date.getDate()+1);break;
			case 3:date.setDate(date.getDate()+2);break;
			case 4:date.setDate(date.getDate()+7);break;
			case 5:date.setMonth(date.getMonth()+1);break;
		}
		registry.byId('fdPlanCompleteDate').set("value",locale.format(date,{
			selector : 'time',
			timePattern : 'yyyy-MM-dd'
		}));
		registry.byId('fdPlanCompleteTime').set("value",locale.format(date,{
			selector : 'time',
			timePattern : 'HH:mm'
		}));
		_setWeek();
	}
	
	//切换时间
	topic.subscribe('/mui/navitem/_selected',function(srcObj){
		if(srcObj.datetype){
			_setDate(srcObj.datetype)
		}
	});
	
	topic.subscribe('/mui/form/datetime/change',function(){
		//初始化星期
		_setWeek();
	});
	
	
});	


</script>