<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="lbpmProcess" list="${queryPage.list }"
		varIndex="status">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column property="fdModelName">
		</list:data-column>
		<list:data-column col="index">
		     ${status+1}
		</list:data-column>
		<!--标题-->
		<list:data-column col="subject"
			title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.docSubject') }"
			escape="false" style="text-align:left;min-width:200px">
			<c:if test="${not empty subjectMap[lbpmProcess.fdId]}">
	             <span class="com_subject">${subjectMap[lbpmProcess.fdId]}</span>
	        </c:if>
		</list:data-column>
		<!--创建人-->
		<list:data-column headerStyle="width:8%" property="fdCreator.fdName"
			title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.docAuthor') }">
		</list:data-column>
		<!--创建时间-->
		<list:data-column headerStyle="width:130px" property="fdCreateTime"
			title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.docAuthorTime') }">
		</list:data-column>
		<!--状态-->
		<c:if test="${param.method == 'getRecentHandle' || param.method == 'getInvalidHandler' || lbpmProcess.fdStatus!='21'}">
			<list:data-column headerStyle="width:6%" col="fdStatus"
				title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.status') }"
				escape="false">
				<c:if test="${lbpmProcess.fdStatus=='20'}">
					${ lfn:message('sys-lbpmmonitor:status.activated') }
				</c:if>
				<c:if test="${lbpmProcess.fdStatus=='21'}">
					${ lfn:message('sys-lbpmmonitor:status.error') }
				</c:if>
				<c:if test="${lbpmProcess.fdStatus=='30'}">
					${ lfn:message('sys-lbpmmonitor:status.completed') }
				</c:if>
				<c:if test="${lbpmProcess.fdStatus=='00'}">
					${ lfn:message('sys-lbpmmonitor:status.discard') }
				</c:if>
				<c:if test="${lbpmProcess.fdStatus=='40'}">
					${ lfn:message('sys-lbpmmonitor:status.suspend') }
				</c:if>
			</list:data-column>
		</c:if>
		<!--当前处理（节点）-->
		<list:data-column headerClass="width100" col="nodeName" title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.nodeName') }" escape="false">
			<kmss:showWfPropertyValues var="nodevalue" idValue="${lbpmProcess.fdId}" propertyName="nodeName" />
			    <div class="textEllipsis width100" title='<c:out value="${nodevalue}"></c:out>'>
			        <c:out value="${nodevalue}"></c:out>
			    </div>
		</list:data-column>
		<!--当前处理人-->
		<list:data-column headerClass="width100" col="handlerName" title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.currentHandler') }" escape="false">
		   <kmss:showWfPropertyValues var="handlerValue" idValue="${lbpmProcess.fdId}" propertyName="handlerName" />
			    <div class="textEllipsis width100" style="font-weight:bold;" title='<c:out value="${handlerValue}"></c:out>'>
			        <c:out value="${handlerValue}"></c:out>
			    </div>
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>