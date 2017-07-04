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
<kmss:windowTitle subject="${sysPropertyDefineForm.fdName}"
	subjectKey="sys-property:table.sysPropertyDefine"
	moduleKey="sys-property:module.sys.property" />
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/property/sys_property_define/sysPropertyDefine.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('sysPropertyDefine.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/sys/property/sys_property_define/sysPropertyDefine.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysPropertyDefine.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-property" key="table.sysPropertyDefine"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyDefine.fdName"/>
		</td><td  width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
			<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyDefine.enabled"/>
		</td><td   width="35%">
			<xform:radio property="fdStatus">
				<xform:enumsDataSource enumsType="sys_property_define_fd_status" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyDefine.fdType"/>
		</td><td  width="35%">
			<xform:select property="fdType">
				<xform:customizeDataSource className="com.landray.kmss.sys.property.service.spring.SysPropertyDefineType" />
			</xform:select>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyDefine.fdStructureName"/>
		</td><td   width="35%">
			 att_<xform:text property="fdStructureName" style="width:35%"  />
		</td>
		
		
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyDefine.fdDisplayType"/>
		</td><td colspan="3" width="85%">
			<c:out value="${defineMap['displayTypeText']}" />
		</td>
	</tr>
<c:if test="${not empty defineMap['configFile']}">
	<c:import url="${defineMap['configFile']}" charEncoding="UTF-8" />
</c:if>
	<tr<c:if test="${empty sysPropertyDefineForm.fdJspPrev}"> style="display:none"</c:if>>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyDefine.fdJspPrev"/>
		</td><td colspan="3" width="85%">
			<xform:textarea property="fdJspPrev" style="width:85%;height:250px;" /><br />
		</td>
	</tr>
	<tr<c:if test="${empty sysPropertyDefineForm.fdDescription}"> style="display:none"</c:if>>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyDefine.fdDescription"/>
		</td><td colspan="3" width="85%">
			<xform:textarea property="fdDescription" style="width:85%;" /><br />
			(<bean:message bundle="sys-property" key="sysPropertyDefine.fdDescription.note"/>)
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyDefine.fdRemarks"/>
		</td><td colspan="3" width="85%">
			<xform:textarea property="fdRemarks" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysProperty.sysPropertyCategory"/>
		</td><td colspan="3"  width="35%">
			<xform:text property="categoryName" style="width:35%"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyDefine.fdTemplateNames"/>
		</td><td colspan="3" width="85%">
			<c:out value="${sysPropertyDefineForm.fdTemplateNames}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyDefine.docCreator"/>
		</td><td width="35%">
			<c:out value="${sysPropertyDefineForm.docCreatorName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyDefine.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>