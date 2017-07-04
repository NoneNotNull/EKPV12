<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/ui/kms_list_top.jsp" %>
<%@ page import="java.util.List,com.landray.kmss.util.ModelUtil" %>
<script type="text/javascript">
window.onload=function(){
	var td_evaluation = parent.document.getElementById("editionContent");
	td_evaluation.style.height=document.body.scrollHeight + 50;
}
function openDoc(url) {
	window.open(url,"_blank");
}
</script>
 
				<bean:message key="sysEditionMain.showText.historyVersion" bundle="sys-edition" />
			 
				<%if (((List) request.getAttribute("queryList")).isEmpty()) {%>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<bean:message key="sysEditionMain.showText.noneRecord" bundle="sys-edition" />
				<%} else {%>
					<table id="List_ViewTables" class="t_b" border="0" cellspacing="0" cellpadding="0" width="100%">
						<tr>
						 
								<td width="30pt" class="t_b_b">
								 NO. 
								</td>
								<td width="300pt">
									<bean:message bundle="sys-edition" key="sysEditionMain.list.subject" />
								</td>
								<td width="100pt">
									<bean:message bundle="sys-edition" key="sysEditionMain.list.creator" />
								</td>
								<td width="100pt">
									<bean:message bundle="sys-edition" key="sysEditionMain.list.version" />
								</td>
								<td width="100pt" class="t_b_c">
									<bean:message bundle="sys-edition" key="sysEditionMain.list.createtime" />
								</td>
							 
						</tr>
						<c:forEach items="${queryList}" var="editionDocument" varStatus="vstatus">
						<%
							pageContext.setAttribute("editionDocumentUrl",ModelUtil.getModelUrl(pageContext.getAttribute("editionDocument")));
						%>
							<c:choose>
				                <c:when test="${vstatus.index%2==0}">
				   				 <tr kmss_href="<c:url value="${editionDocumentUrl}" />" kmss_target="_blank">
				                </c:when>
				                <c:otherwise>
				                 <tr kmss_href="<c:url value="${editionDocumentUrl}" />" kmss_target="_blank"  class='t_b_a' >
				                </c:otherwise>
				            </c:choose>
							
								<td>
									${vstatus.index+1}
								</td>
								<td>
									<a href="javascript:void(0);"
						  				 onClick="openDoc('<c:url value="${editionDocumentUrl}" />')">
						  				 <c:out value="${editionDocument.docSubject}" /> </a>
								</td>
								<td>
									<c:out value="${editionDocument.docCreator.fdName}" />
								</td>
								<td>
									${editionDocument.docMainVersion}.${editionDocument.docAuxiVersion}
								</td>
								<td style="text-align:left;padding-left:20px;">
									<kmss:showDate value="${editionDocument.docCreateTime}" type="datetime" />
								</td>
							</tr>
						</c:forEach>
				</table>
			<%}%>
	 
<%@ include file="/resource/jsp/list_down.jsp"%>
