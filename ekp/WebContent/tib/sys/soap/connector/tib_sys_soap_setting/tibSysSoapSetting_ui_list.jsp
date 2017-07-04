<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="tibSysSoapSetting" list="${queryPage.list }">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<%--标题--%>
		<list:data-column col="docSubject" title="${ lfn:message('tib-sys-soap-connector:tibSysSoapSetting.docSubject') }" style="text-align:center" escape="false">
			<span class="com_subject"><c:out value="${tibSysSoapSetting.docSubject}" /></span>
		</list:data-column>
		<list:data-column col="fdWsdlUrl" title="${ lfn:message('tib-sys-soap-connector:tibSysSoapSetting.fdWsdlUrl') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSoapSetting.fdWsdlUrl}" />
		</list:data-column>
		<list:data-column col="fdEnable" title="${ lfn:message('tib-sys-soap-connector:tibSysSoapSetting.fdEnable') }" escape="false" style="text-align:center;">
			<sunbor:enumsShow value="${tibSysSoapSetting.fdEnable}" enumsType="common_yesno" bundle="tib-sys-soap-connector"/>
		</list:data-column>
		<list:data-column col="fdProtectWsdl" title="${ lfn:message('tib-sys-soap-connector:tibSysSoapSetting.fdProtectWsdl') }" escape="false" style="text-align:center;">
			<sunbor:enumsShow value="${tibSysSoapSetting.fdProtectWsdl}" enumsType="common_yesno" bundle="tib-sys-soap-connector"/>
		</list:data-column>
		<list:data-column col="fdCheck" title="${ lfn:message('tib-sys-soap-connector:tibSysSoapSetting.fdCheck') }" escape="false" style="text-align:center;">
			<sunbor:enumsShow value="${tibSysSoapSetting.fdCheck}" enumsType="common_yesno" bundle="tib-sys-soap-connector"/>
		</list:data-column>
		<list:data-column col="settCategory.fdName" title="${ lfn:message('tib-sys-soap-connector:tibSysSoapSetting.settCategory') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSoapSetting.settCategory.fdName}" />
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
