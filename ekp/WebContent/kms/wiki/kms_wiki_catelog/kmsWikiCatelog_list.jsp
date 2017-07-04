<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/wiki/kms_wiki_catelog/kmsWikiCatelog.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/wiki/kms_wiki_catelog/kmsWikiCatelog.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/wiki/kms_wiki_catelog/kmsWikiCatelog.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/wiki/kms_wiki_catelog/kmsWikiCatelog.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsWikiCatelogForm, 'deleteall');">
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
				<sunbor:column property="kmsWikiCatelog.fdName">
					<bean:message bundle="kms-wiki" key="kmsWikiCatelog.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiCatelog.fdKey">
					<bean:message bundle="kms-wiki" key="kmsWikiCatelog.fdKey"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiCatelog.fdOrder">
					<bean:message bundle="kms-wiki" key="kmsWikiCatelog.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiCatelog.fdParentId">
					<bean:message bundle="kms-wiki" key="kmsWikiCatelog.fdParentId"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiCatelog.fdMain.fdId">
					<bean:message bundle="kms-wiki" key="kmsWikiCatelog.fdMain"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsWikiCatelog" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/wiki/kms_wiki_catelog/kmsWikiCatelog.do" />?method=view&fdId=${kmsWikiCatelog.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsWikiCatelog.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsWikiCatelog.fdName}" />
				</td>
				<td>
					<c:out value="${kmsWikiCatelog.fdKey}" />
				</td>
				<td>
					<c:out value="${kmsWikiCatelog.fdOrder}" />
				</td>
				<td>
					<c:out value="${kmsWikiCatelog.fdParentId}" />
				</td>
				<td>
					<c:out value="${kmsWikiCatelog.fdMain.fdId}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>