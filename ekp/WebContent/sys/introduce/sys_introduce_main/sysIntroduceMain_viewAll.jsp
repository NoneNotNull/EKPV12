<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
window.onload=function(){
	setTimeout("resizeParent();", 100);
}
function resizeParent(){
	try {
		// 调整高度
		var arguObj = document.forms[0];
		if(arguObj!=null && window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			window.frameElement.style.height = (arguObj.offsetHeight + 20) + "px";
		}
	} catch(e) {
	}
}
</script>
<html:form action="/sys/introduce/sys_introduce_main/sysIntroduceMain.do">
	<%if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {	%>
	<center>
		<bean:message key="sysIntroduceMain.showText.noneRecord" bundle="sys-introduce" />
	</center>
	<%} else {%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="40pt">
					<bean:message key="page.serial" />
				</td>

				<sunbor:column property="sysIntroduceMain.fdIntroducer.fdName">
					<bean:message bundle="sys-introduce" key="sysIntroduceMain.fdIntroducer" />
				</sunbor:column>
				<sunbor:column property="sysIntroduceMain.fdIntroduceTime">
					<bean:message bundle="sys-introduce" key="sysIntroduceMain.fdIntroduceTime" />
				</sunbor:column>
				<td>
					<bean:message bundle="sys-introduce" key="sysIntroduceMain.introduce.type" />
				</td>
				<td>
					<bean:message bundle="sys-introduce" key="sysIntroduceMain.fdIntroduceTo" />
				</td>
				<sunbor:column property="sysIntroduceMain.fdIntroduceGrade">
					<bean:message bundle="sys-introduce" key="sysIntroduceMain.fdIntroduceGrade" />
				</sunbor:column>
				<sunbor:column property="sysIntroduceMain.fdIntroduceReason">
					<bean:message bundle="sys-introduce" key="sysIntroduceMain.fdIntroduceReason" />
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysIntroduceMain" varStatus="vstatus">
			<tr>
				<td width="30" nowrap>
					${vstatus.index+1}
				</td>
				<td width="10%">
					<c:out value="${sysIntroduceMain.fdIntroducer.fdName}" />
				</td>
				<td width="10%">
					<kmss:showDate value="${sysIntroduceMain.fdIntroduceTime}" type="date" />
				</td>
				<td width="12%">
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
				<td width="20%">
					<c:out value="${sysIntroduceMain.introduceGoalNames}" />
				</td>
				<td width="10%">
					<sunbor:enumsShow value="${sysIntroduceMain.fdIntroduceGrade}"	enumsType="sysIntroduce_Grade" />				
				</td>
				<td width="38%" style="text-align:left">
				<c:out value="${sysIntroduceMain.fdIntroduceReason}" />
				</td>
			</tr>
		</c:forEach>
	</table>

	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	
	<%}%>

</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
