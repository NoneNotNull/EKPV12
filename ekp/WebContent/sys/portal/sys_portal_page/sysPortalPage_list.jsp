<%@page import="com.landray.kmss.sys.ui.xml.model.SysUiTheme"%>
<%@page import="org.apache.commons.beanutils.PropertyUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/portal/sys_portal_page/sysPortalPage.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/portal/sys_portal_page/sysPortalPage.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/portal/sys_portal_page/sysPortalPage.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/portal/sys_portal_page/sysPortalPage.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysPortalPageForm, 'deleteall');">
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
				<sunbor:column property="sysPortalPage.fdName">
					<bean:message bundle="sys-portal" key="sysPortalPage.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysPortalPage.fdTheme">
					<bean:message bundle="sys-portal" key="sysPortalPage.fdTheme"/>
				</sunbor:column>
				<sunbor:column property="sysPortalPage.fdType">
					<bean:message bundle="sys-portal" key="sysPortalPage.fdType"/>
				</sunbor:column>
				<sunbor:column property="sysPortalPage.docSubject">
					操作
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysPortalPage" varStatus="vstatus">
			<tr>
				<td>
					<input type="checkbox" name="List_Selected" value="${sysPortalPage.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<div style="text-align: left;">
					<a target="_blank" href="<c:url value="/sys/portal/sys_portal_page/sysPortalPage.do" />?method=view&fdId=${sysPortalPage.fdId}"><c:out value="${sysPortalPage.fdName}" /></a>
					&nbsp;&nbsp;:&nbsp;&nbsp;<c:out value="${sysPortalPage.fdPortalNames}" />
					</div>
				</td>
				<td>
					<%
						Object syspage = pageContext.getAttribute("sysPortalPage");
						if(syspage!=null){
							String theme = (String)PropertyUtils.getProperty(syspage,"fdTheme");
							if(theme != null){
								SysUiTheme uit = SysUiPluginUtil.getThemeById(theme);
								if(uit != null)
									out.append(uit.getFdName());
							}
						}
					%>
				</td>
				<td> 
					<xform:select property="connState" value="${sysPortalPage.fdType}">
						<xform:enumsDataSource enumsType="sys_portal_page_type" />
					</xform:select> 
				</td>
				<td>
					<kmss:auth requestURL="/sys/portal/sys_portal_page/sysPortalPage.do?method=edit&fdId=${sysPortalPage.fdId}">
			 
						<a target="_blank" href="<c:url value="/sys/portal/sys_portal_page/sysPortalPage.do" />?method=edit&fdId=${sysPortalPage.fdId}">${lfn:message('button.edit') }</a>
					
					</kmss:auth>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>