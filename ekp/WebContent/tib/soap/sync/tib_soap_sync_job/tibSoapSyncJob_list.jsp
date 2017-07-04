<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/soap/sync/tib_soap_sync_job/tibSoapSyncJob.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/soap/sync/tib_soap_sync_job/tibSoapSyncJob.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/soap/sync/tib_soap_sync_job/tibSoapSyncJob.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/soap/sync/tib_soap_sync_job/tibSoapSyncJob.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSoapSyncJobForm, 'deleteall');">
		</kmss:auth>
	</div>
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
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="tibSoapSyncJob.fdModelName">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdModelName"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.fdModelId">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdModelId"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.fdKey">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdKey"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.fdSubject">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdSubject"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.fdJobService">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdJobService"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.fdJobMethod">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdJobMethod"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.fdLink">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdLink"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.fdParameter">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdParameter"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.fdCronExpression">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdCronExpression"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.fdEnabled">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdEnabled"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.fdIsSysJob">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdIsSysJob"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.fdRunType">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdRunType"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.fdRunTime">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdRunTime"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.fdRequired">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdRequired"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.fdTriggered">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdTriggered"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.fdQuartzEkp">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdQuartzEkp"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.fdUseExplain">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdUseExplain"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.fdParentId">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.fdParentId"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncJob.docCategory.fdName">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncJob.docCategory"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSoapSyncJob" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/soap/sync/tib_soap_sync_job/tibSoapSyncJob.do" />?method=view&fdId=${tibSoapSyncJob.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSoapSyncJob.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSoapSyncJob.fdModelName}" />
				</td>
				<td>
					<c:out value="${tibSoapSyncJob.fdModelId}" />
				</td>
				<td>
					<c:out value="${tibSoapSyncJob.fdKey}" />
				</td>
				<td>
					<c:out value="${tibSoapSyncJob.fdSubject}" />
				</td>
				<td>
					<c:out value="${tibSoapSyncJob.fdJobService}" />
				</td>
				<td>
					<c:out value="${tibSoapSyncJob.fdJobMethod}" />
				</td>
				<td>
					<c:out value="${tibSoapSyncJob.fdLink}" />
				</td>
				<td>
					<c:out value="${tibSoapSyncJob.fdParameter}" />
				</td>
				<td>
					<c:out value="${tibSoapSyncJob.fdCronExpression}" />
				</td>
				<td>
					<xform:radio value="${tibSoapSyncJob.fdEnabled}" property="fdEnabled" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio>
				</td>
				<td>
					<xform:radio value="${tibSoapSyncJob.fdIsSysJob}" property="fdIsSysJob" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio>
				</td>
				<td>
					<c:out value="${tibSoapSyncJob.fdRunType}" />
				</td>
				<td>
					<kmss:showDate value="${tibSoapSyncJob.fdRunTime}" />
				</td>
				<td>
					<xform:radio value="${tibSoapSyncJob.fdRequired}" property="fdRequired" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio>
				</td>
				<td>
					<xform:radio value="${tibSoapSyncJob.fdTriggered}" property="fdTriggered" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio>
				</td>
				<td>
					<c:out value="${tibSoapSyncJob.fdQuartzEkp}" />
				</td>
				<td>
					<c:out value="${tibSoapSyncJob.fdUseExplain}" />
				</td>
				<td>
					<c:out value="${tibSoapSyncJob.fdParentId}" />
				</td>
				<td>
					<c:out value="${tibSoapSyncJob.docCategory.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>