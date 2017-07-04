<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">	
	<script type="text/javascript">	
		seajs.use(['${KMSS_Parameter_ContextPath}sys/edition/import/resource/edition.css']);
	</script>
	<table width="100%"> 
		<tr>
			<td  width="15%">
				<div class="lui_form_subhead">
				<bean:message key="sysEditionMain.showText.currentVersion" bundle="sys-edition" />
				</div>
			</td>
			<td width="85%">
				${param.currentVer}
			</td>
		</tr>
		<tr>
			<td colspan="2"> 
				<list:listview >
					<ui:source type="AjaxJson">
						{"url":"/sys/edition/sys_edition_main/sysEditionMain.do?method=listdata&fdModelName=${param['fdModelName']}&fdModelId=${param['fdModelId']}"}
					</ui:source>
					<list:colTable id="edit_tab" rowHref="!{rowHref}" isDefault="true" layout="sys.ui.listview.listtable" cfg-norecodeLayout="simple">
						<list:col-auto props=""></list:col-auto>
					</list:colTable>
					<ui:event topic="list.loaded">
					   var curVer = '${param.currentVer}';
					   seajs.use(['lui/jquery'],function($){
						   	$("#edit_tab .lui_listview_listtable_td").each(function(){
								var thisObj =  $(this);
								if(thisObj.text()== curVer){
									$(this).parent().addClass("edit_cur_version");
								}
							});
							try {
								if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
									window.frameElement.style.height =  $(document.body).height() + "px";
								}
							} catch(e) {
							}
					   });
					</ui:event>
				</list:listview>
			</td>
		</tr>
	</table>
	</template:replace> 
</template:include>
