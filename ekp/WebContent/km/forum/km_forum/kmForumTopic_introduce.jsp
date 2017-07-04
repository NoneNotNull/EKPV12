<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
    <template:replace name="head">	
	    <script>
	        Com_IncludeFile("dialog.js");
	    </script>
    	<script>
			seajs.use([ 'lui/jquery','lui/parser','lui/dialog'],function($,parser,dialog) {
				//提交表单
				window.submitForm = function(){
					var validateFlag = true;
					var fdNotifyType = document.getElementsByName("fdNotifyType")[0];
					if(fdNotifyType.value == null || fdNotifyType.value == ""){
						dialog.alert('<bean:message key="kmForumTopic.introduce.message.error.fdNotifyType" bundle="km-forum" />');
						validateFlag = false;
						return;
					 }
					var fdTargetIds = document.getElementsByName("fdTargetIds")[0];
					if(fdTargetIds.value == "" ){
						dialog.alert('<bean:message key="kmForumTopic.introduce.message.error.fdTargetIds" bundle="km-forum" />');
						validateFlag = false;
						return;
					}
					if(validateFlag){
						var url ="${LUI_ContextPath}/km/forum/km_forum/kmForumTopic.do?method=updateIntroduce";
						var fdId = '${param.fdId}';
						var data={fdId:fdId,fdTargetIds:fdTargetIds.value,fdNotifyType:fdNotifyType.value};
						LUI.$.ajax({
							url: url,
							type: 'post',
							dataType: 'json',
							async: false,
							data: data,
							success: function(data, textStatus, xhr) {
								if(data==true){
									dialog.success('<bean:message key="return.optSuccess" />');
									setTimeout(function (){
										 $dialog.hide("true");
									}, 1500);
								}else{
									dialog.failure('<bean:message key="return.optFailure" />');
								}
							}
						  });
					}
				};
			});
		</script>
    </template:replace>
   <template:replace name="content">	
		<html:form action="/km/forum/km_forum/kmForumTopic.do">
		<p class="txttitle"><bean:message bundle="km-forum" key="kmForumTopic.introduce.title"/></p>
		<center>
			<table class="tb_normal" width=95%>
				<html:hidden property="fdId"/>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="km-forum" key="kmForumTopic.docSubject"/>
					</td><td width=85%>
						${kmForumTopicForm.docSubject }
						<html:hidden property="docSubject" />
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="km-forum" key="kmForumTopic.introduce.fdNotifyType"/>
					</td><td width=85%>
						<kmss:editNotifyType property="fdNotifyType"/>
						<span class="txtstrong">*</span>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="km-forum" key="kmForumTopic.introduce.fdTargetIds"/>
					</td><td width=85%>
					    <xform:address style="width:96%;height:80px" textarea="true" showStatus="edit"  propertyId="fdTargetIds" propertyName="fdTargetNames" orgType="ORG_TYPE_ALL" mulSelect="true"></xform:address>
				        <span class="txtstrong">*</span>
					</td>
				</tr>
			</table>
		<div style="padding-top: 5px">
			<ui:button style="width:60px" text="${lfn:message('button.update') }"onclick="submitForm();"></ui:button>
	        <ui:button style="padding-left:10px;width:60px"  text="${lfn:message('button.close') }" styleClass="lui_toolbar_btn_gray" onclick="Com_CloseWindow();"></ui:button>
		</div>
		 </center>
		<html:hidden property="method_GET"/>
	  </html:form>
    </template:replace>
</template:include>