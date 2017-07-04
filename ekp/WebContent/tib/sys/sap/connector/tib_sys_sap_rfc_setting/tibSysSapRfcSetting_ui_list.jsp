<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="tibSysSapRfcSetting" list="${queryPage.list }">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<%--标题--%>
		<list:data-column col="fdFunctionName" title="${ lfn:message('tib-sys-sap-connector:tibSysSapRfcSetting.fdFunctionName') }" style="text-align:center" escape="false">
			<span class="com_subject"><c:out value="${tibSysSapRfcSetting.fdFunctionName}" /></span>
		</list:data-column>
		<list:data-column col="fdFunction" title="${ lfn:message('tib-sys-sap-connector:tibSysSapRfcSetting.fdFunction') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSapRfcSetting.fdFunction}" />
		</list:data-column>
		<list:data-column col="fdPool.fdPoolName" title="${ lfn:message('tib-sys-sap-connector:tibSysSapRfcSetting.fdPool') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSapRfcSetting.fdPool.fdPoolName}" />
		</list:data-column>
		<list:data-column col="docCategory.fdName" title="${ lfn:message('tib-sys-sap-connector:tibSysSapRfcSetting.docCategory') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSapRfcSetting.docCategory.fdName}" />
		</list:data-column>
		<list:data-column col="fdWeb" title="${ lfn:message('tib-sys-sap-connector:tibSysSapRfcSetting.fdWeb') }">
			<sunbor:enumsShow value="${tibSysSapRfcSetting.fdWeb}" enumsType="common_yesno" />
		</list:data-column>
		<list:data-column col="fdUse" title="${ lfn:message('tib-sys-sap-connector:tibSysSapRfcSetting.fdUse') }">
			<sunbor:enumsShow value="${tibSysSapRfcSetting.fdUse}" enumsType="common_yesno" />
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
