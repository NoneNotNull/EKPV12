<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
<!--
	function checkParentId(){
		formObj = sysCategoryPropertyForm;
		if(formObj.fdParentId.value!="" && formObj.fdParentId.value==formObj.fdId.value){
			alert("<bean:message bundle="sys-category" key="error.illegalSelected" />");
			return false;
		}else
			return true;	
	}
	Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = checkParentId;
//-->
</script>
<html:form
	action="/sys/category/sys_category_property/sysCategoryProperty.do"
	onsubmit="return validateSysCategoryPropertyForm(this);">
	<div id="optBarDiv"><c:if
		test="${sysCategoryPropertyForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysCategoryPropertyForm, 'update');">
	</c:if> <c:if test="${sysCategoryPropertyForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysCategoryPropertyForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysCategoryPropertyForm, 'saveadd');">
	</c:if> <input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>

	<p class="txttitle"><bean:message bundle="sys-category"
		key="table.sysCategoryProperty" /></p>

	<center>
	<table class="tb_normal" width=95%>
		<html:hidden property="fdId" />
		<c:set var="selectEmpty" value="true"/>
		<kmss:auth requestURL="/sys/category/sys_category_property/sysCategoryProperty.do?method=add" requestMethod="Get">
			<c:set var="selectEmpty" value="false"/>
		</kmss:auth>			
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-category" key="sysCategoryProperty.fdParentName" /></td>
			<td colspan="3"><html:hidden property="fdParentId" /> 
			<html:text property="fdParentName" readonly="true" styleClass="inputsgl" style="width:90%"/>
			<a href="#" onclick="Dialog_property(false,'fdParentId','fdParentName',null,'01',null,${selectEmpty},'${param.fdId}');">
				<bean:message key="dialog.selectOther"/>
			</a>
			</td>
		</tr>			
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-category" key="sysCategoryProperty.fdName" /></td>
			<td colspan="3"><html:text property="fdName" /> <span	class="txtstrong">*</span></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdOrder" /></td>
			<td colspan="3"><html:text property="fdOrder" /></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.tempEditorName" /></td>
			<td colspan="3"><html:hidden  property="authEditorIds"/><html:textarea property="authEditorNames" style="width:90%" readonly="true" styleClass="inputmul" rows="4"/>
			<a href="#" onclick="Dialog_Address(true, 'authEditorIds', 'authEditorNames', ';', null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			<div class="description_txt">
			<bean:message	bundle="sys-category" key="description.property.tempEditor" />
			</div>			
			</td>
		</tr>
		<tr  style="display:none">
			<td class="td_normal_title" width=15%><bean:message
				key="model.tempReaderName" /></td>
			<td colspan="3"><html:hidden  property="authReaderIds"/><html:textarea property="authReaderNames" style="width:90%" rows="4" readonly="true" styleClass="inputmul"/>
			<a href="#" onclick="Dialog_Address(true, 'authReaderIds', 'authReaderNames', ';', null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			<div class="description_txt">
			<bean:message	bundle="sys-category" key="description.property.tempReader" />
			</div>			
			</td>
		</tr>
		<tr  style="display:none">
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-category" key="sysCategory.fdIsinheritMaintainer" /></td>
			<td width=35%>
			<sunbor:enums property="fdIsinheritMaintainer" enumsType="common_yesno" elementType="radio" />
			</td>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-category" key="sysCategory.fdIsinheritUser" /></td>
			<td width=35%>
				<sunbor:enums property="fdIsinheritUser" enumsType="common_yesno" elementType="radio" />
			</td>			
		</tr>
		<c:if test="${sysCategoryPropertyForm.method_GET!='add'}">
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdCreator" /></td>
			<td width=35%><bean:write name="sysCategoryPropertyForm" property="docCreatorName"/></td>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdCreateTime" /></td>
			<td width=35%><bean:write name="sysCategoryPropertyForm" property="docCreateTime"/></td>			
		</tr>
		<c:if test="${sysCategoryPropertyForm.docAlterorName!=''}">
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.docAlteror" /></td>
			<td width=35%><bean:write name="sysCategoryPropertyForm" property="docAlterorName"/></td>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdAlterTime" /></td>
			<td width=35%><bean:write name="sysCategoryPropertyForm" property="docAlterTime"/></td>
		</tr>
		</c:if>
		</c:if>		
	</table>
	</center>
	<html:hidden property="method_GET" />
</html:form>
<script>Com_IncludeFile("dialog.js");</script>
<html:javascript formName="sysCategoryPropertyForm" cdata="false"
	dynamicJavascript="true" staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>
