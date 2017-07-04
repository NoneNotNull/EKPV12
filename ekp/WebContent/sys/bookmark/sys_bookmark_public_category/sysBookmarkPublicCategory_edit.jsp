<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("common.js|doclist.js|dialog.js");
function showCategoryTreeDialog() {
	var dialog = new KMSSDialog(false, false);
	var node = dialog.CreateTree('<bean:message key="dialog.tree.title" bundle="sys-bookmark"/>');
	node.AppendBeanData("sysBookmarkCategoryTreeService&parentId=!{value}&type=all", null, null, null, '${sysBookmarkPublicCategoryForm.fdId}');
	dialog.winTitle = '<bean:message key="dialog.tree.title" bundle="sys-bookmark"/>';
	dialog.BindingField('fdParentId', 'fdParentName');
	dialog.Show();
	return false;
}
</script>

<kmss:windowTitle
	subject="${sysBookmarkPersonCategoryForm.docSubject}"
	moduleKey="sys-bookmark:table.sysBookmarkPersonCategory" />

<html:form action="/sys/bookmark/sys_bookmark_public_category/sysBookmarkPublicCategory.do" 
	onsubmit="return validateSysBookmarkPublicCategoryForm(this);">
<div id="optBarDiv">
	<c:if test="${sysBookmarkPublicCategoryForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysBookmarkPublicCategoryForm, 'update');">
	</c:if>
	<c:if test="${sysBookmarkPublicCategoryForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysBookmarkPublicCategoryForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysBookmarkPublicCategoryForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-bookmark" key="table.sysBookmarkPublicCategory"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
	<%-- 分类名称 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPublicCategory.fdName"/>
		</td>
		<td colspan="3">
			<html:text property="fdName" style="width: 85%;"/>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<%-- 所属类别 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPublicCategory.fdParentId"/>
		</td>
		<td colspan="3">
			<html:hidden property="fdParentId" />
			<html:text property="fdParentName" readonly="true" 
				style="width:85%" styleClass="inputsgl" />
			<a href="#" onclick="return showCategoryTreeDialog();">
				<bean:message key="dialog.selectOther" />
			</a>
		</td>
	</tr>
	<%-- 排序号 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPublicCategory.fdOrder"/>
		</td>
		<td colspan="3">
			<html:text property="fdOrder" style="width:85%"/>
		</td>
	</tr>
	<tr>
	<c:if test="${sysBookmarkPublicCategoryForm.method_GET=='edit'}">
	<%-- 创建人 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPublicCategory.docCreatorId"/>
		</td>
		<td>
			<html:text property="docCreatorName" readonly="true" />
		</td>
	<%-- 创建时间 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPublicCategory.docCreateTime"/>
		</td><td>
			<html:text property="docCreateTime" readonly="true" />
		</td>
	</tr>
	</c:if>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysBookmarkPublicCategoryForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>
