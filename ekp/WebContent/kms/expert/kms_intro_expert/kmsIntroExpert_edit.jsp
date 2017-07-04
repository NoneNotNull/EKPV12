<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script src="<c:url value="/kms/expert/js/lib/jquery.js" />" type="text/javascript"></script>
<script>
Com_IncludeFile("dialog.js");

function selectModel() {
	var dialog = new KMSSDialog(false, true);
	dialog.winTitle = "选择模块";
	dialog.AddDefaultOptionBeanData("kmsModuleDataBean");
	dialog.BindingField("fdModelId", "fdModelName", null, false);
	dialog.notNull = false;
	dialog.Show();
	return false;
}

function Dialog_KmsExpert() {

	/*var dialog = new KMSSDialog(true, true);
	var node = dialog.CreateTree("选择专家");
	dialog.winTitle = "选择专家";
	var dataBean = "kmsExpertByTypeDatabean&expertTypeId=!{value}";
	node.AppendBeanData("kmsExpertTypeTreeService&expertTypeId=!{value}", dataBean, null, null, false);
	node.parameter = dataBean;
	dialog.BindingField("fdExpertListIds", "fdExpertListNames", ";", false);
	dialog.Show();
	return false;*/

	var dialog = new KMSSDialog(true, true);
	var node = dialog.CreateTree("选择专家");
	dialog.winTitle = "选择专家";
	node.AppendBeanData("kmsExpertTypeTreeService&expertTypeId=!{value}", "kmsExpertByTypeDatabean&expertTypeId=!{value}", null, null, false);
	node.parameter = "kmsExpertByTypeDatabean&expertTypeId=!{value}";
	dialog.BindingField("fdExpertListIds", "fdExpertListNames", ";", false);
	dialog.SetAfterShow(null);
	dialog.Show();
}
</script>

<html:form action="/kms/expert/kms_intro_expert/kmsIntroExpert.do">
<div id="optBarDiv">
	<c:if test="${kmsIntroExpertForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsIntroExpertForm, 'update');">
	</c:if>
	<c:if test="${kmsIntroExpertForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsIntroExpertForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsIntroExpertForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-expert" key="table.kmsIntroExpert"/></p>

<center>
<table class="tb_normal" width="65%">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-expert" key="kmsIntroExpert.fdName"/>
		</td>
		<td colspan="3">
			<xform:text property="fdName" style="width:85%" />
		</td>
	</tr>
	<c:if test="${kmsIntroExpertForm.method_GET=='edit'}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-expert" key="kmsIntroExpert.fdPhase"/>
		</td>
		<td colspan="3">
			第<xform:text property="fdPhase" showStatus="view" style="width:85%" />期
		</td>
	</tr>
	</c:if>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-expert" key="kmsIntroExpert.fdModelName"/>
		</td>
		<td colspan="3">
			<xform:text property="fdModelName" style="width:85%" /><a href="#" onclick="selectModel();">选择</a>
			<html:hidden property="fdModelId" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-expert" key="kmsIntroExpert.fdRecommend"/>
		</td>
		<td colspan="3">
			<xform:textarea property="fdRecommend" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-expert" key="kmsIntroExpert.fdExpertList"/>
		</td>
		<td colspan="3">
			<html:hidden property="fdExpertListIds" />
			<html:textarea property="fdExpertListNames" styleClass="inputmul" style="width:85%"></html:textarea>
			<a href="#" onclick="Dialog_KmsExpert();">
				<bean:message key="dialog.selectOther"/>
			</a>
		</td>
	</tr>
	<c:if test="${kmsIntroExpertForm.method_GET=='edit'}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-expert" key="kmsIntroExpert.docCreateTime"/>
		</td>
		<td colspan="3">
			<xform:datetime property="docCreateTime" showStatus="view" />
		</td>
	</tr>
	</c:if>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("dialog.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>