<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
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
<template:include ref="default.view" sidebar="no">
	<template:replace name="head">
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/imeeting/resource/css/view.css" />
	</template:replace>

	<template:replace name="title">
		<c:out value="${ kmImeetingMainForm.fdName} - ${ lfn:message('km-imeeting:table.kmImeetingMain') }"></c:out>
	</template:replace>
	
	<%--操作栏--%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="3">
			<c:if test="${kmImeetingMainForm.docStatusFirstDigit=='3'}">
			
			<%--发送会议通知，条件：1、通知类型为手动通知 2、未发送会议通知 3、会议未开始 --%>
			<kmss:auth requestURL="/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=sendNotify&fdId=${param.fdId}">
				<c:if test="${kmImeetingMainForm.fdNotifyType=='2' && kmImeetingMainForm.isNotify!='true' && isBegin==false}">
					<ui:button id="sendNotify" order="1" title="${lfn:message('km-imeeting:kmImeetingMain.createStep.sendNotify') }" 
						text="${lfn:message('km-imeeting:kmImeetingMain.createStep.sendNotify') }"   onclick="sendNotify();">
					</ui:button>
				</c:if>
			</kmss:auth>
			<%-- 催办会议，条件：1、已发送会议通知 2、会议未开始  --%>
			<c:if test="${kmImeetingMainForm.isNotify==true && isBegin==false}">
				<kmss:auth
					requestURL="/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=hastenMeeting&fdId=${param.fdId}" requestMethod="GET">
					<ui:button order="1" title="${ lfn:message('km-imeeting:kmImeeting.btn.hastenMeeting') }"
						 text="${ lfn:message('km-imeeting:kmImeeting.btn.hastenMeeting') }" onclick="showHastenMeeting()">
					</ui:button>
				</kmss:auth>
			</c:if>
			<%-- 会议变更，条件：1、已发送会议通知 2、未录入纪要 3、会议未开始 --%>
			<c:if test="${kmImeetingMainForm.isNotify==true && kmImeetingMainForm.fdSummaryFlag=='false' && isBegin==false}">
				<kmss:auth
					requestURL="/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=changeMeeting&fdId=${param.fdId}"
					requestMethod="GET">
					<ui:button order="4" text="会议变更" 
							onclick="Com_OpenWindow('${LUI_ContextPath}/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=changeMeeting&fdId=${param.fdId}','_self');">
					</ui:button>
				</kmss:auth>
			</c:if>
			<%-- 取消会议，条件：1、已发送会议通知，2、会议未开始 --%>
			<c:if test="${kmImeetingMainForm.isNotify==true && isBegin==false}">
				<kmss:auth
					requestURL="/km/imeeting/km_imeeting_main/kmImeetingMainCancel.do?method=cancelMeeting&fdId=${param.fdId}" requestMethod="GET">
					<ui:button id="cancelbtn" order="4" text="取消会议"  onclick="showCancelMeeting();">
					</ui:button>
				</kmss:auth>
			</c:if>
			<%-- 会议纪要，条件：1、已发送会议通知 2、录入人才可录入 --%>
			<c:if test="${kmImeetingMainForm.isNotify==true && kmImeetingMainForm.fdSummaryFlag=='false' && not empty kmImeetingMainForm.fdSummaryInputPersonId }">
				<kmss:authShow extendOrgIds="${kmImeetingMainForm.fdSummaryInputPersonId}" roles="SYSROLE_ADMIN">
					<kmss:auth
						requestURL="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=operateSummary&meetingId=${param.fdId}"
						requestMethod="GET">
						<ui:button order="4" text="录入会议纪要" 
							onclick="Com_OpenWindow('${LUI_ContextPath}/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=operateSummary&meetingId=${param.fdId}','_blank');">
					    </ui:button>
					</kmss:auth>
				</kmss:authShow>
			</c:if>
			<%-- 会议纪要(会议纪要创建后，所有可阅读者可见) --%>
			<c:if test="${kmImeetingMainForm.fdSummaryFlag=='true' and not empty summaryId}">
				<kmss:auth
					requestURL="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=view&fdId=${summaryId}"
					requestMethod="GET">
					<ui:button order="4" text="查阅会议纪要" 
							onclick="Com_OpenWindow('${LUI_ContextPath}/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=operateSummary&meetingId=${param.fdId}','_blank');">
					</ui:button>
				</kmss:auth>
			</c:if>
			</c:if>
			<%-- 复制会议 --%> 
			<c:if test="${kmImeetingMainForm.docStatus=='30' }">
			<kmss:auth
				requestURL="/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=add&meetingId=${param.fdId}&copyMeeting=true"
				requestMethod="GET">
				     <ui:button order="5" text="复制会议" 
							onclick="Com_OpenWindow('${LUI_ContextPath}/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=add&fdTemplateId=${kmImeetingMainForm.fdTemplateId}&meetingId=${param.fdId}&copyMeeting=true','_self');">
					 </ui:button>
			</kmss:auth> 
			</c:if>
			 <%-- 编辑文档 --%> 
			<c:if test="${kmImeetingMainForm.docStatus!='00' && kmImeetingMainForm.docStatus!='30'&& kmImeetingMainForm.docStatus!='41'}">
				 <kmss:auth requestURL="/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
					     <ui:button order="3" text="${ lfn:message('button.edit') }"  onclick="Com_OpenWindow('kmImeetingMain.do?method=edit&fdId=${param.fdId}','_self');">
						 </ui:button>
				</kmss:auth>
			</c:if>
			
			<%-- 删除文档 --%>
			<kmss:auth requestURL="/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
				<ui:button order="4" text="${ lfn:message('button.delete') }"  onclick="Delete();"></ui:button>
			</kmss:auth>
			
			<ui:button text="${ lfn:message('button.close') }" order="5"  onclick="Com_CloseWindow()"></ui:button>
		</ui:toolbar>
	</template:replace>
	
	<%--路径--%>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav"  id="categoryId"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imeeting:module.km.imeeting') }" href="/km/imeeting/index.jsp" target="_self"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imeeting:table.kmImeetingMain') }" href="/km/imeeting/km_imeeting_main/index.jsp" target="_self"></ui:menu-item>
			<ui:menu-source autoFetch="false"  target="_self"  href="/km/imeeting/km_imeeting_main/index.jsp?categoryId=${kmImeetingMainForm.fdTemplateId}">
				<ui:source type="AjaxJson">
					{"url":"/sys/category/criteria/sysCategoryCriteria.do?method=path&modelName=com.landray.kmss.km.imeeting.model.KmImeetingTemplate&categoryId=${kmImeetingMainForm.fdTemplateId}"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
	</template:replace>
	
	<%--内容区--%>
	<template:replace name="content">
		<html:form action="/km/imeeting/km_imeeting_main/kmImeetingMain.do">
			<html:hidden property="fdId" />
			<p class="txttitle">
				<bean:message bundle="km-imeeting" key="kmImeetingMain.fdNotifyView" />
			</p>
			
			<%--回执提示栏显示条件：1、会议发布 2、会议未开始 3、会议已发通知 --%>
			<c:if test="${kmImeetingMainForm.docStatus=='30' and isBegin==false and kmImeetingMainForm.isNotify==true }">
				<%--已参加--%>
				<c:if test="${empty param.type && not empty optType && optType=='01' }">
					<div style="color: red;text-align: center;">
						您已回执参加此会议！<a  style="color: red;text-decoration: underline" 
								href="${LUI_ContextPath }/km/imeeting/km_imeeting_main_feedback/kmImeetingMainFeedback.do?method=edit&type=attend&meetingId=${kmImeetingMainForm.fdId }"  target="_blank">修改回执</a>
					</div>
				</c:if>
				<%--不参加--%>
				<c:if test="${empty param.type && not empty optType && optType=='02' }">
					<div style="color: red;text-align: center;">
						您已回执不参加此会议！<a style="color: red;text-decoration: underline"  
							href="${LUI_ContextPath }/km/imeeting/km_imeeting_main_feedback/kmImeetingMainFeedback.do?method=edit&type=attend&meetingId=${kmImeetingMainForm.fdId }"  target="_blank">修改回执</a>
					</div>
				</c:if>
				<%--找人代理--%>
				<c:if test="${empty param.type && not empty optType && optType=='03' }">
					<div style="color: red;text-align: center;">
						您已回执找人代参加此会议！
					</div>
				</c:if>
				<%--未回执--%>
				<c:if test="${empty param.type && not empty optType && optType=='04' }">
					<div style="color: red;text-align: center;">
						您尚未回执！<a style="color: red;text-decoration: underline" 
							href="${LUI_ContextPath }/km/imeeting/km_imeeting_main_feedback/kmImeetingMainFeedback.do?method=edit&type=attend&meetingId=${kmImeetingMainForm.fdId }"  target="_blank">请回执</a>
					</div>
				</c:if>
			</c:if>
			
			<%--内容区--%>
			<div class="lui_form_content_frame" style="padding-top:5px">
				<div style="float: right"></div>
			<%--会议通知单--%>
			<c:if test="${type=='admin'  }">
				<%--管理员、流程审批人、创建人，可以看到通知单所有信息--%>
				<%@include file="/km/imeeting/km_imeeting_notify_letter/km_imeeting_notify_letter_admin.jsp"%>
			</c:if>
			<c:if test="${type=='attend' }">
				<%--会议主持人/参加人/列席人员看到的会议通知单--%>
				<%@include file="/km/imeeting/km_imeeting_notify_letter/km_imeeting_notify_letter_attend.jsp"%>
			</c:if>
			<c:if test="${type=='assist'  }">
				<%--会议协助人、会议室保管员看到的会议通知单--%>
				<%@include file="/km/imeeting/km_imeeting_notify_letter/km_imeeting_notify_letter_assist.jsp"%>
			</c:if>
			<c:if test="${type=='cc'  }">
				<%--抄送人、可阅读者看到的会议通知单--%>
				<%@include file="/km/imeeting/km_imeeting_notify_letter/km_imeeting_notify_letter_cc.jsp"%>
			</c:if>
			
			<%--变更记录--%>
			<ui:dataview>
				<ui:source type="AjaxJson">
					{url:'/km/imeeting/km_imeeting_main_history/kmImeetingMainHistory.do?method=getChangeHistorysByMeeting&meetingId=${param.fdId }'}
				</ui:source>
				<ui:render type="Template">
					<c:import url="/km/imeeting/resource/tmpl/changeHistory.jsp" charEncoding="UTF-8"></c:import>
				</ui:render>
			</ui:dataview>
			
			</div>
		</html:form>
			<ui:tabpage expand="false">
				<%--收藏--%>
				<c:import url="/sys/bookmark/import/bookmark_bar.jsp" charEncoding="UTF-8">
					<c:param name="fdSubject" value="${kmImeetingMainForm.fdName}" />
					<c:param name="fdModelId" value="${kmImeetingMainForm.fdId}" />
					<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingMain" />
				</c:import>
				
				<%--回执页签，管理员、参与人、抄送人可见--%>
				<c:if test="${type=='admin' or type=='attend' or type=='cc'}">
					<%--会议回执--%>
					<c:if test="${kmImeetingMainForm.docStatusFirstDigit=='3' }">
					<kmss:auth requestURL="/km/imeeting/km_imeeting_main/kmImeetingMainFeedback.do?method=getFeedbackList&meetingId=${param.fdId}" requestMethod="GET">
						<ui:content title="${ lfn:message('km-imeeting:table.kmImeetingMainFeedback') }">
							<script type="text/javascript">	seajs.use(['theme!listview']);</script>
							<ui:dataview>
								<ui:source type="AjaxJson">
									{url:'/km/imeeting/km_imeeting_main_feedback/kmImeetingMainFeedback.do?method=getFeedbackList&meetingId=${param.fdId }&rowsize=10'}
								</ui:source>
								<ui:render type="Javascript">
									<%--
										//已废弃,被feedbackList.js替代 #7924
										<c:import url="/km/imeeting/resource/tmpl/feedbackList.jsp" charEncoding="UTF-8"></c:import>
									--%>
									<c:import url="/km/imeeting/resource/tmpl/feedbackList.js" charEncoding="UTF-8"></c:import>
								</ui:render>
							</ui:dataview>
							<list:paging></list:paging>
							<script>
								
							
							</script>
						</ui:content>
					</kmss:auth>
					</c:if>
	        	</c:if>
	        	
	        	<%--机制类页签，管理员可见--%>
	        	<c:if test="${type=='admin'}">
	        		<%--阅读次数--%>
					<c:import url="/sys/readlog/import/sysReadLog_view.jsp" charEncoding="UTF-8">
			       		<c:param name="formName" value="kmImeetingMainForm" />
		        	</c:import>
		        
					<%--发布机制--%>
					<c:import url="/sys/news/import/sysNewsPublishMain_view.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="kmImeetingMainForm" />
						<c:param name="fdKey" value="ImeetingMain" />
					</c:import>
					
					<%--传阅记录--%>
					<c:import url="/sys/circulation/import/sysCirculationMain_view.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="kmImeetingMainForm" />
					</c:import>
				</c:if>
					
					<%--相关任务--%>
					<kmss:ifModuleExist  path = "/sys/task/">
						<c:import url="/sys/task/import/sysTaskMain_view.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmImeetingMainForm" />
							<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingMain" />
						</c:import>
					</kmss:ifModuleExist>
					
				<c:if test="${type=='admin'}">
					 <%-- 权限 --%>
					<c:import url="/sys/right/import/right_view.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmImeetingMainForm" />
							<c:param name="moduleModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingMain" />
					</c:import>
					
					 <%-- 流程 --%>
					<c:import url="/sys/workflow/import/sysWfProcess_view.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmImeetingMainForm" />
							<c:param name="fdKey" value="ImeetingMain" />
					</c:import>
					<%--日程机制--%>
					<c:if test="${kmImeetingMainForm.syncDataToCalendarTime=='sendNotify'||kmImeetingMainForm.syncDataToCalendarTime=='personAttend'}">
						<ui:content title="${ lfn:message('sys-agenda:module.sys.agenda.syn') }" >
							<table class="tb_normal" width=100%>
								<%--同步时机--%>
								<tr>
									<td class="td_normal_title" width="15%">
								 		<bean:message bundle="sys-agenda" key="module.sys.agenda.syn.time" />
								 	</td>
								 	<td colspan="3">
								 		<xform:radio property="syncDataToCalendarTime">
							       			<xform:enumsDataSource enumsType="kmImeetingMain_syncDataToCalendarTime" />
										</xform:radio>
									</td>
								</tr>
								<tr>
									<td colspan="4" style="padding: 0px;">
									 	<c:import url="/sys/agenda/import/sysAgendaMain_general_view.jsp"	charEncoding="UTF-8">
									    	<c:param name="formName" value="kmImeetingMainForm" />
									    	<c:param name="fdKey" value="ImeetingMain" />
									    	<c:param name="fdPrefix" value="sysAgendaMain_formula_view" />
									 	</c:import>
							 		</td>
							 	</tr>
							</table>
						</ui:content>
					</c:if>
				</c:if>
				
				<%--会议跟踪页签，管理员、参与人、抄送人可见--%>
				<c:if test="${kmImeetingMainForm.docStatus!='10' and (type=='admin' or type=='attend' or type=='cc')}">
					<%--会议跟踪--%>
					<ui:content title="${ lfn:message('km-imeeting:table.kmImeetingMainHistory') }">
						<ui:dataview>
							<ui:source type="AjaxJson">
								{url:'/km/imeeting/km_imeeting_main_history/kmImeetingMainHistory.do?method=getHistorysByMeeting&meetingId=${param.fdId }'}
							</ui:source>
							<ui:render type="Template">
								<c:import url="/km/imeeting/resource/tmpl/history.jsp" charEncoding="UTF-8"></c:import>
							</ui:render>
						</ui:dataview>
					</ui:content>
				</c:if>
			</ui:tabpage>
	</template:replace>
</template:include>
<script type="text/javascript">
seajs.use([ 'km/imeeting/resource/js/dateUtil', 'sys/ui/js/dialog'], function(dateUtil,dialog) {

	window.Delete=function(){
    	dialog.confirm("${lfn:message('page.comfirmDelete')}",function(flag){
	    	if(flag==true){
	    		Com_OpenWindow('kmImeetingMain.do?method=delete&fdId=${param.fdId}','_self');
	    	}else{
	    		return false;
		    }
	    },"warn");
    };
	
	//发送会议通知
	window.sendNotify=function(){
		var names=(function(){
			var hostName="${kmImeetingMainForm.fdHostName }",
				attendName="${kmImeetingMainForm.fdAttendPersonNames }",
				participantName="${kmImeetingMainForm.fdParticipantPersonNames }";
			return convertToArray(hostName,attendName,participantName);
		})();
		//#9196 提示语：给人1，人2...发送会议通知，邀请您参加会议：XX会议主题，召开时间：XX，会议地点：XX 
		var confirmTip="${lfn:message('km-imeeting:kmImeetingMain.attend.notify.confirm.tip')}"
						.replace('%km-imeeting:kmImeetingMain.attend%',names)
						.replace('%km-imeeting:kmImeetingMain.fdName%','${kmImeetingMainForm.fdName}')
						.replace('%km-imeeting:kmImeetingMain.fdDate%','${kmImeetingMainForm.fdHoldDate}')
						.replace('%km-imeeting:kmImeetingMain.fdPlace%','${kmImeetingMainForm.fdPlaceName}'+'${kmImeetingMainForm.fdOtherPlace}');
		
		dialog.confirm(confirmTip,function(flag){
			if(flag==true){
				window._load = dialog.loading();
				$.post('<c:url value="/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=sendNotify&fdId=${param.fdId}"/>',
						function(data){
							if(window._load!=null)
								window._load.hide();
							if(data!=null && data.status==true){
								dialog.success('会议通知已发送');
								 LUI('toolbar').removeButton(LUI('sendNotify'));
							}else{
								dialog.failure('<bean:message key="return.optFailure" />');
							}
						},'json');
			}else{
				return false;
			}
			
		});
	};

	//会议催办
	window.showHastenMeeting=function(){
		dialog.iframe('/km/imeeting/km_imeeting_main_hasten/kmImeetingMainHasten.do?method=showHastenMeeting&meetingId=${param.fdId}',
			'催办会议',null,{width:600,height:360});
	};

	//会议取消
	window.showCancelMeeting=function(){
		dialog.iframe('/km/imeeting/km_imeeting_main_cancel/kmImeetingMainCancel.do?method=showCancelMeeting&meetingId=${param.fdId}',
				'取消会议',function(value){
			if(typeof value =="undefined"){
				location.reload();
			}
		},{width:600,height:380});
	};

	//初始化会议历时
	if( "${kmImeetingMainForm.fdHoldDuration}" ){
		//将小时分解成时分
		var timeObj=dateUtil.splitTime({"ms":"${kmImeetingMainForm.fdHoldDuration}"});
		$('#fdHoldDurationHour').html(timeObj.hour);
		$('#fdHoldDurationMin').html(timeObj.minute);
		if(timeObj.minute){
			$('#fdHoldDurationMinSpan').show();
		}else{
			$('#fdHoldDurationMinSpan').hide();
		}		
	}
	
	//转换成数组
	function convertToArray(){
		var slice=Array.prototype.slice,
			args=slice.call(arguments,0),
			arr=[];
		for(var i=0;i<args.length;i++){
			if(args[i]){
				var ids=args[i].split(';');
				for(var j=0;j<ids.length;j++){
					if(ids[j])
						arr.push(ids[j]);
				}
			}
		}
		return arr;
	}
	
});
</script>