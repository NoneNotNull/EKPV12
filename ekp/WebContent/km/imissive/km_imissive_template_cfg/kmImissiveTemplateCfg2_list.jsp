<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmImissiveTemplateCfg" list="${queryPage.list }">
			<list:data-column property="fdId">
			</list:data-column>
			<list:data-column col="fdName" escape="false" title="标题" style="text-align:left">
			      <span class="com_subject"><c:out value="${kmImissiveTemplateCfg.fdName}"/></span>
			</list:data-column>
			<list:data-column   property="fdSendTemplate.fdName" title="来源">
		    </list:data-column>
		    <list:data-column   property="fdReceiveTemplate.fdName" title="目标">
		    </list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
