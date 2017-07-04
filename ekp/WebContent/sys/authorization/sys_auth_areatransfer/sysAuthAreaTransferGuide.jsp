<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/sys/config/resource/view_top.jsp"%>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@ page import="com.landray.kmss.sys.authorization.util.LicenseUtil"%>
<link rel="stylesheet" href="<c:url value="/sys/admin/resource/images/dbcheck_select.css"/>" />
<kmss:windowTitle subjectKey="sys-authorization:sys.sysAuthAreaTransfer" moduleKey="sys-authorization:authorization.moduleName" />
<script type="text/JavaScript">
Com_IncludeFile("jquery.js");
</script>
<script type="text/javascript" src="<c:url value="/sys/admin/resource/js/jquery.corner.js"/>"></script>
<script type="text/javascript">
var SysAdmin_Loading_Div;
function createLoadingDiv() {
	var _img, _text, _div;
	_img = document.createElement('img');
	_img.src = Com_Parameter.ContextPath + "resource/style/common/images/loading.gif";
	_text = document.createElement("label");
	_text.id = 'SysAdmin_loading_Text_Label';
	_text.appendChild(document.createTextNode('<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.proccessing"/>'));
	_text.style.color = "#00F";
	_text.style.height = "16px";
	_text.style.margin = "5px";
	_div = document.createElement('div');
	_div.id = "SysAdmin_Loading_Div";
	_div.style.position = "absolute";
	_div.style.padding = "5px 10px";
	_div.style.fontSize = "12px";
	_div.style.backgroundColor = "#F5F5F5";
	_div.appendChild(_img);
	_div.appendChild(_text);
	_div.style.top = 95 + document.body.scrollTop;
	_div.style.left = document.body.clientWidth / 2 + document.body.scrollLeft - 73;
	SysAdmin_Loading_Div = _div;
}
function showLoadingDiv() {
	document.body.appendChild(SysAdmin_Loading_Div);
}
$(document).ready(function() {
	createLoadingDiv();
});
</script>
<br />
<%
if(LicenseUtil.getAreaLicence() == -1 || LicenseUtil.getAreaLicence() > 0) {
%>
<html:form action="/sys/authorization/sysAuthAreaTransfer.do">
<p class="txttitle"><bean:message bundle="sys-authorization" key="sys.sysAuthAreaTransfer"/></p>
<center>
<% if(ISysAuthConstant.IS_AREA_ENABLED) { %>
<div align="left" style="margin-left:10%"><bean:message key="sysAuthAreaTransfer.area.on.title" bundle="sys-authorization" /></div>
<% } else { %>
<div align="left" style="margin-left:10%"><bean:message key="sysAuthAreaTransfer.area.off.title" bundle="sys-authorization" /></div>
<% } %>
<div id="div_main" class="div_main">
<table width="100%" class="tb_normal" cellspacing="1">
	<% if(ISysAuthConstant.IS_AREA_ENABLED) { %>
	<tr>
		<td height="30px" background="<c:url value="/sys/admin/resource/images/bg_blue.gif"/>" class="rd_title">
			<label>
				<bean:message key="sysAuthAreaTransfer.firstStep" bundle="sys-authorization" /><bean:message key="sysAuthAreaTransfer.createOrg" bundle="sys-authorization" />
			</label>
		</td>
	</tr>
	<tr>
		<td>
			<table class="tb_noborder" width="100%">
				<tr>
					<td style="padding: 5px;">
                        <bean:message key="sysAuthAreaTransfer.createOrg.desc" bundle="sys-authorization" arg0="<a href='${KMSS_Parameter_ContextPath}sys/organization/sys_org_dept/sysOrgDept.do?method=list'><b>" arg1="</b></a>" />
					</td>					
				</tr>
			</table>
		</td>
	</tr>		
	<tr>
		<td height="30px" background="<c:url value="/sys/admin/resource/images/bg_blue.gif"/>" class="rd_title">
			<label>
				<bean:message key="sysAuthAreaTransfer.secondStep" bundle="sys-authorization" /><bean:message key="sysAuthAreaTransfer.createArea" bundle="sys-authorization" />
			</label>
		</td>
	</tr>
	<tr>
		<td>
			<table class="tb_noborder" width="100%">
				<tr>
					<td style="padding: 5px;">
                        <bean:message key="sysAuthAreaTransfer.createArea.desc" bundle="sys-authorization" arg0="<a href='${KMSS_Parameter_ContextPath}sys/authorization/sys_auth_area/sysAuthArea_tree.jsp?modelName=com.landray.kmss.sys.authorization.model.SysAuthArea'><b>" arg1="</b></a>" />
					</td>					
				</tr>
			</table>
		</td>
	</tr>		
	<tr>
		<td height="30px" background="<c:url value="/sys/admin/resource/images/bg_blue.gif"/>" class="rd_title">
			<label>
				<bean:message key="sysAuthAreaTransfer.thirdStep" bundle="sys-authorization" /><bean:message key="sysAuthAreaTransfer.initRole" bundle="sys-authorization" />
			</label>
		</td>
	</tr>	
	<tr>
		<td>
			<table class="tb_noborder" width="100%">
				<tr>
					<td style="padding: 5px;">
                        <bean:message key="sysAuthAreaTransfer.initRole.desc1" bundle="sys-authorization" arg0="<a href='#' onclick='Com_OpenWindow(\"${KMSS_Parameter_ContextPath}sys/common/config.do?method=systemInitPage\");'><b>" arg1="</b></a>"/><br>
                        <bean:message key="sysAuthAreaTransfer.initRole.desc2" bundle="sys-authorization" arg0="<a href='#' onclick='Com_OpenWindow(\"${KMSS_Parameter_ContextPath}sys/authorization/sysAuthAreaTransfer.do?method=detectRole\");'><b>" arg1="</b></a>"/>
					</td>			
				</tr>
			</table>
		</td>
	</tr>	
	<tr>
		<td height="30px" background="<c:url value="/sys/admin/resource/images/bg_blue.gif"/>" class="rd_title">
			<label>
				<bean:message key="sysAuthAreaTransfer.fourthStep" bundle="sys-authorization" /><bean:message key="sysAuthAreaTransfer.transfer" bundle="sys-authorization" />
			</label>
		</td>
	</tr>		
	<tr>
		<td>
			<table class="tb_noborder" width="100%">
				<tr>
					<td style="padding: 5px;">
                        <bean:message key="sysAuthAreaTransfer.transfer.desc" bundle="sys-authorization" arg0="<a href='#' onclick='showLoadingDiv();window.location=\"${KMSS_Parameter_ContextPath}sys/authorization/sysAuthAreaTransfer.do?method=select\"'><b>" arg1="</b></a>"/>
					</td>				
				</tr>
			</table>
		</td>
	</tr>
	<% } else { %>
	<tr>
		<td height="30px" background="<c:url value="/sys/admin/resource/images/bg_blue.gif"/>" class="rd_title">
			<label>
				<bean:message key="sysAuthAreaTransfer.initRole" bundle="sys-authorization" />
			</label>
		</td>
	</tr>	
	<tr>
		<td>
			<table class="tb_noborder" width="100%">
				<tr>
					<td style="padding: 5px;">
                        <bean:message key="sysAuthAreaTransfer.initRole.desc1" bundle="sys-authorization" arg0="<a href='#' onclick='Com_OpenWindow(\"${KMSS_Parameter_ContextPath}sys/common/config.do?method=systemInitPage\");'><b>" arg1="</b></a>"/><br>
                        <bean:message key="sysAuthAreaTransfer.initRole.desc2" bundle="sys-authorization" arg0="<a href='#' onclick='Com_OpenWindow(\"${KMSS_Parameter_ContextPath}sys/authorization/sysAuthAreaTransfer.do?method=detectRole\");'><b>" arg1="</b></a>"/>
					</td>						
				</tr>
			</table>
		</td>
	</tr>	
	<% } %>
</table>
</div>
</center>
<html:hidden property="method_GET" />
</html:form>
<% } %>
<%@ include file="/sys/config/resource/view_down.jsp"%>