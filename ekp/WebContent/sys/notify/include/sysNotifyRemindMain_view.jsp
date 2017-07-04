<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request" />
<c:set var="sysNotifyRemindMainContextForm" value="${mainModelForm.sysNotifyRemindMainContextForm}" scope="request" />
<script type="text/javascript">
Com_IncludeFile("doclist.js");
</script>
<script type="text/javascript">
DocList_Info.push("${param.fdPrefix}_${param.fdKey}");
</script>
<tr>
 <td width="10%" style="padding:15px 0 15px 0" class="td_normal_title" align="center" height="15px">
   <bean:message bundle="sys-notify" key="sysNotify.remind.calendar.subject" />
 </td> 
 <td width="90%" style="padding:15px 0 15px 0">
   <table  class="tb_normal" width="100%" id="${param.fdPrefix}_${param.fdKey}" style="margin-top: -15px;TABLE-LAYOUT: fixed;WORD-BREAK: break-all;;margin-bottom: -15px;">
    <tr>
        <td width="10%" KMSS_IsRowIndex="1" class="td_normal_title"><bean:message key="page.serial" /></td>
		<td width="20%" class="td_normal_title"><bean:message bundle="sys-notify" key="sysNotify.remind.fdNotifyType" /></td>
		<td width="20%" class="td_normal_title"><bean:message bundle="sys-notify" key="sysNotify.remind.fdBeforeTime" /></td>
		<td width="20%" class="td_normal_title"><bean:message bundle="sys-notify" key="sysNotify.remind.fdTimeUnit" /></td>
	</tr>
	<!--内容行-->
	<c:forEach items="${sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList}" var="sysNotifyRemindMainFormListItem" varStatus="vstatus">
		<tr KMSS_IsContentRow="1">
		    <td width="10%" KMSS_IsRowIndex="1" align="center">${vstatus.index+1}</td>
			<td width="20%" class="td_normal_title">
				<xform:select property="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdNotifyType" value="${sysNotifyRemindMainFormListItem.fdNotifyType}">
					<xform:enumsDataSource enumsType="sys_notify_fdNotifyType" />
				</xform:select>
			</td>
			<td width="20%" class="td_normal_title">
			    <c:out value="${sysNotifyRemindMainFormListItem.fdBeforeTime}" />
			</td>
			<td width="20%" class="td_normal_title">
				<xform:select property="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdTimeUnit" value="${sysNotifyRemindMainFormListItem.fdTimeUnit}">
					<xform:enumsDataSource enumsType="sys_notify_fdTimeUnit" />
				</xform:select>
			</td>
		</tr>
	  </c:forEach>
    </table>
 </td>
</tr>