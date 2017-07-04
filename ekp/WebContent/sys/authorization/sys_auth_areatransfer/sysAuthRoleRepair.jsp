<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>	
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ include file="/sys/config/resource/edit_top.jsp"%>
<%@ page import="java.util.Map, java.util.Set, java.util.Iterator"%>
<%@ page import="com.landray.kmss.sys.authorization.model.SysAuthRoleInfo"%>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>

<kmss:windowTitle subjectKey="sys-authorization:sysAuthAreaTransfer.role.transfer" moduleKey="sys-authorization:authorization.moduleName" />
<p class="txttitle"><bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.role.transfer" /></p>
<html:form action="/sys/authorization/sysAuthAreaTransfer.do">
<center>
<%
if (ISysAuthConstant.IS_AREA_ENABLED) {
    Set<SysAuthRoleInfo> rraList = (Set<SysAuthRoleInfo>)request.getAttribute("rraList");
    if(rraList != null && rraList.size() > 0) {
%>
<table class="tb_normal" style="border:0;" width=90%>
	<tr>
		<td width="100%" align="left" style="border:0;">
		    <b><bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.role.role" /></b></td>
	</tr>
</table>
<table class="tb_normal" width=90%>
	<td width="20%" align="center" class="td_normal_title"><bean:message bundle="sys-authorization" key="sysAuthRole.fdName" /></td>
	<td width="80%" align="center" class="td_normal_title"><bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.role.incompatible" /></td>
    <%   
        Iterator<SysAuthRoleInfo> rraItr = rraList.iterator();

        while(rraItr.hasNext()) {
        	SysAuthRoleInfo roleInfo = rraItr.next();  
    %>
	<tr>
		<td>
			<label>
			    <input type="hidden" name="rraId" value="<%=roleInfo.getFdId()%>" />
			    <a href='#' onclick='Com_OpenWindow(Com_Parameter.ContextPath+"<%=roleInfo.getFdPath()%>");'>
				    <c:out value="<%=roleInfo.getFdName()%>" />
				</a>	
			</label>
		</td>		    
		<td>
			<label>
				<c:out value="<%=roleInfo.getDesc()%>" />
			</label>
		</td>				                            
	</tr>
	<% } %>	
</table>
<% } %>
<br />
<%
    Set<SysAuthRoleInfo> uraList = (Set<SysAuthRoleInfo>)request.getAttribute("uraList");
    if(uraList != null && uraList.size() > 0) {
%>
<table class="tb_normal" style="border:0;" width=90%>
	<tr>
		<td width="100%" align="left" style="border:0;">
		    <b><bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.role.ura" /></b></td>
	</tr>
</table>
<table class="tb_normal" width=90%>
    <%   
        Iterator<SysAuthRoleInfo> uraItr = uraList.iterator();

        while(uraItr.hasNext()) {
        	SysAuthRoleInfo roleInfo = uraItr.next();  
    %>
	<tr>
		<td style="border:0;" width="25%">
			<label>
			    <input type="hidden" name="uraId" value="<%=roleInfo.getFdId()%>" />
				<c:out value="<%=roleInfo.getFdName()%>" />	
			</label>
		</td>		    
		<td style="border:0;" width="25%">
			<% 
			    if(uraItr.hasNext()) { 
			    	roleInfo = uraItr.next();
			%>
			<label>
			    <input type="hidden" name="uraId" value="<%=roleInfo.getFdId()%>" />
				<c:out value="<%=roleInfo.getFdName()%>" />	
			</label>
		    <% } %>
		</td>		
		<td style="border:0;" width="25%">
			<% 
		        if(uraItr.hasNext()) { 
		    	    roleInfo = uraItr.next();
			%>
			<label>
			    <input type="hidden" name="uraId" value="<%=roleInfo.getFdId()%>" />
				<c:out value="<%=roleInfo.getFdName()%>" />	
			</label>
		    <% } %>
		</td>		                            
	</tr>
	<% } %>	
</table>
<% } } else { %>
<br />
<%
    Set<SysAuthRoleInfo> areaRoleList = (Set<SysAuthRoleInfo>)request.getAttribute("areaRoleList");
    if(areaRoleList != null && areaRoleList.size() > 0) {
%>
<table class="tb_normal" style="border:0;" width=90%>
	<tr>
		<td width="100%" align="left" style="border:0;">
		    <b><bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.role.edt" /></b></td>
	</tr>
</table>
<table class="tb_normal" width=90%>
    <%   
        Iterator<SysAuthRoleInfo> areaRoleItr = areaRoleList.iterator();

        while(areaRoleItr.hasNext()) {
        	SysAuthRoleInfo roleInfo = areaRoleItr.next();  
    %>
	<tr>
		<td style="border:0;" width="25%">
			<label>
			    <input type="hidden" name="roleEdtId" value="<%=roleInfo.getFdId()%>" />
				<c:out value="<%=roleInfo.getFdName()%>" />	
			</label>
		</td>		    
		<td style="border:0;" width="25%">
			<% 
			    if(areaRoleItr.hasNext()) { 
			    	roleInfo = areaRoleItr.next();
			%>
			<label>
			    <input type="hidden" name="roleEdtId" value="<%=roleInfo.getFdId()%>" />
				<c:out value="<%=roleInfo.getFdName()%>" />	
			</label>
		    <% } %>
		</td>		
		<td style="border:0;" width="25%">
			<% 
		        if(areaRoleItr.hasNext()) { 
		    	    roleInfo = areaRoleItr.next();
			%>
			<label>
			    <input type="hidden" name="roleEdtId" value="<%=roleInfo.getFdId()%>" />
				<c:out value="<%=roleInfo.getFdName()%>" />	
			</label>
		    <% } %>
		</td>		                            
	</tr>
	<% } %>	
</table>
<% } } %>
<table width=90%>
	<tr>
		<td align="right" width="10%">
			<input class="btnopt" type="button" value="<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.role.detect" />" style="height:20px" 
				onclick="Com_Submit(document.sysAuthAreaTransferForm, 'detectRole');">		
			<input id="btnRepair" class="btnopt" type="button" value="<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.role.repair" />" style="height:20px" 
				onclick="repairRole()">				
		</td>			
	</tr>
</table>
</center>
</html:form>
<script>
function repairRole() {	
	if(!confirm('<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.repairRole.comfirm"/>')) {
		return false;
	}

	Com_Submit(document.sysAuthAreaTransferForm, 'repairRole'); 
	return true;
}
</script>
<%@ include file="/sys/config/resource/edit_down.jsp"%>