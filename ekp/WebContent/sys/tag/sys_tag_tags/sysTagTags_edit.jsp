<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
Com_IncludeFile("dialog.js");
</script>
<html:form action="/sys/tag/sys_tag_tags/sysTagTags.do" onsubmit="return validateSysTagTagsForm(this);">
<div id="optBarDiv">
	<c:if test="${sysTagTagsForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysTagTagsForm, 'update');">
	</c:if>
	<c:if test="${sysTagTagsForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysTagTagsForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysTagTagsForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-tag" key="table.sysTagTags"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
		<html:hidden property="fdIsPrivate"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagTags.fdName"/>
		</td><td width=35%>
			<html:text property="fdName"/>
			<span class="txtstrong">*</span>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagTags.fdCategoryId"/>
		</td><td width=35%>
			<html:hidden property="fdCategoryId"/>
			<html:text property="fdCategoryName" readonly="true" styleClass="inputsgl"/>
			<a href="#" 
				onclick="Dialog_List(false, 'fdCategoryId', 'fdCategoryName', ';', 'sysTagCategorTreeService',null,null,null,null,'<bean:message key="sysTagTags.fdCategoryId" bundle="sys-tag"/>')">
			<bean:message key="dialog.selectOther" /></a>
		</td>
	</tr>
	<c:if test="">
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="sys-tag" key="table.sysOrgElement"/>
			</td><td width=35%>
				${sysTagTagsForm.docCreatorName}	
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="sys-tag" key="sysTagTags.docCreateTime"/>
			</td><td width=35%>
				${sysTagTagsForm.docCreateTime }
			</td>
		</tr>
	</c:if>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysTagTagsForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>