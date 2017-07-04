<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include ref="person.cfg">
	<template:replace name="title">
		<template:super/> - 个人自定义快捷操作
	</template:replace>
	<template:replace name="content">
	
		<ui:panel layout="sys.ui.panel.light" scroll="false" toggle="false">
		<ui:content title="个人自定义快捷操作">
		<ui:toolbar layout="sys.ui.toolbar.default" style="float:right;" count="5">
			<ui:button href="/sys/person/sys_person_mytab_category/sysPersonMyTabCategory.do?method=add&type=shortcut" target="_blank" title="新建快捷操作" text="新建快捷操作" />
			<ui:button href="/sys/person/sys_person_mytab_category/sysPersonMyTabCategory.do?method=add&type=hotlink" target="_blank" title="新建常用链接" text="新建常用链接" />
			<ui:button onclick="PersonOnUpdateStatus(2, true);" title="启用" text="启用" />
			<ui:button onclick="PersonOnUpdateStatus(1, true);" title="禁用" text="禁用" />
			<ui:button onclick="PersonOnDeleteAll(true);" title="删除" text="删除" />
		</ui:toolbar>
		
		<html:form action="/sys/person/sys_person_mytab_category/sysPersonMyTabCategory.do">
		<table id="categoriesTable" class="tb_normal detail_table" width="100%">
			<tr class="tr_normal_title">
				<td width="5%" align="center"><input type="checkbox" name="List_Tongle"></td>
				<td width="10%"><bean:message key="page.serial" /></td>
				<td width=30%>名称</td>
				<td width=15%>状态</td>
				<td width=20%>创建人</td>
				<td width=20%>创建时间</td>
			</tr>
			<c:forEach items="${list}" var="category" varStatus="vstatus">
			<tr data-url='<c:url value="/sys/person/sys_person_mytab_category/sysPersonMyTabCategory.do?method=edit" />&fdId=${category.fdId }' style="cursor: pointer;">
				<td align="center">
					<input type="checkbox" name="List_Selected" value="${category.fdId }">
				</td>
				<td>
					${vstatus.index + 1}
				</td>
				<td>
					<c:out value="${category.fdName }" />
				</td>
				<td>
					<sunbor:enumsShow enumsType="sysPerson_fdStatus" value="${category.fdStatus }" />
				</td>
				<td>
					<c:out value="${category.docCreator.fdName }" />
				</td>
				<td>
					<kmss:showDate value="${category.docCreateTime }" type="datetime" />
				</td>
			</tr>
			</c:forEach>
		</table>
		</html:form>
		</ui:content>
		</ui:panel>
		<script src="<c:url value="/sys/person/resource/utils.js" />"></script>
	</template:replace>
</template:include>