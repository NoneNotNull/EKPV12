<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%-- 样式 --%>
<style>
	.lui_imeeting_title{
		float: left;
		width: 60%;
		font-size: 16px;
		padding-left: 8px;
		line-height: 30px;
		height: 30px;
		border-bottom: 1px #d9d9d9 solid;
		margin-bottom: 10px;
	}
</style>
<%-- 权限 --%>
<div>
	<div class="com_subject lui_imeeting_title">
		${ lfn:message('sys-right:right.moduleName') }
	</div>
</div>
<div>
	<table class="tb_normal" width=100%>
		<%@ include file="/sys/right/right_edit.jsp"%>
	</table>
</div>
<%-- 流程 --%>
<div>
	<div class="com_subject lui_imeeting_title">
		${ lfn:message('sys-lbpmservice:lbpm.tab.label') }
	</div>
</div>
<div>
	<c:set var="sysWfBusinessForm" value="${requestScope[param.formName]}" />
	<c:set var="lbpmProcessForm" value="${sysWfBusinessForm.sysWfBusinessForm.internalForm}" />
	<c:set var="resize_prefix" value="_" scope="request" />
	<c:if test="${sysWfBusinessForm.sysWfBusinessForm!=null}">
		<ui:event event="show">
			if (this.isBindOnResize) {
				return;
			}
			var element = this.element;
			function onResize() {
				element.find("*[_onresize]").each(function(){
					var elem = $(this);
					var funStr = elem.attr("_onresize");
					var show = elem.closest('tr').is(":visible");
					var init = elem.attr("data-init-resize");
					if(funStr!=null && funStr!="" && show && init == null){
						elem.attr("data-init-resize", 'true');
						var tmpFunc = new Function(funStr);
						tmpFunc.call();
					}
				});
			}
			this.isBindOnResize = true;
			onResize();
			element.click(onResize);
		</ui:event>
	<%@ include file="/sys/lbpmservice/common/process_edit.jsp"%>
	</c:if>
</div>
<%-- 日程同步 --%>
<c:set var="sysAgendaMainForm" value="${requestScope[param.formName]}" />
<c:if test="${sysAgendaMainForm.syncDataToCalendarTime=='sendNotify'||sysAgendaMainForm.syncDataToCalendarTime=='personAttend'}">
	<div>
		<div class="com_subject lui_imeeting_title" >
			${ lfn:message('sys-agenda:module.sys.agenda.syn') }
		</div>
	</div>
	<table class="tb_normal" width=100%>
		<tr>
		   <td width="15%"  class="tb_normal">
		   		<%--同步时机--%>
		       	<bean:message bundle="sys-agenda" key="module.sys.agenda.syn.time" />
		   </td>
		   <td width="85%" colspan="3">
		       <xform:radio property="syncDataToCalendarTime" showStatus="edit">
		       		<xform:enumsDataSource enumsType="kmImeetingMain_syncDataToCalendarTime" />
				</xform:radio>
		   </td>
		</tr>
		<tr>
			<td colspan="4" style="padding: 0px;">
				<c:import url="/sys/agenda/import/sysAgendaMain_general_edit.jsp"	charEncoding="UTF-8">
					<c:param name="formName" value="${param.formName }" />
					<c:param name="fdKey" value="${param.fdKey}" />
					<c:param name="fdPrefix" value="sysAgendaMain_formula_edit" />
					<c:param name="fdModelName" value="${param.moduleModelName}" />
					<%--可选字段 1.syncTimeProperty:同步时机字段； 2.noSyncTimeValues:当syncTimeProperty为此值时，隐藏同步机制 --%>
					<c:param name="syncTimeProperty" value="syncDataToCalendarTime" />
					<c:param name="noSyncTimeValues" value="noSync" />
				</c:import>
			</td>
		</tr>
	</table>
</c:if>