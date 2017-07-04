<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<kmss:windowTitle
	subjectKey="kms-kmaps:table.kmsMapsCategory"
	moduleKey="kms-kmaps:kmsKmapsMain.mapTemplate" />
<script language="JavaScript">
Com_IncludeFile("dialog.js");

function Cate_getParentMaintainer(){
	var url = Com_Parameter.ContextPath+"kms/kmaps/kms_kmaps_templ_category/kmsKmapsTemplCategory.do?method=getParentMaintainer";
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
<html:form action="/kms/kmaps/kms_kmaps_templ_category/kmsKmapsTemplCategory.do"
		onsubmit="return validateKmsKmapsTemplCategoryForm(this);">
<div id="optBarDiv">
	<c:if test="${kmsKmapsTemplCategoryForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsKmapsTemplCategoryForm, 'update');">
	</c:if>
	<c:if test="${kmsKmapsTemplCategoryForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsKmapsTemplCategoryForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsKmapsTemplCategoryForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div> 
<p class="txttitle"><bean:message  bundle="kms-kmaps" key="table.kmsKmapsTemplateCategory"/></p> 
<center> 
<table id="Label_Tabel" class="tb_normal" width=95%>
	<tr LKS_LabelName="${lfn:message('kms-kmaps:kmsKmapsMain.baseInfo') }">
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
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.fdName"/>
			</td>
			<td width=35% >
				<html:text property="fdName" styleClass="inputsgl"  style="width:50%" />
				<span class="txtstrong">*</span>
			</td>
			<%--排序号--%>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.fdOrder"/>
			</td>
			<td width=35%>
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
		<%--类别可维护者--%>
		<tr>  
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.authEditorIds"/> 
			</td>
			<td width=35% colspan="3">  
				<html:hidden  property="authEditorIds"/>
				<html:textarea property="authEditorNames" style="width:85%" rows="4" readonly="true" styleClass="inputmul"/>
				<a href="#" onclick="Dialog_Address(true, 'authEditorIds', 'authEditorNames', ';', ORG_TYPE_POSTORPERSON);">
					<bean:message  key="dialog.selectOrg"/>
				</a>	
				<br>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.authEditor.tip"/>
			</td> 
		</tr>  
		<%--类别可使用者--%>
		<tr>  
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.authReaderIds"/> 
			</td>
			<td width=35% colspan="3">  
				<html:hidden  property="authReaderIds"/>
				<html:textarea property="authReaderNames" style="width:85%" rows="4" readonly="true" styleClass="inputmul"/>
				<a href="#" onclick="Dialog_Address(true, 'authReaderIds', 'authReaderNames', ';', ORG_TYPE_ALL);">
					<bean:message  key="dialog.selectOrg"/>
				</a>
				<br>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.authReader.tip"/>
			</td> 
		</tr>  
		<%-- 
		<tr>  
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.authTmpEditorIds"/> 
			</td>
			<td width=35% colspan="3">  
				<html:hidden property="authTmpEditorIds" />
				<html:textarea property="authTmpEditorNames" style="width:85%" rows="4" readonly="true" styleClass="inputmul"/>
				<a href="#" onclick="Dialog_Address(true, 'authTmpEditorIds','authTmpEditorNames', ';',ORG_TYPE_ALL);">
					<bean:message key="dialog.selectOrg"/>
				</a>
				<br>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.authTmpEditorIds.tip"/>	
			</td> 
		</tr> 
		<tr>  
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.authTmpReaderIds"/> 
			</td>
			<td width=35% colspan="3">  
				<html:hidden property="authTmpReaderIds" />
				<html:textarea property="authTmpReaderNames" style="width:85%" rows="4" readonly="true" styleClass="inputmul"/>
				<a href="#" onclick="Dialog_Address(true, 'authTmpReaderIds','authTmpReaderNames', ';',ORG_TYPE_ALL);">
					<bean:message key="dialog.selectOrg"/>
				</a>
				<br>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.authTmpReaderIds.tip"/>	
			</td> 
		</tr>
		--%> 	  
		<c:if test="${kmsKmapsTemplCategoryForm.method_GET=='edit'}">  
			<tr>
				<%---创建者--%>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.docCreatorId"/>
				</td>
				<td width=35%> 
					 <c:out value="${kmsKmapsTemplCategoryForm.docCreatorName}" />
				</td>
				<%--创建时间--%>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.docCreateTime"/>
				</td>
				<td width=35%>
					 <c:out value="${kmsKmapsTemplCategoryForm.docCreateTime}" />
				</td> 
			</tr>
			<tr>
			<%--最后编辑者--%>
			<td class="td_normal_title" width=15%> 
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.docAlterorId"/> 
			</td>
			<td width=35%>
				<c:out value="${kmsKmapsTemplCategoryForm.docAlterorName}" />
			</td>
			<%--最后编辑时间--%>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.docAlterTime"/>
			</td>
			<td width=35%>
				 <c:out value="${kmsKmapsTemplCategoryForm.docAlterTime}" />
			</td>
		</tr>  
			<tr>
				<td class="td_normal_title" width="15%">${lfn:message('kms-kmaps:kmsKmapsCategory.setApplyTo') }</td>
				<td colspan=3>
					 <input type='checkbox' name="appToMyDoc"  value='appToMyDoc'/> ${lfn:message('kms-kmaps:kmsKmapsCategory.thisCategory.Documents') }
					 <input type='checkbox' name="appToChildren"  value='appToChildren'/> ${lfn:message('kms-kmaps:kmsKmapsCategory.subCategory')}
					 <input type='checkbox' name="appToChildrenDoc"  value='appToChildrenDoc'/> ${lfn:message('kms-kmaps:kmsKmapsCategory.subCategory.Documents')}
				</td>
			</tr>
		</c:if>
		</table> 
	</td>
	</tr>
		<%----权限--%>
	<tr LKS_LabelName="${lfn:message('kms-kmaps:kmsKmapsCategory.setRight')}">
		<td>
			<table
				class="tb_normal"
				width=100%>
				<c:import
					url="/sys/right/tmp_right_edit.jsp"
					charEncoding="UTF-8">
					<c:param
						name="formName"
						value="kmsKmapsTemplCategoryForm" />
					<c:param
						name="moduleModelName"
						value="com.landray.kmss.kms.kmaps.model.KmsKmapsTemplCategory" />
				</c:import>
			</table>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript
	formName="kmsKmapsTemplCategoryForm"
	cdata="false"
	dynamicJavascript="true"
	staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>
