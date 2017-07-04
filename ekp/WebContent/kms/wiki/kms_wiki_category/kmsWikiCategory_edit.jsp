<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/kms/wiki/kms_wiki_category/kmsWikiCategory_edit_js.jsp"%>
<%@ page import="com.landray.kmss.util.UserUtil" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.landray.kmss.sys.config.dict.SysDataDict" %>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%
   String fdAuthAreaId= UserUtil.getKMSSUser().getAuthAreaId();
   String fdAuthAreaName= UserUtil.getKMSSUser().getAuthAreaName();
   request.setAttribute("fdAuthAreaName", fdAuthAreaName);
   request.setAttribute("fdAuthAreaId", fdAuthAreaId);
   String fdModelName = request.getParameter("fdModelName");
	Set propertyNameSet =  SysDataDict.getInstance().getModel(fdModelName).getPropertyMap().keySet();
%>
<html:form action="/kms/wiki/kms_wiki_category/kmsWikiCategory.do">
<div id="optBarDiv">
	<c:if test="${kmsWikiCategoryForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsWikiCategoryForm, 'update');">
	</c:if>
	<c:if test="${kmsWikiCategoryForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsWikiCategoryForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsWikiCategoryForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-wiki" key="table.kmsWikiCategory"/></p>

<center>
<table id="Label_Tabel" class="tb_normal" width=95%>
	<tr LKS_LabelName="基本信息">
 		<td>
 			<table class="tb_normal" width=100%>
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
					<td class="td_normal_title" width=15%>
						<bean:message bundle="sys-simplecategory" key="sysSimpleCategory.fdName" />
					</td>
					<td colspan="3">
						<xform:text property="fdName" style="width:85%" />
					</td>
				</tr>
		<% if(propertyNameSet.contains("authArea") && ISysAuthConstant.IS_AREA_ENABLED){ %>
		<%-- 所属场所 --%>
		<td class="td_normal_title" width="15%">
			<bean:message key="sysAuthArea.authArea" bundle="sys-authorization" />
		</td>
		<td colspan="3">
		    <html:hidden property="authAreaId"  value="${fdAuthAreaId}"/> 
		    <c:out value="${fdAuthAreaName}" />
		</td>
		<%} %>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message key="model.fdOrder" />
					</td>
					<td colspan="3">
						<xform:text property="fdOrder" />
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="kms-wiki" key="kmsWikiCategory.fdTemplate"/>
					</td><td colspan="3">
						<html:hidden property="fdTemplateId" /> 
						<html:text property="fdTemplateName"  styleClass="inputsgl" style="width:75%" /> 
						<a href="#" onclick="Dialog_List(false, 'fdTemplateId', 'fdTemplateName', null, 'KmsWikiTemplateTree&type=child', null, 'KmsWikiTemplateTree&type=search&key=!{keyword}', null, null, '<bean:message  bundle="kms-wiki" key="table.kmsWikiTemplate"/>');">
						<bean:message key="dialog.selectOther" />
						</a>
					</td>
				</tr>
				<c:import url="/kms/common/resource/ui/sysPropertyTemplate_select.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmsWikiCategoryForm" />
					<c:param name="mainModelName" value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
				</c:import>
 				<!-- 标签机制
				<c:import url="/sys/tag/include/sysTagTemplate_edit.jsp"
						charEncoding="UTF-8">
						<c:param name="formName" value="kmsWikiCategoryForm" />
						<c:param name="fdKey" value="wikidoc" /> 
						<c:param name="diyTitle" value="默认关键字" /> 
				</c:import> -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="sys-simplecategory" key="sysSimpleCategory.parentMaintainer" />
					</td>
					<td colspan="3" id="parentMaintainerId">
						${parentMaintainer}
					</td>
				</tr>
		
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message key="model.tempEditorName" />
					</td>
					<td colspan="3">
						<html:hidden  property="authEditorIds"/>
						<html:textarea property="authEditorNames" style="width:90%" rows="4" readonly="true" styleClass="inputmul"/>
						<a href="#" onclick="Dialog_Address(true, 'authEditorIds', 'authEditorNames', ';', null);"><bean:message key="dialog.selectOrg"/></a>
						<div class="description_txt">
						<bean:message	bundle="sys-simplecategory" key="description.main.tempEditor" />
						</div>
					</td>
				</tr>
		
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message key="model.tempReaderName" />
					</td>
					<td colspan="3">
						<input type="checkbox" name="authNotReaderFlag" value="${kmsWikiCategoryForm.authNotReaderFlag}" onclick="Cate_CheckNotReaderFlag(this);" 
						<c:if test="${kmsWikiCategoryForm.authNotReaderFlag eq 'true'}">checked</c:if>>
						<bean:message bundle="sys-simplecategory" key="description.main.tempReader.notUse" />
						<div id="Cate_AllUserId">
						<html:hidden  property="authReaderIds"/><html:textarea property="authReaderNames" style="width:90%" rows="4" readonly="true" styleClass="inputmul"/>
						<a href="#" onclick="Dialog_Address(true, 'authReaderIds', 'authReaderNames', ';', null);">
						<bean:message key="dialog.selectOrg"/>
						</a>
						</div>
						<div id="Cate_AllUserNote">
						<bean:message bundle="sys-simplecategory" key="description.main.tempReader.allUse" />
						</div>
					</td>
				</tr>
				<tr style="display:none">
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-simplecategory" key="sysSimpleCategory.fdIsinheritMaintainer" /></td>
					<td width=35%>
					<sunbor:enums property="fdIsinheritMaintainer" enumsType="common_yesno" elementType="radio" />
					</td>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-simplecategory" key="sysSimpleCategory.fdIsinheritUser" /></td>
					<td width=35%>
						<sunbor:enums property="fdIsinheritUser" enumsType="common_yesno" elementType="radio" />
					</td>			
				</tr>
				<c:if test="${kmsWikiCategoryForm.method_GET!='add'}">
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						key="model.fdCreator" /></td>
					<td width=35%><bean:write name="kmsWikiCategoryForm" property="docCreatorName"/></td>
					<td class="td_normal_title" width=15%><bean:message
						key="model.fdCreateTime" /></td>
					<td width=35%><bean:write name="kmsWikiCategoryForm" property="docCreateTime"/></td>			
				</tr>
				<c:if test="${kmsWikiCategoryForm.docAlterorName!=''}">
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						key="model.docAlteror" /></td>
					<td width=35%><bean:write name="kmsWikiCategoryForm" property="docAlterorName"/></td>
					<td class="td_normal_title" width=15%><bean:message
						key="model.fdAlterTime" /></td>
					<td width=35%><bean:write name="kmsWikiCategoryForm" property="docAlterTime"/></td>
				</tr>
				</c:if>
				<tr>
					<td
						class="td_normal_title"
						width="15%">将修改应用到</td>
					<td colspan=3>
						 <input type='checkbox' name="appToMyDoc"  value='appToMyDoc'/> 本类别下的文档
						 <input type='checkbox' name="appToChildren"  value='appToChildren'/> 子类别设置
						 <input type='checkbox' name="appToChildrenDoc"  value='appToChildrenDoc'/> 子类别下的文档
					</td>
				</tr>
				</c:if>
 			</table>
 		</td>
 	</tr>
 	
 	<c:import url="/sys/workflow/include/sysWfTemplate_edit.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="kmsWikiCategoryForm" />
		<c:param name="fdKey" value="wikiFlow" />
	</c:import>
 	
 	<%--关联机制--%>
	<tr LKS_LabelName="关联设置">
		<c:set var="mainModelForm" value="${kmsWikiCategoryForm}" scope="request" />
		<c:set var="currModelName" value="com.landray.kmss.kms.wiki.model.KmsWikiCategory" scope="request" />
		<td><%@ include file="/sys/relation/include/sysRelationMain_edit.jsp"%></td>
	</tr>
	<%----权限--%>
	<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />设置">
		<td>
			<table
				class="tb_normal"
				width=100%>
				<c:import
					url="/sys/right/tmp_right_edit.jsp"
					charEncoding="UTF-8">
					<c:param
						name="formName"
						value="kmsWikiCategoryForm" />
					<c:param
						name="moduleModelName"
						value="com.landray.kmss.kms.wiki.model.KmsWikiCategory" />
				</c:import>
			</table>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCategory.fdTemplate"/>
		</td><td width="35%">
			<xform:select property="fdTemplateId">
				<xform:beanDataSource serviceBean="kmsWikiTemplateService" selectBlock="fdId,fdId" orderBy="fdOrder" />
			</xform:select>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("dialog.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>