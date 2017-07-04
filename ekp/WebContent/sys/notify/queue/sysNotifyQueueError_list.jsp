<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.notify.queue.model.SysNotifyQueueError
				,com.landray.kmss.util.*
				,com.landray.kmss.common.model.IBaseModel
				,com.landray.kmss.sys.metadata.interfaces.ISysMetadataParser
				,com.landray.kmss.sys.config.dict.SysDictModel
				,com.landray.kmss.sys.organization.service.ISysOrgPersonService
				,com.landray.kmss.sys.organization.model.SysOrgPerson"%>
<%
ISysOrgPersonService ps = (ISysOrgPersonService)SpringBeanUtil.getBean("sysOrgPersonService");
ISysMetadataParser sysMetadataParser = (ISysMetadataParser)SpringBeanUtil.getBean("sysMetadataParser");
%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
function List_ConfirmRun(checkName){
	return List_CheckSelect(checkName);
}

</script>
<form name="sysNotifyQueueErrorForm" method="post" action="<c:url value="/sys/notify/queue/sysNotifyQueueError.do" />">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/notify/queue/sysNotifyQueueError.do?method=runAll">
			<input type="button" value="<bean:message bundle="sys-notify" key="sysNotifyQueueError.run"/>"
				onclick="if(!List_ConfirmRun())return;Com_Submit(document.sysNotifyQueueErrorForm, 'runAll');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/notify/queue/sysNotifyQueueError.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysNotifyQueueErrorForm, 'deleteall');">
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
				<sunbor:column property="sysNotifyQueueError.fdModelId">
					<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdModelId"/>
				</sunbor:column>
				<sunbor:column property="sysNotifyQueueError.fdModelName">
					<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdModelName"/>
				</sunbor:column>
				<td>
					<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdModelName.text"/>
				</td>
				<sunbor:column property="sysNotifyQueueError.fdType">
					<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdType"/>
				</sunbor:column>
				<sunbor:column property="sysNotifyQueueError.fdMethodType">
					<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdMethodType"/>
				</sunbor:column>
				<sunbor:column property="sysNotifyQueueError.fdTime">
					<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdTime"/>
				</sunbor:column>
				<sunbor:column property="sysNotifyQueueError.fdExecutor">
					<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdExecutor"/>
				</sunbor:column>
				<sunbor:column property="sysNotifyQueueError.fdUserId">
					<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdUserId"/>
				</sunbor:column>
				<sunbor:column property="sysNotifyQueueError.fdFlag">
					<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdFlag"/>
				</sunbor:column>
				<td>
					<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdErrorMsg"/>
				</td>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysNotifyQueueError" varStatus="vstatus">
		<%
		SysNotifyQueueError sysNotifyQueueError = (SysNotifyQueueError)pageContext.getAttribute("sysNotifyQueueError");
		SysOrgPerson p = (SysOrgPerson)ps.findByPrimaryKey(sysNotifyQueueError.getFdUserId());

		String mn = "";
		if (ModelUtil.isModelMerge(sysNotifyQueueError.getFdModelName(), sysNotifyQueueError.getFdModelId())) {
			IBaseModel mModel = ps.findByPrimaryKey(sysNotifyQueueError.getFdModelId(),sysNotifyQueueError.getFdModelName(),false);
			SysDictModel dictModel = sysMetadataParser.getDictModel(mModel);
			if(StringUtil.isNotNull(dictModel.getMessageKey())){
				mn=ResourceUtil.getString(dictModel.getMessageKey(),
						request.getLocale());
			}
		}
		%>
			<tr
				kmss_href="<c:url value="/sys/notify/queue/sysNotifyQueueError.do" />?method=viewPage&fdId=${sysNotifyQueueError.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysNotifyQueueError.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td nowrap>
					<c:out value="${sysNotifyQueueError.fdModelId}" />
				</td>
				<td nowrap>
					<c:out value="${sysNotifyQueueError.fdModelName}" />
				</td>
				<td nowrap>
					<%=mn%>
				</td>
				<td nowrap>
					<c:out value="${sysNotifyQueueError.fdType}" />
				</td>
				<td nowrap>
					<c:out value="${sysNotifyQueueError.fdMethodType}" />
				</td>
				<td nowrap>
				<%
				if(sysNotifyQueueError.getFdTime()!=null){
					out.print(DateUtil.convertDateToString(DateUtil.getCalendar(sysNotifyQueueError.getFdTime()).getTime(),"yyyy-MM-dd HH:mm:ss"));
				}
				%>
				</td>
				<td nowrap>
					<c:out value="${sysNotifyQueueError.fdExecutor}" />
				</td>
				<td nowrap>
					<%=p.getFdName()%>
				</td>
				<td nowrap>
					<c:if test="${sysNotifyQueueError.fdFlag eq '0'}">
						<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdFlag.0"/>
					</c:if>
					<c:if test="${sysNotifyQueueError.fdFlag eq '1'}">
						<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdFlag.1"/>
					</c:if>
				</td>
				<td>
					<c:out value="${sysNotifyQueueError.fdErrorMsg}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</form>
<%@ include file="/resource/jsp/list_down.jsp"%>