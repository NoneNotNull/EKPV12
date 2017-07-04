<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<template:replace name="head">
	</template:replace>
	<template:replace name="title">
		${lfn:message('kms-wiki:kmsWiki.compVersion')}-${firstModel.docSubject }
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<ui:button text="${lfn:message('button.close')}" onclick="Com_CloseWindow();" order="5"/>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" >
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_blank"/>
			<ui:menu-item text="${lfn:message('kms-wiki:menu.kmsWiki.main') }" href="/kms/wiki" target="_blank"/>
			<ui:menu-item 
				text="${firstModel.docSubject}" 
				target="_blank"/>
			<ui:menu-item text="${lfn:message('kms-wiki:kmsWiki.compVersion')}"/>
		</ui:menu>
	</template:replace>
	<template:replace name="content">
		<div class="lui_form_subject">${firstModel.docSubject }</div>
		<center>
			<table id="tb_normal" width=95%>
				<tr>
					<td class="td_normal_title">
						${lfn:message('kms-wiki:kmsWikiMain.compare.version')}${firstModel.fdVersion}&nbsp;&nbsp;&nbsp;&nbsp;${firstModel.docCreator.fdName}&nbsp;&nbsp;&nbsp;&nbsp;<kmss:showDate value="${not empty firstModel.docAlterTime ? firstModel.docAlterTime : firstModel.docCreateTime}" type="date" />
					</td>
					<td class="td_normal_title">
						${lfn:message('kms-wiki:kmsWikiMain.compare.version')}${secondModel.fdVersion}&nbsp;&nbsp;&nbsp;&nbsp;${secondModel.docCreator.fdName}&nbsp;&nbsp;&nbsp;&nbsp;<kmss:showDate value="${not empty secondModel.docAlterTime ? secondModel.docAlterTime : secondModel.docCreateTime}" type="date" />
					</td>
				</tr>
				<tr>
					<td valign="top" height="530px">
						<iframe src="${ LUI_ContextPath}/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=displayVersion&fdId=${firstId}&viewPattern=edition" 
								width="100%" 
								id="left" 
								height="100%" 
								style="overflow-x:hidden;">
						</iframe>
						
					</td>
					<td valign="top" height="530px">
						<iframe src="${ LUI_ContextPath}/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=displayVersion&fdId=${secondId}&viewPattern=edition" 
							    width="100%" id="right" height="100%" style="overflow-x:hidden;">
						</iframe>
					</td>
				</tr>
			</table>
		</center>
	</template:replace>
</template:include>