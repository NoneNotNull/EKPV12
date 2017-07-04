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
			<td width="20%" class="td_normal_title"><bean:message bundle="sys-notify" key="sysNotify.remind.fdNotifyType" /><span class="txtstrong">*</span></td>
			<td width="20%" class="td_normal_title"><bean:message bundle="sys-notify" key="sysNotify.remind.fdBeforeTime" /><span class="txtstrong">*</span></td>
			<td width="20%" class="td_normal_title"><bean:message bundle="sys-notify" key="sysNotify.remind.fdTimeUnit" /><span class="txtstrong">*</span></td>
			<td width="85px;" align="center" class="td_normal_title">
		       <img src="${KMSS_Parameter_StylePath}icons/add.gif" style="cursor:pointer" onclick="DocList_AddRow();" title="<bean:message key="button.insert"/>">
		    </td>
		</tr>
		<!--基准行-->
		<tr KMSS_IsReferRow="1" style="display:none">
		    <td width="10%" KMSS_IsRowIndex="1" align="center">${index+1}</td>
			<td width="20%" class="td_normal_title">
				<xform:select property="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[!{index}].fdNotifyType" value="todo" showPleaseSelect="true">
					<xform:enumsDataSource enumsType="sys_notify_fdNotifyType" />
				</xform:select>
			</td>
			<td width="20%" class="td_normal_title">
				<input name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[!{index}].fdBeforeTime" value="1" class="inputsgl" style="width: 95%" />
			</td>
			<td width="20%" class="td_normal_title">
				<xform:select property="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[!{index}].fdTimeUnit" value="minute" showPleaseSelect="true">
					<xform:enumsDataSource enumsType="sys_notify_fdTimeUnit" />
				</xform:select>
			</td>
			<td align="center" width="10%">
				<a href="#" onclick="DocList_DeleteRow();" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/delete.gif" border="0"  title="<bean:message key="button.delete"/>"/></a>
			    <a href="#" onclick="DocList_MoveRow(-1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/up.gif" border="0"  title="<bean:message key="button.moveup"/>"/></a>
			    <a href="#" onclick="DocList_MoveRow(1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/down.gif" border="0"  title="<bean:message key="button.movedown"/>"/></a>
			</td>
		</tr>
		<!--内容行-->
	   <c:forEach items="${sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList}" var="sysNotifyRemindMainFormListItem" varStatus="vstatus">
		<tr KMSS_IsContentRow="1">
		    <td width="10%" KMSS_IsRowIndex="1" align="center">${vstatus.index+1}</td>
			<td width="20%" class="td_normal_title">
				<xform:select property="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdNotifyType" value="${sysNotifyRemindMainFormListItem.fdNotifyType}" showPleaseSelect="true">
					<xform:enumsDataSource enumsType="sys_notify_fdNotifyType" />
				</xform:select>
			</td>
			<td width="20%" class="td_normal_title">
				<input name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdBeforeTime" class="inputsgl" style="width: 95%"  value="${sysNotifyRemindMainFormListItem.fdBeforeTime}" />
			</td>
			<td width="20%" class="td_normal_title">
				<xform:select property="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdTimeUnit" value="${sysNotifyRemindMainFormListItem.fdTimeUnit}" showPleaseSelect="true">
					<xform:enumsDataSource enumsType="sys_notify_fdTimeUnit" />
				</xform:select>
			</td>
			<td align="center" width="10%">
				<a href="#" onclick="DocList_DeleteRow();" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/delete.gif" border="0"  title="<bean:message key="button.delete"/>"/></a>
			    <a href="#" onclick="DocList_MoveRow(-1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/up.gif" border="0"  title="<bean:message key="button.moveup"/>"/></a>
			    <a href="#" onclick="DocList_MoveRow(1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/down.gif" border="0"  title="<bean:message key="button.movedown"/>"/></a>
			</td>
			<input type="hidden" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdKey" value="${sysNotifyRemindMainFormListItem.fdKey}" />
		</tr>
	   </c:forEach> 
		<tr>
		  <td colspan="3" width="100px;" align="left">
		     <div onclick="DocList_AddRow();">
		         <img src="${KMSS_Parameter_StylePath}icons/add.gif" style="cursor:pointer" title="<bean:message bundle="sys-notify" key="sysNotify.remind.add"/>" >
			     <a href="#"><bean:message bundle="sys-notify" key="sysNotify.remind.add"/></a>
		     </div>
		  </td>
		</tr>
	  </table>
	 </td>
</tr>