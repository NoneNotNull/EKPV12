<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/follow/sys_follow_config/sysFollowConfig.do">
<div id="optBarDiv">
	<c:if test="${sysFollowConfigForm.method_GET=='edit'}">
		<kmss:authShow roles="SYSROLE_ADMIN">
			<input type=button value="<bean:message key="button.update"/>"
				onclick="setNotifyType();Com_Submit(document.sysFollowConfigForm, 'update');">
		</kmss:authShow>
	</c:if>
</div>

<p class="txttitle"><bean:message bundle="sys-follow" key="table.sysFollowConfig"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-follow" key="sysFollowConfig.alreadFollowDay"/>
		</td><td width="85%">
			<xform:text property="alreadFollowDay" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-follow" key="sysFollowConfig.unreadFollowDay"/>
		</td><td width="85%">
			<xform:text property="unReadFollowDay" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-follow" key="sysFollowConfig.isSendUndoNotify"/>
		</td><td width="85%">
			<c:forEach items="${notifyTypeArr}" var="notifyType">
				<input name="notifyType" type=checkbox value="${notifyType}"/>
				<bean:message bundle="sys-notify" key="sysNotify.type.${notifyType}" />&nbsp;
			</c:forEach>
			<html:hidden property="defaultNotifyType" />
		</td>
	</tr>
</table>
</center>
<script>
	$KMSSValidation();

	function setNotifyType(){
		var defaultNotifyType = "";
		$("input[name='notifyType']").each(function(){
			if(this.checked){
				defaultNotifyType = defaultNotifyType + ";" + this.value;
			}
		})
		$("input[name=defaultNotifyType]").val(defaultNotifyType);
	}

	(function initNotifyType(){
		var defaultNotifyType = $("input[name=defaultNotifyType]").val();
		$("input[name='notifyType']").each(function(){
			if(~defaultNotifyType.indexOf(this.value)){
				this.checked = true;
			}
		});
	})();

	
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>