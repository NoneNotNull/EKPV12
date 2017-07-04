<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import="java.util.Date,java.util.Calendar,com.landray.kmss.util.*"%>
<%
	Calendar calendar = Calendar.getInstance();
	calendar.setTime(new Date());
	calendar.add(Calendar.MONTH, -1);//月份减一
	String today=DateUtil.convertDateToString(calendar.getTime(),DateUtil.PATTERN_DATE);
%>
<template:include ref="default.dialog">
   <template:replace name="content">
   	<script>
		seajs.use(['lui/dialog','lui/jquery'], function(dialog,$){
			window.clickCheckbox=function(self){
				var check=$(self).prop("checked");
				if(check){
					$("#updateAuthDate").show();
				}else{
					$("#updateAuthDate").hide();
				}
			};
			//保存共享设置
			window.saveKmCalendarAuth=function(formObj,method){
				var updateAuth=document.getElementsByName("updateAuth")[0];
				if(updateAuth.checked==true){
					var startDate=document.getElementsByName("startDate")[0];
					if(startDate.value==null||startDate.value==""){
						dialog.alert("起始时间不能为空!");
						return;
					}
					document.getElementsByName("updateAuth")[0].value=true;
				}
				Com_Submit(formObj, method);
			};
		});
	</script>
    <html:form action="/km/calendar/km_calendar_auth/kmCalendarAuth.do">
    <br/><p class="txttitle">${lfn:message('km-calendar:sysCalendarShareGroup.persons')}</p>
    <table class="tb_normal" width="95%" style="font-size: 12px;">
    	<tr>
    		<%--允许以下人员创建我的日程安排--%>
    		<td width="28%" class="td_normal_title">
    			${lfn:message('km-calendar:sysCalendarShareGroup.canCreate')}
    		</td>
    		<td>
    			<xform:address propertyId="authEditorIds" propertyName="authEditorNames" 
    				mulSelect="true" orgType="ORG_TYPE_ALLORG" textarea="true" style="width:98%"/>
    		</td>
    	</tr>
    	<tr>
    		<%--允许以下人员阅读我的日程安排--%>
    		<td width="28%" class="td_normal_title">
    			${lfn:message('km-calendar:sysCalendarShareGroup.canRead')}
    		</td>
    		<td>
    			<xform:address propertyId="authReaderIds" propertyName="authReaderNames" 
    				mulSelect="true" orgType="ORG_TYPE_ALLORG" textarea="true" style="width:98%" />
    		</td>
    	</tr>
    	<tr>
    		<%--允许以下人员维护我的日程安排--%>
    		<td width="28%" class="td_normal_title">
    			${lfn:message('km-calendar:sysCalendarShareGroup.canEdit')}
    		</td>
    		<td>
    			<xform:address propertyId="authModifierIds" propertyName="authModifierNames" 
    				mulSelect="true" orgType="ORG_TYPE_ALLORG" textarea="true" style="width:98%"/>
    		</td>
    	</tr>
    	<tr height="50">
    		<td colspan="2" width="100%" class="td_normal_title">
    			<input type="checkbox" name="updateAuth"  onclick="clickCheckbox(this)"/>${lfn:message('km-calendar:sysCalendarShareGroup.updateAuth')}
    			<span id="updateAuthDate" style="margin-left: 5px;display: none;">
    				${lfn:message('km-calendar:sysCalendarShareGroup.updateAuthDate')}
    				<xform:datetime property="startDate"  value="<%=today%>" dateTimeType="date"  style="width:15%;"/>
    			</span>
    		</td>
    	</tr>
    </table>
    <div style="text-align: center;padding-top: 10px;">
   		<ui:button  text="${lfn:message('button.save')}"  onclick="saveKmCalendarAuth(document.kmCalendarAuthForm, 'update');" style="width:70px;"/>
   	</div>
    </html:form>
    </template:replace>

</template:include>
