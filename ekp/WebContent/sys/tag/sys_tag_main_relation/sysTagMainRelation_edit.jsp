<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/tag/sys_tag_main_relation/sysTagMainRelation.do" onsubmit="return validateSysTagMainRelationForm(this);">
<div id="optBarDiv">
	<c:if test="${sysTagMainRelationForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysTagMainRelationForm, 'update');">
	</c:if>
	<c:if test="${sysTagMainRelationForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysTagMainRelationForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysTagMainRelationForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-tag" key="table.sysTagMainRelation"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagMainRelation.fdId"/>
		</td><td width=35%>
			<c:if test="${sysTagMainRelationForm.method_GET=='update'}">
				<html:hidden property="fdId"/>
				<bean:write name="sysTagMainRelationForm" property="fdId" />
			</c:if>
			<c:if test="${sysTagMainRelationForm.method_GET!='update'}">
				<html:text property="fdId"/>
			</c:if>
			<span class="txtstrong">*</span>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="table.sysTagMain"/>.<bean:message  bundle="sys-tag" key="sysTagMain.fdId"/>
		</td><td width=35%>
				
			<html:hidden property="fdMainId"/>
			<a href="#" onclick="alert('请修改这段代码');"><bean:message key="dialog.selectOther"/></a>
				
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagMainRelation.fdTagName"/>
		</td><td width=35%>
			<html:text property="fdTagName"/>
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysTagMainRelationForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>