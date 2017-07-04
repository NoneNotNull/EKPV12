<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysNotifyTodo" list="${queryPage.list }" varIndex="status">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column property="fdModelName">
		</list:data-column>
		<list:data-column col="index">
		  ${status+1}
		</list:data-column>
		<list:data-column col="fdSubject" escape="false" title="${ lfn:message('sys-notify:sysNotifyTodo.fdSubject') }" style="text-align:left">
			<span style="padding-left:16px;vertical-align: middle;" class="lui_notify_content_${sysNotifyTodo.fdType}"></span>
			<c:choose>
				<c:when test="${sysNotifyTodo.fdLevel==1 && sysNotifyTodo.fdType!=3 }">
					<span title="<c:out value='${sysNotifyTodo.fdSubject}' />">
		      			<span style="color:red">${lfn:message('sys-notify:sysNotifyTodo.level.title.1')}</span><c:out value="${sysNotifyTodo.fdSubject}"/>
		    		</span>
				</c:when>
				<c:when test="${sysNotifyTodo.fdLevel==2 && sysNotifyTodo.fdType!=3}">
					<span title="<c:out value='${sysNotifyTodo.fdSubject}' />">
		      			<span style="color:red">${lfn:message('sys-notify:sysNotifyTodo.level.title.2')}</span><c:out value="${sysNotifyTodo.fdSubject}"/>
		    		</span>
				</c:when>
				<c:when test="${sysNotifyTodo.fdType==3 }">
					<span title="<c:out value='${sysNotifyTodo.fdSubject}' />">
		      			<span class="lui_notify_pending" style="margin-bottom:2px;"></span><c:out value="${sysNotifyTodo.fdSubject}"/>
		    		</span>  
				</c:when>
				<c:otherwise>
					<span title="<c:out value='${sysNotifyTodo.fdSubject}' />">
		      			<c:out value="${sysNotifyTodo.fdSubject}"/>
		    		</span>  
				</c:otherwise>
			</c:choose>
		</list:data-column>
		<list:data-column property="fdLevel" title="${ lfn:message('sys-notify:sysNotifyTodo.fdLevel') }" style="text-align:left">
		</list:data-column>
		<list:data-column headerStyle="width:60px" col="fdType" title="${ lfn:message('sys-notify:sysNotifyTodo.fdType') }">
		   <sunbor:enumsShow value="${sysNotifyTodo.fdType}" enumsType="sys_todo_cate" bundle="sys-notify"/>
		</list:data-column> 
		<c:if test="${showApp==1}">
		<list:data-column headerStyle="width:60px" col="appName" title="${ lfn:message('sys-notify:sysNotifyTodo.fdAppName') }">
		    <c:set var="appName" value="${sysNotifyTodo.fdAppName}"/>
			<c:choose>
				<c:when test="${appName==null || appName=='' }">
					<bean:message bundle="sys-notify" key="sysNotifyTodo.todo.local.application.ekp.notify" />
				</c:when>
				<c:otherwise>
					<c:out value="${appName}"/>
				</c:otherwise>
			</c:choose>
		</list:data-column> 
		</c:if>
		<list:data-column headerStyle="width:120px" col="fdCreateTime" title="${ lfn:message('sys-notify:sysNotifyTodo.fdCreateDate') }">
		    <kmss:showDate value="${sysNotifyTodo.fdCreateTime}" type="datetime" />
		</list:data-column>
		<list:data-column headerStyle="100px" col="docCreator.fdName" title="${ lfn:message('sys-notify:sysNotifyTodo.docCreatorName')}" style="width:10%"  escape="false">
			<c:out value="${sysNotifyTodo.docCreator.fdName}"/>
		</list:data-column>
		<list:data-column headerStyle="100px" col="modelNameText" title="${ lfn:message('sys-notify:sysNotifyTodo.moduleName')}" style="width:10%"  escape="false">
			<c:out value="${sysNotifyTodo.modelNameText}"/>
		</list:data-column>
		<c:forEach var="map" items="${sysNotifyTodo.extendContents}">
			<list:data-column headerStyle="100px" col="${map['key'] }.value" title="${map['titleMsgKey']}" style="width:10%"  escape="false">
				<c:out value="${map['titleMsgValue']}"/>
			</list:data-column>
			<list:data-column headerStyle="100px" col="${map['key'] }.key" title="${map['titleMsgKey']}" style="width:10%"  escape="false">
				<c:out value="${map['titleMsgKey']}"/>
			</list:data-column>
		</c:forEach>
		
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>


