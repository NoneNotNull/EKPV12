<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld" prefix="template"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>


<template:include ref="default.simple">
	<template:replace name="title">
		<kmss:message bundle="sys-person" key="sysPersonCfgLink" /> - <kmss:message bundle="sys-person" key="module.name" />
	</template:replace>
	
	<template:replace name="body">
		
		<div style="width: 95%; margin: 0 auto;">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="95%">
			<ui:button text="${lfn:message('button.save') }" order="2" onclick=" Com_Submit(document.sysPersonCfgLinkAllForm, 'update');">
			</ui:button>
			<ui:button text="${lfn:message('button.reset') }" order="2" onclick=" Com_Submit(document.sysPersonCfgLinkAllForm, 'clearAll');">
			</ui:button>
		</ui:toolbar>
		
		<p class="txttitle">
			<kmss:message bundle="sys-person" key="person.setting.nav" />
		</p>
		<script>Com_IncludeFile('doclist.js|jquery.js|plugin.js');</script>
		
		<html:form action="/sys/person/sys_person_cfg_link/sysPersonCfgLink.do">
			<ui:tabpanel layout="sys.ui.tabpanel.light" style="margin-top:10px;">
				<ui:content title="${lfn:message('sys-person:person.link.type.setting.info') }">
					<c:import url="/sys/person/sys_person_cfg_link/sysPersonCfgLink_link.jsp" charEncoding="UTF-8">
						<c:param name="linkType" value="fdSettingInfos" />
						<c:param name="linkForm" value="sysPersonCfgLinkAllForm" />
					</c:import>
				</ui:content>
				<ui:content title="${lfn:message('sys-person:person.link.type.setting.home') }">
					<c:import url="/sys/person/sys_person_cfg_link/sysPersonCfgLink_link.jsp" charEncoding="UTF-8">
						<c:param name="linkType" value="fdSettingHomes" />
						<c:param name="linkForm" value="sysPersonCfgLinkAllForm" />
					</c:import>
				</ui:content>
				<ui:content title="${lfn:message('sys-person:person.link.type.setting') }">
					<c:import url="/sys/person/sys_person_cfg_link/sysPersonCfgLink_link.jsp" charEncoding="UTF-8">
						<c:param name="linkType" value="fdSettings" />
						<c:param name="linkForm" value="sysPersonCfgLinkAllForm" />
					</c:import>
				</ui:content>
			</ui:tabpanel>
		</html:form>
		</div>
		
		<script>
		seajs.use(['lui/jquery', 'sys/person/resource/cfglink', 'theme!form'], function($, cfg) {
			$(document).ready(cfg.ready);
		});
		$(document).ready(function() {
			$KMSSValidation();
		});
		</script>
	</template:replace>
	
</template:include>