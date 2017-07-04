<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("common.js|doclist.js|dialog.js");
function openCategoryWindow(){
	dialog_Category_Tree(null, 'fdParentId', 'fdParentName', ',', 'kmForumCategoryTeeService', '<bean:message key="dialog.tree.title" bundle="km-forum"/>', null, null, '${param.fdId}', null, null, '<bean:message key="dialog.title" bundle="km-forum"/>');
}
function dialog_Category_Tree(mulSelect, idField, nameField, splitStr, treeBean, treeTitle, treeAutoSelChilde, action, exceptValue, isMulField, notNull, winTitle){
	var dialog = new KMSSDialog(mulSelect, false);
	var node = dialog.CreateTree(treeTitle);
	node.AppendBeanData(treeBean, null, null, null, exceptValue);
	dialog.tree.isAutoSelectChildren = treeAutoSelChilde;
	dialog.winTitle = winTitle==null?treeTitle:winTitle;
	dialog.BindingField(idField, nameField, splitStr);
	dialog.SetAfterShow(action);
	dialog.Show();
}
</script>
<p class="txttitle"><bean:message bundle="km-forum" key="kmForumCategory.fdId"/><bean:message key="button.edit"/></p>

<html:form action="/km/forum/km_forum_cate/kmForumCategory.do" onsubmit="return validateKmForumCategoryForm(this);">
<div id="optBarDiv">
<c:if test="${kmForumCategoryForm.method_GET=='editDirectory'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmForumCategoryForm, 'update');">
	</c:if>	
	<c:if test="${kmForumCategoryForm.method_GET=='addDirectory'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmForumCategoryForm, 'save');">		
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>	
		<html:hidden property="fdParentId" value="00" />
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.fdName"/>
		</td><td colspan=3>
			<html:text property="fdName" size="50"/><span class="txtstrong">*</span>
		</td>
	</tr>

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.fdDescription"/>
		</td><td colspan=3>
			<html:textarea property="fdDescription" style="width:95%"/>
		</td>
	</tr>		
	<html:hidden property="fdMainScore" value="0"/>	
		<html:hidden property="fdResScore" value="0"/>	
			<html:hidden property="fdPinkScore" value="0"/>	
	<tr>		
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.fdDisplayOrder"/>
		</td><td colspan=3>
			<html:text property="fdOrder" size="5"/><span class="txtstrong">*</span>
		</td>
	</tr>	
	<c:if test="${kmForumCategoryForm.method_GET=='edit'}">	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.docCreatorId"/>
		</td><td>
			<html:hidden property="docCreatorId"/>
			<html:text property="docCreatorName" readonly="true"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.docCreateTime"/>
		</td><td>
			<html:text property="docCreateTime" readonly="true"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.docAlterId"/>
		</td><td>
			<html:text property="docAlterName" readonly="true"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.docAlterTime"/>
		</td><td>
			<html:text property="docAlterTime" readonly="true"/>
		</td>
	</tr>
	</c:if>	


</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<script language="JavaScript">Com_IncludeFile("calendar.js");</script>
<html:javascript formName="kmForumCategoryForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>