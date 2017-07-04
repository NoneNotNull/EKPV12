<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%--参数--%>
<c:set var="formName" value="kmDocTemplateForm" />
<c:set var="requestURL" value="/km/doc/km_doc_template/kmDocTemplate.do" />
<c:set var="fdId" value="${kmDocTemplateForm.fdId}" />
<c:set var="fdModelName" value="com.landray.kmss.km.doc.model.KmDocTemplate" />
<script language="JavaScript">
	Com_IncludeFile("dialog.js");
</script>
	<%--标题--%>
	<kmss:windowTitle
		subjectKey="km-doc:table.kmDocTemplate"
		moduleKey="km-doc:table.kmdoc" /> 
	<%--按钮 ---%>
	<c:import url="/sys/simplecategory/sys_simple_category/sysCategoryMain_view_button.jsp"
				charEncoding="UTF-8">
		<c:param name="formName" value="${formName}" />
		<c:param name="requestURL" value="${requestURL}" />
		<c:param name="fdId" value="${fdId}" />
		<c:param name="fdModelName" value="${fdModelName}" />
	</c:import>
	<p class="txttitle"><bean:message
		bundle="km-doc"
		key="table.kmDocTemplate" />
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
		<tr LKS_LabelName="<bean:message bundle="km-doc" key="kmDocTemplate.lbl.baseinfo" />">
		<td>
			<table
				class="tb_normal"
				width=100%>
				<tr>
					<td
						class="td_normal_title"
						width=15%><bean:message
						bundle="km-doc"
						key="kmDocTemplate.docContent" /></td>
					<td width=85%>${kmDocTemplateForm.docContent }</td>
				</tr>
				<tr>
					<td
						class="td_normal_title"
						width=15%><bean:message
						bundle="km-doc"
						key="kmDocTemplate.fdStoretime" /></td>
					<td width=85%><bean:write
						name="kmDocTemplateForm"
						property="docExpire" /><bean:message
						key="message.storetime"
						bundle="km-doc" /></td>
				</tr>
				<!-- 标签机制 -->
				<c:import url="/sys/tag/include/sysTagTemplate_view.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmDocTemplateForm" />
					<c:param name="fdKey" value="mainDoc" /> 
				</c:import>
				<!-- 标签机制 -->
				<tr>
					<td
						class="td_normal_title"
						width="15%"><bean:message
						bundle="km-doc"
						key="kmDoc.rattachement" /></td>
					<td><c:import
						url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
						charEncoding="UTF-8">
						<c:param
							name="fdKey"
							value="rattachment" />
						<c:param
							name="formBeanName"
							value="kmDocTemplateForm" />
					</c:import></td>
				</tr>
			</table>
			</td>
		</tr>
		<%--流程机制--%>
		<c:import url="/sys/workflow/include/sysWfTemplate_view.jsp"
		charEncoding="UTF-8">
			<c:param name="formName" value="kmDocTemplateForm" />
			<c:param name="fdKey" value="mainDoc" />
		</c:import> 
		<%----发布机制--%>
		<c:import url="/sys/news/include/sysNewsPublishCategory_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmDocTemplateForm" />
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
						value="kmDocTemplateForm" />
					<c:param
						name="moduleModelName"
						value="com.landray.kmss.km.doc.model.KmDocTemplate" />
				</c:import>
			</table>
		</td>
		</tr>
	</table>
	</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
	