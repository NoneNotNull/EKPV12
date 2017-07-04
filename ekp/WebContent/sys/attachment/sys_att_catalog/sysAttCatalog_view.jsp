<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/attachment/sys_att_catalog/sysAttCatalog.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('sysAttCatalog.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-attachment" key="table.sysAttCatalog"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-attachment" key="sysAttCatalog.fdName"/>
		</td><td width="85%">
			<xform:text property="fdName" style="width:50%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-attachment" key="sysAttCatalog.fdPath"/>
		</td><td width="85%">
			<xform:text property="fdPath" style="width:50%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-attachment" key="sysAttCatalog.fdIsCurrent"/>
		</td><td width="85%">
			<xform:checkbox property="fdIsCurrent" value="${sysAttCatalogForm.fdIsCurrent}">
				<xform:simpleDataSource value="true" textKey="message.yes"></xform:simpleDataSource>
			</xform:checkbox>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>