<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<style>
.message{
	color: #003366; 
}
</style>
<html:form action="/sys/webservice2/sys_webservice_main/sysWebserviceMain.do">
<div id="optBarDiv">
    <input type=button value="<bean:message key="button.update"/>"
		onclick="Com_Submit(document.sysWebserviceMainForm, 'update');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-webservice2" key="table.sysWebserviceMain"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdName"/>
		</td><td width="85%" colspan="3">
			<xform:text property="fdName" style="width:85%" showStatus="view" />
		</td>
	</tr>
	<tr>				
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdServiceClass"/>
		</td><td width="85%" colspan="3">
			<xform:text property="fdServiceClass" style="width:85%" showStatus="view" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdServiceBean"/>
		</td><td width="35%">
			<xform:text property="fdServiceBean" style="width:85%" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdAnonymous"/>
		</td><td width="35%">
			<xform:radio property="fdAnonymous">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdServiceStatus"/>
		</td><td width="35%">
			<c:if test="${sysWebserviceMainForm.fdServiceStatus == 1}"> 
                <bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdServiceStatus.start"/>
            </c:if> 
			<c:if test="${sysWebserviceMainForm.fdServiceStatus == 0}"> 
                <bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdServiceStatus.stop"/>
            </c:if> 						
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdStartupType"/>
		</td><td width="35%">
            <xform:radio property="fdStartupType">
				<xform:enumsDataSource enumsType="sys_webservice_main_fd_startup_type" />
			</xform:radio> 
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdMaxConn"/>
		</td><td width="35%">
			<xform:text property="fdMaxConn" style="width:25%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdTimeOut"/>
		</td><td width="35%">
			<xform:text property="fdTimeOut" style="width:25%" />
		</td>
	</tr>
    <tr>
	    <td class="td_normal_title" width=15%>
		    <bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdUser"/>
	    </td><td width="85%" colspan="3">
            <xform:checkbox property="fdUserIds">
                <xform:beanDataSource serviceBean="sysWebserviceUserService" selectBlock="fdId,fdUserName"></xform:beanDataSource>
            </xform:checkbox> 	     
	    </td>	
    </tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdSoapMsgLogging"/>
		</td><td width="85%" colspan="3">
            <xform:radio property="fdSoapMsgLogging">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio> 
			<span class="message"><bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdSoapMsgLogging.tip"/></span>
		</td>			
	</tr>	    
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdDescription"/>
		</td><td width="85%" colspan="3">
			<xform:textarea property="fdDescription" style="width:85%" />
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("dialog.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>