<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/km/keydata/project/km_project_category/kmProjectCategory.do">
<div id="optBarDiv">
	<c:if test="${kmProjectCategoryForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmProjectCategoryForm, 'update');">
	</c:if>
	<c:if test="${kmProjectCategoryForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmProjectCategoryForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmProjectCategoryForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="km-keydata-project" key="table.kmProjectCategory"/></p>

<center>


<table
		id="Label_Tabel"
		width="95%" >
		
		<tr LKS_LabelName="<bean:message bundle="sys-simplecategory"
		key="table.sysSimpleCategory" />" >
		<td>
			<table class="tb_normal" width="100%" ${param.styleValue}>
		
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-simplecategory" key="sysSimpleCategory.fdParentName" /></td>
			<td colspan="3"><html:hidden property="fdParentId" /> <html:text
				property="fdParentName" readonly="true" styleClass="inputsgl"
				style="width:90%" /> <a href="#"
				onclick="Dialog_SimpleCategory('${param.fdModelName}','fdParentId','fdParentName',false,null,'01',null,false,'${param.fdId}');">
			<bean:message key="dialog.selectOther" /> </a></td>
		</tr>
		<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectCategory.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-project" key="kmProjectCategory.fdOrder"/>
		</td><td width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
	</tr>
	
	
		
			</table>
		</td>
	</tr>
	
		
		
		<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
			<td>
			<table
				class="tb_normal"
				width=100%>
				<c:import
					url="/sys/right/tmp_right_edit.jsp"
					charEncoding="UTF-8">
					<c:param
						name="formName"
						value="kmProjectCategoryForm" />
					<c:param
						name="moduleModelName"
						value="com.landray.kmss.km.keydata.project.model.KmProjectCategory" />
				</c:import>
			</table>
			</td>
		</tr>
		
	</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();

	Com_IncludeFile("jquery.js|dialog.js");
	

	
	function checkParentId(){
		//debugger;
		var formObj = document.forms['kmProjectCategoryForm'];
		if(formObj.fdParentId.value!="" && formObj.fdParentId.value==formObj.fdId.value){
			alert('<bean:message bundle="sys-simplecategory" key="error.illegalSelected" />');
			return false;
		}else
			return true;	
	}
	Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = checkParentId;

	function Cate_getParentMaintainer(){
		var parameters ="parentId="+document.getElementsByName("fdParentId")[0].value;
		var s_url = Com_Parameter.ContextPath+"km/keydata/km_project_category/kmProjectCategory.do?method=add?method=getParentMaintainer";
		$.ajax({
				url: s_url,
				type: "GET",
				data: parameters,
				dataType:"text",
				async: false,
				success: function(text){
					$(document.getElementById("parentMaintainerId")).text(text);
				}});
	}
	function test(value){
		alert(value);
		alert(document.getElementsByName("fdExecutiveDeptId")[0].value);
		//alert(values.value);
	}
<%-- 
	function openKeydataWindow(propertyId,propertyName,keydataType){
		Dialog_Tree(false, propertyId, propertyName, ',', 'kmProjectMainTreeServiceImp&parentId=!{value}&keydataType='+keydataType, '<bean:message key="dialog.tree.title" bundle="dbcenter-report-cfg"/>', null, function callbackFunc(rtnVal){loadConditionPage(rtnVal);}, '${param.fdId}', null, null, '<bean:message key="dialog.title" bundle="dbcenter-report-cfg"/>');
	}
--%>
	function loadConditionPage(rtnVal){
		return;
		if(rtnVal==null){
			return ;
		}
		var o = rtnVal.GetHashMapArray()[0];
		if(o == null){
			return ;
		}
		
		var idAFlagAType = o["id"].split(";");
		document.getElementsByName("fdReportSettingId")[0].value=idAFlagAType[0];

	}

</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>