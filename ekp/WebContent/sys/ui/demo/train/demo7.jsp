<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<template:include ref="default.simple">


	<template:replace name="body">	
	<%-- 
	<ui:env config-contextPath="http://test.liyong.com:8080/ekp">
      <ui:panel toggle="false" layout="sys.ui.panel.default" height="240" scroll="false" id="p_4e5ea949d8337923e555">
       <portal:portlet title="环境变量测试">
        <ui:dataview format="sys.ui.classic">
         <ui:source ref="liyong.test1.source"></ui:source>
         <ui:render ref="sys.ui.classic.default" var-highlight="" var-showCreator="true" var-showCreated="true" var-showCate="true" var-cateSize="0" var-newDay="0" var-target="_blank"></ui:render>
        </ui:dataview>
       </portal:portlet>
      </ui:panel>  
      </ui:env>
      --%>
      <ui:tabpanel height="240" scroll="false" layout="sys.ui.tabpanel.default" id="p_5b57bfd176dad02b5055">
       <portal:portlet title="我的新闻" var-rowsize="6" var-myNews="myPublish" cfg-contextPath="http://test.liyong.com:8081/ekp">
        <ui:dataview format="sys.ui.listtable">
         <ui:source ref="server2://sys.news.main.MyNews.source" var-rowsize="6" var-myNews="myPublish"></ui:source>
         <ui:render ref="sys.ui.listtable.default" var-showTableTitle=""></ui:render>
        </ui:dataview>
        <ui:operation href="/sys/news/" name="{operation.more}" type="more" align="right"></ui:operation>
        <ui:operation href="/sys/news/sys_news_main/sysNewsMain.do?method=add" name="{operation.create}" type="create" align="right"></ui:operation>
       </portal:portlet>
      </ui:tabpanel> 
     </template:replace>
      
</template:include>