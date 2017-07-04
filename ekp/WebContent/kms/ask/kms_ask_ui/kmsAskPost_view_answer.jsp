<%@ page language="java" pageEncoding="UTF-8"%>
	<c:if test="${kmsAskTopicForm.fdStatus==0}">
		<c:if test="${isPoster==true}">
			<html:form action="/kms/ask/kms_ask_addition/kmsAskAddition.do?method=save" method="post" >
				<html:hidden property="fdKmsAskTopicId" value="${kmsAskTopicForm.fdId}" /> 
				<!-- 补充问题 -->
				<div class="lui_ask_bgcolor"  style="display: none;" id="ask_addition">
					<div class="lui_ask_addition_ask"><h2>${lfn:message('kms-ask:kmsAskTopic.addAsk')}</h2></div>	
					<div class="m_t10">
						<kmss:editor property="docContent" height="200" toolbarStartExpanded="false" />  
						<br>
						<div class="lui_ask_add_btn">
							<ui:button  onclick="checkAddition('ask_addition',false);" style="" title="${lfn:message('kms-ask:kmsAskTopic.addAsk')}" >
								<ui:text>${lfn:message('kms-ask:kmsAskTopic.addAsk')}</ui:text>
							</ui:button>
						</div>
						<div class="lui_ask_view_clear" id="focusDiv"></div>
					</div>
				</div>
			</html:form>
		</c:if>
		<!-- 补充回答 -->
		<c:if test="${isReplyer==true}">
			<html:form action="/kms/ask/kms_ask_addition/kmsAskAddition.do?method=save" method="post" >
				<html:hidden property="fdKmsAskPostId" /> 
				<div class="lui_ask_box7_2 m_t10" style="display: none;" id="reply_addition">
					<div class="lui_ask_add_answ c"><h2 class="lui_ask_h2_3">${lfn:message('kms-ask:kmsAskTopic.addAnswer')}</h2></div>	
					<div class="m_t10">
						<kmss:editor property="docContent" height="200" toolbarStartExpanded="false" />  
						<br>
						<div class="lui_ask_btnbox">
							<ui:button onclick="checkAddition('reply_addition',true)" style="" title="${lfn:message('kms-ask:kmsAskTopic.addAnswer')}" >
								<ui:text>${lfn:message('kms-ask:kmsAskTopic.addAnswer')}</ui:text>
							</ui:button>
						</div>
						<div class="lui_ask_view_clear" id="focusDiv"></div>
					</div>
				</div>
			</html:form>
		</c:if>
	</c:if>
	
	<div class="lui_ask_bgcolor">
		<!-- 我的回答 -->
		<c:if test="${kmsAskTopicForm.fdStatus==0}">
			<kmss:auth requestURL="/kms/ask/kms_ask_post/kmsAskPost.do?method=add&fdTopicId=${param.fdId}" requestMethod="GET">
				<html:form action="/kms/ask/kms_ask_post/kmsAskPost.do?method=save&fdTopicId=${param.fdId }" method="post" >
					<c:if test="${isReplyer==false&&isPoster==false}">
						<div  class="lui_ask_botline">
							<h2 >${lfn:message('kms-ask:kmsAskTopic.iAnswer')}</h2>
							<div  class="lui_ask_answer_box">
								<kmss:editor property="docContent" height="200" toolbarStartExpanded="false" />  
								<div class="lui_ask_btnbox">
									<ui:button id="submitPost" onclick="authentication();" style="" title="${lfn:message('kms-ask:kmsAskTopic.submitAnswer')}" >
										<ui:text>${lfn:message('kms-ask:kmsAskTopic.submitAnswer')}</ui:text>
									</ui:button>
								</div>
								<div class="lui_ask_view_clear"></div>
							</div>
						</div>
					</c:if>
				</html:form>
			</kmss:auth>
		</c:if>
		
		<%--最佳答案开始--%> 
		<c:if test="${kmsAskTopicForm.fdStatus==1}">
			<div  class="lui_ask_bestbgcolor" id = "bestPost">
				<center>
					<img src="${KMSS_Parameter_ContextPath}resource/style/common/images/loading.gif" border="0" />
				</center>
			</div>
		</c:if>
		
		<%--其他答案开始---%>
		<div class="lui_ask_tabbox">
		<div style="width:100%" id="otherPostsListDiv">
			<center>
				<img src="${KMSS_Parameter_ContextPath}resource/style/common/images/loading.gif" border="0" />
			</center>
		</div>
		<div class="lui_ask_view_page" id="otherPostsPageDiv">
			<center>
				<img src="${KMSS_Parameter_ContextPath}resource/style/common/images/loading.gif" border="0" />
			</center>
		</div>
		</div>
	</div>
	
	
