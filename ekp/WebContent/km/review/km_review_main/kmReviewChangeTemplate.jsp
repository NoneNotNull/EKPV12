<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">
		Com_IncludeFile("dialog.js");
		function save() {
			var tName = document.getElementsByName("fdTemplateName");
			if(tName[0].value=="") {
				alert("<bean:message key="message.no.template" bundle="km-review"/>");
				return false;
			}
			Com_Submit(document.kmReviewMainForm, 'changeTemplate');
		}
</script>
<html:form action="/km/review/km_review_main/kmReviewMain.do">
	<div id="optBarDiv"><input type=button
		value="<bean:message key="button.save"/>"
		onclick="save();"> <input
		type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>

	<p class="txttitle"><bean:message bundle="km-review"
		key="review.title.trans" /></p>

	<center>
	<table class="tb_normal" width=60%>
		<tr>
			<td class="td_normal_title" width=10%>
			<bean:message key="kmReviewTemplate.fdName" bundle="km-review"/></td>
			<td>
			<html:hidden property="fdTemplateId"/>
			<html:text property="fdTemplateName" style="width:80%;" styleClass="inputsgl" readonly="true"/>
			<span class="txtstrong">*</span>&nbsp;&nbsp;&nbsp;
			<a href="#"
						onclick="Dialog_Template('com.landray.kmss.km.review.model.KmReviewTemplate', 'fdTemplateId::fdTemplateName',false,true, '01');"><bean:message
						key="dialog.selectOther" /></a>
						
			</td>
		</tr>

	</table>
	</center>
	<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
