<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
	function doActionForward(){
		document.location.href="tattEkpSys.do?method=download";
	}
</script>
<html:form action="/sys/ftsearch/expand/t_att_ekp_sys/tattEkpSys.do">
	<div id="optBarDiv">
	
	<input type="button" value="<bean:message key="button.upload" bundle="sys-ftsearch-expand"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/ftsearch/expand/uploadExcle/UploadExcle.jsp" />');">
				
	<input type="button" value="<bean:message key="button.down" bundle="sys-ftsearch-expand"/>"
				onclick="doActionForward()">
				
		<kmss:auth requestURL="/sys/ftsearch/expand/t_att_ekp_sys/tattEkpSys.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/ftsearch/expand/t_att_ekp_sys/tattEkpSys.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/ftsearch/expand/t_att_ekp_sys/tattEkpSys.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tattEkpSysForm, 'deleteall');">
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
				<sunbor:column property="tattEkpSys.fdEkpId">
					<bean:message bundle="sys-ftsearch-expand" key="tattEkpSys.fdEkpId"/>
				</sunbor:column>
				<sunbor:column property="tattEkpSys.fdEkpName">
					<bean:message bundle="sys-ftsearch-expand" key="tattEkpSys.fdEkpName"/>
				</sunbor:column>
				<sunbor:column property="tattEkpSys.fdSysName">
					<bean:message bundle="sys-ftsearch-expand" key="tattEkpSys.fdSysName"/>
				</sunbor:column>
				<sunbor:column property="tattEkpSys.fdUserId">
					<bean:message bundle="sys-ftsearch-expand" key="tattEkpSys.fdUserId"/>
				</sunbor:column>
				<sunbor:column property="tattEkpSys.fdUserName">
					<bean:message bundle="sys-ftsearch-expand" key="tattEkpSys.fdUserName"/>
				</sunbor:column>
					<sunbor:column property="tattEkpSys.fdTypeUser">
					<bean:message bundle="sys-ftsearch-expand" key="tattEkpSys.fdTypeUser"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tattEkpSys" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/ftsearch/expand/t_att_ekp_sys/tattEkpSys.do" />?method=view&fdId=${tattEkpSys.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tattEkpSys.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tattEkpSys.fdEkpId}" />
				</td>
				<td>
					<c:out value="${tattEkpSys.fdEkpName}" />
				</td>
				<td>
					<c:out value="${tattEkpSys.fdSysName}" />
				</td>
				<td>
					<c:out value="${tattEkpSys.fdUserId}" />
				</td>
				<td>
					<c:out value="${tattEkpSys.fdUserName}" />
				</td>
				<td>
					<c:out value="${tattEkpSys.fdTypeUser}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>