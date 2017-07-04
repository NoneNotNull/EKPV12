<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.view" compatibleMode="true">
	<template:replace name="title">
		<c:out value="${kmReviewMainForm.docSubject}"></c:out>
	</template:replace>
	<template:replace name="content">
		<html:form action="/km/review/km_review_main/kmReviewMain.do">		
		<div id="scrollView" 
			data-dojo-type="mui/view/DocScrollableView"
			data-dojo-mixins="mui/form/_ValidateMixin">
			<div data-dojo-type="mui/panel/AccordionPanel">
				<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'基本信息',icon:'mui-ul'">
					<div class="muiFormContent">
						<table class="muiSimple" cellpadding="0" cellspacing="0">
							<tr>
								<td class="muiTitle">
									<bean:message bundle="km-review" key="kmReviewMain.docSubject" />
								</td><td>
									<xform:text property="docSubject" mobile="true"/>
								</td>
							</tr>
							<tr>
								<td class="muiTitle">
									<bean:message bundle="km-review" key="kmReviewTemplate.fdName" />
								</td><td>
									<xform:text property="fdTemplateName" mobile="true"/>
								</td>
							</tr>
							<tr>
								<td class="muiTitle">
									<bean:message bundle="km-review" key="kmReviewMain.docCreatorName" />
								</td><td>
									<xform:text property="docCreatorName" mobile="true"/>
								</td>
							</tr>
						</table>
					</div>
				</div>
				<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'审批内容',icon:'mui-ul'">
					<c:if test="${kmReviewMainForm.fdUseForm == 'false'}">
						<br/>
						<xform:rtf property="docContent" mobile="true"></xform:rtf>
						<br/>
						<c:import url="/sys/attachment/mobile/import/view.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmReviewMainForm"></c:param>
							<c:param name="fdKey" value="fdAttachment"></c:param>
						</c:import> 
						<br/>
					</c:if>
					<c:if test="${kmReviewMainForm.fdUseForm == 'true' || empty kmReviewMainForm.fdUseForm}">
						<div data-dojo-type="mui/table/ScrollableHContainer">
							<div data-dojo-type="mui/table/ScrollableHView" class="muiFormContent">
								<c:import url="/sys/xform/mobile/import/sysForm_mobile.jsp"
									charEncoding="UTF-8">
									<c:param name="formName" value="kmReviewMainForm" />
									<c:param name="fdKey" value="reviewMainDoc" />
									<c:param name="backTo" value="scrollView" />
								</c:import>
							</div>
						</div>
					</c:if>
				</div>
				<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'流程记录',icon:'mui-ul'">
					<c:import url="/sys/lbpmservice/mobile/lbpm_audit_note/import/view.jsp" charEncoding="UTF-8">
						<c:param name="fdModelId" value="${kmReviewMainForm.fdId }"/>
						<c:param name="fdModelName" value="com.landray.kmss.km.review.model.KmReviewMain"/>
						<c:param name="formBeanName" value="kmReviewMainForm"/>
					</c:import>
				</div>
			</div>
			<c:if test="${kmReviewMainForm.docStatus >= '30' }">
				<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom" >
				  <li data-dojo-type="mui/back/BackButton"></li>
				  <c:import url="/sys/bookmark/mobile/import/view.jsp" charEncoding="UTF-8">
					  <c:param name="fdModelName" value="${kmReviewMainForm.modelClass.name}"/>
					  <c:param name="fdModelId" value="${kmReviewMainForm.fdId}"/>
					  <c:param name="fdSubject" value="${kmReviewMainForm.docSubject}"/>
				  </c:import>
				   <li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:'mui mui-more'">
				    	<div data-dojo-type="mui/back/HomeButton"></div>
				    	<c:import url="/sys/relation/mobile/import/view.jsp" charEncoding="UTF-8">
				    		<c:param name="formName" value="kmReviewMainForm"/>
				    	</c:import>
				    </li>
				</ul>
			</c:if>
			<c:if test="${kmReviewMainForm.docStatus < '30' }">
				<template:include file="/sys/lbpmservice/mobile/import/bar.jsp" 
					editUrl="/km/review/km_review_main/kmReviewMain.do?method=edit&fdId=${param.fdId }"
					formName="kmReviewMainForm">
					<template:replace name="group">
						<template:super/>
						<c:import url="/sys/relation/mobile/import/view.jsp" charEncoding="UTF-8">
				    		<c:param name="formName" value="kmReviewMainForm"/>
				    	</c:import>
					</template:replace>
				</template:include>
			</c:if>
		</div>
		<c:import url="/sys/lbpmservice/mobile/import/view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmReviewMainForm" />
			<c:param name="fdKey" value="reviewMainDoc" />
			<c:param name="viewName" value="lbpmView" />
			<c:param name="backTo" value="scrollView" />
			<c:param name="onClickSubmitButton" value="Com_Submit(document.kmReviewMainForm, 'publishDraft');" />
		</c:import>
		<script type="text/javascript">
			require(["mui/form/ajax-form!kmReviewMainForm"]);
		</script>
	</html:form>
	</template:replace>
</template:include>
