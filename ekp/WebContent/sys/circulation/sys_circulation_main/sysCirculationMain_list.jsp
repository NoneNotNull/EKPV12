<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<c:set var="validateAuth" value="false" />
<kmss:auth
	requestURL="/sys/circulation/sys_circulation_main/sysCirculationMain.do?method=delete&fdModelName=${param.fdModelName}&fdModelId=${param.fdModelId}"
	requestMethod="GET">
	<c:set var="validateAuth" value="true" />
</kmss:auth>
<script type="text/javascript">
	Com_AddEventListener(window,'load',function(){
		setTimeout(resetHeight,100);
	});

	function resetHeight(){
		var td_circulation = document.getElementById("div_viewContainer");
		if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			window.frameElement.style.height = (td_circulation.offsetHeight+20)+"px";
		}
	}
	
	function confirmDelete(msg){
		var del = confirm('<bean:message bundle="sys-circulation" key="sysCirculationMain.message.delete"/>');
		return del;
	}
</script>
<html:form
	action="/sys/circulation/sys_circulation_main/sysCirculationMain.do">
	<center>
	<div id="div_viewContainer">
	<%if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {	%>
		<bean:message key="sysCirculationMain.showText.noneRecord" bundle="sys-circulation" />
	<%} else {%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">			
				<td width="40pt"><bean:message key="page.serial" /></td>
				<sunbor:column property="sysCirculationMain.fdCirculationTime">
					<bean:message bundle="sys-circulation"
						key="sysCirculationMain.fdCirculationTime" />
				</sunbor:column>
				<sunbor:column property="sysCirculationMain.fdCirculator.fdId">
					<bean:message bundle="sys-circulation"
						key="sysCirculationMain.fdCirculatorId" />
				</sunbor:column>
				<td>
					<bean:message bundle="sys-circulation"
						key="table.sysCirculationCirculors" />
				</td>
				<sunbor:column property="sysCirculationMain.fdRemark">
					<bean:message bundle="sys-circulation"
						key="sysCirculationMain.fdRemark" />
				</sunbor:column>
				<c:if test="${validateAuth=='true'}">
					<td width="10%">&nbsp;</td>
				</c:if>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysCirculationMain"
			varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/circulation/sys_circulation_main/sysCirculationMain.do" />?method=view&fdId=${sysCirculationMain.fdId}">
				<td>${vstatus.index+1}</td>
				<td>
				<kmss:showDate
					value="${sysCirculationMain.fdCirculationTime}" type="datetine" />
				</td>
				<td><c:out value="${sysCirculationMain.fdCirculator.fdName}" /></td>
				<td>
				<c:forEach
					items="${sysCirculationMain.receivedCirCulators}"
					var="receivedCirCulators" 
					varStatus="vstatus">
					<c:out value="${receivedCirCulators.fdName}" />
				</c:forEach></td>
				<td><c:out value="${sysCirculationMain.fdRemark}" /></td>
				<c:if test="${validateAuth=='true'}">
				<td>
					<a href="#"
						onclick="if(!confirmDelete())return;Com_OpenWindow('<c:url value="/sys/circulation/sys_circulation_main/sysCirculationMain.do"/>?method=delete&fdId=${sysCirculationMain.fdId}&fdModelId=${sysCirculationMain.fdModelId}&fdModelName=${sysCirculationMain.fdModelName}','_self');"><bean:message
						key="button.delete" />
					</a>
				</td>
				</c:if>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%}%>
	</div>
	</center>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>