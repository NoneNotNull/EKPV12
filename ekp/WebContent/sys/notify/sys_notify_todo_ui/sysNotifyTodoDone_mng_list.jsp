<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysNotifyTodoDoneInfo" list="${queryPage.list }" varIndex="status">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="index">
		  ${status+1}
		</list:data-column>
		<list:data-column col="fdModelName" title="" escape="false">
			${sysNotifyTodoDoneInfo.todo.fdModelName}
		</list:data-column>
		<list:data-column headerStyle="width:80px" col="tr_href" title="" escape="false">
			<c:set var="_fdLink" value="${sysNotifyTodoDoneInfo.todo.fdLink}" />
			<c:set var="_contextPath" value="${KMSS_Parameter_ContextPath}" />
			<%
				String fdLink = (String)pageContext.getAttribute("_fdLink");
				//如：/ekp/或/
				String contextPath = (String)pageContext.getAttribute("_contextPath");
				if(fdLink!=null && fdLink.startsWith("/")){
					fdLink = contextPath+fdLink.substring(1);
				}
				pageContext.setAttribute("_tr_href",fdLink);
			%>
		    <c:out value="${_tr_href}" escapeXml="false"/>
		</list:data-column>
		<list:data-column col="todo.subject4View" escape="false" title="${ lfn:message('sys-notify:sysNotifyTodo.fdSubject') }" style="text-align:left">
			<span style="padding-left:16px;vertical-align: middle;" class="lui_notify_content_${sysNotifyTodoDoneInfo.todo.fdType}"></span>
			<c:choose>
				<c:when test="${sysNotifyTodoDoneInfo.todo.fdLevel==1 && sysNotifyTodoDoneInfo.todo.fdType!=3 }">
					<span title="<c:out value='${sysNotifyTodoDoneInfo.todo.subject4View}' />">
		      			<span class="lui_notify_level">${lfn:message('sys-notify:sysNotifyTodo.level.title.1')}</span><c:out value="${sysNotifyTodoDoneInfo.todo.subject4View}"/>
		    		</span>
				</c:when>
				<c:when test="${sysNotifyTodoDoneInfo.todo.fdLevel==2 && sysNotifyTodoDoneInfo.todo.fdType!=3}">
					<span title="<c:out value='${sysNotifyTodoDoneInfo.todo.subject4View}' />">
		      			<span class="lui_notify_level">${lfn:message('sys-notify:sysNotifyTodo.level.title.2')}</span><c:out value="${sysNotifyTodoDoneInfo.todo.subject4View}"/>
		    		</span>
				</c:when>
				<c:when test="${sysNotifyTodoDoneInfo.todo.fdType==3}">
					<span title="<c:out value='${sysNotifyTodoDoneInfo.todo.subject4View}' />">
		      			<span class="lui_notify_pending"></span><c:out value="${sysNotifyTodoDoneInfo.todo.subject4View}"/>
		    		</span>  
				</c:when>
				<c:otherwise>
					<span title="<c:out value='${sysNotifyTodoDoneInfo.todo.subject4View}' />">
		      			<c:out value="${sysNotifyTodoDoneInfo.todo.subject4View}"/>
		    		</span>  
				</c:otherwise>
			</c:choose>
		</list:data-column>
		<list:data-column headerStyle="width:60px" col="todo.fdType" title="${ lfn:message('sys-notify:sysNotifyTodo.fdType') }">
		   <sunbor:enumsShow value="${sysNotifyTodoDoneInfo.todo.fdType}" enumsType="sys_todo_cate" bundle="sys-notify"/>
		</list:data-column> 
		<c:if test="${showApp==1}">
			<list:data-column headerStyle="width:60px" col="appName" title="${ lfn:message('sys-notify:sysNotifyTodo.fdAppName') }">
			    <c:set var="appName" value="${sysNotifyTodoDoneInfo.todo.fdAppName}"/>
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
		<list:data-column headerStyle="width:120px" col="todo.fdCreateTime" title="${ lfn:message('sys-notify:sysNotifyTodo.fdCreateDate') }">
		    <kmss:showDate value="${sysNotifyTodoDoneInfo.todo.fdCreateTime}" type="datetime" />
		</list:data-column>
		<list:data-column headerStyle="width:120px" col="fdFinishTime" title="${ lfn:message('sys-notify:sysNotifyTodo.finishDate') }">
		    <kmss:showDate value="${sysNotifyTodoDoneInfo.fdFinishTime}" type="datetime" />
		</list:data-column>
		<list:data-column headerStyle="100px" col="docCreator.fdName" title="${ lfn:message('sys-notify:sysNotifyTodo.docCreatorName')}" style="width:10%"  escape="false">
			<c:out value="${sysNotifyTodoDoneInfo.todo.docCreator.fdName}"/>
		</list:data-column>
		<list:data-column headerStyle="100px" col="modelNameText" title="${ lfn:message('sys-notify:sysNotifyTodo.moduleName')}" style="width:10%"  escape="false">
			<c:out value="${sysNotifyTodoDoneInfo.todo.modelNameText}"/>
		</list:data-column>
		<c:forEach var="map" items="${sysNotifyTodoDoneInfo.todo.extendContents}">
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


