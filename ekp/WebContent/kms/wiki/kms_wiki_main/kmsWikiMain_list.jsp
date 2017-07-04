<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%@ include file="/kms/wiki/kms_wiki_main/kmsWikiMain_list_js.jsp"%>
<html:form action="/kms/wiki/kms_wiki_main/kmsWikiMain.do">

	<c:import url="/sys/bookmark/include/bookmark_bar_all.jsp"
	charEncoding="UTF-8">
	<c:param name="fdTitleProName" value="docSubject" />
	<c:param name="fdModelName"
		value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
</c:import>
<c:import
	url="/resource/jsp/search_bar.jsp"
	charEncoding="UTF-8">
	<c:param
		name="fdModelName"
		value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
</c:import>
<c:import
	url="/sys/right/doc_right_change_button.jsp"
	charEncoding="UTF-8">
	<c:param
		name="modelName"
		value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
</c:import>


<c:import
	url="/sys/simplecategory/include/doc_cate_change_button.jsp"
	charEncoding="UTF-8">
	<c:param
		name="modelName"
		value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
	<c:param
		name="docFkName"
		value="docCategory" />
	<c:param
		name="cateModelName"
		value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" />
	<c:param
		name="extProps"
		value="fdTemplateType:2;fdTemplateType:3" />
</c:import>
	<div id="optBarDiv">
		<c:if test="${param.introduce!='true'}">
		<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=add&fdCategoryId=${param.categoryId}">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do" />?method=add&fdCategoryId=${param.categoryId}');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=deleteall">
			<input type="button" value="${lfn:message('kms-knowledge:kmsKnowledge.button.delete')}"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsWikiMainForm, 'deleteall');">
		</kmss:auth>
		</c:if> 
		<c:if test="${param.introduce=='true'}">
		<c:import
			url="/sys/introduce/include/sysIntroduceMain_cancelbtn.jsp"
			charEncoding="UTF-8">
			<c:param
				name="fdModelName"
				value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
		</c:import>
	</c:if> 
	<input
	type="button"
	value="<bean:message key="button.search"/>"
	onclick="Search_Show();">
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="kmsWikiMain.docSubject">
					<bean:message bundle="kms-wiki" key="kmsWikiMain.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiMain.fdVersion">
					<bean:message bundle="kms-wiki" key="kmsWikiMain.fdVersion"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiMain.docCreateTime">
					<bean:message bundle="kms-wiki" key="kmsWikiMain.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiMain.docAlterTime">
					<bean:message bundle="kms-wiki" key="kmsWikiMain.docAlterTime"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiMain.docAlteror.fdName">
					<bean:message bundle="kms-wiki" key="kmsWikiMain.docAlteror"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsWikiMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do" />?method=view&fdId=${kmsWikiMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsWikiMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsWikiMain.docSubject}" />
				</td>
				<td>
					<c:out value="${kmsWikiMain.fdVersion}" />
				</td>
				<td>
					<kmss:showDate value="${kmsWikiMain.docCreateTime}" />
				</td>
				<td>
					<kmss:showDate value="${kmsWikiMain.docAlterTime}" />
				</td>
				<td>
					<c:if test="${not empty kmsWikiMain.docAlterTime}"><c:out value="${kmsWikiMain.docCreator.fdName}" /></c:if>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>