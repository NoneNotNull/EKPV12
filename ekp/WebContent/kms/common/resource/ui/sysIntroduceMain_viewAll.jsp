<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 
<%@ include file="/kms/common/resource/ui/kms_list_top.jsp" %>
<script type="text/javascript">
Com_AddEventListener(window,"load",function(){
	setTimeout("resizeInterduceParent();", 100);
	var num='<%=((Page)request.getAttribute("queryPage")).getTotalrows()%>';
    self.parent.refreshIntroduceNum(num) ;
});

function resizeInterduceParent(){
	var arguObj = document.forms[0];
	if(arguObj!=null && window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
		window.frameElement.style.height = (arguObj.offsetHeight + 20) + "px";
	}
}
</script>
<html:form action="/kms/common/resource/ui/kmsSysIntroduceMain.do">
	<%if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {	%>
	<center>
		<bean:message key="sysIntroduceMain.showText.noneRecord" bundle="sys-introduce" />
	</center>
	<%} else {%>
	<table id="List_ViewIntroduceTable" class="t_b" border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr>
			 
				<td width="5%" class="t_b_b">
					NO.
				</td>
				<td width="10%">
					<bean:message bundle="sys-introduce" key="sysIntroduceMain.fdIntroducer" />
				</td>
				<td width="15%">
					<bean:message bundle="sys-introduce" key="sysIntroduceMain.fdIntroduceTime" />
				</td>
				<td width="15%">
					<bean:message bundle="sys-introduce" key="sysIntroduceMain.introduce.type" />
				</td>
				<td width="10%">
					<bean:message bundle="sys-introduce" key="sysIntroduceMain.fdIntroduceTo" />
				</td>
				<td width="10%">
					<bean:message bundle="sys-introduce" key="sysIntroduceMain.fdIntroduceGrade" />
				</td>
				<td class="t_b_c" width="35%">
					<bean:message bundle="sys-introduce" key="sysIntroduceMain.fdIntroduceReason" />
				</td>
			 
		</tr>
		<c:forEach items="${queryPage.list}" var="sysIntroduceMain" varStatus="vstatus">
			<c:choose>
                <c:when test="${vstatus.index%2==0}">
   				 <tr >
                </c:when>
                <c:otherwise>
                <tr class='t_b_a' >
                </c:otherwise>
            </c:choose>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysIntroduceMain.fdIntroducer.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${sysIntroduceMain.fdIntroduceTime}" type="date" />
				</td>
				<td>
					<c:if test="${sysIntroduceMain.fdIntroduceToEssence}">
						<bean:message key="sysIntroduceMain.introduce.show.type.essence" bundle="sys-introduce" />
					</c:if>
					<c:if test="${sysIntroduceMain.fdIntroduceToNews}">
						<bean:message key="sysIntroduceMain.introduce.show.type.news" bundle="sys-introduce" />
					</c:if>
					<c:if test="${sysIntroduceMain.fdIntroduceToPerson}">
						<bean:message key="sysIntroduceMain.introduce.show.type.person" bundle="sys-introduce" />
					</c:if>
				</td>
				<td kmss_wordlength="20">
					<c:out value="${sysIntroduceMain.introduceGoalNames}" />
				</td>
				<td>
					<sunbor:enumsShow value="${sysIntroduceMain.fdIntroduceGrade}"	enumsType="sysIntroduce_Grade" />				
				</td>
				<td kmss_wordlength="60" style="text-align:left">
					<c:out value="${sysIntroduceMain.fdIntroduceReason}" />
				</td>
			</tr>
		</c:forEach>
	</table>

	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	
	<%}%>

</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
