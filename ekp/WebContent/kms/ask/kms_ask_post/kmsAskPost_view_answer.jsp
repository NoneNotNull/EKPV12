<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.kms.communitycko.model.KmsCommunityckoAskScoreConfig"%>
	<c:if test="${kmsAskTopicForm.fdStatus==0}">
		<c:if test="${isReplyer==false&&isPoster==false}">
			<kmss:auth requestURL="/kms/ask/kms_ask_post/kmsAskPost.do?method=add&fdTopicId=${param.fdId}" requestMethod="GET">
				<%
					request.setAttribute("fdAskScore",new KmsCommunityckoAskScoreConfig().getFdAnswerScore());
				%>
				<html:form action="/kms/ask/kms_ask_post/kmsAskPost.do?method=save&fdTopicId=${param.fdId }" method="post" >
					<div class="box7_2 m_t10" id="ask_reply">
						<div class="title5 c"><h2 class="h2_3">我来解答</h2></div>	
						<div class="m_t10">
							<kmss:editor property="docContent" height="200" toolbarStartExpanded="false" />  
							<br>
							<bean:message bundle="kms-ask" key="kmsAskPost.score.msg" arg0="${fdAskScore}" />
							<div class="btn_o r m_t10">
								<a href="javascript:void(0)" title="提交回答" onclick="authentication()" id="submitPost"><span>提交回答</span></a>
							</div>
							<div class="clear"></div>
						</div>
					</div>
				</html:form>
			</kmss:auth>
		</c:if>
		<c:if test="${isReplyer==true}">
			<html:form action="/kms/ask/kms_ask_addition/kmsAskAddition.do?method=save" method="post" >
				<html:hidden property="fdKmsAskPostId" /> 
				<div class="box7_2 m_t10" style="display: none;" id="reply_addition">
					<div class="title5 c"><h2 class="h2_3">补充回答</h2></div>	
					<div class="m_t10">
						<kmss:editor property="docContent" height="200" toolbarStartExpanded="false" />  
						<br>
						<div class="btn_o r m_t10">
							<a href="javascript:void(0)" title="补充回答" onclick="checkAddition('reply_addition',true)"><span>补充回答</span></a>
						</div>
						<div class="clear" id="focusDiv"></div>
					</div>
				</div>
			</html:form>
		</c:if>
		<c:if test="${isPoster==true}">
			<html:form action="/kms/ask/kms_ask_addition/kmsAskAddition.do?method=save" method="post" >
				<html:hidden property="fdKmsAskTopicId" value="${kmsAskTopicForm.fdId}" /> 
				<div class="box7_2 m_t10"  style="display: none;" id="ask_addition">
					<div class="title5 c"><h2 class="h2_3">补充提问</h2></div>	
					<div class="m_t10">
						<kmss:editor property="docContent" height="200" toolbarStartExpanded="false" />  
						<br>
						<div class="btn_o r m_t10">
							<a href="javascript:void(0)" title="提交回答" onclick="checkAddition('ask_addition',false)"><span>补充提问</span></a>
						</div>
						<div class="clear" id="focusDiv"></div>
					</div>
				</div>
			</html:form>
		</c:if>
	</c:if>
