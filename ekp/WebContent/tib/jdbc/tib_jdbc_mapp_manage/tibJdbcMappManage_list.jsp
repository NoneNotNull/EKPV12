<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do" />?method=add&fdtemplatId=${param.categoryId}');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibJdbcMappManageForm, 'deleteall');">
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
				<sunbor:column property="tibJdbcMappManage.docSubject">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.docSubject"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcMappManage.fdDataSource">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdDataSource"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcMappManage.fdIsEnabled">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdIsEnabledStatus"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcMappManage.fdDataSourceSql">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdDataSourceSql"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcMappManage.fdTargetSource">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdTargetSource"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcMappManage.fdTargetSourceSelectedTable">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdTargetSourceSelectedTable"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcMappManage.docCategory.fdName">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.docCategory"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibJdbcMappManage" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do" />?method=view&fdId=${tibJdbcMappManage.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibJdbcMappManage.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibJdbcMappManage.docSubject}" />
				</td>
				<td>
				 <!-- 
					<c:out value="${tibJdbcMappManage.fdDataSource}" />
				  -->
				  <c:out value="${dataSoure[tibJdbcMappManage.fdDataSource]}"/>	
				</td>
				<td>
					   <sunbor:enumsShow value="${tibJdbcMappManage.fdIsEnabled}" enumsType="common_yesno" />
				</td>
				<td>
					<c:out value="${tibJdbcMappManage.fdDataSourceSql}" />
				</td>
				<td>
				<!-- 
					<c:out value="${tibJdbcMappManage.fdTargetSource}" />
				-->
					  <c:out value="${dataSoure[tibJdbcMappManage.fdTargetSource]}"/>	
				</td>
				<td>
					<c:out value="${tibJdbcMappManage.fdTargetSourceSelectedTable}" />
				</td>
				<td>
					<c:out value="${tibJdbcMappManage.docCategory.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
 
</c:if>

</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>