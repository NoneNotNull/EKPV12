<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">
		Com_IncludeFile("dialog.js|doclist.js");
</script>
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.submit"/>"
		onclick="Com_Submit(document.kmReviewMainForm, 'updateRight');">
	<input type="button" value="<bean:message key="button.close"/>"
	onclick="Com_CloseWindow();"></div>
<p class="txttitle"><bean:message bundle="km-review"
	key="review.title.change.right" /></p>
<center>
<%
try {
%> <html:form action="/km/review/km_review_main/kmReviewMain.do">
	<table class="tb_normal" width=95%>
		<!--流程标签可阅读者-->
		<html:hidden property="fdLableReaderIds" />
<!--	
		<tr>
			<td class="td_normal_title" width=15%><bean:message key="kmReviewPermission.oldFdLableReaders" bundle="km-review"/></td>
			<td colspan=3>
			<%
			out.print(request.getAttribute("oldFdLableReaders"));
			%>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="km-review" key="table.kmReviewMainLabelReader" /></td>
			<td colspan=3><html:hidden property="fdLableReaderIds" /> <html:textarea
				property="fdLableReaderNames" style="width:80%" readonly="true" />
			<a href="#"
				onclick="Dialog_Address(true, 'fdLableReaderIds','fdLableReaderNames', ';',null);"><bean:message
				key="dialog.selectOther" /></a></td>
		</tr>
-->
		<!--可阅读者-->
<!--
		<tr>
			<td class="td_normal_title" width=15%><bean:message key="kmReviewpermission.oldAuthReaders" bundle="km-review"/><br>
			</td>
			<td colspan=3>
			<%
			out.print(request.getAttribute("oldAuthReaders"));
			%>
			</td>
		</tr>
-->
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="km-review" key="table.kmReviewMainReader" /></td>
			<td colspan=3><html:hidden property="authReaderIds" /> <html:textarea
				property="authReaderNames" style="width:80%" readonly="true" /> <a
				href="#"
				onclick="Dialog_Address(true, 'authReaderIds','authReaderNames', ';',null);"><bean:message
				key="dialog.selectOther" /></a></td>
		</tr>
		<!--实施反馈人-->
<!--
			<tr>
				<td class="td_normal_title" width=15%><bean:message key="kmReviewPermission.oldFdFeedback" bundle="km-review"/></td>
				<td colspan=3>
				<%
				out.print(request.getAttribute("oldFdFeedback"));
				%>
				</td>
			</tr>
-->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="table.kmReviewFeedback" /></td>
				<td colspan=3><html:hidden property="fdFeedbackIds" /> <html:textarea
					property="fdFeedbackNames" style="width:80%" readonly="true" />
					<a href="#"
						onclick="Dialog_Address(true, 'fdFeedbackIds','fdFeedbackNames', ';',null);"><bean:message
						key="dialog.selectOther" /></a>
				</td>

			</tr>
	</table>
</html:form> <%
 		} catch (Exception e) {
 		e.printStackTrace();
 	}
 %>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
