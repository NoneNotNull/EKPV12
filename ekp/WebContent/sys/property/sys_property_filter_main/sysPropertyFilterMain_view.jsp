<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<kmss:windowTitle
	subject="${kmsMultidocFilterMainForm.fdName}"
	subjectKey="sys-property:table.sysPropertyTemplate"
	moduleKey="sys-property:module.sys.property" />
<script>
	function confirmDelete(msg){
		var del = confirm('<bean:message key="page.comfirmDelete"/>');
		return del;
	}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/property/sys_property_filter_main/sysPropertyFilterMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('sysPropertyFilterMain.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/sys/property/sys_property_filter_main/sysPropertyFilterMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysPropertyFilterMain.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-property" key="table.sysPropertyFilterMain" /></p>
 
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyTemplate.fdName"/>
		</td><td   width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyFilterMain.fdOrder" />
		</td><td  width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		 
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyFilterMain.fdRemark" />
		</td><td   width="35%">
			<xform:text property="fdRemark" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdIsEnabled"/>
		</td><td   >
			<xform:radio property="fdIsEnabled">
				<xform:enumsDataSource enumsType="common_yesno_property" />
			</xform:radio>
		</td>
	</tr>   
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="table.sysPropertyFilter"/>
		</td><td colspan="3" width="85%">
			<table class="tb_normal" width=100% id="TABLE_DocList">
				<tr align="center">
				     <td class="td_normal_title" width="5%">
						 <bean:message key="page.serial"/>
					</td>
					<td class="td_normal_title" width="36%">
						<bean:message bundle="sys-property" key="sysPropertyFilter.fdFilterSetting"/>
					</td>
					<td class="td_normal_title" width="59%">
						<bean:message bundle="sys-property" key="sysPropertyFilter.fdName"/>
					</td>
					 
				</tr>
				<c:forEach items="${sysPropertyFilterMainForm.fdFilterForms}" var="sysFilterConfigForm" varStatus="vstatus">
					<tr KMSS_IsContentRow="1">
					<td>
					       <xform:text property="fdFilterForms[${vstatus.index}].fdOrder" value="${sysFilterConfigForm.fdOrder}"  />
					</td>
						<td>
							<input type="hidden" name="fdFilterForms[${vstatus.index}].fdId" value="${sysFilterConfigForm.fdId}" />
							<input type="hidden" name="fdFilterForms[${vstatus.index}].fdMainId" value="${sysFilterConfigForm.fdMainId}" />
							<input type="hidden" name="fdFilterForms[${vstatus.index}].fdFilterSettingId" value="${sysFilterConfigForm.fdFilterSettingId}" ref="fdFilterSettingId" />
						    <xform:text property="fdFilterForms[${vstatus.index}].fdFilterSettingName" style="border:0px; color:black;" />
						</td>
						<td>
							<xform:text property="fdFilterForms[${vstatus.index}].fdName" style="width:85%" required="true" />
						</td>
						 
					</tr>						
				</c:forEach>
			</table>
			 
		</td>
	</tr>
	 
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyTemplate.docCreator"/>
		</td><td width="35%">
			<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyTemplate.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" showStatus="view" />
		</td>
	</tr>
</table>
</center>
 
<%@ include file="/resource/jsp/view_down.jsp"%>