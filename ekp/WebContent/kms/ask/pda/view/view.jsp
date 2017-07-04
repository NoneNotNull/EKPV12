<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kms.tld" prefix="kms" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/kms/common/pda/template/view.jsp">
	<template:replace name="title">
		${lfn:message('kms-ask:kmsAsk.tree.title') }
	</template:replace>
	<template:replace name="header">
		<%@ include file="/kms/common/resource/jsp/include_kms.jsp"%>
		<%@ include file="view_js.jsp"%>
		<%@ include file="view_tmpl.jsp"%>
		<header class="lui-header">
			<ul class="clearfloat">
				<li style="float: left;padding-left: 10px;">
					<a id="column_button" data-lui-role="button">
						<script type="text/config">
						{
							currentClass : 'lui-icon-s lui-back-icon',
							onclick : "setTimeout(function(){history.go(-1)},0)"
						}
						</script>		
					</a>
				</li>
				<li class="lui-docSubject">
					<h2 class="textEllipsis">${kmsAskTopicForm.docSubject }</h2>
				</li>
			</ul>
		</header>
	</template:replace>
	<template:replace name="docContent">
		<!-- 爱问问题 -->
		<div class="box4 m_t5" style="text-align: left;">
			<div class="title5 c m_t10">
				<c:if test="${kmsAskTopicForm.fdStatus==1||kmsAskTopicForm.fdStatus==2}"><h2 class="h2_6_y"></c:if>
				<c:if test="${kmsAskTopicForm.fdStatus==0}"><h2 class="h2_6_n"></c:if>
				<xform:text property="docSubject"/>
				</h2>
			</div>
			<dl class="dl_e m_t5">
				<dd class="doc_content">
					${ kmsAskTopicForm.docContent}
				</dd>
				
				<link rel="stylesheet" href="${LUI_ContextPath }/kms/common/pda/core/attachment/style/att.css" />
				<c:import url="/sys/attachment/pda/sysAttMain_view.jsp" charEncoding="UTF-8">
					<c:param name="fdKey" value="topic" />
					<c:param name="formBeanName" value="kmsAskTopicForm"/>
				</c:import>
				
				<dd>			
					<span class="date" >
						<xform:datetime property="fdPostTime"  />
					</span>
				
					<span id="span_fdMoney"  class="m_lr20 score">
						 <img src="${KMSS_Parameter_StylePath}answer/ic_money.gif" 
						      align="absMiddle" 
						      title="<bean:message bundle="kms-ask" key="kmsAskTopic.fdScore"/>">
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
				<div style="margin-top: 2px;" >
					<c:if test="${not empty fdPosterTypeListNames }">
					<c:if test="${kmsAskTopicForm.fdPosterType==1}">
						<span >提问专家 : </span>
					</c:if>
					<c:if test="${kmsAskTopicForm.fdPosterType==2}">
						<span>提问领域 : </span>
					</c:if>
						<span style="color:#F19703;"><xform:text property="fdPosterTypeListNames" value="${fdPosterTypeListNames }" /></span>
					</c:if>
				</div>
			</div>
		</div>
		
		<!--  最佳答案 -->
		<c:if test="${kmsAskTopicForm.fdStatus==1}">
			<kms:portlet id="bestPostsListDiv" 
			             beanParm="{s_method:\"getViewBestPost\",fdTopicId : \"${param.fdId}\"}" 
			             title="最佳答案" 
			             template="best_post_tmpl" 
			             dataBean="kmsAskViewInfoService" 
			             dataType="Bean" cssClass="box5">
			</kms:portlet>
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
								<input type="button" id="submitPost" value="提交">
							</div>
						</div>
					</html:form>
				</kmss:auth>
			</c:if>
		</c:if>
		
		<!-- 其他回答 -->
		<div id="portlet_otherPostsListDiv"></div>
		
		<div class="loading" id="loading" style="display:none;">
			<span>正在加载 ~请稍后...</span>
		</div>
	</template:replace>
</template:include>