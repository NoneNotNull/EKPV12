<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmImissiveSendMain" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="docSubject" escape="false" title="标题" style="text-align:left;min-width:150px">
		      <span class="com_subject"><c:out value="${kmImissiveSendMain.docSubject}"/></span>
		</list:data-column>
		<list:data-column headerClass="width120" col="fdDocNum" title="文号">
		    <c:if test="${empty kmImissiveSendMain.fdDocNum}">
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.docNum.info"/>
			</c:if>
			<c:if test="${not empty kmImissiveSendMain.fdDocNum}">
				<c:out value="${kmImissiveSendMain.fdDocNum}"/>
			</c:if>
		</list:data-column>
		<list:data-column headerClass="width80"  property="fdSendtoUnit.fdName" title="发文单位">
		</list:data-column>
		<list:data-column headerClass="width60" col="fdDrafter.fdName" title="拟稿人" escape="false">
		   <ui:person personId="${kmImissiveSendMain.fdDrafter.fdId}" personName="${kmImissiveSendMain.fdDrafter.fdName}"></ui:person> 
		</list:data-column>
		<list:data-column headerClass="width80"  col="fdDraftTime" title="拟稿时间">
		    <kmss:showDate value="${kmImissiveSendMain.fdDraftTime}" type="date" />
		</list:data-column>
		<list:data-column headerClass="width40" col="docStatus" title="状态">
			<sunbor:enumsShow
				value="${kmImissiveSendMain.docStatus}"
				enumsType="common_status" />
		</list:data-column>
	<c:if test="${fdstatus!=30}">		
		<!-- 当前环节和当前处理人-->	
		<list:data-column headerClass="width80" col="nodeName" title="当前环节" escape="false">
			<kmss:showWfPropertyValues idValue="${kmImissiveSendMain.fdId}" propertyName="nodeName" />
		</list:data-column>
		<list:data-column headerClass="width80" col="handlerName" title="当前处理人" escape="false">
		    <kmss:showWfPropertyValues idValue="${kmImissiveSendMain.fdId}" propertyName="handlerName" />
		</list:data-column>
   </c:if>  		
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
