<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>

function config_defaultSize(){
	var maxSizeObj=document.getElementsByName("value(kmtopic.att.maxSize)")[0];
	if(maxSizeObj.value=='')
		maxSizeObj.value = '0';
}
config_addOnloadFuncList(config_defaultSize);
</script>
<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" colspan=2><b>${ lfn:message('kms-kmtopic:kmsKmtopicMain.batchDown.config') }</b></td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">${ lfn:message('kms-kmtopic:kmsKmtopicMain.batchDown.maxSize') }</td>
		<td>
			<xform:text property="value(kmtopic.att.maxSize)"  subject="${lfn:message('kms-kmtopic:kmsKmtopicMain.batchDown.maxSize')}" required="false" style="width:150px" showStatus="edit"/><br>
			<span class="message">${ lfn:message('kms-kmtopic:kmsKmtopicMain.batchDown.tip') }&nbsp;&nbsp;&nbsp;</span>
		</td>
	</tr>
	
</table>