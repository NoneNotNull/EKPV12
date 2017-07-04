<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
	
	Menu 样例 Demo <br>
	<ui:menu layout="sys.ui.menu.nav" >
		<ui:menu-item text="menu1"></ui:menu-item>
		<ui:menu-item text="menu2"></ui:menu-item>
		<ui:menu-popup text="popup">
			sdfsdf
		</ui:menu-popup>
		<ui:menu-source href="#?categoryId=!{value}">
				<ui:source type="AjaxJson">
					{"url":"/sys/simplecategory/criteria/sysSimpleCategoryCriteria.do?method=path&modelName=com.landray.kmss.km.doc.model.KmDocTemplate&categoryId=140cdb1e42780ead46cecde43d5a5572&currId="} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>	
	</template:replace>
</template:include>