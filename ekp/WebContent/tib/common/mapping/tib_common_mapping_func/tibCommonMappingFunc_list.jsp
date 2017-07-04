<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/common/mapping/tib_common_mapping_func/tibCommonMappingFunc.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/common/mapping/tib_common_mapping_func/tibCommonMappingFunc.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/common/mapping/tib_common_mapping_func/tibCommonMappingFunc.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/common/mapping/tib_common_mapping_func/tibCommonMappingFunc.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibCommonMappingFuncForm, 'deleteall');">
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
				<sunbor:column property="tibCommonMappingFunc.fdTemplateId">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdTemplateId"/>
				</sunbor:column>
				<sunbor:column property="tibCommonMappingFunc.fdInvokeType">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdInvokeType"/>
				</sunbor:column>
				<sunbor:column property="tibCommonMappingFunc.fdOrder">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="tibCommonMappingFunc.fdFuncMark">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdFuncMark"/>
				</sunbor:column>
				<sunbor:column property="tibCommonMappingFunc.fdRfcImport">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdRfcImport"/>
				</sunbor:column>
				<sunbor:column property="tibCommonMappingFunc.fdRfcExport">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdRfcExport"/>
				</sunbor:column>
				<sunbor:column property="tibCommonMappingFunc.fdJspSegmen">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdJspSegmen"/>
				</sunbor:column>
				<sunbor:column property="tibCommonMappingFunc.fdQuartzId">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdQuartzId"/>
				</sunbor:column>
				<sunbor:column property="tibCommonMappingFunc.fdUse">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdUse"/>
				</sunbor:column>
				<sunbor:column property="tibCommonMappingFunc.fdQuartzTime">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdQuartzTime"/>
				</sunbor:column>
				<sunbor:column property="tibCommonMappingFunc.fdRfcSetting.docSubject">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdRfcSetting"/>
				</sunbor:column>
				<sunbor:column property="tibCommonMappingFunc.fdMain.docSubject">
					<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdMain"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibCommonMappingFunc" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/common/mapping/tib_common_mapping_func/tibCommonMappingFunc.do" />?method=view&fdId=${tibCommonMappingFunc.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibCommonMappingFunc.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibCommonMappingFunc.fdTemplateId}" />
				</td>
				<td>
					<c:out value="${tibCommonMappingFunc.fdInvokeType}" />
				</td>
				<td>
					<c:out value="${tibCommonMappingFunc.fdOrder}" />
				</td>
				<td>
					<c:out value="${tibCommonMappingFunc.fdFuncMark}" />
				</td>
				<td>
					<c:out value="${tibCommonMappingFunc.fdRfcImport}" />
				</td>
				<td>
					<c:out value="${tibCommonMappingFunc.fdRfcExport}" />
				</td>
				<td>
					<c:out value="${tibCommonMappingFunc.fdJspSegmen}" />
				</td>
				<td>
					<c:out value="${tibCommonMappingFunc.fdQuartzId}" />
				</td>
				<td>
					<sunbor:enumsShow value="${tibCommonMappingFunc.fdUse}" enumsType="common_yesno" />
				</td>
				<td>
					<kmss:showDate value="${tibCommonMappingFunc.fdQuartzTime}" />
				</td>
				<td>
					<c:out value="${tibCommonMappingFunc.fdRfcSetting.docSubject}" />
				</td>
				<td>
					<c:out value="${tibCommonMappingFunc.fdMain.docSubject}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
