<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
function submitForm(fdEnable){
	var msg = fdEnable ?
		"<bean:message bundle="sys-quartz" key="sysQuartzJob.dialog.comfirmEnable"/>":
		"<bean:message bundle="sys-quartz" key="sysQuartzJob.dialog.comfirmDisable"/>";
	if(confirm(msg)){
		document.getElementsByName('fdEnabled')[0].value=fdEnable;
		document.sysQuartzJobForm.submit();
	}
}
</script>
<div id="optBarDiv">
	<input type="button" value="<bean:message bundle="sys-quartz" key="sysQuartzJob.button.run"/>"
		onClick="Com_OpenWindow('sysQuartzJob.do?method=run&fdId=${sysQuartzJobForm.fdId}','_self');">
	<c:if test="${sysQuartzJobForm.fdEnabled!='true'}">
		<input type="button" value="<bean:message bundle="sys-quartz" key="sysQuartzJob.button.enable"/>" 
			onclick="submitForm(true);"/>
	</c:if>
	<c:if test="${sysQuartzJobForm.fdEnabled=='true'}">
		<input type="button" value="<bean:message bundle="sys-quartz" key="sysQuartzJob.button.disable"/>" 
			onclick="submitForm(false);"/>
	</c:if>
	<input type="button" value="<bean:message key="button.edit"/>"
		onClick="Com_OpenWindow('sysQuartzJob.do?method=edit&fdId=${sysQuartzJobForm.fdId}','_self');">
	<input type="button" value="<bean:message key="button.close"/>" onClick="Com_CloseWindow();">
</div>
<div class="txttitle"><bean:message bundle="sys-quartz" key="table.sysQuartzJob"/></div>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-quartz" key="sysQuartzJob.fdSubject"/>
		</td><td colspan="3">
			<c:if test="${sysQuartzJobForm.fdIsSysJob=='true'}">
				<kmss:message key="${sysQuartzJobForm.fdSubject}"/>
			</c:if>
			<c:if test="${sysQuartzJobForm.fdIsSysJob!='true'}">
				<c:out value="${sysQuartzJobForm.fdSubject}" /> 
			</c:if>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-quartz" key="sysQuartzJob.fdCronExpression"/>
		</td><td width=35%>
			<c:import url="/sys/quartz/sys_quartz_job/sysQuartzJob_showCronExpression.jsp" charEncoding="UTF-8">
				<c:param name="value" value="${sysQuartzJobForm.fdCronExpression}" />
			</c:import>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-quartz" key="sysQuartzJob.nextTime"/>
		</td><td width=35%>
			<c:if test="${sysQuartzJobForm.fdEnabled=='true'}">
				<c:out value="${sysQuartzJobForm.fdRunTime}"/>
			</c:if>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-quartz" key="sysQuartzJob.fdRunType"/>
		</td><td>
			<sunbor:enumsShow value="${sysQuartzJobForm.fdRunType}" enumsType="sysQuartzJob_fdRunType" />
			<c:if test="${not empty sysQuartzJobForm.fdRunServer}">
				(${sysQuartzJobForm.fdRunServer})
			</c:if>
		</td>
		<td class="td_normal_title">
			<bean:message bundle="sys-quartz" key="sysQuartzJob.fdEnabled"/>
		</td><td>
			<sunbor:enumsShow value="${sysQuartzJobForm.fdEnabled}" enumsType="common_yesno" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-quartz" key="sysQuartzJob.fdIsSysJob"/>
		</td><td colspan="3">
			<sunbor:enumsShow value="${sysQuartzJobForm.fdIsSysJob}" enumsType="common_yesno" />
		</td>
		
	</tr>
	<tr>
	   <td  colspan="4">
		    <input type="checkbox" disabled <c:if test="${sysQuartzJobForm.fdRequired == 'true'}">checked</c:if>>
		    <bean:message bundle="sys-quartz" key="sysQuartzJob.fdRequired"/>&nbsp;&nbsp;
		    <bean:message bundle="sys-quartz" key="sysQuartzJob.fdRequired.desc"/>
	   </td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-quartz" key="sysQuartzJob.fdJob"/>
		</td><td colspan="3">
			${sysQuartzJobForm.fdJobService}.${sysQuartzJobForm.fdJobMethod}(${sysQuartzJobForm.fdParameter})
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-quartz" key="sysQuartzJob.fdLink"/>
		</td><td colspan="3">
			<c:if test="${sysQuartzJobForm.fdLink!=null && sysQuartzJobForm.fdLink!=''}">
				<a href="<c:url value="${sysQuartzJobForm.fdLink}" />" target="_blank">
					<c:out value="${sysQuartzJobForm.fdLink}"/>
				</a>
			</c:if>
		</td>
	</tr>
</table>
<form name="sysQuartzJobForm" action="<c:url value="/sys/quartz/sys_quartz_job/sysQuartzJob.do?method=chgenabled"/>" method="POST">
	<input type=hidden name="List_Selected" value="${sysQuartzJobForm.fdId}">
	<input type=hidden name="fdEnabled">
</form>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>