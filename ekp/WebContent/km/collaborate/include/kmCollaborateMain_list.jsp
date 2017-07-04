<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
	<c:import url="/resource/jsp/search_bar.jsp" charEncoding="UTF-8">
		<c:param name="fdModelName" value="com.landray.kmss.km.collaborate.model.KmCollaborateMain" />
	</c:import>
<html:form action="/km/collaborate/km_collaborate_main/kmCollaborateMain.do">
			<c:set var="validateAuth" value="false" />
		<c:if test="${param.status eq 10 }">
			<c:set var="validateAuth" value="true" />
		</c:if>
		<c:if test="${! (param.status eq 10) }">
		   <c:if test="${queryPage.totalrows>0}">
				<kmss:authShow roles="ROLE_KMCOLLABORATEMAIN_DELETE">
					<c:set var="validateAuth" value="true" />
				</kmss:authShow>
			</c:if>
		</c:if>
<c:if test="${queryPage.totalrows==0}">
	<center>
		<bean:message key="kmCollaborateMain.noRecord" bundle="km-collaborate" />
	</center>
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
				<td width="10pt">
					<img   src="../img/gt.png" style="margin:4px 0 0 0;">
				</td>
				<td width="10pt">
					<img   src="../img/fjh.png"  style="margin:4px 0 0 0;">
				</td>
				
				<sunbor:column property="kmCollaborateMain.docSubject">
					<bean:message bundle="km-collaborate" key="kmCollaborateMain.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateMain.fdCategory.fdName">
					<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdCategory"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateMain.docCreator.fdName">
					<bean:message bundle="km-collaborate" key="kmCollaborateMain.docCreator"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateMain.docReadCount">
					<bean:message bundle="km-collaborate" key="kmCollaborateMain.docReadCount"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateMain.docReplyCount">
					<bean:message bundle="km-collaborate" key="kmCollaborateMain.docReplyCount"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateMain.docCreateTime">
					<bean:message bundle="km-collaborate" key="kmCollaborateMain.docCreateTime"/>
				</sunbor:column>
			
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmCollaborateMain" varStatus="vstatus">
			<tr
				<c:if test="${!(param.status eq '10') }">kmss_href="<c:url value="/km/collaborate/km_collaborate_main/kmCollaborateMain.do" />?method=view&fdId=${kmCollaborateMain.fdId}"</c:if>
				<c:if test="${param.status eq '10' }">kmss_href="<c:url value="/km/collaborate/km_collaborate_main/kmCollaborateMain.do" />?method=viewDefault&fdId=${kmCollaborateMain.fdId}"</c:if>
				
			>
		
				<td>
					<input type="checkbox" name="List_Selected" value="${kmCollaborateMain.fdId}">
				</td>
				<td>
					<center>${vstatus.index+1}</center>
				</td>
				<td width="10pt">
				   <c:if test="${kmCollaborateMain.fdIsPriority }">
					   <img  src="../img/gt_zy.png" >
				   </c:if>
				   <c:if test="${!kmCollaborateMain.fdIsPriority }">
				       &nbsp;
				   </c:if>
				</td>
				<td width="10pt">
				  <c:if test="${kmCollaborateMain.fdHasAttachment}">
				       <img   src="../img/fjh.png">
				   </c:if>
				
				</td>
				<td align="left" style="text-align:left;">
					<c:if test="${kmCollaborateMain.docStatus==40 }">
					<img src="../img/end.gif" border="0">
				    </c:if>
					<c:out value="${kmCollaborateMain.docSubject}" />
				</td>
				<td width="240pt"><center>
					<c:out value="${kmCollaborateMain.fdCategory.fdName}" /></center>
				</td>
				<td width="90pt"><center>
					<c:out value="${kmCollaborateMain.docCreator.fdName}" /></center>
				</td>
				<td width="60pt"><center>
				<c:if test="${kmCollaborateMain.docReadCount==null}">
				0
				</c:if>
					<c:out value="${kmCollaborateMain.docReadCount}" />
					</center>
				</td>
				<td width="60pt"><center>
				<c:if test="${kmCollaborateMain.docReplyCount==null}">
				0
				</c:if>
					<c:out value="${kmCollaborateMain.docReplyCount}" /></center>
				</td>
				<td width="150pt"><center>
					<kmss:showDate value="${kmCollaborateMain.docCreateTime}" /></center>
				</td>
				<c:if test="${validateAuth=='true'}">
					<td width="60pt">
						<a href="#" onClick="if(!confirmDelete())return;Com_OpenWindow(
						'<c:url value="/km/collaborate/km_collaborate_main/kmCollaborateMain.do"/>?method=deleteInclude&fdId=${kmCollaborateMain.fdId}&fdModelId=${kmCollaborateMain.fdModelId}&fdModelName=${kmCollaborateMain.fdModelName}','_self');"><bean:message key="button.delete" /></a>
					</td>
				</c:if>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<script type="text/javascript">
Com_IncludeFile("jquery.js");
</script>
<script type="text/javascript">
function resizeParent(){
	try {
		// 调整高度
		var arguObj = document.forms[0];
		if(arguObj!=null && window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			window.frameElement.style.height = (arguObj.offsetHeight + 60) + "px";
		}
	} catch(e) {
	}
}
function confirmDelete(msg){
	var del = confirm('<bean:message key="page.comfirmDelete"/>');
	return del;
}
Com_AddEventListener(window,"load",function(){
	setTimeout("resizeParent();", 100);
});
</script>
<%@ include file="/resource/jsp/list_down.jsp"%>