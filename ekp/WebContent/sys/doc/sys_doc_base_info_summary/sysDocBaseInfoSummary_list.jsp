<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<style type="text/css">
<!--
.lineStyle {
	border-collapse:collapse;
	border-top: 0px solid #CCCCCC;
	border-right: 0px solid #CCCCCC;
	border-bottom: 1px solid #CCCCCC;
	border-left: 0px solid #CCCCCC;
	height: 40px;
}
.slightLineStyle {
	border-collapse:collapse;
	border-top: 0px solid #CCCCCC;
	border-right: 0px solid #CCCCCC;
	border-bottom: 1px solid #CCCCCC;
	border-left: 0px solid #CCCCCC;
	height: 0px;
}
.boldLinkFont {
	font-size: 13px;
	color: #3e9af9;
	text-decoration: none;
	font-weight: bold;
}
.normalLinkFont {
	font-size: 13px;
	color: #40403d;
	text-decoration: none;
}
.txttitle{
	font-size: 18px;
	font-weight: bold; 
	text-align: center;
}
-->
</style>

	<%if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<%} else {%>
	<c:set var="maxSize" value="${queryPage.totalrows}" />
	<div class="txttitle">
		<bean:message bundle="sys-doc" key="sysDoc.summary.title" />
	</div>
	<%Date date = new Date();
				pageContext.setAttribute("now", date);
%>
	<center>
		(
		<bean:message bundle="sys-doc" key="sysDoc.summary.title.refreshTime" />
		<kmss:showDate value="${now}" type="date" />
		)
	</center>
	<center>
		<table width="95%">
			<c:forEach items="${queryPage.list}" var="mainSummary" varStatus="mainStatus">
				<c:set var="mainIndex" value="${(mainStatus.index % 10)+ 1}" />
				<tr>
					<td width="100%" colspan="5">
						<img src="${KMSS_Parameter_StylePath}icons/summary${mainIndex}.gif" style="cursor:pointer">
						<a href="#" class="boldLinkFont" onClick="Com_OpenWindow('<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do" />?method=listChildren&parentId=${mainSummary.fdId}&isShowAll=false','_self');">${mainSummary.fdCateName}( ${mainSummary.fdCount} )</a>
					</td>
				</tr>
				<tr class="slightLineStyle"><td colspan=5 class="slightLineStyle">&nbsp;</td></tr>	
				<tr>
					<c:forEach items="${mainSummary.hbmChildrenSummaryList}" var="subSummary" varStatus="subStatus">
						<td width="20%">
							&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" class="normalLinkFont" onClick="Com_OpenWindow('<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do" />?method=listChildren&parentId=${subSummary.fdId}&isShowAll=false','_self');"><c:out value="${subSummary.fdCateName}" />( ${subSummary.fdCount} )</a>
						</td>
						<c:if test="${(subStatus.index + 1) % 5 == 0}">
				</tr>
				<c:if test="${subStatus.index <= (mainSummary.fdChildCount) && mainSummary.fdChildCount != 0}">
					
				</c:if>
				<tr class="slightLineStyle"><td colspan=5 class="slightLineStyle">&nbsp;</td></tr>
				<tr>
					</c:if>
				
			</c:forEach>
			</tr>
			<c:if test="${mainSummary.fdChildCount > 0 }">
				<tr class="slightLineStyle"><td colspan=5 class="slightLineStyle">&nbsp;</td></tr>	
			</c:if>
			</c:forEach>
		</table>
	</center>
	<%}%>
<%@ include file="/resource/jsp/list_down.jsp"%>
