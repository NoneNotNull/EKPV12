<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.sys.config.design.SysCfgRelation"%>
<%@page import="com.landray.kmss.sys.relation.web.RelationEntry"%>
<%@page import="com.landray.kmss.sys.config.design.SysConfigs"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<template:include ref="default.dialog">
	<template:replace name="content"> 
	<script type="text/javascript" >
		Com_IncludeFile("validator.jsp|validation.jsp|validation.js|plugin.js|jquery.js", null, "js");
		Com_IncludeFile("rela_condition.js","${KMSS_Parameter_ContextPath}sys/relation/import/resource/","js",true);
	</script>
	<script type="text/javascript">
		var _param={"tempId":'<%=com.landray.kmss.util.IDGenerator.generateID()%>',
				"varName":"rela_opt",
				'fdModuleName.isNull':"<bean:message bundle="sys-relation" key="sysRelationMain.fdModuleName.isNull"/>",
				'preview.title':'<bean:message key="sys-relation:button.setting.preview"/>',
				'button.cancel':'<bean:message key="button.close"/>'
			};
		
		new RelationConditionSetting(_param);
	</script>
	<div class="rela_config_subset">
		<table class="tb_simple" style="width:100%">
			<tr><td width="20%"><bean:message bundle="sys-relation" key="sysRelationMain.relation.name"/>
			</td><td>
				<xform:text property="fdModuleName" required="true" value="${sysRelationMain.relation.fdModelName}" showStatus="edit" 
								subject="${lfn:message('sys-relation:sysRelationMain.relation.name') }" style="width:75%"></xform:text>
			</td></tr>
			<tr><td width="20%"><bean:message bundle="sys-relation" key="sysRelationMain.fdRelationEntries"/>
			</td><td>
				<select id="rela_module">
				<%
					Map<?, ?> relations = SysConfigs.getInstance().getRelations();
					String modelName = (String)request.getParameter("currModelName");
					Class currModelNameClass = Class.forName(modelName);
					Set set = relations.keySet();
					if(!set.isEmpty()){
						Iterator<?> iter = set.iterator();
						while (iter.hasNext()) {
							SysCfgRelation relation = (SysCfgRelation) relations
									.get(iter.next());
							RelationEntry rtn = new RelationEntry(relation, request
											.getLocale());
							Class c = Class.forName(relation.getModelName());
							if(modelName.equals(relation.getModelName()) || c.isAssignableFrom(currModelNameClass)){
								out.append("<option value='"+relation.getModelName()+"' selected='selected'>"+rtn.getTitle()+"</option>");
							}else{
								out.append("<option value='"+relation.getModelName()+"'>"+rtn.getTitle()+"</option>");
							}
						}
					}else{
							out.append("<option value=''><bean:message key='page.firstOption'/></option>");
					}
				%>
				</select>
			</td></tr>
		</table>
	</div>
	<div class="rela_config_table">
		<iframe id="rela_condition_iframe" src="" frameborder="0" scrolling="no" width="100%"/>
	</div>
	</template:replace>
</template:include>