<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/common/kms_home_knowledge_intro/kmsHomeKnowledgeIntro.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/common/kms_home_knowledge_intro/kmsHomeKnowledgeIntro.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/common/kms_home_knowledge_intro/kmsHomeKnowledgeIntro.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/common/kms_home_knowledge_intro/kmsHomeKnowledgeIntro.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsHomeKnowledgeIntroForm, 'deleteall');">
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
				<sunbor:column property="kmsHomeKnowledgeIntro.fdName">
					<bean:message bundle="kms-common" key="kmsHomeKnowledgeIntro.fdName"/>
				</sunbor:column>
				<%--
				<sunbor:column property="kmsHomeKnowledgeIntro.fdModelName">
					<bean:message bundle="kms-common" key="kmsHomeKnowledgeIntro.fdModelName"/>
				</sunbor:column> --%>  
				<td>
					<bean:message key="button.edit"/>
				</td>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsHomeKnowledgeIntro" varStatus="vstatus">
			<tr>
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsHomeKnowledgeIntro.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsHomeKnowledgeIntro.fdName}" />
				</td>
				<%--
				<td>
					<c:out value="${kmsHomeKnowledgeIntro.fdModelName}" />
				</td> --%>  
				<td>
					<a target="_blank" href="<c:url value="/kms/common/kms_home_knowledge_intro/kmsHomeKnowledgeIntro.do" />?method=edit&fdId=${kmsHomeKnowledgeIntro.fdId}">
						<bean:message key="button.edit"/>
					</a>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>