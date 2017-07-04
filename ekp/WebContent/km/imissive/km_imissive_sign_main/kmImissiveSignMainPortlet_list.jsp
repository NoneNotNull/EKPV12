<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmImissiveSignMain" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="docSubject" title="${ lfn:message('km-imissive:kmImissiveSignMain.docSubject') }" style="text-align:left;min-width:150px" escape="false">
			<a class="com_subject" title="${kmImissiveSignMain.docSubject}" href="${LUI_ContextPath}/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=view&fdId=${kmImissiveSignMain.fdId}" target="_blank">
			   <c:out value="${kmImissiveSignMain.docSubject}"/>
			 </a>
		</list:data-column>
		<list:data-column headerClass="width120" styleClass="width120" col="fdDocNum" title="${ lfn:message('km-imissive:kmImissiveSignMain.fdDocNum') }">
		    <c:if test="${empty kmImissiveSignMain.fdDocNum}">
				<bean:message  bundle="km-imissive" key="kmImissiveSignMain.docNum.info"/>
			</c:if>
			<c:if test="${not empty kmImissiveSignMain.fdDocNum}">
				<c:out value="${kmImissiveSignMain.fdDocNum}"/>
			</c:if>
		</list:data-column>
		<list:data-column headerClass="width80" styleClass="width80" col="fdDrafter.fdName" title="${ lfn:message('km-imissive:kmImissiveSignMain.fdDraftId') }" escape="false">
		   <ui:person personId="${kmImissiveSignMain.fdDrafter.fdId}" personName="${kmImissiveSignMain.fdDrafter.fdName}"></ui:person> 
		</list:data-column>
		<list:data-column headerClass="width80" styleClass="width80"  col="fdDraftTime" title="${ lfn:message('km-imissive:kmImissiveSignMain.fdDraftTime') }">
		    <kmss:showDate value="${kmImissiveSignMain.fdDraftTime}" type="date" />
		</list:data-column>
		<list:data-column headerClass="width60" styleClass="width60" col="docStatus" title="${ lfn:message('km-imissive:kmImissiveSignMain.docStatus') }">
			<sunbor:enumsShow
				value="${kmImissiveSignMain.docStatus}"
				enumsType="common_status" />
		</list:data-column>
	</list:data-columns>
</list:data>
