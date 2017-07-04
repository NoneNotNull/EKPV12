<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="path_hrefDisable" value="false"/>
<xform:editShow>
	<c:set var="path_hrefDisable" value="true"/>
</xform:editShow>
<c:choose>
	<c:when test="${ path_hrefDisable == true }">
			<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;" id="${varParams.id }">
				<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home">
				</ui:menu-item>
				<ui:menu-item text="${ lfn:message('km-imeeting:module.km.imeeting') }" target="_self">
				</ui:menu-item>
				<ui:menu-item text="${ lfn:message('km-imeeting:table.kmImeetingStat') }" href="#" target="_self">
				</ui:menu-item>
				<c:if test="${varParams.items!=null}">
					<ui:menu-source href="">
						<ui:source type="Static">
								${varParams.items}
						</ui:source>
					</ui:menu-source>
				</c:if>
			</ui:menu>
	</c:when>
	<c:otherwise>
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;" id="${varParams.id }">
			<ui:menu-item text="${ lfn:message('home.home') }" 
				icon="lui_icon_s_home" href="/" target='_self'>
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imeeting:module.km.imeeting') }" href="/km/imeeting/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imeeting:table.kmImeetingStat') }" href="/km/imeeting/km_imeeting_stat/index.jsp?stat_key=dept.stat" target="_self">
				<ui:menu-item text="${ lfn:message('km-imeeting:kmImeeting.tree.calender') }" href="/km/imeeting/index.jsp" target="_self"></ui:menu-item>
			   	<ui:menu-item text="${ lfn:message('km-imeeting:table.kmImeetingMain') }" href="/km/imeeting/km_imeeting_main/index.jsp" target="_self"></ui:menu-item>
			   	<ui:menu-item text="${ lfn:message('km-imeeting:kmImeeting.tree.summary') }" href="/km/imeeting/km_imeeting_summary/index.jsp" target="_self"></ui:menu-item>
			</ui:menu-item>
			<c:if test="${varParams.items!=null}">
				<ui:menu-source>
					<ui:source type="Static">
							${varParams.items}
					</ui:source>
				</ui:menu-source>
			</c:if>
		</ui:menu>
	</c:otherwise>
</c:choose>