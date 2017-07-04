<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="kmsFtsearchConfig_edit_js.jsp"%>
<html:form action="/kms/common/kms_ftsearch_config/kmsFtsearchConfig.do">
<div id="optBarDiv">
	<c:if test="${kmsFtsearchConfigForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsFtsearchConfigForm, 'update');">
	</c:if>
	<c:if test="${kmsFtsearchConfigForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsFtsearchConfigForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsFtsearchConfigForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-common" key="table.kmsFtsearchConfig"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsFtsearchConfig.docSubject"/>
		</td>
		<td width="35%">
			<xform:text property="docSubject" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsFtsearchConfig.fdIsDefaultSearch"/>
		</td><td width="85%">
			<xform:checkbox property="fdIsDefault">
				<xform:simpleDataSource value="true"><bean:message key="message.yes"/></xform:simpleDataSource>
			</xform:checkbox>
		</td>
	</tr>
	
	<tr>
		<td colspan="4" class="td_normal_title" style="text-align: center">
			<strong>搜索范围设置</strong>
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15% >
			模块范围
		</td>
		<td width="85%" colspan="3" id="moduleRange">
			<c:forEach var="module" items="${ftSearchModuleRange }">
				<span data-module-range="data_module_range_div">
					<input type="checkbox" value="${module.value }" ${module.isChecked?'checked="checked"':'' }>${ module.moduleTitle}
				</span>
			</c:forEach>
		</td>
	</tr>
	
	<tr>
		<td colspan="4" class="td_normal_title" style="text-align: center" >
			<strong>模块分类范围设置</strong>
		</td>
	</tr>
	
	<tr>
		<td width="100%" colspan="4" id="categoryRange">
			<table class="tb_noborder">
				<tr>
					<td>
						<c:forEach var="module" items="${ftSearchCategoryRange }">
							<div moduleId="${module.value }" moduleTitle=${module.moduleTitle } style="float: left;padding: 0 30px" data-category-range="data-category-range-div" class="treediv">
							</div>
						</c:forEach>
					</td>				
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td colspan="4" class="td_normal_title" style="text-align: center">
			<strong>扩展属性范围设置</strong>&nbsp&nbsp<a style="cursor: pointer;color: #3399cc;" id="propertySelect">+选择属性</a>
		</td>
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
<html:hidden property="moduleContent" />
<html:hidden property="categoryContent" />
<html:hidden property="propertyContent" />
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("calendar.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>