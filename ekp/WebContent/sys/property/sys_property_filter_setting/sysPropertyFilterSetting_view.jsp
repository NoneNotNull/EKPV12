<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
function confirmDelete(msg){
	var del = confirm('<bean:message key="page.comfirmDelete"/>');
	return del;
}
</script>
<html:form action="/sys/property/sys_property_filter_setting/sysPropertyFilterSetting.do">
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/property/sys_property_filter_setting/sysPropertyFilterSetting.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('sysPropertyFilterSetting.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/sys/property/sys_property_filter_setting/sysPropertyFilterSetting.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysPropertyFilterSetting.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-property" key="table.sysPropertyFilterSetting2"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdName"/>
		</td><td  >
			<xform:text property="fdName" style="width:85%;"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdIsEnabled"/>
		</td><td  >
			 <xform:radio property="fdIsEnabled">
				<xform:enumsDataSource enumsType="common_yesno_property" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdFilterBean2"/>
		</td><td width="35%">
			<xform:select property="fdFilterBean">
				<xform:customizeDataSource className="com.landray.kmss.sys.property.service.spring.SysPropertyFilterListService" />
			</xform:select>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdDefine"/>
		</td><td width="35%">
			<c:out value='${sysPropertyFilterSettingForm.fdDefineName}' />
		</td>
	</tr>
	<c:if test="${not empty configFile}">
		<c:import url="${configFile}" charEncoding="UTF-8" />
	</c:if>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdTemplateNames"/>
		</td><td colspan="3" width="85%">
			<c:out value="${sysPropertyFilterSettingForm.fdTemplateNames}" />
		</td>
	</tr>
	 
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/view_down.jsp"%>