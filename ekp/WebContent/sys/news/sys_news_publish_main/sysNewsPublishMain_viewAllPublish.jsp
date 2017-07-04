<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">	
	 	<list:listview >
			<ui:source type="AjaxJson">
				{"url":"/sys/news/sys_news_main/sysNewsMain.do?method=viewAllPublish&fdModelNameParam=${ param['fdModelNameParam'] }&fdModelIdParam=${ param['fdModelIdParam'] }&fdKeyParam=${ param['fdKeyParam'] }"}
			</ui:source>
			<list:colTable isDefault="true" layout="sys.ui.listview.listtable" rowHref="/sys/news/sys_news_main/sysNewsMain.do?method=view&fdId=!{fdId}" cfg-norecodeLayout="simple">
				<list:col-auto props=""></list:col-auto>
			</list:colTable>
			<ui:event topic="list.loaded">
				 seajs.use(['lui/jquery'],function($){
						try {
							if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
								window.frameElement.style.height = document.getElementsByTagName('div')[0].offsetHeight + 40 +"px";
							}
						} catch(e) {
						}
				   });
			</ui:event>
		</list:listview> 
	</template:replace>
</template:include>