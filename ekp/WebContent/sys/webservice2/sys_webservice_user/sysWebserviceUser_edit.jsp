<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/webservice2/sys_webservice_user/sysWebserviceUser.do">
<div id="optBarDiv">
	<c:if test="${sysWebserviceUserForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysWebserviceUserForm, 'update');">
	</c:if>
	<c:if test="${sysWebserviceUserForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysWebserviceUserForm, 'save');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-webservice2" key="table.sysWebserviceUser"/></p>

<center>
<table class="tb_normal" width=95%>
    <span class="txtstrong">${alertPassword}</span>	
	<c:if test="${sysWebserviceUserForm.method_GET=='edit'}">
	  <tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceUser.fdUserName"/>
		</td><td width="85%" colspan="3">
			<xform:text property="fdUserName" style="width:25%" showStatus="view"/>
		</td>
	  </tr>
	  <tr>	
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceUser.fdLoginId"/>
		</td><td width="35%" colspan="3">
			<xform:text property="fdLoginId" style="width:25%" showStatus="view"/>
		</td>
	  </tr>			
	</c:if>	
	<c:if test="${sysWebserviceUserForm.method_GET=='add'}">
	  <tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceUser.fdUserName"/>
		</td><td width="35%" colspan="3">
			<xform:text property="fdUserName" style="width:25%" />
		</td>
	  </tr>
	  <tr>	 	
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceUser.fdLoginId"/>
		</td><td width="35%" colspan="3">
			<xform:text property="fdLoginId" style="width:25%" />
		</td>
	  </tr>
	  <tr>					
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceUser.fdPassword"/>
		</td><td width="35%" colspan="3">			
			<xform:text property="fdPassword" style="width:25%" />
		</td>	
	  </tr>		                
	</c:if>		

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
			<xform:textarea property="fdAccessIp" style="width:85%" /><br>
			<bean:message bundle="sys-webservice2" key="sysWebserviceUser.fdAccessIp.desc"/>
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceUser.fdDescription"/>
		</td><td width="85%" colspan="3">
			<xform:textarea property="fdDescription" style="width:85%" />
		</td>
	</tr>

	<c:if test="${sysWebserviceUserForm.method_GET=='edit'}">	
	  <tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceUser.docCreator"/>
		</td><td width="35%">
			<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
		</td>	
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceUser.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" showStatus="view" />
		</td>	
	  </tr>
	</c:if>
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