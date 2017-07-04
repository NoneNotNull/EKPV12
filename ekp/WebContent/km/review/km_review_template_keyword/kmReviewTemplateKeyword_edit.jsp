<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/km/review/km_review_template_keyword/kmReviewTemplateKeyword.do" onsubmit="return validateKmReviewTemplateKeywordForm(this);">
<div id="optBarDiv">
	<c:if test="${kmReviewTemplateKeywordForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmReviewTemplateKeywordForm, 'update');">
	</c:if>
	<c:if test="${kmReviewTemplateKeywordForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmReviewTemplateKeywordForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmReviewTemplateKeywordForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="km-review" key="table.kmReviewTemplateKeyword"/><bean:message key="button.edit"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-review" key="table.kmReviewTemplate"/>.<bean:message  bundle="km-review" key="kmReviewTemplate.fdId"/>
		</td><td width=35%>
				
			<html:hidden property="fdObjectId"/>
			<logic:present  name="kmReviewTemplateKeywordForm" property="kmReviewTemplate">
				<html:text property="kmReviewTemplate.fdId" readonly="true"  styleClass="inputsgl"/>
			</logic:present>
			<logic:notPresent name="kmReviewTemplateKeywordForm" property="kmReviewTemplate">
				<input type = text name="kmReviewTemplate.fdId" readonly class="inputsgl">
			</logic:notPresent>
			<a href="#" onclick="alert('请修改这段代码');"><bean:message key="dialog.selectOther"/></a>
				
			<span class="txtstrong">*</span>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-review" key="kmReviewTemplateKeyword.fdKeyword"/>
		</td><td width=35%>
			<html:text property="fdKeyword"/>
			<span class="txtstrong">*</span>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="kmReviewTemplateKeywordForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>
