<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/ask/kms_ask_introduce/kmsAskIntroduce.do">
<%-- 
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/ask/kms_ask_introduce/kmsAskIntroduce.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/ask/kms_ask_introduce/kmsAskIntroduce.do" />?method=add');">
		</kmss:auth>
	
		<kmss:auth requestURL="/kms/ask/kms_ask_introduce/kmsAskIntroduce.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsAskIntroduceForm, 'deleteall');">
		</kmss:auth>
	</div>
--%>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="kmsAskIntroduce.fdKmsAskTopic.docSubject">
					<bean:message bundle="kms-ask" key="kmsAskIntroduce.fdKmsAskTopic"/>
				</sunbor:column>
				<sunbor:column property="kmsAskIntroduce.fdIntroduceTime">
					<bean:message bundle="kms-ask" key="kmsAskIntroduce.fdIntroduceTime"/>
				</sunbor:column>
				<sunbor:column property="kmsAskIntroduce.fdReason">
					<bean:message bundle="kms-ask" key="kmsAskIntroduce.fdReason"/>
				</sunbor:column>
				<sunbor:column property="kmsAskIntroduce.fdPoster.fdName">
					<bean:message bundle="kms-ask" key="kmsAskIntroduce.fdPoster"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsAskIntroduce" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/ask/kms_ask_introduce/kmsAskIntroduce.do" />?method=view&fdId=${kmsAskIntroduce.fdId}">
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsAskIntroduce.fdKmsAskTopic.docSubject}" />
				</td>
				<td>
					<kmss:showDate value="${kmsAskIntroduce.fdIntroduceTime}" />
				</td>
				<td>
					<c:out value="${kmsAskIntroduce.fdReason}" />
				</td>
				<td>
					<c:out value="${kmsAskIntroduce.fdPoster.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>