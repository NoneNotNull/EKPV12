<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="fmt"%>
<script type="text/javascript">
	Com_IncludeFile("dialog.js");
</script>
<script type="text/javascript">
function dyniFrameSize() {
	try {
		// 调整高度
		var arguObj = document.getElementsByTagName("table")[0];
		if (arguObj != null && window.frameElement != null && window.frameElement.tagName == "IFRAME") {
			window.frameElement.style.height = (arguObj.offsetHeight + 20) + "px";
		}
	} catch (e) {}
}
window.onload =function (){
	setTimeout(dyniFrameSize,100);
}; 
</script>
<c:import
	url="/sys/right/doc_right_change_button.jsp"
	charEncoding="UTF-8">
	<c:param
		name="modelName"
		value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
	<c:param
		name="authReaderNoteFlag"
		value="2" />
</c:import>
<c:import
	url="/sys/simplecategory/include/doc_cate_change_button.jsp"
	charEncoding="UTF-8">
	<c:param
		name="modelName"
		value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
	<c:param
		name="docFkName"
		value="fdTemplate" />
	<c:param
		name="cateModelName"
		value="com.landray.kmss.km.smissive.model.KmSmissiveTemplate" />
</c:import>
<c:import url="/sys/bookmark/include/bookmark_bar_all.jsp"
	charEncoding="UTF-8">
	<c:param name="fdTitleProName" value="docSubject" />
	<c:param name="fdModelName"
		value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
</c:import>
<c:import url="/resource/jsp/search_bar.jsp" charEncoding="UTF-8">
	<c:param name="fdModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
</c:import>
<html:form action="/km/smissive/km_smissive_main/kmSmissiveMain.do">
<div id="optBarDiv">
	<kmss:authShow roles="ROLE_KMSMISSIVE_CREATE">
	<c:choose>
		<c:when test="${not empty param.categoryId}">
		
			<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=add&categoryId=${param.categoryId}" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/smissive/km_smissive_main/kmSmissiveMain.do" />?method=add&categoryId=${param.categoryId}');">
			</kmss:auth>
		
		</c:when>
		<c:otherwise>
		
			<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=add" requestMethod="GET">
				<input type="button" value="<bean:message key="button.add"/>"
				onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.km.smissive.model.KmSmissiveTemplate','<c:url value="/km/smissive/km_smissive_main/kmSmissiveMain.do" />?method=add&categoryId=!{id}');">
			</kmss:auth>
		
		</c:otherwise>
	</c:choose>
	</kmss:authShow>
	
	<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}&nodeType=${param.nodeType}" requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmSmissiveMainForm, 'deleteall');">
	</kmss:auth>
	
	<input type="button" value="<bean:message key="button.search"/>" onclick="Search_Show();">
	
</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="30pt"><bean:message key="page.serial"/></td>
				<sunbor:column property="kmSmissiveMain.fdFileNo" >
					<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdFileNo"/>
				</sunbor:column>
				<sunbor:column property="kmSmissiveMain.docSubject">
					<bean:message  bundle="km-smissive" key="kmSmissiveMain.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmSmissiveMain.docCreator.fdName">
					<bean:message  bundle="km-smissive" key="kmSmissiveMain.docCreatorId"/>
				</sunbor:column>
				<sunbor:column property="kmSmissiveMain.fdMainDept.fdName">
					<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdMainDeptId"/>
				</sunbor:column>
				<sunbor:column property="kmSmissiveMain.docPublishTime">
					<bean:message  bundle="km-smissive" key="kmSmissiveMain.docPublishTime"/>
				</sunbor:column>
				<sunbor:column property="kmSmissiveMain.docStatus">
					<bean:message  bundle="km-smissive" key="kmSmissiveMain.docStatus"/>
				</sunbor:column>								
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmSmissiveMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/smissive/km_smissive_main/kmSmissiveMain.do" />?method=view&fdId=${kmSmissiveMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmSmissiveMain.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td kmss_wordlength="22">
					${kmSmissiveMain.fdFileNo}
				</td>
				<td kmss_wordlength="35">
					<c:out value="${kmSmissiveMain.docSubject}" />
				</td>
				<td width="10%">
					${kmSmissiveMain.docCreator.fdName}
				</td>
				<td kmss_wordlength="12" width="10%">
					${kmSmissiveMain.fdMainDept.fdName}
				</td>
				<td width="10%">
					<kmss:showDate value="${kmSmissiveMain.docPublishTime}" type="date"/>
				</td>
				<td width="10%">
					<sunbor:enumsShow value="${kmSmissiveMain.docStatus}" enumsType="common_status" />
				</td>
				
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>