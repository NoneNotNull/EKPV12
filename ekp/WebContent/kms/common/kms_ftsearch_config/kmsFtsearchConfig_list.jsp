<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
function setDefault(){
	var fdId = "";
	var url ="kmsFtsearchConfig.do?method=setDefault&fdIsSetDefault=true&fdId="+fdId;
	Com_OpenWindow(url,'_self');
}
</script>
<html:form action="/kms/common/kms_ftsearch_config/kmsFtsearchConfig.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/common/kms_ftsearch_config/kmsFtsearchConfig.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/common/kms_ftsearch_config/kmsFtsearchConfig.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/common/kms_ftsearch_config/kmsFtsearchConfig.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsFtsearchConfigForm, 'deleteall');">
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
				<sunbor:column property="kmsFtsearchConfig.docSubject">
					<bean:message bundle="kms-common" key="kmsFtsearchConfig.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmsFtsearchConfig.docCreateTime">
					<bean:message bundle="kms-common" key="kmsFtsearchConfig.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsFtsearchConfig.docAlterTime">
					<bean:message bundle="kms-common" key="kmsFtsearchConfig.docAlterTime"/>
				</sunbor:column>
				<sunbor:column property="kmsFtsearchConfig.fdLastModifiedTime">
					<bean:message bundle="kms-common" key="kmsFtsearchConfig.fdLastModifiedTime"/>
				</sunbor:column>
				<sunbor:column property="kmsFtsearchConfig.fdIsDefault">
					<bean:message bundle="kms-common" key="kmsFtsearchConfig.fdIsDefaultSearch"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsFtsearchConfig" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/common/kms_ftsearch_config/kmsFtsearchConfig.do" />?method=view&fdId=${kmsFtsearchConfig.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsFtsearchConfig.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsFtsearchConfig.docSubject}" />
				</td>
				<td>
					<kmss:showDate value="${kmsFtsearchConfig.docCreateTime}" />
				</td>
				<td>
					<kmss:showDate value="${kmsFtsearchConfig.docAlterTime}" />
				</td>
				<td>
					<kmss:showDate value="${kmsFtsearchConfig.fdLastModifiedTime}" />
				</td>
				<td>
					<c:choose>
						<c:when test="${kmsFtsearchConfig.fdIsDefault=='true'}">
							<bean:message key="message.yes"/>
						</c:when>
						<c:otherwise>
							<bean:message key="message.no"/>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>