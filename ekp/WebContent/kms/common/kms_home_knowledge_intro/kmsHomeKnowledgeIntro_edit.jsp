<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="kmsHomeKnowledgeIntro_edit_js.jsp" %>
<html:form action="/kms/common/kms_home_knowledge_intro/kmsHomeKnowledgeIntro.do">
<div id="optBarDiv">
	<c:if test="${kmsHomeKnowledgeIntroForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsHomeKnowledgeIntroForm, 'update');">
	</c:if>
	<c:if test="${kmsHomeKnowledgeIntroForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsHomeKnowledgeIntroForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsHomeKnowledgeIntroForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-common" key="table.kmsHomeKnowledgeIntro"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsHomeKnowledgeIntro.fdName"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdName" style="width:85%" />
		</td>
	</tr>
	<c:if test="${kmsHomeKnowledgeIntroForm.method_GET=='edit'}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsHomeKnowledgeIntro.fdPhase"/>
		</td>
		<td width="85%" colspan="3">
			第<xform:text property="fdPhase" style="width:85%" showStatus="view" />期
		</td>
	</tr>
	</c:if>
	<html:hidden property="fdPortalId" />

	<%-- 
	<tr>
		<td class="td_normal_title" width=15%>
			所属门户
		</td>
		<td width="85%" colspan="3">
		<c:if test="${kmsHomeKnowledgeIntroForm.method_GET=='add'}">
			<xform:text property="fdPortalName" style="width:85%" htmlElementProperties="readonly=true"/><a href="#" onclick="selectPortal();">选择</a>
		</c:if>	
		<c:if test="${kmsHomeKnowledgeIntroForm.method_GET=='edit'}">
			<xform:text property="fdPortalName" style="width:85%"  showStatus="view"/>
		</c:if>
			<html:hidden property="fdPortalId" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsHomeKnowledgeIntro.fdModelName"/>
		</td>
		<td width="85%" colspan="3">
		<c:if test="${kmsHomeKnowledgeIntroForm.method_GET=='add'}">
			<xform:text property="fdModelName" style="width:85%" htmlElementProperties="readonly=true"/><a href="#" onclick="selectModel();">选择</a>
		</c:if>
		<c:if test="${kmsHomeKnowledgeIntroForm.method_GET=='edit'}">
			<xform:text property="fdModelName" style="width:85%"  showStatus="view"/>
		</c:if>
			<html:hidden property="fdModelId" />
		</td>
	</tr>
	--%>
	<tr class="tr_normal_title">
		<td colspan="4" align="center">推荐头条</td>
	</tr>
	<tr>
		<td class="td_normal_title">标题</td>
		<td colspan="3">
			<xform:text property="fdTopName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">链接</td>
		<td colspan="3">
			<c:if test="${empty kmsHomeKnowledgeIntroForm.fdTopUrl}">
				<xform:text property="fdTopUrl" style="width:85%" value="http://" />
			</c:if>
			<c:if test="${not empty kmsHomeKnowledgeIntroForm.fdTopUrl}">
				<xform:text property="fdTopUrl" style="width:85%;" />
			</c:if>
		</td>
	</tr>
	<%-- 
	<tr>
		<td class="td_normal_title">内容预览</td>
		<td colspan="3">
			<xform:textarea property="fdTopContent" style="width:85%"></xform:textarea>
		</td>
	</tr>--%>
	<tr>
		<td class="td_normal_title">头条图片</td>
		<td colspan="3">
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
		    	<c:param name="fdKey" value="kmsHomeKnowlegeIntr_fdKey"/>
		    	<c:param name="fdMulti" value="false"/>
		    	<c:param name="fdAttType" value="pic"/>
		    	<c:param name="fdImgHtmlProperty" value="height=150"/>
			</c:import>
		</td>
	</tr>
	<%--
	<tr class="tr_normal_title">
		<td colspan="4" align="center">相关知识</td>
	</tr>
	<tr>
		<td colspan="4" align="center">
			<table id="knowledge_mapping_doclist" class="tb_normal" width="90%">
				<tr class="tr_normal_title">
					<td align="center" width="5%">序号</td>
					<td width="25%">知识标题</td>
					<td width="45%">知识链接</td>
					<td align="center" width="20%"><img src="<c:url value="/resource/style/default/icons/add.gif" />" onclick="DocList_AddRow();" title="添加"/></td>
				</tr>
				<tr KMSS_IsReferRow="1" style="display:none">
					<td KMSS_IsRowIndex="1" align="center" width="5%"></td>
					<td width="25%">
						<input name="fdKnowledgeMappingForms[!{index}].docSubject" 
							class="inputsgl" style="width:85%" value="知识标题"/>
					</td>
					<td width="45%">
						<input name="fdKnowledgeMappingForms[!{index}].fdUrl" 
							class="inputsgl" style="width:85%" value="http://"/></td>
					<td align="center" width="20%">
						<img src="<c:url value="/resource/style/default/icons/delete.gif" />" onclick="DocList_DeleteRow();" title="删除"/>
						<img src="<c:url value="/resource/style/default/icons/up.gif" />" onclick="DocList_MoveRow(-1);" title="上移"/>
						<img src="<c:url value="/resource/style/default/icons/down.gif" />" onclick="DocList_MoveRow(1);" title="下移"/>
					</td>
				</tr>
				<c:forEach var="knowlegeMapping" items="${kmsHomeKnowledgeIntroForm.fdKnowledgeMappingForms }" varStatus="vstatus">
				<tr KMSS_IsContentRow="1">
					<td align="center">${vstatus.index + 1 }</td>
					<td>
						<input name="fdKnowledgeMappingForms[${vstatus.index }].docSubject" 
							class="inputsgl" style="width:85%" value="${knowlegeMapping.docSubject }"/>
					</td>
					<td>
						<input name="fdKnowledgeMappingForms[${vstatus.index }].fdUrl" 
							class="inputsgl" style="width:85%" value="${knowlegeMapping.fdUrl }"/>
					</td>
					<td align="center">
						<img src="<c:url value="/resource/style/default/icons/delete.gif" />" onclick="DocList_DeleteRow();" title="删除"/>
						<img src="<c:url value="/resource/style/default/icons/up.gif" />" onclick="DocList_MoveRow(-1);" title="上移"/>
						<img src="<c:url value="/resource/style/default/icons/down.gif" />" onclick="DocList_MoveRow(1);" title="下移"/>
					</td>
				</tr>
				</c:forEach>
			</table>
		</td>
	</tr>
	--%>
	<c:if test="${kmsHomeKnowledgeIntroForm.method_GET=='edit'}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsHomeKnowledgeIntro.docCreator"/>
		</td><td width="35%">
			<xform:text property="docCreatorName" showStatus="view"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsHomeKnowledgeIntro.docCreateTime"/>
		</td><td width="35%">
			<xform:text property="docCreateTime" style="width:85%" showStatus="view"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsHomeKnowledgeIntro.docAlteror"/>
		</td><td width="35%">
			<xform:text property="docAlterorName" showStatus="view"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsHomeKnowledgeIntro.docAlterTime"/>
		</td><td width="35%">
			<xform:datetime property="docAlterTime" showStatus="view" />
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