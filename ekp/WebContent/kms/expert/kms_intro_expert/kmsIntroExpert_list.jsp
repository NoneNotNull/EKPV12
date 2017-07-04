<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/expert/kms_intro_expert/kmsIntroExpert.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/expert/kms_intro_expert/kmsIntroExpert.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/expert/kms_intro_expert/kmsIntroExpert.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/expert/kms_intro_expert/kmsIntroExpert.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsIntroExpertForm, 'deleteall');">
		</kmss:auth>
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="kmsIntroExpert.fdName">
					<bean:message bundle="kms-expert" key="kmsIntroExpert.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmsIntroExpert.fdPhase">
					<bean:message bundle="kms-expert" key="kmsIntroExpert.fdPhase"/>
				</sunbor:column>
				<sunbor:column property="kmsIntroExpert.fdModelName">
					<bean:message bundle="kms-expert" key="kmsIntroExpert.fdModelName"/>
				</sunbor:column>
				<sunbor:column property="kmsIntroExpert.docCreateTime">
					<bean:message bundle="kms-expert" key="kmsIntroExpert.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsIntroExpert" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/expert/kms_intro_expert/kmsIntroExpert.do" />?method=edit&fdId=${kmsIntroExpert.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsIntroExpert.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsIntroExpert.fdName}" />
				</td>
				<td>
					第<c:out value="${kmsIntroExpert.fdPhase}" />期
				</td>
				<td>
					<c:out value="${kmsIntroExpert.fdModelName}" />
				</td>
				<td>
					<kmss:showDate value="${kmsIntroExpert.docCreateTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>