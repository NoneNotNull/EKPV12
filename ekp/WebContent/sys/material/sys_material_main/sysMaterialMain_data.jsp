<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.sys.material.model.SysMaterialMain"%>
<list:data>
	<list:data-columns var="sysMaterialMain" list="${queryPage.list }" varIndex="status">
		<list:data-column property="fdId">
		</list:data-column>		
		<list:data-column col="index">
		      ${status+1}
		</list:data-column >
		<list:data-column col="fdImageUrl" escape="false">
			<c:out value="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysMaterialMain.fdAttId}"></c:out>
		</list:data-column>
	</list:data-columns>
	
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>