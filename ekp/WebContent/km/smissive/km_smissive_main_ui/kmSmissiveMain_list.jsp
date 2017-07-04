<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmSmissiveMain" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="docSubject" escape="false" title="${ lfn:message('km-smissive:kmSmissiveMain.docSubject') }" style="text-align:left">
		       <span class="com_subject"><c:out value="${kmSmissiveMain.docSubject}"/></span>
		</list:data-column>
		<list:data-column headerStyle="width:140px" property="fdFileNo" title="${ lfn:message('km-smissive:kmSmissiveMain.fdFileNo') }">
		</list:data-column> 
		<list:data-column headerStyle="width:60px" col="docAuthor.fdName" title="${ lfn:message('km-smissive:kmSmissiveMain.docAuthorId') }" escape="false">
		   <ui:person personId="${kmSmissiveMain.docCreator.fdId}" personName="${kmSmissiveMain.docCreator.fdName}"></ui:person> 
		</list:data-column>
		<list:data-column headerStyle="width:100px" property="fdMainDept.fdName" title="${ lfn:message('km-smissive:kmSmissiveMain.fdMainDeptId') }">
		</list:data-column>
		<list:data-column headerStyle="width:80px" col="docPublishTime" title="${ lfn:message('km-smissive:kmSmissiveMain.docPublishTime') }">
		    <kmss:showDate value="${kmSmissiveMain.docPublishTime}" type="date"/>
		</list:data-column>
		<list:data-column headerStyle="width:50px" col="docStatus" title="${ lfn:message('km-smissive:kmSmissiveMain.docStatus') }">
			<sunbor:enumsShow
				value="${kmSmissiveMain.docStatus}"
				enumsType="common_status" />
		</list:data-column>
   <c:if test="${docStatus!=30}">		
		<!-- 当前环节和当前处理人-->	
		<list:data-column headerStyle="width:70px" col="nodeName" title="${ lfn:message('km-smissive:sysWfNode.processingNode.currentProcess') }" escape="false">
			<kmss:showWfPropertyValues idValue="${kmSmissiveMain.fdId}" propertyName="nodeName" />
		</list:data-column>
		<list:data-column headerStyle="width:80px" col="handlerName" title="${ lfn:message('km-smissive:sysWfNode.processingNode.currentProcessor') }" escape="false">
		    <kmss:showWfPropertyValues idValue="${kmSmissiveMain.fdId}" propertyName="handlerName" />
		</list:data-column>
   </c:if>  		
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
