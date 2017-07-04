<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmDocKnowledge" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<!-- 主题-->
		<list:data-column   col="docSubject"  title="${ lfn:message('sys-doc:sysDocBaseInfo.docSubject') }" escape="false" style="text-align:left;width:60%">
		    <a href="${LUI_ContextPath}/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=view&fdId=${kmDocKnowledge.fdId}" target="_blank">
		        <c:out value="${kmDocKnowledge.docSubject}"/>
		    </a>  
		</list:data-column>
		<!-- 所属部门-->
		<list:data-column headerStyle="100px" property="docDept.fdName" title="${ lfn:message('sys-doc:sysDocBaseInfo.docDept')}" style="width:15%"  escape="false">
		    <c:out value="${kmDocKnowledge.docDept.fdName}"/>
		</list:data-column>
		<!--文档状态-->
		<list:data-column headerStyle="100px" col="docStatus" title="${ lfn:message('km-doc:kmDoc.kmDocKnowledge.docStatus') }" style="width:10%" escape="false">
			 <sunbor:enumsShow
				value="${kmDocKnowledge.docStatus}"
				enumsType="common_status" />
		</list:data-column> 
		<!--发布时间-->
		<list:data-column headerStyle="100px" col="docCreateTime" title="${ lfn:message('sys-doc:sysDocBaseInfo.docPublishTime') }" style="width:15%" escape="false">
		  <kmss:showDate value="${kmDocKnowledge.docPublishTime}" type="date" />
		</list:data-column>
	</list:data-columns>
</list:data>