<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form
	action="/tib/soap/sync/tib_soap_sync_temp_func/tibSoapSyncTempFunc.do">
	<div id="optBarDiv"></div>
	<c:if test="${queryPage.totalrows==0}">
		<%@ include file="/resource/jsp/list_norecord.jsp"%>
	</c:if>
	<c:if test="${queryPage.totalrows>0}">
		<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
		<table id="List_ViewTable">
			<tr>

				<%
					Page p = (Page) request.getAttribute("queryPage");
							List<Map<String, Object>> list = p.getList();
							if (list.size() == 0) {
								%>
								<%@ include file="/resource/jsp/list_norecord.jsp"%>
								<% 
							}
							else {
								Map<String, Object> head = (Map<String, Object>) list
										.get(0);

								Set<String> headKey = head.keySet();
				%>
				<sunbor:columnHead htmlTag="td">
					<%
						for (String key : headKey) {
					%>

					<td><%=key%></td>

					<%
						}
									
					%>

				</sunbor:columnHead>

			</tr>
			<%
						
				for (int i = 0; i < list.size(); i++) {
			%>
			<tr>
				<%
					Map<String, Object> mapData = (Map<String, Object>) list
										.get(i);

								for (Object key : (Set) headKey) {
									if (mapData.get(key) != null) {
				%>

				<td><%=mapData.get(key)%></td>

				<%
					} else {
				%>

				<td><span style="color: red;"> <空>
				</span>
				</td>
				<%
					}
								}
				%>
			</tr>
			<%
				}
							}
			%>
		</table>
		<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
