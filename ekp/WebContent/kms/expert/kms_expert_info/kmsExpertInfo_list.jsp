<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%@ page import="com.landray.kmss.kms.expert.model.KmsExpertInfo"%>
<%--bookmark收藏机制在没有删除权限时不能进行收藏功能(没有多选按钮)--%>
<c:if test="${empty search }">
	<c:import url="/sys/bookmark/include/bookmark_bar_all.jsp"
		charEncoding="UTF-8">
		<c:param name="fdTitleProName" value="fdName" />
		<c:param name="fdModelName"	value="com.landray.kmss.kms.expert.model.KmsExpertInfo" />
	</c:import>
</c:if>
<html:form action="/kms/expert/kms_expert_info/kmsExpertInfo.do">
	<div id="optBarDiv">
		<c:if test="${empty search }">
			<kmss:auth requestURL="/kms/expert/kms_expert_info/kmsExpertInfo.do?method=add" requestMethod="GET">
				<input type="button" value="<bean:message key="button.add"/>" onclick="Com_OpenWindow('<c:url value="/kms/expert/kms_expert_info/kmsExpertInfo.do" />?method=add&categoryType=${param.categoryType}&fdCategoryId=${param.fdCategoryId}');">
			</kmss:auth>
			<%-- <input type="button" value="<bean:message bundle="kms-expert" key="kmsExpert.search"/>" 
				onclick="window.open('<c:url value="/kms/expert/kms_expert_search/kmsExpertSearch_main.jsp"/>')"> --%>
			<kmss:auth requestURL="/kms/expert/kms_expert_info/kmsExpertInfo.do?method=deleteall" requestMethod="GET">
				<input type="button" value="<bean:message key="button.delete"/>" 
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsExpertInfoForm, 'deleteall');">
			</kmss:auth>
		</c:if>
		<c:if test="${!empty search }">
			<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
		</c:if>
	</div>
	<%if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<%} else {%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<c:if test="${empty search }">
					<td width="10pt">
						<input type="checkbox" name="List_Tongle">
					</td>
				</c:if>
				<td width="40pt">
					<bean:message key="page.serial" />
				</td>
				<sunbor:column property="kmsExpertInfo.fdName">
					<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdName" />
				</sunbor:column>
				<sunbor:column property="kmsExpertInfo.kmsExpertType.fdName">
					<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdAreaName" />
				</sunbor:column>
				<sunbor:column property="kmsExpertInfo.fdPerson.hbmParent.fdName">
					<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdDepartment" />
				</sunbor:column>
				<sunbor:column property="kmsExpertInfo.fdMobileNo">
					<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdMobileNo" />
				</sunbor:column>
				<%--<td>
					<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdWikiCategoryName" />
				</td>
				<td>
					<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdAskCategoryName" />
				</td>
				<sunbor:column property="kmsExpertInfo.fdBackground">
					<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdBackground" />
				</sunbor:column>--%>
				<%-- 
				<sunbor:column property="kmsExpertInfo.fdPersonType">
					<bean:message bundle="kms-expert" key="table.kmsExpertInfo.personType" />
				</sunbor:column>
				--%>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsExpertInfo" varStatus="vstatus">
		<%  %>
			<tr kmss_href="<c:url value="/kms/expert/kms_expert_info/kmsExpertInfo.do" />?method=view&fdId=${kmsExpertInfo.fdId}&fdExpertId=${kmsExpertInfo.fdId}&fdPersonId=${kmsExpertInfo.fdPerson.fdId}&expert=true">
				<c:if test="${empty search }">
					<td width="3%">
						<input type="checkbox" name="List_Selected" value="${kmsExpertInfo.fdId}">
					</td>
				</c:if>
				<td width="5%">
					${vstatus.index+1}
				</td>
				<td width="15%">
					<c:out value="${kmsExpertInfo.fdName}" />
				</td>
				<td width="25%">
					<c:out value="${kmsExpertInfo.kmsExpertType.fdName}" />
				</td>
				<td width="25%">
					<c:out value="${kmsExpertInfo.fdDeptName}" />
				</td>
				<td width="25%">
					<c:out value="${kmsExpertInfo.fdMobileNo}" />
				</td>
				<%--<td width="25%">
					<c:out value="${kmsExpertInfo.kmsWikiCategorys}" />
				</td>
				<td width="25%">
					<c:out value="${kmsExpertInfo.kmsAskCategorys}" />
				</td>
				<td title="<c:out value="${kmsExpertInfo.fdBackground}" />" align="left" width="35%">
				<% 
					KmsExpertInfo kmsExpertInfo =(KmsExpertInfo)(pageContext.getAttribute("kmsExpertInfo"));
					String strBackground = "";
					StringBuffer item = new StringBuffer();
					if(kmsExpertInfo != null){
						strBackground = kmsExpertInfo.getFdBackground();
						if(strBackground == null){
							strBackground = "";
						}
					}
					if(strBackground.length()>30){
						strBackground = strBackground.substring(0,25) + "...";
					}
					pageContext.setAttribute("strBackground", strBackground);
				%>
					<div title="${kmsExpertInfo.fdBackground}">${strBackground}</div>					
				</td>--%>
				<%-- 
				<td width="10%">
					<sunbor:enumsShow  bundle="kms-expert" enumsType="expertInfo_expertType_innerOuter" value="${kmsExpertInfo.fdPersonType}"/>			
				</td>
				--%>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%}

		%>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
