<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/ask/kms_ask_agree/kmsAskAgree.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/ask/kms_ask_agree/kmsAskAgree.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/ask/kms_ask_agree/kmsAskAgree.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/ask/kms_ask_agree/kmsAskAgree.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsAskAgreeForm, 'deleteall');">
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
				<sunbor:column property="kmsAskAgree.fdAgreeTime">
					<bean:message bundle="kms-ask" key="kmsAskAgree.fdAgreeTime"/>
				</sunbor:column>
				<sunbor:column property="kmsAskAgree.fdPoster.fdName">
					<bean:message bundle="kms-ask" key="kmsAskAgree.fdPoster"/>
				</sunbor:column>
				<sunbor:column property="kmsAskAgree.fdKmsAskPost.docSubject">
					<bean:message bundle="kms-ask" key="kmsAskAgree.fdKmsAskPost"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsAskAgree" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/ask/kms_ask_agree/kmsAskAgree.do" />?method=view&fdId=${kmsAskAgree.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsAskAgree.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<kmss:showDate value="${kmsAskAgree.fdAgreeTime}" />
				</td>
				<td>
					<c:out value="${kmsAskAgree.fdPoster.fdName}" />
				</td>
				<td>
					<c:out value="${kmsAskAgree.fdKmsAskPost.docSubject}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>