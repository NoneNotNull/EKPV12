<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="
	com.landray.kmss.util.KmssMessageWriter,
	com.landray.kmss.util.KmssReturnPage" %>
<%
if(request.getAttribute("KMSS_RETURNPAGE") != null && request.getHeader("accept") != null 
		&& request.getHeader("accept").indexOf("application/json") >= 0) {
	KmssReturnPage _krPage = (KmssReturnPage) request.getAttribute("KMSS_RETURNPAGE");
	if (_krPage.getMessages().hasError()) {
		out.write((new KmssMessageWriter(request, _krPage)).DrawJsonMessage(true).toString());
		response.setHeader("lui-status", "false");
		return;
	}
}
%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("common.js|doclist.js|dialog.js");
function showCategoryTreeDialog() {
	var dialog = new KMSSDialog(false, false);
	var node = dialog.CreateTree('<bean:message key="dialog.tree.title" bundle="sys-bookmark"/>');
	node.AppendBeanData("sysBookmarkCategoryTreeService&parentId=!{value}&type=all");
	dialog.winTitle = '<bean:message key="dialog.tree.title" bundle="sys-bookmark"/>';
	dialog.BindingField('docCategoryId', 'docCategoryName');
	dialog.Show();
	return false;
}
</script>

<kmss:windowTitle
	subject="${sysBookmarkMainForm.docSubject}"
	moduleKey="sys-bookmark:table.sysBookmarkMain" />

<html:form action="/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do" onsubmit="return validateSysBookmarkMainForm(this);">
<div id="optBarDiv">
	<c:if test="${sysBookmarkMainForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysBookmarkMainForm, 'update');">
	</c:if>
	<c:if test="${sysBookmarkMainForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysBookmarkMainForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysBookmarkMainForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-bookmark" key="table.sysBookmarkMain"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
	<%-- 收藏名 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkMain.docSubject"/>
		</td>
		<td>
			<html:text property="docSubject" style="width: 85%;"/>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<%-- 收藏URL --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkMain.fdUrl"/>
		</td>
		<td>
			<html:text property="fdUrl" style="width: 85%;"/>
			<span class="txtstrong">*</span>
			<br>
			<bean:message bundle="sys-bookmark" key="sysBookmarkMain.fdUrl.example"/>
		</td>
	</tr>
	<%-- 收藏分类 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkMain.docCategoryId"/>
		</td>
		<td colspan="3">
			<html:hidden property="docCategoryId" />
			<html:text property="docCategoryName" readonly="true" 
				style="width:85%" styleClass="inputsgl" />
			<a href="#" onclick="return showCategoryTreeDialog();">
				<bean:message key="dialog.selectOther" />
			</a>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysBookmarkMainForm" cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>
