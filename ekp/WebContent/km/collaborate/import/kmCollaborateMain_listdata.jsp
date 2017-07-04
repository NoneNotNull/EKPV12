<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmCollaborateMain" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column >
		<!--优先-->
		<list:data-column  col="fdIsPriority"  escape="false" title="<image src='${KMSS_Parameter_ContextPath}km/collaborate/img/gt.png'/>" style="width:2px;text-align:center">
		           <c:if test="${kmCollaborateMain.fdIsPriority }">
					   <img  src="${KMSS_Parameter_ContextPath}km/collaborate/img/gt_zy.png" title="${ lfn:message('km-collaborate:kmCollaborateMain.highPriority') }">
				   </c:if>
		</list:data-column>
	     <!--含有附件-->
		<list:data-column  col="fdHasAttachment"   title="<image src='${KMSS_Parameter_ContextPath}km/collaborate/img/fjh.png'/>" escape="false" style="width:2px;text-align:center" >
		         <c:if test="${kmCollaborateMain.fdHasAttachment}">
				       <img   src="${KMSS_Parameter_ContextPath}km/collaborate/img/fjh.png" title="${ lfn:message('km-collaborate:kmCollaborateMain.HasAttachment') }">
				   </c:if>
		</list:data-column>
		<!--标题-->
		<list:data-column  col="docSubject" escape="false"  title="${ lfn:message('km-collaborate:kmCollaborateMain.docSubject') }" style="text-align:left">
		       	<span  class="com_subject textEllipsis" title="${kmCollaborateMain.docSubject}">
		          <c:if test="${kmCollaborateMain.docStatus==40 }">
					  <img src="${KMSS_Parameter_ContextPath}km/collaborate/img/end.gif" border="0" title="${ lfn:message('km-collaborate:kmCollaborateMain.end') }">
				    </c:if>
				  <c:out value="${kmCollaborateMain.docSubject}" /></span>
		</list:data-column>
	    <!--沟通类型-->
		<list:data-column property="fdCategory.fdName" style="width:120px"  title="${ lfn:message('km-collaborate:table.kmCollaborateCategory.tilteKind') }">
		</list:data-column>
	     <!--创建者-->
		<list:data-column headerStyle="width:80px" col="docCreator.fdName"  title="${ lfn:message('km-collaborate:kmCollaborateMain.docCreator') }" escape="false">
		           <ui:person personId="${kmCollaborateMain.docCreator.fdId}" personName="${kmCollaborateMain.docCreator.fdName}"></ui:person>
		</list:data-column>
		<!--点击率-->
		<list:data-column headerStyle="width:60px"  col="docReadCount" title="${ lfn:message('km-collaborate:kmCollaborateMain.docReadCount') }" style="text-align:center" escape="false">
		        	 <c:if test="${kmCollaborateMain.docReadCount==null}">
					 <span class="com_number">0</span>
					</c:if>
					<span class="com_number"><c:out value="${kmCollaborateMain.docReadCount}" /></span>
		</list:data-column>
		<!--回复率-->	
		<list:data-column headerStyle="width:60px"  col="docReplyCount" title="${ lfn:message('km-collaborate:kmCollaborateMain.docReplyCount') }" style="text-align:center" escape="false">
		     	     <c:if test="${kmCollaborateMain.docReplyCount==null}">
			     	<span class="com_number">0</span>
			    	</c:if>
					 <span class="com_number"><c:out value="${kmCollaborateMain.docReplyCount}" /></span>
		</list:data-column>
		<!--创建时间-->	
			<list:data-column headerStyle="width:80px" col="docCreateTime"  title="${ lfn:message('km-collaborate:kmCollaborateMain.docCreateTime') }" escape="false">
			               <kmss:showDate value="${kmCollaborateMain.docCreateTime}" type="date"></kmss:showDate>
		</list:data-column>
		<!--操作-->	
		<list:data-column headerStyle="width:60px;" col="operate"  escape="false" title="${ lfn:message('km-collaborate:kmCollaborateLogs.operate')}">
			<kmss:authShow roles="ROLE_KMCOLLABORATEMAIN_DELETE">
				<a class="com_btn_link" onclick="del(event,'<c:url value="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=delete&fdId=${kmCollaborateMain.fdId}"/>');"><bean:message key="button.delete"/></a>
			</kmss:authShow>
		</list:data-column>
    </list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>