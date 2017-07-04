<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<script type="text/javascript">
Com_IncludeFile("jquery.js");
</script>
<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/kmtopic/kms_kmtopic_main/style/edit.css" />

<script type="text/javascript">
$(document).ready(function() {
	$(".inputsgl").bind('keydown',function(event){
		var titleContent = document.getElementsByName('catelog_title')[0].value;
		
		//按Enter键直接添加链接，窗口关闭
		if(titleContent!=""&&event.keyCode==13){
			seajs.use(['lui/dialog'],function(dialog){
				$dialog.content.buttonsConfig[0].fn();
			});
		}
	});
});
</script>
<center>
	<div style="padding-top:30px;">
		<table class="tb_simple" id="tb1" width="100%">
			<tr>
				<td class="lui_kmtopic_catelog_title" width="15%">${ lfn:message('kms-kmtopic:kmsKmtopicMain.fill.catelogName') }</td>
				<td width="85%"><input id="catelog_title" value="${param.catelogTitle}" type='text' name='catelog_title' style="width:98%"  class="inputsgl" /></td>
			</tr>
			<tr>
				<td class="lui_kmtopic_catelog_title" width="15%">${ lfn:message('kms-kmtopic:kmsKmtopicMain.fill.catelogInfo') }</td>
				<td style="padding-top: 20px;">
					<textarea name="catelog_desc" id="catelog_desc" style="width: 98%; height: 150px;" class="inputsgl">${param.catelogDesc}</textarea>
				</td>
			</tr>
			
		</table>
	</div>
</center>
