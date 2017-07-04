<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/ftsearch/expand/sys_ftsearch_word/sysFtsearchWord.do">
	<div id="optBarDiv">
	<%--
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_word/sysFtsearchWord.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/ftsearch/expand/sys_ftsearch_word/sysFtsearchWord.do" />?method=add');">
		</kmss:auth>
	 --%>
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_word/sysFtsearchWord.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysFtsearchWordForm, 'deleteall');">
		</kmss:auth>
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
				<sunbor:column property="sysFtsearchWord.fdSearchWord">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchWord.fdSearchWord"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchWord.fdContainSpace">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchWord.fdContainSpace"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchWord.fdSearchByButton">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchWord.fdSearchByButton"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchWord.fdSearchPage">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchWord.fdSearchPage"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchWord.fdUserName">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchWord.fdUserName"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchWord.fdUserId">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchWord.fdUserId"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchWord.fdSearchTime">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchWord.fdSearchTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysFtsearchWord" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/ftsearch/expand/sys_ftsearch_word/sysFtsearchWord.do" />?method=view&fdId=${sysFtsearchWord.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysFtsearchWord.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td width="30%">
					<c:out value="${sysFtsearchWord.fdSearchWord}" />
				</td>
				
				<td>
					<sunbor:enumsShow value="${sysFtsearchWord.fdContainSpace}" enumsType="common_yesno" />
				</td>
				<td>

					<sunbor:enumsShow value="${sysFtsearchWord.fdSearchByButton}" enumsType="common_yesno" />
					<%--  
					<xform:radio value="${sysFtsearchWord.fdSearchByButton}" property="fdSearchByButton" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio>
					--%>
				</td>
				
				<td>
					<c:out value="${sysFtsearchWord.fdSearchPage}" />
				</td>
				<td>
					<c:out value="${sysFtsearchWord.fdUserName}" />
				</td>
				<td>
					<c:out value="${sysFtsearchWord.fdUserId}" />
				</td>
				<td>
					<kmss:showDate value="${sysFtsearchWord.fdSearchTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>