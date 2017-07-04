<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ page import="com.landray.kmss.tib.soap.sync.forms.TibSoapSyncJobForm,
	com.landray.kmss.sys.quartz.scheduler.CronExpression,
	java.util.Date,
	com.landray.kmss.util.DateUtil" %>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%
	TibSoapSyncJobForm tibSoapSyncJobForm = (TibSoapSyncJobForm)request.getAttribute("tibSoapSyncJobForm");
%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<input type="button"
			value="<bean:message key="tibSoapSyncJob.dataList" bundle="tib-soap-sync"/>"
			onclick="Com_OpenWindow('tibSoapSyncJob.do?method=getXMLTable&quartzId=${tibSoapSyncJobForm.fdId}');">
	<c:if test="${not empty tibSoapSyncJobForm.fdQuartzEkp}">
		 <input type="button" value="<bean:message bundle="sys-quartz" key="sysQuartzJob.button.run"/>"
		onClick="Com_OpenWindow('<c:url value="/tib/soap/sync/tib_soap_sync_job/tibSoapSyncJob.do"/>?method=run&fdId=${tibSoapSyncJobForm.fdQuartzEkp}','_self');">
	</c:if>

	<kmss:auth requestURL="/tib/soap/sync/tib_soap_sync_job/tibSoapSyncJob.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('tibSoapSyncJob.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/tib/soap/sync/tib_soap_sync_job/tibSoapSyncJob.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('tibSoapSyncJob.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-soap-sync" key="table.tibSoapSyncJob"/></p>

<center>

<table
		id="Label_Tabel"
		width=95%>
		<tr LKS_LabelName="定时任务信息">
			<td>
			
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdSubject"/>
		</td><td>
			<c:if test="${tibSoapSyncJobForm.fdIsSysJob=='true'}">
				<kmss:message key="${tibSoapSyncJobForm.fdSubject}"/>
			</c:if>
			<c:if test="${tibSoapSyncJobForm.fdIsSysJob!='true'}">
				${tibSoapSyncJobForm.fdSubject} 
			</c:if>
		</td>
		
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.docCategory"/>
		</td><td width="35%">
			<c:out value="${tibSoapSyncJobForm.docCategoryName}" />
		</td>
		
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdCronExpression"/>
		</td><td width=35%>
			<c:import url="/sys/quartz/sys_quartz_job/sysQuartzJob_showCronExpression.jsp" charEncoding="UTF-8">
				<c:param name="value" value="${tibSoapSyncJobForm.fdCronExpression}" />
			</c:import>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.nextTime"/>
		</td><td width=35%>
			<c:if test="${tibSoapSyncJobForm.fdEnabled=='true'}">
			<%
				CronExpression expression = new CronExpression(tibSoapSyncJobForm.getFdCronExpression());
				Date nxtTime = expression.getNextValidTimeAfter(new Date());
				if(nxtTime!=null)
					out.write(DateUtil.convertDateToString(nxtTime,DateUtil.TYPE_DATETIME, request.getLocale()));
			%>
			</c:if>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdJobType"/>
		</td><td>
			<sunbor:enumsShow value="${(empty tibSoapSyncJobForm.fdRunTime)?'false':'true'}" enumsType="common_yesno" />
		</td>
		<td class="td_normal_title">
			<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdRunType"/>
		</td><td>
			<sunbor:enumsShow value="${tibSoapSyncJobForm.fdRunType}" enumsType="sysQuartzJob_fdRunType" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdEnabled"/>
		</td><td>
			<sunbor:enumsShow value="${tibSoapSyncJobForm.fdEnabled}" enumsType="common_yesno" />
		</td>
		<td class="td_normal_title">
			<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdIsSysJob"/>
		</td><td>
			<sunbor:enumsShow value="${tibSoapSyncJobForm.fdIsSysJob}" enumsType="common_yesno" />
		</td>
	</tr>
	<c:if test="${not empty tibSoapSyncJobForm.fdRunTime}">
		<tr>
			<td class="td_normal_title">
				<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdRequired"/>
			</td><td>
				<sunbor:enumsShow value="${tibSoapSyncJobForm.fdRequired}" enumsType="common_yesno" />
			</td>
			<td class="td_normal_title">
				<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdTriggered"/>
			</td><td>
				<sunbor:enumsShow value="${tibSoapSyncJobForm.fdTriggered}" enumsType="common_yesno" />
			</td>
		</tr>
	</c:if>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdJob"/>
		</td><td colspan="3">
			${tibSoapSyncJobForm.fdJobService}.${tibSoapSyncJobForm.fdJobMethod}(${tibSoapSyncJobForm.fdParameter})
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdLink"/>
		</td><td colspan="3">
			<c:if test="${tibSoapSyncJobForm.fdLink!=null && tibSoapSyncJobForm.fdLink!=''}">
				<a href="<c:url value="${tibSoapSyncJobForm.fdLink}" />" target="_blank">
					<c:out value="${tibSoapSyncJobForm.fdUseExplain}"/>
				</a>
			</c:if>
		</td>
	</tr>
		<tr>
		<td class="td_normal_title">
			<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdUseExplain"/>
		</td><td colspan="3">
		${tibSoapSyncJobForm.fdUseExplain}
		</td>
	</tr>
</table>
</td>
</tr>
 
<%@ include file="/tib/soap/sync/tib_soap_sync_job/tibSoapSync_tempView.jsp"%>

</table>

</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
