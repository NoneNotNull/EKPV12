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
		<kmss:auth requestURL="/sys/time/sys_time_patchwork/sysTimePatchwork.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('sysTimePatchwork.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/time/sys_time_patchwork/sysTimePatchwork.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('sysTimePatchwork.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="top.close();">
</div>
<p class="txttitle"><bean:message  bundle="sys-time" key="table.sysTimePatchwork"/></p>
<center>
<table class="tb_normal" width=95%>
	<html:hidden name="sysTimePatchworkForm" property="fdId"/>
	<html:hidden name="sysTimePatchworkForm" property="sysTimeAreaId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimePatchwork.fdName"/>
		</td><td width=85% colspan=3>
			<bean:write name="sysTimePatchworkForm" property="fdName"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimePatchwork.time"/>
		</td>
		<td width=85% colspan=3>
			<bean:message  bundle="sys-time" key="sysTimePatchwork.start"/>
			<bean:write name="sysTimePatchworkForm" property="fdStartTime"/>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<bean:message  bundle="sys-time" key="sysTimePatchwork.end"/>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<bean:write name="sysTimePatchworkForm" property="fdEndTime"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimePatchwork.docCreatorId"/>
		</td><td width=35%>
			${sysTimePatchworkForm.docCreatorName}			
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimePatchwork.docCreateTime"/>
		</td><td width=35%>
			${sysTimePatchworkForm.docCreateTime}
		</td>
	</tr>
	<tr>
		<td colspan=4>
			<table class="tb_normal" width=100% id="TABLE_DocList">
				<tr>
					<td class="td_normal_title" align="center" width=5%>
						<bean:message  bundle="sys-time" key="table.sysTimePatchworkTime"/>
					</td>
					<td class="td_normal_title" align="center" width=45%>
						<bean:message  bundle="sys-time" key="sysTimePatchworkTime.fdWorkStartTime"/>
					</td>
					<td class="td_normal_title" align="center" width=45%>
						<bean:message  bundle="sys-time" key="sysTimePatchworkTime.fdWorkEndTime"/>
					</td>		
				</tr>
				<c:forEach items="${sysTimePatchworkForm.sysTimePatchworkTimeFormList}" var="sysTimePatchworkTimeForm" varStatus="vstatus">
				<tr KMSS_IsContentRow="1">
					<td>
						<center>
							${vstatus.index+1}
						</center>
					</td>
					<td>
					    <input type="hidden"   name="sysTimePatchworkTimeFormList[${vstatus.index}].fdWorkId" value = "${sysTimePatchworkForm.fdId}"/>
					    <input type="hidden"   name="sysTimePatchworkTimeFormList[${vstatus.index}].fdId" value = "${sysTimePatchworkTimeForm.fdId}"/>
						<center>
					    	<c:out value="${sysTimePatchworkTimeForm.fdWorkStartTime}" />
					    </center>
					</td>	
					<td>
					    <center>
					    	<c:out value="${sysTimePatchworkTimeForm.fdWorkEndTime}" />
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