<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="box4 m_t10">
<div class="title5 c">
	<c:if test="${kmsAskTopicForm.fdStatus==1||kmsAskTopicForm.fdStatus==2}"><h2 class="h2_6_y"></c:if>
	<c:if test="${kmsAskTopicForm.fdStatus==0}"><h2 class="h2_6_n"></c:if>
	<xform:text property="docSubject"/>
	</h2>
	<c:if test="${isLimit==false }"><span style="color: red;">该问题需要指定权限才能回答</span></c:if>
</div>	
	<dl >
		<dd>			
			<span class="date">
				提问时间:<xform:datetime property="fdPostTime" />
			</span>
		
			提问者：<a href="#" onclick="showUserInfo('${kmsAskTopicForm.fdPosterId}');return false;"><c:out value="${kmsAskTopicForm.fdPosterName}" />|</a>
		
			<span id="span_fdMoney"  class="m_lr20">
				 <img src="${KMSS_Parameter_StylePath}answer/ic_money.gif" align="absMiddle" title="<bean:message bundle="kms-ask" key="kmsAskTopic.fdScore"/>">
				 <strong class="o">
					<span id="span_fdScore" ><xform:text property="fdScore" /></span> 
					<span style="font-size: 12px">[知识币]</span>
				 </strong> 
			</span>|
			<c:if test = "${not empty fdPosterTypeListNames }">
				求助专家：<span class="ar" id="expertHelp"><xform:text property="fdPosterTypeListNames" value="${fdPosterTypeListNames }"/></span>|
			</c:if>
			
				阅读次数：<span class="ar"><xform:text property="docReadCount" /></span>
			
		</dd>
		<dd>
			${ kmsAskTopicForm.docContent}
		</dd>
		
		<%-- 补充提问--%>
		<div id = "additionAsk_div"></div>
		<c:if test="${not empty kmsAskTopicForm.attachmentForms}"> 
		<dd>
			<%--附件--%>
			<span style="float: left;">附件：</span>
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_link_view.jsp" charEncoding="UTF-8"> 
				<c:param name="fdKey" value="topic"/>
				<c:param name="fdAttType" value="byte"/>
				<c:param name="formBeanName" value="kmsAskTopicForm" />
				<c:param name="fdModelId" value="${param.fdId}"/>
				<c:param name="fdModelName" value="com.landray.kmss.kms.ask.model.KmsAskTopic"/>	
			</c:import>
   		</dd>
   		</c:if>
   		<br>
   		
   		<span id="spanId">
		
			<%-- 补充提问--%>
			<c:if test="${kmsAskTopicForm.fdStatus==0&&isPoster==true}">
				<kmss:auth requestURL="/kms/ask/kms_ask_addition/kmsAskAddition.do?method=add&fdId=${param.fdId}" requestMethod="GET">
					<a href="javascript:void(0);" class="ask_add" title="补充提问" id="askAddition">补充提问</a>
				</kmss:auth>
			</c:if>
			
			<%-- 向专家求助--%>
			<%-- 
			<kmss:authShow roles="SYSROLE_ADMIN">
			--%>
			<c:if test="${kmsAskTopicForm.fdStatus==0&&isPoster==true&&hasExpert==true}">
				<kmss:auth requestURL="/kms/ask/kms_ask_addition/kmsAskAddition.do?method=updateExpertTypeHelp&fdId=${param.fdId}" requestMethod="GET">
					<input type="hidden" value="${kmsAskTopicForm.fdPosterType }" name="fdPosterType"/>
					<input type="hidden" value="${kmsAskTopicForm.fdPosterTypeListIds }" name="fdPosterTypeListIds"/>
					<input type="hidden" value="${fdPosterTypeListNames }" name="fdPosterTypeListNames"/>
					<c:if test="${ kmsAskTopicForm.fdPosterType==1||kmsAskTopicForm.fdPosterType==2}">
						<a href="javascript:void(0);" class="help_expert" title="向专家求助" id="help_expert">向专家求助</a>
					</c:if>
					<c:if test="${kmsAskTopicForm.fdPosterType==0 }">
						<a href="javascript:void(0);" class="help_expert" title="向专家个人求助" id="help_expert_person">个人求助</a>
						<a href="javascript:void(0);" class="help_expert" title="向专家领域求助" id="help_expert_area">领域求助</a>
					</c:if>
				</kmss:auth>
			</c:if>
			<%-- 
			</kmss:authShow>
			--%>
			<%-- 增加悬赏---%>
			<div id="div_addMoney" style="position:absolute;top:70px; right:80px;z-index: 9999"></div> 
				
			<%--增加悬赏 只有本人---%>
			<c:if test="${kmsAskTopicForm.fdStatus==0}">
				<kmss:auth requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=addScore&fdId=${param.fdId}" requestMethod="GET">
					<a href="#" id="kmsAsk_showAdd" class="add_money" title="<bean:message bundle="kms-ask" key="kmsAskTopic.fdMoney.add"/>">
						<bean:message bundle="kms-ask" key="kmsAskTopic.fdMoney.add"/>
					</a>
				</kmss:auth>
			</c:if>
			
			<%--问题置顶---%>
			<c:if test="${kmsAskTopicForm.fdSetTopTime==null}">
				<kmss:auth requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=askSetTop&fdId=${param.fdId}" requestMethod="GET">
					<a class="settop" href="#" title="问题置顶" id="setTop">问题置顶</a>
				</kmss:auth>
			</c:if>
			
			<%--取消置顶---%>
			<c:if test="${kmsAskTopicForm.fdSetTopTime!=null}">
				<kmss:auth requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=askSetTop&fdId=${param.fdId}" requestMethod="GET">
					<a class="settop" href="#"  title="取消置顶" id="setTopCancel">取消置顶</a>
				</kmss:auth>
			</c:if>
			
			<%---删除问题--%>
			<kmss:auth requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
				<a href="#" class="del_topic" title="删除提问" id="deleteTopic">删除提问</a>
			</kmss:auth>
			
			<%--推荐--%>				
			<c:if test="${kmsAskTopicForm.fdStatus==1}"> 
				<kmss:auth requestURL="/kms/ask/kms_ask_introduce/kmsAskIntroduce.do?method=add&fdId=${param.fdId}" requestMethod="GET">
					<a href="#" class="share" id="objIntroduece" title="推荐">推荐</a>
				</kmss:auth>
			</c:if>
			<%--收藏 --%>
			<c:if test="${kmsAskTopicForm.fdStatus==1}"> 
				<c:import url="/kms/ask/resource/jsp/bookmark_bar.jsp"
					charEncoding="UTF-8">
					<c:param name="fdSubject" value="${kmsAskTopicForm.docSubject}" />
					<c:param name="fdModelId" value="${kmsAskTopicForm.fdId}" />
					<c:param name="fdModelName"
						value="com.landray.kmss.kms.ask.model.KmsAskTopic" />
					<c:param name="fdClass"
						value="bookmark" />
				</c:import>
			</c:if>
			
			<%--修改分类--%>
			<kmss:auth requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=editCategory&fdId=${param.fdId}" requestMethod="GET">
				<a href="#" title="修改分类" class="edit_category" id="editCategory">修改分类</a>
			</kmss:auth>
			
			<%-- 结束问题，只有未解决问题才可操作--%>
			<c:if test="${kmsAskTopicForm.fdStatus==0}">
			<kmss:auth requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=close&fdId=${param.fdId}" requestMethod="GET">
				<a href="#" class="end_topic" id="endTopic" title="<bean:message bundle="kms-ask" key="button.kmForum.close"/>"><bean:message bundle="kms-ask" key="button.kmForum.close"/></a>
			</kmss:auth>
			</c:if>
		</span>
	</dl>
</div>