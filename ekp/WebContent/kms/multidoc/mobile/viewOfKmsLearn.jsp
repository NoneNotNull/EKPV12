<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.view" compatibleMode="true">
	<template:replace name="title">
		<c:out value="${ kmsMultidocKnowledgeForm.docSubject }" />
	</template:replace>
	<template:replace name="content">
		<div data-dojo-type="mui/view/DocScrollableView" id="scrollView">
			<div class="muiDocFrame">
				<div class="muiDocSubject">
					<c:out value="${ kmsMultidocKnowledgeForm.docSubject }" />
				</div>
				<div class="muiDocInfo">
					<c:if test="${not empty publishTime }">
						<span>
							<c:out
								value="${publishTime  }" />
						</span>
						&nbsp;&nbsp;&nbsp;&nbsp; 
					</c:if>
					<span>
						${lfn:message('sys-doc:sysDocBaseInfo.docAuthor') } ： <c:if
							test="${not empty kmsMultidocKnowledgeForm.docAuthorId }">
							<c:out value="${ kmsMultidocKnowledgeForm.docAuthorName }" />
						</c:if> <c:if test="${not empty kmsMultidocKnowledgeForm.docAuthorId }">
							<c:out value="${ kmsMultidocKnowledgeForm.outerAuthor }" />
						</c:if>
					</span> &nbsp;&nbsp;&nbsp;&nbsp;
					<c:if test="${kmsMultidocKnowledgeForm.docStatus >= '30' }">
						<span>
							阅读量：
							<c:out value="${ kmsMultidocKnowledgeForm.docReadCount }" />
						</span>
					</c:if> 
				</div>
				<c:if
					test="${kmsMultidocKnowledgeForm.fdDescription!=null && kmsMultidocKnowledgeForm.fdDescription!='' }">
					<div class="muiDocSummary">
						<div class="muiDocSummarySign">
							摘要
						</div>
						<c:out value="${ kmsMultidocKnowledgeForm.fdDescription }" />
					</div>
				</c:if>
				<span class="muiDocContent"> 
					<xform:rtf property="docContent" mobile="true"></xform:rtf>
				</span>
				<!-- 附件 -->
				<c:import url="/sys/attachment/mobile/import/view.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmsMultidocKnowledgeForm"></c:param>
					<c:param name="fdKey" value="attachment"></c:param>
				</c:import>
			</div>
			<!--<c:if test="${kmsMultidocKnowledgeForm.docStatus < '30' }">
				<div data-dojo-type="mui/panel/AccordionPanel">
					<div data-dojo-type="mui/panel/Content"
						data-dojo-props="title:'流程日志',icon:'mui-ul'">
						<c:import
							url="/sys/lbpmservice/mobile/lbpm_audit_note/import/view.jsp"
							charEncoding="UTF-8">
							<c:param name="fdModelId"
								value="${kmsMultidocKnowledgeForm.fdId }"></c:param>
							<c:param name="fdModelName"
								value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge"></c:param>
							<c:param name="formBeanName" value="kmsMultidocKnowledgeForm"></c:param>
						</c:import>
					</div>
				</div>
			</c:if>-->
			<c:if test="${kmsMultidocKnowledgeForm.docStatus >= '30' }">
				<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom">
					<!-- 返回 -->
					<li data-dojo-type="mui/tabbar/TabBarButton" onclick="gobackHome()" id="goBackHome" class="mblTabBarButton mblTabBarButtonHasIcon unselectable"  style="width: 50%; margin: 0px;">
					<div class="mblTabBarButtonIconArea" style="float: left;">
					<div class="mblTabBarButtonIconParent mblTabBarButtonIconParent1"><i title="" class="mui mui-back"></i></div>
					<div class="mblTabBarButtonIconParent mblTabBarButtonIconParent2"><i title="" class="mui mui-back"></i></div></div>
					<div class="mblTabBarButtonLabel"></div></li>
					
					<li data-dojo-type="mui/tabbar/TabBarButtonGroup"
						data-dojo-props="icon1:'mui mui-more'">
						<div data-dojo-type="mui/back/HomeButton"></div> 
						<c:import
							url="/sys/relation/mobile/import/view.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsMultidocKnowledgeForm"></c:param>
						</c:import>
					</li>
				</ul>
			</c:if>
			
			<!--<c:if test="${kmsMultidocKnowledgeForm.docStatus < '30' }">
				<template:include file="/sys/lbpmservice/mobile/import/bar.jsp" 
					docStatus="${kmsMultidocKnowledgeForm.docStatus}" 
					editUrl="javascript:building();"
					formName="kmsMultidocKnowledgeForm">
					<template:replace name="group">
						<template:super/>
						<c:import url="/sys/relation/mobile/import/view.jsp" charEncoding="UTF-8">
				    		<c:param name="formName" value="kmsMultidocKnowledgeForm"></c:param>
				    	</c:import>
					</template:replace>
				</template:include>
			</c:if>-->
			<div style="width: 100%;margin: 1rem 0rem;text-align:center">
				<c:choose>
				     <c:when test="${fdStatus=='1'}"> 
						<a class="btnCourse" href="javascript:void(0)" onclick="">已学习</a>
				     </c:when>
				     <c:when test="${fdStatus=='0'}">
						  <a class="btnCourse" id="learningButton" href="javascript:void(0)" onclick="changeStatus('${fdCatelogContentId}');">置为已学习</a>
						  <a class="btnCourse" id="learntButton"  href="javascript:void(0)" style="display: none;">已学习</a>
				     </c:when>
				   
				     <c:otherwise></c:otherwise>
			    </c:choose>
			</div>
		</div>
		<style>
		 .btnCourse{ display:inline-block; height:2rem; line-height:2rem; padding:0rem 0.6rem;  border:0.1rem solid #6fc13a; color:#6fc13a; font-size:1.4rem; border-radius:0.25rem;margin: 1rem auto;}
		</style>
		<script>
		 function changeStatus(fdCatelogContentId){
			 
				var url="<c:out value='${LUI_ContextPath}/kms/learn/kms_learn_main/kmsLearnMain.do?method=buildClassEnd'/>";
					url=url+"&fdCatelogContentId="+fdCatelogContentId;
		    	require(["dojo/request"],function(request){
		    		request.post(url).then(function(result){
		    			document.getElementById("learningButton").style.display="none";
							document.getElementById("learntButton").style.display="";
			    		});

			    	});
			    }
       function gobackHome(){
    	   require(["dojo/request"], function(request){
  			 var fdCatelogContentId="${fdCatelogContentId}";
  			 var url="<c:out value='${LUI_ContextPath}/kms/learn/kms_learn_main/kmsLearnMain.do?method=buildClassMainId'/>";
  				url=url+"&fdCatelogContentId="+fdCatelogContentId;
  				request.post(url).then(function(data){
  					var curUrl = "<c:url value='/kms/learn/kms_learn_main/kmsLearnMain.do'/>?method=view&fdId="+data.replace(/\s+/g,"");
  					window.location.href=curUrl;
  		    		});
  				
  			 });
           }
		
		</script>
		<!--<c:import url="/sys/lbpmservice/mobile/import/view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmsMultidocKnowledgeForm" />
			<c:param name="fdKey" value="mainDoc" />
			<c:param name="viewName" value="lbpmView" />
			<c:param name="backTo" value="scrollView" />
		</c:import>-->
	</template:replace>
</template:include>
