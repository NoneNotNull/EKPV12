<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.SpringBeanUtil,
		java.util.*,
		com.landray.kmss.sys.person.interfaces.*" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%-- 需要处理当前人员 --%>
<template:include file="/sys/person/template/person.base.template.jsp">
	<template:replace name="title">个人空间</template:replace>
	<c:if test="${empty param.iframe }">
	<template:replace name="nav">
	<div style="text-align: center; background-color: #fff;">
	    <div style="padding-top: 15px;">
	     <img style="max-width: 120px;" src="${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${zone_user.fdId}&size=120" />
	    </div>
	    <div style="text-align: left;padding: 5px 10px;">
	    <span class="com_author"><c:out value="${zone_user.fdName }" /></span>
	    </div>
	    <div style="text-align: left;padding: 0 10px 5px 10px;">
	    <span><c:out value="${zone_user.fdParent.fdName }" /></span>
	    </div>
	</div>
	<c:set var="tempate_rander" scope="page">
			{$
					<ul class='lui_list_nav_list'>
			$}
			var taText = '<c:out value="${zone_TA_text }" />';
			for(var i = 0; i < data.length; i++) {
				var text = data[i].text;
				if (text != null && taText != '' && taText != 'TA' && text.indexOf('TA') > -1) {
					text = text.replace('TA', taText);
				}
				if (data[i].id == '${param.nav }' || data[i].id == '${param.id }') {
					{$<li class="lui_list_nav_selected"><a href="${ LUI_ContextPath }${zone_url}{%data[i].id%}" title="{%data[i].text%}">{%text%}</a></li>$}
				} else {
					{$<li><a href="${ LUI_ContextPath }${zone_url}{%data[i].id%}" title="{%data[i].text%}">{%text%}</a></li>$}
				}
			}
			{$
				</ul>
			$}
	</c:set>
	<c:forEach items="${zone_navs}" var="nav">
		<ui:accordionpanel>
			<ui:content title="${nav.fdName }">
			
				<ui:dataview>
					<ui:source type="Static">
							[<ui:trim>
							<c:forEach items="${nav.fdLinks}" var="link">
								{
									id: "${link.fdId }",
									text: "<c:out value="${link.fdName }" />",
									<%-- href: "${link.fdUrl }", --%>
									target: "${link.fdTarget }"
								},
							</c:forEach>
							</ui:trim>]
						</ui:source>
					<ui:render type="Template">
					${tempate_rander }
					</ui:render>
				</ui:dataview>
			</ui:content>
		</ui:accordionpanel>
	</c:forEach>
	</template:replace>
	</c:if>
</template:include>
