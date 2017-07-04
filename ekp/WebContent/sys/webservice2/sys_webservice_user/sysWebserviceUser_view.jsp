<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/webservice2/sys_webservice_user/sysWebserviceUser.do?method=editPassword&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message bundle="sys-webservice2" key="button.password"/>"
			onclick="Com_OpenWindow('sysWebserviceUser.do?method=editPassword&fdId=${param.fdId}','_blank');">
	</kmss:auth>
	<kmss:auth requestURL="/sys/webservice2/sys_webservice_user/sysWebserviceUser.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('sysWebserviceUser.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/sys/webservice2/sys_webservice_user/sysWebserviceUser.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysWebserviceUser.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>	
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-webservice2" key="table.sysWebserviceUser"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceUser.fdUserName"/>
		</td><td width="85%" colspan="3">
			<xform:text property="fdUserName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceUser.fdLoginId"/>
		</td><td width="85%" colspan="3">
			<xform:text property="fdLoginId" style="width:85%" />
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceUser.fdService"/>
		</td><td width="85%" colspan="3">
            <xform:checkbox property="fdServiceIds">
                <xform:beanDataSource serviceBean="sysWebserviceMainService"></xform:beanDataSource>
            </xform:checkbox> 	
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceUser.fdAccessIp"/>
		</td><td width="85%" colspan="3">
			<xform:textarea property="fdAccessIp" style="width:85%" />
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceUser.fdDescription"/>
		</td><td width="85%" colspan="3">
			<xform:textarea property="fdDescription" style="width:85%" />
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceUser.docCreator"/>
		</td><td width="35%">
			<c:out value="${sysWebserviceUserForm.docCreatorName}" />
		</td>	
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceUser.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" />
		</td>		
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>