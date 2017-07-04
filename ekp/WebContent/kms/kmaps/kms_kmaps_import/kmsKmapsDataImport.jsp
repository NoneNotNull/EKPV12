<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<div id="optBarDiv">
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<script>
function submitForm(val){
	if('0'==val){
		if(document.getElementsByName("mapImport")[0].value.length>0){
			document.forms[0].action = document.forms[0].action +"&type="+val ;
			document.forms[0].submit();
			return;
		}
	}else if('1' == val){
		if(document.getElementsByName("docImport")[0].value.length>0){
			document.forms[0].action = document.forms[0].action +"&type="+val ;
			document.forms[0].submit();
			return;
		}
	}
	
	alert("${ lfn:message('kms-kmaps:kmsKmapsMain.source.notnull')}");
}
function exportT(){
	location.href = "<%=request.getContextPath()%>/kms/kmaps/kms_kmaps_import/kmsKmapsDataImport.do?method=exportTemplate" ;
}
function exportD(){
	location.href = "<%=request.getContextPath()%>/kms/kmaps/kms_kmaps_import/kmsKmapsDataImport.do?method=exportDoc" ;
}
</script>
<html:form action="/kms/kmaps/kms_kmaps_import/kmsKmapsDataImport.do?method=startImport" method="post" enctype="multipart/form-data" >
	<center>
<table class="tb_normal" width=95%>				
	<tr>
		<td class="td_normal_title" width=20%>
			${ lfn:message('kms-kmaps:kmsKmapsMain.importTemplate')}:
		</td><td width=40%>
			<span id="_formFilesSpan">
				<input type="file" class="upload" name="mapImport" width=50%>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input class="btnopt" type=button value="${ lfn:message('kms-kmaps:kmsKmapsMain.importTemplate')}" onclick="submitForm('0');">
			</span>
		</td>
		<td class="td_normal_title" width=40%>
			<input type="button" value="${ lfn:message('kms-kmaps:kmsKmapsMain.batch.export')}" onclick="exportT();" > 
		</td>
		
	</tr>
 <!--<tr>
		<td class="td_normal_title" width=20%>
			地图文档导入:
		</td><td width=40%>
			<span id="_formFilesSpan">
				<input type="file" class="upload" name="docImport" width=50%>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input class="btnopt" type=button value="地图文档导入" onclick="submitForm('1');">
			</span>
		</td>
		<td class="td_normal_title" width=40%>
			<input type="button" value="地图文档批量导出" onclick="exportD();"  > 
		</td>
	</tr>    -->
</table>
</center>
</html:form>
<%@ include file="/resource/jsp/view_down.jsp"%>
