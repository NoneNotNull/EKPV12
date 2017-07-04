<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<script>
Com_IncludeFile("dialog.js");
Com_IncludeFile("tools.js","${KMSS_Parameter_ContextPath}tib/common/resource/js/","js",true);
</script>
<html:form action="/tib/sys/core/control/tib_sys_core_control/tibSysCoreControl.do">
<div id="optBarDiv">
	<c:if test="${tibSysCoreControlForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="saveFdData();Com_Submit(document.tibSysCoreControlForm, 'update');">
	</c:if>
	<c:if test="${tibSysCoreControlForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="saveFdData();Com_Submit(document.tibSysCoreControlForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="saveFdData();Com_Submit(document.tibSysCoreControlForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-sys-core-control" key="table.tibSysCoreControl"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-core-control" key="tibSysCoreControl.fdFunc"/>
		</td><td colspan="3" width="85%">
			<input type="hidden" name="fdFuncId" value="" />
			<input type="text" name="fdFuncName" value="" />
			<input type="button" value="选择" class="btnopt" onclick="Tib_treeDialog('fdFuncId', 'fdFuncName', Tib_treeDialog_buildTemplate);"/>
		</td>
	</tr>
</table>
</center>

<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script type="text/javascript">
	$KMSSValidation();
	function Tib_treeDialog(idField, nameField, action) {
		var t_bean="tibCommonMappingControlTreeBean&serviceBean=tibSoapControlTreeInfo&selectId=!{value}&type=cate";
		var d_bean="tibCommonMappingControlTreeBean&serviceBean=tibSoapControlTreeInfo&selectId=!{value}&type=func";
		var s_bean="tibCommonMappingControlTreeBean&serviceBean=tibSoapControlTreeInfo&keyword=!{keyword}&type=search";
		//输入参数有点眼花,换成这种
		var data = {
			idField : idField,
			nameField : nameField,
			treeBean : t_bean,
			treeTitle :'选择',
			dataBean : d_bean,
			action : action,
			searchBean : s_bean,
			winTitle : '选择'
		};
		TibUtil.tibTreeDialog(data);
	}
	function Tib_treeDialog_buildTemplate(rtnData) {
		alert(rtnData);
	}
	var dialogObj = {
			"_source" : "tib",
			"_key" : "aaaaaaaaa",
			"_keyName" : "bbbbbbb"
		};
	var rtnVal = window.showModalDialog(Com_Parameter.ContextPath
			+ "tib/common/resource/jsp/dialog/dialog.jsp",dialogObj,"dialogWidth:600px;dialogHeight:400px");
</script>
</html:form>

<%@ include file="/resource/jsp/edit_down.jsp"%>