<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.sys.attachment.model.SysAttMain"%>
<%@page import="com.landray.kmss.sys.attachment.util.SysAttViewerUtil"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>

<template:include ref="mobile.view" compatibleMode="true">
	<template:replace name="head">
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/smissive/mobile/resource/css/smissive.css?v1.2" />
		
	</template:replace>
	<template:replace name="title">
		<c:out value="${kmSmissiveMainForm.docSubject}"></c:out>
	</template:replace>
	<template:replace name="content">
		<div id="scrollView" 
			data-dojo-type="mui/view/DocScrollableView">
			<div class="muiViewBanner">
				<c:set var="attForms" value="${kmSmissiveMainForm.attachmentForms['mainOnline']}" />
			 	<c:if test="${attForms!=null && fn:length(attForms.attachments)>0}">
			 		<c:forEach var="sysAttMain" items="${attForms.attachments}" varStatus="vsStatus">
			 			<c:set var="attMainId" value="${sysAttMain.fdId }"></c:set>
			 			<%
							SysAttMain sysAttMain = (SysAttMain) pageContext
											.getAttribute("sysAttMain");
							String path = SysAttViewerUtil.getViewerPath(
									sysAttMain, request);
							if (StringUtil.isNotNull(path)){
								pageContext.setAttribute("hasThumbnail", "true");
								pageContext.setAttribute("hasViewer", "true");
							}
							pageContext.setAttribute("_sysAttMain", sysAttMain);
						%>
			 		</c:forEach>
			 	</c:if>
			 	
				<div class="leftInfo">
					<c:if test="${hasThumbnail =='true'}">
						<img class="muiSummaryImg" src="${LUI_ContextPath}/sys/attachment/sys_att_main/sysAttMain.do?method=view&filethumb=yes&fdId=${attMainId }" onerror="this.src='${LUI_ContextPath}/km/smissive/mobile/resource/images/thumbnail.png'" alt="" />
					</c:if>
					<c:if test="${hasThumbnail !='true'}">
						<img class="muiSummaryImg" src="${LUI_ContextPath}/km/smissive/mobile/resource/images/thumbnail.png" alt="" />
					</c:if>
					<c:choose>
							<c:when test="${kmSmissiveMainForm.docStatus=='00'}">
								<c:set var="statusBg" value="muiSmissiveDiscard"/>
								<c:set var="statusText" value="${ lfn:message('km-review:status.discard')}"/>
							</c:when>
							<c:when test="${kmSmissiveMainForm.docStatus=='10'}">
								<c:set var="statusBg" value="muiSmissiveDraft"/>
								<c:set var="statusText" value="${ lfn:message('km-review:status.draft')}"/>
							</c:when>
							<c:when test="${kmSmissiveMainForm.docStatus=='11'}">
								<c:set var="statusBg" value="muiSmissiveRefuse"/>
								<c:set var="statusText" value="${ lfn:message('km-review:status.refuse')}"/>
							</c:when>
							<c:when test="${kmSmissiveMainForm.docStatus=='20'}">
								<c:set var="statusBg" value="muiSmissiveExamine"/>
								<c:set var="statusText" value="${ lfn:message('km-review:status.append')}"/>
							</c:when>
							<c:when test="${kmSmissiveMainForm.docStatus=='30'}">
								<c:set var="statusBg" value="muiSmissivePublish"/>
								<c:set var="statusText" value="发布"/>
							</c:when>
						</c:choose>
					<div class="muiSmissiveStatus ${statusBg}">
						${statusText }
					</div>
				</div>
				<div class="rightInfo">
					<span class="title">
						<xform:text property="docSubject"></xform:text>
					</span>
					<ul>
						<li>
							<span>发文单位：<c:out value="${kmSmissiveMainForm.fdMainDeptName}" /></span>
						</li>
						<li>
							<span>文件编号：<c:out value="${kmSmissiveMainForm.fdFileNo}" /></span>
						</li>
					</ul>
				</div>
				
			</div>
			
			
			<div data-dojo-type="mui/panel/AccordionPanel">
				<c:if test="${not empty _sysAttMain.fdId }">
					<div class="muiReadAllItem ">
						<div class="muiAttachments textAlign">
							<span class="muiReadAll" onclick="smissiveViewer()">阅读全文</span>
						</div>
					</div>
				</c:if>
				
				<c:import url="/sys/attachment/mobile/import/view.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmSmissiveMainForm"></c:param>
					<c:param name="fdKey" value="mainAtt"></c:param>
				</c:import> 
			<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'稿纸信息',icon:'mui-ul'">
				<div data-dojo-type="dojox/mobile/ListItem" class="baseInfoNav"
 					data-dojo-props='icon:"mui mui-bookViewDetail",rightIcon:"mui mui-forward",clickable:true,noArrow:true,moveTo:"basicInfoView"'>查看稿纸信息</div>
					
					
			</div>
				<c:if test="${kmSmissiveMainForm.docStatus < '30'}">
					<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'流程记录',icon:'mui-ul'">
						<c:import url="/sys/lbpmservice/mobile/lbpm_audit_note/import/view.jsp" charEncoding="UTF-8">
							<c:param name="fdModelId" value="${kmSmissiveMainForm.fdId }"/>
							<c:param name="fdModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain"/>
							<c:param name="formBeanName" value="kmSmissiveMainForm"/>
						</c:import>
					</div>
				</c:if>
	
			</div>
			<c:if test="${kmSmissiveMainForm.docStatus >= '30'}">
				<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom" >
				  <li data-dojo-type="mui/back/BackButton"></li>
				  <c:import url="/sys/bookmark/mobile/import/view.jsp" charEncoding="UTF-8">
					  <c:param name="fdModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain"></c:param>
					  <c:param name="fdModelId" value="${kmSmissiveMainForm.fdId}"></c:param>
					  <c:param name="fdSubject" value="${kmSmissiveMainForm.docSubject}"></c:param>
				  </c:import>
				   <li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:'mui mui-more'">
				    	<div data-dojo-type="mui/back/HomeButton"></div>
				    	<c:import url="/sys/relation/mobile/import/view.jsp" charEncoding="UTF-8">
				    		<c:param name="formName" value="kmSmissiveMainForm"></c:param>
				    	</c:import>
				    </li>
				</ul>
			</c:if>
			<c:if test="${kmSmissiveMainForm.docStatus < '30' }">
				<template:include file="/sys/lbpmservice/mobile/import/bar.jsp" 
					docStatus="${kmSmissiveMainForm.docStatus}" 
					editUrl="javascript:building();"
					formName="kmSmissiveMainForm">
					<template:replace name="group">
						<template:super/>
						<c:import url="/sys/relation/mobile/import/view.jsp" charEncoding="UTF-8">
				    		<c:param name="formName" value="kmSmissiveMainForm"></c:param>
				    	</c:import>
					</template:replace>
				</template:include>
			</c:if>
		</div>
		<c:import url="/sys/lbpmservice/mobile/import/view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmSmissiveMainForm" />
			<c:param name="fdKey" value="smissiveDoc" />
			<c:param name="viewName" value="lbpmView" />
			<c:param name="backTo" value="scrollView" />
		</c:import>
			<%--查看详细稿纸 --%>
			<div id='basicInfoView' data-dojo-type="dojox/mobile/ScrollableView">
				<div class="basicInfoHeader" data-dojo-type="mui/header/Header" data-dojo-props="height:'3.8rem'">
					<div class="basicInfoHeaderBack" onclick="backToDocView(this)">
						<i class="mui mui-back"></i>
						<span class="personHeaderReturnTxt">返回</span>
					</div>
					<div class="basicInfoHeaderTitle">稿纸信息</div>
					<div></div>
				</div>
				<div class="muiAccordionPanelContent">
					<c:import url="/km/smissive/mobile/basicInfoView.jsp" charEncoding="UTF-8">
					</c:import>
				</div>
				
			</div>
	</template:replace>
</template:include>

<script type="text/javascript" >
require(['dojo/topic',
         'dojo/ready',
         'dijit/registry',
         'dojox/mobile/TransitionEvent',
         'mui/device/adapter'
         ],function(topic,ready,registry,TransitionEvent,adapter){
	
		//返回主视图
		window.backToDocView=function(obj){
			var opts = {
				transition : 'slide',
				transitionDir:-1,
				moveTo:'scrollView'
			};
			new TransitionEvent(obj, opts).dispatch();
			
		};
		//正文阅读
		window.smissiveViewer = function(){
			var type = "${_sysAttMain.fdContentType}";
			var href = '${KMSS_Parameter_ContextPath}sys/attachment/sys_att_main/sysAttMain.do?method=view&fdId=${_sysAttMain.fdId}&viewer=aspose_mobilehtmlviewer';
			var downLoadUrl = "${KMSS_Parameter_ContextPath}sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${_sysAttMain.fdId}";
			var hasViewer = "${hasViewer }";
			if(hasViewer !='true' && type !='img'){
				href = downLoadUrl;
			}
			window.location.href=href;
		}
	});
	
</script>
