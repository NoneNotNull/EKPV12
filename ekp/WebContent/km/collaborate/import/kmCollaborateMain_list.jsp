<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
		<script type="text/javascript">
			seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog , topic) {
				//删除
				window.del=function(event,url){
					//阻止事件冒泡
					var e=(event)?event:window.event;  
					 if (window.event){  
					 	e.cancelBubble=true;  
					 }else {  
						e.stopPropagation();  
					 }
					dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(value){
						if(value==true){
							window._load = dialog.loading();
							$.get(url,function(data){
								if(window._load!=null)
									window._load.hide();
								if(data!=null && data.status==true){
									topic.publish("list.refresh");
									dialog.success('<bean:message key="return.optSuccess" />');
								}else{
									dialog.failure('<bean:message key="return.optFailure" />');
								}
							},'json');
						}
					});
				};
			});
	 	</script>
		<table width="100%"> 
			<tr>
				<td>
				<list:listview>
					<ui:source type="AjaxJson">
						{"url":"/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=list&forward=listUi&fdModelId=${param['fdModelId']}&fdModelName=${param['fdModelName']}&include=enter&rowsize=10"}
					</ui:source>
					<list:colTable isDefault="true" layout="sys.ui.listview.listtable" sort="false"  rowHref="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=view&fdId=!{fdId}" cfg-norecodeLayout="simple">
							<list:col-auto props="fdIsPriority;fdHasAttachment"></list:col-auto>
							<list:col-serial title="${ lfn:message('page.serial')}" headerStyle="width:5%"></list:col-serial>
							<list:col-auto props="docSubject;fdCategory.fdName;docCreator.fdName;docReadCount;docReplyCount;docCreateTime;operate"></list:col-auto>
					</list:colTable>
					<ui:event topic="list.loaded">  
						seajs.use(['lui/jquery'],function($){
							if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
								window.frameElement.style.height =  $(document.body).height() + "px";
							}
						});
					</ui:event>					
				</list:listview>
				<div style="height: 15px;"></div>
				<list:paging layout="sys.ui.paging.simple"></list:paging>
				</td>
			</tr>
		</table>
	</template:replace>
</template:include>