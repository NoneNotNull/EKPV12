<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysNewsMain" list="${queryPage.list }" varIndex="status">
		<list:data-column property="fdId">
		</list:data-column >
		<list:data-column col="index">
		      ${status+1}
		</list:data-column >
	    <!-- 主题-->	
		<list:data-column  col="docSubject" title="${ lfn:message('sys-news:sysNewsMain.docSubject') }" escape="false" style="text-align:left">
		           <span class="com_subject"><c:out value="${sysNewsMain.docSubject}"/></span>
		</list:data-column>
		
		  <!-- 主题--摘要视图-->	
		<list:data-column col="docSubject_row" title="${ lfn:message('sys-news:sysNewsMain.docSubject') }" escape="false" style="text-align:left">
		           <span class="textEllipsis com_subject" title="${sysNewsMain.docSubject}">
		             <c:if test="${sysNewsMain.fdIsTop==true}">
		            	 <img src="${LUI_ContextPath}/sys/news/images/zding.gif" border=0 title="<bean:message key="news.fdIsTop.true" bundle="sys-news"/>" />
		             </c:if>    
		             <c:out value="${sysNewsMain.docSubject}"/>
		           </span>
		</list:data-column>
		 <!-- 类型-->
		<list:data-column headerStyle="width:80px" property="fdTemplate.fdName"  title="${ lfn:message('sys-news:sysNewsMain.fdTemplate') }">
		</list:data-column>
	     <!-- 重要度-->
		<list:data-column headerStyle="width:100px" col="fdImportance"  title="${ lfn:message('sys-news:sysNewsPublishMain.fdImportance') }">
		     <sunbor:enumsShow value="${sysNewsMain.fdImportance}" enumsType="sysNewsMain_fdImportance" />
		</list:data-column>
		 <!-- 创建者-->
		<list:data-column headerStyle="width:80px" col="docCreator.fdName" title="${ lfn:message('sys-news:sysNewsMain.docCreatorId') }" escape="false">
		        <ui:person personId="${sysNewsMain.docCreator.fdId}" personName="${sysNewsMain.docCreator.fdName}"></ui:person>
		</list:data-column>
		 <!-- 创建时间-->
		 <list:data-column headerStyle="width:100px" col="docCreateTime" title="${ lfn:message('sys-news:sysNewsMain.docCreateTime') }">
		        <kmss:showDate value="${sysNewsMain.docPublishTime}" type="date"></kmss:showDate>
	      </list:data-column>
		  <!-- 发布时间-->   	
		<list:data-column headerStyle="width:100px"  col="docPublishTime" title="${ lfn:message('sys-news:sysNewsMain.docPublishTime') }">
		<c:if test="${not empty sysNewsMain.docPublishTime }">
		        <kmss:showDate value="${sysNewsMain.docPublishTime}" type="date"></kmss:showDate>
		  </c:if>
		</list:data-column>
			  <!-- 发布时间row-->   	
		<list:data-column headerStyle="width:80px"  col="docPublishTime_row" title="${ lfn:message('sys-news:sysNewsMain.docPublishTime') }">
		<c:if test="${not empty sysNewsMain.docPublishTime }">
		         ${ lfn:message('sys-news:sysNewsMain.docPublishTime') }：<kmss:showDate value="${sysNewsMain.docPublishTime}" type="date"></kmss:showDate>
		</c:if>
		</list:data-column>
		
			  <!--修改时间-->   	
		<list:data-column headerStyle="width:80px"  col="docAlterTime" title="${ lfn:message('sys-news:sysNewsMain.fdLastModifiedTime') }">
		<c:if test="${not empty sysNewsMain.docAlterTime }">
		       <kmss:showDate value="${sysNewsMain.docAlterTime}" type="date"></kmss:showDate>
		</c:if>
		</list:data-column>
	     <!-- 点击率-->	
	<c:if test="${docStatus=='30' ||docStatus=='40'}">
		<list:data-column headerStyle="width:60px"  col="docHits" title="${ lfn:message('sys-news:sysNewsMain.docHits')}" escape="false">
		             <font class="com_number"> <c:out value="${sysNewsMain.docReadCount}"/></font>
		</list:data-column>
      </c:if>
	       <!-- 是否置顶-->
	<c:if test="${docStatus=='30'||top=='true'}">			
	    <list:data-column headerStyle="width:60px" col="fdTopDays" escape="false" title="${ lfn:message('sys-news:sysNewsMain.fdIsTop') }">       
		       <c:if test="${sysNewsMain.fdIsTop==true}">
		           <img src="${LUI_ContextPath}/sys/news/images/zding.gif" border=0 title="<bean:message key="news.fdIsTop.true" bundle="sys-news"/>" />
		       </c:if>
		</list:data-column>		
	</c:if> 
	
	
	<!-- 摘要-->
	<list:data-column headerStyle="width:80px"  col="fdDescription_row" title="${ lfn:message('sys-news:sysNewsMain.fdDescription')}" escape="false">
	                <c:out value="${sysNewsMain.fdDescription}"/>
	</list:data-column>
		
    <!-- 部门-->
	<list:data-column headerStyle="width:80px"  property="fdDepartment.fdName" title="${ lfn:message('sys-news:sysNewsMain.fdDepartmentIdBy')}">
	</list:data-column>
	<!-- 作者-->	
	<list:data-column headerStyle="width:80px" col="fdWriterName_row"  escape="false" title="${ lfn:message('sys-news:sysNewsMain.fdAuthorId')}">
	           <c:if test="${sysNewsMain.fdAuthor==null}">
	                 <c:out value="${sysNewsMain.fdWriter}"/>
	           </c:if>
	            <c:if test="${sysNewsMain.fdAuthor!=null}">
	                 <ui:person personId="${sysNewsMain.fdAuthor.fdId}" personName="${sysNewsMain.fdAuthor.fdName}"></ui:person>
	           </c:if>
	</list:data-column>
	
	
		
     <!-- 点击率row-->	
		<list:data-column headerStyle="width:50px"  col="docHits_row" title="${ lfn:message('sys-news:sysNewsMain.docHits')}" escape="false">
		        <c:if test="${not empty sysNewsMain.docReadCount}">
		                 ${lfn:message('sys-news:sysNewsMain.docHits') }：<font class="com_number"> <c:out value="${sysNewsMain.docReadCount}"/></font>
		         </c:if>
		</list:data-column>
	<!-- 标签-->	
	<list:data-column headerStyle="width:80px"  col="sysTagMain_row" title="${ lfn:message('sys-news:sysNewsMain.label')}" escape="false">
	            <c:if test="${not empty tagJson[sysNewsMain.fdId]}">
	              ${lfn:message('sys-news:sysNewsMain.label') }：${tagJson[sysNewsMain.fdId]}
	             </c:if>
	</list:data-column>


	</list:data-columns>
	
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>