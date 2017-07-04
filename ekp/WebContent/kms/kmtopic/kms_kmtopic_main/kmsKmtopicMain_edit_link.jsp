<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<script type="text/javascript">
Com_IncludeFile("jquery.js");
</script>
<script type="text/javascript">
			$(document).ready(function() {
				$(".inputsgl").bind('keydown',function(event){
					var urlContent = document.getElementsByName('link_url')[0].value;
					var titleContent = document.getElementsByName('link_title')[0].value;
					//按Tab键直接添加链接，窗口不关闭
					if(urlContent!=""&&titleContent!=""&&event.keyCode==9){
						$dialog.content.buttonsConfig[0].fn();
						parent.editLink(1,$dialog.link);
						document.getElementById("link_title").focus();
					}
					//按Enter键直接添加链接，窗口关闭
					if(urlContent!=""&&titleContent!=""&&event.keyCode==13){
						seajs.use(['lui/dialog'],function(dialog){
							$dialog.content.buttonsConfig[0].fn();
						});
					}
				});
			});
</script>

<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/kmtopic/kms_kmtopic_main/style/edit.css" />
<center>
	<div style="padding-top:30px">
		<table class="tb_simple" width="100%" id="tb1">
			<tr>
				<td class="lui_kmtopic_link_title" width="15%">${ lfn:message('kms-kmtopic:kmsKmtopicMain.linkName') }</td>
				<td width="85%"><input id="link_title" value="${param.linkTitle}" type='text' name='link_title' style="width:98%"  class="inputsgl" /></td>
			</tr>
			<tr>
				<td class="lui_kmtopic_link_title" width="15%">${ lfn:message('kms-kmtopic:kmsKmtopicMain.linkAddress') }</td>
				<td width="85%"><input id="link_url" value="${param.linkUrl}" type='text' name='link_url' style="width:98%"  class="inputsgl" /></td>
			</tr>
			<tr>
				<td></td>
				<td style="text-align: right;padding-right: 3%">${ lfn:message('kms-kmtopic:kmsKmtopicMain.linkTip') }</td>
			</tr>
		</table>
	</div>
</center>
