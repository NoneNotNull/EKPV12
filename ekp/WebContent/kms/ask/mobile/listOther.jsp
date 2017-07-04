<%@page import="com.landray.kmss.kms.ask.model.KmsAskTopic"%>
<%@page import="com.landray.kmss.kms.ask.model.KmsAskPost"%>
<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld"
	prefix="person"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }" mobile="true">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column property="docContent" col="label"
			title="${lfn:message('kms-ask:kmsAskTopic.topic') }" escape="false">
		</list:data-column>
		<list:data-column col="fdPostTime"
			title="${lfn:message('kms-ask:kmsAskTopic.fdAskTime') }">
			<kmss:showDate isInterval="true" value="${item.fdPostTime}" />
		</list:data-column>
		<list:data-column col="fdTopicId" property="fdKmsAskTopic.fdId">
		</list:data-column>
		<!--头像-->
		<list:data-column col="icon" escape="false">
			<person:headimageUrl personId="${item.fdPoster.fdId}" size="90" />
		</list:data-column>
		<list:data-column property="fdPoster.fdName" col="fdName">
		</list:data-column>
		<list:data-column property="fdIsBest">
		</list:data-column>
		<list:data-column col="canSetBestB">
			<%
				boolean flagSetBest = false;
							KmsAskPost post = (KmsAskPost) pageContext
									.getAttribute("item");
							KmsAskTopic topic = post.getFdKmsAskTopic();
							if (topic.getFdStatus().equals(0)) {
								flagSetBest = UserUtil.checkAuthentication(
										"/kms/ask/kms_ask_post/kmsAskPost.do?method=best&fdTopicId="
												+ topic.getFdId()
												+ "&categoryId="
												+ topic.getFdKmsAskCategory()
														.getFdId(), "GET");
							}
							out.print(flagSetBest);
			%>
		</list:data-column>

		<list:data-column col="canEvalB">
			<%
				boolean canEval = true;
							KmsAskPost post = (KmsAskPost) pageContext
									.getAttribute("item");
							String fdCurUserId = UserUtil.getUser().getFdId();
							if (UserUtil.getUser().isAnonymous()) {
								canEval = false;
							} else if (fdCurUserId.equals(post.getFdPoster()
									.getFdId())) {
								canEval = false;
							}
							out.print(canEval);
			%>
		</list:data-column>


		<list:data-column col="canAdditionB">
			<%
				boolean canAddition = false;
							KmsAskPost post = (KmsAskPost) pageContext
									.getAttribute("item");
							KmsAskTopic topic = post.getFdKmsAskTopic();
							if (UserUtil.getUser().getFdId()
									.equals(post.getFdPoster().getFdId())
									&& topic.getFdStatus().equals(0)) {
								canAddition = true;
							}
							out.print(canAddition);
			%>
		</list:data-column>
	</list:data-columns>

	<list:data-paging page="${queryPage }">
	</list:data-paging>
</list:data>
