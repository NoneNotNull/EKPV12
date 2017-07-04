<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<kmss:windowTitle
	subjectKey="kms-kmtopic:table.kmsKmtopicCategory"
	moduleKey="kms-kmtopic:module.kms.kmtopic" />
<script language="JavaScript">
Com_IncludeFile("dialog.js");

function Cate_getParentMaintainer(){
	var url = Com_Parameter.ContextPath+"kms/kmtopic/kms_kmtopic_category/kmsKmtopicCategory.do?method=getParentMaintainer";
	jQuery.ajax({
		url: url,
		type: 'get',
		dataType: 'html',
		data: {
			'parentId': document.getElementsByName("fdParentId")[0].value
		},
		success: function(data, textStatus, xhr) {
			$(document.getElementById("parentMaintainerId")).text(xhr.responseText);
		},
		error: function(xhr, textStatus, errorThrown) {
			alert(errorThrown);
		}
	});
}

	
</script>
<html:form action="/kms/kmtopic/kms_kmtopic_category/kmsKmtopicCategory.do" 
		onsubmit="return validateKmsKmtopicCategoryForm(this);">
<div id="optBarDiv">
	<c:if test="${kmsKmtopicCategoryForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsKmtopicCategoryForm, 'update');">
	</c:if>
	<c:if test="${kmsKmtopicCategoryForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsKmtopicCategoryForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsKmtopicCategoryForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div> 
<p class="txttitle"><bean:message  bundle="kms-kmtopic" key="table.kmsKmtopicCategory"/></p> 
<center> 
<table id="Label_Tabel" class="tb_normal" width=95%>
	<tr LKS_LabelName="${lfn:message('kms-kmtopic:kmsKmtopicMain.baseInfo') }">
		<td>
		<table class="tb_normal" width="100%"> 
			<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-simplecategory" key="sysSimpleCategory.fdParentName" />
					</td>
					<td colspan="3">
						<html:hidden property="fdParentId" />
						<html:text property="fdParentName" readonly="true" styleClass="inputsgl" style="width:90%" /> 
						<a href="#" onclick="Dialog_SimpleCategory('${param.fdModelName}','fdParentId','fdParentName',false,null,'01',null,true,'${param.fdId}');Cate_getParentMaintainer();">
						<bean:message key="dialog.selectOther" /></a>
					</td>
			</tr>
			<tr> 
			<%--类别名称--%>
			<html:hidden property="fdId"/> 
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmtopic" key="kmsKmtopicCategory.fdName"/>
			</td>
			<td colspan="3" >
				<html:text property="fdName" styleClass="inputsgl"  style="width:50%" />
				<span class="txtstrong">*</span>
			</td>
			<%--属性 --%>
			<c:import url="/sys/property/include/sysPropertyTemplate_select.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsKmtopicCategoryForm" />
				<c:param name="mainModelName" value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" />
			</c:import>
			
			<%--排序号--%>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmtopic" key="kmsKmtopicCategory.fdOrder"/>
			</td>
			<td colspan="3">
				<html:text property="fdOrder"/>
			</td> 
		</tr>  
		
		
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-simplecategory" key="sysSimpleCategory.parentMaintainer" />
			</td>
			<td colspan="3" id="parentMaintainerId">
				${parentMaintainer}
			</td>
		</tr> 
		
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.tempEditorName" /></td>
			<td colspan="3"><html:hidden  property="authEditorIds"/><html:textarea property="authEditorNames" style="width:90%" rows="4" readonly="true" styleClass="inputmul"/>
			<a href="#" onclick="Dialog_Address(true, 'authEditorIds', 'authEditorNames', ';', null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			<div class="description_txt">
			<bean:message	bundle="sys-simplecategory" key="description.main.tempEditor" />
			</div>
			</td>
		</tr>

		<tr>
			<td class="td_normal_title" width=15%><bean:message
				key="model.tempReaderName" /></td>
			<td colspan="3">
			<input type="checkbox" name="authNotReaderFlag" value="${sysSimpleCategoryMain.authNotReaderFlag}" onclick="Cate_CheckNotReaderFlag(this);" 
			<c:if test="${sysSimpleCategoryMain.authNotReaderFlag eq 'true'}">checked</c:if>>
			<bean:message bundle="sys-simplecategory" key="description.main.tempReader.notUse" />
			<div id="Cate_AllUserId">
			<html:hidden  property="authReaderIds"/><html:textarea property="authReaderNames" style="width:90%" rows="4" readonly="true" styleClass="inputmul"/>
			<a href="#" onclick="Dialog_Address(true, 'authReaderIds', 'authReaderNames', ';', null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			<div>
			<div id="Cate_AllUserNote">
			<bean:message bundle="sys-simplecategory" key="description.main.tempReader.allUse" />
			</div>
			</td>
		</tr>
		
		<c:if test="${kmsKmtopicCategoryForm.method_GET=='edit'}">  
			<tr>
				<%---创建者--%>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="kms-kmtopic" key="kmsKmtopicCategory.docCreator"/>
				</td>
				<td width=35%> 
					 <c:out value="${kmsKmtopicCategoryForm.docCreatorName}" />
				</td>
				<%--创建时间--%>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="kms-kmtopic" key="kmsKmtopicCategory.docCreateTime"/>
				</td>
				<td width=35%>
					 <c:out value="${kmsKmtopicCategoryForm.docCreateTime}" />
				</td> 
			</tr>
			<tr>
			<%--最后编辑者--%>
			<td class="td_normal_title" width=15%> 
				<bean:message  bundle="kms-kmtopic" key="kmsKmtopicCategory.docAlterorId"/> 
			</td>
			<td width=35%>
				<c:out value="${kmsKmtopicCategoryForm.docAlterorName}" />
			</td>
			<%--最后编辑时间--%>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmtopic" key="kmsKmtopicCategory.docAlterTime"/>
			</td>
			<td width=35%>
				 <c:out value="${kmsKmtopicCategoryForm.docAlterTime}" />
			</td>
		</tr>  
		</c:if>
		</table> 
	</td>
	</tr>
	
	<c:import url="/sys/workflow/include/sysWfTemplate_edit.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="kmsKmtopicCategoryForm" />
		<c:param name="fdKey" value="kmtopic" />
	</c:import>
	
	<%----发布机制开始--%>
	<c:import url="/sys/news/include/sysNewsPublishCategory_edit.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmsKmtopicCategoryForm" />
		<c:param name="fdKey" value="kmtopic" /> 
		<c:param name="messageKey"
				value="kms-kmtopic:kmsKmtopicCategory.lbl.publish" />
	</c:import>
	<%----发布机制结束--%>
		
	<%----权限--%>
	<tr LKS_LabelName="${lfn:message('kms-kmtopic:kmsKmtopicCategory.setRight')}">
		<td>
			<table
				class="tb_normal"
				width=100%>
				<c:import
					url="/sys/right/tmp_right_edit.jsp"
					charEncoding="UTF-8">
					<c:param
						name="formName"
						value="kmsKmtopicCategoryForm" />
					<c:param
						name="moduleModelName"
						value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicCategory" />
				</c:import>
			</table>
		</td>
	</tr>
	
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript
	formName="kmsKmtopicCategoryForm"
	cdata="false"
	dynamicJavascript="true"
	staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>
