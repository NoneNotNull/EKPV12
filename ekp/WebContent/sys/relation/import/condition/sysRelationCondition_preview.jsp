<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
	<template:replace name="content"> 
		<script type="text/javascript" >
			Com_IncludeFile("jquery.js", null, "js");
			Com_IncludeFile("rela.css", Com_Parameter.ContextPath + "sys/relation/import/resource/","css",true);
		</script>
		<script type="text/javascript">
			var _lang = {
					'number.eq':'<bean:message bundle="sys-relation" key="relation.logic.number.eq" />',
					'number.lt':'<bean:message bundle="sys-relation" key="relation.logic.number.lt" />',
					'number.le':'<bean:message bundle="sys-relation" key="relation.logic.number.le" />',
					'number.gt':'<bean:message bundle="sys-relation" key="relation.logic.number.gt" />',
					'number.ge':'<bean:message bundle="sys-relation" key="relation.logic.number.ge" />',
					'number.bt':'<bean:message bundle="sys-relation" key="relation.logic.number.bt" />',
					'date.eq':'<bean:message bundle="sys-relation" key="relation.logic.date.eq" />',
					'date.lt':'<bean:message bundle="sys-relation" key="relation.logic.date.lt" />',
					'date.le':'<bean:message bundle="sys-relation" key="relation.logic.date.le" />',
					'date.gt':'<bean:message bundle="sys-relation" key="relation.logic.date.gt" />',
					'date.ge':'<bean:message bundle="sys-relation" key="relation.logic.date.ge" />',
					'date.bt':'<bean:message bundle="sys-relation" key="relation.logic.date.bt" />',
					'mid':'<bean:message bundle="sys-relation" key="relation.logic.middleStr" />',
					'right':'<bean:message bundle="sys-relation" key="relation.logic.rightStr"/>'
			};
			function init(setting){
				var argus = setting;
				if(argus==null) return ;
				var tableObj = $("#rela_condition_preview");
				var trLast = tableObj.find("tr:last-child");
				var tmpDiv = $("<div class='rela_preview_result'></div>").append(argus['fdModuleModelTitle']);
				tmpDiv.appendTo(tableObj.find("tr:first-child td:last-child"));
				if(argus.relationConditions!=null && argus.relationConditions!={}){
					for(var tempKey in argus.relationConditions){
						var condition = argus.relationConditions[tempKey];
						var trObj = $("<tr/>");
						var tdObj = $("<td/>").append(condition['fdTitle']);
						tdObj.appendTo(trObj);
						tdObj = $("<td/>");
						var fdType = condition['fdType'];
						var conditionHtml = "<div class='rela_preview_result'></div>"; 
						var summaryhtml = "<span class='rela_preview_sumaray'></span>";
						if(condition['fdVarName'] != null && condition['fdVarName']!=''){
							$(conditionHtml).append('<bean:message bundle="sys-relation" key="relation.word.relationChebox.Tip"/>').appendTo(tdObj);
						}else{
							if(fdType=="foreign"){
								if(condition['fdItemName']=="docKeyword"){
									$(conditionHtml).append(condition['fdParameter2']).appendTo(tdObj);
								}else{
									if(condition['fdParameter1']!=""){
										$(conditionHtml).append(condition['fdParameter2']).appendTo(tdObj);
									}else if(condition['fdBlurSearch']=="1"){
										$(conditionHtml).append(condition['fdParameter2']).appendTo(tdObj);
									}else{
										$(conditionHtml).append(condition['fdParameter3']).appendTo(tdObj);
									}
								}
							}else if(fdType=='date'||fdType=='number'){
								var opt = condition['fdParameter1'];
								var optKey = fdType + '.' + opt;
								if(opt=="bt"){
									$(summaryhtml).append(_lang[optKey]).appendTo(tdObj);
									$(conditionHtml).append(condition['fdParameter2']).appendTo(tdObj);
									$(summaryhtml).append(_lang['mid']).appendTo(tdObj);
									$(conditionHtml).append(condition['fdParameter3']).appendTo(tdObj);
									$(summaryhtml).append(_lang['right']).appendTo(tdObj);
								}else{
									$(summaryhtml).append(_lang[optKey]).appendTo(tdObj);
									$(conditionHtml).append(condition['fdParameter2']).appendTo(tdObj);
								}
							}else if(fdType=="enum"){
								$(conditionHtml).append(condition['fdParameter1Title']).appendTo(tdObj);
							}else{
								$(conditionHtml).append(condition['fdParameter1']).appendTo(tdObj);
							}
						}
						tdObj.appendTo(trObj);
						trLast.before(trObj);
					}
				}
			}
		</script>
		<div class=rela_config_subset>
			<table width=100% class="tb_simple" id="rela_condition_preview">
				<tr>
					<td width="25%"><bean:message bundle="sys-relation" key="sysRelationMain.fdRelationEntries"/>
					</td>
					<td></td>
				</tr>
			</table>
		</div>
	</template:replace>
</template:include>
