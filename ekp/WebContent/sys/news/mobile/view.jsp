<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.view" compatibleMode="true">
	<template:replace name="title">
		<c:out value="${sysNewsMainForm.docSubject}"></c:out>
	</template:replace>
	<template:replace name="content">
		<div id="scrollView" 
			data-dojo-type="mui/view/DocScrollableView">
			<div class="muiDocFrame">
				<div class="muiDocSubject">
					<bean:write	name="sysNewsMainForm" property="docSubject" />
				</div> 
				<div class="muiDocInfo">
					<span><c:out value="${ sysNewsMainForm.docPublishTime }"/></span>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<span>
						<c:if test="${sysNewsMainForm.fdIsWriter==false}">	
							<bean:message bundle="sys-news" key="sysNewsMain.fdAuthorId" />：<c:out value="${ sysNewsMainForm.fdAuthorName }"/>		
					    </c:if>
					    <c:if test="${sysNewsMainForm.fdIsWriter==true}">	
							<bean:message bundle="sys-news" key="sysNewsMain.fdAuthorId" />：<c:out value="${sysNewsMainForm.fdWriter}"></c:out>
						</c:if>
					 </span>
					 <c:if test="${sysNewsMainForm.docStatus >= '30' }">
					 	&nbsp;&nbsp;&nbsp;&nbsp;
						 <span>
						 	<bean:message bundle="sys-news" key="sysNewsMain.docReadCount" />：<c:out value="${sysNewsMainForm.docReadCount}"/>
						 </span>
					 </c:if>
				</div>
				<c:if test="${sysNewsMainForm.fdDescription!=null && sysNewsMainForm.fdDescription!='' }">
					<div class="muiDocSummary">
						<div class="muiDocSummarySign">
							<bean:message bundle="sys-news" key="sysNewsMain.docDesc" />
						</div>
						<c:out value="${sysNewsMainForm.fdDescription}"/>
					</div>	
				</c:if>
				<div class="muiDocContent" id="contentDiv" style="z-index: -1;">
					<c:choose>
							<c:when test="${not empty sysNewsMainForm.fdIsLink}">
							   <!--发布机制链接-->
								<bean:message bundle="sys-news" key="SysNewsMain.linkNews" />
								<a href='<c:url value="${sysNewsMainForm.fdLinkUrl}"/>' class="muiLink"/>
							        <c:out value="${sysNewsMainForm.docContent}"/>
								</a>
							</c:when>
							<c:otherwise>
								<c:if test="${sysNewsMainForm.fdContentType=='rtf'}">
									<xform:rtf property="docContent" mobile="true"></xform:rtf>
								</c:if>
								<c:if test="${sysNewsMainForm.fdContentType=='word'}">
								<%if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()){
									if (com.landray.kmss.sys.attachment.util.JgWebOffice.isExistFile(request)){%>
									<div data-dojo-type="mui/view/IframeView" 
										data-dojo-props='url:"/sys/attachment/sys_att_main/jg/sysAttMain_html_forward.jsp?fdId=${param.fdId}"'>
									</div>
								<%  }else{%>
										${sysNewsMainForm.fdHtmlContent}
									<% }
								  } else { %>
										${sysNewsMainForm.fdHtmlContent}
								<%} %>
								</c:if>
							</c:otherwise>
					</c:choose>
				</div>	
				<c:import url="/sys/attachment/mobile/import/view.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="sysNewsMainForm"></c:param>
					<c:param name="fdKey" value="fdAttachment"></c:param>
				</c:import> 
			</div>
			<c:if test="${sysNewsMainForm.docStatus < '30' }">
				<div data-dojo-type="mui/panel/AccordionPanel">
					<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'流程记录',icon:'mui-ul'">
						<c:import url="/sys/lbpmservice/mobile/lbpm_audit_note/import/view.jsp" charEncoding="UTF-8">
							<c:param name="fdModelId" value="${sysNewsMainForm.fdId }"/>
							<c:param name="fdModelName" value="com.landray.kmss.sys.news.model.SysNewsMain"/>
							<c:param name="formBeanName" value="sysNewsMainForm"/>
						</c:import>
					</div>
				</div>
			</c:if>
			
			<c:if test="${sysNewsMainForm.docStatus >= '30' }">
				<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom" >
				  <li data-dojo-type="mui/back/BackButton"></li>
				  <c:import url="/sys/evaluation/mobile/import/view.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="sysNewsMainForm"></c:param>
				 </c:import>
				  <c:import url="/sys/bookmark/mobile/import/view.jsp" charEncoding="UTF-8">
					  <c:param name="fdModelName" value="${sysNewsMainForm.modelClass.name}"></c:param>
					  <c:param name="fdModelId" value="${sysNewsMainForm.fdId}"></c:param>
					  <c:param name="fdSubject" value="${sysNewsMainForm.docSubject}"></c:param>
				  </c:import>
				   <li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:'mui mui-more'">
				    	<div data-dojo-type="mui/back/HomeButton"></div>
				    	<c:import url="/sys/relation/mobile/import/view.jsp" charEncoding="UTF-8">
				    		<c:param name="formName" value="sysNewsMainForm"></c:param>
				    	</c:import>
				    </li>
				</ul>
			</c:if>
			<c:if test="${sysNewsMainForm.docStatus < '30' }">
				<template:include file="/sys/lbpmservice/mobile/import/bar.jsp" 
					docStatus="${sysNewsMainForm.docStatus}" 
					editUrl="javascript:building();"
					formName="sysNewsMainForm">
					<template:replace name="group">
						<template:super/>
						<c:import url="/sys/relation/mobile/import/view.jsp" charEncoding="UTF-8">
				    		<c:param name="formName" value="sysNewsMainForm"></c:param>
				    	</c:import>
					</template:replace>
				</template:include>
			</c:if>
		</div>
		
		<c:import url="/sys/lbpmservice/mobile/import/view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="sysNewsMainForm" />
			<c:param name="fdKey" value="newsMainDoc" />
			<c:param name="viewName" value="lbpmView" />
			<c:param name="backTo" value="scrollView" />
		</c:import>
		
	</template:replace>
</template:include>
