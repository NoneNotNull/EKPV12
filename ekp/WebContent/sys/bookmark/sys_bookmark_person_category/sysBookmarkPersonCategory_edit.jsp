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
	subject="${sysBookmarkPersonCategoryForm.fdName}"
	moduleKey="sys-bookmark:table.sysBookmarkPersonCategory" />

<html:form action="/sys/bookmark/sys_bookmark_person_category/sysBookmarkPersonCategory.do" onsubmit="return validateSysBookmarkPersonCategoryForm(this);">
<div id="optBarDiv">
	<c:if test="${sysBookmarkPersonCategoryForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysBookmarkPersonCategoryForm, 'update');">
	</c:if>
	<c:if test="${sysBookmarkPersonCategoryForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysBookmarkPersonCategoryForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysBookmarkPersonCategoryForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-bookmark" key="table.sysBookmarkPersonCategory"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
	<%-- 分类名称 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPersonCategory.fdName"/>
		</td>
		<td>
			<html:text property="fdName" style="width: 85%;"/>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<%-- 所属类别 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPersonCategory.fdParentId"/>
		</td>
		<td>
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
			<bean:message bundle="sys-bookmark" key="sysBookmarkPersonCategory.fdOrder"/>
		</td>
		<td>
			<html:text property="fdOrder" style="width:85%"/>
		</td>
	</tr>
	<%-- 创建时间 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPersonCategory.docCreateTime"/>
		</td><td>
			<html:text property="docCreateTime" readonly="true" />
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysBookmarkPersonCategoryForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>
