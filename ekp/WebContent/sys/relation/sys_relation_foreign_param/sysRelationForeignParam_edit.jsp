<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/relation/sys_relation_foreign_param/sysRelationForeignParam.do" onsubmit="return validateSysRelationForeignParamForm(this);">
<div id="optBarDiv">
	<c:if test="${sysRelationForeignParamForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysRelationForeignParamForm, 'update');">
	</c:if>
	<c:if test="${sysRelationForeignParamForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysRelationForeignParamForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysRelationForeignParamForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-relation" key="table.sysRelationForeignParam"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignParam.fdId"/>
		</td><td width=35%>
			<c:if test="${sysRelationForeignParamForm.method_GET=='update'}">
				<html:hidden property="fdId"/>
				<bean:write name="sysRelationForeignParamForm" property="fdId" />
			</c:if>
			<c:if test="${sysRelationForeignParamForm.method_GET!='update'}">
				<html:text property="fdId"/>
			</c:if>
			<span class="txtstrong">*</span>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignParam.fdParam"/>
		</td><td width=35%>
			<html:text property="fdParam"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignParam.fdParamName"/>
		</td><td width=35%>
			<html:text property="fdParamName"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignParam.fdParamType"/>
		</td><td width=35%>
			<html:text property="fdParamType"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="table.sysRelationForeignModule"/>.<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdId"/>
		</td><td width=35%>
				
			<html:hidden property="fdModuleId"/>
			<a href="#" onclick="alert('请修改这段代码');"><bean:message key="dialog.selectOther"/></a>
				
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysRelationForeignParamForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>