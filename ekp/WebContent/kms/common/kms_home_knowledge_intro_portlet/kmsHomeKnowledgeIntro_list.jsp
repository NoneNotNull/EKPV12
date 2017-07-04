<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column property="fdId" >
		</list:data-column>
		<list:data-column property="fdId" col="id">
		</list:data-column>
		<list:data-column property="fdTopUrl">
		</list:data-column>
		<list:data-column property="fdTopName" col="name">
		</list:data-column>
		<list:data-column property="docAlterTime">
		</list:data-column>
	</list:data-columns>
	<list:data-paging page="${queryPage }">
	</list:data-paging>
</list:data>