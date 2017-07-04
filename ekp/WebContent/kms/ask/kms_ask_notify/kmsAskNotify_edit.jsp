<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%--通知方式设置--%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/appconfig/sys_appconfig/sysAppConfig.do">
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.update"/>"
		onclick="Com_Submit(document.sysAppConfigForm, 'update');">
</div>
<p class="txttitle"><bean:message bundle="kms-ask" key="kmsAsk.notify.set"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr >
		<td class="tr_normal_title" style="width: 15%">
			通知方式
		</td>
		<td>
			<kmss:editNotifyType property="value(fdInnerNotifyType)"/>
		</td>
	</tr>
	<%--<tr>
		<td class="tr_normal_title" style="width: 15%">
			<bean:message  bundle="kms-ask" key="kmsAsk.outer.notify.type"/>
		</td>
		<td>
			<kmss:editNotifyType property="value(fdOuterNotifyType)" exceptType="todo"/>
		</td>
	</tr>--%>
</table>
</center>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
