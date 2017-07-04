<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld" prefix="template"%>

<c:set var="sysWfBusinessForm" value="${requestScope[param.formName]}" scope="page" />
<c:set var="lbpmProcessForm" value="${sysWfBusinessForm.sysWfBusinessForm.internalForm}" scope="page" />
<c:set var="docStatus" value="${empty param.docStatus ? sysWfBusinessForm.docStatus : param.docStatus}" scope="page" />

<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom" data-dojo-props='fill:"grid"'>
  <li data-dojo-type="mui/back/BackButton"></li>
  <c:if test="${sysWfBusinessForm.sysWfBusinessForm.fdIsHander == 'true' && lbpmProcessForm.fdIsError != 'true'}">
		<c:if test="${docStatus >= '20' && docStatus < '30' }">
		<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnSubmit " 
				data-dojo-props='colSize:2,moveTo:"lbpmView",icon1:"mui mui-approval"'>审批</li>
		</c:if>
		<c:if test="${docStatus < '20' && docStatus >= '10' && not empty param.editUrl }">
		<kmss:auth requestURL="${param.editUrl }">
		<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnSubmit" 
			data-dojo-props='colSize:2,href:"${param.editUrl }",icon1:"mui mui-create"'>编辑</li>
		</kmss:auth>
		</c:if>
  </c:if>
  <c:if test="${docStatus < '10' or sysWfBusinessForm.sysWfBusinessForm.fdIsHander != 'true' or lbpmProcessForm.fdIsError == 'true'}">
  <li data-dojo-type="mui/tabbar/TabBarButton" 
  		data-dojo-props='colSize:2'></li>
  </c:if>
   <li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:'mui mui-more'">
   		<template:block name="group">
    	<div data-dojo-type="mui/back/HomeButton"></div>
    	</template:block>
    </li>
</ul>