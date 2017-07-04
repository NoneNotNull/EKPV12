<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>


<c:set var="navForm" value="${requestScope[param.formName] }" scope="request" />

<template:include ref="default.edit" width="95%" sidebar="no">

 	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;">
			<c:if test="${param.readOnly != 'true' }">
				<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home">
				</ui:menu-item>
				<c:if test="${not empty param.parentModuleName }">
					<ui:menu-item text="${ param.parentModuleName }">
					</ui:menu-item>
				</c:if>
				<ui:menu-item text="${ param.moduleName }">
				</ui:menu-item>
				<ui:menu-item text="${ param.modelName  }">
				</ui:menu-item>
			</c:if>
		</ui:menu>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="95%">
				<c:choose>
					<c:when test="${ navForm.method_GET == 'add' }">
						<ui:button text="${lfn:message('button.save') }" order="2" onclick=" Com_Submit(document.${param.formName}, 'save');">
						</ui:button>
					</c:when>
					<c:when test="${ navForm.method_GET == 'edit' }">					
						<ui:button text="${lfn:message('button.update') }" order="2" onclick=" Com_Submit(document.${param.formName}, 'update');">
						</ui:button>
						<c:if test="${ param.readOnly != 'true' }">
						<ui:button text="${lfn:message('button.delete') }" order="3" onclick="deleteNav();">
						</ui:button>
						</c:if>
					</c:when>
				</c:choose>
				<ui:button text="${lfn:message('button.close') }" order="5" onclick="Com_CloseWindow();">
				</ui:button>
		</ui:toolbar>
	</template:replace>	
	<template:replace name="content">
		
		<html:form action="${param.actionPath }">
		<p class="txttitle">
			<template:block name="txttitle"></template:block>
		</p> 
		<center>
		<table class="tb_normal" width=95%>
			<col width="15%">
			<col width="35%">
			<col width="15%">
			<col width="35%">
			<tr>
				<td class="td_normal_title">
					<bean:message bundle="sys-zone" key="sysZoneNavigation.fdName"/>
				</td>
				<td colspan="3">
					<c:set var="_showStatus" value="${param.readOnly eq 'true' ? 'view' : 'edit'}" />
					<xform:text property="fdName" style="width:90%" showStatus="${_showStatus }" 
						htmlElementProperties="maxlength='150'" required="true" 
						subject="${lfn:message('sys-zone:sysZoneNavigation.fdName') }" />
					<xform:text property="fdType" showStatus="noShow" />
				</td>
			</tr>
				<tr>
					<td class="td_normal_title">
						<bean:message bundle="sys-zone" key="sysZoneNavigation.fdStatus"/>
					</td>
					<td>
						<xform:select property="fdStatus" required="true" showPleaseSelect="false">
							<xform:enumsDataSource enumsType="sysZone_fdStatus" />
						</xform:select>
					</td>
					<td class="td_normal_title">
						<bean:message bundle="sys-zone" key="sysZoneNavigation.fdShowType"/>
					</td>
					<td>
							<xform:select property="fdShowType" required="true" showPleaseSelect="false"
									 onValueChange="showTypeChange" 
									 showStatus="${navForm.method_GET=='add' ? 'edit' : 'readOnly'}">
								<xform:enumsDataSource enumsType="sysZone_fdShowType" />
							</xform:select>
					</td>					
			</tr>			
			<template:block name="example">
			<%-- 样例图片 --%>
			</template:block>
			<template:block name="link_title">
			<tr class="tr_normal_title">
				<td colspan="4">
					<bean:message bundle="sys-zone" key="sysZoneNavigation.docContent"/>
				</td>
			</tr>
			</template:block>
			<template:block name="links">
			<%@ include file="/sys/zone/sys_zone_nav_link/include/links.jsp" %>
			</template:block>
			<template:block name="mng_info">
				<%-- 权限相关 --%>
			</template:block>
			<tr>
				<td class="td_normal_title">
					<bean:message bundle="sys-zone" key="sysZoneNavigation.docCreator"/>
				</td>
				<td>
					<c:out value="${navForm.docCreatorName }" />
				</td>
				<td class="td_normal_title">
					<bean:message bundle="sys-zone" key="sysZoneNavigation.docCreateTime"/>
				</td><td>
					<c:out value="${navForm.docCreateTime }" />
				</td>
			</tr>
			<c:if test="${not empty navForm.docAlterorName}">
			<tr>
				<td class="td_normal_title">
					<bean:message bundle="sys-zone" key="sysZoneNavigation.docAlteror"/>
				</td>
				<td >
					<c:out value="${navForm.docAlterorName }" />
				</td>
				<td class="td_normal_title">
					<bean:message bundle="sys-zone" key="sysZoneNavigation.docAlterTime"/>
				</td>
				<td>
					<c:out value="${navForm.docAlterTime }" />
				</td>
			</tr>
			</c:if>
		</table>
		</center>
		<html:hidden property="fdId" />
		<html:hidden property="method_GET" />
		
		</html:form>
		<script type="text/javascript">	
		Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|xform.js", null, "js");
		</script>		
		<script>
		$KMSSValidation(document.${param.formName});

		function deleteNav(){
			seajs.use(['lui/dialog'],function(dialog){
				dialog.confirm("确定删除？",function(val){
					if(val == true) {
						location.href = "${LUI_ContextPath}/sys/zone/sys_zone_navigation/sysZoneNavigation.do?method=delete&fdId=${navForm.fdId}";
					} 
				});
			});
		}
		</script>
		<br>
		<br>
	</template:replace>
</template:include>