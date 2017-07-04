<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
	Com_IncludeFile("dialog.js");
</script>
<script type="text/javascript">
	function refreshType(){
		<%-- 暂时取消通知
		var fields = document.getElementsByName("fdOperationType");
		var trArr = document.getElementById("TB_Main").rows;
		if(${param.type == 'tmpdoc'}){
			if(fields[0].checked){
				trArr[3].style.display = "";
			}else{
				trArr[3].style.display = "none";
				_cleareMail();
			}
		}else {
			if(fields[0].checked){
				trArr[2].style.display = "";
			}else{
				trArr[2].style.display = "none";
				_cleareMail();
			}
		}
		--%>
	}
</script>
<kmss:windowTitle subjectKey="sys-right:right.change.title.doc" />
<p class="txttitle"><bean:message
	bundle="sys-right"
	key="right.change.title.doc" /></p>
<html:form
	action="/sys/right/batchChangeRight.do"
	onsubmit="return validateBatchChangeRightForm(this);">
	<div id="optBarDiv"><input
		type=button
		value="<bean:message key="button.save"/>"
		onclick="Com_Submit(document.batchChangeRightForm, 'changeRightBatchUpdate');"> <input
		type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>
	<center>
	<table
		class="tb_normal"
		width=95%
		id="TB_Main">
		<tr>
			<td
				class="td_normal_title"
				width=15%><bean:message
				bundle="sys-right"
				key="right.operation.type" /></td>
			<td><sunbor:enums
				property="fdOperationType"
				enumsType="sys_right_add_or_delete"
				elementType="radio"
				htmlElementProperties="onclick='refreshType();'" /></td>
		</tr>
		<tr>
			<td
				class="td_normal_title"
				width=15%><bean:message
				bundle="sys-right"
				key="right.batch.change.elements" /></td>
			<td><input
				type="hidden"
				name="fdIds"
				value="${param.fdIds }"> <input
				type="hidden"
				name="moduleModelName"
				value="${param.moduleModelName }"><html:hidden property="elementIds" /> <html:textarea
				property="elementNames"
				readonly="true"
				styleClass="inputmgl"
				style="width:80%" /> <a
				href="#"
				onclick="Dialog_Address(true, 'elementIds', 'elementNames', ';', ORG_TYPE_ALL);"> <bean:message key="dialog.selectOrg" /> </a></td>
		</tr>
		<c:if test="${param.type == 'tmpdoc'}">
			<tr>
				<td
					class="td_normal_title"
					width=15%><bean:message
					bundle="sys-right"
					key="right.search.docsubject.keyword" /></td>
				<td><input
					name="fdSubjectKeyword"
					class="inputsgl"
					style="width:80%"></td>
			</tr>
		</c:if>
		<%-- 暂时取消通知
		<tr>
			<td
				class="td_normal_title"
				width=15%><bean:message
				key="right.batchchange.notifyType"
				bundle="sys-right" /></td>
			<td width=85%><kmss:editNotifyType property="fdNotifyType" /></td>
		</tr>
		--%>
	</table>
	</center>
	<html:hidden property="method_GET" />
</html:form>
<script>
function _disabledTodo(){
	var es = document.getElementsByTagName("input");
	for(var i=0;i<es.length;i++){
		if(es[i].type=="checkbox"){
			if(es[i].value=="todo"){
				es[i].disabled="true";
			}
		}
	}	
}
function _cleareMail(){
	var es = document.getElementsByTagName("input");
	for(var i=0;i<es.length;i++){
		if(es[i].type=="checkbox"){
			if(es[i].value=="email"){
				es[i].checked=false;
			}
		}
	}
}
//_disabledTodo();
</script>
<html:javascript
	formName="batchChangeRightForm"
	cdata="false"
	dynamicJavascript="true"
	staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>
