<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page import="com.landray.kmss.sys.transport.model.SysTransportImportConfig" %>
<%@page import="com.landray.kmss.util.comparator.ChinesePinyinComparator"%>	
<%@page import="com.landray.kmss.sys.config.dict.SysDictCommonProperty"%>
<Script>Com_IncludeFile("select.js");</Script>
<script type="text/javascript">
<!--
function beforeSubmit() {
	var form = document.sysTransportExportForm;
	var selectedOptions = form.selectedOptions;
	if (selectedOptions.length == 0) {
		alert('<bean:message  bundle="sys-transport" key="sysTransport.error.none.selected"/>');
		return false;
	}
	if (validateSysTransportExportForm(form)) {
		for (var j = 0; j < selectedOptions.length; j++) { // 遍历“已选列表”
			var propertyName = selectedOptions[j].value;
			form.selectedPropertyNames.value += propertyName + ';';
		}
		return true;
	}
	else return false;
}
//-->
</script>
<html:form action="/sys/transport/sys_transport_export/SysTransportExport.do" onsubmit="return beforeSubmit();">
<div id="optBarDiv">
	<c:if test="${sysTransportExportForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysTransportExportForm, 'update');">
	</c:if>
	<c:if test="${sysTransportExportForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysTransportExportForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysTransportExportForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><kmss:message key="${modelMessageKey}"/><bean:message  bundle="sys-transport" key="table.sysTransportExportConfig"/><bean:message key="button.edit"/></p>
<table class="tb_normal" width="600" align="center" id="transportTable">
	<html:hidden property="fdId"/>
	<html:hidden property="selectedPropertyNames"/>
	<c:if test="${sysTransportExportForm.method_GET=='add'}">
		<html:hidden property="fdModelName" value="${param.fdModelName }"/>
	</c:if>
	<c:if test="${sysTransportExportForm.method_GET=='edit'}">
		<html:hidden property="fdModelName"/>
	</c:if>
	<tr>
		<td>
			<bean:message  bundle="sys-transport" key="fdName"/>&nbsp;
			<html:text property="fdName" style="width:90%"/><span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" class="tb_normal">
				<tr>
					<td width="40%" align="center">
						<bean:message  bundle="sys-transport" key="sysTransport.label.optionList"/><br/>
						<select name="options" size="10" multiple="true" style="width:98%" ondblclick="Select_AddOptions(options, selectedOptions, false);">
							<c:forEach items="${sysTransportExportForm.optionList }" var="commonProperty">
							<option value="${commonProperty.name }">
							<%
								SysDictCommonProperty commonProperty = (SysDictCommonProperty) pageContext.getAttribute("commonProperty");
								Character c = ChinesePinyinComparator.getFirstPinyinChar(commonProperty.getMessageKey(), request.getLocale()); 
								if (c != null) out.print(c);
								%>
								<kmss:message key="${commonProperty.messageKey }"/>
							</option>
							</c:forEach>
						</select>
					</td>
					<td width="20%" align="center" valign="center">
						<input type="button" value="<bean:message  bundle="sys-transport" key="sysTransport.button.add"/>" 
								onclick="Select_AddOptions(options, selectedOptions, false);"><br/><br/>
						<input type="button" value="<bean:message  bundle="sys-transport" key="sysTransport.button.delete"/>" 
								onclick="Select_DelOptions(selectedOptions, false);"><br/><br/>
						<input type="button" value="<bean:message  bundle="sys-transport" key="sysTransport.button.addAll"/>" 
								onclick="Select_AddOptions(options, selectedOptions, true);"><br/><br/>
						<input type="button" value="<bean:message  bundle="sys-transport" key="sysTransport.button.delteAll"/>" 
								onclick="Select_DelOptions(selectedOptions, true);"><br/><br/>
						<input type="button" value="<bean:message  bundle="sys-transport" key="sysTransport.button.up"/>" 
								onclick="Select_MoveOptions(selectedOptions, -1);"><br/><br/>
						<input type="button" value="<bean:message  bundle="sys-transport" key="sysTransport.button.down"/>" 
								onclick="Select_MoveOptions(selectedOptions, 1);">
					</td>
					<td width="40%" align="center">
						<bean:message  bundle="sys-transport" key="sysTransport.label.selectedOptionList"/><br/>
						<select name="selectedOptions" size="10" multiple="true" style="width:98%" ondblclick="Select_DelOptions(selectedOptions, false);">
							<c:forEach items="${sysTransportExportForm.propertyList }" var="commonProperty">
							<option value="${commonProperty.name }">
							<%
								SysDictCommonProperty commonProperty = (SysDictCommonProperty) pageContext.getAttribute("commonProperty");
								Character c = ChinesePinyinComparator.getFirstPinyinChar(commonProperty.getMessageKey(), request.getLocale()); 
								if (c != null) out.print(c);
								%>
							<kmss:message key="${commonProperty.messageKey }"/>
							</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysTransportExportForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>