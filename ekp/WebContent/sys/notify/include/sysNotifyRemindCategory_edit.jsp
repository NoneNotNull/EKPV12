<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="templateForm" value="${requestScope[param.formName]}" scope="request" />
<c:set var="sysNotifyRemindCategoryContextForm" value="${templateForm.sysNotifyRemindCategoryContextForm}" scope="request" />
<style>
	.tb_simple td{border: 0px;}
	.sys_notify_add{color: #1354ca;}
	.sys_notify_add:HOVER {text-decoration: underline;}
</style>
<script type="text/javascript">Com_IncludeFile("doclist.js");</script>
<script type="text/javascript">
	DocList_Info.push("${param.fdPrefix}_${param.fdKey}");
	// 拼接动态行的错误消息提示
	function getDynRowAlertMsg(fdNotifyType_index,fdBeforeTime_index,fdTimeUnit_index,row){
		var msg = "";
		if (fdNotifyType_index.length > 0) {
			if (!fdNotifyType_index.val()) {
				msg += '<bean:message bundle="sys-notify" key="sysNotify.the"/>' + row + '<bean:message bundle="sys-notify" key="sysNotify.row"/><bean:message bundle="sys-notify" key="sysNotify.remind.fdNotifyType"/><bean:message bundle="sys-notify" key="validate.notNull"/>\n';
			}
		}
		if (fdBeforeTime_index.length > 0) {
			if (!fdBeforeTime_index.val()) {
				msg += '<bean:message bundle="sys-notify" key="sysNotify.the"/>' + row + '<bean:message bundle="sys-notify" key="sysNotify.row"/><bean:message bundle="sys-notify" key="sysNotify.remind.fdBeforeTime"/><bean:message bundle="sys-notify" key="validate.notNull"/>\n';
			}
		}
		if (fdTimeUnit_index.length > 0) {
			if (!fdTimeUnit_index.val()) {
				msg += '<bean:message bundle="sys-notify" key="sysNotify.the"/>' + row + '<bean:message bundle="sys-notify" key="sysNotify.row"/><bean:message bundle="sys-notify" key="sysNotify.remind.fdTimeUnit"/><bean:message bundle="sys-notify" key="validate.notNull"/>\n';
			}
		}
		return msg;
	}
	// 新增或者修改"同步日程"时候的验证
	Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function(){
		var dynRowObj = $('#${param.fdPrefix}_${param.fdKey}').find("tr");
		var minDynRow = dynRowObj.length;
		var msg="";
		if(minDynRow<=2){
			return true;
		}else{
			dynRowObj.each(function(i) {
				if(i>0&&i<minDynRow){//校验跳过表头行,表尾行
					var index = (parseInt(i) - 1); //调整动态行元素下标
					var fdNotifyType_index = $(this).find(":input[name$='fdNotifyType']");
					var fdBeforeTime_index = $(this).find(':input[name$="fdBeforeTime"]');
					var fdTimeUnit_index = $(this).find(':input[name$="fdTimeUnit"]');
					var row = (parseInt(i));  //调整动态行提示内容下标
					msg  += getDynRowAlertMsg(fdNotifyType_index,fdBeforeTime_index,fdTimeUnit_index,row);
			    }
			});
		}
		if(msg!=""){
			alert(msg);
			return false;
		}else{
			return true;
		}
	};
</script>
 <table  class="tb_simple" style="border-collapse: collapse;" width="100%" id="${param.fdPrefix}_${param.fdKey}">
	<%--基准行--%>
	<tr KMSS_IsReferRow="1" style="display:none">
		<td>
			<kmss:editNotifyType value="todo" property="sysNotifyRemindCategoryContextForm.sysNotifyRemindCategoryFormList[!{index}].fdNotifyType" multi="false" ></kmss:editNotifyType>
			<input name="sysNotifyRemindCategoryContextForm.sysNotifyRemindCategoryFormList[!{index}].fdBeforeTime" value="30"  style="width: 50px;"/>
			<xform:select property="sysNotifyRemindCategoryContextForm.sysNotifyRemindCategoryFormList[!{index}].fdTimeUnit" value="minute" showPleaseSelect="false">
				<xform:enumsDataSource enumsType="sys_notify_fdTimeUnit" />
			</xform:select>
			<a href="javascript:void(0);" onclick="DocList_DeleteRow();" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_ContextPath}sys/notify/images/delete_btn.png" border="0"  title="<bean:message key="button.delete"/>"/></a>
		</td>
	</tr>
	<%--内容行--%>
   <c:forEach items="${sysNotifyRemindCategoryContextForm.sysNotifyRemindCategoryFormList}" var="sysNotifyRemindCategoryFormListItem" varStatus="vstatus">
	<tr KMSS_IsContentRow="1">
		<td>
			<kmss:editNotifyType property="sysNotifyRemindCategoryContextForm.sysNotifyRemindCategoryFormList[${vstatus.index}].fdNotifyType" multi="false" ></kmss:editNotifyType>
			<input name="sysNotifyRemindCategoryContextForm.sysNotifyRemindCategoryFormList[${vstatus.index}].fdBeforeTime" style="width: 60px;"  value="${sysNotifyRemindCategoryFormListItem.fdBeforeTime}" />
			<xform:select property="sysNotifyRemindCategoryContextForm.sysNotifyRemindCategoryFormList[${vstatus.index}].fdTimeUnit" value="${sysNotifyRemindCategoryFormListItem.fdTimeUnit}" showPleaseSelect="false">
				<xform:enumsDataSource enumsType="sys_notify_fdTimeUnit" />
			</xform:select>
			<a href="javascript:void(0);" onclick="DocList_DeleteRow();" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_ContextPath}sys/notify/images/delete_btn.png" border="0" title="<bean:message key="button.delete"/>" /></a>
		</td>
	</tr>
   </c:forEach>
	<tr>
	  <td align="left">
	     <div style="width: 100px;">
		     <a href="javascript:void(0);" onclick="DocList_AddRow();" class="sys_notify_add"><bean:message bundle="sys-notify" key="sysNotify.remind.add"/></a>
	     </div>
	  </td>
	</tr>
 </table>