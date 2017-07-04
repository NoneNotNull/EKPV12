<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" width="95%" sidebar="no">
	<template:replace name="title">
		<c:choose>
			<c:when test="${ sysPortalLinkForm.fdType == '1' }">
				${ lfn:message('sys-portal:sys_portal_link_type_1') }
			</c:when>
			<c:when test="${ sysPortalLinkForm.fdType == '2' }">					
				${ lfn:message('sys-portal:sys_portal_link_type_2') }	
			</c:when>
		</c:choose>	
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="95%">
				<kmss:auth requestURL="/sys/portal/sys_portal_link/sysPortalLink.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
					<ui:button text="${lfn:message('button.edit') }" onclick="Com_OpenWindow('sysPortalLink.do?method=edit&fdId=${param.fdId}','_self');">
					</ui:button>					
				</kmss:auth>
				<kmss:auth requestURL="/sys/portal/sys_portal_link/sysPortalLink.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
					<ui:button text="${lfn:message('button.delete') }" onclick="if(!confirmDelete())return;Com_OpenWindow('sysPortalLink.do?method=delete&fdId=${param.fdId}','_self');">
					</ui:button>
				</kmss:auth>
				<ui:button text="${lfn:message('button.close') }" order="5" onclick="Com_CloseWindow();">
				</ui:button>
		</ui:toolbar> 
	</template:replace>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="${empty varParams.target ? '_self' : varParams.target}">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-portal:module.sys.portal') }" href="/sys/portal" target="_self">
			</ui:menu-item>		
			<ui:menu-item text="${ lfn:message(fn:replace('sys-portal:sys_portal_link_type_***','***',sysPortalLinkForm.fdType)) }" href="#" target="_self">
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	<template:replace name="content">
		<script>
			function confirmDelete(msg){
			var del = confirm("<bean:message key="page.comfirmDelete"/>");
			return del;
		}
		</script>
		
		<p class="txttitle">
		<xform:select property="fdType">
				<xform:enumsDataSource enumsType="sys_portal_link_type" />
		</xform:select>
		</p>
		
		<center>
		<table class="tb_normal" width=95%>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="sys-portal" key="sysPortalLink.fdName"/>
				</td>
				<td width="35%" colspan="3">
					<xform:text property="fdName" style="width:85%" />
					<xform:text property="fdType" showStatus="hidden"></xform:text>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%>
					${ lfn:message('sys-portal:table.sysPortalLinkDetail') }
				</td>
				<td width="35%" colspan="3">
					 <table id="TABLE_DocList" class="tb_normal" width=100%>
						<tr> 
							<td align="center" class="td_normal_title">${ lfn:message('sys-portal:sysPortalLinkDetail.fdText') }</td> 
							<td align="center" class="td_normal_title">${ lfn:message('sys-portal:sysPortalLinkDetail.fdHref') }</td> 
							<c:if test="${ sysPortalLinkForm.fdType == '2' }">
								<td align="center" class="td_normal_title">${ lfn:message('sys-portal:sysPortalLinkDetail.fdIcon') }</td> 
							</c:if>
						</tr>
						<!--内容行-->
						<c:forEach items="${sysPortalLinkForm.fdLinks}" var="link" varStatus="vstatus">
							<tr KMSS_IsContentRow="1">
								<td width="20%">
									${link.fdName }
								</td>
								<td width="20%">
									${link.fdUrl }
								</td>
								<c:if test="${ sysPortalLinkForm.fdType == '2' }">
								<td width="20%">
									<div class="lui_icon_l" style="background: #C78700;">
										<div id='iconPreview_${vstatus.index}' class="lui_icon_l ${link.fdIcon }">
										</div>
									</div>
								</td>
								</c:if>
							</tr>
						</c:forEach>
					</table>
				</td>
			</tr>	
			<tr>
				<td class="td_normal_title" width="15%">${ lfn:message('sys-portal:common.msg.editors') }</td>
				<td colspan="3">
					<xform:address textarea="true" mulSelect="true" propertyId="fdEditorIds" propertyName="fdEditorNames" style="width:96%;height:90px;" ></xform:address>
				</td>
			</tr> 
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="sys-portal" key="sysPortalLink.docCreator"/>
				</td><td width="35%">
					<c:out value="${sysPortalLinkForm.docCreatorName}" />
				</td>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="sys-portal" key="sysPortalLink.docCreateTime"/>
				</td><td width="35%">
					<xform:datetime property="docCreateTime" />
				</td>
			</tr>
			<tr>				
				<td class="td_normal_title" width=15%>
					<bean:message bundle="sys-portal" key="sysPortalLink.docAlteror"/>
				</td><td width="35%">
					<c:out value="${sysPortalLinkForm.docAlterorName}" />
				</td>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="sys-portal" key="sysPortalLink.docAlterTime"/>
				</td><td width="35%">
					<xform:datetime property="docAlterTime" />
				</td>
			</tr>
		</table>
		</center>
		<br>
	</template:replace>
</template:include>