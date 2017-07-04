<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="templateForm" value="${requestScope[param.formName]}" scope="request" />
<c:set var="sysNotifyRemindCategoryContextForm" value="${templateForm.sysNotifyRemindCategoryContextForm}" scope="request" />
<script type="text/javascript">Com_IncludeFile("doclist.js");</script>
<script type="text/javascript">DocList_Info.push("${param.fdPrefix}_${param.fdKey}");</script>
<style>
	.tb_simple td{border: 0px;}
</style>
<table  class="tb_simple" width="100%" id="${param.fdPrefix}_${param.fdKey}">
	<!--内容行-->
	<c:forEach items="${sysNotifyRemindCategoryContextForm.sysNotifyRemindCategoryFormList}" var="sysNotifyRemindCategoryFormListItem" varStatus="vstatus">
		<tr KMSS_IsContentRow="1">
			<td>
				<xform:select property="sysNotifyRemindCategoryContextForm.sysNotifyRemindCategoryFormList[${vstatus.index}].fdNotifyType" value="${sysNotifyRemindCategoryFormListItem.fdNotifyType}">
					<xform:enumsDataSource enumsType="sys_notify_fdNotifyType" />
				</xform:select>
				<c:out value="${sysNotifyRemindCategoryFormListItem.fdBeforeTime}" />
				<xform:select property="sysNotifyRemindCategoryContextForm.sysNotifyRemindCategoryFormList[${vstatus.index}].fdTimeUnit" value="${sysNotifyRemindCategoryFormListItem.fdTimeUnit}">
					<xform:enumsDataSource enumsType="sys_notify_fdTimeUnit" />
				</xform:select>
			</td>
		</tr>
	 </c:forEach>
</table>