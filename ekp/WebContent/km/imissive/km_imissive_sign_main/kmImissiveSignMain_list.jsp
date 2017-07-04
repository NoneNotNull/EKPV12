<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmImissiveSignMain" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="docSubject" escape="false" title="${lfn:message('km-imissive:kmImissiveSignMain.docSubject')}" style="text-align:left">
		      <span class="com_subject"><c:out value="${kmImissiveSignMain.docSubject}"/></span>
		</list:data-column>
		<list:data-column headerStyle="width:150px" col="fdDocNum" title="${lfn:message('km-imissive:kmImissiveSignMain.fdDocNum')}">
		    <c:if test="${empty kmImissiveSignMain.fdDocNum}">
				<bean:message  bundle="km-imissive" key="kmImissiveSignMain.docNum.info"/>
			</c:if>
			<c:if test="${not empty kmImissiveSignMain.fdDocNum}">
				<c:out value="${kmImissiveSignMain.fdDocNum}"/>
			</c:if>
		</list:data-column>
		<list:data-column headerStyle="width:40px" col="fdDrafter.fdName" title="${lfn:message('km-imissive:kmImissiveSignMain.fdDraftId')}" escape="false">
		   <ui:person personId="${kmImissiveSignMain.fdDrafter.fdId}" personName="${kmImissiveSignMain.fdDrafter.fdName}"></ui:person> 
		</list:data-column>
		<list:data-column headerStyle="width:80px"  col="fdDraftTime" title="${lfn:message('km-imissive:kmImissiveSignMain.fdDraftTime')}">
		    <kmss:showDate value="${kmImissiveSignMain.fdDraftTime}" type="date" />
		</list:data-column>
		<list:data-column headerStyle="width:40px" col="docStatus" title="状态">
			<sunbor:enumsShow
				value="${kmImissiveSignMain.docStatus}"
				enumsType="common_status" />
		</list:data-column>
	<c:if test="${fdstatus!=30}">		
		<!-- 当前环节和当前处理人-->	
		<list:data-column headerStyle="width:70px" col="nodeName" title="当前环节" escape="false">
			<kmss:showWfPropertyValues idValue="${kmImissiveSignMain.fdId}" propertyName="nodeName" />
		</list:data-column>
		<list:data-column headerStyle="width:80px" col="handlerName" title="当前处理人" escape="false">
		    <kmss:showWfPropertyValues idValue="${kmImissiveSignMain.fdId}" propertyName="handlerName" />
		</list:data-column>
   </c:if>  		
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
