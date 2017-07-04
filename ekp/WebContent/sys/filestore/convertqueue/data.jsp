<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.sys.filestore.util.AttModuleUtil"%>
<%@page
	import="com.landray.kmss.sys.filestore.model.SysFileConvertQueue"%><list:data>
	<list:data-columns var="sysFileConvertQueue" list="${queryPage.list }"
		varIndex="status">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="index">
		      ${status+1}
		</list:data-column>
		<list:data-column property="fdAttMainId" title="附件ID" escape="false"
			style="text-align:center">
		</list:data-column>
		<list:data-column col="fdModule" title="所属应用" escape="false"
			style="text-align:center">
			<%
				SysFileConvertQueue sysFileConvertQueue = (SysFileConvertQueue) pageContext
									.getAttribute("sysFileConvertQueue");
							if (sysFileConvertQueue != null) {
								out.append(AttModuleUtil
										.getModule(sysFileConvertQueue
												.getFdAttMainId()));
							}
			%>
		</list:data-column>
		<list:data-column property="fdFileExtName" title="文件扩展名"
			escape="false" style="text-align:center">
		</list:data-column>
		<list:data-column property="fdConverterKey" title="转换器" escape="false"
			style="text-align:center">
		</list:data-column>
		<list:data-column property="fdConvertNumber" title="转换次数"
			escape="false" style="text-align:center">
		</list:data-column>
		<list:data-column col="fdConvertStatus" title="状态" escape="false"
			style="text-align:center">
			<c:choose>
				<c:when test="${ sysFileConvertQueue.fdConvertStatus == 0 }">
					<c:out value="${ lfn:message('sys-filestore:convertStatus.0') }"></c:out>
				</c:when>
				<c:when test="${ sysFileConvertQueue.fdConvertStatus == 1 }">
					<c:out value="${ lfn:message('sys-filestore:convertStatus.1') }"></c:out>
				</c:when>
				<c:when test="${ sysFileConvertQueue.fdConvertStatus == 2 }">
					<c:out value="${ lfn:message('sys-filestore:convertStatus.2') }"></c:out>
				</c:when>
				<c:when test="${ sysFileConvertQueue.fdConvertStatus == 3 }">
					<c:out value="${ lfn:message('sys-filestore:convertStatus.3') }"></c:out>
				</c:when>
				<c:when test="${ sysFileConvertQueue.fdConvertStatus == 5 }">
					<c:out value="${ lfn:message('sys-filestore:convertStatus.5') }"></c:out>
				</c:when>
				<c:when test="${ sysFileConvertQueue.fdConvertStatus == 6 }">
					<c:out value="${ lfn:message('sys-filestore:convertStatus.6') }"></c:out>
				</c:when>
				<c:when test="${ sysFileConvertQueue.fdConvertStatus == 4 }">
					<c:out value="${ lfn:message('sys-filestore:convertStatus.4') }"></c:out>
				</c:when>
			</c:choose>
		</list:data-column>
		<list:data-column headerStyle="width:120px" col="fdStatusTime"
			title="状态时间">
			<c:if test="${not empty sysFileConvertQueue.fdStatusTime }">
				<kmss:showDate value="${sysFileConvertQueue.fdStatusTime}"
					type="datatime"></kmss:showDate>
			</c:if>
		</list:data-column>
		<list:data-column headerStyle="width:120px" col="fdCreateTime"
			title="入队时间">
			<c:if test="${not empty sysFileConvertQueue.fdCreateTime }">
				<kmss:showDate value="${sysFileConvertQueue.fdCreateTime}"
					type="datatime"></kmss:showDate>
			</c:if>
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>