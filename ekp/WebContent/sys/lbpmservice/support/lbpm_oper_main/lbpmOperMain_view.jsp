<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/lbpmservice/support/lbpm_oper_main/lbpmOperMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('lbpmOperMain.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/sys/lbpmservice/support/lbpm_oper_main/lbpmOperMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('lbpmOperMain.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-lbpmservice-support" key="table.lbpmOperMain"/></p>

<center>
<table class="tb_normal" width=95% style="table-layout: fixed;">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.fdName"/>
		</td><td width="85%">
			<xform:text property="fdName" style="width:85%" />
		</td>
	</tr>
	<tr>
	    <td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.fdNodeType"/>
		</td><td width="85%">
			<xform:radio property="fdNodeType">
			    <xform:customizeDataSource className="com.landray.kmss.sys.lbpmservice.support.service.spring.NodeTypeDataSource" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.fdIsDefault"/>
		</td><td width="85%">
			<xform:radio property="fdIsDefault">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<c:if test="${!empty lbpmOperMainForm.drafterOperations}">
	<tr>
		<td class="td_normal_title" width=15% style="word-wrap:break-word">
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.lbpmOperations.creator" /><br>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.lbpmOperations.note" />
		</td><td width=85%>
			<%@ include file="/sys/lbpmservice/support/lbpm_oper_main/lbpmOperMain_view_draft.jsp"%>
		</td>
	</tr>
	</c:if>
	<c:if test="${!empty lbpmOperMainForm.handlerOperations}">
	<tr> 
		<td class="td_normal_title" width=15% style="word-wrap:break-word">
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.lbpmOperations.processor" /><br>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.lbpmOperations.processorNode" />
		</td>
		<td width="85%">
			<%@ include file="/sys/lbpmservice/support/lbpm_oper_main/lbpmOperMain_view_processor.jsp"%>
		</td>
	</tr>
	</c:if>
	<c:if test="${!empty lbpmOperMainForm.historyhandlerOperations}">
	<tr> 
		<td class="td_normal_title" width=15% style="word-wrap:break-word">
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.lbpmOperations.historyhandler" /><br>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.lbpmOperations.historyhandlerNode" />
		</td>
		<td width="85%">
			<%@ include file="/sys/lbpmservice/support/lbpm_oper_main/lbpmOperMain_view_historyhandler.jsp"%>
		</td>
	</tr>
	</c:if>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>