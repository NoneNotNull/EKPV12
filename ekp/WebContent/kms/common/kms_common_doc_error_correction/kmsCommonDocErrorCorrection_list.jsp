<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column property="docDescription" title="纠错意见">
		</list:data-column>	
		<list:data-column property="docCreator.fdName" title="纠错人姓名 ">
		</list:data-column>		
		<list:data-column property="docCreateTime" title="纠错时间 ">
		</list:data-column>
		<list:data-column property="fdId">
		</list:data-column>		
	</list:data-columns>

	<list:data-paging page="${queryPage }" >
	</list:data-paging> 
</list:data>
