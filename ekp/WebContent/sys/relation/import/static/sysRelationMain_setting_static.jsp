<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
	<template:replace name="head">
		<script type="text/javascript" >
			Com_IncludeFile("validator.jsp|validation.jsp|validation.js|plugin.js|doclist.js|jquery.js", null, "js");
			Com_IncludeFile("rela_static.js","${KMSS_Parameter_ContextPath}sys/relation/import/resource/","js",true);
		</script>
	</template:replace>
	<template:replace name="content"> 
		<script type="text/javascript">
			var _params={
						"tempId":'<%=com.landray.kmss.util.IDGenerator.generateID()%>',
						"varName":"rela_opt",
						'format.error':'<bean:message bundle="sys-relation" key="validate.fdOtherUrl.format.error"/>',
						'fdModuleName.isNull':"<bean:message bundle="sys-relation" key="sysRelationMain.fdModuleName.isNull"/>",
						'search.title':'<bean:message key="button.search"/>',
						'button.ok':'<bean:message key="button.ok"/>',
						'button.cancel':'<bean:message key="button.cancel"/>'
				};
			new RelationStaticSetting(_params);
		</script>
		<div class=rela_config_subset>
			<table id="TABLE_DocList" class="tb_simple" style="width:100%">
				<tr>
					<td width="20%"><bean:message bundle="sys-relation" key="sysRelationMain.relation.name"/></td>
					<td width="60%" colspan="2">
						<span>
							<xform:text property="fdModuleName" required="true" showStatus="edit" 
								subject="${lfn:message('sys-relation:sysRelationMain.relation.name') }" style="width:97%"></xform:text>
						</span>
					</td>
					<td width="20%" class="rela_opt_area">
						<ui:button text="${lfn:message('button.insert')}" id="rela_config_add"></ui:button>
						<ui:button text="${lfn:message('button.search')}" id="rela_config_search"></ui:button>
					</td>
				</tr>
				<tr>
					<td></td>
					<td width="30%">
						<bean:message bundle="sys-relation" key="sysRelationMain.docTitle"/>
					</td>
					<td width="30%">
						<bean:message bundle="sys-relation" key="sysRelationMain.docUrl"/>
					</td>
					<td></td>
				</tr>
				<tr KMSS_IsReferRow="1" style="display:none">
					<td></td>
					<td>
						<input class="inputsgl" name="fdName" style="width:94%"/>
					</td>
					<td>
						<input class="inputsgl" name="fdLink" style="width:94%"/>
					</td>
					<td class="rela_opt_area">
						<div class="lui_icon_s lui_icon_s_icon_remove" onclick="rela_opt.deleteConfig();"></div>
						<div class="lui_icon_s lui_icon_s_icon_arrow_up" onclick="DocList_MoveRow(-1);"></div>
						<div class="lui_icon_s lui_icon_s_icon_arrow_down" onclick="DocList_MoveRow(1);"></div>
					</td>
				</tr>
				<tr>
					<td colspan="4" align="center" class="rela_scope_button">
						<ui:button text="${lfn:message('button.ok')}"  id="rela_config_save"></ui:button>
						&nbsp;&nbsp;&nbsp;
						<ui:button text="${lfn:message('button.cancel')}"  id="rela_config_close" styleClass="lui_toolbar_btn_gray"></ui:button>
					</td>
				</tr>
			</table>
		</div>
	
	</template:replace>
</template:include>
