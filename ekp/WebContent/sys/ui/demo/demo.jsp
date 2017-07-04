<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="	com.landray.kmss.sys.ui.plugin.SysUiPluginUtil,
					com.landray.kmss.sys.ui.xml.model.SysUiTemplate"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld" prefix="template"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%
	SysUiTemplate template = SysUiPluginUtil.getTemplateById("default");
	request.setAttribute("template", template);
	request.setAttribute("pageheader", "/sys/ui/demo/header.jsp");
	request.setAttribute("pagefooter", "/sys/ui/demo/footer.jsp");
%>
<template:include file="${ template.fdFile }">
	<template:replace name="left">
		<ui:panel width="250" var-toggle="true">
			<ui:content title="服务联系人2">
				<ui:dataview format="sys.ui.classic">
					<ui:source ref="sys.ui.ajaxxml2.source">
					</ui:source>
				</ui:dataview>
			</ui:content>
		</ui:panel>
	</template:replace>
	
	<template:replace name="center">
		<ui:tabpanel width="500" var-toggle="true">
			<ui:content title="服务联系人2">
				<ui:dataview format="sys.ui.classic">
					<ui:source ref="sys.ui.ajaxxml2.source">
					</ui:source>
				</ui:dataview>
			</ui:content>
			<ui:content title="服务联系人2">
				<ui:dataview format="sys.ui.classic">
					<ui:source ref="sys.ui.ajaxxml2.source">
					</ui:source>
				</ui:dataview>
			</ui:content>
		</ui:tabpanel>
	</template:replace>
	
	<template:replace name="right">
		<ui:panel width="200" var-toggle="true">
			<ui:content title="服务联系人2">
				<ui:dataview format="sys.ui.classic">
					<ui:source ref="sys.ui.ajaxxml2.source">
					</ui:source>
				</ui:dataview>
			</ui:content>
		</ui:panel>
	</template:replace>
</template:include>
