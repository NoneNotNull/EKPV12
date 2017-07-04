<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="tibSysSoapMain" list="${queryPage.list }">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<%--标题--%>
		<list:data-column col="docSubject" title="${ lfn:message('tib-sys-soap-connector:tibSysSoapMain.docSubject') }" style="text-align:center" escape="false">
			<span class="com_subject"><c:out value="${tibSysSoapMain.docSubject}" /></span>
		</list:data-column>
		<list:data-column col="wsBindFunc" title="${ lfn:message('tib-sys-soap-connector:tibSysSoapMain.wsBindFunc') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSoapMain.wsBindFunc}" />
		</list:data-column>
		<list:data-column col="tibSysSoapSetting.docSubject" title="${ lfn:message('tib-sys-soap-connector:tibSysSoapMain.wsServerSetting') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSoapMain.tibSysSoapSetting.docSubject}" />
		</list:data-column>
		<list:data-column col="docCategory.fdName" title="${ lfn:message('tib-sys-soap-connector:tibSysSoapMain.docCategory') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSoapMain.docCategory.fdName}" />
		</list:data-column>
		<list:data-column col="wsEnable" title="${ lfn:message('tib-sys-soap-connector:tibSysSoapMain.wsEnable') }" escape="false" style="text-align:center;">
			<sunbor:enumsShow value="${tibSysSoapMain.wsEnable}" enumsType="common_yesno" bundle="tib-sys-soap-connector"/>
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
