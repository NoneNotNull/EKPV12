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
			<c:if test="${param.readOnly == 'true' }">
				<ui:menu-item text="${ lfn:message('home.home') }" href="/" icon="lui_icon_s_home">
				</ui:menu-item>
				<ui:menu-item text="${ param.moduleName }" href="/sys/person" target="_self">
				</ui:menu-item>
				<ui:menu-item text="${ param.modelName  }" href="" target="_self">
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
						<ui:button text="${lfn:message('button.delete') }" order="3" onclick=" Com_OpenWindow('${LUI_ContextPath}${param.actionPath}?method=delete&fdId=${navForm.fdId}', '_self');">
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
			<template:block name="base_info">
			<%@ include file="/sys/person/sys_person_link/include/base_info.jsp" %>
			</template:block>
			<template:block name="example">
			<%-- 样例图片 --%>
			</template:block>
			<template:block name="link_title">
			<tr class="tr_normal_title">
				<td colspan="4">
					<bean:message bundle="sys-person" key="sysPersonLink.content"/>
				</td>
			</tr>
			</template:block>
			<template:block name="links">
			<%@ include file="/sys/person/sys_person_link/include/links.jsp" %>
			</template:block>
			<template:block name="mng_info">
				<%-- 权限相关 --%>
			</template:block>
			<template:block name="base_attr">
			<%@ include file="/sys/person/sys_person_link/include/base_attr.jsp" %>
			</template:block>
		</table>
		</center>
		<html:hidden property="fdId" />
		<html:hidden property="method_GET" />
		<script type="text/javascript">	
		Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|xform.js", null, "js");
		</script>		
		<script>
		$KMSSValidation(document.${param.formName});
		</script>
		</html:form>
		<br>
		<br>
	</template:replace>
</template:include>