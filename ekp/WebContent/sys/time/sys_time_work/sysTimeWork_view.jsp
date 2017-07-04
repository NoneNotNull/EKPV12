<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
		<kmss:auth requestURL="/sys/time/sys_time_work/sysTimeWork.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('sysTimeWork.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/time/sys_time_work/sysTimeWork.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('sysTimeWork.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="top.close();">
</div>
<p class="txttitle"><bean:message  bundle="sys-time" key="table.sysTimeWork"/></p>
<center>
<table class="tb_normal" width=95%>
	<html:hidden name="sysTimeWorkForm" property="fdId"/>
	<html:hidden name="sysTimeWorkForm" property="sysTimeAreaId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeWork.validTime"/>
		</td>
		<td width=85% colspan=3>
			<bean:message  bundle="sys-time" key="sysTimeWork.validTime.start"/>
			<bean:write name="sysTimeWorkForm" property="fdStartTime"/>
			&nbsp;&nbsp;
			<bean:message  bundle="sys-time" key="sysTimeWork.validTime.end"/>
			<c:if test="${sysTimeWorkForm.fdEndTime != null || sysTimeWorkForm.fdEndTime != ''}">
				<bean:write name="sysTimeWorkForm" property="fdEndTime"/>
			</c:if>
			<c:if test="${sysTimeWorkForm.fdEndTime == null || sysTimeWorkForm.fdEndTime == ''}">
				<bean:message  bundle="sys-time" key="sysTimeWork.validTime.end.list"/>
			</c:if>	
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeWork.week"/>
		</td><td width=85% colspan=3>
			<bean:message  bundle="sys-time" key="sysTimeWork.week.start"/>
			<sunbor:enumsShow value="${sysTimeWorkForm.fdWeekStartTime}" enumsType="common_week_type"/>
			&nbsp;&nbsp;
			<bean:message  bundle="sys-time" key="sysTimeWork.week.end"/>
			<sunbor:enumsShow value="${sysTimeWorkForm.fdWeekEndTime}" enumsType="common_week_type"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeWork.docCreatorId"/>
		</td><td width=35%>
			${sysTimeWorkForm.docCreatorName}			
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeWork.docCreateTime"/>
		</td><td width=35%>
			${sysTimeWorkForm.docCreateTime}
		</td>
	</tr>
	<tr>
		<td colspan=4>
			<table class="tb_normal" width=100% id="TABLE_DocList">
				<tr>
					<td class="td_normal_title" align="center" width=5%>
						<bean:message  bundle="sys-time" key="table.sysTimeWorkTime"/>
					</td>
					<td class="td_normal_title" align="center" width=45%>
						<bean:message  bundle="sys-time" key="sysTimeWorkTime.fdWorkStartTime"/>
					</td>
					<td class="td_normal_title" align="center" width=45%>
						<bean:message  bundle="sys-time" key="sysTimeWorkTime.fdWorkEndTime"/>
					</td>		
				</tr>
				<c:forEach items="${sysTimeWorkForm.sysTimeWorkTimeFormList}" var="sysTimeWorkTimeForm" varStatus="vstatus">
				<tr>
					<td>
						<center>
							${vstatus.index+1}
						</center>
					</td>
					<td>
					    <input type="hidden"   name="sysTimeWorkTimeFormList[${vstatus.index}].fdWorkId" value = "${sysTimeWorkForm.fdId}"/>
					    <input type="hidden"   name="sysTimeWorkTimeFormList[${vstatus.index}].fdId" value = "${sysTimeWorkTimeForm.fdId}"/>
						<center>
							<c:out value="${sysTimeWorkTimeForm.fdWorkStartTime}" />
						</center>
					</td>	
					<td>
						<center>
						 	<c:out value="${sysTimeWorkTimeForm.fdWorkEndTime}" />
						</center>
					</td>
				</tr>	
				</c:forEach>
			</table>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>