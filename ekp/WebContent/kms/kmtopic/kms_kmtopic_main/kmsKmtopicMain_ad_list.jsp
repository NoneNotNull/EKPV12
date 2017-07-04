<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%@ include file="/kms/wiki/kms_wiki_main/kmsWikiMain_list_js.jsp"%>
<html:form action="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do">
<c:import
	url="/resource/jsp/search_bar.jsp"
	charEncoding="UTF-8">
	<c:param
		name="fdModelName"
		value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" />
</c:import>
<c:import
	url="/sys/right/doc_right_change_button.jsp"
	charEncoding="UTF-8">
	<c:param
		name="modelName"
		value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" />
</c:import>


<c:import
	url="/sys/simplecategory/include/doc_cate_change_button.jsp"
	charEncoding="UTF-8">
	<c:param
		name="modelName"
		value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" />
	<c:param
		name="docFkName"
		value="docCategory" />
	<c:param
		name="cateModelName"
		value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicCategory" />
</c:import>
	<div id="optBarDiv">
		<c:if test="${param.introduce!='true'}">
		<kmss:auth requestURL="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=add&fdCategoryId=${param.categoryId}">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do" />?method=add&fdCategoryId=${param.categoryId}');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=deleteall">
			<input type="button" value="${lfn:message('button.delete')}"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsKmtopicMainForm, 'deleteall');">
		</kmss:auth>
		</c:if> 
		<c:if test="${param.introduce=='true'}">
		<c:import
			url="/sys/introduce/include/sysIntroduceMain_cancelbtn.jsp"
			charEncoding="UTF-8">
			<c:param
				name="fdModelName"
				value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" />
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
				<sunbor:column property="kmsKmtopicMain.docSubject">
					<bean:message bundle="kms-kmtopic" key="kmsKmtopicMain.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmsKmtopicMain.docCreateTime">
					<bean:message bundle="kms-kmtopic" key="kmsKmtopicMain.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsKmtopicMain.docAlterTime">
					<bean:message bundle="kms-kmtopic" key="kmsKmtopicMain.docAlterTime"/>
				</sunbor:column>
				<sunbor:column property="kmsKmtopicMain..docAlteror.fdName">
					<bean:message bundle="kms-kmtopic" key="kmsKmtopicMain.docAlteror"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsKmtopicMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do" />?method=view&fdId=${kmsKmtopicMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsKmtopicMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsKmtopicMain.docSubject}" />
				</td>
				<td>
					<c:out value="${kmsKmtopicMain.docCreateTime}" />
				</td>
				<td>
					<c:out value="${kmsKmtopicMain.docAlterTime}" />
				</td>
				<td>
					<c:out value="${kmsKmtopicMain.docAlteror.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>