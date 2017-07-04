<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.Date"%>
<%@page import="com.landray.kmss.util.DateUtil"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.landray.kmss.km.imeeting.forms.KmImeetingMainForm"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/mobile/mui.tld" prefix="mui"%>
<%
	Date now=new Date();
	Boolean isBegin=false,isEnd=false;
	KmImeetingMainForm kmImeetingMainForm = (KmImeetingMainForm)request.getAttribute("kmImeetingMainForm");
	if(kmImeetingMainForm.getFdHoldDate()!=null && kmImeetingMainForm.getFdFinishDate()!=null){
		// 会议已开始
		if (DateUtil.convertStringToDate(kmImeetingMainForm.getFdHoldDate(),
				ResourceUtil.getString("date.format.datetime")).getTime() < now.getTime()) {
			isBegin = true;
		}
		// 会议已结束
		if (DateUtil.convertStringToDate(kmImeetingMainForm.getFdFinishDate(),
				ResourceUtil.getString("date.format.datetime")).getTime() < now.getTime()) {
			isEnd = true;
		}
	}
	request.setAttribute("isBegin", isBegin);
	request.setAttribute("isEnd", isEnd);
%>
<template:include ref="mobile.view" compatibleMode="true">
	<template:replace name="head">
		<!-- TODO 压缩合并 -->
		<link rel="Stylesheet" href="${LUI_ContextPath}/sys/mobile/css/themes/default/header.css" />
		<link rel="Stylesheet" href="${LUI_ContextPath}/sys/mobile/css/themes/default/listview.css" />
		<link rel="Stylesheet" href="${LUI_ContextPath}/sys/mobile/css/themes/default/nav.css" />
		<link rel="Stylesheet" href="${LUI_ContextPath}/sys/mobile/css/themes/default/person.css" />
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/imeeting/mobile/resource/css/view.css" />
		<mui:min-file name="mui-imeeting.js"/>
	</template:replace>
	<template:replace name="title">
		<c:if test="${not empty kmImeetingMainForm.fdName}">
			<c:out value="${ kmImeetingMainForm.fdName}"></c:out>
		</c:if>
		<c:if test="${empty kmImeetingMainForm.fdName}">
			<bean:message bundle="km-imeeting" key="module.km.imeeting"/>
		</c:if>
	</template:replace>
	<template:replace name="content">
	
		<div id="scrollView"  class="gray"
			data-dojo-type="mui/view/DocScrollableView"
			data-dojo-mixins="mui/list/_ViewPushAppendMixin">
			
			<div class="muiImeetingInfoBanner">
				<dl class="txtInfoBar">
					<dt>
						<%--会议名称--%>
						<xform:text property="fdName"></xform:text>
					</dt>
					<c:if test="${not empty kmImeetingMainForm.fdHoldDate or not empty kmImeetingMainForm.fdFinishDate }">
						<dd>
							<i class="mui mui-meeting_date"></i>
							<%--会议时间--%>
							<xform:datetime property="fdHoldDate" dateTimeType="datetime"></xform:datetime> ~
							<xform:datetime property="fdFinishDate" dateTimeType="datetime"></xform:datetime>
						</dd>
					</c:if>
					<c:if test="${not empty kmImeetingMainForm.fdPlaceName or not empty kmImeetingMainForm.fdOtherPlace }">
						<dd>
							<i class="mui mui-meeting_path"></i>
							<%--地点 --%>
							<xform:text property="fdPlaceName"></xform:text>
							<c:if test="${not empty kmImeetingMainForm.fdOtherPlace}">
								<xform:text property="fdOtherPlace"></xform:text>
							</c:if>	
						</dd>
					</c:if>
				</dl>
				<div class="figureBar">
					<%--主持人头像--%>
					<span class="figure">
						<img src="<person:headimageUrl personId="${kmImeetingMainForm.fdHostId}" />" alt="" />
					</span> 
					<%--主持人--%>
					<span class="name">
						<xform:text property="fdHostName"></xform:text>
					</span>
					<span class="tagBar figureTag" ><i class="mui mui-voice"></i></span>
				</div>
				
				<%--状态 --%>
				<c:import url="/km/imeeting/mobile/import/status.jsp">
					<c:param name="status" value="${kmImeetingMainForm.docStatus }"></c:param>
					<c:param name="isBegin" value="${isBegin }"></c:param>
					<c:param name="isEnd" value="${isEnd }"></c:param>
				</c:import>
				
				<span class="tagBar rightTag" onclick="window.dialPhone('${kmImeetingMainForm.fdHostMobileNo}');">
					<i class="mui mui-tel"></i>
				</span>
			</div>
			
			<c:if test="${type=='admin' or type=='attend' or type=='cc' }">
			
				<div data-dojo-type="mui/fixed/Fixed" id="fixed">
					<div data-dojo-type="mui/fixed/FixedItem" class="ImeetingFixedItem">
						<%--切换页签--%>
						<div class="muiHeader">
							<div
								data-dojo-type="mui/nav/MobileCfgNavBar" 
								data-dojo-props="scrollDir:'',defaultUrl:'/km/imeeting/mobile/view_nav.jsp?docStatus=${kmImeetingMainForm.docStatus }' ">
							</div>
						</div>
					</div>
				</div>
				
				<%--会议内容页签--%>
				<div id="contentView" data-dojo-type="dojox/mobile/View">
					<div data-dojo-type="mui/panel/AccordionPanel" data-dojo-props="fixed:false">
					
						<%--会议目的--%>
						<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'${lfn:message('km-imeeting:kmImeetingMain.fdMeetingAim') }',icon:''">
							<div class="txtContent">
								<div class="muiMeetingAimDiv">
									
									<xform:textarea property="fdMeetingAim"></xform:textarea>
								</div>
							</div>
						</div>
						
						<%--会议议程--%>
						<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'${lfn:message('km-imeeting:kmImeetingMain.kmImeetingAgendas') }',icon:''">
							<div class="txtContent">
		       					<%@include file="/km/imeeting/mobile/agenda_view.jsp"%>
		        				<br/>
		        				<c:import url="/sys/attachment/mobile/import/view.jsp" charEncoding="UTF-8">
									<c:param name="formName" value="kmImeetingMainForm" />
									<c:param name="fdKey" value="attachment" />
								</c:import>
		        				
		        				<%--查阅会议纪要--%>
		        				<c:if test="${kmImeetingMainForm.docStatusFirstDigit=='3'}">
			        				<c:if test="${kmImeetingMainForm.fdSummaryFlag=='true' and not empty summaryId}">
										<kmss:auth
											requestURL="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=view&fdId=${summaryId}"
											requestMethod="GET">
											<div class="muiReadButton" onclick="window.open('${LUI_ContextPath}/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=operateSummary&meetingId=${param.fdId}','_self')">
					        					查阅会议纪要
					        				</div>
										</kmss:auth>
									</c:if>
		        				</c:if>
		        				
		        			</div>
						</div>
						
					</div>
				</div>
				
				<%--会议人员页签--%>
				<div id="personView" data-dojo-type="dojox/mobile/View">
					<div data-dojo-type="mui/panel/AccordionPanel" data-dojo-props="fixed:false">
						<%--参加人员 --%>
						<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'${lfn:message('km-imeeting:kmImeetingMain.fdAttendPersons') }',icon:''">
							<div class="txtContent">
								<ul class="muiMeetingList attendPersonContainer">
									<c:if test="${not empty kmImeetingMainForm.fdAttendPersonIds }">
										<li>
											<div data-dojo-type="mui/person/PersonList"
												data-dojo-props="title:'内部',detailTitle:'参加人员',personId:'${kmImeetingMainForm.fdAttendPersonIds }'">
											</div>
										</li>
									</c:if>
									<c:if test="${not empty kmImeetingMainForm.fdOtherAttendPerson }">
										<li>
											<strong>
												<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherPerson"/>
											</strong>
											<div class="staffList">
												<c:out value="${kmImeetingMainForm.fdOtherAttendPerson }"></c:out>
											</div>
										</li>
									</c:if>
								</ul>
							</div>
						</div>
						<%--列席人员--%>
						<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'${lfn:message('km-imeeting:kmImeetingMain.fdParticipantPersons') }',icon:''">
							<div class="txtContent">
								<ul class="muiMeetingList participantPersonContainer">
									<c:if test="${not empty kmImeetingMainForm.fdParticipantPersonIds }">
										<li>
											<div data-dojo-type="mui/person/PersonList"
												data-dojo-props="title:'内部',detailTitle:'列席人员',personId:'${kmImeetingMainForm.fdParticipantPersonIds }'">
											</div>
										</li>
									</c:if>
									<c:if test="${not empty kmImeetingMainForm.fdOtherParticipantPerson }">
										<li>
											<strong>
												<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherPerson"/>
											</strong>
											<div class="staffList">
												<c:out value="${kmImeetingMainForm.fdOtherParticipantPerson }"></c:out>
											</div>
										</li>
									</c:if>
								</ul>
							</div>
						</div>
						
						<%--抄送人员 --%>
						<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'${lfn:message('km-imeeting:kmImeetingSummary.fdCopyToPersons') }',icon:''">
							<div class="txtContent">
								<ul class="muiMeetingList ccPersonContainer">
									<c:if test="${not empty kmImeetingMainForm.fdCopyToPersonIds }">
										<li>
											<div data-dojo-type="mui/person/PersonList"
												data-dojo-props="title:'内部',detailTitle:'抄送',personId:'${kmImeetingMainForm.fdCopyToPersonIds }'">
											</div>
										</li>
									</c:if>
									<c:if test="${not empty kmImeetingMainForm.fdOtherCopyToPerson }">
										<li>
											<strong>
												<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherPerson"/>
											</strong>
											<div class="staffList">
												<c:out value="${kmImeetingMainForm.fdOtherCopyToPerson }"></c:out>
											</div>
										</li>
									</c:if>
								</ul>
							</div>
						</div>
					</div>
					
				
				</div>
				
				<%--会议回执页签--%>
				<div id="feedbackListView" data-dojo-type="dojox/mobile/View">
					<div class="muiMeetingFeedbackHeader gray">
					
						<%-- 有通知数才做筛选 --%>
						<c:if test="${ fn:length(kmImeetingMainForm.kmImeetingMainFeedbackForms) > 0}">
						
							<div data-dojo-type="km/imeeting/mobile/resource/js/CriteriaButtonGroup"
								 data-dojo-props="icon:'mui mui-filter',label:'筛选',align:'left'">
								 
								<div data-dojo-type="km/imeeting/mobile/resource/js/CriteriaButton"
					    			 data-dojo-props="criteriaType:''">全部</div>
					    			 
					    		<div data-dojo-type="km/imeeting/mobile/resource/js/CriteriaButton"
					    			 data-dojo-props="criteriaType:'04'">未回执</div>
					    			 
					    		<div data-dojo-type="km/imeeting/mobile/resource/js/CriteriaButton"
					    			 data-dojo-props="criteriaType:'01'">参加</div>
					    			 
					    		<div data-dojo-type="km/imeeting/mobile/resource/js/CriteriaButton"
					    			 data-dojo-props="criteriaType:'02'">不参加</div>
					    			 
					    		<div data-dojo-type="km/imeeting/mobile/resource/js/CriteriaButton"
					    			 data-dojo-props="criteriaType:'03'">代理</div>
					    	</div>
					    	
				    	</c:if>
					</div>
					<ul id="muiMeetingFeedbackList" class="muiMeetingFeedbackList" 
			    		data-dojo-type="km/imeeting/mobile/resource/js/list/FeedbackJsonStoreList" 
			    		data-dojo-mixins="km/imeeting/mobile/resource/js/list/FeedbackItemListMixin"
			    		data-dojo-props="url:'/km/imeeting/km_imeeting_main_feedback/kmImeetingMainFeedback.do?method=list&meetingId=${kmImeetingMainForm.fdId }',lazy:false">
					</ul>
				</div>
				
				
				<%--会议流程信息 --%>
				<div id="processView" data-dojo-type="dojox/mobile/View">
					<div class="ProcessAccordionPanel" data-dojo-type="mui/panel/AccordionPanel" data-dojo-props="fixed:false">
						<div class="muiAccordionPanelContent muiImeetingPanelContent">
							<c:import url="/sys/lbpmservice/mobile/lbpm_audit_note/import/view.jsp" charEncoding="UTF-8">
								<c:param name="fdModelId" value="${kmImeetingMainForm.fdId }"/>
								<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingMain"/>
								<c:param name="formBeanName" value="kmImeetingMainForm"/>
							</c:import>
						</div>
					</div>
				</div>
				
			</c:if>
	
			
			<c:if test="${type=='assist' }">
				<div id="contentView" data-dojo-type="dojox/mobile/View">
					<div class="AssistAccordionPanel" data-dojo-type="mui/panel/AccordionPanel" data-dojo-props="fixed:false">
						<%--会议辅助设备--%>
						<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'${lfn:message('km-imeeting:kmImeetingMain.kmImeetingDevices') }',icon:''">
							<div class="txtContent" style="padding: 1rem;">
								<c:out value="${kmImeetingMainForm.kmImeetingDeviceNames}"></c:out>
							</div>
						</div>
						
						<%--会议布置要求--%>
						<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'${lfn:message('km-imeeting:kmImeetingMain.fdArrange') }',icon:''">
							<div class="txtContent" style="padding: 1rem;">
								<xform:textarea property="fdArrange" mobile="true"></xform:textarea>
							</div>
						</div>
						
						<%-- 会议协助人 --%>
						<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'${lfn:message('km-imeeting:kmImeetingMain.fdAssistPersons') }',icon:''">
							<div class="txtContent" style="padding: 1rem;">
								<ul class="muiMeetingList assistPersonContainer">
									<c:if test="${not empty kmImeetingMainForm.fdAssistPersonIds }">
										<li>
											<div data-dojo-type="mui/person/PersonList"
												data-dojo-props="title:'内部',detailTitle:'会议协助人',personId:'${ kmImeetingMainForm.fdAssistPersonIds}'">
											</div>
										</li>
									</c:if>
									<c:if test="${not empty kmImeetingMainForm.fdOtherAssistPersons }">
										<li>
											<strong>
												<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherPerson"/>
											</strong>
											<div class="staffList">
												<c:out value="${kmImeetingMainForm.fdOtherAssistPersons }"></c:out>
											</div>
										</li>
									</c:if>
								</ul>
							</div>
						</div>
						
					</div>
				
				</div>
			
			<script type="text/javascript">
				require(['dojo/topic','dojo/ready','dijit/registry'],function(topic,ready,registry){
					ready(function(){
						topic.publish('/mui/list/pushDomHide',registry.byId('contentView'));
					});
				});
			</script>
			</c:if>
			
			
			<c:if test="${kmImeetingMainForm.docStatus<'30' }">
				<template:include file="/sys/lbpmservice/mobile/import/bar.jsp" 
					docStatus="${kmImeetingMainForm.docStatus}" 
					editUrl="javascript:window.building();"
					formName="kmImeetingMainForm">
					<template:replace name="group">
						<template:super/>
					</template:replace>
				</template:include>
			</c:if>
			
			<c:if test="${kmImeetingMainForm.docStatus>='30' }">
				<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom" data-dojo-props='fill:"grid"'>
				  	<li data-dojo-type="mui/back/BackButton"></li>
				  	
				  	<%--未召开且已发送会议通知单的会议才显示回执按钮--%>
				  	<c:if test="${kmImeetingMainForm.docStatus=='30' and isBegin==false and kmImeetingMainForm.isNotify==true }">
				  		<%--是参会人才显示回执按钮--%>
				  		<c:if test="${not empty optType and optType =='04'}">
				  			<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnSubmit " 
				  				data-dojo-props="colSize:2,href:'/km/imeeting/km_imeeting_main_feedback/kmImeetingMainFeedback.do?method=edit&type=attend&meetingId=${kmImeetingMainForm.fdId }'">参会回执</li>
				  		</c:if>
				  	</c:if>
			    	<li data-dojo-type="mui/tabbar/TabBarButtonGroup" style="float: right;" data-dojo-props="icon1:'mui mui-more'">
			    		<div data-dojo-type="mui/back/HomeButton"></div>
			    	</li>
				</ul>
			</c:if>
		</div>
		
		<%--流程页面 --%>
		<c:import url="/sys/lbpmservice/mobile/import/view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmImeetingMainForm" />
			<c:param name="fdKey" value="ImeetingMain" />
			<c:param name="viewName" value="lbpmView" />
			<c:param name="backTo" value="scrollView" />
		</c:import>
		
		
	</template:replace>
</template:include>
<script>
	require(['dojo/topic',
	         'dojo/ready',
	         'dijit/registry',
	         'dojox/mobile/TransitionEvent',
	         'dojo/request',
	         'dojo/query',
	         'dojo/dom-construct',
	         'dojo/dom-style',
	         'dojo/dom-geometry',
	         'mui/util',
	         'mui/dialog/BarTip',
	         'mui/dialog/Tip'
	         ],function(topic,ready,registry,TransitionEvent,request,query,domConstruct,domStyle,domGeometry,util,BarTip,Tip){
		
		//顶部回执Tip
		<c:if test="${kmImeetingMainForm.docStatus=='30' and isBegin==false and kmImeetingMainForm.isNotify==true }">
			var url="${LUI_ContextPath }/km/imeeting/km_imeeting_main_feedback/kmImeetingMainFeedback.do?method=edit&type=attend&meetingId=${kmImeetingMainForm.fdId }";
			
			<c:if test="${not empty optType && optType=='01' }">
				BarTip.tip({
					text:'您已回执参加此会议！<a class="modifyLink" href="'+url+'">修改回执</a>'
				});
			</c:if>
			<c:if test="${not empty optType && optType=='02' }">
				BarTip.tip({
					text:'您已回执不参加此会议！<a class="modifyLink" href="'+url+'">修改回执</a>'
				});
			</c:if>
			<c:if test="${not empty optType && optType=='03' }">
				BarTip.tip({
					text:'您已回执找人代参加此会议！'
				});
			</c:if>
		</c:if>
		
		<c:if test="${type=='admin' or type=='attend' or type=='cc' }">
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
		</c:if>
		
		//拨打主持人号码
		window.dialPhone=function(mobileNo){
			if(mobileNo){
				window.open('tel:'+mobileNo);
			}else{
				Tip.fail({
					text:'手机号码为空'
				});
			}
		};
		
	});

</script>
