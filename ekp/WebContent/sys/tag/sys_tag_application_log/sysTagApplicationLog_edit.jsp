<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/tag/sys_tag_application_log/sysTagApplicationLog.do" onsubmit="return validateSysTagApplicationLogForm(this);">
<div id="optBarDiv">
	<c:if test="${sysTagApplicationLogForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysTagApplicationLogForm, 'update');">
	</c:if>
	<c:if test="${sysTagApplicationLogForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysTagApplicationLogForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysTagApplicationLogForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-tag" key="table.sysTagApplicationLog"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdId"/>
		</td><td width=35%>
			<c:if test="${sysTagApplicationLogForm.method_GET=='update'}">
				<html:hidden property="fdId"/>
				<bean:write name="sysTagApplicationLogForm" property="fdId" />
			</c:if>
			<c:if test="${sysTagApplicationLogForm.method_GET!='update'}">
				<html:text property="fdId"/>
			</c:if>
			<span class="txtstrong">*</span>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdModelName"/>
		</td><td width=35%>
			<html:text property="fdModelName"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdModelId"/>
		</td><td width=35%>
			<html:text property="fdModelId"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdTagName"/>
		</td><td width=35%>
			<html:text property="fdTagName"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdValue"/>
		</td><td width=35%>
			<html:text property="fdValue"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdAccount"/>
		</td><td width=35%>
			<html:text property="fdAccount"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="table.sysOrgElement"/>.<bean:message  bundle="sys-tag" key="sysOrgElement.fdId"/>
		</td><td width=35%>
				
			<html:hidden property="docCreatorId"/>
			<a href="#" onclick="alert('请修改这段代码');"><bean:message key="dialog.selectOther"/></a>
				
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagApplicationLog.docCreateTime"/>
		</td><td width=35%>
			<html:text property="docCreateTime"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagApplicationLog.docStatus"/>
		</td><td width=35%>
			<html:text property="docStatus"/>
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysTagApplicationLogForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>