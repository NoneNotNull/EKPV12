<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import=" com.landray.kmss.util.ResourceUtil"%>
<%request.setAttribute("dateTimeFormatter",ResourceUtil.getString("date.format.datetime"));%>
<template:include ref="default.edit" sidebar="no" >

	<template:replace name="head">
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/imeeting/km_imeeting_calendar/calendar.css" />
	</template:replace>

	<%--页签名--%>
	<template:replace name="title">
		<c:choose>
			<c:when test="${ kmImeetingMainForm.method_GET == 'add' }">
				<c:out value="${ lfn:message('km-imeeting:kmImeetingMain.opt.create') } - ${ lfn:message('km-imeeting:module.km.imeeting') }"></c:out>	
			</c:when>
			<c:otherwise>
				<c:out value="${kmImeetingMainForm.fdName} - ${ lfn:message('km-imeeting:module.km.imeeting') }"></c:out>
			</c:otherwise>
		</c:choose>
	</template:replace>
	
	<%--操作栏--%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float"> 
			<%--暂存--%>
		    <ui:button text="${lfn:message('button.savedraft') }" order="2" onclick="commitMethod('save', 'true');"></ui:button>
		    <%--保存--%>
			<ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod('save', 'false');"></ui:button>
			<ui:button text="${ lfn:message('button.close') }" order="5"  onclick="Com_CloseWindow()"></ui:button>
		</ui:toolbar>
	</template:replace>
	
	<%--导航路径--%>
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
	
	<%--内容区--%>
	<template:replace name="content"> 
		<c:if test="${kmImeetingMainForm.method_GET=='add'}">
			<script type="text/javascript">
				window.changeDocTemp = function(modelName,url,canClose){
					if(modelName==null || modelName=='' || url==null || url=='')
						return;
			 		seajs.use(['sys/ui/js/dialog'],function(dialog) {
					 	dialog.categoryForNewFile(modelName,url,false,null,
						function(rtn) {
							// 无分类状态下（一般于门户快捷操作）创建文档，取消操作同时关闭当前窗口
							if (!rtn)
								window.close();
						},'${param.categoryId}','_self',canClose);
				 	});
			 	};
				if('${param.fdTemplateId}'==''){
					window.changeDocTemp('com.landray.kmss.km.imeeting.model.KmImeetingTemplate','/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=add&fdTemplateId=!{id}',true);
				}
			</script>
		</c:if>
		<html:form action="/km/imeeting/km_imeeting_main/kmImeetingMain.do">
			<html:hidden property="fdId" />
			<html:hidden property="docStatus" />
			<html:hidden property="docCreatorId" />
			<html:hidden property="docCreateTime" />
			<html:hidden property="fdNotifyerId" />
			<html:hidden property="fdChangeMeetingFlag" />
			<html:hidden property="fdSummaryFlag" />
			<html:hidden property="method_GET" />
 			<ui:step id="__step" style="background-color:#f2f2f2" onSubmit="commitMethod('save','false');">
				<%--会议信息填写--%>
				<ui:content title="${lfn:message('km-imeeting:kmImeetingMain.createStep.base') }" toggle="false" id="validate_ele0">
					 <table class="tb_normal" width=100% id="Table_Main"> 
					 	<tr>
					 		<td colspan="4" class="com_subject" style="font-size: 110%;font-weight: bold;">
					 			<bean:message bundle="km-imeeting" key="kmImeetingMain.createStep.base"/>
					 		</td>
					 	</tr>
					 	<tr>
					 		<%--会议名称--%>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-imeeting" key="kmImeetingMain.fdName"/>
							</td>			
							<td width="85%" colspan="3">
								<xform:text property="fdName" style="width:97%" />		 	
							</td>
					 	</tr>
					 	<tr>
					 		<%--召开时间--%>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-imeeting" key="kmImeetingMain.fdDate"/>
							</td>			   
							<td width="35%" >
								<xform:datetime property="fdHoldDate" dateTimeType="datetime" showStatus="edit" 
									onValueChange="changeDateTime"  required="true" validators="after compareTime"></xform:datetime>
								<span style="position: relative;top:-5px;">~</span>
								<xform:datetime property="fdFinishDate" dateTimeType="datetime" showStatus="edit" 
									onValueChange="changeDateTime" required="true" validators="after compareTime"></xform:datetime>
								<%--隐藏域,保存改变前的时间，用于回退--%>
								<input type="hidden" name="fdHoldDateTmp" value="${kmImeetingMainForm.fdHoldDate}">
								<input type="hidden" name="fdFinishDateTmp" value="${kmImeetingMainForm.fdFinishDate}">
								
							</td>
							<%--会议历时--%>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-imeeting" key="kmImeetingMain.fdHoldDuration"/>
							</td>
							<td width="35%">
								<input type="text" name="fdHoldDurationHour" validate="digits maxLength(4)" class="inputsgl" style="width:50px;text-align: center;"  onchange="changeDuration();"/><bean:message key="date.interval.hour"/>
								<input type="text" name="fdHoldDurationMin" validate="digits maxLength(4)" class="inputsgl" style="width:50px;text-align: center;"  onchange="changeDuration();"/><bean:message key="date.interval.minute"/>
								<xform:text property="fdHoldDuration" showStatus="noShow"/>
							</td>
					 	</tr>
					 	<tr>
					 		<%--会议目的--%>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-imeeting" key="kmImeetingMain.fdMeetingAim"/>
							</td>			
							<td width="85%" colspan="3" >
								<xform:textarea property="fdMeetingAim" style="width:97%;" />
							</td>
					 	</tr>
					 	<tr>
					 		<%--会议类型--%>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-imeeting" key="kmImeetingMain.fdTemplate"/>
							</td>			
							<td width="35%" >
								<html:hidden property="fdTemplateId"/>
								<c:out value="${kmImeetingMainForm.fdTemplateName }"></c:out>
							</td>
							<%--会议编号--%>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-imeeting" key="kmImeetingMain.fdMeetingNum"/>
							</td>			
							<td width="35%" >
								<bean:message bundle="km-imeeting" key="kmImeetingMain.createStep.base.fdMeetingNum.tip"/>
								<span style="float: right;"></span>
							</td>
					 	</tr>
					 	<tr>
					 		<%--会议组织人--%>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-imeeting" key="kmImeetingTemplate.fdEmcee"/>
							</td>			
							<td width="35%" >
								<xform:address propertyName="fdEmceeName" propertyId="fdEmceeId" orgType="ORG_TYPE_PERSON" style="width:95%;"></xform:address>
							</td>
							<%--组织部门--%>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-imeeting" key="kmImeetingMain.docDept"/>
							</td>			
							<td width="35%" >
								<xform:address propertyName="docDeptName" propertyId="docDeptId" subject="${lfn:message('km-imeeting:kmImeetingMain.docDept') }"
									orgType="ORG_TYPE_DEPT" style="width:95%;" required="true"></xform:address>
							</td>
					 	</tr>
					 	<tr>
					 		<%--会议发起人--%>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-imeeting" key="kmImeetingMain.docCreator"/>
							</td>			
							<td width="85%" colspan="3" >
								<html:hidden property="docCreatorId"/>
								<c:out value="${kmImeetingMainForm.docCreatorName }"></c:out>
							</td>
					 	</tr>
					 	<tr>
					 		<td colspan="4" class="com_subject"  style="font-size: 110%;font-weight: bold;">
					 			<bean:message bundle="km-imeeting" key="kmImeetingMain.createStep.base.fdAttendPersons"/>
					 			<div style="float: right;margin-right: 30px;border: 0px;color: #333;">
					 				<ui:button text="${lfn:message('km-imeeting:kmImeetingMain.checkFree.text') }"  onclick="checkFree();" href="javascript:void(0);"
					 					title="${lfn:message('km-imeeting:kmImeetingMain.checkFree.title') }"/>
					 				预计<xform:text property="fdAttendNum" validators="min(1)" style="width:40px;text-align:center;"/>人参与
					 			</div>
					 		</td>
					 	</tr>
					 	<tr>
					 		<%--主持人--%>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-imeeting" key="kmImeetingMain.fdHost"/>
							</td>			
							<td width="85%" colspan="3" >
								<xform:address propertyName="fdHostName" propertyId="fdHostId" orgType="ORG_TYPE_PERSON" style="width:47%;" onValueChange="caculateAttendNum"></xform:address>&nbsp;
								&nbsp;&nbsp;&nbsp;&nbsp;
								<xform:text property="fdOtherHostPerson" htmlElementProperties="placeholder='${lfn:message('km-imeeting:kmImeetingMain.fdOtherHostPerson') }'" style="width:47%;position: relative;top:-8px;" />
							</td>
					 	</tr>
					 	<tr>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-imeeting" key="kmImeetingMain.fdAttendPersons"/>
							</td>			
							<td width="85%" colspan="3" >
								<%--参加人员--%>
								<xform:address  style="width:47%;height:80px;" textarea="true" showStatus="edit"  propertyId="fdAttendPersonIds" propertyName="fdAttendPersonNames" 
									orgType="ORG_TYPE_ALL" mulSelect="true" onValueChange="caculateAttendNum" validators="validateattend"></xform:address>
						  		&nbsp;&nbsp;&nbsp;&nbsp;
						  		<%--外部参加人员--%>
						  		<xform:textarea style="width:47%;border:1px solid #b4b4b4"  property="fdOtherAttendPerson" showStatus="edit"
						  			htmlElementProperties="placeholder='${lfn:message('km-imeeting:kmImeetingMain.fdOtherAttendPerson') }'"  validators="validateattend maxLength(1500)" />
						  		<span class="txtstrong">*</span>
							</td>
					 	</tr>
					 	<tr>
					 		<%--列席人员--%>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-imeeting" key="kmImeetingMain.fdParticipantPersons"/>
							</td>			
							<td width="85%" colspan="3" >
								<xform:address style="width:47%;height:80px" textarea="true" showStatus="edit"  propertyId="fdParticipantPersonIds" propertyName="fdParticipantPersonNames" orgType="ORG_TYPE_ALL" mulSelect="true" onValueChange="caculateAttendNum"></xform:address>
						  		&nbsp;&nbsp;&nbsp;&nbsp;
						  		<xform:textarea style="width:47%;border:1px solid #b4b4b4" property="fdOtherParticipantPerson" showStatus="edit"  validators="maxLength(1500)"
						  			htmlElementProperties="placeholder='${lfn:message('km-imeeting:kmImeetingMain.fdOtherParticipantPerson') }'"/>
							</td>
					 	</tr>
					 	<tr>
					 		<%--抄送人员--%>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-imeeting" key="kmImeetingMain.fdCopyToPersons"/>
							</td>			
							<td width="85%" colspan="3" >
								<xform:address style="width:47%;height:80px" textarea="true" showStatus="edit"  propertyId="fdCopyToPersonIds" propertyName="fdCopyToPersonNames" orgType="ORG_TYPE_ALL" mulSelect="true"></xform:address>
						  		&nbsp;&nbsp;&nbsp;&nbsp;
						  		<xform:textarea style="width:47%;border:1px solid #b4b4b4" property="fdOtherCopyToPerson" showStatus="edit"  validators="maxLength(1500)"
						  			htmlElementProperties="placeholder='${lfn:message('km-imeeting:kmImeetingMain.fdOtherCopyToPerson') }'"/>
							</td>
					 	</tr>
					 	<tr>
					 		<%--纪要录入人--%>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-imeeting" key="kmImeetingMain.fdSummaryInputPerson"/>
							</td>
							<td width="35%" >
								<xform:address style="width:95%;"   propertyId="fdSummaryInputPersonId" propertyName="fdSummaryInputPersonName" 
									orgType="ORG_TYPE_PERSON" onValueChange="caculateAttendNum"  validators="validateSummaryInputPerson"></xform:address>
							</td>
							<%--纪要完成时间--%>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-imeeting" key="kmImeetingMain.fdSummaryCompleteTime"/>
							</td>			
							<td width="35%" >
								<xform:datetime property="fdSummaryCompleteTime" style="width:75%" showStatus="edit" dateTimeType="date"  validators="validateSummaryCompleteTime validateWithHoldDate"></xform:datetime>
								<%--是否催办纪要--%>
								<span>
						 			<input type="checkbox" style="margin-left:10px" name="fdIsHurrySummary" value="true" onclick="showHurryDayDiv();" 
										<c:if test="${kmImeetingMainForm.fdIsHurrySummary == 'true'}">checked</c:if>> 
										<bean:message bundle="km-imeeting" key="kmImeetingMain.fdIsHurrySummary" />
								</span>
								<span id="HurryDayDiv" style="display:none">
									&nbsp;<bean:message bundle="km-imeeting" key="kmImeetingMain.fdHurrySummaryDay.0" />
									<xform:text property="fdHurryDate" style="width:30px" showStatus="edit"/> 
									<bean:message	bundle="km-imeeting" key="kmImeetingMain.fdHurrySummaryDay.1" /> 
								</span> 
							</td>
					 	</tr>
					 	 <tr>
					 		<td colspan="4" class="com_subject" style="font-size: 110%;font-weight: bold;">
					 			<bean:message bundle="km-imeeting" key="kmImeetingMain.createStep.base.agenda"/>
					 		</td>
					 	</tr>
					 	<tr>
					 		<%--会议议程信息--%>
					 		<td colspan="4">
					 			<%@include file="/km/imeeting/km_imeeting_agenda/kmImeetingAgenda_edit.jsp"%>
					 		</td>
					 	</tr>
					 	<tr>
					 		<%--相关资料--%>
					 		<td class="td_normal_title" width=15%>
					 			<bean:message bundle="km-imeeting" key="kmImeetingMain.attachment"/>
					 		</td>
					 		<td width="85%" colspan="3" >
								<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
									<c:param name="fdKey" value="attachment" />
									<c:param name="fdModelId" value="${param.fdId }" />
									<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingMain" />
								</c:import>
							</td>
					 	</tr>
					 	<tr>
					 		<%--备注--%>
					 		<td class="td_normal_title" width=15%>
					 			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdRemark"/>
					 		</td>
					 		<td width="85%" colspan="3" >
								<xform:textarea property="fdRemark" style="width:97%;"></xform:textarea>
							</td>
					 	</tr>
					 </table>
				</ui:content>
				<%-- 会议资源预定 --%>
				<ui:content title="${lfn:message('km-imeeting:kmImeetingMain.createStep.resource') }" toggle="false"  id="validate_ele1">
					 <table class="tb_normal" width=100% id="Table_Res"> 
					 	<tr>
					 		<td colspan="4" class="com_subject" style="font-size: 110%;font-weight: bold;">
					 			<bean:message bundle="km-imeeting" key="kmImeetingMain.createStep.resource.base"/>
					 		</td>
					 	</tr>
						<tr>
					 		<%--选择会议室--%>
					 		<td class="td_normal_title" width=15%>
					 			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdPlace"/>
					 		</td>
					 		<td width="85%" colspan="3" >
					 			<xform:dialog propertyId="fdPlaceId" propertyName="fdPlaceName" showStatus="edit" validators="validateplace"
					 				className="inputsgl" style="width:44%;float:left">
							  	 	selectHoldPlace();
								</xform:dialog>
								&nbsp;	&nbsp;	&nbsp;
					 			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherPlace"/>
								<xform:text property="fdOtherPlace" style="width:43%;" validators="validateplace"></xform:text>
								<span class="txtstrong">*</span>
							</td>
					 	</tr>
					 	<tr>
					 		<%--会议室辅助设备--%>
					 		<td class="td_normal_title" width=15%>
					 			<bean:message bundle="km-imeeting" key="kmImeetingMain.kmImeetingDevices"/>
					 		</td>
					 		<td width="85%" colspan="3" >
								<ui:dataview>
									<ui:source type="AjaxJson">
										{url:'/km/imeeting/km_imeeting_device/kmImeetingDevice.do?method=listDevices'}
									</ui:source>
									<ui:render type="Template">
										<c:import url="/km/imeeting/resource/tmpl/devices.jsp" charEncoding="UTF-8"></c:import>
									</ui:render>
								</ui:dataview>
							</td>
					 	</tr>
					 	<tr>
					 		<%--会场布置要求--%>
					 		<td class="td_normal_title" width=15%>
					 			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdArrange"/>
					 		</td>
					 		<td width="85%" colspan="3" >
								<xform:textarea property="fdArrange" style="width:97%;"></xform:textarea>
							</td>
					 	</tr>
					 	 <tr>
					 		<%--会议协助人--%>
					 		<td class="td_normal_title" width=15%>
					 			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdAssistPersons"/>
					 		</td>
					 		<td width="85%" colspan="3" >
					 			<xform:address style="width:47%;height:80px" textarea="true" showStatus="edit"  propertyId="fdAssistPersonIds" propertyName="fdAssistPersonNames" orgType="ORG_TYPE_ALL" mulSelect="true"></xform:address>
						  		&nbsp;&nbsp;&nbsp;&nbsp;
						  		<xform:textarea style="width:47%;border:1px solid #b4b4b4" property="fdOtherAssistPersons" validators="maxLength(1500)"
						  			htmlElementProperties="placeholder='${lfn:message('km-imeeting:kmImeetingMain.fdOtherAssistPersons') }'"/>
							</td>
					 	</tr>
					 	<tr>
					 		<td colspan="4" class="com_subject" style="font-size: 110%;font-weight: bold;">
					 			<bean:message bundle="km-imeeting" key="kmImeetingMain.createStep.resource.calendar"/>
					 		</td>
					 	</tr>
					 	<tr>
					 		<%--会议资源日历--%>
					 		<td colspan="4" style="padding: 1px;">
					 			<script>
									seajs.use([
										'km/imeeting/resource/js/dateUtil',
										'lui/dialog',
										'lui/topic',
										'lui/jquery',
										], function(dateUtil,dialog,topic,$) {
										//引入日历虚拟类
										//window.meetingCalendar=calendar.MeetingCalendarMode;

										//数据初始化
										window.transformData=function(datas){
											var main=datas.main;
											for(var key in main){
												for(var i=0;i<main[key].list.length;i++){
													var item=main[key].list[i];
													if(checkStatus(item)==-1){
														item.color=$('.meeting_calendar_label_unhold').css('background-color');
													}
													if(checkStatus(item)==0){
														item.color=$('.meeting_calendar_label_holding').css('background-color');
													}
													if(checkStatus(item)==1){
														item.color=$('.meeting_calendar_label_hold').css('background-color');
													}
												}
											}
											return datas;
										};

										//当前会议状态
										var checkStatus=function(item){
											var startDate=dateUtil.parseDate(item.start),endDate=dateUtil.parseDate(item.end);
											var now=new Date();
											//未召开
											if(now.getTime()<startDate.getTime()){
												return -1;
											}
											//进行中
											if(now.getTime()>=startDate.getTime() && now.getTime()<=endDate.getTime()){
												return 0;
											}
											//已召开
											if(now.getTime()>endDate.getTime()){
												return 1;
											}
										};
										
										//定位
										var getPos=function(evt,obj){
											var sWidth=obj.width();var sHeight=obj.height();
											x=evt.pageX;
											y=evt.pageY;
											if(y+sHeight>$(window).height()){
												y-=sHeight;
											}
											if(x+sWidth>$(document.body).outerWidth(true)){
												x-=sWidth;
											}
											return {"top":y,"left":x};
										};

										//查看
										topic.subscribe('calendar.thing.click',function(arg){
											$('.meeting_calendar_dialog').hide();
											var viewDialog;//弹出框
											if(arg.data.type =="book"){
												viewDialog=$("#meeting_calendar_bookview");//会议室预约弹出框
												viewDialog.find(".fdRemark").html(textEllipsis(arg.data.fdRemark));//备注
											}else{
												viewDialog=$("#meeting_calendar_mainview");//会议安排弹出框
												viewDialog.find(".fdHost").html(arg.data.fdHost);//主持人
											}
											//时间格式2014-7-11~2014-7-12
											var date=dateUtil.formatDate(arg.data.start,"${dateTimeFormatter}");
											if(arg.data.start!=arg.data.end){
												date+="~"+dateUtil.formatDate(arg.data.end,"${dateTimeFormatter}");
											}
											viewDialog.find(".fdId").html(arg.data.fdId);//fdId
											viewDialog.find(".fdName").html(arg.data.title);//会议题目
											viewDialog.find(".fdPlace").html(arg.data.fdPlaceName);//地点
											viewDialog.find(".fdHoldDate").html(date);//召开时间

											var creator=arg.data.creator;
											if(arg.data.dept){
												creator+="("+arg.data.dept+")";//（部门）
											}
											viewDialog.find(".docCreator").html(creator);//人员（部门）
											//会议预约按钮权限检测
											if(arg.data.type=="book"){
												$('#book_delete_btn,#book_edit_btn').hide();
												$.ajax({
													url: "${LUI_ContextPath}/km/imeeting/km_imeeting_book/kmImeetingBook.do?method=checkAuth",
													type: 'POST',
													dataType: 'json',
													data: {fdId: arg.data.fdId},
													success: function(data, textStatus, xhr) {//操作成功
														if(data.canEdit){
															$('#book_edit_btn').show();
														}
														if(data.canDelete){
															$('#book_delete_btn').show();
														}
													}
												});
											}
											viewDialog.css(getPos(arg.evt,viewDialog)).fadeIn("fast");
										});
										
										//字符串截取
										function textEllipsis(text){
											if(text.length>200){
												text=text.substring(0,200)+"......";
											}
											return text;
										}
										
									});
								</script>
								<ui:calendar id="calendar" showStatus="view" mode="meetingCalendar"  layout="km.imeeting.calendar.default" customMode="{'id':'meetingCalendar','name':'会议日历','func':'km/imeeting/km_imeeting_calendar/calendar'}">
									<%--数据--%>
									<ui:dataformat>
										<ui:source type="AjaxJson">
											{url:'/km/imeeting/km_imeeting_calendar/kmImeetingCalendar.do?method=rescalendar'}
										</ui:source>
										<ui:transform type="ScriptTransform">
											return transformData(data);
										</ui:transform>
									</ui:dataformat>
								</ui:calendar>
								<%--日期列看不见时固定在顶部--%>
								<ui:fixed elem=".meeting_calendar_date_fix"></ui:fixed>
								<%--弹出框--%>
								<%@ include file="/km/imeeting/km_imeeting_calendar/kmImeetingCalendar_view.jsp"%>
					 		</td>
					 	</tr>
					</table>
				</ui:content>
				<%-- 权限及流程处理 --%>
				<ui:content title="${lfn:message('km-imeeting:kmImeetingMain.createStep.rightAndWorkflow') }" toggle="false">
					<c:import url="/km/imeeting/km_imeeting_main/kmImeetingMain_rightAndWorkflow_add.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="kmImeetingMainForm" />
						<c:param name="moduleModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingMain" />
						<c:param name="fdKey" value="ImeetingMain" />
					</c:import>
				</ui:content>
				<%-- 发送会议通知单 --%>
				<ui:content title="${lfn:message('km-imeeting:kmImeetingMain.createStep.sendNotify') }" toggle="false">
					<%-- 会议通知 --%>
					<div>
						<div class="com_subject lui_imeeting_title">
							${lfn:message('km-imeeting:kmImeetingMain.createStep.sendNotify') }
						</div>
					</div>
					<div>
						<table class="tb_normal" width=100%>
							<%-- 会议通知选项 --%>
							<tr>
								<td class="td_normal_title" width=15%>
									<bean:message bundle="km-imeeting" key="kmImeetingMain.fdNotifyType"/>
								</td>
								<td width="85%" colspan="3">
									<xform:radio property="fdNotifyType" showStatus="edit">
		       							<xform:enumsDataSource enumsType="km_imeeting_main_fd_notify_type" />
									</xform:radio>
								</td>
							</tr>
							<%-- 会议通知方式 --%>
							<tr>
								<td class="td_normal_title" width=15%>
									<bean:message bundle="km-imeeting" key="kmImeetingMain.fdNotifyType"/>
								</td>
								<td width="85%" colspan="3">
									 <kmss:editNotifyType property="fdNotifyWay" />
								</td>
							</tr>
						</table>
					</div>
				</ui:content>
			</ui:step>
		</html:form>
	</template:replace>
</template:include>
<%@include file="/km/imeeting/km_imeeting_main/kmImeetingMain_add_js.jsp"%>