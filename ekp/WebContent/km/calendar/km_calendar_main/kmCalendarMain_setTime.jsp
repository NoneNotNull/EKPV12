<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import="java.util.Date, java.util.Calendar,com.landray.kmss.util.*"%>
<% 
	Calendar calendar = Calendar.getInstance();
	calendar.setTime(new Date());
	calendar.add(Calendar.MONTH, -1);//月份减一
	String startTime = DateUtil.convertDateToString(calendar.getTime(),DateUtil.TYPE_DATE, request.getLocale());
	String endTime = DateUtil.convertDateToString(new Date(),DateUtil.TYPE_DATE, request.getLocale());
%>
<template:include ref="default.dialog">
	<template:replace name="content" >
		<script>
			seajs.use(['lui/dialog', 'lui/jquery'],function(dialog,$) {
				//未勾选的标签
				var exceptLabelIds="";
				window.clickCheckbox=function(self){
					var isCheck=$(self).prop('checked');
					if(isCheck){
						exceptLabelIds=exceptLabelIds.replace($(self).val(),"");
					}else{
						exceptLabelIds+=$(self).val()+",";
					}
				};
				//确认
				window.clickOk=function(){
					var startTime=document.getElementsByName("startTime")[0];
					if(startTime.value==null||startTime.value==""){
						dialog.alert("<kmss:message key='errors.required' argKey0='km-calendar:kmCalendarMain.docStartTime' />");
						return;
					}
					var endTime=document.getElementsByName("endTime")[0];
					if(endTime.value==null||endTime.value==""){
						dialog.alert("<kmss:message key='errors.required' argKey0='km-calendar:kmCalendarMain.docFinishTime' />");
						return;
					}
					//var form=document.getElementById("form");
					//form.submit();
					var url="${LUI_ContextPath}/km/calendar/km_calendar_main/kmCalendarMain.do?method=exportCalendar&type=${param.type}";
					url+="&startTime="+startTime.value+"&endTime="+endTime.value;
					//群组ID(导出群组日程时必需)
					if("${param.groupId}"!=""){
						url+="&groupId=${param.groupId}";
					}
					//未选中标签ID(导出个人日程时必需)
					if(exceptLabelIds!=""){
						url+="&exceptLabelIds="+exceptLabelIds;
					}
					$dialog.hide();
					window.open(url);
				};
			});
		</script>
		<html:form styleId="form" action="/km/calendar/km_calendar_main/kmCalendarMain.do?method=exportCalendar&type=${param.type}">
		<c:if test="${param.type=='groupCalendar' }">
			<div style="height: 50px;"></div>
		</c:if>
		<c:if test="${param.type=='myCalendar' }">
			<div style="height: 20px;"></div>
		</c:if>
		<div style="margin:0px auto;text-align: center;">
			<div class="txttitle">
				<bean:message bundle="km-calendar" key="kmCalendarMain.setTimeTitle" />
			</div>
			<br/>
			<table id="Table_Main" class="tb_normal"width="80%"align="center">
				<%--导出开始时间--%>
				<tr>
					<td class="td_normal_title">
						<bean:message	bundle="km-calendar" key="kmCalendarMain.setTimeTitle.startTime" />
					</td>
					<td width="70%">
						<xform:datetime property="startTime" style="width:98%;" value="<%=startTime%>" showStatus="edit" dateTimeType="date"></xform:datetime>
					</td>
				</tr>
				<%--导出结束时间--%>
				<tr>
					<td class="td_normal_title">
						<bean:message	bundle="km-calendar" key="kmCalendarMain.setTimeTitle.endTime" />
					</td>
					<td width="70%">
						<xform:datetime property="endTime" style="width:98%;" value="<%=endTime%>" showStatus="edit" dateTimeType="date"></xform:datetime>
					</td>
				</tr>
				<%--所选标签--%>
				<c:if test="${param.type=='myCalendar' }">
					<tr>
						<td class="td_normal_title">
							<bean:message	bundle="km-calendar" key="kmCalendarMain.docLabel" />
						</td>
						<td width="70%">
							<ui:dataview id="label_checkbox">
								<ui:source type="AjaxJson">
									{url:'/km/calendar/km_calendar_label/kmCalendarLabel.do?method=listJson'}
								</ui:source>
								<ui:render type="Template">
									<c:import url="/km/calendar/tmpl/label_checkbox.jsp" charEncoding="UTF-8"></c:import>
								</ui:render>
							</ui:dataview>
						</td>
					</tr>					
				</c:if>
				<tr>
					<td colspan="2" align="center" >
						<ui:button text="${lfn:message('button.ok') }" onclick="clickOk();" >
						</ui:button>&nbsp;
						<ui:button  text="${lfn:message('button.cancel') }" onclick="window.$dialog.hide(null);" styleClass="lui_toolbar_btn_gray">
						</ui:button>
					</td>
				</tr>
			</table>
			
		</div>	
		</html:form>
	</template:replace>
</template:include>