<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmImissiveReceiveMain" list="${queryPage.list }"> 
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="docSubject" headerClass="width120" title="${ lfn:message('km-imissive:kmImissiveReceiveMain.docSubject') }" style="text-align:left;min-width:150px" escape="false">
		   <span class="com_subject" title="${kmImissiveReceiveMain.docSubject}"><c:out value="${kmImissiveReceiveMain.docSubject}"/></span>
		</list:data-column>
		  <list:data-column headerClass="width100" property="fdReceiveUnit.fdName" title="${ lfn:message('km-imissive:kmImissiveReceiveMain.fdReceiveUnit') }">
		  </list:data-column>
		  <list:data-column headerClass="width100" col="fdSendtoUnit.fdName" title="${ lfn:message('km-imissive:kmImissiveReceiveMain.fdSendtoDept') }">
		   <c:out value="${kmImissiveReceiveMain.fdSendtoUnit.fdName}" /><c:out value="${kmImissiveReceiveMain.fdOutSendto}" />
		  </list:data-column>
		  <list:data-column headerClass="width120" property="fdReceiveNum" title="${ lfn:message('km-imissive:kmImissiveReceiveMain.fdReceiveNum') }">
		  </list:data-column>
		<list:data-column headerClass="width60" col="docStatus" title="${ lfn:message('km-imissive:kmImissiveReceiveMain.docStatus') }">
			<sunbor:enumsShow
				value="${kmImissiveReceiveMain.docStatus}"
				enumsType="common_status" />
		</list:data-column> 
		<!-- 当前环节和当前处理人-->	
		<list:data-column headerClass="width80" col="nodeName" title="${ lfn:message('km-imissive:sysWfNode.processingNode.currentProcess') }" escape="false">
			<kmss:showWfPropertyValues idValue="${kmImissiveReceiveMain.fdId}" propertyName="nodeName" />
		</list:data-column>
		<list:data-column headerClass="width80" col="handlerName" title="${ lfn:message('km-imissive:sysWfNode.processingNode.currentProcessor') }" escape="false">
		    <kmss:showWfPropertyValues idValue="${kmImissiveReceiveMain.fdId}" propertyName="handlerName" />
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>

