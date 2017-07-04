<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column property="fdVersion" title="版本号">
		</list:data-column>
		<list:data-column property="docCreateTime" title="创建时间">
		</list:data-column>	
		<list:data-column property="docAlterTime" title="完善时间">
		</list:data-column>	
		<list:data-column title="完善时间" col="alterTime" >
			<c:if test="${not empty item.docAlterTime}"> 
				<kmss:showDate value="${item.docAlterTime}" type="date"></kmss:showDate>
			</c:if>
			<c:if test="${empty item.docAlterTime}"> 
				<kmss:showDate value="${item.docCreateTime}" type="date"></kmss:showDate>
			</c:if>
		</list:data-column>	
		<list:data-column property="docCreator.fdName" title="完善人" col="docCreatorName">
		</list:data-column>		
		<list:data-column property="fdReason" title="完善原因">
		</list:data-column>  
	</list:data-columns>

	<list:data-paging page="${queryPage }" >
	</list:data-paging>
</list:data>