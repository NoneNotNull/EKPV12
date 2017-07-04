<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function sysAuthConfirm(msg){
	var del = confirm('<bean:message bundle="sys-authorization" key="sysAuthArea.invalidate.comfirm"/>');
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/authorization/sys_auth_area/sysAuthArea.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('sysAuthArea.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/sys/authorization/sys_auth_area/sysAuthArea.do?method=invalidate&fdId=${param.fdId}" requestMethod="GET">
		<c:if test="${sysAuthAreaForm.fdIsAvailable}">
		<input type="button"
			value="<bean:message bundle="sys-authorization" key="sysAuthArea.invalidate"/>"
			onclick="if(!sysAuthConfirm())return;Com_OpenWindow('sysAuthArea.do?method=invalidate&fdId=${param.fdId}','_self');">
		</c:if>	
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-authorization" key="table.sysAuthArea"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthArea.fdParent"/>
		</td><td width="35%">
			<xform:dialog propertyId="fdParentId" propertyName="fdParentName" style="width: 85%">
				Dialog_Tree(false,'fdParentId','fdParentName',';','sysAuthAreaTreeService&parentId=!{value}','<bean:message bundle="sys-authorization" key="table.sysAuthArea"/>',null,sysAuthAfterParentChange,'${param.fdId}');
			</xform:dialog>
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
			<xform:address propertyId="authAreaAdminIds" propertyName="authAreaAdminNames" mulSelect="true" orgType="ORG_TYPE_PERSON" style="width:85%" />
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
	<c:choose>
	    <c:when test="${sysAuthAreaForm.fdOasSyncType == ISysAuthConstant.OAS_SYNC_AUTO || sysAuthAreaForm.fdOasSyncType == ISysAuthConstant.OAS_SYNC_MANUAL}"> 
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
	    </c:when> 
	    <c:otherwise>
	        <tr>
		        <td class="td_normal_title" width=15%>
			        <bean:message bundle="sys-authorization" key="sysAuthArea.authAreaRole"/>
		        </td><td colspan="3" width="85%">
                    <xform:radio property="fdCreateRole">
				        <xform:enumsDataSource enumsType="common_yesno" />
			        </xform:radio> 					
		        </td>
	        </tr>	
	    </c:otherwise>
	</c:choose>	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthArea.authAreaVisitor"/>
		</td><td colspan="3" width="85%">
			<xform:address propertyId="authAreaVisitorIds" propertyName="authAreaVisitorNames" mulSelect="true" orgType="ORG_TYPE_ALL" textarea="true" style="width:85%" />
			<br />
			<bean:message bundle="sys-authorization" key="sysAuthArea.authAreaVisitor.note"/>
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
<%@ include file="/resource/jsp/view_down.jsp"%>