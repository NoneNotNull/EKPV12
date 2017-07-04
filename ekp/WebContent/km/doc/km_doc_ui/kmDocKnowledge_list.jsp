<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmDocKnowledge" list="${queryPage.list }" varIndex="status">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="index">
		  ${status+1}
		</list:data-column>
		<!-- 主题-->
		<list:data-column   col="docSubject" escape="false"  title="${ lfn:message('sys-doc:sysDocBaseInfo.docSubject') }" style="text-align:left">
		    <c:out value="${kmDocKnowledge.docSubject}"></c:out> 
		    <c:if test="${kmDocKnowledge.docIsIntroduced==true}">
		  	  <img src="${LUI_ContextPath}/km/doc/resource/images/jing.gif" border=0 title="<bean:message key="kmDoc.tree.jing" bundle="km-doc"/>" />
		    </c:if>
		</list:data-column>
		<!-- 主题摘要视图-->
		<list:data-column   col="row_docSubject" escape="false"  title="${ lfn:message('sys-doc:sysDocBaseInfo.docSubject') }" style="text-align:left">
		    <c:if test="${kmDocKnowledge.docIsIntroduced==true}">
		  	  <img src="${LUI_ContextPath}/km/doc/resource/images/jing.gif" border=0 title="<bean:message key="kmDoc.tree.jing" bundle="km-doc"/>" />
		    </c:if>
		    <span title="${kmDocKnowledge.docSubject}">
		      <c:out value="${kmDocKnowledge.docSubject}"></c:out> 
		    </span>  
		</list:data-column>
		<!--作者-->
		<list:data-column headerStyle="width:60px" col="docAuthor.fdName" title="${ lfn:message('sys-doc:sysDocBaseInfo.docAuthor') }" escape="false"> 
		      <ui:person personId="${kmDocKnowledge.docAuthor.fdId}" personName="${kmDocKnowledge.docAuthor.fdName}"></ui:person> 
		</list:data-column>
		<!-- 所属部门-->
		<list:data-column headerStyle="width:80px" property="docDept.fdName" title="${ lfn:message('sys-doc:sysDocBaseInfo.docDept') }">
		</list:data-column>
		<!--发布时间-->
		<list:data-column headerStyle="width:80px" col="docPublishTime" title="${ lfn:message('km-doc:kmDocKnowledge.docPublishTime') }" escape="false">
		    <kmss:showDate value="${kmDocKnowledge.docPublishTime}" type="date" /> 
		</list:data-column>
		<!--文档状态-->
		<list:data-column headerStyle="width:60px" col="docStatus" title="${ lfn:message('km-doc:kmDoc.kmDocKnowledge.docStatus') }">
			<sunbor:enumsShow
				value="${kmDocKnowledge.docStatus}"
				enumsType="common_status" />
		</list:data-column> 
		<list:data-column headerStyle="width:60px" col="docReadCount" title="${lfn:message('km-doc:kmDoc.kmDocKnowledge.read') }" escape="false">
			${kmDocKnowledge.docReadCount}
		</list:data-column>
		<!--摘要视图所属分类-->
		<list:data-column headerStyle="width:80px" col="kmDocTemplateName_row" title="${ lfn:message('km-doc:kmDocKnowledge.fdTemplateName') }" escape="false">
		   <c:if test="${not empty kmDocKnowledge.kmDocTemplate.fdName}">
		    ${ lfn:message('km-doc:kmDocKnowledge.fdTemplateName') }：<c:out value="${kmDocKnowledge.kmDocTemplate.fdName}"/>
		    </c:if>
		</list:data-column>
		<!--发布时间摘要视图-->
		<list:data-column headerStyle="width:80px" col="docPublishTime_row" title="${ lfn:message('km-doc:kmDocKnowledge.docPublishTime') }" escape="false">
		   <c:if test="${not empty kmDocKnowledge.docPublishTime}">
		    ${ lfn:message('km-doc:kmDocKnowledge.docPublishTime') }：<kmss:showDate value="${kmDocKnowledge.docPublishTime}" type="date" /> 
		    </c:if>
		</list:data-column>
		
			<!-- 摘要-->
	<list:data-column headerStyle="width:80px"  col="fdDescription_row" title="${ lfn:message('sys-doc:sysDocBaseInfo.fdDescription')}" escape="false">
	                <c:out value="${kmDocKnowledge.fdDescription}"/>
	</list:data-column>
	
			<!-- 标签-->
	<list:data-column headerStyle="width:80px"  col="sysTagMain_row" title="${ lfn:message('km-doc:kmDoc.kmDocKnowledge.tag')}" escape="false">
	                 <c:if test="${not empty tagJson[kmDocKnowledge.fdId]}">
	                    ${lfn:message('km-doc:kmDoc.kmDocKnowledge.tag') }：${tagJson[kmDocKnowledge.fdId]}
	                 </c:if>
	</list:data-column>
	</list:data-columns>



	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>