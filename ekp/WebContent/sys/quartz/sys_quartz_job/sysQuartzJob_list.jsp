<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<form action="<c:url value="/sys/quartz/sys_quartz_job/sysQuartzJob.do?method=chgenabled"/>" method="POST">
<script>
function confirmEnable(info){
	return List_CheckSelect() && confirm(info);
}
</script>
<div id="optBarDiv">
	<input type="button" value="<bean:message bundle="sys-quartz" key="sysQuartzJob.button.enable"/>" onclick="
		if(confirmEnable('<bean:message bundle="sys-quartz" key="sysQuartzJob.dialog.comfirmEnable"/>')){
			document.getElementsByName('fdEnabled')[0].value=true;
			submit();
		}"/>
	<input type="button" value="<bean:message bundle="sys-quartz" key="sysQuartzJob.button.disable"/>" onclick="
		if(confirmEnable('<bean:message bundle="sys-quartz" key="sysQuartzJob.dialog.comfirmDisable"/>')){
			document.getElementsByName('fdEnabled')[0].value=false;
			submit();
		}"/>
</div>
<input type="hidden" name="fdEnabled">
<% if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
<% }else{ %>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<sunbor:column property="sysQuartzJob.fdSubject">
					<bean:message bundle="sys-quartz" key="sysQuartzJob.fdSubject"/>
				</sunbor:column>
				<td>
					<bean:message bundle="sys-quartz" key="sysQuartzJob.fdCronExpression"/>
				</td>
				<sunbor:column property="sysQuartzJob.fdRunTime">
					<bean:message bundle="sys-quartz" key="sysQuartzJob.nextTime"/>
				</sunbor:column>
				<sunbor:column property="sysQuartzJob.fdLink">
					<bean:message bundle="sys-quartz" key="sysQuartzJob.fdLink"/>
				</sunbor:column>
				<sunbor:column property="sysQuartzJob.fdRunType">
					<bean:message bundle="sys-quartz" key="sysQuartzJob.fdRunType"/>
				</sunbor:column>
				<sunbor:column property="sysQuartzJob.fdEnabled">
					<bean:message bundle="sys-quartz" key="sysQuartzJob.fdEnabled"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<logic:iterate id="sysQuartzJob" name="queryPage" property="list" indexId="index">
			<tr kmss_href="<c:url value="/sys/quartz/sys_quartz_job/sysQuartzJob.do?method=view&fdId=${sysQuartzJob.fdId}" />">
				<td>
					<input type="checkbox" name="List_Selected"
						value="<bean:write name="sysQuartzJob" property="fdId" />">
				</td>
				<td style="text-align: left;">
					<c:if test="${sysQuartzJob.fdIsSysJob}">
						<kmss:message key="${sysQuartzJob.fdSubject}"/>
					</c:if>
					<c:if test="${not sysQuartzJob.fdIsSysJob}">
						<bean:write name="sysQuartzJob" property="fdSubject"/> 
					</c:if>
				</td>
				<td>
					<c:import url="/sys/quartz/sys_quartz_job/sysQuartzJob_showCronExpression.jsp" charEncoding="UTF-8">
						<c:param name="value" value="${sysQuartzJob.fdCronExpression}" />
					</c:import>
				</td>
				<td>
					<c:if test="${sysQuartzJob.fdEnabled}">
						<kmss:showDate value="${sysQuartzJob.fdRunTime}" type="datetime"/>
					</c:if>
				</td>
				<td>
					<c:if test="${sysQuartzJob.fdLink!=null && sysQuartzJob.fdLink!=''}">
						<a href="<c:url value="${sysQuartzJob.fdLink}" />" target="_blank">
							<bean:message bundle="sys-quartz" key="sysQuartzJob.fdLink"/>
						</a>
					</c:if>
				</td>
				<td>
					<sunbor:enumsShow value="${sysQuartzJob.fdRunType}" enumsType="sysQuartzJob_fdRunType" />
					<c:if test="${not empty sysQuartzJob.fdRunServer}">
						(${sysQuartzJob.fdRunServer})
					</c:if>
				</td>
				<td>
					<sunbor:enumsShow value="${sysQuartzJob.fdEnabled}" enumsType="common_yesno" />
				</td>
			</tr>
		</logic:iterate>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</form>
<%@ include file="/resource/jsp/list_down.jsp"%>