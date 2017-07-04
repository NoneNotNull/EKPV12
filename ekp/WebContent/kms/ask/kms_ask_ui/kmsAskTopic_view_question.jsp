<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div class="lui_ask_view_question">
<div ><c:if
	test="${kmsAskTopicForm.fdStatus==1||kmsAskTopicForm.fdStatus==2}">
	<h2 class="lui_ask_h2_6_y">
</c:if> <c:if test="${kmsAskTopicForm.fdStatus==0}">
	<h2 class="lui_ask_h2_6_n">
</c:if> <xform:text property="docSubject" />
</h2>
<c:if test="${isLimit==false }">
	<span style="color: red;">${ lfn:message('kms-ask:kmsAskTopic.fdLimitAnswer')}</span>
</c:if></div>
<dl>
	<dd>${ lfn:message('kms-ask:kmsAskTopic.fdQuPoster')}
		<span class="lui_ask_word_yell">
			<ui:person personId="${kmsAskTopicForm.fdPosterId}" personName="${kmsAskTopicForm.fdPosterName}">
			</ui:person>
		</span>
		 <span id="span_fdMoney"
		class="lui_ask_m_lr20"> <img
		src="${KMSS_Parameter_StylePath}answer/ic_money.gif" align="absMiddle"
		title="<bean:message bundle="kms-ask" key="kmsAskTopic.fdScore"/>">
		<span class="lui_ask_word_score"><xform:text
		property="fdScore" /></span> <span class="lui_ask_inter">${ lfn:message('kms-ask:kmsAskTopic.fdScorez')}</span> </span>| 
		
		<!-- 求助专家、领域 指定人员 -->
		<c:if test="${not empty fdPosterTypeListNames }">
			<c:if test="${kmsAskTopicForm.fdPosterType==1}">
				<span class="lui_ask_left">${ lfn:message('kms-ask:kmsAskTopic.fdQuExpert')}</span>
			</c:if>
			<c:if test="${kmsAskTopicForm.fdPosterType==2}">
				<span class="lui_ask_left">${ lfn:message('kms-ask:kmsAskTopic.fdQuArea')}</span>
			</c:if>
			<c:if test="${kmsAskTopicForm.fdPosterType==3}">
				<span class="lui_ask_left">${ lfn:message('kms-ask:kmsAskTopic.fdQuPerson')}</span>
			</c:if>
				<span class="lui_ask_word_yell"><xform:text property="fdPosterTypeListNames" value="${fdPosterTypeListNames }" /></span>|
		</c:if> 
		<!-- 阅读次数 -->
		<span class="lui_ask_left">${ lfn:message('kms-ask:kmsAskTopic.fdReadNum')}</span>
		<span class="com_number"><xform:text property="docReadCount" /></span>
		<span class="lui_ask_date">
			<xform:datetime  property="fdPostTime" /> 
		</span> 
	</dd>
	<dd class="lui_ask_content">${ kmsAskTopicForm.docContent}</dd>
	
	<div class="lui_ask_view_dot">
	<%-- 补充提问--%>
	<div id="additionAsk_div"></div>
	<c:if test="${not empty kmsAskTopicForm.attachmentForms}">
		<dd><%--附件--%> <span style="float: left;">${ lfn:message('kms-ask:kmsAskTopic.fdAtta')}</span> <c:import
			url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
			charEncoding="UTF-8">
			<c:param name="fdKey" value="topic" />
			<c:param name="fdAttType" value="byte" />
			<c:param name="formBeanName" value="kmsAskTopicForm" />
			<c:param name="fdModelId" value="${param.fdId}" />
			<c:param name="fdModelName"
				value="com.landray.kmss.kms.ask.model.KmsAskTopic" />
		</c:import></dd>
	</c:if>
	
	</div>
	<span id="spanId"> 
	<%-- 补充提问--%> 
	<c:if
		test="${kmsAskTopicForm.fdStatus==0&&isPoster==true}">
		<kmss:auth
			requestURL="/kms/ask/kms_ask_addition/kmsAskAddition.do?method=add&fdId=${param.fdId}"
			requestMethod="GET">
			<a href="javascript:void(0);" class="lui_ask_add" title="${ lfn:message('kms-ask:kmsAskTopic.addAsk')}"
				id="askAddition">${ lfn:message('kms-ask:kmsAskTopic.addAsk')}</a>
		</kmss:auth>
	</c:if> 
	<%-- 向专家求助--%> 
	 <c:if
		test="${kmsAskTopicForm.fdStatus==0&&isPoster==true&&hasExpert==true}">
		<kmss:auth
			requestURL="/kms/ask/kms_ask_addition/kmsAskAddition.do?method=updateExpertTypeHelp&fdId=${param.fdId}"
			requestMethod="GET">
			<input type="hidden" value="${kmsAskTopicForm.fdPosterType }"
				name="fdPosterType" />
			<input type="hidden" value="${kmsAskTopicForm.fdPosterTypeListIds }"
				name="fdPosterTypeListIds" />
			<input type="hidden" value="${fdPosterTypeListNames }"
				name="fdPosterTypeListNames" />
			<c:if
				test="${kmsAskTopicForm.fdPosterType==1}">
				<a href="javascript:void(0);" class="lui_ask_help_expert" title="${ lfn:message('kms-ask:kmsAskTopic.fdAsk.person')}"
					id="help_expert_person">${ lfn:message('kms-ask:kmsAskTopic.fdAsk.person')}</a>
			</c:if>
			<c:if
				test="${kmsAskTopicForm.fdPosterType==2}">
				<a href="javascript:void(0);" class="lui_ask_help_expert" title="${ lfn:message('kms-ask:kmsAskTopic.fdAskHelp.area')}"
					id="help_expert_area">${ lfn:message('kms-ask:kmsAskTopic.fdAskHelp.area')}</a>
			</c:if>
			<!-- 没有求助专家或者求助领域的情况 -->
			<c:if test="${kmsAskTopicForm.fdPosterType==0 }">
				<a href="javascript:void(0);" class="lui_ask_help_expert" title="${ lfn:message('kms-ask:kmsAskTopic.fdAsk.person')}"
					id="help_expert_person">${ lfn:message('kms-ask:kmsAskTopic.fdAskHelp.person')}</a>
				<a href="javascript:void(0);" class="lui_ask_help_expert" title="${ lfn:message('kms-ask:kmsAskTopic.fdAsk.area')}"
					id="help_expert_area">${ lfn:message('kms-ask:kmsAskTopic.fdAskHelp.area')}</a>
			</c:if>
		</kmss:auth>
	</c:if> 
	<%-- 增加悬赏---%>
	<div id="div_addMoney"
		class="lui_ask_view_addMoney"></div>

	<%--增加悬赏 只有本人---%> 
	<c:if test="${kmsAskTopicForm.fdStatus==0}">
		<kmss:auth
			requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=addScore&fdId=${param.fdId}"
			requestMethod="GET">
			<a href="#" id="kmsAsk_showAdd" class="lui_ask_add_money"
				title="<bean:message bundle="kms-ask" key="kmsAskTopic.fdMoney.add"/>">
			<bean:message bundle="kms-ask" key="kmsAskTopic.fdMoney.add" /> </a>
		</kmss:auth>
	</c:if> 
	
	 <!-- 置顶 -->
	 <c:if test="${kmsAskTopicForm.fdSetTopTime==null}">
	 	<kmss:auth 
			 requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=setTop&local=view&fdId=${param.fdId}" requestMethod="GET">
				<a class="lui_ask_settop" href="#" title="${ lfn:message('kms-ask:kmsAskTopic.fdAsk.setTop')}" id="setTop">${ lfn:message('kms-ask:kmsAskTopic.fdAsk.setTop')}</a>
		 </kmss:auth>
	 </c:if>
	 
	 <!-- 取消置顶 -->
	 <c:if test="${kmsAskTopicForm.fdSetTopTime!=null}">
		<c:choose>
			<c:when test="${kmsAskTopicForm.docIsIndexTop == null}">
				<kmss:auth
							requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=cancelTop&local=view&fdId=${param.fdId}"
							requestMethod="GET">
				 	<a class="lui_ask_settop" href="#" title="${ lfn:message('kms-ask:kmsAskTopic.fdCancel.setTop')}" id="setTopCancel">${ lfn:message('kms-ask:kmsAskTopic.fdCancel.setTop')}</a>	 
				</kmss:auth>	
			</c:when>
			<c:otherwise>
				<kmss:auth
							requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=cancelTop&local=index&fdId=${param.fdId}"
							requestMethod="GET">
					<a class="lui_ask_settop" href="#" title="${ lfn:message('kms-ask:kmsAskTopic.fdCancel.setTop')}" id="setTopCancel">${ lfn:message('kms-ask:kmsAskTopic.fdCancel.setTop')}</a>
				</kmss:auth>	
			</c:otherwise>
		</c:choose>
	</c:if>
	
	<%---删除问题--%>
	<kmss:auth
		requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=delete&fdId=${param.fdId}"
		requestMethod="GET">
		<a href="#" class="lui_ask_del_topic" title="${ lfn:message('kms-ask:kmsAskTopic.fdDelTopic')}" id="deleteTopic">${ lfn:message('kms-ask:kmsAskTopic.fdDelTopic')}</a>
	</kmss:auth> 
	<%--推荐--%> 
	<c:if test="${kmsAskTopicForm.fdStatus==1}">
		<kmss:auth
			requestURL="/kms/ask/kms_ask_introduce/kmsAskIntroduce.do?method=add&fdId=${param.fdId}"
			requestMethod="GET">
			<a href="#" class="lui_ask_share" id="objIntroduece" title="${ lfn:message('kms-ask:kmsAskTopic.fdIntro')}">${ lfn:message('kms-ask:kmsAskTopic.fdIntro')}</a>
		</kmss:auth>
	</c:if> 
	<%--收藏 --%> 
	<c:if test="${kmsAskTopicForm.fdStatus==1}">
		<c:import url="/kms/ask/resource/jsp/bookmark_bar_ui.jsp"
			charEncoding="UTF-8">
			<c:param name="fdSubject" value="${kmsAskTopicForm.docSubject}" />
			<c:param name="fdModelId" value="${kmsAskTopicForm.fdId}" />
			<c:param name="fdModelName"
				value="com.landray.kmss.kms.ask.model.KmsAskTopic" />
			<c:param name="fdClass" value="bookmark" />
		</c:import>
		
	</c:if> 
	
	<%--修改分类--%> 
	<kmss:auth
		requestURL="/sys/sc/cateChg.do?method=cateChgEdit&cateModelName=com.landray.kmss.kms.ask.model.KmsAskCategory&categoryId=${kmsAskTopicForm.fdKmsAskCategoryId}&modelName=com.landray.kmss.kms.ask.model.KmsAskTopic"
		requestMethod="GET">
		<a href="#" title="${ lfn:message('kms-ask:kmsAskTopic.fdEditCate')}" class="lui_ask_edit_category" id="editCategory">${ lfn:message('kms-ask:kmsAskTopic.fdEditCate')}</a>
	</kmss:auth> 
	<%-- 结束问题，只有未解决问题才可操作--%> 
	<c:if test="${kmsAskTopicForm.fdStatus==0}">
		<kmss:auth
			requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=close&fdId=${param.fdId}"
			requestMethod="GET">
			<a href="#" class="lui_ask_end_topic" id="endTopic"
				title="<bean:message bundle="kms-ask" key="button.kmForum.close"/>"><bean:message
				bundle="kms-ask" key="button.kmForum.close" /></a>
		</kmss:auth>
	</c:if> 
	<c:if test="${kmsAskTopicForm.fdStatus==1 && docIsPush!=true}">
		<c:set var="kmsCommonPushAction" value="/kms/ask/kms_ask_topic/kmsAskDataPush.do?method=accept"/>
		<c:set var="url" value="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=getPushModels&modelName=com.landray.kmss.kms.ask.model.KmsAskTopic&fdId=${param.fdId}"/>
		<%@ include file="/kms/common/kms_common_push/kms_common_data_push.jsp"%>
	</c:if>
	</span>
</dl>
</div>
