<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/common/mapping/tib_common_mapping_module/tibCommonMappingModule.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/common/mapping/tib_common_mapping_module/tibCommonMappingModule.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/common/mapping/tib_common_mapping_module/tibCommonMappingModule.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/common/mapping/tib_common_mapping_module/tibCommonMappingModule.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibCommonMappingModuleForm, 'deleteall');">
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
				<%-- 
				<sunbor:column property="tibCommonMappingModule.fdServerName">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdServerName"/>
				</sunbor:column>
				<sunbor:column property="tibCommonMappingModule.fdServerIp">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdServerIp"/>
				</sunbor:column>
				 --%>
				<sunbor:column property="tibCommonMappingModule.fdModuleName">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdModuleName"/>
				</sunbor:column>
				<sunbor:column property="tibCommonMappingModule.fdTemplateName">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdTemplateName"/>
				</sunbor:column>
				<sunbor:column property="tibCommonMappingModule.fdMainModelName">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdMainModelName"/>
				</sunbor:column>
					<sunbor:column property="tibCommonMappingModule.fdCate">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.cate.type"/>
				</sunbor:column>
				<sunbor:column property="tibCommonMappingModule.fdUse">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdUse"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibCommonMappingModule" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/common/mapping/tib_common_mapping_module/tibCommonMappingModule.do" />?method=view&fdId=${tibCommonMappingModule.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibCommonMappingModule.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<%--
				<td>
					<c:out value="${tibCommonMappingModule.fdServerName}" />
				</td>
				<td>
					<c:out value="${tibCommonMappingModule.fdServerIp}" />
				</td>
				--%>
				<td>
					<c:out value="${tibCommonMappingModule.fdModuleName}" />
				</td>
				<td>
					<c:out value="${tibCommonMappingModule.fdTemplateName }" />
				</td>
					<td>
					<c:out value="${tibCommonMappingModule.fdMainModelName}" />
				</td>
					<td>
					<sunbor:enumsShow value="${tibCommonMappingModule.fdCate}" enumsType="tibCommonMappingModule_cate"  />
				</td>
				<td>
					<sunbor:enumsShow value="${tibCommonMappingModule.fdUse}" enumsType="common_yesno" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
