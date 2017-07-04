<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="tibSysCoreIface" list="${queryPage.list }">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<%--接口名称--%>
		<list:data-column col="fdIfaceName" title="${ lfn:message('tib-sys-core-provider:tibSysCoreIface.fdIfaceName') }" style="text-align:center" escape="false">
			<span class="com_subject"><c:out value="${tibSysCoreIface.fdIfaceName}" /></span>
		</list:data-column>
		<%--接口Key--%>
		<list:data-column col="fdIfaceKey" title="${ lfn:message('tib-sys-core-provider:tibSysCoreIface.fdIfaceKey') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysCoreIface.fdIfaceKey}" />
		</list:data-column>
		<%--调度模式--%>
		<list:data-column col="fdControlPattern" title="${ lfn:message('tib-sys-core-provider:tibSysCoreIface.controlPattern') }">
			<sunbor:enumsShow value="${tibSysCoreIface.fdControlPattern}" enumsType="fd_control_pattern_enums"  />
		</list:data-column>
		<%--是否前台控制--%>
		<list:data-column col="fdIfaceControl" title="${ lfn:message('tib-sys-core-provider:tibSysCoreIface.fdIfaceControl') }">
			<sunbor:enumsShow value="${tibSysCoreIface.fdIfaceControl}" enumsType="common_yesno"  />
		</list:data-column>
		<%--标签列表--%>
		<list:data-column col="fdIfaceTags" title="${ lfn:message('tib-sys-core-provider:tibSysCoreIface.fdIfaceTags') }">
			<c:forEach items="${tibSysCoreIface.fdIfaceTags}" var="fdIfaceTag" varStatus="vstatus">
				<c:out value="${fdIfaceTag.fdTagName}" />;
			</c:forEach>
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
