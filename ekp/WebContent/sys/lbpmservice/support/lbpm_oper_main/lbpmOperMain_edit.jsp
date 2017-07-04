<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/lbpmservice/support/lbpm_oper_main/lbpmOperMain.do">
<div id="optBarDiv">
	<c:if test="${lbpmOperMainForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="if(!validateForm())return;Com_Submit(document.lbpmOperMainForm, 'update');">
	</c:if>
	<c:if test="${lbpmOperMainForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="if(!validateForm())return;Com_Submit(document.lbpmOperMainForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="if(!validateForm())return;Com_Submit(document.lbpmOperMainForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<script>
    Com_IncludeFile("dialog.js|doclist.js");
</script>
<%@ include file="/sys/lbpmservice/support/lbpm_oper_main/lbpmOperMain_script.jsp"%>
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
			<xform:radio property="fdNodeType" onValueChange="selectOperationsGroup">
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
	<tr id="drafterGroup" style="display:none">
		<td class="td_normal_title" width=15% style="word-wrap:break-word">
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.lbpmOperations.creator" /><br>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.lbpmOperations.note" />
		</td><td width=85%>
			<%@ include file="/sys/lbpmservice/support/lbpm_oper_main/lbpmOperMain_edit_draft.jsp"%>
		</td>
	</tr>
	<tr id="processorGroup" style="display:none"> 
		<td class="td_normal_title" width=15% style="word-wrap:break-word">
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.lbpmOperations.processor" /><br>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.lbpmOperations.processorNode" />
		</td>
		<td width="85%">
			<%@ include file="/sys/lbpmservice/support/lbpm_oper_main/lbpmOperMain_edit_processor.jsp"%>
		</td>
	</tr>
	<tr id="historyhandlerGroup" style="display:none"> 
		<td class="td_normal_title" width=15% style="word-wrap:break-word">
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.lbpmOperations.historyhandler" /><br>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.lbpmOperations.historyhandlerNode" />
		</td>
		<td width="85%">
			<%@ include file="/sys/lbpmservice/support/lbpm_oper_main/lbpmOperMain_edit_historyhandler.jsp"%>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>