<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/common/kms_home_knowledge_mapping/kmsHomeKnowledgeMapping.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/common/kms_home_knowledge_mapping/kmsHomeKnowledgeMapping.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/common/kms_home_knowledge_mapping/kmsHomeKnowledgeMapping.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/common/kms_home_knowledge_mapping/kmsHomeKnowledgeMapping.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsHomeKnowledgeMappingForm, 'deleteall');">
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
				<sunbor:column property="kmsHomeKnowledgeMapping.docSubject">
					<bean:message bundle="kms-common" key="kmsHomeKnowledgeMapping.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmsHomeKnowledgeMapping.fdUrl">
					<bean:message bundle="kms-common" key="kmsHomeKnowledgeMapping.fdUrl"/>
				</sunbor:column>
				<sunbor:column property="kmsHomeKnowledgeMapping.fdMainContent">
					<bean:message bundle="kms-common" key="kmsHomeKnowledgeMapping.fdMainContent"/>
				</sunbor:column>
				<sunbor:column property="kmsHomeKnowledgeMapping.fdIsFirst">
					<bean:message bundle="kms-common" key="kmsHomeKnowledgeMapping.fdIsFirst"/>
				</sunbor:column>
				<sunbor:column property="kmsHomeKnowledgeMapping.fdMapping.fdName">
					<bean:message bundle="kms-common" key="kmsHomeKnowledgeMapping.fdMapping"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsHomeKnowledgeMapping" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/common/kms_home_knowledge_mapping/kmsHomeKnowledgeMapping.do" />?method=view&fdId=${kmsHomeKnowledgeMapping.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsHomeKnowledgeMapping.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsHomeKnowledgeMapping.docSubject}" />
				</td>
				<td>
					<c:out value="${kmsHomeKnowledgeMapping.fdUrl}" />
				</td>
				<td>
					<c:out value="${kmsHomeKnowledgeMapping.fdMainContent}" />
				</td>
				<td>
					<xform:radio value="${kmsHomeKnowledgeMapping.fdIsFirst}" property="fdIsFirst" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio>
				</td>
				<td>
					<c:out value="${kmsHomeKnowledgeMapping.fdMapping.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>