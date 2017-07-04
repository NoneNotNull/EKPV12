<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.edit" compatibleMode="true">
	<template:replace name="content"> 
		<html:form action="/km/imeeting/km_imeeting_main_feedback/kmImeetingMainFeedback.do">
			<html:hidden property="fdId" />
			<html:hidden property="fdMeetingId"  value="${param.meetingId }"/>
			<div data-dojo-type="mui/view/DocScrollableView" id="scrollView" data-dojo-mixins="mui/form/_ValidateMixin">
				<div data-dojo-type="mui/panel/AccordionPanel">
					<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'回执单',icon:'mui-ul'">
						<table class="muiSimple" cellpadding="0" cellspacing="0">
							<tr>
								<%--回执操作--%>
								<td class="muiTitle">
									<bean:message bundle="km-imeeting" key="kmImeetingMainFeedback.fdOperateType"/>
								</td>
								<td>
									<xform:radio property="fdOperateType" required="true" mobile="true">
										<xform:enumsDataSource enumsType="km_imeeting_main_feedback_fd_operate_type" />
									</xform:radio>
								</td>
							</tr>
							<tr>
								<%--留言--%>
								<td class="muiTitle">
									<bean:message bundle="km-imeeting" key="kmImeetingMainFeedback.fdReason" />
								</td>
								<td>
									<xform:textarea property="fdReason" mobile="true" validators="validateReason"/>
								</td>
							</tr>
							
							<tr id="docAttend" style="<c:if test="${kmImeetingMainFeedbackForm.fdOperateType!='03' }">display: none;</c:if>" class="muiTitle">
								<%--实际参与人--%>
								<td class="muiTitle">
									<bean:message bundle="km-imeeting" key="kmImeetingMainFeedback.docAttendId"/>
								</td>
								<td>
									<xform:address propertyName="docAttendName" propertyId="docAttendId" orgType="ORG_TYPE_PERSON"
										 mobile="true" validators="validateDocAttend"></xform:address>
								</td>
							</tr>
						</table>
					</div>
				</div>
				<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom" data-dojo-props='fill:"grid"'>
				  	<li data-dojo-type="mui/back/BackButton"
				  		data-dojo-props="doBack:window.doback"></li>
				  	<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnSubmit " 
				  		data-dojo-props='colSize:2,href:"javascript:updateFeedback(\"update\",\"false\");",transition:"slide"'>提交</li>
				   	<li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:'mui mui-more'">
				    	<div data-dojo-type="mui/back/HomeButton"></div>
				   	</li>
				</ul>
			</div>
		</html:form>
		<script>
			require(["mui/form/ajax-form!kmImeetingMainFeedbackForm"]);
			require(['mui/dialog/Tip',"dojo/topic","dojo/dom-style","dojo/query","mui/util","dijit/registry","dojo/ready"],
					function(tip,topic,domStyle,query,util,registry,ready){
				//校验对象
				var validorObj=null;
				
				ready(function(){
					validorObj=registry.byId('scrollView');
					//自定义校验器1：当回复不参加时，留言为必填
					validorObj._validation.addValidator("validateReason","请填写不参加理由",function(v, e, o){
						var fdOperateType=query('[name="fdOperateType"]')[0];
						var reason=query('[name="fdReason"]')[0].value;
						if(fdOperateType && fdOperateType.value=="02" && !reason){
							return false;	
						}
						return true;
					});
					
					//自定义校验器2：当回复找人代参加时，实际参与人为必填
					validorObj._validation.addValidator("validateDocAttend","请选择实际参与人员",function(v, e, o){
						var fdOperateType=query('[name="fdOperateType"]')[0];
						if(fdOperateType && fdOperateType.value=="03" && !v){
							return false;	
						}
						return true;
					});
					
					//切换radio时校验
					topic.subscribe('mui/form/radio/change',function(){
						validorObj.validate();
					});
					
				});
				
				//提交
				window.updateFeedback=function(commitType,saveDraft){
					if(validorObj.validate()){
						var formObj = document.kmImeetingMainFeedbackForm;
						if ('save' == commitType) {
							Com_Submit(formObj, commitType, 'fdId');
						} else {
							Com_Submit(formObj, commitType);
						}
					}
				};
				
				window.doback=function(){
					window.open('${LUI_ContextPath}/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=view&fdId=${param.meetingId}','_self');
				};
				
				topic.subscribe('/mui/form/valueChanged',function(widget,args){
					if(widget.name=='fdOperateType'){
						if(args.value && args.value=="03"){
							domStyle.set(query('#docAttend')[0],'display','');
						}else{
							domStyle.set(query('#docAttend')[0],'display','none');
						}
						
					}
				});
				
				
				
				
			});
			
		</script>
	</template:replace>
</template:include>