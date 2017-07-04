<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/ask/kms_ask_category/kmsAskCategory.do">
<div id="optBarDiv">
	<c:if test="${kmsAskCategoryForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsAskCategoryForm, 'update');">
	</c:if>
	<c:if test="${kmsAskCategoryForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsAskCategoryForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsAskCategoryForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-ask" key="table.kmsAskCategory"/></p>

<center>
<table class="tb_normal" width=95%>
	<c:import url="/sys/simplecategory/include/sysCategoryMain_edit.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmsAskCategoryForm" />
		<c:param name="requestURL" value="/kms/ask/kms_ask_category/kmsAskCategory.do?method=add" />
		<c:param name="fdModelName" value="${param.fdModelName}" />
	</c:import>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
<script type="text/javascript">
	Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function() {
		//提交前，校验类别名称唯一性
		if (checkAskName()) {
			return true;
		} else {
			return false;
		}
	}
	function checkAskName() {
		var fdName = document.getElementsByName("fdName")[0].value;
		var fdId = '${kmsAskCategoryForm.fdId}';
		var parentId = '${kmsAskCategoryForm.fdParentId}';
		if (fdName != "" && fdName != null) {
			var url = "kmsAskCategoryCheckService&fdName=" + fdName + "&fdId=" + fdId + "&parentId=" + parentId;
			url = Com_SetUrlParameter(url, "fdName", fdName);
			var data = new KMSSData();
			var rtnVal = data.AddBeanData(url).GetHashMapArray()[0];
			var flag = rtnVal["flag"];
			if (flag == 'true') {
				return true;
			} else {
				alert('<bean:message key="kmsAsk.msg.category.hasExist" bundle="kms-ask"/>');
				return false;
			}
		} else {
			alert('<bean:message key="kmsAsk.msg.category.notNull" bundle="kms-ask"/>');
			return false;
		}
	}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>