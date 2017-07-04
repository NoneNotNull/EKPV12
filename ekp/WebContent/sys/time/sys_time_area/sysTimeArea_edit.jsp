<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
	Com_IncludeFile("dialog.js");
</script>
<html:form action="/sys/time/sys_time_area/sysTimeArea.do" onsubmit="return validateSysTimeAreaForm(this);">
<div id="optBarDiv">
	<c:if test="${sysTimeAreaForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysTimeAreaForm, 'update');">
	</c:if>
	<c:if test="${sysTimeAreaForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysTimeAreaForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysTimeAreaForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="top.close();">
</div>

<p class="txttitle"><bean:message  bundle="sys-time" key="table.sysTimeArea"/></p>

<center>
<table class="tb_normal" width=95%>
	<html:hidden property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeArea.fdName"/>
		</td>
		<td width=85% colspan=3>
			<html:text property="fdName" style="width:85%"/>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-time" key="sysTimeArea.scope"/>
		</td>
		<td width=85% colspan=3>
			<html:hidden property="areaMemberIds" />
			<html:textarea property="areaMemberNames" style="width:90%;height:90px" styleClass="inputmul" readonly="true" />
			<a href="#" onclick="Dialog_Address(true, 'areaMemberIds','areaMemberNames', ';', ORG_TYPE_ORG | ORG_TYPE_DEPT | ORG_TYPE_PERSON);">
				<bean:message key="dialog.selectOrg" /></a>							
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeArea.timeAdmin"/>
		</td>
		<td width=85% colspan=3>
			<html:hidden property="areaAdminIds" />
			<html:textarea property="areaAdminNames" style="width:90%;height:90px" styleClass="inputmul" readonly="true" />
			<a href="#" onclick="Dialog_Address(true, 'areaAdminIds','areaAdminNames', ';', ORG_TYPE_PERSON);">
				<bean:message key="dialog.selectOrg" /></a>			
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<c:if test="${sysTimeAreaForm.method_GET=='edit'}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeArea.docCreatorId"/>
		</td><td width=35%>
			${sysTimeAreaForm.docCreatorName}
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeArea.docCreateTime"/>
		</td><td width=35%>
			${sysTimeAreaForm.docCreateTime}
		</td>
	</tr>
	</c:if>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<script language="JavaScript">Com_IncludeFile("calendar.js");</script>
<html:javascript formName="sysTimeAreaForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>