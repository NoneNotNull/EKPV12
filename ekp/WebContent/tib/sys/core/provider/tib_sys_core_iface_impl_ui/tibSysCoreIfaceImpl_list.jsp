<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="tibSysCoreIfaceImpl" list="${queryPage.list }">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<%--接口实现名称--%>
		<list:data-column col="fdName" title="${ lfn:message('tib-sys-core-provider:tibSysCoreIfaceImpl.fdName') }" style="text-align:center" escape="false">
			<span class="com_subject"><c:out value="${tibSysCoreIfaceImpl.fdName}" /></span>
		</list:data-column>
		<%--实现函数名称--%>
		<list:data-column col="fdImplRefName" title="${ lfn:message('tib-sys-core-provider:tibSysCoreIfaceImpl.fdImplRefName') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysCoreIfaceImpl.fdImplRefName}" />
		</list:data-column>
		<%--实现函数名称--%>
		<list:data-column col="tibSysCoreIface.fdId" title="${ lfn:message('tib-sys-core-provider:tibSysCoreIfaceImpl.tibSysCoreIface') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysCoreIfaceImpl.tibSysCoreIface.fdIfaceName}" />
		</list:data-column>
		
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
