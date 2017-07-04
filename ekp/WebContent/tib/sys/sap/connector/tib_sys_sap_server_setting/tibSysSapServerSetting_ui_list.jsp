<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="tibSysSapServerSetting" list="${queryPage.list }">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<%--标题--%>
		<list:data-column col="fdServerName" title="${ lfn:message('tib-sys-sap-connector:tibSysSapServerSetting.fdServerName') }" style="text-align:center" escape="false">
			<span class="com_subject"><c:out value="${tibSysSapServerSetting.fdServerName}" /></span>
		</list:data-column>
		<list:data-column col="fdServerCode" title="${ lfn:message('tib-sys-sap-connector:tibSysSapServerSetting.fdServerCode') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSapServerSetting.fdServerCode}" />
		</list:data-column>
		<list:data-column col="fdServerIp" title="${ lfn:message('tib-sys-sap-connector:tibSysSapServerSetting.fdServerIp') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSapServerSetting.fdServerIp}" />
		</list:data-column>
		<list:data-column col="fdTibSysSapCode" title="${ lfn:message('tib-sys-sap-connector:tibSysSapServerSetting.fdTibSysSapCode') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSapServerSetting.fdTibSysSapCode}" />
		</list:data-column>
		<list:data-column col="fdClientCode" title="${ lfn:message('tib-sys-sap-connector:tibSysSapServerSetting.fdClientCode') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSapServerSetting.fdClientCode}" />
		</list:data-column>
		<list:data-column col="fdLanguage" title="${ lfn:message('tib-sys-sap-connector:tibSysSapServerSetting.fdLanguage') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSapServerSetting.fdLanguage}" />
		</list:data-column>
		<list:data-column col="fdUpdateTime" title="${ lfn:message('tib-sys-sap-connector:tibSysSapServerSetting.fdUpdateTime') }">
			<kmss:showDate value="${tibSysSapServerSetting.fdUpdateTime}" />
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
