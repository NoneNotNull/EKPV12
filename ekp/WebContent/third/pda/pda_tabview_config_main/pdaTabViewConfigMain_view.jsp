<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
    Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
	Com_IncludeFile("doclist.js|dialog.js|jquery.js|kms_tmpl.js|json2.js");
</script>
<style>
.tb_normal {
	border-color: #dddde5;
}
</style>
<html:form action="/third/pda/pda_tabview_config_main/pdaTabViewConfigMain.do">

	<script>
	function confirmDelete(msg){
	  var del = confirm("<bean:message key="page.comfirmDelete"/>");
	  return del;
	}
	</script>

	<div id="optBarDiv">
		<kmss:auth requestURL="/third/pda/pda_tabview_config_main/pdaTabViewConfigMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		   <input type="button" value="<bean:message key="button.edit"/>" onclick="Com_OpenWindow('pdaTabViewConfigMain.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/third/pda/pda_tabview_config_main/pdaTabViewConfigMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>" onclick="Com_OpenWindow('pdaTabViewConfigMain.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
	</div>

	<p class="txttitle"><bean:message bundle="third-pda" key="table.pdaTabViewConfigMain" /></p>

	<center>
		<table class="tb_normal" width=95%>
			<tr>
				<%-- 功能区名称 --%>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="third-pda" key="pdaTabViewConfigMain.fdName"/>
				</td><td width="85%"  colspan="3">
					<xform:text property="fdName" style="width:85%" />
				</td>
			</tr>
			<tr>
				<%-- 所属组件名称 --%>
				<td class="td_normal_title" width=15%><bean:message bundle="third-pda" key="pdaTabViewConfigMain.fdModuleId"/></td>
				<td width="85%"><xform:text property="fdModuleName" style="width:85%"/></td>
			</tr>
			<tr>
				<%-- 是否启用 --%>
				<td class="td_normal_title" width=15%><bean:message bundle="third-pda" key="pdaTabViewConfigMain.fdStatus"/></td>
				<td width="85%">
					<xform:checkbox property="fdStatus" showStatus="view">
						<xform:simpleDataSource value="1" textKey="message.yes"></xform:simpleDataSource>
					</xform:checkbox>
				</td>
			</tr>
			<tr>
				<%-- 排序号,可为空 --%>
				<td class="td_normal_title" width=15%><bean:message bundle="third-pda" key="pdaTabViewConfigMain.fdOrder"/></td>
				<td width="85%">
					<xform:text property="fdOrder" style="width:35%" />
				</td>
			</tr>
			<%-- 类型为listTab 功能区配置 menglei begin --%>
			<tr id="tr_listArea">
				<td colspan="4" width=100%>
					<bean:message bundle="third-pda" key="table.pdaModuleLabelList"/><br/>
					<c:import url="/third/pda/pda_tabview_label_list/pdaTabViewLabelList_view.jsp" charEncoding="UTF-8">
					</c:import>
					<bean:message bundle="third-pda" key="pdaTabViewConfigMain.tabViewList.summary"/>
				</td>
			</tr>
			<%-- 类型为listTab 功能区配置 menglei end --%>
		</table>
	</center>

<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<input type="hidden" id="fdUrlPrefix" value="${fdUrlPrefix}" />
<input type="hidden" id="fdModuleName" value="${pdaTabViewConfigMainForm.fdModuleName}" />

</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>