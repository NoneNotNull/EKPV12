<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/webservice2/sys_webservice_main/sysWebserviceMain.do?method=start">
		<input type="button" value="<bean:message key="button.startservice" bundle="sys-webservice2"/>"
			onclick="Com_OpenWindow('sysWebserviceMain.do?method=start&fdId=${param.fdId}','_self');">
	</kmss:auth>	
	<kmss:auth requestURL="/sys/webservice2/sys_webservice_main/sysWebserviceMain.do?method=stop">
		<input type="button" value="<bean:message key="button.stopservice" bundle="sys-webservice2"/>"
			onclick="Com_OpenWindow('sysWebserviceMain.do?method=stop&fdId=${param.fdId}','_self');">
	</kmss:auth>  
	<kmss:auth requestURL="/sys/webservice2/sys_webservice_main/sysWebserviceMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('sysWebserviceMain.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/sys/webservice2/sys_webservice_main/sysWebserviceMain.do?method=download">
		<input type="button" value="<bean:message key="button.download.client" bundle="sys-webservice2"/>"
			onclick="Com_OpenWindow('sysWebserviceMain.do?method=download&fdId=${param.fdId}','_self');">
	</kmss:auth>		
	<input type="button" 
	       value="<bean:message key="button.wsdl" bundle="sys-webservice2"/>" 
	       onclick="Com_OpenWindow('${requestScope.wsdlUrl}','_blank');">	
	<input type="button" 
	       value="<bean:message key="button.help" bundle="sys-webservice2"/>" 
	       onclick="Com_OpenWindow('<%=request.getContextPath()%>${sysWebserviceMainForm.fdServiceParam}?name=${sysWebserviceMainForm.fdName}','_blank');">		
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
		
</div>

<p class="txttitle"><bean:message bundle="sys-webservice2" key="table.sysWebserviceMain"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdName"/>
		</td><td width="85%"  colspan="3">
			<xform:text property="fdName" style="width:85%" />
		</td>
	</tr>
	<tr>			
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdServiceClass"/>
		</td><td width="85%"  colspan="3">
			<xform:text property="fdServiceClass" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdServiceBean"/>
		</td><td width="35%">
			<xform:text property="fdServiceBean" style="width:85%" />
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

<%@ include file="/resource/jsp/view_down.jsp"%>