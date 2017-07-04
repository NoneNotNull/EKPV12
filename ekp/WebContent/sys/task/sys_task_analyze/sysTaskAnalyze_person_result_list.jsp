<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>	 
<script type="text/javascript" src="../js/tableSort.js"></script>
<style>
sortheader{
background-color:#d8e9fd;
align:"center" ;
bgcolor:"#d8e9fd"
} 
</style>
<script>
function doClick(url){
	var url = url;
	url = url +"&isincludechildtask=${isincludechildtask}&fdStartDate=${startDate}&fdEndDate=${endDate}&dateQueryType=${dateQueryType}";
	window.open(url);
}
</script>
	<table id="table_id" class="sortable" cellspacing="1" cellpadding="5" width="100%"  bgcolor="#666666"  border="0">
		<tr align="center" style="background-color:#d8e9fd">
			
				<td width="2%"><bean:message key="page.serial"/></td>
				<td width="5%">
					<bean:message bundle="sys-task" key="sysTaskAnalyze.personName"/>
				</td>
				<c:if test="${analyzeType =='1' ||  analyzeType =='3'}">
				<td width="5%">
					<bean:message bundle="sys-task" key="sysTaskAnalyze.account"/>
				</td>
				<td width="5%">
					<bean:message bundle="sys-task" key="sysTaskAnalyze.account.complete.true"/>
				</td>
				<td width="5%">
					<bean:message bundle="sys-task" key="sysTaskAnalyze.account.complete.false"/>
				</td>
				</c:if>
				<c:if test="${analyzeType !='1'}">
					<c:forEach items="${approveList}" var="taskApprove" varStatus="vstatus_">
						<td width="5%">
					      <c:out value="${taskApprove.fdApprove}" />	
						</td>
					</c:forEach>
				</c:if>
			
		</tr>
	<c:if test="${rtnSize>0}">
		<c:forEach items="${rtnList}" var="taskAnalyzeContext" varStatus="vstatus">
			<c:if test="${(vstatus.index+1)%2==0}">
				<c:set var="bgcolor" value="#f5f5f5" />
			</c:if>
			<c:if test="${(vstatus.index+1)%2!=0}">
				<c:set var="bgcolor" value="#ffffff" />
			</c:if>
			<c:if test="${param.type =='detail' && param.fdId == sysCommunicateMain.fdId}">
				<c:set var="bgcolor" value="#FFFACD" />
			</c:if>
			<tr align="center" style="cursor: pointer" bgcolor="${bgcolor}"
				onclick="doClick('<c:url value="/sys/task/sys_task_main/sysTaskMain.do" />?method=listByPerson&fdId=${sysTaskAnalyzeForm.fdId}&orgId=${taskAnalyzeContext.hbmOrgElement.fdId}')"
				onmouseover="this.style.background='#cccccc'"
			    onmouseout="this.style.background='${bgcolor}'"
				>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${taskAnalyzeContext.hbmOrgElement.fdName}" />					
				</td>
				<c:if test="${analyzeType =='1' ||  analyzeType =='3'}">
				<td>
					<c:out value="${taskAnalyzeContext.taskCount}" />		
				</td>
				<td>
					<c:out value="${taskAnalyzeContext.taskComplementTrueCount}" />		
				</td>
				<td>
					<c:out value="${taskAnalyzeContext.taskComplementFalseCount}" />		
				</td>
				</c:if>
				<c:if test="${approveList != null}">
						<c:forEach items="${approveList}" var="taskApprove" varStatus="vstatus1">
							<c:forEach items="${taskAnalyzeContext.evaluateMap}" var ="evaluate" varStatus = "vstatus11">
								<c:if test="${taskApprove.fdId == evaluate.key}">
									<td>
										<c:out value="${evaluate.value}"/>
										<c:set value="1" var="flag"/>		
									</td>
								</c:if>					
						   </c:forEach>
					   		<c:if test="${flag!='1'}">
					   			<td>
									0		
								</td>
					   		</c:if>
					   		<c:set value="0" var="flag"/>		
					   </c:forEach>
				</c:if>
			</tr>
		</c:forEach>
	</c:if>
	</table>
<%@ include file="/resource/jsp/list_down.jsp"%>