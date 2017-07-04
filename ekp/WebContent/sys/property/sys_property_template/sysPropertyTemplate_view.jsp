<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<kmss:windowTitle
	subject="${sysPropertyTemplateForm.fdName}"
	subjectKey="sys-property:table.sysPropertyTemplate"
	moduleKey="sys-property:module.sys.property" />
<script>
	function confirmDelete(msg){
		var del = confirm('<bean:message key="page.comfirmDelete"/>');
		return del;
	}
	Com_AddEventListener(window,'load',function(){
		try{
			var arguObj = document.getElementsByTagName("table")[0];
			if(arguObj!=null && window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
				window.frameElement.style.height = (arguObj.offsetHeight+60) + "px" ;
			}
		}catch (e) {}});
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/property/sys_property_template/sysPropertyTemplate.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('sysPropertyTemplate.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/sys/property/sys_property_template/sysPropertyTemplate.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysPropertyTemplate.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-property" key="table.sysPropertyTemplate"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyTemplate.fdName"/>
		</td><td colspan="3" width="85%">
			<xform:text property="fdName" style="width:85%" />
			<xform:text property="fdModelName" showStatus="noShow" />
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
			<bean:message bundle="sys-property" key="table.sysPropertyReference"/>
		</td><td colspan="3" width="85%">
			<table class="tb_normal" width=100% id="TABLE_DocList">
				<tr align="center">
					<td class="td_normal_title" width="20%">
						<bean:message bundle="sys-property" key="table.sysPropertyDefine"/>
					</td>
					<td class="td_normal_title" width="20%">
						<bean:message bundle="sys-property" key="sysPropertyReference.fdDisplayName"/>
					</td>
					<td class="td_normal_title" width="20%">
						<bean:message bundle="sys-property" key="sysPropertyReference.fdParentName"/>
					</td>
					<td class="td_normal_title" width="10%">
						<bean:message bundle="sys-property" key="sysPropertyReference.fdIsNotNull"/>
					</td>
					 
				</tr>
				<c:forEach items="${sysPropertyTemplateForm.fdReferenceForms}" var="sysPropertyReferenceForm" varStatus="vstatus">
					<tr KMSS_IsContentRow="1">
						<td>
							<input type="hidden" name="fdReferenceForms[${vstatus.index}].fdId" value="${sysPropertyReferenceForm.fdId}" />
							<input type="hidden" name="fdReferenceForms[${vstatus.index}].fdTemplateId" value="${sysPropertyReferenceForm.fdTemplateId}" />
							<input type="hidden" name="fdReferenceForms[${vstatus.index}].fdDefineId" value="${sysPropertyReferenceForm.fdDefineId}" ref="fdDefineId" />
						    <xform:text property="fdReferenceForms[${vstatus.index}].fdDefineName" />
						</td>
						<td>
							<xform:text property="fdReferenceForms[${vstatus.index}].fdDisplayName" style="width:85%" required="true" />
						</td>
						<td>
							<xform:text property="fdReferenceForms[${vstatus.index}].fdParentName" style="width:85%" required="true" />
						</td>
						<td>
							<center>
							<xform:checkbox property="fdReferenceForms[${vstatus.index}].fdIsNotNull">
								<xform:simpleDataSource value="true" textKey="message.yes" />
							</xform:checkbox>
							</center>
						</td>
						 
					</tr>						
				</c:forEach>
			</table>
			<div style="color:red;padding-top:5px"><bean:message bundle="sys-property" key="sysPropertyTemplate.selectDefine.note" /></div>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="table.sysPropertyFilter"/>
		</td><td colspan="3" width="85%">
			<table class="tb_normal" width=100% id="TABLE_DocList">
				<tr align="center">
					<td class="td_normal_title" width="43%">
						<bean:message bundle="sys-property" key="sysPropertyFilter.fdFilterSetting"/>
					</td>
					<td class="td_normal_title" width="57%">
						<bean:message bundle="sys-property" key="sysPropertyFilter.fdName"/>
					</td>
					 
				</tr>
				<c:forEach items="${sysPropertyTemplateForm.fdFilterForms}" var="sysPropertyFilterForm" varStatus="vstatus">
					<tr KMSS_IsContentRow="1">
						<td>
							<input type="hidden" name="fdFilterForms[${vstatus.index}].fdId" value="${sysPropertyFilterForm.fdId}" />
							<input type="hidden" name="fdFilterForms[${vstatus.index}].fdTemplateId" value="${sysPropertyFilterForm.fdTemplateId}" />
							<input type="hidden" name="fdFilterForms[${vstatus.index}].fdFilterSettingId" value="${sysPropertyFilterForm.fdFilterSettingId}" ref="fdFilterSettingId" />
						    <xform:text property="fdFilterForms[${vstatus.index}].fdFilterSettingName" style="border:0px; color:black;" />
						</td>
						<td>
							<xform:text property="fdFilterForms[${vstatus.index}].fdName" style="width:85%" required="true" />
						</td>
						 
					</tr>						
				</c:forEach>
			</table>
			<br />图例：<br />
			<img src="${KMSS_Parameter_ContextPath}sys/property/define/images/selectFilter.jpg" border="0" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyTemplate.belongModelName"/>
		</td><td colspan="3" width="85%">
			<c:out value="${sysPropertyTemplateForm.modelDisplayName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyTemplate.fdLastModify"/>
		</td><td colspan="3" width="85%">
			<xform:datetime property="fdLastModify" showStatus="view" />
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