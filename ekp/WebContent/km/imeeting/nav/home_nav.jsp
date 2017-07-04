<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple" sidebar="no">
	<template:replace name="body">
	<style type="text/css" media="screen">
		@import url("../resource/css/meeting.css");
	</style>
     <div class="meeting_graSection">
      	<h2>${lfn:message('km-meeting:kmMeetingMain.nav.meetingWorkProcess')}</h2>
        	<div class="meeting_proWrapper">
             	<!-- 中间图标 Begin -->
                <div class="meeting_pro_c_iconBox">
                    <div class="m_pro_c_icon"></div>
                </div>
                 <!-- 中间图标 End -->
                 <div class="meeting_pro_contentBox_1 clrfix">
                           <!-- 区块 Begin -->
                           <div class="meeting_proC_left">
                               <div class="m_pro_header">
                                   <i class="m_pro_head_num_1"></i>
                                   <p class="m_pro_head_bg_1">${lfn:message('km-meeting:kmMeetingMain.nav.meetingSystemManager')}</p>
                               </div>
                               <ul class="m_pro_ul_1 clrfix">
                                   <li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingTemplate_nav.jsp','${lfn:message('km-meeting:kmMeetingMain.nav.meetingCard')}')"
                                          title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingCard')}" target="_self">${lfn:message('km-meeting:kmMeetingMain.nav.meetingCard')}</a></li>
                                   <li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingMain_nav.jsp','${lfn:message('km-meeting:kmMeetingMain.nav.meetingColock')}')"
                                          title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingColock')}" target="_self">${lfn:message('km-meeting:kmMeetingMain.nav.meetingColock')}</a></li>
                                   <li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingMain_nav.jsp','${lfn:message('km-meeting:kmMeetingMain.nav.meetingSta')}')"
                                          target="_self" title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingStaSearch')}">${lfn:message('km-meeting:kmMeetingMain.nav.meetingStaSearch')}</a></li>
                                   <li><a href="javascript:iframeUrl('/sys/category/sys_category_main/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.km.meeting.model.KmMeetingTemplate&mainModelName=com.landray.kmss.km.meeting.model.KmMeetingMain&categoryName=docCategory&templateName=fdMeetingTemplate&authReaderNoteFlag=2','${lfn:message('km-meeting:kmMeetingMain.nav.category')}')"
                                          target="_self" title="${lfn:message('km-meeting:kmMeetingMain.nav.categoryManager')}">${lfn:message('km-meeting:kmMeetingMain.nav.categoryManager')}</a></li>
                                   <li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingRes_nav.jsp','${lfn:message('km-meeting:kmMeetingMain.nav.meetingRes')}')" 
                                          title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingResManager')}" target="_self">${lfn:message('km-meeting:kmMeetingMain.nav.meetingRes')}</a></li>
                               </ul>
                           </div>
                           <!-- 区块 Begin -->
                           <!-- 区块 Begin -->
                           <div class="meeting_proC_right">
                               <div class="m_pro_header">
                                   <i class="m_pro_head_num_2"></i>
                                   <p class="m_pro_head_bg_2">${lfn:message('km-meeting:kmMeetingMain.nav.meetingArrangement')}</p>
                               </div>
                               <ul class="m_pro_ul_2 clrfix">
                                   <li><a href="javascript:addDoc();" 
                                          title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingArrangement')}">${lfn:message('km-meeting:kmMeetingMain.nav.meetingArrangement')}</a></li>
                                   <li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingMain_nav.jsp?type=approval','${lfn:message('km-meeting:kmMeetingMain.nav.meetingAppro')}')"
                                          target="_self" title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingAppro')}">${lfn:message('km-meeting:kmMeetingMain.nav.meetingAppro')}</a></li>
                                   <li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingMain_nav.jsp?status=30','${lfn:message('km-meeting:kmMeetingMain.nav.meetingPublish')}')" 
                                          target="_self" title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingPublish')}">${lfn:message('km-meeting:kmMeetingMain.nav.meetingPublish')}</a></li>
                                   <li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingMain_nav.jsp','${lfn:message('km-meeting:kmMeetingMain.nav.meetingData')}')" target="_self"
                                          title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingData')}">${lfn:message('km-meeting:kmMeetingMain.nav.meetingData')}</a></li>
                                   <li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingMain_nav.jsp','${lfn:message('km-meeting:kmMeetingMain.nav.meetingChange')}')" 
                                          target="_self" title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingChange')}">${lfn:message('km-meeting:kmMeetingMain.nav.meetingChange')}</a></li>
                                   <li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingMain_nav.jsp?status=41','${lfn:message('km-meeting:kmMeetingMain.nav.meetingCancle')}')" 
                                          target="_self" title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingCancle')}">${lfn:message('km-meeting:kmMeetingMain.nav.meetingCancle')}</a></li>
                               </ul>
                           </div>
                           <!-- 区块 Begin -->
                       </div>
                       <div class="meeting_pro_contentBox_2 clrfix">
                           <!-- 区块 Begin -->
                           <div class="meeting_proC_left">
                               <div class="m_pro_header">
                                   <i class="m_pro_head_num_4"></i>
                                   <p class="m_pro_head_bg_4">${lfn:message('km-meeting:kmMeetingMain.nav.meetingAnalyAndKnowShare')}</p>
                               </div>
                               <ul class="m_pro_ul_4 clrfix">
                                   <li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingMain_nav.jsp','${lfn:message('km-meeting:kmMeetingMain.nav.meetingReport')}')"
                                          target="_self" title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingReport')}">${lfn:message('km-meeting:kmMeetingMain.nav.meetingReport')}</a></li>
                                   <li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingMain_nav.jsp','${lfn:message('km-meeting:kmMeetingMain.nav.meetingAchiveFile')}')" 
                                          target="_self" title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingAchiveFile')}">${lfn:message('km-meeting:kmMeetingMain.nav.meetingAchiveFile')}</a></li>
                                   <li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingMain_nav.jsp?status=30','${lfn:message('km-meeting:kmMeetingMain.nav.meetingPass')}')"
                                          target="_self" title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingPass')}">${lfn:message('km-meeting:kmMeetingMain.nav.meetingPass')}</a></li>
                                   <li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingMain_nav.jsp','${lfn:message('km-meeting:kmMeetingMain.nav.meetingChoiceSubside')}')"
                                          target="_self" title=${lfn:message('km-meeting:kmMeetingMain.nav.meetingChoiceSubside')}>${lfn:message('km-meeting:kmMeetingMain.nav.meetingChoiceSubside')}</a></li>
                                   <li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingMain_nav.jsp','${lfn:message('km-meeting:kmMeetingMain.nav.meetingFlowSubside')}')" 
                                          target="_self" title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingFlowSubside')}">${lfn:message('km-meeting:kmMeetingMain.nav.meetingFlowSubside')}</a></li>
                               </ul>
                           </div>
                           <!-- 区块 Begin -->
                           <!-- 区块 Begin -->
                           <div class="meeting_proC_right">
                               <div class="m_pro_header">
                                   <i class="m_pro_head_num_3"></i>
                                   <p class="m_pro_head_bg_3">${lfn:message('km-meeting:kmMeetingMain.nav.meetingFllow')}</p>
                               </div>
                               <ul class="m_pro_ul_3 clrfix">
                                   <li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingMain_nav.jsp?status=30','${lfn:message('km-meeting:kmMeetingMain.nav.meetingReceipt')}')"
                                          target="_self" title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingReceipt')}">${lfn:message('km-meeting:kmMeetingMain.nav.meetingReceipt')}</a></li>
                                   <li><a href="javascript:iframeUrl('/km/meeting/km_meeting_main/kmMeetingMain.do?method=meetingCalendar&mydoc=false&status=30','${lfn:message('km-meeting:kmMeetingMain.nav.meetingCalendar')}',{width:980,height:570,left:300,top:30})" 
                                          name="${ lfn:message('km-meeting:kmMeeting.tree.calender')}" target="_self" title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingCalendar')}">${lfn:message('km-meeting:kmMeetingMain.nav.meetingCalendar')}</a></li>
                               	<li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingSummary_nav.jsp','${lfn:message('km-meeting:kmMeetingMain.nav.meetingSummary')}')"
                               	       title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingSummary')}" target="_self">${lfn:message('km-meeting:kmMeetingMain.nav.meetingSummary')}</a></li>
                                   <li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingMain_nav.jsp?status=30','${lfn:message('km-meeting:kmMeetingMain.nav.meetingHandle')}')"
                                          target="_self" title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingHandle')}">${lfn:message('km-meeting:kmMeetingMain.nav.meetingHandle')}</a></li>
                                   <li><a href="javascript:iframeUrl('/km/meeting/nav/kmMeetingMain_nav.jsp?status=30','${lfn:message('km-meeting:kmMeetingMain.nav.meetingTask')}')" 
                                          target="_self" title="${lfn:message('km-meeting:kmMeetingMain.nav.meetingTask')}">${lfn:message('km-meeting:kmMeetingMain.nav.meetingTask')}</a></li>
                               </ul>
                           </div>
                           <!-- 区块 Begin -->
                       </div>
                   </div>
               </div>
                <div class="meeting_graSection">
                    <h2>${lfn:message('km-meeting:kmMeetingMain.nav.meetingSingleProcess')}</h2>
                    <ul class="meeting_gra_example clrfix">
                        <li class="m_e_item_1_L">
                            <div class="m_e_item_1_R">
                                <div class="m_e_item_1_C">${lfn:message('km-meeting:kmMeetingMain.nav.meetingArrange')}</div>
                            </div>
                        </li>
                        <li class="m_e_item_2_L">
                            <div class="m_e_item_2_R">
                                <div class="m_e_item_2_C">${lfn:message('km-meeting:kmMeetingMain.nav.meetingCheck')}</div>
                            </div>
                        </li>
                        <li class="m_e_item_3_L">
                            <div class="m_e_item_3_R">
                                <div class="m_e_item_3_C">${lfn:message('km-meeting:kmMeetingMain.nav.meetingPublish')}</div>
                            </div>
                        </li>
                        <li class="m_e_item_4_L">
                            <div class="m_e_item_4_R">
                                <div class="m_e_item_4_C">${lfn:message('km-meeting:kmMeetingMain.nav.meetingReceipt')}</div>
                            </div>
                        </li>
                        <li class="m_e_item_5_L">
                            <div class="m_e_item_5_R">
                                <div class="m_e_item_5_C">${lfn:message('km-meeting:kmMeetingMain.nav.meetingStart')}</div>
                            </div>
                        </li>
                        <li class="m_e_item_6_L">
                            <div class="m_e_item_6_R">
                                <div class="m_e_item_6_C">${lfn:message('km-meeting:kmMeetingMain.nav.meetingSummary')}</div>
                            </div>
                        </li>
                        <li class="m_e_item_7_L">
                            <div class="m_e_item_7_R">
                                <div class="m_e_item_7_C">${lfn:message('km-meeting:kmMeetingMain.nav.meetingPracticable')}</div>
                            </div>
                        </li>
                        <li class="m_e_item_8_L">
                            <div class="m_e_item_8_R">
                                <div class="m_e_item_8_C">${lfn:message('km-meeting:kmMeetingMain.nav.meetingPass')}</div>
                            </div>
                        </li>
                    </ul>
                </div>
              <script type="text/javascript">
                seajs.use(['lui/dialog'], function(dialog) {
			 	//新建会议
		 		 window.addDoc = function() {
						dialog.categoryForNewFile(
								'com.landray.kmss.km.meeting.model.KmMeetingTemplate',
								'/km/meeting/km_meeting_main/kmMeetingMain.do?method=add&fdTemplateId=!{id}',false,null,null,'${param.categoryId}');
			 			};

			     window.iframeUrl=function(url,title,config){
				     if(config!=null){
				     	dialog.iframe(url,title,null,{width:config.width,height:config.height,left:config.left,top:config.top});
				      }else{
				    	dialog.iframe(url,title,null,{width:800,height:475});
				      }
			        	};
                });		
			 </script>
	</template:replace> 
</template:include>
