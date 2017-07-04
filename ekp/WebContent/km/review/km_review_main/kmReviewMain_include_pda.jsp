<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/resource/jsp/common.jsp"%>

<%--驳回后的编辑按钮 --%>	
<div id="div_OptButton" class="optDetailTrHide">
	<c:if test="${kmReviewMainForm.docStatus=='11'}">
			<kmss:auth
				requestURL="/km/review/km_review_main/kmReviewMain.do?method=edit&fdId=${param.fdId}"
				requestMethod="GET">
				<div class="div_more" 
					 onclick="Com_OpenWindow('kmReviewMain.do?method=edit&fdId=${param.fdId}&isAppflag=${param['isAppflag']}','_self');">
					<bean:message key="button.edit"/>
				</div>
			</kmss:auth>
	</c:if>
</div>