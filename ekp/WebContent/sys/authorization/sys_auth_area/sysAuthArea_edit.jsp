<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@ page import="com.landray.kmss.sys.authorization.util.OASConfig"%>
<%@ page import="com.landray.kmss.sys.authorization.forms.SysAuthAreaForm"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
Com_IncludeFile("dialog.js");
Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function(){
	var formObj = document.sysAuthAreaForm;
	if(formObj.fdParentId.value!="" && formObj.fdParentId.value==formObj.fdId.value){
		alert("<bean:message bundle="sys-category" key="error.illegalSelected" />");
		return false;
	}
/**	
	var authIds= "";
	var authIdArr = document.getElementsByName("fdAuthAssignId");  
	if(authIdArr.length > 0) {
		for (var i = 0; i < authIdArr.length; i++) {
			if(authIdArr[i].checked) {
				authIds += ";" + authIdArr[i].value;
			}
		}
		if(authIds != "") {
			authIds=authIds.substring(1);
		}
	} 
	document.getElementsByName("authAreaRoleIds")[0].value = authIds;
**/
	var url = "sysAuthAreaService&fdId=${sysAuthAreaForm.fdId}";
	var fdIsAvailable = "true", fdIsAvailableObj = document.getElementsByName("fdIsAvailable");
	for(var i = 0; i < fdIsAvailableObj.length; i++) {
		if(fdIsAvailableObj[i].checked) {
			fdIsAvailable = fdIsAvailableObj[i].value;
			break;
		}
	}
	url += "&fdIsAvailable="+fdIsAvailable;
	
	var authAreaOrgIds = document.getElementsByName("authAreaOrgIds")[0].value;
	if(authAreaOrgIds) { // 校验所属组织
		url += "&authAreaOrgIds="+authAreaOrgIds;
	}
//	if(authIds) { // 校验可分配权限
//		url += "&authAreaRoleIds="+authIds;
//	}

	var fdParentId = document.getElementsByName("fdParentId")[0].value;
	if(fdParentId) { 
		url += "&fdParentId="+fdParentId;
	}
	var fdName = document.getElementsByName("fdName")[0].value;
	if(fdName) { 
		url += "&fdName="+encodeURI(fdName);
	}
	var authAreaAdminIds = document.getElementsByName("authAreaAdminIds")[0].value;
	if(authAreaAdminIds) { 
		url += "&authAreaAdminIds="+authAreaAdminIds;
	}
	var fdOrder = document.getElementsByName("fdOrder")[0].value;
	if(fdOrder) { 
		url += "&fdOrder="+fdOrder;
	}	
	<%
        SysAuthAreaForm sysAuthAreaForm = (SysAuthAreaForm)request.getAttribute("sysAuthAreaForm");
        if(OASConfig.getInstance().isOASEnabled && (ISysAuthConstant.OAS_SYNC_AUTO.equals(sysAuthAreaForm.getFdOasSyncType()) 
    		|| ISysAuthConstant.OAS_SYNC_MANUAL.equals(sysAuthAreaForm.getFdOasSyncType()))) {
    %>	
	var fdOasSyncType = document.getElementsByName("fdOasSyncType")[0].checked;
	if(fdOasSyncType) { 
		var formerSyncType = "${sysAuthAreaForm.fdOasSyncType}";
		if(formerSyncType == '<%=ISysAuthConstant.OAS_SYNC_MANUAL%>') {
			url += "&fdOasSyncType="+<%=ISysAuthConstant.OAS_SYNC_MANUAL%>;   // 用户开启自动同步不校验
		} else {
			url += "&fdOasSyncType="+<%=ISysAuthConstant.OAS_SYNC_AUTO%>;
		}
	} else {
		url += "&fdOasSyncType="+<%=ISysAuthConstant.OAS_SYNC_MANUAL%>;
	}		
    <%
        }
    %>
	
	var data = new KMSSData().AddBeanData(url).GetHashMapArray();
    if (data && data[0]) {
    	if(data[0].key0) {
    		var index = data[0].key0.indexOf("<bean:message bundle="sys-authorization" key="oas.async" />");
    		var msg = data[0].key0.replace("<bean:message bundle="sys-authorization" key="oas.async" />", "");
        	if(index >= 0) {            	
        		if(confirm("<bean:message bundle="sys-authorization" key="oas.async" />")) { 
        			if(msg != null && msg.length > 0){
        			    alert(msg);
        			    return false;
        			}     

        			document.getElementsByName("fdOasSyncType")[0].value = <%=ISysAuthConstant.OAS_SYNC_MANUAL%>;   			
        			return true;
        		}
        		
        		return false;
        	} else {
    			alert(msg);
    			return false;
        	}
		}
	}

	return true;
};
function sysAuthOrgSelect() {
	var parentId = document.getElementsByName("fdParentId")[0].value;
	if(parentId) {
		Dialog_TreeList(true,'authAreaOrgIds','authAreaOrgNames',';','sysAuthAreaOrgTreeService&parent=!{value}&areaId='+parentId,'<bean:message bundle="sys-organization" key="organization.moduleName" />','sysAuthAreaOrgListService&parent=!{value}&areaId='+parentId);
	} else {
		Dialog_Address(true,'authAreaOrgIds','authAreaOrgNames',';',ORG_TYPE_ORGORDEPT);
	}
}
function sysAuthAfterParentChange(data) {
	if(data){
		var dat = data.GetHashMapArray(), url = location.href, parentId = "";
		if(dat && dat[0]){
			parentId = dat[0].id;
		}
		url = Com_SetUrlParameter(url, "parentId", parentId);
		//location.href = url;
		document.getElementsByName("authAreaOrgIds")[0].value = "";
		document.getElementsByName("authAreaOrgNames")[0].value = "";
	}
}
function areaOrg2Visitor() {
	var orgIdField = document.getElementsByName("authAreaOrgIds")[0];
	var orgNameField = document.getElementsByName("authAreaOrgNames")[0];
	var visitorIdField = document.getElementsByName("authAreaVisitorIds")[0];
	var visitorNameField = document.getElementsByName("authAreaVisitorNames")[0];

	//visitorIdField.value = visitorIdField.value + ";" + orgIdField.value;
	//visitorNameField.value = visitorNameField.value + ";" + orgNameField.value;

	visitorIdField.value = rmDulp(visitorIdField.value, orgIdField.value)+ orgIdField.value;
	visitorNameField.value = rmDulp(visitorNameField.value, orgNameField.value) + orgNameField.value;
}

function rmDulp(srcStr, str) {
    var arr = str.split(";");
	
	if(srcStr != null && srcStr.length > 0 && str != null && str.length > 0) {
		srcStr = srcStr + ";";
	}

	for(var i = 0; i < arr.length; i++) {
		if(arr[i] != null && arr[i].length > 0) {
    	    var reg = arr[i] + ";"; 
    	    srcStr = srcStr.replace(reg, ""); 
            reg = ";" + arr[i];
    	    srcStr = srcStr.replace(reg, "");
		}
	}

	return srcStr;
}
</script>
<c:set var="isSysAdmin" value="0"/>
<kmss:authShow roles="ROLE_SYSAUTHROLE_ADMIN;SYSROLE_ADMIN">
	<c:set var="isSysAdmin" value="1"/>
</kmss:authShow>
<html:form action="/sys/authorization/sys_auth_area/sysAuthArea.do">
<div id="optBarDiv">
	<c:if test="${sysAuthAreaForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysAuthAreaForm, 'update');">
	</c:if>
	<c:if test="${sysAuthAreaForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysAuthAreaForm, 'save');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-authorization" key="table.sysAuthArea"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthArea.fdParent"/>
		</td><td width="35%">
			<c:choose>
			<c:when test="${isSysAdmin == '1'}">
				<xform:dialog propertyId="fdParentId" propertyName="fdParentName" style="width: 85%">
					Dialog_Tree(false,'fdParentId','fdParentName',';','sysAuthAreaTreeService&parentId=!{value}','<bean:message bundle="sys-authorization" key="table.sysAuthArea"/>',null,sysAuthAfterParentChange);
				</xform:dialog>
			</c:when>
			<c:otherwise>
				<xform:dialog propertyId="fdParentId" propertyName="fdParentName" style="width: 85%" required="true">
					Dialog_Tree(false,'fdParentId','fdParentName',';','sysAuthAreaTreeService&parentId=!{value}','<bean:message bundle="sys-authorization" key="table.sysAuthArea"/>',null,sysAuthAfterParentChange,null,null,true);
				</xform:dialog>
			</c:otherwise>
			</c:choose>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthArea.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthArea.authAreaAdmin"/>
		</td><td colspan="3" width="85%">
			<xform:address propertyId="authAreaAdminIds" propertyName="authAreaAdminNames" mulSelect="true" orgType="ORG_TYPE_POSTORPERSON|ORG_FLAG_BUSINESSALL" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthArea.authAreaOrg"/>
		</td><td colspan="3" width="85%">
			<xform:dialog propertyId="authAreaOrgIds" propertyName="authAreaOrgNames" style="width: 85%">
				sysAuthOrgSelect();
			</xform:dialog>
		</td>
	</tr>
	<%
	    if(OASConfig.getInstance().isOASEnabled && (ISysAuthConstant.OAS_SYNC_AUTO.equals(sysAuthAreaForm.getFdOasSyncType()) 
	    		|| ISysAuthConstant.OAS_SYNC_MANUAL.equals(sysAuthAreaForm.getFdOasSyncType()))) {
	%>
	    <tr>
		    <td class="td_normal_title" width=15%>
			    <bean:message bundle="sys-authorization" key="sysAuthArea.authAreaRole"/>
		    </td><td width="35%">
                <xform:radio property="fdCreateRole">
				    <xform:enumsDataSource enumsType="common_yesno" />
			    </xform:radio> 		
		    </td>
		    <td class="td_normal_title" width=15%>
			    <bean:message bundle="sys-authorization" key="sysAuthArea.fdOasSyncType"/>
		    </td><td width="35%">
                <xform:radio property="fdOasSyncType">
				    <xform:enumsDataSource enumsType="common_yesno_number" />
			    </xform:radio> 	
		    </td>		
	    </tr>
	<%
	    } else {
	%>    
	    <tr>
		    <td class="td_normal_title" width=15%>
			    <bean:message bundle="sys-authorization" key="sysAuthArea.authAreaRole"/>
		    </td><td colspan="3" width="85%">
                <xform:radio property="fdCreateRole">
				    <xform:enumsDataSource enumsType="common_yesno" />
			    </xform:radio> 					
		    </td>
	    </tr>	
    <% } %>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthArea.authAreaVisitor"/>
		</td><td colspan="3" width="85%">
			<xform:address propertyId="authAreaVisitorIds" propertyName="authAreaVisitorNames" mulSelect="true" orgType="ORG_TYPE_ALL" textarea="true" style="width:85%" />
			<br />
			<bean:message bundle="sys-authorization" key="sysAuthArea.authAreaVisitor.note"/>
			<br />
			<input type=button value="<bean:message bundle="sys-authorization" key="sysAuthArea.addAreaOrg"/>"
			onclick="areaOrg2Visitor();">
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthArea.fdOrder"/>
		</td><td width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthArea.fdIsAvailable"/>
		</td><td width="35%">
			<xform:radio property="fdIsAvailable">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthArea.docCreator"/>
		</td><td width="35%">
			<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthArea.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" showStatus="view" />
		</td>
	</tr>
	<c:if test="${not empty sysAuthAreaForm.docAlterorName}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthArea.docAlteror"/>
		</td><td width="35%">
			<xform:address propertyId="docAlterorId" propertyName="docAlterorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthArea.docAlterTime"/>
		</td><td width="35%">
			<xform:datetime property="docAlterTime" showStatus="view" />
		</td>
	</tr>
	</c:if>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>