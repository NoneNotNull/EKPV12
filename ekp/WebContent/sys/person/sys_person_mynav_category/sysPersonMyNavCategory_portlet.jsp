<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<%@ page import="com.landray.kmss.sys.person.service.ISysPersonMyNavCategoryService,
		com.landray.kmss.util.SpringBeanUtil" %>
	<%
	if (request.getAttribute("home_navs") == null) {
		ISysPersonMyNavCategoryService service = (ISysPersonMyNavCategoryService) SpringBeanUtil.getBean("sysPersonMyNavCategoryService");
		request.setAttribute("home_navs", service.findPersonAllNav());
	}
	%>
	<c:set var="tempate_rander" scope="page">
			{$
					<ul class='lui_list_nav_list'>
			$} 
			for(var i=0;i <data.length;i++){
				var xid = encodeURIComponent(data[i].id);
				if (data[i].id == '${param.nav }' || data[i].id == '${SYS_PERSON_HOME_LINK.fdId }') {
					{$<li class="lui_list_nav_selected"><a href="${ LUI_ContextPath }/sys/person/home.do?nav={%xid%}" target="_self" title="{%data[i].text%}">{%data[i].text%}</a></li>$}
				} else {
					{$<li><a href="${ LUI_ContextPath }/sys/person/home.do?nav={%xid%}" target="{%data[i].target%}" title="{%data[i].text%}">{%data[i].text%}</a></li>$}
				}
			}
			{$
				</ul>
			$}
	</c:set>
	<ui:accordionpanel cfg-memoryExpand="person_my_home_nav">
	<c:forEach items="${home_navs}" var="nav">
			<portal:portlet title="${empty nav.fdShortName ? nav.fdName : nav.fdShortName }">
				<c:if test="${nav.sysNavCategory != null}">
					<c:set var="nav" value="${nav.sysNavCategory }" scope="page" />
				</c:if>
				<ui:dataview>
					<ui:source type="Static">
							[<ui:trim>
							<c:forEach items="${nav.fdLinks}" var="link">
								{
									id: "${link.fdId }",
									text: "<c:out value="${link.fdName }" />",
									href: "${link.fdUrl }",
									target: "${link.fdTarget }"
								},
							</c:forEach>
							</ui:trim>]
						</ui:source>
					<ui:render type="Template">
					${tempate_rander }
					</ui:render>
				</ui:dataview>
			</portal:portlet>
	</c:forEach>
	</ui:accordionpanel>
	<%
	request.removeAttribute("home_navs");
	%>
