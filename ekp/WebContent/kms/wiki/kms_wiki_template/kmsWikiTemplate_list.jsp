<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/wiki/kms_wiki_template/kmsWikiTemplate.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/wiki/kms_wiki_template/kmsWikiTemplate.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/wiki/kms_wiki_template/kmsWikiTemplate.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/wiki/kms_wiki_template/kmsWikiTemplate.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsWikiTemplateForm, 'deleteall');">
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
				<sunbor:column property="kmsWikiTemplate.fdName">
					<bean:message bundle="kms-wiki" key="kmsWikiTemplate.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiTemplate.fdOrder">
					<bean:message bundle="kms-wiki" key="kmsWikiTemplate.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiTemplate.docCreator.fdName">
					<bean:message bundle="kms-wiki" key="kmsWikiTemplate.docCreator"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiTemplate.docCreateTime">
					<bean:message bundle="kms-wiki" key="kmsWikiTemplate.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiTemplate.docAlteror.fdName">
					<bean:message bundle="kms-wiki" key="kmsWikiTemplate.docAlteror"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiTemplate.docAlterTime">
					<bean:message bundle="kms-wiki" key="kmsWikiTemplate.docAlterTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsWikiTemplate" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/wiki/kms_wiki_template/kmsWikiTemplate.do" />?method=view&fdId=${kmsWikiTemplate.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsWikiTemplate.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsWikiTemplate.fdName}" />
				</td>
				<td>
					<c:out value="${kmsWikiTemplate.fdOrder}" />
				</td>
				<td>
					<c:out value="${kmsWikiTemplate.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${kmsWikiTemplate.docCreateTime}" />
				</td>
				<td>
					<c:out value="${kmsWikiTemplate.docAlteror.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${kmsWikiTemplate.docAlterTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>