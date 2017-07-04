<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmCollaborateMain" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column >
		<list:data-column col="method" escape="false">
	       <c:choose> 	
		      <c:when test="${kmCollaborateMain.docStatus=='10'}">
		           <c:out value="viewDefault"/>
		      </c:when>
		       <c:otherwise>
		          <c:out value="view"/>
		      </c:otherwise>
		   </c:choose> 
		</list:data-column >
			<!--是否已看-->
		<list:data-column headerStyle="width:1px" col="fdIsLook"  escape="false" title="<image src='${KMSS_Parameter_ContextPath}km/collaborate/img/yj_yd.png'/>" style="text-align:left">
		             <c:if test="${isLook[kmCollaborateMain.fdId]==true}" >
					   			 <img  src="${KMSS_Parameter_ContextPath}km/collaborate/img/yj_yd.png" title="${ lfn:message('km-collaborate:kmCollaborate.jsp.yudu') }">
					  </c:if>
				     <c:if test="${isLook[kmCollaborateMain.fdId]==false}" >
					   			 <img  src="${KMSS_Parameter_ContextPath}km/collaborate/img/yj_wd.png" title="${ lfn:message('km-collaborate:kmCollaborate.jsp.weidu') }">
					  </c:if>
		</list:data-column>
		<!--优先-->
		<list:data-column headerStyle="width:1px" col="fdIsPriority"  escape="false" style="text-align:left;width:1px" >
		           <c:if test="${kmCollaborateMain.fdIsPriority}">
					   <img  src="${KMSS_Parameter_ContextPath}km/collaborate/img/gt_zy.png" title="${ lfn:message('km-collaborate:kmCollaborateMain.highPriority') }">
				   </c:if>
		</list:data-column>
	     <!--含有附件-->
		<list:data-column headerStyle="width:1px" col="fdHasAttachment"  escape="false" style="text-align:left;width:1px">
		         <c:if test="${kmCollaborateMain.fdHasAttachment}">
				       <img   src="${KMSS_Parameter_ContextPath}km/collaborate/img/fjh.png" title="${ lfn:message('km-collaborate:kmCollaborateMain.HasAttachment') }">
				   </c:if>
		</list:data-column>
	
		<!--标题-->
		<list:data-column  col="docSubject" escape="false"  title="${ lfn:message('km-collaborate:kmCollaborateMain.docSubject') }" style="text-align:left">
		     <c:if test="${isLook[kmCollaborateMain.fdId]==false}" >
		       	<span  class="com_subject" style="font-weight:bold">
		     </c:if> 
		      <c:if test="${isLook[kmCollaborateMain.fdId]==true||isLook[kmCollaborateMain.fdId]==null}" >
		        <span  class="com_subject">
		     </c:if> 	
		          <c:if test="${kmCollaborateMain.docStatus==40 }">
					  <img src="${KMSS_Parameter_ContextPath}km/collaborate/img/end.gif" border="0" title="${ lfn:message('km-collaborate:kmCollaborateMain.end') }">
				    </c:if>
				  <c:out value="${kmCollaborateMain.docSubject}" /></span>
		</list:data-column>
	    <!--沟通类型-->
		<list:data-column headerStyle="width:120px" col="fdCategory.fdName"  escape="false" title="${ lfn:message('km-collaborate:table.kmCollaborateCategory.tilteKind') }">
	              <c:if test="${isLook[kmCollaborateMain.fdId]==false}" >
			       	<span style="font-weight:bold">
			      </c:if>    
			      <c:if test="${isLook[kmCollaborateMain.fdId]==true}" >
			       	<span>
			      </c:if>   
	                  <c:out value="${kmCollaborateMain.fdCategory.fdName}"/>
	               </span>  
		</list:data-column>
	     <!--创建者-->
		<list:data-column headerStyle="width:80px" col="docCreator.fdName"  title="${ lfn:message('km-collaborate:kmCollaborateMain.docCreator') }" escape="false">
		          <c:if test="${isLook[kmCollaborateMain.fdId]==false}" >
			       	<span style="font-weight:bold">
			      </c:if>    
			      <c:if test="${isLook[kmCollaborateMain.fdId]==true}" >
			       	<span>
			      </c:if>  
		           <ui:person personId="${kmCollaborateMain.docCreator.fdId}" personName="${kmCollaborateMain.docCreator.fdName}"></ui:person>
		            </span>  
		</list:data-column>
		<!--点击率-->
		<list:data-column headerStyle="width:40px"  col="docReadCount" title="${ lfn:message('km-collaborate:kmCollaborateMain.docReadCount') }" style="text-align:center" escape="false">
	            <c:if test="${isLook[kmCollaborateMain.fdId]==false}" >
			       	<span style="font-weight:bold">
			      </c:if>    
			      <c:if test="${isLook[kmCollaborateMain.fdId]==true}" >
			       	<span>
			      </c:if>	        
		        	 <c:if test="${kmCollaborateMain.docReadCount==null}">
					     0
					</c:if>
					<c:out value="${kmCollaborateMain.docReadCount}" />
					 </span>  
		</list:data-column>
		<!--回复率-->	
		<list:data-column headerStyle="width:40px"  col="docReplyCount" title="${ lfn:message('km-collaborate:kmCollaborateMain.docReplyCount') }" style="text-align:center" escape="false">
		       <c:if test="${isLook[kmCollaborateMain.fdId]==false}" >
			       	<span style="font-weight:bold">
			      </c:if>    
			      <c:if test="${isLook[kmCollaborateMain.fdId]==true}" >
			       	<span>
			      </c:if>	
		     	     <c:if test="${kmCollaborateMain.docReplyCount==null}">
			             0
			    	</c:if>
					<c:out value="${kmCollaborateMain.docReplyCount}" />
					 </span>  
		</list:data-column>
		<!--创建时间-->	
			<list:data-column headerStyle="width:100px" col="docCreateTime"  title="${ lfn:message('km-collaborate:kmCollaborateMain.docCreateTime') }" escape="false">
			      <c:if test="${isLook[kmCollaborateMain.fdId]==false}" >
			       	<span style="font-weight:bold">
			      </c:if>    
			      <c:if test="${isLook[kmCollaborateMain.fdId]==true}" >
			       	<span>
			      </c:if>    
			               <kmss:showDate value="${kmCollaborateMain.docCreateTime}" type="date"></kmss:showDate>
			       </span>     
		</list:data-column>
		<!--文档状态-->
		<list:data-column headerStyle="width:60px" col="docStatus" title="${ lfn:message('km-collaborate:kmCollaborateMain.docStatus') }" escape="false">
		  <xform:select property="docStatus" value="${kmCollaborateMain.docStatus}" showStatus="view">
		      	<xform:enumsDataSource enumsType="km_collaborate_main_status" />
		   </xform:select>
		</list:data-column>
		<!--关注-->	
		<list:data-column headerStyle="width:30px" col="attend"  escape="false"  title="${ lfn:message('km-collaborate:kmCollaborateMain.attention') }">
			           <c:if test="${isFollow[kmCollaborateMain.fdId]=='false'}" >
					          <img  alt="<bean:message key='kmCollaborate.jsp.signToAtt' bundle='km-collaborate' />" src="${KMSS_Parameter_ContextPath}km/collaborate/img/gz_n.png" title="${ lfn:message('km-collaborate:kmCollaborateMain.attention') }" onclick="ajaxAtten(event,'${kmCollaborateMain.fdId}')">
					    </c:if>
					    <c:if test="${isFollow[kmCollaborateMain.fdId]=='true'}" >
					          <img alt="<bean:message key='kmCollaborate.jsp.calcelAtt' bundle='km-collaborate' />" src="${KMSS_Parameter_ContextPath}km/collaborate/img/gz_y.png" title="${ lfn:message('km-collaborate:kmCollaborate.jsp.calcelAtt') }" onclick="ajaxAtten(event,'${kmCollaborateMain.fdId}')">
					    </c:if>
		</list:data-column>
    </list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>