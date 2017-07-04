<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<script type="text/javascript">
Com_IncludeFile("common.js|doclist.js|dialog.js");
function showCategoryTreeDialog() {
	var dialog = new KMSSDialog(false, false);
	var node = dialog.CreateTree('分词类别');
	node.AppendBeanData("sysFtsearchParticipleCategoryTreeService&parentId=!{value}", null, null, null, '${sysFtsearchParticipleCategoryForm.fdId}');
	dialog.winTitle = '分词类别';
	dialog.BindingField('fdParentId', 'fdParentName');
	dialog.Show();
	return false;
}
</script>

<html:form action="/sys/ftsearch/expand/sys_ftsearch_participle_category/sysFtsearchParticipleCategory.do">
<div id="optBarDiv">
	<c:if test="${sysFtsearchParticipleCategoryForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysFtsearchParticipleCategoryForm, 'update');">
	</c:if>
	<c:if test="${sysFtsearchParticipleCategoryForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysFtsearchParticipleCategoryForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysFtsearchParticipleCategoryForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-ftsearch-expand" key="table.sysFtsearchParticipleCategory"/></p>

<center>

<table class="tb_normal" width=95% id="Label_Tabel">
		<tr
			LKS_LabelName="分词类别">
			<td>

<table class="tb_normal" width=95%>
<html:hidden property="fdHierarchyId" />

				<%-- 父类别名称 --%>
				<tr>
					<td class="td_normal_title" width=15%>
						父类别名称
					</td>
					<td width=85% colspan="3">
						<html:hidden property="fdParentId" />
						<html:text property="fdParentName" readonly="true" styleClass="inputsgl" style="width:85%" />
						  <a href="#" onclick="return showCategoryTreeDialog();"> 
							<bean:message key="dialog.selectOther" />
					</td>
				</tr>
				<%-- 类别名称 --%>
				<tr>
					<td class="td_normal_title" width=15%>
						类别名称
					</td>
					<td width=85% colspan="3"><html:text property="fdName" style="width:85%"/> <span
						class="txtstrong">*</span></td>
				</tr>
				<%-- 排序号 --%>
				<tr>
					<td class="td_normal_title" width=15%> 
						排序号
					</td>
					<td width=85% colspan="3"><html:text property="fdOrder" /></td>
				</tr>
				<c:if test="${sysFtsearchParticipleCategoryForm.method_GET=='edit'}">
					<tr>
						<%-- 创建人 --%>
						<td class="td_normal_title" width=15%>
							创建人
						</td>
						<td width=35%>
							<html:text property="docCreatorName" readonly="true" />
						</td>
						<%-- 创建时间 --%>
						<td class="td_normal_title" width=15%>
							 创建时间
						</td>
						<td width=35%>
							<html:text property="docCreateTime" readonly="true" />
						</td>
					</tr>
					<%-- 最后修改人 
					<tr>
						<td class="td_normal_title" width=15%><bean:message
							bundle="km-rules" key="kmRulesCategory.docAlterorName" /></td>
						<td width=35%><html:text property="docAlterorName"
							readonly="true" /></td>--%>
						<%-- 最后修改时间 
						<td class="td_normal_title" width=15%><bean:message
							bundle="km-rules" key="kmRulesCategory.docAlterTime" /></td>
						<td width=35%><html:text property="docAlterTime"
							readonly="true" /></td>
					</tr>--%>
				</c:if>

	
</table>
</td>
</tr>


</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>