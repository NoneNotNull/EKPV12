<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/kmtopic/kms_kmtopic_category/kmsKmtopicCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/kmtopic/kms_kmtopic_category/kmsKmtopicCategory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/kmtopic/kms_kmtopic_category/kmsKmtopicCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/kmtopic/kms_kmtopic_category/kmsKmtopicCategory.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsKmtopicCategoryForm, 'deleteall');">
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
				<sunbor:column property="kmsKmtopicCategory.fdName">
					<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmsKmtopicCategory.fdOrder">
					<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="kmsKmtopicCategory.docCreateTime">
					<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsKmtopicCategory.docAlterTime">
					<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.docAlterTime"/>
				</sunbor:column>
				<sunbor:column property="kmsKmtopicCategory.fdHierarchyId">
					<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.fdHierarchyId"/>
				</sunbor:column>
				<sunbor:column property="kmsKmtopicCategory.docCreator.fdName">
					<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.docCreator"/>
				</sunbor:column>
				<sunbor:column property="kmsKmtopicCategory.docAlteror.fdName">
					<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.docAlteror"/>
				</sunbor:column>
				<sunbor:column property="kmsKmtopicCategory.hbmParent.fdName">
					<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.hbmParent"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsKmtopicCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/kmtopic/kms_kmtopic_category/kmsKmtopicCategory.do" />?method=view&fdId=${kmsKmtopicCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsKmtopicCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsKmtopicCategory.fdName}" />
				</td>
				<td>
					<c:out value="${kmsKmtopicCategory.fdOrder}" />
				</td>
				<td>
					<kmss:showDate value="${kmsKmtopicCategory.docCreateTime}" />
				</td>
				<td>
					<kmss:showDate value="${kmsKmtopicCategory.docAlterTime}" />
				</td>
				<td>
					<c:out value="${kmsKmtopicCategory.fdHierarchyId}" />
				</td>
				<td>
					<c:out value="${kmsKmtopicCategory.docCreator.fdName}" />
				</td>
				<td>
					<c:out value="${kmsKmtopicCategory.docAlteror.fdName}" />
				</td>
				<td>
					<c:out value="${kmsKmtopicCategory.hbmParent.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>