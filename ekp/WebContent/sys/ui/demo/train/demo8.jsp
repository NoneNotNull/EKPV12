<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/portal/sys_portal_page/page.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<template:include ref="default.simple">  
 <template:replace name="body">  
  
      <ui:panel toggle="false" layout="sys.ui.panel.default" height="240" scroll="false" id="p_b54ff4b66a8c37d35b16">
       <portal:portlet title="自定义页面" var-fdId="1477ae618d76923da1a174b494dbc636">
        <ui:dataview format="sys.ui.html">
         <ui:source ref="sys.portal.html.source" var-fdId="1477ae618d76923da1a174b494dbc636"></ui:source>
         <ui:render ref="sys.ui.html.default"></ui:render>
        </ui:dataview>
       </portal:portlet>
      </ui:panel>  
 
 </template:replace>  
</template:include>