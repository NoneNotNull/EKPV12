<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysNewsMain" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column >
	    <!-- 主题-->	
		<list:data-column  col="docSubject" title="${ lfn:message('sys-news:sysNewsMain.docSubject') }" escape="false" style="text-align:left">
		          <a href="${LUI_ContextPath}/sys/news/sys_news_main/sysNewsMain.do?method=view&fdId=${sysNewsMain.fdId}">
		            <span class="com_subject"><c:out value="${sysNewsMain.docSubject}"/></span>
		          </a>  
		</list:data-column>
		 <!-- 类型-->
		<list:data-column headerStyle="width:80px" property="fdTemplate.fdName"  title="${ lfn:message('sys-news:sysNewsMain.fdTemplate') }">
		</list:data-column>
		 <!-- 点击率-->
	    <list:data-column headerStyle="width:60px"  col="docHits" title="${ lfn:message('sys-news:sysNewsMain.docHits')}" escape="false">
		             <font class="com_number"> <c:out value="${sysNewsMain.docReadCount}"/></font>
		</list:data-column>
		  <!-- 发布时间--> 
		<list:data-column headerStyle="width:100px"  col="docPublishTime" title="${ lfn:message('sys-news:sysNewsMain.docPublishTime') }">
			    <kmss:showDate value="${sysNewsMain.docPublishTime}" type="date"></kmss:showDate>
		</list:data-column> 
  </list:data-columns>
</list:data>