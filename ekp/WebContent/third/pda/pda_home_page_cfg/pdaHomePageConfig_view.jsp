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
	<kmss:auth requestURL="/third/pda/pda_home_page_cfg/pdaHomePageConfig.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('pdaHomePageConfig.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/third/pda/pda_home_page_cfg/pdaHomePageConfig.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('pdaHomePageConfig.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="third-pda" key="table.pdaHomePageConfig"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<%-- 主页名称 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomePageConfig.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<%-- 是否为默认主页 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomePageConfig.fdIsDefault"/>
		</td>
		<td width="85%">
			<xform:checkbox property="fdIsDefault" showStatus="view">
				<xform:simpleDataSource value="1" textKey="message.yes"></xform:simpleDataSource>
			</xform:checkbox>
		</td>
	</tr>
	<tr>
		<%-- 主页窗口显示条目数--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomePageConfig.fdRowsize"/>
		</td>
		<td width="85%">
			<xform:text property="fdRowsize" style="width:35%" />
		</td>
	</tr>
	<tr>
		<%-- 排序号,可为空 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomePageConfig.fdOrder"/>
		</td>
		<td width="85%">
			<xform:text property="fdOrder" style="width:35%" />
		</td>
	</tr>
	<tr>
		<%-- 文档类型列表 --%>
		<td colspan="2">
			<c:import url="/third/pda/pda_home_page_portlet/pdaHomePagePortlet_view.jsp"
				charEncoding="UTF-8">
			</c:import>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomePageConfig.docCreator"/>
		</td><td width="85%">
			<c:out value="${pdaHomePageConfigForm.docCreatorName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomePageConfig.fdCreateTime"/>
		</td><td width="85%">
			<xform:datetime property="fdCreateTime" />
		</td>
	</tr>
	<c:if test="${!empty pdaHomePageConfigForm.docAlterorName}">
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="third-pda" key="pdaHomePageConfig.docAlteror"/>
			</td><td width="85%">
				<c:out value="${pdaHomePageConfigForm.docAlterorName}" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="third-pda" key="pdaHomePageConfig.docAlterTime"/>
			</td><td width="85%">
				<xform:datetime property="docAlterTime"/>
			</td>
		</tr>
	</c:if>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>