<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<kmss:windowTitle
	subjectKey="sys-notify:sysNotifyTodo.param.config"
	moduleKey="sys-notify:table.sysNotifyTodo" />

<html:form action="/sys/notify/sys_notify_todo/sysNotifyConfig.do" onsubmit="return validateAppConfigForm(this);">
	<div id="optBarDiv">
		<input type=button value="<bean:message key="button.submit"/>" onclick="Com_Submit(document.sysAppConfigForm, 'update');">
	</div>

	<p class="txttitle">
		<bean:message bundle="sys-notify" key="sysNotifyTodo.param.config" />
	</p>
	<center>
		<table  class="tb_normal" width=95%>
			<tr>
				<td class="td_normal_title" width="20%">
					<bean:message bundle="sys-notify" key="sysNotifyTodo.clear.config" />
				</td>
				<td>
				<table class="tb_noborder" width=100%>
				<%--
					 <tr>
						<td class="td_normal_title">
							<bean:message bundle="sys-notify" key="sysNotifyTodo.clear.config.day" />
						</td>
						<td>
						<c:choose>
							<c:when test="${empty sysAppConfigForm.map.clearDay}">
								<input type="text" name="value(clearDay)" class="inputsgl"
									value="<%=com.landray.kmss.sys.notify.model.SysNotifyConfig.CLEAR_DAY%>" >
							</c:when>
							<c:otherwise>
								<html:text property="value(clearDay)" />
							</c:otherwise>
						</c:choose>
							<bean:message bundle="sys-notify" key="sysNotifyTodo.clear.config.day.info" />
						</td>
					</tr>
					<tr>
						<td class="td_normal_title">
							<bean:message bundle="sys-notify" key="sysNotifyTodo.clear.config.type" />
						</td>
						<td>
							<sunbor:enums property="value(clearType)" enumsType="sys_todo_clear_type" elementType="radio"/>
						</td>
					</tr>
					--%> 
					<tr>
						<td width="50%">
							<bean:message bundle="sys-notify" key="sysNotifyTodo.clear" />
							<c:choose>
								<c:when test="${empty sysAppConfigForm.map.fdClDayToView}">
									<input type="text" name="value(fdClDayToView)" class="inputsgl" > 
								</c:when>
								<c:otherwise>
									<html:text property="value(fdClDayToView)" />
								</c:otherwise>
							</c:choose>				
							<bean:message bundle="sys-notify" key="sysNotifyTodo.clear.fdClDayToView" />
						</td>
						<td>
							<bean:message bundle="sys-notify" key="sysNotifyTodo.clear" />
							<c:choose>
								<c:when test="${empty sysAppConfigForm.map.fdClDayTodo}">
									<input type="text" name="value(fdClDayTodo)" class="inputsgl" > 
								</c:when>
								<c:otherwise>
									<html:text property="value(fdClDayTodo)" />
								</c:otherwise>
							</c:choose>	 
							<bean:message bundle="sys-notify" key="sysNotifyTodo.clear.fdClDayTodo" />
						</td>			
					</tr> 
					<tr>
						<td>
							<bean:message bundle="sys-notify" key="sysNotifyTodo.clear" />
							<c:choose>
								<c:when test="${empty sysAppConfigForm.map.fdClDayViewed}">
									<input type="text" name="value(fdClDayViewed)" class="inputsgl" > 
								</c:when>
								<c:otherwise>
									<html:text property="value(fdClDayViewed)" />
								</c:otherwise>
							</c:choose>	  
							<bean:message bundle="sys-notify" key="sysNotifyTodo.clear.fdClDayViewed" />
						</td> 
						<td>
							<bean:message bundle="sys-notify" key="sysNotifyTodo.clear" />
							<c:choose>
							<c:when test="${empty sysAppConfigForm.map.fdClDayDone}">
								<input type="text" name="value(fdClDayDone)" class="inputsgl" > 
							</c:when>
							<c:otherwise>
								<html:text property="value(fdClDayDone)" /> 
							</c:otherwise>
							</c:choose>	
							<bean:message bundle="sys-notify" key="sysNotifyTodo.clear.fdClDayDone" />
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<span class="txtstrong"><bean:message bundle="sys-notify" key="sysNotifyTodo.clear.note" /></span>
						</td>
					</tr> 
				</table>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width="20%">
				<bean:message bundle="sys-notify" key="sysNotifyTodo.display.config" />
			</td>
			<td>
				<table class="tb_noborder" width=100%>
					<tr>
						<td width="50%">
							<xform:checkbox  property="value(fdDisplayAppName)" showStatus="edit">
								<xform:simpleDataSource value="1">
									<bean:message bundle="sys-notify" key="sysNotifyTodo.display.config.notify" />
								</xform:simpleDataSource>
							</xform:checkbox>
						</td>
						<td>
							<xform:checkbox  property="value(fdDisplayAppNameHome)" showStatus="edit">
								<xform:simpleDataSource value="1">
									<bean:message bundle="sys-notify" key="sysNotifyTodo.display.config.home" />
								</xform:simpleDataSource>
							</xform:checkbox>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<!--add by wubing date:2014-10-09-->
		<tr>
			<td class="td_normal_title" width="20%">
				<bean:message bundle="sys-notify" key="sysNotifyTodo.notify.error.notifyCrashTargets" />
			</td>
			<td>
				<xform:address propertyId="value(notifyCrashTargetIds)" propertyName="value(notifyCrashTargetNames)" mulSelect="true" orgType="ORG_TYPE_PERSON | ORG_TYPE_POST" style="width:85%">
				</xform:address>
			</td>
		</tr>
		<!--
		<tr>
			<td class="td_normal_title" width="20%">
				<bean:message bundle="sys-notify" key="sysNotifyTodo.notify.error.notifyErrorNotifyType" />
			</td>
			<td>
				<kmss:editNotifyType property="value(notifyErrorNotifyType)" />
			</td>
		</tr>
		-->

		<tr>
			<td class="td_normal_title" width="20%">
				<bean:message bundle="sys-notify" key="sysNotifyTodo.level.notify.title" />
			</td>
			<td>
				<table class="tb_noborder" width=100%>
					<tr>
						<td height="30px">
							<bean:message bundle="sys-notify" key="sysNotifyTodo.level.taglib.1" />:
							<kmss:editNotifyType property="value(emergencyDefaultNotifyType)" />
						</td>
					</tr>
					<tr>
						<td height="30px">
							 <font color="white">一</font><bean:message bundle="sys-notify" key="sysNotifyTodo.level.taglib.2" />:
							<kmss:editNotifyType property="value(urgencyDefaultNotifyType)" />
						</td>
					</tr>
					<tr>
						<td height="30px">
							<bean:message bundle="sys-notify" key="sysNotifyTodo.level.taglib.3" />:
							<kmss:editNotifyType property="value(generalDefaultNotifyType)" />
						</td>
					</tr>
				</table>
			</td>
		</tr>

	</table>
	</center>
	<html:hidden property="method_GET" />
	<input type="hidden" name="modelName" value="com.landray.kmss.sys.notify.model.SysNotifyConfig" />
</html:form>

<script>
var _val_ = /^(\d+)$/;
var _trim_ = /(^\s*)|(\s*$)/g; 

function validateAppConfig(form,key) {
	var day = form["value("+key+")"]; 
	day.value = day.value.replace(_trim_, ''); 
	if (day.value==""||_val_.test(day.value)) return true;  
	alert('<bean:message bundle="sys-notify" key="sysNotifyTodo.clear.config.day.alert" />');
	return false;
}

function validateAppConfigForm(form) {
	var key="fdClDayToView";
	if(!validateAppConfig(form,key)){
		return false;
	} 
	key="fdClDayTodo";
	if(!validateAppConfig(form,key)){
		return false;
	} 
	key="fdClDayViewed";
	if(!validateAppConfig(form,key)){
		return false;
	} 
	key="fdClDayDone";
	if(!validateAppConfig(form,key)){
		return false;
	} 
	return true;
}


function validateAppConfigForms(form) {
	var day = form["value(clearDay)"];
	day.value = day.value.replace(_trim_, '');
	if (_val_.test(day.value)) return true;
	alert('<bean:message bundle="sys-notify" key="sysNotifyTodo.clear.config.day.alert"/>');
	return false;
}
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>