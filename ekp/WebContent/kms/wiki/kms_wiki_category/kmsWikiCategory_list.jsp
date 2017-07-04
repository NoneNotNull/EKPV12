<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/wiki/kms_wiki_category/kmsWikiCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/wiki/kms_wiki_category/kmsWikiCategory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/wiki/kms_wiki_category/kmsWikiCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/wiki/kms_wiki_category/kmsWikiCategory.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsWikiCategoryForm, 'deleteall');">
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
				<sunbor:column property="kmsWikiCategory.fdName">
					<bean:message bundle="kms-wiki" key="kmsWikiCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiCategory.fdOrder">
					<bean:message bundle="kms-wiki" key="kmsWikiCategory.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiCategory.fdParentId">
					<bean:message bundle="kms-wiki" key="kmsWikiCategory.fdParentId"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiCategory.docCreateTime">
					<bean:message bundle="kms-wiki" key="kmsWikiCategory.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiCategory.docAlterTime">
					<bean:message bundle="kms-wiki" key="kmsWikiCategory.docAlterTime"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiCategory.fdTemplate.fdId">
					<bean:message bundle="kms-wiki" key="kmsWikiCategory.fdTemplate"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiCategory.docCreator.fdName">
					<bean:message bundle="kms-wiki" key="kmsWikiCategory.docCreator"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiCategory.docAlteror.fdName">
					<bean:message bundle="kms-wiki" key="kmsWikiCategory.docAlteror"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsWikiCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/wiki/kms_wiki_category/kmsWikiCategory.do" />?method=view&fdId=${kmsWikiCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsWikiCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsWikiCategory.fdName}" />
				</td>
				<td>
					<c:out value="${kmsWikiCategory.fdOrder}" />
				</td>
				<td>
					<c:out value="${kmsWikiCategory.fdParentId}" />
				</td>
				<td>
					<kmss:showDate value="${kmsWikiCategory.docCreateTime}" />
				</td>
				<td>
					<kmss:showDate value="${kmsWikiCategory.docAlterTime}" />
				</td>
				<td>
					<c:out value="${kmsWikiCategory.fdTemplate.fdId}" />
				</td>
				<td>
					<c:out value="${kmsWikiCategory.docCreator.fdName}" />
				</td>
				<td>
					<c:out value="${kmsWikiCategory.docAlteror.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>