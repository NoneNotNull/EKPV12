<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/kms/common/pda/template/edit.jsp">
	<template:replace name="title">
		提问
	</template:replace>
	<template:replace name="header">
		<%@ include file="/kms/ask/pda/edit/edit_js.jsp" %>
		<c:import url="/kms/common/pda/template/edit_header.jsp" charEncoding="UTF-8">
		</c:import>
	</template:replace>
	<template:replace name="content">
		<div class="lui-step-panel">
			<div class="global">
				<%
			  		session.setAttribute("S_DocLink","/kms/ask/pda/list/index.jsp");
			  	%>
				  	<html:form action="/kms/ask/kms_ask_topic/kmsAskTopic.do" style="height: 100%" >
				  		<section class="step" data-lui-title="基本信息">
				  			<div class="lui-content-section">
								<div class="lui-ask-category-input">
									<div  onclick="selectCategory();">
										<input type="text" 
											   name="fdKmsAskCategoryName" 
											   class="lui-ask-input" readonly="readonly"
											   placeholder="请选择分类">
										<input type="hidden" name="fdKmsAskCategoryId" value="${param.fdCategoryId }">
										<span class="lui-ask-category-select-icon"></span>
									</div>
								</div>
								<div>
									<%--向专家提问 --%>
									<c:if test="${hasExpert and not empty param.fdPosterTypeListId }">
										<div class="lui-ask-to-expert">
											向专家
											<span>
												<c:out value="${kmsAskTopicForm.fdPosterTypeListNames}" />
											</span>
											提问: <html:hidden property="fdPosterTypeListIds"/>
										</div>
									</c:if>
									<div class="lui-ask-word">
											${lfn:message('kms-ask:kmsAskTopic.moreWord')}
												<a style="font-family: Constantia, Georgia;font-size: 24px;">
													50
										        </a>
										     ${lfn:message('kms-ask:kmsAskTopic.word')}
									</div>
									<div class="lui-step-content" style=" top:75px;"> 
										<textarea name="docSubject" 
												  id="docSubject" 
												  class="docContent lui-ask-content-input" placeholder="请填写内容"
												  style="border:1px solid #b4b4b4;"></textarea>
										
									</div>
									
								</div>
								<input type="hidden" name="method_GET" value="POST">
								<input type="hidden" name="method" value="save">
								<html:hidden property="fdId" />
								<html:hidden property="fdPosterType"/>
							</div>
							<section class="lui-step-btn">
						  		<a class="next">下一步</a>
						  	</section>
						</section>
						
						<section class="step" data-lui-title="悬赏与附件">
				  			<div class="lui-content-section">
			  					<div class="ask_submit">
									<div style="padding-bottom: 1px; ">
										<ul class="money_title">
											<li style="float: left;">
												<span class="icon_value" style="float: left">悬赏：</span>
												<input name="fdScore" type="hidden" value="0">
												<div class="score_box">0</div>
											</li>
											<li style="float: right;">
												<img src="${LUI_ContextPath }/kms/ask/pda/img/tips.gif" border="0" />
												<span style="color: #999999">目前知识货币：<b>${fdScore}</b></span>
											</li>
											<div class="clear"></div>
										</ul>
										<div class="money_content">
											<ul>
												<li class="out" score="0" >
													0分
												</li>
												<li class="out" score="5" >
													5分
												</li>
												<li class="out" score="10" >
													10分
												</li>
												<li class="out" score="20" >
													20分
												</li>
												<li class="out" score="30" >
													30分
												</li>
												<li class="out" score="60" >
													60分 
												</li>
												<li class="out" score="80" >
													80分
												</li>
												<li class="out" score="100" >
													100分
												</li>
												<div class="clear"></div>
											</ul>	
										</div>
									</div>
								</div>
								<div class="lui-ask-attachment">
									<c:import url="/kms/common/pda/core/attachment/attachment_upload.jsp" charEncoding="UTF-8">
										<c:param name="fdModelId" value="${kmsAskTopicForm.fdId}"></c:param>
										<c:param name="fdModelName" value="com.landray.kmss.kms.ask.model.KmsAskTopic"></c:param>
										<c:param name="fdKey" value="topic"></c:param>
										<c:param name="extParam" value="{'thumb':[{'name':'s1','w':'800','h':'800'},{'name':'s2','w':'2250','h':'1695'}]}" />
										<c:param name="toolbar" value="toolbar"></c:param>
									</c:import>
								</div>
				  			</div>
				  			<section class="lui-step-btn">
								<a class="pre">上一步</a>
						  		<a class="submit">提交</a>
						  	</section>
			  			</section>
				</html:form>
			</div>
		</div>
		<!-- 弹出层 -->
		<div id="" class="warn_div"></div>
		<div id="" class="warn2_div"></div>
	</template:replace>
</template:include>



