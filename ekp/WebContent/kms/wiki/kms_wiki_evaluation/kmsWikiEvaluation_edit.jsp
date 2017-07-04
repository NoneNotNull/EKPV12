<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/wiki/kms_wiki_evaluation/kmsWikiEvaluation.do">
<div id="optBarDiv">
	<c:if test="${kmsWikiEvaluationForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Commit_submit(document.kmsWikiEvaluationForm, 'save');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-wiki" key="table.kmsWikiEvaluation"/></p>

<center>


<table class="tb_normal" width=95%>

	<tr>
		<td class="td_normal_title">
			点评对象
		</td>
	</tr>
	<tr>
		<td>
			<input type="hidden" name="docSubject">
		</td>
	</tr>

	<tr>
		<td class="td_normal_title">
			点评内容
		</td>
	</tr>
	<tr>
		<td>
			<xform:textarea property="fdEvaluationContent" style="width:100%;height:80" />
		</td>
	</tr>
	<input type="hidden" name="fdFirstModelId" value="${param.fdFirstId }">
	<input type="hidden" name="fdModelId" value="${param.fdWikiId}">
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>

<script>
	Com_IncludeFile("jquery.js", null, "js");
</script>
<script>
	// 保存点评对象使用
	~~function() {
		if(top.dialogArguments){
			var docSubject = top.dialogArguments['docSubject'];
			$('input[name="docSubject"]').val(docSubject) ;
			$('input[name="docSubject"]').after(docSubject);
		}
	}();
		
	function Commit_submit(doc, type) {
		jQuery.ajax({
			url: Com_Parameter.ContextPath + 'kms/wiki/kms_wiki_evaluation/kmsWikiEvaluation.do?method=save',
			type: 'POST',
			dataType: 'json',
			data: $(document.getElementsByName('kmsWikiEvaluationForm')[0]).serialize(),
			success: function(data, textStatus, xhr) {
				if (data && data['fdId']) {
					top.returnValue = data['fdId'];
					top.close();
				}
			},
			error: function(xhr, textStatus, errorThrown) {
				alert(errorThrown);
			}
		});

	}
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>