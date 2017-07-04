<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("common.js|doclist.js|dialog.js");
function showCategoryTreeDialog() {
	var dialog = new KMSSDialog(false, false);
	var node = dialog.CreateTree('<bean:message key="dialog.tree.title" bundle="sys-rss"/>');
	node.AppendBeanData("sysRssCategoryTreeService&selectdId=!{value}", null, null, null, '${param.fdId}');
	dialog.winTitle = '<bean:message key="dialog.title" bundle="sys-rss"/>';
	dialog.BindingField('fdParentId', 'fdParentName');
	dialog.Show();
	return false;
}
</script>

<html:form action="/sys/rss/sys_rss_category/sysRssCategory.do" onsubmit="return validateSysRssCategoryForm(this);">
<div id="optBarDiv">
	<c:if test="${sysRssCategoryForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysRssCategoryForm, 'update');">
	</c:if>
	<c:if test="${sysRssCategoryForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysRssCategoryForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysRssCategoryForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-rss" key="table.sysRssCategory"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
	<%-- 名称 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssCategory.fdName"/>
		</td>
		<td colspan="3">
			<html:text style="width:85%" property="fdName"/>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<%--  --%>
	<tr>
		<%-- 分类 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssCategory.fdParentId"/>
		</td>
		<td width=35%>
			<html:hidden property="fdParentId" />
			<html:text property="fdParentName" readonly="true" 
				style="width:85%" styleClass="inputsgl" />
			<a href="#" onclick="return showCategoryTreeDialog();">
				<bean:message key="dialog.selectOther" />
			</a>
		</td>
		<%-- 排序号 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssCategory.fdOrder"/>
		</td>
		<td width=35%>
			<html:text property="fdOrder" style="width:85%"/>
		</td>
	</tr>
	<%---创建时间创建人 修改时间修改人 不显示在新建里， 仅在编辑页面 modify by zhouchao---%>
	<c:if test="${sysRssCategoryForm.method_GET=='edit'}">
	<%-- 创建人 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssCategory.docCreatorId"/>
		</td>
		<td width=35%>
			<html:text property="docCreatorName" readonly="true" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssCategory.docCreateTime"/>
		</td>
		<td width=35%>
			<html:text property="docCreateTime" readonly="true"/>
		</td>
	</tr>
	<%-- 修改人 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssCategory.docAlterorId"/>
		</td>
		<td width=35%>
			<html:text property="docAlterorName" readonly="true" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssCategory.docAlterTime"/>
		</td>
		<td width=35%>
			<html:text property="docAlterTime" readonly="true"/>
		</td>
	</tr>
	</c:if>

</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysRssCategoryForm" cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>
