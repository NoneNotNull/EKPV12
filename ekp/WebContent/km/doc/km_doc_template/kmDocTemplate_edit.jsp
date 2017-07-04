<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<kmss:windowTitle
	subjectKey="km-doc:table.kmDocTemplate"
	moduleKey="km-doc:table.kmdoc" />
<script language="JavaScript">
Com_IncludeFile("dialog.js");
</script>
<html:form
	action="/km/doc/km_doc_template/kmDocTemplate.do"
	onsubmit="return validateKmDocTemplateForm(this);">
		
		<c:import url="/sys/simplecategory/sys_simple_category/sysCategoryMain_edit_button.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmDocTemplateForm" />
		</c:import>

	<p class="txttitle"><bean:message
		bundle="km-doc"
		key="table.kmDocTemplate" /></p>

	<center>
	<table
		id="Label_Tabel"
		width="95%">

		<c:import url="/sys/simplecategory/include/sysCategoryMain_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmDocTemplateForm" />
			<c:param name="requestURL" value="km/doc/km_doc_template/kmDocTemplate.do?method=add" />
			<c:param name="fdModelName" value="${param.fdModelName}" />
		</c:import>

		<tr LKS_LabelName="<bean:message bundle="km-doc" key="kmDocTemplate.lbl.baseinfo" />">
			<td>
			<table
				class="tb_normal"
				width=100%>
				<tr>
					<td class="td_normal_title" colspan="2" align="center">
						<bean:message bundle="km-doc" key="kmDocTemplate.lbl.defaultValue" />
					</td>
				</tr>
				<tr>
					<td
						class="td_normal_title"
						width=15%><bean:message
						bundle="km-doc"
						key="kmDocTemplate.docContent" /></td>
					<td width=85%><kmss:editor
						property="docContent"
						height="400" /></td>
				</tr>
				<%--
				<tr>
					<td
						class="td_normal_title"
						width=15%><bean:message
						bundle="km-doc"
						key="kmDocTemplate.fdStoretime" /></td>
					<td width=85%><html:text property="docExpire" /><bean:message
						key="message.storetime"
						bundle="km-doc" /><bean:message
						key="message.storetime.tip"
						bundle="km-doc" /></td>
				</tr>
				--%>
				<!-- 标签机制 -->
				<c:import url="/sys/tag/include/sysTagTemplate_edit.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmDocTemplateForm" />
					<c:param name="fdKey" value="mainDoc" /> 
				</c:import>
				<!-- 标签机制 -->
				<%-- 适用岗位的不要 modify by zhouchao----%>
				<%-- 
				<tr>
					<td
						class="td_normal_title"
						width="15%"><bean:message
						bundle="km-doc"
						key="kmDocTemplatePost.fdPostName" /></td>
					<td><html:hidden property="docPostsIds" /> <html:textarea
						property="docPostsNames"
						style="width:80%"
						readonly="true" /> <a
						href="#"
						onclick="Dialog_Address(true, 'docPostsIds','docPostsNames', ';',ORG_TYPE_POST);"> <bean:message key="dialog.selectOrg" /> </a></td>
				</tr>
				--%>
				<%--
				<tr>
					<td
						class="td_normal_title"
						width="15%"><bean:message
						bundle="km-doc"
						key="kmDoc.rattachement" /></td>
					<td><c:import
						url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
						charEncoding="UTF-8">
						<c:param
							name="fdKey"
							value="rattachment" />
					</c:import></td>
				</tr>
				 --%>
			</table>
			</td>
		</tr>
		<!-- 流程 -->
		<c:import url="/sys/workflow/include/sysWfTemplate_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmDocTemplateForm" />
			<c:param name="fdKey" value="mainDoc" /> 
		</c:import>
		<%--<tr LKS_LabelName="<bean:message bundle="km-doc" key="kmDocTemplate.lbl.publish"/>">
			<td>
			<table
				class="tb_normal"
				width="100%">
			</table>
			</td>
		</tr>
		--%>
		<%--关联机制--%>
		<tr LKS_LabelName="<bean:message bundle="sys-relation" key="sysRelationMain.tab.label" />">
			<c:set
				var="mainModelForm"
				value="${kmDocTemplateForm}"
				scope="request" />
			<c:set
				var="currModelName"
				value="com.landray.kmss.km.doc.model.KmDocKnowledge"
				scope="request" />
			<td><%@ include file="/sys/relation/include/sysRelationMain_edit.jsp"%></td>
		</tr>
		<%----发布机制开始--%>
		<c:import url="/sys/news/include/sysNewsPublishCategory_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmDocTemplateForm" />
			<c:param name="fdKey" value="mainDoc" /> 
		<c:param name="messageKey"
				value="km-doc:kmDocTemplate.lbl.publish" />
		</c:import>
		<%----发布机制结束--%>
		<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
			<td>
			<table
				class="tb_normal"
				width=100%>
				<c:import
					url="/sys/right/tmp_right_edit.jsp"
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
	<html:hidden property="fdId" />
	<html:hidden property="method_GET" />
</html:form>
<html:javascript
	formName="kmDocTemplateForm"
	cdata="false"
	dynamicJavascript="true"
	staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>
