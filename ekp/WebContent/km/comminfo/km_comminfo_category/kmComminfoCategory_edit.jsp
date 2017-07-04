<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<kmss:windowTitle
	subjectKey="km-comminfo:kmComminfoCategory.fdId"
	moduleKey="km-comminfo:module.km.comminfo" />
<script>
	Com_IncludeFile("calendar.js");
	Com_IncludeFile("doclist.js");
	Com_IncludeFile("dialog.js|document.js|jquery.js");
</script>

<script type="text/javascript">

	function check(str){
		var fdName = document.getElementsByName("fdName")[0].value;
		$.ajax({
			url: "${KMSS_Parameter_ContextPath}km/comminfo/km_comminfo_category/kmComminfoCategory.do?method=checkCategory",
			type: 'POST',
			dataType: 'json',
			data: {fdName: fdName},
			success: function(data, textStatus, xhr) {//操作成功
				if(data.result ){
					alert("<bean:message  bundle="km-comminfo" key="kmComminfoCategory.cateDuplicate"/>");
				}
				if(data&&!data.result ){
					Com_Submit(document.kmComminfoCategoryForm, str);
				}
			}
		});
	}

</script>

<html:form action="/km/comminfo/km_comminfo_category/kmComminfoCategory.do" onsubmit="return validateKmComminfoCategoryForm(this);">
<div id="optBarDiv">
	<c:if test="${kmComminfoCategoryForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmComminfoCategoryForm, 'update');">
	</c:if>
	<c:if test="${kmComminfoCategoryForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
				onclick="check('save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="check('saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="km-comminfo" key="table.kmComminfoCategory"/></p>

<center>
<table class="tb_normal" width=95%>
	<html:hidden property="fdId"/>
	
	<tr>
		<%-- 类别名称 --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-comminfo" key="kmComminfoCategory.fdName"/>
		</td>
		<td colspan="3" id="fdName">
			<html:text property="fdName"  styleClass="inputsgl"	style="width:80%;" 
			onkeypress="if(event.keyCode==13){event.keyCode=0;return false;}"/>
			<span class="txtstrong">*</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<font color="red"><span id="mySpan"></span></font>
		</td>
	</tr>
	<tr>
		<!-- 排序号 -->
		<td >
		<bean:message
			bundle="km-comminfo" key="kmComminfoMain.fdOrder" />
		</td>
		<td colspan="3">
			<xform:text property="fdOrder" style="width:20%" required="true"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			key="model.tempEditorName" /></td>
		<td colspan="3">
			<html:hidden  property="authEditorIds"/>
			<html:textarea property="authEditorNames" style="width:80%" rows="4" readonly="true" styleClass="inputmul"/>
			<a href="#" onclick="Dialog_Address(true, 'authEditorIds', 'authEditorNames', ';', null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			<div class="description_txt">
			<bean:message	bundle="km-comminfo" key="kmComminfoMain.mainDocEditor" />
			</div>
		</td>
	</tr>
		<%-- 提交者 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-comminfo" key="kmComminfoCategory.docCreatorId"/>
		</td>
		<td width=35%>
			<html:hidden property="docCreatorId" /> 
			<c:out value="${kmComminfoCategoryForm.docCreatorName}" />
		</td>
		<%-- 提交时间 --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-comminfo" key="kmComminfoCategory.docCreateTime"/>
		</td>
		<td width=35%>
			<c:out value="${kmComminfoCategoryForm.docCreateTime}" />
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="kmComminfoCategoryForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>