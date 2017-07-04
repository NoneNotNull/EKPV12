<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%pageContext.setAttribute("_isJGEnabled", new Boolean(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()));%>
<script language="JavaScript">
Com_IncludeFile("dialog.js");
window.onload = function(){
	checkEditType("${sysNewsTemplateForm.fdContentType}", null);
	var data = new KMSSData();
	data.AddBeanData("sysNewsTemplateService");
};
Com_Parameter.event["submit"].push(function() {
	var type=document.getElementsByName("fdContentType")[0];
	if ("word" == type.value) {
		if ("${pageScope._isJGEnabled}" == "true") {
			// 保存附件
			if(!JG_SaveDocument()){return false;}
			// 保存附件为html
			//if(!JG_WebSaveAsHtml()){return false;}
		}
	}
	return true;
});
function checkEditType(value, obj){
	var type=document.getElementsByName("fdContentType")[0];
	type.value = "rtf";
	var _rtfEdit = document.getElementById('rtfEdit');
	var _wordEdit = document.getElementById('wordEdit');
	if (_rtfEdit == null || _wordEdit == null) {
		return ;
	}
	if("word" == value){
		type.value = "word";
		_rtfEdit.style.display = "none";
		_wordEdit.style.display = "block";
		if ("${pageScope._isJGEnabled}" == "true") {
			JG_Load();
		}
	} else {
		_rtfEdit.style.display = "block";
		_wordEdit.style.display = "none";
	}
}
</script>
<html:form action="/sys/news/sys_news_template/sysNewsTemplate.do"
	onsubmit="return validateSysNewsTemplateForm(this);">

	<c:import url="/sys/simplecategory/sys_simple_category/sysCategoryMain_edit_button.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="sysNewsTemplateForm" />
		</c:import>

	<p class="txttitle"><bean:message key="news.category.set" bundle="sys-news" /></p>

	<center>
	<table id="Label_Tabel" width=95%>
		<!-- 模板信息 -->
		<c:import url="/sys/simplecategory/include/sysCategoryMain_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="sysNewsTemplateForm" />
			<c:param name="requestURL" value="/sys/news/sys_news_template/sysNewsTemplate.do?method=add" />
			<c:param name="fdModelName" value="${param.fdModelName}" />
			<c:param name="fdKey" value="newsMainDoc" />
		</c:import>
		<!-- 基本信息 -->
		<tr
			LKS_LabelName="<bean:message bundle='sys-news' key='news.template.baseInfo'/>">
			<td>
			<table id="base_info" class="tb_normal" width=100%>
				<%-- 编辑方式 --%>
				<html:hidden property="fdContentType" />
				<c:if test="${sysNewsTemplateForm.method_GET=='add'}">
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="sys-news" key="sysNewsMain.fdContentType" />
					</td>
					<td width="85%" colspan="3">
						<xform:radio property="fdEditType" showStatus="edit" value="${sysNewsTemplateForm.fdContentType}" onValueChange="checkEditType">
							<xform:enumsDataSource enumsType="sysNewsMain_fdContentType" />
						</xform:radio>
					</td>
				</tr>
				</c:if>
				<!-- 文档内容 -->
				<tr>
					<td class="td_normal_title" colspan="4" align="center"><bean:message
						bundle="sys-news" key="sysNewsTemplate.docContent" /></td>
				</tr>
				<tr>
					<td colspan="4">
						<div id="rtfEdit" 
						<c:if test="${sysNewsTemplateForm.fdContentType!='rtf'}">style="display:none"</c:if>>
						<kmss:editor property="docContent" toolbarSet="Default" height="500" />
						</div>
						<div id="wordEdit" style="height:600px;"
						<c:if test="${sysNewsTemplateForm.fdContentType!='word'}">style="display:none"</c:if>>
						<c:choose>
						<c:when test="${pageScope._isJGEnabled == 'true'}">
							<c:import url="/sys/attachment/sys_att_main/jg_ocx.jsp" charEncoding="UTF-8">
								<c:param name="fdModelId" value="${sysNewsTemplateForm.fdId}" />
								<c:param name="fdModelName" value="com.landray.kmss.sys.news.model.SysNewsTemplate" />
								<c:param name="fdKey" value="editonline" />
								<c:param name="formBeanName" value="sysNewsTemplateForm" />
								<c:param name="fdAttType" value="${sysNewsTemplateForm.fdContentType}" />
								<c:param name="fdCopyId" value="${param.fdCopyId}" />
							</c:import>
						</c:when>
						<c:otherwise>
							<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
								<c:param name="fdKey" value="editonline"/>
								<c:param name="fdAttType" value="office"/>
								<c:param name="fdModelId" value="${sysNewsTemplateForm.fdId}"/>
								<c:param name="fdModelName" value="com.landray.kmss.sys.news.model.SysNewsTemplate"/>
								<c:param name="isTemplate" value="true"/>
							</c:import>
						</c:otherwise>
						</c:choose>
						</div>
					</td>
				</tr>
				<!-- 关键字 
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNews.docKeyword" /></td>
					<td width=83%><html:hidden property="docKeywordIds" /> <html:text
						property="docKeywordNames" style="width:50%;" /></td>
				</tr>-->
					<!-- 标签机制 -->
				<c:import url="/sys/tag/include/sysTagTemplate_edit.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="sysNewsTemplateForm" />
					<c:param name="fdKey" value="newsMainDoc" /> 
				</c:import>
				<!-- 标签机制 -->
				<!-- 新闻重要度 -->
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsMain.fdImportance" /></td>
					<td colspan=3>
						<sunbor:enums property="fdImportance" enumsType="sysNewsMain_fdImportance" elementType="radio" />
					</td>
				</tr>
			</table>
			</td>
		</tr>
		<!-- 相关新闻 -->
		<tr
			LKS_LabelName="<bean:message bundle='sys-news' key='news.template.relation.news'/>">
			<c:set var="mainModelForm" value="${sysNewsTemplateForm}"
				scope="request" />
			<c:set
				var="currModelName"
				value="com.landray.kmss.sys.news.model.SysNewsMain"
				scope="request" />
			<td><%@ include
				file="/sys/relation/include/sysRelationMain_edit.jsp"%></td>
		</tr>
		<!-- 以下代码为嵌入流程模板标签的代码 -->
		<c:import url="/sys/workflow/include/sysWfTemplate_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="sysNewsTemplateForm" />
			<c:param name="fdKey" value="newsMainDoc" />
		</c:import>
		<!-- 以上代码为嵌入流程模板标签的代码 -->
			<%-- 以下代码为嵌入默认权限模板标签的代码 --%>
	   <tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />"><td>
		 <table class="tb_normal" width=100%>
			<c:import url="/sys/right/tmp_right_edit.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="sysNewsTemplateForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.sys.news.model.SysNewsTemplate" />
			</c:import>
		 </table>
	    </td></tr>
	<%-- 以上代码为嵌入默认权限模板标签的代码 --%>
	</table>
	</center>
	<html:hidden property="fdId" />
	<html:hidden property="method_GET" />
</html:form>
<html:javascript formName="sysNewsTemplateForm" cdata="false"
	dynamicJavascript="true" staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>
