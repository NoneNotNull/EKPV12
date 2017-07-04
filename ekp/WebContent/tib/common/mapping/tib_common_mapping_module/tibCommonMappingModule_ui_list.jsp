<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<list:data>
	<list:data-columns var="tibCommonMappingModule" list="${queryPage.list }">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<%--标题--%>
		<list:data-column col="fdModuleName" title="${ lfn:message('tib-common-mapping:tibCommonMappingModule.fdModuleName') }" style="text-align:center" escape="false">
			<span class="com_subject"><c:out value="${tibCommonMappingModule.fdModuleName}" /></span>
		</list:data-column>
		<%--模版名称--%>
		<list:data-column col="fdTemplateName" title="${ lfn:message('tib-common-mapping:tibCommonMappingModule.fdTemplateName') }" escape="false" style="text-align:center;">
			<c:out value="${tibCommonMappingModule.fdTemplateName}" />
		</list:data-column>
		<list:data-column col="fdMainModelName" title="${ lfn:message('tib-common-mapping:tibCommonMappingModule.fdMainModelName') }" escape="false" style="text-align:center;">
			<c:out value="${tibCommonMappingModule.fdMainModelName}" />
		</list:data-column>
		<list:data-column col="fdCate" title="${ lfn:message('tib-common-mapping:tibCommonMappingModule.cate.type') }">
			<sunbor:enumsShow value="${tibCommonMappingModule.fdCate}" enumsType="tibCommonMappingModule_cate"  />
		</list:data-column>
		<list:data-column col="fdUse" title="${ lfn:message('tib-common-mapping:tibCommonMappingModule.fdUse') }">
			<sunbor:enumsShow value="${tibCommonMappingModule.fdUse}" enumsType="common_yesno"  />
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
