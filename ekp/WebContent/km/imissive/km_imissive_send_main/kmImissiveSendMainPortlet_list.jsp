<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmImissiveSendMain" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="docSubject" headerClass="width150" styleClass="width150" title="${ lfn:message('km-imissive:kmImissiveSendMain.docSubject') }" style="text-align:left;min-width:150px" escape="false">
			<a class="com_subject" title="${kmImissiveSendMain.docSubject}" href="${LUI_ContextPath}/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=view&fdId=${kmImissiveSendMain.fdId}" target="_blank">
			   <c:out value="${kmImissiveSendMain.docSubject}"/>
			 </a>
		</list:data-column>
		<list:data-column headerClass="width100" styleClass="width100" col="fdDocNum" title="${ lfn:message('km-imissive:kmImissiveSendMain.fdDocNum') }">
		    <c:if test="${empty kmImissiveSendMain.fdDocNum}">
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.docNum.info"/>
			</c:if>
			<c:if test="${not empty kmImissiveSendMain.fdDocNum}">
				<c:out value="${kmImissiveSendMain.fdDocNum}"/>
			</c:if>
		</list:data-column>
		<list:data-column headerClass="width80" styleClass="width80"  property="fdSendtoUnit.fdName" title="${ lfn:message('km-imissive:kmImissiveSendMain.fdSendtoDept')}">
		</list:data-column>
		<list:data-column headerClass="width60" styleClass="width60" col="fdDrafter.fdName" title="${ lfn:message('km-imissive:kmImissiveSendMain.fdDraftId') }" escape="false">
		   <ui:person personId="${kmImissiveSendMain.fdDrafter.fdId}" personName="${kmImissiveSendMain.fdDrafter.fdName}"></ui:person> 
		</list:data-column>
		<list:data-column headerClass="width60" styleClass="width60"  col="fdDraftTime" title="${ lfn:message('km-imissive:kmImissiveSendMain.fdDraftTime') }">
		    <kmss:showDate value="${kmImissiveSendMain.fdDraftTime}" type="date" />
		</list:data-column>
		<list:data-column headerClass="width40" styleClass="width40" col="docStatus" title="${ lfn:message('km-imissive:kmImissiveSendMain.docStatus') }">
			<sunbor:enumsShow
				value="${kmImissiveSendMain.docStatus}"
				enumsType="common_status" />
		</list:data-column>
	</list:data-columns>
</list:data>
