<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
Com_IncludeFile("dialog.js");
</script>
<html:form action="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do">
<%---全文搜索--%>
<c:import url="/resource/jsp/search_bar.jsp" charEncoding="UTF-8">
	<c:param
		name="fdModelName"
		value="com.landray.kmss.kms.kmaps.model.KmsKmapsMain" />
</c:import>
<c:import
	url="/sys/right/doc_right_change_button.jsp"
	charEncoding="UTF-8">
	<c:param
		name="modelName"
		value="com.landray.kmss.kms.kmaps.model.KmsKmapsMain" />
	<c:param name="categoryId" value="${param.categoryId }" />
</c:import>


<c:import
	url="/sys/simplecategory/include/doc_cate_change_button.jsp"
	charEncoding="UTF-8">
	<c:param
		name="modelName"
		value="com.landray.kmss.kms.kmaps.model.KmsKmapsMain" />
	<c:param
		name="docFkName"
		value="docCategory" />
	<c:param
		name="cateModelName"
		value="com.landray.kmss.kms.kmaps.model.KmsKmapsCategory" />
</c:import>
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do" />?method=add&categoryId=${param.categoryId}');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsKmapsMainForm, 'deleteall');">
		</kmss:auth>
		<input  type="button" value="<bean:message key="button.search"/>" onclick="Search_Show();">
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td><input type="checkbox" name="List_Tongle"></td>
				<td><bean:message key="page.serial"/></td> 
				<sunbor:column property="kmsKmapsMain.docSubject">
					<bean:message  bundle="kms-kmaps" key="kmsKmapsMain.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmsKmapsMain.docCategory.fdId">
					<bean:message bundle="kms-kmaps" key="kmsKmapsMain.docCategoryId"/>
				</sunbor:column>  
				<sunbor:column property="kmsKmapsMain.docCreateTime">
					<bean:message  bundle="kms-kmaps" key="kmsKmapsMain.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsKmapsMain.docAlterTime">
					<bean:message  bundle="kms-kmaps" key="kmsKmapsMain.docAlterTime"/>
				</sunbor:column>
				<sunbor:column property="kmsKmapsMain.docAlteror.fdId">
					<bean:message bundle="kms-kmaps" key="kmsKmapsMain.docAlterorId"/>
				</sunbor:column> 
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsKmapsMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do" />?method=view&fdId=${kmsKmapsMain.fdId}">
				<td width="3%" style="text-align: center">
					<input type="checkbox" name="List_Selected" value="${kmsKmapsMain.fdId}">
				</td>
				<td width="5%" style="text-align: center">${vstatus.index+1}</td> 
				<td width="17%" style="text-align: left;">
					<c:out value="${kmsKmapsMain.docSubject}" />
				</td>
				<td width="15%">
					<c:out value="${kmsKmapsMain.docCategory.fdName}" />
				</td> 
				<td width="20%">
					<kmss:showDate value="${kmsKmapsMain.docCreateTime}" type="datetime"/> 
				</td>
				<td width="20%">
					<kmss:showDate value="${kmsKmapsMain.docAlterTime}" type="datetime"/> 
				</td>
				<td width="20%">
					<c:out value="${kmsKmapsMain.docAlteror.fdName}" />
				</td>  
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>