<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<div id="optBarDiv">
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-log" key="table.sysLogOnline"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogOnline.fdPerson"/>
		</td><td width="35%">
			<c:out value="${sysLogOnlineForm.fdPersonName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogOnline.isOnline"/>
		</td><td width="35%">
			<c:out value="${sysLogOnlineForm.fdIsUserOnline}" />
			<c:if test="${not empty sysLogOnlineForm.fdOnlineTime}">
				(<xform:datetime property="fdOnlineTime" />)
			</c:if>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogOnline.fdLoginTime"/>
		</td><td width="35%">
			<xform:datetime property="fdLoginTime" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogOnline.fdLoginIp"/>
		</td><td width="35%">
			<xform:text property="fdLoginIp" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogOnline.fdLastLoginTime"/>
		</td><td width="35%">
			<xform:datetime property="fdLastLoginTime" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogOnline.fdLastLoginIp"/>
		</td><td width="35%">
			<xform:text property="fdLastLoginIp" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogOnline.fdLoginNum"/>
		</td><td width="35%">
			<xform:text property="fdLoginNum" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogOnline.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>