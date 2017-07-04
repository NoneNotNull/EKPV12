<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysFileConvertConfig" list="${queryPage.list }" varIndex="status">
		<list:data-column property="fdId">
		</list:data-column >
		<list:data-column col="index">
		      ${status+1}
		</list:data-column >
		<list:data-column property="fdFileExtName" title="文档扩展名" escape="false" style="text-align:left">
		</list:data-column>
		<list:data-column property="fdModelName" title="文档所属模块" escape="false" style="text-align:left">
		</list:data-column>
		<list:data-column property="fdConverterKey" title="转换器" escape="false" style="text-align:left">
		</list:data-column>
		<list:data-column col="fdDispenser" title="分配器" escape="false" style="text-align:left">
		<c:choose>
			<c:when test="${ sysFileConvertConfig.fdDispenser == 'remote' }">
				<c:out value="远程"></c:out>
			</c:when>
			<c:when test="${ sysFileConvertConfig.fdDispenser == 'local' }">
				<c:out value="本地"></c:out>
			</c:when>
		</c:choose>
		</list:data-column>
	</list:data-columns>
	
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>