<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.number.service.ISysNumberMainMappService,com.landray.kmss.sys.number.service.ISysNumberMainFlowService,com.landray.kmss.sys.number.model.SysNumberMainMapp,java.util.*" %>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/number/sys_number_main_flow/sysNumberMainFlow.do">
	 
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
				<sunbor:column property="sysNumberMainFlow.fdNumberMain.fdName">
					<bean:message bundle="sys-number" key="sysNumberMainFlow.fdNumberMain"/>
				</sunbor:column>
				<sunbor:column property="sysNumberMainFlow.fdVirtualNumberValue">
					<bean:message bundle="sys-number" key="sysNumberMainFlow.fdVirtualNumberValue"/>
				</sunbor:column>
				<sunbor:column property="sysNumberMainFlow.fdFlowNum">
					<bean:message bundle="sys-number" key="sysNumberMainFlow.fdFlowNum"/>
				</sunbor:column>
				<sunbor:column property="sysNumberMainFlow.fdLimitsValue">
					<bean:message bundle="sys-number" key="sysNumberMainFlow.fdLimitsValue"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysNumberMainFlow" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/number/sys_number_main_flow/sysNumberMainFlow.do" />?method=edit&fdId=${sysNumberMainFlow.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysNumberMainFlow.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:set var="sysNumberMainName" value="${sysNumberMainFlow.fdNumberMain.fdName}"/>
					<c:set var="sysNumberMainId" value="${sysNumberMainFlow.fdNumberMain.fdId}"/>
					<%
						String sysNumberMainName=(String)pageContext.getAttribute("sysNumberMainName");
						String sysNumberMainId=(String)pageContext.getAttribute("sysNumberMainId");
						if(StringUtil.isNotNull(sysNumberMainName))
						{
							out.print(sysNumberMainName);
						}
						else
						{
							ISysNumberMainMappService sysNumberMainMappService= (ISysNumberMainMappService) SpringBeanUtil.getBean("sysNumberMainMappService");
							List mapps=null;
							try {
								mapps = sysNumberMainMappService.findList("fdNumber.fdId='"+sysNumberMainId+"'", null);
							} catch (Exception e) {
								System.out.println(e.getLocalizedMessage());
							}
							if(mapps!=null && mapps.size()>0)
							{
								SysNumberMainMapp mapp=(SysNumberMainMapp) mapps.get(0);
								if(mapp!=null)
								{
									try {
										out.print(""+((ISysNumberMainFlowService)SpringBeanUtil.getBean("sysNumberMainFlowService")).getLinkModelName(mapp.getFdModelName(), mapp.getFdModelId()));
									} catch (Exception e) {
										System.out.println(e.getLocalizedMessage());
									}
								}
							}
						}
					%> 
				</td>
				<td>
					<c:out value="${sysNumberMainFlow.fdVirtualNumberValue}" />
				</td>
				<td>
					<c:out value="${sysNumberMainFlow.fdFlowNum}" />
				</td>
				<td>
					<c:out value="${sysNumberMainFlow.fdLimitsValue}" />
				</td>
				
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>