<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
	Date now=new Date();
	Boolean isBegin=false,isEnd=false;
	KmImeetingMainForm kmImeetingMainForm = (KmImeetingMainForm)request.getAttribute("kmImeetingMainForm");
	// 会议已开始
	if (DateUtil.convertStringToDate(kmImeetingMainForm.getFdHoldDate(),
			DateUtil.PATTERN_DATETIME).getTime() < now.getTime()) {
		isBegin = true;
	}
	// 会议已结束
	if (DateUtil.convertStringToDate(kmImeetingMainForm.getFdFinishDate(),
			DateUtil.PATTERN_DATETIME).getTime() < now.getTime()) {
		isEnd = true;
	}
	request.setAttribute("isBegin", isBegin);
	request.setAttribute("isEnd", isEnd);
%>
<template:include ref="default.edit" sidebar="no" >
	<template:replace name="title">
		<c:out value="${kmImeetingMainForm.fdName} - ${ lfn:message('km-imeeting:table.kmImeetingMain') }"></c:out>
	</template:replace>
	
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float"> 
			<%--保存--%>
			<c:if test="${isBegin==false && kmImeetingMainFeedbackForm.fdOperateType!='03' }">
				<ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod('update', 'false');"></ui:button>
			</c:if>
			<ui:button text="${ lfn:message('button.close') }" order="5"  onclick="Com_CloseWindow()"></ui:button>
		</ui:toolbar>
	</template:replace>
	
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav"  id="categoryId"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imeeting:module.km.imeeting') }"  ></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imeeting:table.kmImeetingMain') }"></ui:menu-item>
			<ui:menu-source autoFetch="false">
				<ui:source type="AjaxJson">
					{"url":"/sys/category/criteria/sysCategoryCriteria.do?method=path&modelName=com.landray.kmss.km.imeeting.model.KmImeetingTemplate&categoryId=${kmImeetingMainForm.fdTemplateId}"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
	</template:replace>
	
	
	<template:replace name="content"> 
		<html:form action="/km/imeeting/km_imeeting_main_feedback/kmImeetingMainFeedback.do">
			<p class="txttitle">
				<bean:message bundle="km-imeeting" key="kmImeetingMain.fdNotifyView" />
			</p>
			<div class="lui_form_content_frame" style="padding-top:5px">
			<%--需要回复--%>
			<c:if test="${shouldFeedback==true }">
				<html:hidden property="fdId" />
				<html:hidden property="fdMeetingId"  value="${param.meetingId }"/>
				<table class="tb_normal" width="100%;">
					<tr>
						<%--回执留言--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMainFeedback.fdReason"/>
						</td>
						<td width="85%" colspan="3" >
							<xform:textarea property="fdReason" style="width:98%;" validators="validateReason"></xform:textarea>
						</td>
					</tr>
					<tr>
						<%--回执操作--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMainFeedback.fdOperateType"/>
						</td>
						<td width="35%" >
							<xform:radio property="fdOperateType" required="true" onValueChange="changeOptType">
								<xform:enumsDataSource enumsType="km_imeeting_main_feedback_fd_operate_type" />
							</xform:radio>
							<c:if test="${kmImeetingMainForm.syncDataToCalendarTime=='personAttend' }">
								<script>
									//同步时机为“参与人点击参加后同步”时，参加radio上面显示提示文字：点击确认参会并自动写入个人日程中
									seajs.use(['lui/jquery'],function($){
										$('[name="fdOperateType"][value="01"]').parent().attr('title','${lfn:message("km-imeeting:kmImeetingMain.attend.sync.tip")}');					
									});
								</script>
							</c:if>
						</td>
						<%--实际参与人员--%>
						<td class="td_normal_title" width=15%>
							<div class="docAttend" <c:if test="${kmImeetingMainFeedbackForm.fdOperateType!='03' }">style="display:none;"</c:if>>
								<bean:message bundle="km-imeeting" key="kmImeetingMainFeedback.docAttendId"/>
							</div>
						</td>
						<td width="35%" >
							<div class="docAttend" <c:if test="${kmImeetingMainFeedbackForm.fdOperateType!='03' }">style="display:none;"</c:if>>
								<xform:address propertyName="docAttendName" propertyId="docAttendId" orgType="ORG_TYPE_PERSON" style="width:50%;" validators="validateDocAttend"></xform:address>
							</div>
						</td>
					</tr>
				</table>
				<br/>
			</c:if>
			<%--会议通知单--%>
			<c:if test="${type=='admin'  }">
				<%--管理员，可以看到通知单所有信息--%>
				<%@include file="/km/imeeting/km_imeeting_notify_letter/km_imeeting_notify_letter_admin.jsp"%>
			</c:if>
			<c:if test="${param.type=='attend' }">
				<%--会议主持人/参加人/列席人员看到的会议通知单--%>
				<%@include file="/km/imeeting/km_imeeting_notify_letter/km_imeeting_notify_letter_attend.jsp"%>
			</c:if>
			<c:if test="${param.type=='assist' }">
				<%--会议协助人看到的会议通知单--%>
				<%@include file="/km/imeeting/km_imeeting_notify_letter/km_imeeting_notify_letter_assist.jsp"%>
			</c:if>
			<c:if test="${param.type=='cc' }">
				<%--抄送人员看到的会议通知单--%>
				<%@include file="/km/imeeting/km_imeeting_notify_letter/km_imeeting_notify_letter_cc.jsp"%>
			</c:if>
			</div>
		</html:form>
	</template:replace>

</template:include>
<script>
	var validation=$KMSSValidation();//校验框架
</script>
<script>
seajs.use([
          'km/imeeting/resource/js/dateUtil',
 	      'lui/jquery',
 	      'lui/dialog'
 	        ],function(dateUtil,$,dialog){
	

		//自定义校验器1：当回复不参加时，留言为必填
		validation.addValidator("validateReason","不参加必须填写理由",function(v, e, o){
			var fdOperateType=$('[name="fdOperateType"]:checked');
			var reason=$('[name="fdReason"]').val();
			if(fdOperateType && fdOperateType.val()=="02" && !reason){
				return false;	
			}
			return true;
		});
		
		//自定义校验器2：当回复找人代参加时，实际参与人为必填
		validation.addValidator("validateDocAttend","找人代参加必须填写实际参与人",function(v, e, o){
			var fdOperateType=$('[name="fdOperateType"]:checked');
			var docAttendId=$('[name="docAttendId"]').val();
			if(fdOperateType && fdOperateType.val()=="03" && !docAttendId){
				return false;	
			}
			return true;
		});
		

		//修改回执操作
		window.changeOptType=function(){
			KMSSValidation_HideWarnHint(document.getElementsByName("docAttendName"));
			KMSSValidation_HideWarnHint(document.getElementsByName("fdReason"));
			var fdOperateType=$('[name="fdOperateType"]:checked');
			if(fdOperateType && fdOperateType.val()=="03"){
				$('.docAttend').show();
				setTimeout(function(){
					//$('[name="docAttendName"]').trigger('click');
					Dialog_Address(false, 'docAttendId', 'docAttendName',null,ORG_TYPE_PERSON);
				},1);
			}else{
				$('.docAttend').hide();
			}
		};
		
		//提交
		window.commitMethod=function(commitType, saveDraft){
			var formObj = document.kmImeetingMainFeedbackForm;
			if ('save' == commitType) {
				Com_Submit(formObj, commitType, 'fdId');
			} else {
				Com_Submit(formObj, commitType);
			}
		};

		//初始化会议历时
		if('${kmImeetingMainForm.fdHoldDuration}'){
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

    });
</script>