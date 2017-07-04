<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/kmtopic/kms_kmtopic_catelog/kmsKmtopicCatelog.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/kmtopic/kms_kmtopic_catelog/kmsKmtopicCatelog.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/kmtopic/kms_kmtopic_catelog/kmsKmtopicCatelog.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/kmtopic/kms_kmtopic_catelog/kmsKmtopicCatelog.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsKmtopicCatelogForm, 'deleteall');">
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
				<sunbor:column property="kmsKmtopicCatelog.fdName">
					<bean:message bundle="kms-kmtopic" key="kmsKmtopicCatelog.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmsKmtopicCatelog.fdOrder">
					<bean:message bundle="kms-kmtopic" key="kmsKmtopicCatelog.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="kmsKmtopicCatelog.fdParentId">
					<bean:message bundle="kms-kmtopic" key="kmsKmtopicCatelog.fdParentId"/>
				</sunbor:column>
				<sunbor:column property="kmsKmtopicCatelog.fdCount">
					<bean:message bundle="kms-kmtopic" key="kmsKmtopicCatelog.fdCount"/>
				</sunbor:column>
				<sunbor:column property="kmsKmtopicCatelog.kmsKmtopicMain.docSubject">
					<bean:message bundle="kms-kmtopic" key="kmsKmtopicCatelog.kmsKmtopicMain"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsKmtopicCatelog" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/kmtopic/kms_kmtopic_catelog/kmsKmtopicCatelog.do" />?method=view&fdId=${kmsKmtopicCatelog.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsKmtopicCatelog.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsKmtopicCatelog.fdName}" />
				</td>
				<td>
					<c:out value="${kmsKmtopicCatelog.fdOrder}" />
				</td>
				<td>
					<c:out value="${kmsKmtopicCatelog.fdParentId}" />
				</td>
				<td>
					<c:out value="${kmsKmtopicCatelog.fdCount}" />
				</td>
				<td>
					<c:out value="${kmsKmtopicCatelog.kmsKmtopicMain.docSubject}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>