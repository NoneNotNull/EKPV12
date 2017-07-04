<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="tibJdbcTaskManage" list="${queryPage.list }">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<%--标题--%>
		<list:data-column col="fdSubject" title="${ lfn:message('tib-jdbc:tibJdbcTaskManage.fdSubject') }" style="text-align:center" escape="false">
			<span class="com_subject"><c:out value="${tibJdbcTaskManage.fdSubject}" /></span>
		</list:data-column>
		<list:data-column col="fdCronExpression" title="${ lfn:message('sys-quartz:sysQuartzJob.fdCronExpression') }" escape="false" style="text-align:center;">
			<c:import url="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage_showCronExpression.jsp" charEncoding="UTF-8">
				<c:param name="value" value="${tibJdbcTaskManage.fdCronExpression}" />
			</c:import>
		</list:data-column>
		<list:data-column col="fdLink" title="${ lfn:message('sys-quartz:sysQuartzJob.fdLink') }" escape="false" style="text-align:center;">
			<c:if test="${tibJdbcTaskManage.fdLink!=null && tibJdbcTaskManage.fdLink!=''}">
				<a href="<c:url value="${tibJdbcTaskManage.fdLink}" />" target="_blank">
					<bean:write name="tibJdbcTaskManage" property="fdUseExplain"/> 
				</a>
			</c:if>
		</list:data-column>
		<list:data-column col="fdRunType" title="${ lfn:message('sys-quartz:sysQuartzJob.fdRunType') }" escape="false" style="text-align:center;">
			<sunbor:enumsShow value="${tibJdbcTaskManage.fdRunType}" enumsType="sysQuartzJob_fdRunType" />
		</list:data-column>
		<list:data-column col="fdIsEnabled" title="${ lfn:message('sys-quartz:sysQuartzJob.fdEnabled') }">
			<sunbor:enumsShow value="${tibJdbcTaskManage.fdIsEnabled}" enumsType="common_yesno" />
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
