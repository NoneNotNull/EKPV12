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
		<kmss:auth requestURL="/sys/time/sys_time_area/sysTimeArea.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('sysTimeArea.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/time/sys_time_area/sysTimeArea.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('sysTimeArea.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="top.close();">
</div>
<p class="txttitle"><bean:message  bundle="sys-time" key="title.timeSetting"/></p>
<center>
<table width="95%" align="center" id="Label_Tabel">
	<tr LKS_LabelName="<bean:message  bundle="sys-time" key="table.sysTimeArea"/>">
	    <td>
			<table class="tb_normal" width=100%>
				<html:hidden name="sysTimeAreaForm" property="fdId"/>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-time" key="sysTimeArea.fdName"/>
					</td>
					<td width=85% colspan=3>
						<bean:write name="sysTimeAreaForm" property="fdName"/>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="sys-time" key="sysTimeArea.scope"/>
					</td>
					<td width=85% colspan=3>
						<bean:write name="sysTimeAreaForm" property="areaMemberNames"/>						
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-time" key="sysTimeArea.timeAdmin"/>
					</td>
					<td width=85% colspan=3>
						<bean:write name="sysTimeAreaForm" property="areaAdminNames"/>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-time" key="sysTimeArea.docCreatorId"/>
					</td><td width=35%>
						<bean:write name="sysTimeAreaForm" property="docCreatorName"/>
					</td>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-time" key="sysTimeArea.docCreateTime"/>
					</td><td width=35%>
						<bean:write name="sysTimeAreaForm" property="docCreateTime"/>
					</td>
				</tr>
				<tr>
				  <td colspan="4" style="color: red">
				    ${lfn:message('sys-time:sysTimeArea.descriptption')}<br>
				    ${lfn:message('sys-time:sysTimeArea.descriptption.area')}<br>
				    ${lfn:message('sys-time:sysTimeArea.descriptption.time')}<br>
				    ${lfn:message('sys-time:sysTimeArea.descriptption.voa')}<br>
				    ${lfn:message('sys-time:sysTimeArea.descriptption.patch')}<br>
				    
				    ${lfn:message('sys-time:sysTimeArea.notice')} <br>
				    ${lfn:message('sys-time:sysTimeArea.notice1')}<br>
				    ${lfn:message('sys-time:sysTimeArea.notice2')}<br>
				    
				    ${lfn:message('sys-time:sysTimeArea.notice.example')}<br>
				    ${lfn:message('sys-time:sysTimeArea.notice.example1')}<br>
				    ${lfn:message('sys-time:sysTimeArea.notice.example2')}<br>
				  </td>
				</tr>
			</table>
		</td>
	</tr>
	<c:import url="/sys/time/sys_time_work/sysTimeWork_view_list.jsp" charEncoding="UTF-8">
		<c:param name="sysTimeAreaId" value="${sysTimeAreaForm.fdId}" />
	</c:import>	
	<c:import url="/sys/time/sys_time_vacation/sysTimeVacation_view_list.jsp" charEncoding="UTF-8">
		<c:param name="sysTimeAreaId" value="${sysTimeAreaForm.fdId}" />
	</c:import>	
	<c:import url="/sys/time/sys_time_patchwork/sysTimePatchwork_view_list.jsp" charEncoding="UTF-8">
		<c:param name="sysTimeAreaId" value="${sysTimeAreaForm.fdId}" />
	</c:import>	
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>