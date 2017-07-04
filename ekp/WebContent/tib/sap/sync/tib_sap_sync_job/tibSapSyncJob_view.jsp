<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ page import="com.landray.kmss.tib.sap.sync.forms.TibSapSyncJobForm,
	com.landray.kmss.sys.quartz.scheduler.CronExpression,
	java.util.Date,
	com.landray.kmss.util.DateUtil" %>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%
	TibSapSyncJobForm tibSapSyncJobForm = (TibSapSyncJobForm)request.getAttribute("tibSapSyncJobForm");
%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<input type="button"
			value="<bean:message key="tibSapSyncJob.dataList" bundle="tib-sap-sync"/>"
			onclick="Com_OpenWindow('tibSapSyncJob.do?method=getXMLTable&quartzId=${tibSapSyncJobForm.fdId}');">
	<c:if test="${not empty tibSapSyncJobForm.fdQuartzEkp}">
		 <input type="button" value="<bean:message bundle="sys-quartz" key="sysQuartzJob.button.run"/>"
		onClick="Com_OpenWindow('<c:url value="/tib/sap/sync/tib_sap_sync_job/tibSapSyncJob.do"/>?method=run&fdId=${tibSapSyncJobForm.fdQuartzEkp}','_self');">
	</c:if>

	<kmss:auth requestURL="/tib/sap/sync/tib_sap_sync_job/tibSapSyncJob.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('tibSapSyncJob.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/tib/sap/sync/tib_sap_sync_job/tibSapSyncJob.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('tibSapSyncJob.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-sap-sync" key="table.tibSapSyncJob"/></p>

<center>

<table
		id="Label_Tabel"
		width=95%>
		<tr LKS_LabelName="定时任务信息">
			<td>
			
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.fdSubject"/>
		</td><td>
			<c:if test="${tibSapSyncJobForm.fdIsSysJob=='true'}">
				<kmss:message key="${tibSapSyncJobForm.fdSubject}"/>
			</c:if>
			<c:if test="${tibSapSyncJobForm.fdIsSysJob!='true'}">
				${tibSapSyncJobForm.fdSubject} 
			</c:if>
		</td>
		
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.docCategory"/>
		</td><td width="35%">
			<c:out value="${tibSapSyncJobForm.docCategoryName}" />
		</td>
		
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.fdCronExpression"/>
		</td><td width=35%>
			<c:import url="/sys/quartz/sys_quartz_job/sysQuartzJob_showCronExpression.jsp" charEncoding="UTF-8">
				<c:param name="value" value="${tibSapSyncJobForm.fdCronExpression}" />
			</c:import>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.nextTime"/>
		</td><td width=35%>
			<c:if test="${tibSapSyncJobForm.fdEnabled=='true'}">
			<%
				CronExpression expression = new CronExpression(tibSapSyncJobForm.getFdCronExpression());
				Date nxtTime = expression.getNextValidTimeAfter(new Date());
				if(nxtTime!=null)
					out.write(DateUtil.convertDateToString(nxtTime,DateUtil.TYPE_DATETIME, request.getLocale()));
			%>
			</c:if>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.fdJobType"/>
		</td><td>
			<sunbor:enumsShow value="${(empty tibSapSyncJobForm.fdRunTime)?'false':'true'}" enumsType="common_yesno" />
		</td>
		<td class="td_normal_title">
			<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.fdRunType"/>
		</td><td>
			<sunbor:enumsShow value="${tibSapSyncJobForm.fdRunType}" enumsType="sysQuartzJob_fdRunType" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.fdEnabled"/>
		</td><td>
			<sunbor:enumsShow value="${tibSapSyncJobForm.fdEnabled}" enumsType="common_yesno" />
		</td>
		<td class="td_normal_title">
			<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.fdIsSysJob"/>
		</td><td>
			<sunbor:enumsShow value="${tibSapSyncJobForm.fdIsSysJob}" enumsType="common_yesno" />
		</td>
	</tr>
	<c:if test="${not empty tibSapSyncJobForm.fdRunTime}">
		<tr>
			<td class="td_normal_title">
				<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.fdRequired"/>
			</td><td>
				<sunbor:enumsShow value="${tibSapSyncJobForm.fdRequired}" enumsType="common_yesno" />
			</td>
			<td class="td_normal_title">
				<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.fdTriggered"/>
			</td><td>
				<sunbor:enumsShow value="${tibSapSyncJobForm.fdTriggered}" enumsType="common_yesno" />
			</td>
		</tr>
	</c:if>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.fdJob"/>
		</td><td colspan="3">
			${tibSapSyncJobForm.fdJobService}.${tibSapSyncJobForm.fdJobMethod}(${tibSapSyncJobForm.fdParameter})
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.fdLink"/>
		</td><td colspan="3">
			<c:if test="${tibSapSyncJobForm.fdLink!=null && tibSapSyncJobForm.fdLink!=''}">
				<a href="<c:url value="${tibSapSyncJobForm.fdLink}" />" target="_blank">
					<c:out value="${tibSapSyncJobForm.fdUseExplain}"/>
				</a>
			</c:if>
		</td>
	</tr>
		<tr>
		<td class="td_normal_title">
			<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.fdUseExplain"/>
		</td><td colspan="3">
		${tibSapSyncJobForm.fdUseExplain}
		</td>
	</tr>
</table>
</td>
</tr>
 
<%@ include file="/tib/sap/sync/tib_sap_sync_job/tibSapSync_tempView.jsp"%>

</table>

</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
