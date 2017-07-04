<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ page import="java.util.Set" %>
<%@ page import="com.landray.kmss.sys.config.dict.SysDataDict" %>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>	
<%
	String fdModelName = request.getParameter("fdModelName");
	Set propertyNameSet =  SysDataDict.getInstance().getModel(fdModelName).getPropertyMap().keySet();
%>
<c:set var="sysSimpleCategoryMain" value="${requestScope[param.formName]}" />

		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-simplecategory" key="sysSimpleCategory.fdParentName" /></td>
			<td colspan="3"><bean:write name="sysSimpleCategoryMain" property="fdParentName"/></td>
		</tr>		
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-simplecategory" key="sysSimpleCategory.fdName" /></td>
			<td colspan="3"><bean:write name="sysSimpleCategoryMain" property="fdName"/></td>
		</tr>

		<% if(propertyNameSet.contains("docProperties")){ %>
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="sys-category" key="menu.sysCategory.property" /></td>
				<td colspan="3"><bean:write name="sysSimpleCategoryMain"
					property="docPropertyNames" /></td>
			</tr>
		<%} %>
		
		<% if(propertyNameSet.contains("authArea") && ISysAuthConstant.IS_AREA_ENABLED){ %>
		<%-- 所属场所 --%>
		<td class="td_normal_title" width="15%">
			<bean:message key="sysAuthArea.authArea" bundle="sys-authorization" />
		</td>
		<td colspan="3">
		    <c:out value="${sysSimpleCategoryMain.authAreaName}" />
		</td>
		<%} %>

		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdOrder" /></td>
			<td colspan="3"><bean:write name="sysSimpleCategoryMain" property="fdOrder"/></td>
		</tr>
		
		<tr>
			<td class="td_normal_title" width=15%><bean:message bundle="sys-simplecategory"
				key="sysSimpleCategory.parentMaintainer" /></td>
			<td colspan="3" id="parentMaintainerId">${parentMaintainer}</td>
		</tr>
		
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.tempEditorName" /></td>
			<td colspan="3"><bean:write name="sysSimpleCategoryMain" property="authEditorNames"/></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.tempReaderName" /></td>
			<td colspan="3"><bean:write name="sysSimpleCategoryMain" property="authReaderNames"/></td>
		</tr>
		<tr style="display:none">
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-simplecategory" key="sysSimpleCategory.fdIsinheritMaintainer" /></td>
			<td width=35%>
			<sunbor:enumsShow value="${sysSimpleCategoryMain.fdIsinheritMaintainer}" enumsType="common_yesno" />
			</td>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-simplecategory" key="sysSimpleCategory.fdIsinheritUser" /></td>
			<td width=35%>
			<sunbor:enumsShow value="${sysSimpleCategoryMain.fdIsinheritUser}" enumsType="common_yesno" />
			</td>			
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdCreator" /></td>
			<td width=35%><bean:write name="sysSimpleCategoryMain" property="docCreatorName"/></td>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdCreateTime" /></td>
			<td width=35%><bean:write name="sysSimpleCategoryMain" property="docCreateTime"/></td>			
		</tr>
		<c:if test="${sysSimpleCategoryMain.docAlterorName!=''}">
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.docAlteror" /></td>
			<td width=35%><bean:write name="sysSimpleCategoryMain" property="docAlterorName"/></td>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdAlterTime" /></td>
			<td width=35%><bean:write name="sysSimpleCategoryMain" property="docAlterTime"/></td>
		</tr>
		</c:if>
