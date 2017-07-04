<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<%--悬赏分数--%>
		<c:if test="${s_money == true }">
			<list:data-column  
			    col="fdScore" 
			    title="${lfn:message('kms-ask:kmsAskTopic.fdScores') }"  
			    escape="false" 
			    style="width:40px;border-bottom:none;height:22px;line-height:22px;" 
			    headerStyle="width:40px;">
				<span class="com_number" style="white-space: nowrap;"><img src="${LUI_ContextPath}/kms/ask/kms_ask_ui/style/img/ic_money.png" border="0" style="padding-right:6px;vertical-align: -2px;">${item.fdScore}</span>
			</list:data-column>
		</c:if>
		<list:data-column 
				col="docSubject" 
				title="${lfn:message('kms-ask:kmsAskTopic.topic') }" 
				escape="false" 
				style="padding:3px 0px;text-align:left;text-overflow: ellipsis; white-space: nowrap;overflow:hidden;border-bottom:none;height:22px;line-height:22px;" >
			<c:if test="${s_category == true}">
				<a  href="${LUI_ContextPath}/kms/ask/?categoryId=${item.fdKmsAskCategory.fdId}" target="_blank" title="${item.fdKmsAskCategory.fdName}">
					<span style="color:#0b93e1;">【</span><span style="color:#0b93e1;vertical-align: top;max-width:80px;text-overflow: ellipsis; white-space: nowrap;overflow:hidden;display: inline-block;">
					    <c:out value="${item.fdKmsAskCategory.fdName }"/></span><span style="color:#0b93e1;">】</span>
			    </a>
			</c:if>
			<a  href="${LUI_ContextPath}/kms/ask/kms_ask_topic/kmsAskTopic.do?method=view&fdId=${item.fdId}" target="_blank" title="${item.docSubject }">
				<c:out value="${item.docSubject }"/>
			</a>
		</list:data-column>
		<%-- 回答数--%>
		<c:if test="${s_reply == true }">
			<list:data-column col="fdReplyCount" 
			  title="${lfn:message('kms-ask:kmsAskTopic.replyCount') }" 
			  escape="false" style="width:65px;border-bottom:none;height:22px;line-height:22px;"
			  headerStyle="width:65px;">
				<span  style="color: #9e9e9e;white-space: nowrap;">${item.fdReplyCount}  ${lfn:message('kms-ask:kmsAsk.portlet.reply')}</span>
			</list:data-column>
		</c:if>
		<%-- 回答状态--%>
		<c:if test="${s_status == true }">
			<list:data-column 
			     title="${lfn:message('kms-ask:kmsAskTopic.fdAskStatus') }" 
			     col="fdStatus" escape="false" 
			     style="width:30px;border-bottom:none;height:22px;line-height:22px;"
			     headerStyle="width:30px;">
				<c:if test="${ item.fdStatus == 0}">
					<span><img src="${LUI_ContextPath}/kms/ask/kms_ask_ui/style/img/ico_help.png" border="0" style="vertical-align: -2px;"></span>
				</c:if>
				<c:if test="${ item.fdStatus > 0}">
					<span><img src="${LUI_ContextPath}/kms/ask/kms_ask_ui/style/img/icon_ask_sure.png" border="0" style="vertical-align: -2px;"></span>
				</c:if>
			</list:data-column>
		</c:if>
		<%-- 提问时间--%>
		<c:if test="${s_time == true }">
			<list:data-column  
			    col="fdPostTime" 
			    title="${lfn:message('kms-ask:kmsAskTopic.fdAskTime') }" 
			    style="width:105px;border-bottom:none;height:22px;line-height:22px;"
			   headerStyle="width:105px;" 
			     escape="false">
				<span style="color: #9e9e9e;white-space: nowrap;"><kmss:showDate value="${item.fdPostTime}" type="interval"></kmss:showDate></span>
			</list:data-column>
		</c:if>
	</list:data-columns>

	<list:data-paging page="${queryPage }" >
	</list:data-paging>
</list:data>
