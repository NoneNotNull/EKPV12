<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%--@ include file="kmReviewMain_list_query.jsp"--%>
	<%
	if (((com.sunbor.web.tag.Page) request.getAttribute("queryPage")).getTotalrows() == 0) {
	%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<%
	} else {
		new com.landray.kmss.sys.workflow.engine.spi.actions.SysWfPageCache().setWfPageCache(request);
	%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial" /></td>

				<!-- 流程名称 -->
				<sunbor:column property="kmReviewMain.docSubject">
					<bean:message bundle="km-review" key="kmReviewMain.docSubject" />
				</sunbor:column>

				<sunbor:column property="kmReviewMain.fdNumber">
					<bean:message bundle="km-review" key="kmReviewMain.fdNumber" />
				</sunbor:column>

				<sunbor:column property="kmReviewMain.docCreator">
					<bean:message bundle="km-review" key="kmReviewMain.docCreatorName" />
				</sunbor:column>
				
				<sunbor:column property="kmReviewMain.docCreateTime">
					<bean:message bundle="km-review" key="kmReviewMain.docCreateTime" />
				</sunbor:column>
				
				<sunbor:column property="kmReviewMain.docPublishTime">
					<bean:message bundle="km-review" key="kmReviewMain.docPublishTime" />
				</sunbor:column>
				
				<sunbor:column property="kmReviewMain.docStatus">
					<bean:message bundle="km-review" key="kmReviewMain.docStatus" />
				</sunbor:column>
				
				<td>
					<bean:message bundle="km-review" key="sysWfNode.processingNode.currentProcess" />
				</td>
				<td>
					<bean:message bundle="km-review" key="sysWfNode.processingNode.currentProcessor" />
				</td>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmReviewMain"
			varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/review/km_review_main/kmReviewMain.do" />?method=view&fdId=${kmReviewMain.fdId}">
				<td><input type="checkbox" name="List_Selected"
					value="${kmReviewMain.fdId}"></td>
				<td>${vstatus.index+1}</td>
				<td kmss_wordlength="50">
					<c:out value="${kmReviewMain.docSubject}" />
				</td>
				<td>
					<c:out value="${kmReviewMain.fdNumber}" />
				</td>			
				<td>
					<c:out value="${kmReviewMain.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${kmReviewMain.docCreateTime}" type="datetime"/>
				</td>
				<td>
					<kmss:showDate value="${kmReviewMain.docPublishTime}" type="datetime"/>
				</td>
				<td>
					<c:if test="${kmReviewMain.docStatus=='00'}">
						<bean:message bundle="km-review" key="status.discard"/>
					</c:if>
					<c:if test="${kmReviewMain.docStatus=='10'}">
						<bean:message bundle="km-review" key="status.draft"/>
					</c:if>
					<c:if test="${kmReviewMain.docStatus=='11'}">
						<bean:message bundle="km-review" key="status.refuse"/>
					</c:if>
					<c:if test="${kmReviewMain.docStatus=='20'}">
						<bean:message bundle="km-review" key="status.append"/>
					</c:if>
					<c:if test="${kmReviewMain.docStatus=='30'}">
						<bean:message bundle="km-review" key="status.publish"/>
					</c:if>
					<c:if test="${kmReviewMain.docStatus=='31'}">
						<bean:message bundle="km-review" key="status.feedback" />
					</c:if>
				</td>				
			<td><kmss:showWfPropertyValues
				idValue="${kmReviewMain.fdId}"
				propertyName="nodeName" /></td>
			<td><kmss:showWfPropertyValues
				idValue="${kmReviewMain.fdId}"
				propertyName="handlerName" /></td>
				
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%
	}
	%>

