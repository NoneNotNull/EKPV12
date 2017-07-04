<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%--参数--%>
<c:set var="formName" value="kmsMultidocTemplateForm" />
<c:set var="requestURL" value="/kms/multidoc/kms_multidoc_template/kmsMultidocTemplate.do" />
<c:set var="fdId" value="${kmsMultidocTemplateForm.fdId}" />
<c:set var="fdModelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate" />
<script language="JavaScript">
	Com_IncludeFile("dialog.js");
</script>
	<%--标题--%>
	<kmss:windowTitle
		subjectKey="kms-multidoc:table.kmsMultidocTemplate"
		moduleKey="kms-multidoc:table.kmdoc" /> 
	<%--按钮 ---%>
	<c:import url="/sys/simplecategory/sys_simple_category/sysCategoryMain_view_button.jsp"
				charEncoding="UTF-8">
		<c:param name="formName" value="${formName}" />
		<c:param name="requestURL" value="${requestURL}" />
		<c:param name="fdId" value="${fdId}" />
		<c:param name="fdModelName" value="${fdModelName}" />
	</c:import>
	<p class="txttitle"><bean:message
		bundle="kms-multidoc"
		key="table.kmsMultidocTemplate" />
	</p>

	<center>
	<table
		id="Label_Tabel"
		width="95%">
		<%--模板信息---%>		
		<c:import url="/sys/simplecategory/include/sysCategoryMain_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="${formName}" />
			<c:param name="fdModelName" value="${fdModelName}" />
		</c:import>
		<%--基本信息--%>	 
		<tr LKS_LabelName="<bean:message bundle="kms-multidoc" key="kmsMultidocTemplate.lbl.baseinfo" />">
		<td>
			<table
				class="tb_normal"
				width=100%>
				<tr>
					<td
						class="td_normal_title"
						width=15%><bean:message
						bundle="kms-multidoc"
						key="kmsMultidocTemplate.docContent" /></td>
					<td width=85%>${kmsMultidocTemplateForm.docContent }</td>
				</tr>
				<tr>
					<td
						class="td_normal_title"
						width=15%><bean:message
						bundle="kms-multidoc"
						key="kmsMultidocTemplate.fdStoretime" /></td>
					<td width=85%><bean:write
						name="kmsMultidocTemplateForm"
						property="docExpire" /><bean:message
						key="message.storetime"
						bundle="kms-multidoc" /></td>
				</tr>
				<!-- 标签机制 -->
				<c:import url="/sys/tag/include/sysTagTemplate_view.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmsMultidocTemplateForm" />
					<c:param name="fdKey" value="mainDoc" /> 
				</c:import>
				<!-- 标签机制 -->
				<tr>
					<td
						class="td_normal_title"
						width="15%"><bean:message
						bundle="kms-multidoc"
						key="kmsMultidoc.rattachement" /></td>
					<td><c:import
						url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
						charEncoding="UTF-8">
						<c:param
							name="fdKey"
							value="rattachment" />
						<c:param
							name="formBeanName"
							value="kmsMultidocTemplateForm" />
					</c:import></td>
				</tr>
			</table>
			</td>
		</tr>
		<%--流程机制--%>
		<c:import url="/sys/workflow/include/sysWfTemplate_view.jsp"
		charEncoding="UTF-8">
			<c:param name="formName" value="kmsMultidocTemplateForm" />
			<c:param name="fdKey" value="mainDoc" />
		</c:import> 
		<%----发布机制--%>
		<c:import url="/sys/news/include/sysNewsPublishCategory_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmsMultidocTemplateForm" />
			<c:param name="fdKey" value="mainDoc" />
		</c:import>
		<%----权限--%>
		<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
		<td>
			<table
				class="tb_normal"
				width=100%>
				<c:import
					url="/sys/right/tmp_right_view.jsp"
					charEncoding="UTF-8">
					<c:param
						name="formName"
						value="kmsMultidocTemplateForm" />
					<c:param
						name="moduleModelName"
						value="com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate" />
				</c:import>
			</table>
		</td>
		</tr>
	</table>
	</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
	
