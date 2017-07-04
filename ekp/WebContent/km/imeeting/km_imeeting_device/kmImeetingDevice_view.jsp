<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/km/imeeting/km_imeeting_device/kmImeetingDevice.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmImeetingDevice.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/km/imeeting/km_imeeting_device/kmImeetingDevice.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmImeetingDevice.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-imeeting" key="table.kmImeetingDevice"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<%--设备名称--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingDevice.fdName"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<%--排序号--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingDevice.fdOrder"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
	</tr>
	<tr>
		<%--是否有效--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingDevice.fdIsAvailable"/>
		</td>
		<td width="85%" colspan="3">
			<xform:radio property="fdIsAvailable">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	
	<tr><td colspan="4">&nbsp;</td></tr>	
	
	<tr>
		<%--创建人--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingDevice.docCreator"/>
		</td>
		<td width="35%">
			<c:out value="${kmImeetingDeviceForm.docCreatorName}" />
		</td>
		<%--创建时间--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingDevice.docCreateTime"/>
		</td>
		<td width=35%>
			<c:out value="${kmImeetingDeviceForm.docCreateTime}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>