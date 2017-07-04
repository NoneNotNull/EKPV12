<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ include file="/resource/jsp/list_top.jsp"%>
	<%if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {	%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<%} else {%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.km.review.model.KmReviewTemplate"%>
<%@page import="com.landray.kmss.km.review.actions.KmReviewCommonConfigAction"%>
<%@page import="com.landray.kmss.km.review.util.KmReviewUtil"%>
<script>
	function openReviewList(index){
		var url = "${pageContext.request.contextPath}/moduleindex.jsp?nav=/km/review/tree.jsp&main=/";
		var fdId = document.getElementById("fdId["+index+"]").value;
		var s_path = document.getElementById("s_path["+index+"]").value;
		var s_pathEncode = encodeURIComponent(s_path);
		url += encodeURIComponent("km/review/km_review_main/kmReviewMain.do?method=listChildren&type=category&categoryId="+fdId+"&nodeType=TEMPLATE&s_path="+s_pathEncode+"&s_css=default");
		Com_OpenWindow(url);
	}
	function kmReviewConfig(){
		 window.open('<%=request.getContextPath()%>/km/review/km_review_common_config/kmReviewCommonConfig.do?method=edit','personConfig','resizable=yes,scrollbars=yes,menubar=no,toolbar=no,status=no,width=800px,height=600px,screenX=10px,screenY=10px,top=10px,left=10px');
	}
</script>
<div id="optBarDiv">	
	<input type="button" value="<bean:message bundle="km-review" key="kmReviewMain.commonConfig.set"/>" onClick="kmReviewConfig();">
</div>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td>
					<bean:message key="page.serial" />
				</td>
				<sunbor:column property="kmReviewTemplate.fdName">
					<bean:message bundle="km-review" key="kmReviewTemplate.fdName"/>
				</sunbor:column>
				<td>
					<bean:message bundle="km-review" key="kmReviewMain.commonConfig.path"/>
				</td>
				<td>
					<bean:message key="button.add" />
				</td>
			</sunbor:columnHead>
		</tr>
		<%Page templatePage = (Page)request.getAttribute("queryPage");
		  List  templateList = templatePage.getList();
			if (templateList != null && !templateList.isEmpty()) {
				for (int j = 0; j < templateList.size(); j++) {
					KmReviewTemplate kmReviewTemplate = (KmReviewTemplate) templateList
							.get(j);	
					String path = KmReviewUtil.getSPath(kmReviewTemplate.getDocCategory(),kmReviewTemplate.getFdName());
					%>
					<tr>
						<td width="5%"  onclick="openReviewList('<%=j+1%>');" style="cursor: pointer;">
							<input id="fdId[<%=j+1 %>]" value="<%=kmReviewTemplate.getFdId()%>" type="hidden"/>
							<input id="s_path[<%=j+1 %>]" value="<%=path%>" type="hidden"/>
							<%=j+1 %>
						</td>
						<td onclick="openReviewList('<%=j+1%>');" style="cursor: pointer;">
							<%=kmReviewTemplate.getFdName() %>
						</td>
						<td onclick="openReviewList('<%=j+1%>');" style="cursor: pointer;">
							<%=path%>
						</td>
						<td>
							<img title="<bean:message key="button.add"/>" src="${KMSS_Parameter_StylePath}icons/edit.gif" onclick="Com_OpenWindow('<c:url value="/km/review/km_review_main/kmReviewMain.do" />?method=add&fdTemplateId=<%=kmReviewTemplate.getFdId()%>');" 
					border="0" style="cursor: pointer;">
						</td>				
					</tr>
					<%
				}
			}			
			%>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%}	%>
<%@ include file="/resource/jsp/list_down.jsp"%>
