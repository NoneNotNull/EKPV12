<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.DateUtil"%>
<%@ page import="com.landray.kmss.km.imeeting.forms.KmImeetingSummaryForm"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.sys.attachment.model.SysAttMain"%>
<%@page import="com.landray.kmss.sys.attachment.util.SysAttViewerUtil"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
	//移动端发布时间只显示日期，不显示时间
	KmImeetingSummaryForm kmImeetingSummaryForm = (KmImeetingSummaryForm)request.getAttribute("kmImeetingSummaryForm");
	kmImeetingSummaryForm.setDocPublishTime(DateUtil.convertDateToString(DateUtil.convertStringToDate(
			kmImeetingSummaryForm.getDocPublishTime(), DateUtil.PATTERN_DATETIME), DateUtil.PATTERN_DATE));
%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<template:include ref="mobile.view" compatibleMode="true">
	<template:replace name="head">
		<!-- TODO 压缩合并 -->
		<link rel="Stylesheet" href="${LUI_ContextPath}/sys/mobile/css/themes/default/header.css" />
		<link rel="Stylesheet" href="${LUI_ContextPath}/sys/mobile/css/themes/default/listview.css" />
		<link rel="Stylesheet" href="${LUI_ContextPath}/sys/mobile/css/themes/default/nav.css" />
		<link rel="Stylesheet" href="${LUI_ContextPath}/sys/mobile/css/themes/default/person.css" />
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/imeeting/mobile/resource/css/summary_view.css" />
	</template:replace>
	
	
	<template:replace name="title">
		<c:if test="${not empty kmImeetingSummaryForm.fdName}">
			<c:out value="${ kmImeetingSummaryForm.fdName}"></c:out>
		</c:if>
		<c:if test="${empty kmImeetingSummaryForm.fdName}">
			<bean:message bundle="km-imeeting" key="module.km.imeeting"/>
		</c:if>
	</template:replace>
	
	<template:replace name="content">
		<div id="scrollView"  class="gray"
			data-dojo-type="mui/view/DocScrollableView">
			
			<div class="muiSummaryInfoBanner">
				<div class="leftInfo">
					<%--纪要人头像--%>
					<span class="figure">
						<img class="muiSummaryImg" src="<person:headimageUrl personId="${kmImeetingSummaryForm.docCreatorId}" />" alt="" />
					</span>
				</div>
				<div class="rightInfo">
					<span class="title">
						<xform:text property="fdName"></xform:text>
					</span>
					<ul>
						<%--发布时间 --%>
						<c:if test="${not empty kmImeetingSummaryForm.docPublishTime }">
							<li>
								<i class="mui mui-meeting_date"></i>
								<xform:datetime property="docPublishTime" dateTimeType="date"></xform:datetime>
							</li>
						</c:if>
						<%--纪要人 --%>
						<li>
							<i class="mui mui-person"></i>
							<xform:text property="docCreatorName"></xform:text>
						</li>
						<c:if test="${kmImeetingSummaryForm.docStatus >= '30'}">
							<li>
								<i class="mui mui-eyes"></i>
								<c:out value="${kmImeetingSummaryForm.docReadCount}"/>
								<c:if test="${empty kmImeetingSummaryForm.docReadCount }">0</c:if>
							</li>
						</c:if>
					</ul>
				</div>
			</div>
			
			<div data-dojo-type="mui/fixed/Fixed" id="fixed">
				<div data-dojo-type="mui/fixed/FixedItem"  class="ImeetingFixedItem">
					<%--切换页签--%>
					<div class="muiHeader">
						<div
							data-dojo-type="mui/nav/MobileCfgNavBar" 
							data-dojo-props=" defaultUrl:'/km/imeeting/mobile/summary_view_nav.jsp?docStatus=${kmImeetingSummaryForm.docStatus }' ">
						</div>
					</div>
				</div>
			</div>
			
			<%--会议内容页签--%>
			<div id="contentView" data-dojo-type="dojox/mobile/View">
				<div class="muiAccordionPanelContent muiSummaryPanelContent">
					<div class="muiFormContent">
						<table class="muiSimple" cellpadding="0" cellspacing="0">
							<%--会议模板--%>
							<tr>
								<td class="muiTitle">
									<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdTemplate" />
								</td>
								<td>
									<xform:text property="fdTemplateName" mobile="true"/>
								</td>
							</tr>
							<%--会议主持人 --%>
							<tr>
								<td class="muiTitle">
									<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdHost" />
								</td>
								<td>
									<c:if test="${not empty kmImeetingSummaryForm.fdHostId }">
										<xform:address propertyName="fdHostName" propertyId="fdHostId" mobile="true"></xform:address>
									</c:if>
									<c:if test="${not empty kmImeetingSummaryForm.fdOtherHostPerson }">
										&nbsp;<xform:text property="fdOtherHostPerson"></xform:text>
									</c:if>
								</td>
							</tr>
							<%--会议地点--%>
							<tr>
								<td class="muiTitle">
									<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdPlace" />
								</td>
								<td>
									<xform:text property="fdPlaceName"></xform:text>
									<xform:text property="fdOtherPlace"></xform:text>
								</td>
							</tr>
							<%--会议时间--%>
							<tr>
								<td class="muiTitle">
									<bean:message bundle="km-imeeting" key="kmImeetingMain.fdDate" />
								</td>
								<td>
									<c:out value="${kmImeetingSummaryForm.fdHoldDate }"></c:out> ~
									<c:out value="${kmImeetingSummaryForm.fdFinishDate }"></c:out>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
	
			<%--会议人员页签--%>
			<div id="personView" data-dojo-type="dojox/mobile/View">
				<div data-dojo-type="mui/panel/AccordionPanel" data-dojo-props="fixed:false">
					<%--参加人员 --%>
					<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'${lfn:message('km-imeeting:kmImeetingSummary.fdPlanAttendPersons') }',icon:''">
						<div class="txtContent">
							<ul class="muiMeetingList">
								<c:if test="${not empty kmImeetingSummaryForm.fdPlanAttendPersonIds }">
									<li>
										<div data-dojo-type="mui/person/PersonList"
											data-dojo-props="title:'内部',detailTitle:'参加人员',personId:'${kmImeetingSummaryForm.fdPlanAttendPersonIds }'">
										</div>
									</li>
								</c:if>
								<c:if test="${not empty kmImeetingSummaryForm.fdPlanOtherAttendPerson }">
									<li>
										<strong>
											<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherPerson"/>
										</strong>
										<div class="staffList">
											<c:out value="${kmImeetingSummaryForm.fdPlanOtherAttendPerson }"></c:out>
										</div>
									</li>
								</c:if>
							</ul>
						</div>
					</div>
					
					<%--列席人员 --%>
					<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'${lfn:message('km-imeeting:kmImeetingSummary.fdPlanParticipantPersons') }',icon:''">
						<div class="txtContent">
							<ul class="muiMeetingList">
								<c:if test="${not empty kmImeetingSummaryForm.fdPlanParticipantPersonIds }">
									<li>
										<div data-dojo-type="mui/person/PersonList"
											data-dojo-props="title:'内部',detailTitle:'列席人员',personId:'${kmImeetingSummaryForm.fdPlanParticipantPersonIds }'">
										</div>
									</li>
								</c:if>
								<c:if test="${not empty kmImeetingSummaryForm.fdPlanOtherParticipantPersons }">
									<li>
										<strong>
											<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherPerson"/>
										</strong>
										<div class="staffList">
											<c:out value="${kmImeetingSummaryForm.fdPlanOtherParticipantPersons }"></c:out>
										</div>
									</li>
								</c:if>
							</ul>
						</div>
					</div>
					
					<%--实际参加人员 --%>
					<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'${lfn:message('km-imeeting:kmImeetingSummary.fdActualAttendPersons') }',icon:''">
						<div class="txtContent">
							<ul class="muiMeetingList">
								<c:if test="${not empty kmImeetingSummaryForm.fdActualAttendPersonIds }">
									<li>
										<div data-dojo-type="mui/person/PersonList"
											data-dojo-props="title:'内部',detailTitle:'实际与会人员',personId:'${kmImeetingSummaryForm.fdActualAttendPersonIds }'">
										</div>
									</li>
								</c:if>
								<c:if test="${not empty kmImeetingSummaryForm.fdActualOtherAttendPersons }">
									<li>
										<strong>
											<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherPerson"/>
										</strong>
										<div class="staffList">
											<c:out value="${kmImeetingSummaryForm.fdActualOtherAttendPersons }"></c:out>
										</div>
									</li>
								</c:if>
							</ul>
						</div>
					</div>
					
					<%--抄送人员 --%>
					<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'${lfn:message('km-imeeting:kmImeetingSummary.fdCopyToPersons') }',icon:''">
						<div class="txtContent">
							<ul class="muiMeetingList">
								<c:if test="${not empty kmImeetingSummaryForm.fdCopyToPersonIds }">
									<li>
										<div data-dojo-type="mui/person/PersonList"
											data-dojo-props="title:'内部',detailTitle:'抄送',personId:'${kmImeetingSummaryForm.fdCopyToPersonIds }'">
										</div>
									</li>
								</c:if>
							</ul>
						</div>
					</div>
					
				</div>
			
			</div>
			
			
			<%--会议决议 --%>	
			<div id="processView" data-dojo-type="dojox/mobile/View">
				<div data-dojo-type="mui/panel/AccordionPanel"
					data-dojo-props="fixed:false">
					<div data-dojo-type="mui/panel/Content" class="proceePanelContent" data-dojo-props="title:'会议决议',icon:''">
						<c:if test="${kmImeetingSummaryForm.fdContentType=='rtf'}">
							<div id="_____rtf_____docContent" class="muiFieldRtf">
								${kmImeetingSummaryForm.docContent}
							</div>
						</c:if>
						<c:if test="${kmImeetingSummaryForm.fdContentType=='word'}">
						
							<c:set var="___attForms" value="${kmImeetingSummaryForm.attachmentForms['editonline']}" />
							<c:if test="${___attForms!=null && fn:length(___attForms.attachments)>0}">
						 		<c:forEach var="sysAttMain" items="${___attForms.attachments}" varStatus="vsStatus">
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
						 	
						 	<div class="muiReadButton" onclick="window.readWord();">
	        					阅读全文
	        				</div>
						</c:if>
						
						<%--附件--%>
						<c:import url="/sys/attachment/mobile/import/view.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmImeetingSummaryForm" />
							<c:param name="fdKey" value="attachment" />
							<c:param name="fdModelId" value="${param.fdId }" />
							<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingSummary" />
						</c:import> 
						
						<%--查阅会议纪要--%>
						<c:if test="${not empty kmImeetingSummaryForm.fdMeetingId}">
						<kmss:auth
							requestURL="/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=view&fdId=${kmImeetingSummaryForm.fdMeetingId}"
							requestMethod="GET">
							<div class="muiReadButton" onclick="window.open('${LUI_ContextPath}/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=view&fdId=${kmImeetingSummaryForm.fdMeetingId}','_self')">
	        					查看会议通知
	        				</div>
						</kmss:auth>
						</c:if>
						
					</div>
					
					<c:if test="${kmImeetingSummaryForm.docStatus < '30'}">
						<div data-dojo-type="mui/panel/Content" class="muiImeetingPanelContent" data-dojo-props="title:'流程记录',icon:''">
							<c:import url="/sys/lbpmservice/mobile/lbpm_audit_note/import/view.jsp" charEncoding="UTF-8">
								<c:param name="fdModelId" value="${kmImeetingSummaryForm.fdId }"/>
								<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingSummary"/>
								<c:param name="formBeanName" value="kmImeetingSummaryForm"/>
							</c:import>
						</div>
					</c:if>
				</div>
			</div>
			
			
			<%--底部按钮 --%>
			<c:if test="${kmImeetingSummaryForm.docStatus >= '30'}">
				<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom" >
				  <li data-dojo-type="mui/back/BackButton"></li>
				  <c:import url="/sys/bookmark/mobile/import/view.jsp" charEncoding="UTF-8">
					  <c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingSummary"></c:param>
					  <c:param name="fdModelId" value="${kmImeetingSummaryForm.fdId}"></c:param>
					  <c:param name="fdSubject" value="${kmImeetingSummaryForm.fdName}"></c:param>
				  </c:import>
				   <li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:'mui mui-more'">
				    	<div data-dojo-type="mui/back/HomeButton"></div>
				    </li>
				</ul>
			</c:if>
			<c:if test="${kmImeetingSummaryForm.docStatus < '30' }">
				<template:include file="/sys/lbpmservice/mobile/import/bar.jsp" 
					docStatus="${kmImeetingSummaryForm.docStatus}" 
					editUrl="javascript:building();"
					formName="kmImeetingSummaryForm">
					<template:replace name="group">
						<template:super/>
					</template:replace>
				</template:include>
			</c:if>
			
		</div>
			
		<%--流程信息 --%>	
		<c:import url="/sys/lbpmservice/mobile/import/view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmImeetingSummaryForm" />
			<c:param name="fdKey" value="ImeetingSummary" />
			<c:param name="viewName" value="lbpmView" />
			<c:param name="backTo" value="scrollView" />
		</c:import>	
		

	</template:replace>


</template:include>
<script type="text/javascript">
require(['dojo/_base/array','dojo/topic','dojo/query','dijit/registry','dojo/dom-geometry','mui/rtf/RtfResize'],
		function(array,topic,query,registry,domGeometry,RtfResize){
	
	//切换标签重新计算高度
	var _position=domGeometry.position(query('#fixed')[0]),
		_scrollTop=0;
	topic.subscribe("/mui/list/_runSlideAnimation",function(srcObj, evt) {
		_scrollTop= Math.abs(evt.to.y);
	});
	topic.subscribe("/mui/navitem/_selected",function(){
		var view=registry.byId("scrollView");
		
		if(_scrollTop > _position.y){
			view.handleToTopTopic(null,{
				y: 0 - (_position.y)
			});
		}
	});
	
	//切换标签时resize rtf中的表格
	var hasResize=false;
	topic.subscribe("/mui/navitem/_selected",function(widget,args){
		var processView=registry.byId("processView");
		if(!hasResize && processView && processView.isVisible() ){
			var arr=query('.muiFieldRtf');
			array.forEach(arr,function(item){
				new RtfResize({
					containerNode:item
				});
			});
			hasResize=true;
		}
	});
	
	//阅读word形式的纪要
	window.readWord=function(){
		var type = "${_sysAttMain.fdContentType}";
		var href = '${KMSS_Parameter_ContextPath}sys/attachment/sys_att_main/sysAttMain.do?method=view&fdId=${_sysAttMain.fdId}&viewer=aspose_mobilehtmlviewer';
		var downLoadUrl = "${KMSS_Parameter_ContextPath}sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${_sysAttMain.fdId}";
		var hasViewer = "${hasViewer }";
		if(hasViewer !='true' && type !='img'){
			href = downLoadUrl;
		}
		window.location.href=href;
	};
	
	
});

</script>


