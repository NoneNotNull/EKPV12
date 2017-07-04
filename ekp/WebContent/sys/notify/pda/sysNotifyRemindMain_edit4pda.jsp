<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request" />
<c:set var="sysNotifyRemindMainContextForm" value="${mainModelForm.sysNotifyRemindMainContextForm}" scope="request" />
<style type="text/css">
	
</style>
<%--移动端提醒页面--%>
<div id="sysNotifyRemind">
	<input  type="hidden" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdModelName" 
				value="${sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdModelName}"  />
	<input  type="hidden"  name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdNotifyType"  
				value="todo"/>
	<input  type="hidden" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdBeforeTime" 
				value="${sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdBeforeTime}"  />
	<input  type="hidden" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdTimeUnit" 
				value="${sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdTimeUnit}"  />
	<input type="hidden" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdId" 
				value="${sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdId}" />
	<input type="hidden" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdModelId" 
				value="${sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdModelId}" />
	<input type="hidden" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdKey" 
				value="${sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdKey}" />
  	<ul class="listBox">
          <li>
          	<h2><bean:message bundle="sys-notify"  key="sysNotify.remind.calendar" /></h2>
          </li>
          <%--不提醒--%>
          <li class="on" data="no;0">
          	<span class="title"><bean:message bundle="sys-notify"  key="sysNotify.remind.noRemind" /></span><i class="sele"></i>
          </li>
           <%--提前5分钟--%>
          <li data="minute;5">
          	<span class="title"><bean:message bundle="sys-notify"  key="sysNotify.remind.fiveMinutes" /></span><i class="sele"></i>
          </li>
           <%--提前15分钟--%>
          <li data="minute;15">
          	<span class="title"><bean:message bundle="sys-notify"  key="sysNotify.remind.fiftyMinutes" /></span><i class="sele"></i>
          </li>
          <%--提前30分钟--%>
          <li data="minute;30">
          	<span class="title"><bean:message bundle="sys-notify"  key="sysNotify.remind.thirtyMinutes" /></span><i class="sele"></i>
          </li>
           <%--提前1小时--%>
          <li data="hour;1">
          	<span class="title"><bean:message bundle="sys-notify"  key="sysNotify.remind.oneHour" /></span><i class="sele"></i>
          </li>
          <%--提前2小时--%>
          <li data="hour;2">
          	<span class="title"><bean:message bundle="sys-notify"  key="sysNotify.remind.twoHour" /></span><i class="sele"></i>
          </li>
          <%--提前1天--%>
          <li data=day;1>
          	<span class="title"><bean:message bundle="sys-notify"  key="sysNotify.remind.oneDay" /></span><i class="sele"></i>
          </li>
          <%--提前2天--%>
          <li data="day;2">
          	<span class="title"><bean:message bundle="sys-notify"  key="sysNotify.remind.twoDay" /></span><i class="sele"></i>
          </li>
          <%--提前1周--%>
          <li data="week;1">
          	<span class="title"><bean:message bundle="sys-notify"  key="sysNotify.remind.oneWeek" /></span><i class="sele"></i>
          </li>
      </ul>
 </div>
 <script>Com_IncludeFile("jquery.js",null,"js");</script>
<script type="text/javascript">
	var sysNotifyRemindLANG={
		"no;0":'<bean:message bundle="sys-notify"  key="sysNotify.remind.noRemind" />',
		'minute;5':'<bean:message bundle="sys-notify"  key="sysNotify.remind.fiveMinutes" />',
		'minute;15':'<bean:message bundle="sys-notify"  key="sysNotify.remind.fiftyMinutes" />',
		'minute;30':'<bean:message bundle="sys-notify"  key="sysNotify.remind.thirtyMinutes" />',
		'hou;1':'<bean:message bundle="sys-notify"  key="sysNotify.remind.oneHour" />',
		'hou;2':'<bean:message bundle="sys-notify"  key="sysNotify.remind.twoHour" />',
		'day;1':'<bean:message bundle="sys-notify"  key="sysNotify.remind.oneDay" />',
		'day;2':'<bean:message bundle="sys-notify"  key="sysNotify.remind.twoDay" />',
		'week;1':'<bean:message bundle="sys-notify"  key="sysNotify.remind.oneWeek" />'
	};
	//初始化
	function initSysNotifyRemind(){
		var rtnValue={"value":"","text":""};
		if("${sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0]}"!=null
				&&"${sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0]}"!=""){
			rtnValue.value="${sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdTimeUnit}"
				+";${sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdBeforeTime}";
			rtnValue.text=sysNotifyRemindLANG[rtnValue.value];
		}else{
			rtnValue.value="no;0";
			rtnValue.text=sysNotifyRemindLANG[rtnValue.value];
		}
		//用户自定义回调函数,可不实现
		if(window["init_sysNotifyRemind_${param.formName}_callback"]){
			window["init_sysNotifyRemind_${param.formName}_callback"](rtnValue);
		}
	}
	initSysNotifyRemind();
	//提醒选择
	$("#sysNotifyRemind li").click(function(){
		$("#sysNotifyRemind li").removeClass("on");
		$(this).addClass("on");
		var selectValue=$(this).attr("data");
		var selectText=$(this).children("span").text();
		var unit=selectValue.split(";")[0];
		if(unit=="no"){
			$("#sysNotifyRemind [name='sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdModelName']").val("");
		}else{
			var beforeTime=selectValue.split(";")[1];
			$("#sysNotifyRemind [name='sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdTimeUnit']").val(unit);
			$("#sysNotifyRemind [name='sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdBeforeTime']").val(beforeTime);
			$("#sysNotifyRemind [name='sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[0].fdModelName']").val("${param.fdModelName}");
		}
		var rtnValue={"value":selectValue,"text":selectText};
		//用户自定义回调函数，可不实现
		if(window["submit_sysNotifyRemind_${param.formName}_callback"]){
			window["submit_sysNotifyRemind_${param.formName}_callback"](rtnValue);
		}
	});
</script>