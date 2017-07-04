<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/ask/kms_ask_post/kmsAskPost.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/ask/kms_ask_post/kmsAskPost.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/ask/kms_ask_post/kmsAskPost.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/ask/kms_ask_post/kmsAskPost.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsAskPostForm, 'deleteall');">
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
				<sunbor:column property="kmsAskPost.fdIsBest">
					<bean:message bundle="kms-ask" key="kmsAskPost.fdIsBest"/>
				</sunbor:column>
				<sunbor:column property="kmsAskPost.fdTopicFlag">
					<bean:message bundle="kms-ask" key="kmsAskPost.fdTopicFlag"/>
				</sunbor:column>
				<sunbor:column property="kmsAskPost.fdAgreeNum">
					<bean:message bundle="kms-ask" key="kmsAskPost.fdAgreeNum"/>
				</sunbor:column>
				<sunbor:column property="kmsAskPost.fdPostTime">
					<bean:message bundle="kms-ask" key="kmsAskPost.fdPostTime"/>
				</sunbor:column>
				<sunbor:column property="kmsAskPost.fdCommentNum">
					<bean:message bundle="kms-ask" key="kmsAskPost.fdCommentNum"/>
				</sunbor:column>
				<sunbor:column property="kmsAskPost.fdKmsAskTopic.docSubject">
					<bean:message bundle="kms-ask" key="kmsAskPost.fdKmsAskTopic"/>
				</sunbor:column>
				<sunbor:column property="kmsAskPost.fdPoster.fdName">
					<bean:message bundle="kms-ask" key="kmsAskPost.fdPoster"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsAskPost" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/ask/kms_ask_post/kmsAskPost.do" />?method=view&fdId=${kmsAskPost.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsAskPost.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<sunbor:enumsShow value="${kmsAskPost.fdIsBest}" enumsType="common_yesno" />
				</td>
				<td>
					<sunbor:enumsShow value="${kmsAskPost.fdTopicFlag}" enumsType="common_yesno" />
				</td>
				<td>
					<c:out value="${kmsAskPost.fdAgreeNum}" />
				</td>
				<td>
					<kmss:showDate value="${kmsAskPost.fdPostTime}" />
				</td>
				<td>
					<c:out value="${kmsAskPost.fdCommentNum}" />
				</td>
				<td>
					<c:out value="${kmsAskPost.fdKmsAskTopic.docSubject}" />
				</td>
				<td>
					<c:out value="${kmsAskPost.fdPoster.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>