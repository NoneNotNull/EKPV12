<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

	<c:forEach items="${zone_navs}" var="nav">
		<ui:accordionpanel>
			<ui:content title="${nav.fdName }">
				<ui:menu layout="sys.ui.menu.ver.default">
					<ui:menu-source autoFetch="false">
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
					</ui:menu-source>
				</ui:menu>
			</ui:content>
		</ui:accordionpanel>
	</c:forEach>
