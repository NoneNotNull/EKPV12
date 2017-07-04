<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysEditionForm" value="${requestScope[param.formName].editionForm}" />
<ui:content title="${lfn:message('sys-edition:sysEditionMain.tab.label') }">
	<html:hidden property="editionForm.fdModelId" />
	<html:hidden property="editionForm.fdModelName" />
	<html:hidden property="editionForm.mainVersion" />
	<html:hidden property="editionForm.auxiVersion" />
	<html:hidden property="editionForm.isNewVersion" />
	<ui:event event="show"> 
			var url = '<%= request.getContextPath() %>/sys/edition/sys_edition_main/sysEditionMain_list.jsp?fdModelName=${sysEditionForm.fdModelName}&fdModelId=${sysEditionForm.fdModelId}&currentVer=${sysEditionForm.mainVersion}.${sysEditionForm.auxiVersion}';
			document.getElementById("editionContent").setAttribute("src",url);
	</ui:event>
	<iframe id="editionContent" width=100% height=100% frameborder=0 scrolling=no style="min-height: 110px">
	</iframe>
</ui:content>

