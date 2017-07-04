<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<c:set var="favoriteUrl" scope="page" 
	value="/sys/person/sys_person_favorite_category/sysPersonFavoriteCategory.do?method=favorite&modelName=${varParams.modelName}" />

<c:set var="tempate_rander" scope="page">
		{$
			<ul class='lui_list_nav_list'>
		$} 
		for(var i=0;i < data.length;i++){
		    var url = "${ LUI_ContextPath }";
		    if("${varParams.onClick}" != ""){
		    	url = "javascript:${varParams.onClick}";
		    } else {
		    	url += "${varParams.href}";
		    }
			url = favoriteUrlVariableResolver(url, data[i]);
			{$<li><a href="{%url%}" class="favorite_category_link" target="{%data[i].target%}" title="{%data[i].text%}" >{%data[i].text%}</a></li>$}
		}
		{$
			</ul>
		$}
</c:set>

	<script>
	seajs.use(['lui/util/str'], function(str) {
		window.favoriteUrlVariableResolver = str.variableResolver;
	});
	</script>
<c:set var="favoriteTitle" scope="page" value="${lfn:message('sys-person:favorite')} " />
<c:choose>
	<c:when test="${empty varParams.content or varParams.content == 'true'}">
		<ui:content title="${empty varParams.title ? favoriteTitle : varParams.title}" expand="true" toggle="true" style="padding-top: 4px;padding-bottom: 0;">
			<%-- <ui:menu layout="sys.ui.menu.ver.default">
				<ui:menu-source autoFetch="false" href="${varParams.href}">
					<ui:source type="AjaxJson">
						{url: '${favoriteUrl}'}
					</ui:source>
				</ui:menu-source>
			</ui:menu> --%>
			<ui:dataview>
				<ui:source type="AjaxJson">
					{url: '${favoriteUrl}'}
				</ui:source>
				<ui:render type="Template">
					${tempate_rander }
				</ui:render>
			</ui:dataview>
		<ui:operation href="/sys/person/setting.do?setting=sys_person_favorite_category" name="${lfn:message('sys-person:sysPersonFavoriteCategory.config') }"/>
		<%-- <div class="lui_portlet_operations clearfloat" style="margin: -8px 0;">
		<a class="lui_portlet_operation" 
			href="<c:url value="/sys/person/setting.do?setting=sys_person_favorite_category" />" target="_blank" style="float:right">${lfn:message('sys-person:sysPersonFavoriteCategory.config') }</a>
		</div> --%>
		</ui:content>
	</c:when>
	<c:otherwise>
		<%-- <ui:menu layout="sys.ui.menu.ver.default">
			<ui:menu-source autoFetch="false" href="${varParams.href}">
				<ui:source type="AjaxJson">
					{url: '${favoriteUrl}'}
				</ui:source>
			</ui:menu-source>
		</ui:menu> --%>
		<ui:dataview>
			<ui:source type="AjaxJson">
				{url: '${favoriteUrl}'}
			</ui:source>
			<ui:render type="Template">
				${tempate_rander }
			</ui:render>
		</ui:dataview>
		<ui:operation href="/sys/person/setting.do?setting=sys_person_favorite_category" name="${lfn:message('sys-person:sysPersonFavoriteCategory.config') }"/>
		<%-- <div class="lui_portlet_operations clearfloat" style="margin: -8px 0;">
		<a class="lui_portlet_operation" 
			href="<c:url value="/sys/person/setting.do?setting=sys_person_favorite_category" />" target="_blank" style="float:right">${lfn:message('sys-person:sysPersonFavoriteCategory.config') }</a>
		</div> --%>
	</c:otherwise>
</c:choose>
