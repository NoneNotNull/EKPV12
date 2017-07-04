<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/imissive/km_imissive_template_cfg/kmImissiveTemplateCfg.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/imissive/km_imissive_template_cfg/kmImissiveTemplateCfg.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/imissive/km_imissive_template_cfg/kmImissiveTemplateCfg.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/imissive/km_imissive_template_cfg/kmImissiveTemplateCfg.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmImissiveTemplateCfgForm, 'deleteall');">
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
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial"/></td>
				<td>
				    <bean:message bundle="km-imissive" key="kmImissiveTemplateCfg.fdName"/>
				</td>
				<td>
				    转换类型
				</td>
				<td>
					<bean:message bundle="km-imissive" key="kmImissiveTemplateCfg.from"/>
				</td>
				<td>
					<bean:message bundle="km-imissive" key="kmImissiveTemplateCfg.to"/>
				</td>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmImissiveTemplateCfg" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/imissive/km_imissive_template_cfg/kmImissiveTemplateCfg.do" />?method=view&fdId=${kmImissiveTemplateCfg.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmImissiveTemplateCfg.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${kmImissiveTemplateCfg.fdName}" />
				</td>
				<td>
				    <sunbor:enumsShow value="${kmImissiveTemplateCfg.fdType}" enumsType="kmImissiveTemplateCfg_type" bundle="km-imissive" />
				</td>
				<td>
				 <c:if test="${kmImissiveTemplateCfg.fdSendTempOne!=null}">
				    <c:out value="${kmImissiveTemplateCfg.fdSendTempOne.fdName}" />
				 </c:if>
				 <c:if test="${kmImissiveTemplateCfg.fdReceiveTempOne!=null}">
				    <c:out value="${kmImissiveTemplateCfg.fdReceiveTempOne.fdName}" />
				 </c:if>
				</td>
				<td>
				 <c:if test="${kmImissiveTemplateCfg.fdSendTempTwo!=null}">
				    <c:out value="${kmImissiveTemplateCfg.fdSendTempTwo.fdName}" />
				 </c:if>
				 <c:if test="${kmImissiveTemplateCfg.fdReceiveTempTwo!=null}">
				    <c:out value="${kmImissiveTemplateCfg.fdReceiveTempTwo.fdName}" />
				 </c:if>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>