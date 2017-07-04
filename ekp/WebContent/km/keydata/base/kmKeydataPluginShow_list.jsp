<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/keydata/base/kmKeydataPluginShow.do">
	<div id="optBarDiv">
		<kmss:auth
			requestURL="/km/keydata/base/kmKeydataPluginShow.do?method=importPluginShowData"
			requestMethod="GET">
			<input type="button" value="导入模块"
					onclick="Com_OpenWindow('<c:url value="/km/keydata/base/kmKeydataPluginShow.do?method=importPluginShowData" />');">
		</kmss:auth>
		<kmss:auth requestURL="/km/keydata/base/kmKeydataPluginShow.do?method=showall">
			<input type="button" value="启用"
				onclick="Com_Submit(document.kmKeydataPluginShowForm, 'showall');">
		</kmss:auth>
		<kmss:auth requestURL="/km/keydata/base/kmKeydataPluginShow.do?method=disshowall">
			<input type="button" value="不启用"
				onclick="Com_Submit(document.kmKeydataPluginShowForm, 'disshowall');">
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
				<sunbor:column property="kmKeydataPluginShow.fdName">
					<bean:message bundle="km-keydata-base" key="kmKeydataPluginShow.fdName"/>
				</sunbor:column>
				
				<sunbor:column property="kmKeydataPluginShow.fdActionUrl">
					<bean:message bundle="km-keydata-base" key="kmKeydataPluginShow.fdActionUrl"/>
				</sunbor:column>
				<sunbor:column property="kmKeydataPluginShow.fdIsShow">
					<bean:message bundle="km-keydata-base" key="kmKeydataPluginShow.fdIsShow"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmKeydataPluginShow" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/keydata/base/kmKeydataPluginShow.do" />?method=edit&fdId=${kmKeydataPluginShow.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmKeydataPluginShow.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmKeydataPluginShow.fdName}" />
				</td>
				
				<td>
					<c:out value="${kmKeydataPluginShow.fdActionUrl}" />
				</td>
				<td>
					<xform:radio value="${kmKeydataPluginShow.fdIsShow}" property="fdIsShow" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>