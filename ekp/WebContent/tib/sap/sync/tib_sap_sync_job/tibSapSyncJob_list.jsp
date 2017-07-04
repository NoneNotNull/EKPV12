<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%@ page import="
	java.util.Date,
	com.landray.kmss.util.DateUtil,
	com.landray.kmss.util.ResourceUtil" %>

<%@page import="com.landray.kmss.tib.sap.sync.model.TibSapSyncJob"%>
<%@page import="com.landray.kmss.sys.quartz.scheduler.CronExpression"%>
<html:form action="/tib/sap/sync/tib_sap_sync_job/tibSapSyncJob.do">
<script>
function confirmEnable(info){
	return List_CheckSelect() && confirm(info);
}
</script>
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/sap/sync/tib_sap_sync_job/tibSapSyncJob.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sap/sync/tib_sap_sync_job/tibSapSyncJob.do" />?method=add&fdtemplatId=${param.categoryId}');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/sap/sync/tib_sap_sync_job/tibSapSyncJob.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSapSyncJobForm, 'deleteall');">
		</kmss:auth>
			<kmss:auth requestURL="/tib/sap/sync/tib_sap_sync_job/tibSapSyncJob.do?method=chgenabled">
			<input type="button" value="<bean:message bundle="sys-quartz" key="sysQuartzJob.button.disable"/>"
				onclick="if(confirmEnable('<bean:message bundle="sys-quartz" key="sysQuartzJob.dialog.comfirmDisable"/>')){
				document.getElementsByName('fdEnabled')[0].value=false;
				Com_Submit(document.tibSapSyncJobForm, 'chgenabled')
			}"/>
		</kmss:auth>
				<kmss:auth requestURL="/tib/sap/sync/tib_sap_sync_job/tibSapSyncJob.do?method=chgenabled">
			<input type="button" value="<bean:message bundle="sys-quartz" key="sysQuartzJob.button.enable"/>"
				onclick="if(confirmEnable('<bean:message bundle="sys-quartz" key="sysQuartzJob.dialog.comfirmEnable"/>')){
				document.getElementsByName('fdEnabled')[0].value=true;
				Com_Submit(document.tibSapSyncJobForm, 'chgenabled')
			}"/>
		</kmss:auth>
		
	</div>
	<input type="hidden" name="fdEnabled">
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<c:if test="${param.sysJob=='0'}">
					<sunbor:column property="tibSapSyncJob.fdSubject">
						<bean:message bundle="sys-quartz" key="sysQuartzJob.fdSubject"/>
					</sunbor:column>
				</c:if>
				<c:if test="${param.sysJob!='0'}">
					<td>
						<bean:message bundle="sys-quartz" key="sysQuartzJob.fdSubject"/>
					</td>
				</c:if>
				<td>
					<bean:message bundle="sys-quartz" key="sysQuartzJob.fdCronExpression"/>
				</td>
				<td>
					<bean:message bundle="sys-quartz" key="sysQuartzJob.nextTime"/>
				</td>
				<sunbor:column property="tibSapSyncJob.fdLink">
					<bean:message bundle="sys-quartz" key="sysQuartzJob.fdLink"/>
				</sunbor:column>
				<sunbor:column property="tibSapSyncJob.fdRunType">
					<bean:message bundle="sys-quartz" key="sysQuartzJob.fdRunType"/>
				</sunbor:column>
				<sunbor:column property="tibSapSyncJob.fdEnabled">
					<bean:message bundle="sys-quartz" key="sysQuartzJob.fdEnabled"/>
				</sunbor:column>
				<td>
				<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.dataList"/>
				</td>
				
			</sunbor:columnHead>
		</tr>
		<logic:iterate id="tibSapSyncJob" name="queryPage" property="list" indexId="index">
			<tr kmss_href="<c:url value="/tib/sap/sync/tib_sap_sync_job/tibSapSyncJob.do?method=view&fdId=${tibSapSyncJob.fdId}" />">
				<td>
					<input type="checkbox" name="List_Selected"
						value="<bean:write name="tibSapSyncJob" property="fdId" />">
				</td>
				<td>
				<%
				
				
				TibSapSyncJob jobModel = (TibSapSyncJob)tibSapSyncJob;
					if(jobModel.getFdIsSysJob().booleanValue()){
						out.print(ResourceUtil.getString(jobModel.getFdSubject(), request.getLocale()));
					}else{
				%>
					<bean:write name="tibSapSyncJob" property="fdSubject"/> 
				<%
					}
				%>
				</td>
				<td>
					<c:import url="/sys/quartz/sys_quartz_job/sysQuartzJob_showCronExpression.jsp" charEncoding="UTF-8">
						<c:param name="value" value="${tibSapSyncJob.fdCronExpression}" />
					</c:import>
				</td>
				<td>
					<%
						if(jobModel.getFdEnabled().booleanValue()){
							CronExpression expression = new CronExpression(jobModel.getFdCronExpression());
							Date nxtTime = expression.getNextValidTimeAfter(new Date());
							if(nxtTime!=null)
								out.write(DateUtil.convertDateToString(nxtTime,DateUtil.TYPE_DATETIME, request.getLocale()));
						}
					%>
				</td>
				<td>
					<c:if test="${tibSapSyncJob.fdLink!=null && tibSapSyncJob.fdLink!=''}">
						<a href="<c:url value="${tibSapSyncJob.fdLink}" />" target="_blank">
							<bean:write name="tibSapSyncJob" property="fdUseExplain"/> 
						</a>
					</c:if>
				</td>
				<td>
					<sunbor:enumsShow value="${tibSapSyncJob.fdRunType}" enumsType="sysQuartzJob_fdRunType" />
				</td>
				<td>
					<sunbor:enumsShow value="${tibSapSyncJob.fdEnabled}" enumsType="common_yesno" />
				</td>
				<td> 
				   <a href="<c:url value="/tib/sap/sync/tib_sap_sync_job/tibSapSyncJob.do?method=getXMLTable&quartzId=${tibSapSyncJob.fdId}" />" target="_blank">
							<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.dataList"/>
						</a>
				</td>
			</tr>
		</logic:iterate>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
