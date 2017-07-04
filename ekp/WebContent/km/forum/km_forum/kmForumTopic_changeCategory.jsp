<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("common.js|doclist.js|dialog.js|calendar.js");
</script>
<p class="txttitle"><bean:message bundle="km-forum" key="kmForumCategory.changeDirectory" /></p>

<html:form action="/km/forum/km_forum/kmForumTopic.do">
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.save"/>" onclick="Com_Submit(document.kmForumTopicForm, 'changeDocumentCategory');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td width="15%" class="td_normal_title" >
			<bean:message bundle="km-forum" key="kmForumCategory.changeTo" />
		</td>
		<td width="85%">
			<html:hidden property="fdForumId" />
			<html:text property="fdForumName" readonly="true" style="width:50%;" styleClass="inputsgl" />
			<a href="#" onclick="Dialog_Tree(false, 'fdForumId', 'fdForumName', ',', 'kmForumCategoryTreeSelectService&categoryId=!{value}', '<bean:message key="dialog.tree.title" bundle="km-forum"/>', null, null, '${param.fdId}', null, null, '<bean:message key="dialog.title" bundle="km-forum"/>');">
			<bean:message key="dialog.selectOther" /></a><span class="txtstrong">*</span>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>