<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
<!--
	function checkParentId(){
		var formObj = document.sysCategoryOrgTreeForm;
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
	action="/sys/category/sys_category_org_tree/sysCategoryOrgTree.do"
	onsubmit="return validateSysCategoryOrgTreeForm(this);">
	<div id="optBarDiv"><c:if
		test="${sysCategoryOrgTreeForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysCategoryOrgTreeForm, 'update');">
	</c:if> <c:if test="${sysCategoryOrgTreeForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysCategoryOrgTreeForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysCategoryOrgTreeForm, 'saveadd');">		
	</c:if> <input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>

	<p class="txttitle"><bean:message bundle="sys-category"
		key="table.sysCategoryOrgTree" /><bean:message key="button.edit" /></p>

	<center>
	<table class="tb_normal" width=95%>
		<html:hidden property="fdId" />
		<c:set var="selectEmpty" value="true"/>
		<kmss:auth requestURL="/sys/category/sys_category_org_tree/sysCategoryOrgTree.do?method=add" requestMethod="Get">
			<c:set var="selectEmpty" value="false"/>
		</kmss:auth>		
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-category" key="sysCategoryOrgTree.fdParentName" /></td>
			<td colspan="3">
			<html:hidden property="fdParentId"/>
			<html:text style="width:90%" property="fdParentName" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="cate_selectedOrgTree(null,null,null,null,${selectEmpty});">
				<bean:message key="dialog.selectOther"/>
			</a>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-category" key="sysCategoryOrgTree.fdName" /></td>
			<td colspan="3"><html:text property="fdName" size="40"/><span class="txtstrong">*</span></td>		
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-category" key="sysCategoryOrgTree.fdOrgName" /></td>
			<td colspan="3"><html:hidden property="fdOrgIds" /> 
			<html:text property="fdOrgNames" readonly="true" style="width:90%"  styleClass="inputsgl"/>
			<span class="txtstrong">*</span>
			<a href="#" onclick="Dialog_Address(true, 'fdOrgIds', 'fdOrgNames', ';', ORG_TYPE_ORGORDEPT|ORG_FLAG_BUSINESSALL);">
				<bean:message key="dialog.selectOrg"/>
			</a></td>
		</tr>		
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdOrder" /></td>
			<td colspan="3"><html:text property="fdOrder" /></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.tempEditorName" /></td>
			<td colspan="3"><html:hidden  property="authEditorIds"/><html:textarea property="authEditorNames" style="width:90%" rows="4" readonly="true" styleClass="inputmul"/>
			<a href="#" onclick="Dialog_Address(true, 'authEditorIds', 'authEditorNames', ';', null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			<div class="description_txt">
			<bean:message	bundle="sys-category" key="description.orgTree.tempEditor" />
			</div>			
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.tempReaderName" /></td>
			<td colspan="3"><html:hidden  property="authReaderIds"/><html:textarea property="authReaderNames" readonly="true"  style="width:90%" rows="4" styleClass="inputmul"/>
			<a href="#" onclick="Dialog_Address(true, 'authReaderIds', 'authReaderNames', ';', null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			<div class="description_txt">
			<bean:message	bundle="sys-category" key="description.orgTree.tempReader" />
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
		<c:if test="${sysCategoryOrgTreeForm.method_GET!='add'}">
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdCreator" /></td>
			<td width=35%><bean:write name="sysCategoryOrgTreeForm" property="docCreatorName"/></td>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdCreateTime" /></td>
			<td width=35%><bean:write name="sysCategoryOrgTreeForm" property="docCreateTime"/></td>			
		</tr>
		<c:if test="${sysCategoryOrgTreeForm.docAlterorName!=''}">
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.docAlteror" /></td>
			<td width=35%><bean:write name="sysCategoryOrgTreeForm" property="docAlterorName"/></td>
			<td class="td_normal_title" width=15%><bean:message
				key="model.fdAlterTime" /></td>
			<td width=35%><bean:write name="sysCategoryOrgTreeForm" property="docAlterTime"/></td>
		</tr>
		</c:if>
		</c:if>
	</table>
	</center>
	<html:hidden property="method_GET" />
</html:form>
<script>Com_IncludeFile("dialog.js");</script>
<html:javascript formName="sysCategoryOrgTreeForm" cdata="false"
	dynamicJavascript="true" staticJavascript="false" />
<%@ include file="/sys/category/sysCategoryDialog_script.jsp"%>
<%@ include file="/resource/jsp/edit_down.jsp"%>
