<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request" />
<c:set var="sysNotifyRemindMainContextForm" value="${mainModelForm.sysNotifyRemindMainContextForm}" scope="request" />
<script type="text/javascript">Com_IncludeFile("doclist.js");</script>
<script type="text/javascript">DocList_Info.push("${param.fdPrefix}_${param.fdKey}");</script>
<style type="text/css">
	.sys_notify_add{color: #1354ca;}
	.sys_notify_add:HOVER {text-decoration: underline;}
</style>
 <table  class="tb_simple" width="100%" id="${param.fdPrefix}_${param.fdKey}" >
 	<%--基准行 --%>
	<tr KMSS_IsReferRow="1" style="display:none">
		 <td>
		 	<input  type="hidden" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[!{index}].fdModelName" value="${param.fdModelName}"  />
		 	<kmss:editNotifyType value="todo" property="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[!{index}].fdNotifyType" multi="false" ></kmss:editNotifyType>
	       	<input style="width: 50px;" type="text" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[!{index}].fdBeforeTime" value="30"  />
			<xform:select property="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[!{index}].fdTimeUnit" value="minute" showStatus="edit" showPleaseSelect="false">
				<xform:enumsDataSource enumsType="sys_notify_fdTimeUnit" />
			</xform:select>
			<span>
		    	<a href="javascript:void(0);" onclick="sysNotifyRemind_Delete(this);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_ContextPath}sys/notify/images/delete_btn.png" border="0"  title="<bean:message key="button.delete"/>"/></a>
		     </span>
	    </td>
	</tr>
	<%--内容行--%>
    <c:forEach items="${sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList}" var="sysNotifyRemindMainFormListItem" varStatus="vstatus">
	<tr KMSS_IsContentRow="1">
		 <td>
		 	<input type="hidden" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdId" value="${sysNotifyRemindMainFormListItem.fdId}" />
		 	<input type="hidden" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdModelId" value="${sysNotifyRemindMainFormListItem.fdModelId}" />
		 	<input type="hidden" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdKey" value="${sysNotifyRemindMainFormListItem.fdKey}" />
		 	<input type="hidden" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdModelName" value="${param.fdModelName}" />
		 	<kmss:editNotifyType property="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdNotifyType" multi="false" ></kmss:editNotifyType>
			<input style="width:50px" type="text" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdBeforeTime" value="${sysNotifyRemindMainFormListItem.fdBeforeTime}" />
			<xform:select property="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdTimeUnit" value="${sysNotifyRemindMainFormListItem.fdTimeUnit}" showStatus="edit" showPleaseSelect="false">
				<xform:enumsDataSource enumsType="sys_notify_fdTimeUnit" />
			</xform:select>
			<span>
			 	<a href="javascript:void(0);" onclick="sysNotifyRemind_Delete(this);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_ContextPath}sys/notify/images/delete_btn.png" border="0"  title="<bean:message key="button.delete"/>"/></a>
			</span>
	    </td>
	</tr>
   </c:forEach> 
	<tr>
	  	<td align="left">
	    	<div style="width:100px;" >
			    <a href="javascript:void(0);"  onclick="DocList_AddRow();" class="sys_notify_add"><bean:message bundle="sys-notify" key="sysNotify.remind.add"/></a>
	     	</div>
	  	</td>
	</tr>
</table>
<script type="text/javascript">
	//删除消息列
	function sysNotifyRemind_Delete(self){
		var tr=$(self).parents("tr").eq(0);
		tr.find("[name$='fdModelName']").val("");
		tr.hide();
	}
</script>