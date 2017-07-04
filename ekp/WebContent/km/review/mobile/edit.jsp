<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/mobile/jsp/ajax-accept.jsp" %>
<template:include ref="mobile.edit" compatibleMode="true">
	<template:replace name="title">
		<c:if test="${empty  kmReviewMainForm.docSubject}">
			<c:out value="新建流程" />
		</c:if>
		<c:out value="${kmReviewMainForm.docSubject}"></c:out>
	</template:replace>
	<template:replace name="content">
		<html:form action="/km/review/km_review_main/kmReviewMain.do?method=save">
			<div data-dojo-type="mui/view/DocScrollableView" data-dojo-mixins="mui/form/_ValidateMixin" id="scrollView">
				<div data-dojo-type="mui/panel/AccordionPanel">
					<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'基本信息',icon:'mui-ul'">
						<div class="muiFormContent">
							<html:hidden property="fdId" />
							<html:hidden property="fdModelId" />
							<html:hidden property="fdModelName" />
							<html:hidden property="docStatus" />
							<table class="muiSimple" cellpadding="0" cellspacing="0">
								<tr>
									<td class="muiTitle">
										<bean:message bundle="km-review" key="kmReviewMain.docSubject" />
									</td><td>
										<c:if test="${kmReviewMainForm.titleRegulation==null || kmReviewMainForm.titleRegulation=='' }">
											<xform:text property="docSubject" mobile="true"/>
										</c:if>
										<c:if test="${kmReviewMainForm.titleRegulation!=null && kmReviewMainForm.titleRegulation!='' }">
											<xform:text property="docSubject" mobile="true" showStatus="readOnly" value="${lfn:message('km-review:kmReviewMain.docSubject.info') }" />
										</c:if>
									</td>
								</tr><tr>
									<td class="muiTitle">
										<bean:message bundle="km-review" key="kmReviewTemplate.fdName" />
									</td><td>
										<html:hidden property="fdTemplateId" /> 
										<xform:text property="fdTemplateName" mobile="true" showStatus="view"/>
									</td>
								</tr>
								<tr>
									<td class="muiTitle">
										<bean:message bundle="km-review" key="kmReviewMain.docCreatorName" />
									</td><td>
										<xform:text property="docCreatorName" mobile="true" showStatus="view"/>
									</td>
								</tr>
							</table>
							<c:import url="/sys/right/right_edit4pda.jsp" charEncoding="UTF-8">
								<c:param name="formName" value="kmReviewMainForm" />
								<c:param name="moduleModelName" value="com.landray.kmss.km.review.model.KmReviewMain" />
							</c:import>
						</div>
					</div>
					<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'审批内容',icon:'mui-ul'">
							<c:if test="${kmReviewMainForm.fdUseForm == 'false'}">
								<div class="muiFormContent">
								<table class="muiSimple" cellpadding="0" cellspacing="0">
									<tr>
										<td colspan="2">
											<c:set property="docContent" target="${kmReviewMainForm}" value=""/>
											<xform:textarea property="docContent" mobile="true"/>
										</td>
									</tr><tr>
										<td colspan="2">
											<c:import url="/sys/attachment/mobile/import/edit.jsp" charEncoding="UTF-8">
												<c:param name="formName" value="kmReviewMainForm"></c:param>
												<c:param name="fdKey" value="fdAttachment"></c:param>
											</c:import> 
										</td>
									</tr>
								</table>
								</div>
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
									<br/>
								</div>
								</div>
							</c:if>
					</div>
				</div>
				<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom" data-dojo-props='fill:"grid"'>
				  	<li data-dojo-type="mui/back/BackButton" edit="true"></li>
				  	<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnNext " 
				  		data-dojo-props='colSize:2,moveTo:"lbpmView",icon1:"mui mui-nextStep",transition:"slide"'>下一步</li>
				   	<li data-dojo-type="mui/tabbar/TabBarButtonGroup" 
				   		data-dojo-props="icon1:'mui mui-more'">
				    	<div data-dojo-type="mui/back/HomeButton"></div>
				   	</li>
				</ul>
			</div>
			<c:import url="/sys/lbpmservice/mobile/import/edit.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmReviewMainForm" />
				<c:param name="fdKey" value="reviewMainDoc" />
				<c:param name="viewName" value="lbpmView" />
				<c:param name="backTo" value="scrollView" />
				<c:param name="onClickSubmitButton" value="review_submit();" />
			</c:import>
			
			<script>
			require(["mui/form/ajax-form!kmReviewMainForm"]);
			function review_submit(){
				var status = document.getElementsByName("docStatus")[0];
				var method = Com_GetUrlParameter(location.href,'method');
				if(method=='add'){
					Com_Submit(document.forms[0],'save');
				}else{
					if(status.value=='10'||status.value=='11'){
						Com_Submit(document.forms[0],'publishDraft');
					}else{
						Com_Submit(document.forms[0],'update');
					}
				}
			}
			</script>
		</html:form>
	</template:replace>
</template:include>
