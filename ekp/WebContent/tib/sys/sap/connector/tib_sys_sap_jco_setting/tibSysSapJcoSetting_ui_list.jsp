<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="tibSysSapJcoSetting" list="${queryPage.list }">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<%--标题--%>
		<list:data-column col="fdPoolName" title="${ lfn:message('tib-sys-sap-connector:tibSysSapJcoSetting.fdPoolName') }" style="text-align:center" escape="false">
			<span class="com_subject"><c:out value="${tibSysSapJcoSetting.fdPoolName}" /></span>
		</list:data-column>
		<list:data-column col="fdTibSysSapCode.fdServerName" title="${ lfn:message('tib-sys-sap-connector:tibSysSapJcoSetting.fdTibSysSapCode') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSapJcoSetting.fdTibSysSapCode.fdServerName}" />
		</list:data-column>
		<list:data-column col="fdPoolAdmin" title="${ lfn:message('tib-sys-sap-connector:tibSysSapJcoSetting.fdPoolAdmin') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSapJcoSetting.fdPoolAdmin}" />
		</list:data-column>
		<list:data-column col="fdPoolNumber" title="${ lfn:message('tib-sys-sap-connector:tibSysSapJcoSetting.fdPoolNumber') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSapJcoSetting.fdPoolNumber}" />
		</list:data-column>
		<list:data-column col="fdConnectType" title="${ lfn:message('tib-sys-sap-connector:tibSysSapJcoSetting.fdConnectType') }" escape="false" style="text-align:center;">
			<sunbor:enumsShow value="${tibSysSapJcoSetting.fdConnectType}" enumsType="connect_type" bundle="tib-sys-sap-connector"/>
		</list:data-column>
		<list:data-column col="fdPoolStatus" title="${ lfn:message('tib-sys-sap-connector:tibSysSapJcoSetting.fdPoolStatus') }" escape="false" style="text-align:center;">
			<sunbor:enumsShow value="${tibSysSapJcoSetting.fdPoolStatus}" enumsType="status_type" bundle="tib-sys-sap-connector"/>
		</list:data-column>
		<list:data-column col="fdUpdateTime" title="${ lfn:message('tib-sys-sap-connector:tibSysSapJcoSetting.fdUpdateTime') }">
			<kmss:showDate value="${tibSysSapJcoSetting.fdUpdateTime}" />
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
