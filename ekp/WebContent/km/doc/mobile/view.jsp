<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.DateUtil"%>
<%@ page import="com.landray.kmss.km.doc.forms.KmDocKnowledgeForm"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<%
	//移动端发布时间只显示日期，不显示时间
	KmDocKnowledgeForm kmDocKnowledgeForm = (KmDocKnowledgeForm)request.getAttribute("kmDocKnowledgeForm");
	kmDocKnowledgeForm.setDocPublishTime(DateUtil.convertDateToString(DateUtil.convertStringToDate(
			kmDocKnowledgeForm.getDocPublishTime(), DateUtil.PATTERN_DATETIME), DateUtil.PATTERN_DATE));
%>
<template:include ref="mobile.view" compatibleMode="true">
	<template:replace name="head">
		<link rel="stylesheet" href="${LUI_ContextPath}/km/doc/mobile/resource/css/doc.css?v1.0" />
	</template:replace>
	<template:replace name="title">
		<c:out value="${kmDocKnowledgeForm.docSubject}"></c:out>
	</template:replace>
	<template:replace name="content">
		<div id="scrollView"  data-dojo-type="mui/view/DocScrollableView">
		<div id="_banner" data-dojo-type="mui/view/ViewBanner" data-dojo-props="
			docIsIntroduced:'${kmDocKnowledgeForm.docIsIntroduced}',
			docStatus:'${kmDocKnowledgeForm.docStatus}',
			docPublishTime:'${kmDocKnowledgeForm.docPublishTime}',
			icon:'<person:headimageUrl personId="${kmDocKnowledgeForm.docAuthorId}" />',
			creator:'${kmDocKnowledgeForm.docAuthorName}',
			docReadCount:'${kmDocKnowledgeForm.docReadCount}',
			docSubject:'${kmDocKnowledgeForm.docSubject}'"></div>
			
			<div class="muiDocFrame">
				<%--摘要--%>
				<c:if test="${kmDocKnowledgeForm.fdDescription!=null && kmDocKnowledgeForm.fdDescription!='' }">
					<div class="muiDocSummary">
						<div class="muiDocSummarySign">
							<bean:message bundle="km-doc" key="kmDocKnowledge.fdDescription" />
						</div>
						<c:out value="${kmDocKnowledgeForm.fdDescription}"/>
					</div>	
				</c:if>
				<%--文档内容--%>
				<div class="muiDocContent" id="contentDiv" style="z-index: -1;">
					<xform:rtf property="docContent" mobile="true"></xform:rtf>
				</div>
				<c:import url="/sys/attachment/mobile/import/view.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmDocKnowledgeForm" />
					<c:param name="fdKey" value="attachment" />
				</c:import>
			</div>
			<c:if test="${kmDocKnowledgeForm.docStatus >= '30' }">
				<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom" >
				  <li data-dojo-type="mui/back/BackButton"></li>
				  <%--点评 --%>
				  <c:import url="/sys/evaluation/mobile/import/view.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmDocKnowledgeForm"></c:param>
				 </c:import>
				 <%--推荐 --%>
				 <c:import url="/sys/introduce/mobile/import/view.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmDocKnowledgeForm"></c:param>
				 </c:import>
				  <c:import url="/sys/bookmark/mobile/import/view.jsp" charEncoding="UTF-8">
					  <c:param name="fdModelName" value="com.landray.kmss.km.doc.model.KmDocKnowledge"></c:param>
					  <c:param name="fdModelId" value="${kmDocKnowledgeForm.fdId}"></c:param>
					  <c:param name="fdSubject" value="${kmDocKnowledgeForm.docSubject}"></c:param>
				  </c:import>
				   
				    <li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:'mui mui-more'">
				    	<div data-dojo-type="mui/back/HomeButton"></div>
				    	 
				    	<c:import url="/sys/relation/mobile/import/view.jsp" charEncoding="UTF-8">
				    		<c:param name="formName" value="kmDocKnowledgeForm"></c:param>
				    	</c:import>
				    	
				    </li>
				</ul>
			</c:if>
			<c:if test="${kmDocKnowledgeForm.docStatus < '30' }">
				<div data-dojo-type="mui/panel/AccordionPanel">
					<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'流程记录',icon:'mui-ul'">
						<c:import url="/sys/lbpmservice/mobile/lbpm_audit_note/import/view.jsp" charEncoding="UTF-8">
							<c:param name="fdModelId" value="${kmDocKnowledgeForm.fdId }"/>
							<c:param name="fdModelName" value="com.landray.kmss.km.doc.model.KmDocKnowledge"/>
							<c:param name="formBeanName" value="kmDocKnowledgeForm"/>
						</c:import>
					</div>
				</div>
				<template:include file="/sys/lbpmservice/mobile/import/bar.jsp" 
					docStatus="${kmDocKnowledgeForm.docStatus}" 
					editUrl="javascript:window.building();"
					formName="kmDocKnowledgeForm">
					<template:replace name="group">
						<template:super/>
						<c:import url="/sys/relation/mobile/import/view.jsp" charEncoding="UTF-8">
				    		<c:param name="formName" value="kmDocKnowledgeForm"/>
				    	</c:import>
					</template:replace>
				</template:include>
			</c:if>
		</div>
		
		
		<c:import url="/sys/lbpmservice/mobile/import/view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmDocKnowledgeForm" />
			<c:param name="fdKey" value="mainDoc" />
			<c:param name="viewName" value="lbpmView" />
			<c:param name="backTo" value="scrollView" />
		</c:import>
		
	</template:replace>
</template:include>
