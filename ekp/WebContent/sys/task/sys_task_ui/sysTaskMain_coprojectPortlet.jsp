<%@ page language="java" contentType="text/json; charset=UTF-8"
    import="com.landray.kmss.sys.task.model.SysTaskMain,com.landray.kmss.sys.organization.model.SysOrgElement,java.util.*"
	pageEncoding="UTF-8"%>
	
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysTaskMain" list="${queryPage.list }">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<%--任务名称--%>
		<list:data-column col="docSubject" title="${ lfn:message('sys-task:sysTaskMain.docSubject') }" style="text-align:left;width:28%;" escape="false">
			<p title="${sysTaskMain.docSubject}">
			<a href="${LUI_ContextPath}/sys/task/sys_task_main/sysTaskMain.do?method=view&fdId=${sysTaskMain.fdId}" target="_blank">
				<c:choose >
					<c:when test="${fn:length(sysTaskMain.docSubject)>28}">${fn:substring(sysTaskMain.docSubject, 0,26)}...</c:when>
					<c:otherwise>${sysTaskMain.docSubject}</c:otherwise>
				</c:choose>
			</a>
			</p>
		</list:data-column>
		<%--任务状态--%>
		<list:data-column headerStyle="width: 8%;" col="fdPastDue" title="${ lfn:message('sys-task:sysTaskMain.fdStatus') }" escape="false">
			<kmss:showTaskStatus taskStatus="${sysTaskMain.fdStatus}" />
		</list:data-column>
		<%--是否过期--%>
		<list:data-column headerStyle="width: 8%;" col="fdPastDue" title="${ lfn:message('sys-task:sysTaskMain.pastdue.yesno') }">
			<sunbor:enumsShow value="${sysTaskMain.fdPastDue}" enumsType="sys_task_yesno"  />
		</list:data-column>
		<%--任务进度--%>
		<list:data-column headerStyle="width: 18%;" col="fdProgress" title="${ lfn:message('sys-task:sysTaskMain.fdProgress') }" escape="false" style="line-height:10px;">
			<c:out value="${sysTaskMain.fdProgress}" />%
			<div class='pro_barline'>
				<c:if test="${sysTaskMain.fdProgress=='100' }">
					<div class='complete' style="width:${sysTaskMain.fdProgress}%"></div>
				</c:if>
				<c:if test="${sysTaskMain.fdProgress!='100' }">
					<div class='uncomplete' style="width:${sysTaskMain.fdProgress}%"></div>
				</c:if>
			</div>
		</list:data-column>
		<%--指派人--%>
		<list:data-column headerStyle="width: 8%;" col="fdAppoint.fdName" title="${ lfn:message('sys-task:sysTaskFeedback.fdNotifyType.appoint') }" escape="false">
			<ui:person personId="${sysTaskMain.fdAppoint.fdId}" personName="${sysTaskMain.fdAppoint.fdName}"></ui:person>
		</list:data-column>
		<%--接收人--%>
		<list:data-column headerStyle="width: 12%;" col="toSysOrgPerform" escape="false" title="${ lfn:message('sys-task:table.sysTaskMainPerform') }">
			<%
			if(pageContext.getAttribute("sysTaskMain")!=null){
		    List toSysOrgPerform=((SysTaskMain)pageContext.getAttribute("sysTaskMain")).getToSysOrgPerform();
			String personsName="";
				for(int i=0;i<toSysOrgPerform.size();i++){
					if(i==toSysOrgPerform.size()-1){
					 	personsName+=((SysOrgElement)toSysOrgPerform.get(i)).getFdName();	
					}else{
	                  	personsName+=((SysOrgElement)toSysOrgPerform.get(i)).getFdName()+";";	
					}
				 }
			request.setAttribute("personsName",personsName);
			}
			%>
			<p title="${personsName}">
				<c:forEach items="${sysTaskMain.toSysOrgPerform}" var="performName" varStatus="vstatus_" begin="0" end="1">
					<ui:person personId="${performName.fdId}" personName="${performName.fdName}"></ui:person>
				</c:forEach>
				<c:if test="${fn:length(sysTaskMain.toSysOrgPerform)>2}">
					...
				</c:if>
			</p>
		</list:data-column>
		<%-- 计划完成时间--%>
		<list:data-column headerStyle="width: 11%;" col="fdPlanCompleteDateTime" title="${ lfn:message('sys-task:sysTaskMain.fdPlanCompleteTime') }">
			<kmss:showDate value="${sysTaskMain.fdPlanCompleteDateTime}" type="date" />
		</list:data-column>
	</list:data-columns>
</list:data>