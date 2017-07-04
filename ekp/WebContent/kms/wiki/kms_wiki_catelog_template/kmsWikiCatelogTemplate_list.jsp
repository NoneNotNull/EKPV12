<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/wiki/kms_wiki_catelog_template/kmsWikiCatelogTemplate.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/wiki/kms_wiki_catelog_template/kmsWikiCatelogTemplate.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/wiki/kms_wiki_catelog_template/kmsWikiCatelogTemplate.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/wiki/kms_wiki_catelog_template/kmsWikiCatelogTemplate.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsWikiCatelogTemplateForm, 'deleteall');">
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
				<sunbor:column property="kmsWikiCatelogTemplate.fdName">
					<bean:message bundle="kms-wiki" key="kmsWikiCatelogTemplate.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiCatelogTemplate.fdOrder">
					<bean:message bundle="kms-wiki" key="kmsWikiCatelogTemplate.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiCatelogTemplate.fdKey">
					<bean:message bundle="kms-wiki" key="kmsWikiCatelogTemplate.fdKey"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiCatelogTemplate.fdTemplate.fdId">
					<bean:message bundle="kms-wiki" key="kmsWikiCatelogTemplate.fdTemplate"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsWikiCatelogTemplate" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/wiki/kms_wiki_catelog_template/kmsWikiCatelogTemplate.do" />?method=view&fdId=${kmsWikiCatelogTemplate.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsWikiCatelogTemplate.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsWikiCatelogTemplate.fdName}" />
				</td>
				<td>
					<c:out value="${kmsWikiCatelogTemplate.fdOrder}" />
				</td>
				<td>
					<c:out value="${kmsWikiCatelogTemplate.fdKey}" />
				</td>
				<td>
					<c:out value="${kmsWikiCatelogTemplate.fdTemplate.fdId}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>