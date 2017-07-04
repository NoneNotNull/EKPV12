<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>

<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.close"/>"
	onclick="Com_CloseWindow();">
	</div>
<p class="txttitle"><bean:message bundle="sys-circulation"
	key="sysCirculationMain.tab.circulation.label" /></p>
<center>
<table class="tb_normal" width=95%>
	
	
		<tr>
			<td class="td_normal_title" width=15%>
			<bean:message
				bundle="sys-circulation" key="sysCirculationMain.fdCirculatorId" />
			</td>
			<td>
			<c:out 	value="${sysCirculationMainForm.fdCirculatorName}" />
			</td>
		</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
		<bean:message
			bundle="sys-circulation" key="sysCirculationMain.fdCirculationTime" />
		</td>
		<td>
		<c:out 	value="${sysCirculationMainForm.fdCirculationTime}" />
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
		<bean:message
			bundle="sys-circulation" key="table.sysCirculationCirculors" />
		</td>
		<td>
		<c:out value="${sysCirculationMainForm.receivedCirCulatorNames}" />
		</td>
	</tr>
	
	<tr>
		   <td class="td_normal_title" width=15%>
			<bean:message
				bundle="sys-circulation" key="sysCirculationMain.fdRemark" />
				</td>
			<td>
		<c:out value="${sysCirculationMainForm.fdRemark}" />
			</td>
		</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>


