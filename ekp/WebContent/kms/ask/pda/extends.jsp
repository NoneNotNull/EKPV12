<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/jsp/tags.jsp" %>
<%@ include file="/kms/common/resource/jsp/include_kms.jsp"%>
<%@ include file="extends_js.jsp"%>
<%@ include file="extends_tmpl.jsp"%>

<!-- 爱问问题 -->
<div class="box4 m_t5" style="text-align: left;">
	<div class="title5 c m_t10">
		<c:if test="${kmsAskTopicForm.fdStatus==1||kmsAskTopicForm.fdStatus==2}"><h2 class="h2_6_y"></c:if>
		<c:if test="${kmsAskTopicForm.fdStatus==0}"><h2 class="h2_6_n"></c:if>
		<xform:text property="docSubject"/>
		</h2>
	</div>
	<!-- 
	 <a href="javascript:void(0)" onclick="window.open('${kmsContextPath}/third/pda/pda_ftsearch/pdaFtsearch.do?method=custom','_blank')">test</a>
	<a href="javascript:void(0)" onclick="window.open('${kmsContextPath}kms/ask/kms_ask_topic/kmsAskTopic.do?method=add&isAppflag=1','_blank')">test</a> -->	
	<dl class="dl_e m_t5">
		<dd class="doc_content">
			${ kmsAskTopicForm.docContent}
		</dd>
		
		<c:import url="/kms/ask/pda/extends_att_view.jsp" charEncoding="UTF-8">
			<c:param name="fdKey" value="topic" />
			<c:param name="formBeanName" value="kmsAskTopicForm"/>
		</c:import>
		
		<dd>			
			<span class="date" >
				<xform:datetime property="fdPostTime"  />
			</span>
		
			<span id="span_fdMoney"  class="m_lr20 score">
				 <img src="${KMSS_Parameter_StylePath}answer/ic_money.gif" align="absMiddle" title="<bean:message bundle="kms-ask" key="kmsAskTopic.fdScore"/>">
				 <strong class="o">
					<span id="span_fdScore" ><xform:text property="fdScore" /></span> 
					<span style="font-size: 12px">[知识币]</span>
				 </strong> 
			</span>
		</dd>
	</dl>
	
	<div class="per_info">
		<span>提问者 : <c:out value="${kmsAskTopicForm.fdPosterName}" /></span>
		
		<span class="grade">等级 : ${totalGrade }</span>
	</div>
</div>

<!--  最佳答案 -->
<c:if test="${kmsAskTopicForm.fdStatus==1}">
	<kms:portlet id="bestPostsListDiv" beanParm="{s_method:\"getViewBestPost\",fdTopicId : \"${param.fdId}\"}" title="最佳答案" template="best_post_tmpl" dataBean="kmsAskViewInfoService" dataType="Bean" cssClass="box5"></kms:portlet>
</c:if>

<!-- 回答问题 -->
<c:if test="${kmsAskTopicForm.fdStatus==0}">
	<c:if test="${isReplyer==false&&isPoster==false}">
		<kmss:auth requestURL="/kms/ask/kms_ask_post/kmsAskPost.do?method=add&fdTopicId=${param.fdId}" requestMethod="GET">
			<html:form action="/kms/ask/kms_ask_post/kmsAskPost.do?method=save&fdTopicId=${param.fdId }" method="post" >
				<div class="box7_2" id="ask_reply">
					<div>
						<input type="text" placeholder="回答是种美德" name="docContent" class="input_box">
						<br>
						<input type="button" id="submitPost" value="提交问题">
					</div>
				</div>
			</html:form>
		</kmss:auth>
	</c:if>
</c:if>

<!-- 其他回答 -->
<div id="portlet_otherPostsListDiv"></div>

<!-- 更多 
<div class="more" id="more" style="display:block;">
	<span>更多</span>
</div>-->

<div class="loading" id="loading" style="display:none;">
	<span>正在加载 ~请稍后...</span>
</div>