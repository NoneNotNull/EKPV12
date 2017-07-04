<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<style>
.btnmsg{
	padding: 2px 5px 0px 5px;
	border:1px solid #000033;
	cursor:hand;
	width: 80px;
}
</style>
<script type="text/javascript" charset="UTF-8">
Com_IncludeFile("dialog.js");
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
</script>
<html:form action="/km/signature/km_signature_main/kmSignatureMain.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/signature/km_signature_main/kmSignatureMain.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.km.signature.model.KmSignatureCategory','<c:url value="/km/signature/km_signature_main/kmSignatureMain.do" />?method=add&docType=${param.docType}&fdTemplateId=!{id}');">
		</kmss:auth>
		<kmss:auth requestURL="/km/signature/km_signature_main/kmSignatureMain.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmSignatureMainForm, 'deleteall');">
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
				<sunbor:column property="kmSignatureMain.fdMarkName">
					<bean:message bundle="km-signature" key="signature.markname"/>
				</sunbor:column>
				<td width="80pt">
					<bean:message bundle="km-signature" key="signature.fdTemp"/>
				</td>
				<sunbor:column property="kmSignatureMain.fdMarkDate">
					<bean:message bundle="km-signature" key="signature.markdate"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureMain.fdDocType">
					<bean:message bundle="km-signature" key="signature.docType"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmSignatureMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/signature/km_signature_main/kmSignatureMain.do" />?method=view&fdId=${kmSignatureMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmSignatureMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmSignatureMain.fdMarkName}" />
				</td>
				<td>
					<c:out value="${kmSignatureMain.fdTemp.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${kmSignatureMain.fdMarkDate}" />
				</td>
				<td>
					<c:if test="${kmSignatureMain.fdDocType == 1}">
						<bean:message bundle="km-signature" key="signature.fdDocType.handWrite"/>
					</c:if>
					<c:if test="${kmSignatureMain.fdDocType == 2}">
						<bean:message bundle="km-signature" key="signature.fdDocType.companySignature"/>
					</c:if>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>