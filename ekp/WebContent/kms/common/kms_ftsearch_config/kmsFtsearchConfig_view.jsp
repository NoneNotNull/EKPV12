<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@ include file="kmsFtsearchConfig_view_js.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv"><kmss:auth
	requestURL="/kms/common/kms_ftsearch_config/kmsFtsearchConfig.do?method=edit&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('kmsFtsearchConfig.do?method=edit&fdId=${param.fdId}','_self');">
</kmss:auth> <kmss:auth
	requestURL="/kms/common/kms_ftsearch_config/kmsFtsearchConfig.do?method=delete&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('kmsFtsearchConfig.do?method=delete&fdId=${param.fdId}','_self');">
</kmss:auth> <input type="button" value="<bean:message key="button.close"/>"
	onclick="Com_CloseWindow();">
	<c:if test="${kmsFtsearchConfigForm.fdIsDefault=='false' || empty kmsFtsearchConfigForm.fdIsDefault}">
	<input type="button"
			value="<bean:message bundle="kms-common" key="kmsFtsearchConfig.fdIsDefault.button"/>"
			onclick="Com_OpenWindow('kmsFtsearchConfig.do?method=setDefault&fdId=${param.fdId}&fdIsSetDefault=true','_self');">
	</c:if>
	<c:if test="${kmsFtsearchConfigForm.fdIsDefault=='true'}" >		
	<input type="button"
			value="<bean:message bundle="kms-common" key="kmsFtsearchConfig.fdCancleDefault.button"/>"
			onclick="Com_OpenWindow('kmsFtsearchConfig.do?method=setDefault&fdId=${param.fdId}&fdIsSetDefault=false','_self');">
	</c:if>
	</div>
<p class="txttitle"><bean:message bundle="kms-common"
	key="table.kmsFtsearchConfig" /></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="kms-common" key="kmsFtsearchConfig.docSubject" /></td>
		<td width="35%"><xform:text property="docSubject"
			style="width:85%" /></td>
		<td class="td_normal_title" width=15%><bean:message
			bundle="kms-common" key="kmsFtsearchConfig.docCreateTime" /></td>
		<td width="35%"><xform:datetime property="docCreateTime" /></td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="kms-common" key="kmsFtsearchConfig.docAlterTime" /></td>
		<td width="35%"><xform:datetime property="docAlterTime" /></td>
		<td class="td_normal_title" width=15%><bean:message
			bundle="kms-common" key="kmsFtsearchConfig.fdLastModifiedTime" /></td>
		<td width="35%"><xform:datetime property="fdLastModifiedTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsFtsearchConfig.fdIsDefaultSearch"/>
		</td><td width="85%" colspan="3">
			<c:choose>
				<c:when test="${kmsFtsearchConfigForm.fdIsDefault=='true'}">
					<bean:message key="message.yes"/>
				</c:when>
				<c:otherwise>
					<bean:message key="message.no"/>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>

	<tr>
		<td colspan="4" class="td_normal_title" align="center">搜索范围设置</td>
	</tr>

	<tr>
		<td class="td_normal_title" width=15%>模块范围</td>
		<td width="85%" colspan="3" id="moduleRange"><c:forEach
			var="module" items="${ftSearchModuleRange }">
			<span data-module-range="data_module_range_div"> <input
				type="checkbox" value="${module.value }" ${module.isChecked?'checked="checked"':'' } disabled="disabled">${ module.moduleTitle} </span>
		</c:forEach></td>
	</tr>

	<tr>
		<td colspan="4" class="td_normal_title" align="center">模块分类范围设置</td>
	</tr>

	<tr>
		<td width="100%" colspan="4" id="categoryRange">
		<table class="tb_noborder">
			<tr>
				<td><c:forEach var="module" items="${ftSearchCategoryRange }">
					<div id="${module.value }" moduleTitle="${module.moduleTitle }"
						style="float: left; padding: 0 30px"
						data-category-range="data-category-range-div" class="treediv">


					</div>
				</c:forEach></td>
			</tr>
		</table>
		</td>
	</tr>

	<tr>
		<td colspan="4" class="td_normal_title" align="center">扩展属性范围设置</td>
	</tr>

	<tr>
		<td width="100%" colspan="4" id="propertyRange">

		<table class="tb_noborder">
			<tr>
				<td id="treeview" data-property-range="data-property-range-div">
				
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>