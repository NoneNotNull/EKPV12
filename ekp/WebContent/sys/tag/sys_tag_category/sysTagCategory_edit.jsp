<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
Com_IncludeFile("dialog.js");
</script>
<html:form action="/sys/tag/sys_tag_category/sysTagCategory.do" onsubmit="return validateSysTagCategoryForm(this);">
<div id="optBarDiv">
	<c:if test="${sysTagCategoryForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysTagCategoryForm, 'update');">
	</c:if>
	<c:if test="${sysTagCategoryForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysTagCategoryForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysTagCategoryForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-tag" key="table.sysTagCategory"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagCategory.fdName"/>
		</td><td width=35%>
			<html:text property="fdName"/>
			<span class="txtstrong">*</span>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagCategory.fdManagerId"/>
		</td><td width=35%>
			<html:hidden property="fdManagerId"/>
			<html:text property="fdManagerName" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="Dialog_Address(false, 'fdManagerId', 'fdManagerName', null, ORG_TYPE_PERSON);"><bean:message key="dialog.selectOrg"/></a>
			<span class="txtstrong">*</span>	
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagCategory.fdTagQuoteTimes"/>
		</td><td width=35%>
			<html:hidden property="fdTagQuoteTimes"/>
			${sysTagCategoryForm.fdTagQuoteTimes}
			<span class="txtstrong">(<bean:message  bundle="sys-tag" key="sysTagCategory.fdTagQuoteTimes.describe"/>)</span>
		</td>		
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagCategory.fdOrder"/>
		</td><td width=35%>
			<html:text property="fdOrder"/>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysTagCategoryForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>