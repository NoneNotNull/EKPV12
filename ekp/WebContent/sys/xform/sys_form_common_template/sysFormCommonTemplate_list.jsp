<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/xform/sys_form_common_template/sysFormCommonTemplate.do?fdModelName=${param.fdModelName }&fdKey=${param.fdKey }">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/xform/sys_xform_template/sysFormCommonTemplate.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/xform/sys_form_common_template/sysFormCommonTemplate.do">
					<c:param name="method" value="add" />
					<c:param name="fdModelName" value="${param.fdModelName}" />
					<c:param name="fdKey" value="${param.fdKey}" />
					<c:param name="fdMainModelName" value="${param.fdMainModelName}" />
				</c:url>');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/xform/sys_xform_template/sysFormCommonTemplate.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysFormCommonTemplateForm, 'deleteall');">
		</kmss:auth>
	</div>
	<% if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<% }else{ %>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial"/></td>	
				<sunbor:column property="sysFormCommonTemplate.fdName" >
					<bean:message  bundle="sys-xform" key="sysFormCommonTemplate.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysFormCommonTemplate.fdCreator" >
					<bean:message  bundle="sys-xform" key="sysFormCommonTemplate.fdCreatorId"/>
				</sunbor:column>
				<sunbor:column property="sysFormCommonTemplate.fdCreateTime" >
					<bean:message  bundle="sys-xform" key="sysFormCommonTemplate.fdCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysFormCommonTemplate" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/xform/sys_form_common_template/sysFormCommonTemplate.do">
					<c:param name="method" value="view" />
					<c:param name="fdId" value="${sysFormCommonTemplate.fdId}" />
					<c:param name="fdModelName" value="${sysFormCommonTemplate.fdModelName}" />
					<c:param name="fdKey" value="${param.fdKey}" />
					<c:param name="fdMainModelName" value="${param.fdMainModelName}" />
				</c:url>">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysFormCommonTemplate.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td width="50%">
					<c:out value="${sysFormCommonTemplate.fdName}" />
				</td>
				<td width="20%">
					<c:out value="${sysFormCommonTemplate.fdCreator.fdName}" />
				</td>
				<td width="20%">
					<kmss:showDate value="${sysFormCommonTemplate.fdCreateTime}" type="datetime"/>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>