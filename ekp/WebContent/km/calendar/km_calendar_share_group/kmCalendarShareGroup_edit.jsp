<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
   <template:replace name="content">
   		<script language="JavaScript">
			Com_IncludeFile("doclist.js|dialog.js");
			function saveUserKmCalendarShareGroup(formObj,method){
				alert('formObj='+formObj+' ,method='+method);
				Com_Submit(formObj, method);
				//$dialog.hide();
			}
		</script>
       <html:form action="/km/calendar/km_calendar_share_group/kmCalendarShareGroup.do?method=update">
			<br/><p class="txttitle">群组</p><br/>       
       		<table class="tb_normal" width=98% id="TABLE_DocList" align="center">
       			<%--标题--%>
       			<tr>
       				<%--群组名--%> 
					<td class="td_normal_title" style="width: 25%">
						<bean:message  bundle="km-calendar" key="kmCalendarShareGroup.fdName"/>
					</td>
					<%--群组人员--%> 
					<td class="td_normal_title" style="width: 70%">
						<bean:message  bundle="km-calendar" key="kmCalendarShareGroup.fdGroupMemberNames"/>
					</td>
					<td width="5%">
						<a onclick="DocList_AddRow(TABLE_DocList);" style="cursor: pointer;"><div style="width: 16px;height: 16px;" class="lui_icon_s_icon_add_green" ></div></a>
					</td>
       			</tr>
       			<%--基准行--%>
				<tr KMSS_IsReferRow="1" style="display: none">
					
					<%--群组名--%> 					
					<td width="25%">
						<input type="hidden" name="kmCalendarShareGroupForms[!{index}].fdId"/>
						<xform:text property="kmCalendarShareGroupForms[!{index}].fdName" style="width:98%" showStatus="edit"></xform:text>
					</td>
					<%--群组人员--%> 
					<td width="70%">
						<xform:address subject="${lfn:message('km-calendar:kmCalendarShareGroup.fdGroupMemberNames') }" style="width:90%"  orgType='ORG_TYPE_PERSON'
							propertyId="kmCalendarShareGroupForms[!{index}].fdGroupMemberIds" propertyName="kmCalendarShareGroupForms[!{index}].fdGroupMemberNames" ></xform:address>
					</td>
					<td width="5%">
						<a onclick="DocList_DeleteRow();" style="cursor: pointer;"><div style="width: 16px;height: 16px;" class="lui_icon_s_icon_close_red" ></div></a>
					</td>
				</tr>
       		</table>
       		<div style="text-align: center;padding-top: 10px;">
		   		<ui:button  text="${lfn:message('button.save')}"  onclick="saveUserKmCalendarShareGroup(document.kmCalendarUserShareGroupForm, 'update');" style="width:70px;"/>
		   	</div>
       </html:form>
   </template:replace>
</template:include>