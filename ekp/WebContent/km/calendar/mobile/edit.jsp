<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/mobile/mui.tld" prefix="mui"%>
<template:include ref="mobile.edit" compatibleMode="true">

	<template:replace name="title">
		<c:if test="${empty kmCalendarMainForm.docSubject }">
			<bean:message bundle="km-calendar" key="kmCalendarMain.opt.create"/>
		</c:if>
	
		<c:if test="${not empty kmCalendarMainForm.docSubject }">
			<bean:message bundle="km-calendar" key="kmCalendarMain.opt.edit"/>
		</c:if>
		
	</template:replace>
	<template:replace name="head">
		<link rel="Stylesheet" href="${LUI_ContextPath}/sys/mobile/css/themes/default/header.css" />
		<link rel="Stylesheet" href="${LUI_ContextPath}/sys/mobile/css/themes/default/nav.css" />
		<link rel="stylesheet" type="text/css" href="${LUI_ContextPath}/km/calendar/mobile/resource/css/edit.css" />
		<mui:min-file name="mui-calendar.js"/>
	</template:replace>

	<template:replace name="content">
		<html:form action="/km/calendar/km_calendar_main/kmCalendarMain.do" >
			<html:hidden property="fdId" />
			<html:hidden property="docCreatorId" />
			<html:hidden property="docCreateTime" />
			<html:hidden property="fdRecurrenceStr" />
			<html:hidden property="fdType"  value="event"/>
			<html:hidden property="method_GET"/>
			
			<div class="gray" data-dojo-type="mui/view/DocScrollableView" id="scrollView" data-dojo-mixins="mui/form/_ValidateMixin">
				<div class="muiImportBox">
					<div data-dojo-type="mui/form/Textarea" class="docSubjectTextArea"
						data-dojo-props="name:'docSubject',value:'${kmCalendarMainForm.docSubject}',showStatus:'edit',subject:'内容',validate:'required maxLength(500)',placeholder:'内容',opt:false">
					</div>
					<div data-dojo-type="mui/form/Input" class="locationInput"
						data-dojo-props="name:'fdLocation',value:'${kmCalendarMainForm.fdLocation }',showStatus:'edit',subject:'地点',validate:'maxLength(200)',placeholder:'地点',opt:false">
					</div>
				</div>
				<div class="muiHeader muiCalendarHeader">
					<div
						data-dojo-type="mui/nav/MobileCfgNavBar" 
						data-dojo-mixins="km/calendar/mobile/resource/js/NavBarMixin"
						data-dojo-props="defaultUrl:'/km/calendar/mobile/edit_nav.jsp',height:'6rem',scrollDir:''"
						class="kmCalendarNavBar">
					</div>
				</div>
				
				<div id="dateView" data-dojo-type="dojox/mobile/View">
					<%-- 是否全天 --%>
					<div class="muiCalendarAllDay">
						<bean:message bundle="km-calendar" key="kmCalendarMain.allDay"/>
						<c:set var="allday" value="on"></c:set>
						<c:if test="${kmCalendarMainForm.fdIsAlldayevent == false }">
							<c:set var="allday" value="off"></c:set>
						</c:if>
						<div data-dojo-type="dojox/mobile/Switch"
							 data-dojo-mixins="km/calendar/mobile/resource/js/SwitchMixin"
							 data-dojo-props="leftLabel:'',rightLabel:'',value:'${allday}',property:'fdIsAlldayevent'"
							 class="kmCalendarSwitch">
						</div>
					</div>
					<%-- 开始时间 --%>
					<div class="muiCalendarDatetimeContainer">
						<div class="muiCalendarDateText">
							<bean:message bundle="km-calendar" key="kmCalendarMain.docStartTime"/>
						</div>
						<div class="muiCalendarDatetime">	
							<xform:datetime property="docStartTime" dateTimeType="date" mobile="true" showStatus="edit" className=""
								required="true" htmlElementProperties="id='docStartTime',class='dateTimeTransition'"></xform:datetime>
						</div>
						<div class="muiCalendarDatetime">	
							<html:hidden property="startHour"/>
							<html:hidden property="startMinute"/>
							<xform:datetime property="docStartHHmm" dateTimeType="time" mobile="true" showStatus="edit"
								required="true" htmlElementProperties="id='docStartHHmm'"></xform:datetime>
						</div>
					</div>
					<%-- 结束时间 --%>
					<div class="muiCalendarDatetimeContainer">
						<div class="muiCalendarDateText">
							<bean:message bundle="km-calendar" key="kmCalendarMain.docFinishTime"/>
						</div>
						<div class="muiCalendarDatetime">	
							<xform:datetime property="docFinishTime" dateTimeType="date" mobile="true" showStatus="edit" className="dateTimeTransition"
								required="true" htmlElementProperties="id='docFinishTime',class='dateTimeTransition'"></xform:datetime>
						</div>
						<div class="muiCalendarDatetime">	
							<html:hidden property="endHour"/>
							<html:hidden property="endMinute"/>
							<xform:datetime property="docFinishHHmm" dateTimeType="time" mobile="true" showStatus="edit"
								required="true" htmlElementProperties="id='docFinishHHmm'"></xform:datetime>
						</div>
					</div>
				
				</div>
				
				<div id="notifyView" data-dojo-type="dojox/mobile/View">
					<c:import url="/sys/notify/mobile/import/edit.jsp">
						<c:param name="formName" value="kmCalendarMainForm" />
				         <c:param name="fdKey" value="kmCalenarMainDoc" />
				         <c:param name="fdPrefix" value="event" />
				         <c:param name="fdModelName" value="com.landray.kmss.km.calendar.model.KmCalendarMain" />
					</c:import>
				</div>
				
				<div id="labelView" data-dojo-type="dojox/mobile/View">
					<div class="muiCalendarLabelContainer">
						<%-- 标签 
						<xform:select property="docLabel" showStatus="edit" mobile="true">
							<c:forEach var="label" items="${labels}" >
								<xform:simpleDataSource value="${label[0] }">
									<c:out value="${label[1] }"></c:out>
								</xform:simpleDataSource>
							</c:forEach>
						</xform:select>--%>
						<div data-dojo-type="mui/form/Select"
							 data-dojo-props="name:'labelId',mul:false,showStatus:'edit',subject:'标签',value:'${kmCalendarMainForm.labelId }',
							 store:[<c:forEach var="label" items="${labels}" varStatus="vs">
										{text:'${label[1] }',value:'${label[0]}'}
										<c:if test="${ vs.last==false }">,</c:if>
									</c:forEach>]" >
						</div>
						
					</div>
				</div>
				
				
				
				
				<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom" data-dojo-props='fill:"grid"'>
				  	<li data-dojo-type="mui/back/BackButton"
				  		data-dojo-props="doBack:window.doback,edit:true"></li>
					<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnSubmit " 
					  	data-dojo-props='colSize:2,href:"javascript:commitMethod(\"save\");",transition:"slide"'>
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
<script>
require(["mui/form/ajax-form!kmCalendarMainForm"]);
require(['dojo/query','dojo/topic','dijit/registry','dojo/ready','dojo/dom-style','dojo/dom-geometry','mui/dialog/Tip','mui/calendar/CalendarUtil'],
		function(query,topic,registry,ready,domStyle,domGeometry,Tip,cutil){
	
	//校验对象
	var validorObj=null;
	
	ready(function(){
		validorObj=registry.byId('scrollView');
		
		//全天,不显示type='time'的时间控件
		var fdIsAlldayevent=query('[name="fdIsAlldayevent"]')[0].value;
			startTimeWidget=registry.byId('docStartTime'),
			startHHmmWidget=registry.byId('docStartHHmm'),
			finishTimeWidget=registry.byId('docFinishTime'),
			finishHHmmWidget=registry.byId('docFinishHHmm');
		if(fdIsAlldayevent=='true'){
			hideHHmm();
		}else{
			showHHmm();
		}
		//初始化type='time'的时间控件
		var startHour=query('[name="startHour"]')[0].value || '00',
			startMinute=query('[name="startMinute"]')[0].value || '00',
			endHour=query('[name="endHour"]')[0].value || '00',
			endMinute=query('[name="endMinute"]')[0].value || '00';
		startHHmmWidget.set('value',startHour+':'+startMinute);
		finishHHmmWidget.set('value',endHour+':'+endMinute);
	});
	
	//切换全天时隐藏type='time'的时间控件
	topic.subscribe('km/calendar/statChanged',function(widget,value){
		if(value){
			hideHHmm();
		}else{
			showHHmm();
		}
	});
	
	//显示type='time'的时间控件
	function hideHHmm(){
		var startTimeWidget=registry.byId('docStartTime'),
			startHHmmWidget=registry.byId('docStartHHmm'),
			finishTimeWidget=registry.byId('docFinishTime'),
			finishHHmmWidget=registry.byId('docFinishHHmm');
		var w=domGeometry.getMarginSize(startHHmmWidget.domNode).w;
		//隐藏type='time'的时间控件
		domStyle.set(startHHmmWidget.domNode,'display','none');
		domStyle.set(finishHHmmWidget.domNode,'display','none');
		//修改type='date'的时间控件宽度
		//domStyle.set(startTimeWidget.domNode,'width',2*w+'px');
		//domStyle.set(finishTimeWidget.domNode,'width',2*w+'px');
	}
	
	//显示type='time'的时间控件
	function showHHmm(){
		var startTimeWidget=registry.byId('docStartTime'),
			startHHmmWidget=registry.byId('docStartHHmm'),
			finishTimeWidget=registry.byId('docFinishTime'),
			finishHHmmWidget=registry.byId('docFinishHHmm');
		var w=domGeometry.getMarginSize(startHHmmWidget.domNode).w;
		//修改type='date'的时间控件宽度
		//domStyle.set(startTimeWidget.domNode,'width',w+'px');
		//domStyle.set(finishTimeWidget.domNode,'width',w+'px');
		//隐藏type='time'的时间控件
		setTimeout(function(){
			domStyle.set(startHHmmWidget.domNode,'display','block');
			domStyle.set(finishHHmmWidget.domNode,'display','block');
		},500);
	}
	
	//type='time'的的时间控件发生变化
	topic.subscribe('/mui/form/datetime/change',function(widget){
		//开始时间变化
		if(widget.id=='docStartHHmm'){
			var _HHmm=widget.value.split(':');
			query('[name="startHour"]')[0].value=_HHmm[0];
			query('[name="startMinute"]')[0].value=_HHmm[1];
		}
		//结束时间变化
		if(widget.id=='docFinishHHmm'){
			var _HHmm=widget.value.split(':');
			query('[name="endHour"]')[0].value=_HHmm[0];
			query('[name="endMinute"]')[0].value=_HHmm[1];
		}
	});
	
	
	window.commitMethod=function(){
		if(___validate())
			Com_Submit(document.forms[0],'saveEvent');
	};
	
	function ___validate(){
		var result=validorObj.validate();
		var startTime=query('[name="docStartTime"]')[0].value+' '+query('[name="docStartHHmm"]')[0].value,
			endTime=query('[name="docFinishTime"]')[0].value+' '+query('[name="docFinishHHmm"]')[0].value;
		startTime=cutil.parseDate(startTime);
		endTime=cutil.parseDate(endTime);
		if(endTime.getTime() < startTime.getTime()){
			Tip.fail({
				text:'结束时间不能早于开始时间' 
			});
			return false;
		}
		return result;
	}
	
	window.doback=function(){
		window.location.href='${LUI_ContextPath}/km/calendar/mobile/index.jsp?moduleName=${param.moduleName}';
	};
	
	
});
</script>



