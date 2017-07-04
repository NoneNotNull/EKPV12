<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="config.edit">
	<template:replace name="toolbar">
		<ui:toolbar var-navwidth="90%" id="toolbar" layout="sys.ui.toolbar.float"> 
			<ui:button text="保存" order="2" onclick="Com_Submit(document.pdaDataExtendConfigForm, 'update');">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">
		
<html:form action="/third/pda/pda_data_extend_config/pdaDataExtendConfig.do" method="POST">
	<html:hidden property="method_GET" />
	<script>
	Com_IncludeFile("dialog.js|doclist.js");
	</script>
	<script>
	DocList_Info.push("pda_data_extend_config");
	</script>
	<table class="tb_normal" width="98%" style="margin-top: 50px;" id="pda_data_extend_config">
		<tr class="tr_normal_title">
			<td width="35px;">序号</td>
			<td width="140px;">名称</td>
			<td width="140px;">标识符</td>
			<td>数据源</td>
			<td width="140pc;">类型</td>
			<td width="100px;"><a href="#" onclick="DocList_AddRow();return false;">添加</a></td>
		</tr>
		<tr KMSS_IsReferRow="1" style="display:none">
			<td KMSS_IsRowIndex="1"></td>
			<td>
				<xform:text property="pdaDataExtendConfigList[!{index}].fdName" required="true" style="width:90%"></xform:text>
			</td>
			<td>
				<xform:text property="pdaDataExtendConfigList[!{index}].fdKey" required="true" style="width:90%"></xform:text>
			</td>
			<td>
				<xform:text property="pdaDataExtendConfigList[!{index}].fdValue" required="true" style="width:95%"></xform:text>
			</td>
			<td>
				<xform:text property="pdaDataExtendConfigList[!{index}].fdType" required="true" style="width:90%"></xform:text>
			</td>
			<td>
				<a href="#" onclick="DocList_DeleteRow();">删除</a>
				<a href="#" onclick="DocList_MoveRow(-1);">上移</a>
				<a href="#" onclick="DocList_MoveRow(1);">下移</a>
			</td>
		</tr>
		<c:forEach items="${pdaDataExtendConfigForm.pdaDataExtendConfigList }" var="fdDetails" varStatus="vstatus">
		<tr KMSS_IsContentRow="1">
			<td>${vstatus.index+1}</td>
			<td>
				<xform:text property="pdaDataExtendConfigList[${vstatus.index}].fdName" required="true" style="width:90%"></xform:text>
			</td>
			<td>
				<xform:text property="pdaDataExtendConfigList[${vstatus.index}].fdKey" required="true" style="width:90%"></xform:text>
			</td>
			<td>
				<xform:text property="pdaDataExtendConfigList[${vstatus.index}].fdValue" required="true" style="width:95%"></xform:text>
			</td>
			<td>
				<xform:text property="pdaDataExtendConfigList[${vstatus.index}].fdType" required="true" style="width:95%"></xform:text>
			</td>
			<td>
				<a href="#" onclick="DocList_DeleteRow();">删除</a>
				<a href="#" onclick="DocList_MoveRow(-1);">上移</a>
				<a href="#" onclick="DocList_MoveRow(1);">下移</a>
			</td>
		</tr>
		</c:forEach>
	</table>
</html:form>
	<script>
			$KMSSValidation(document.forms['pdaDataExtendConfigForm']);
	</script>
		
	</template:replace>
</template:include>
