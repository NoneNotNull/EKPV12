<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request" />
<c:set var="sysNotifyRemindMainContextForm" value="${mainModelForm.sysNotifyRemindMainContextForm}" scope="request" />
<script type="text/javascript">Com_IncludeFile("doclist.js");</script>
<script type="text/javascript">DocList_Info.push("${param.fdPrefix}_${param.fdKey}");</script>
 <table  class="tb_simple" width="100%" id="${param.fdPrefix}_${param.fdKey}">
	<c:forEach items="${sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList}" var="sysNotifyRemindMainFormListItem" varStatus="vstatus">
		<tr KMSS_IsContentRow="1">
			 <td>
				<xform:select property="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdNotifyType" value="${sysNotifyRemindMainFormListItem.fdNotifyType}" showStatus="view">
					<xform:enumsDataSource enumsType="sys_notify_fdNotifyType" />
				</xform:select>
				<c:out value="${sysNotifyRemindMainFormListItem.fdBeforeTime}" />
                <xform:select property="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdTimeUnit" value="${sysNotifyRemindMainFormListItem.fdTimeUnit}" showStatus="view">
					<xform:enumsDataSource enumsType="sys_notify_fdTimeUnit" />
				</xform:select>
		    </td>
		</tr>
	</c:forEach> 
 </table>