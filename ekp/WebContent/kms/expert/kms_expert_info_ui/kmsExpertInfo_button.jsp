<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>

<kmss:auth requestURL="/kms/expert/kms_expert_info/kmsExpertInfo.do?method=add" requestMethod="GET">
	<script>
	//添加专家
	function addExpert() {
		seajs.use(['lui/dialog'], function(dialog) {
			dialog
					.simpleCategoryForNewFile(
							'com.landray.kmss.kms.expert.model.KmsExpertType',
							'/kms/expert/kms_expert_info/kmsExpertInfo.do?method=add&fdCategoryId=!{id}',
							false,null,null,'${param.categoryId}');
		});
	}
	</script>
	<ui:button text="${lfn:message('button.add')}" onclick="addExpert()"></ui:button>
</kmss:auth>
<kmss:auth requestURL="/kms/expert/kms_expert_info/kmsExpertInfo.do?method=deleteall" requestMethod="GET">
	<script type="text/javascript">
	//删除专家
	function delExpert(){ 
			var values = [];
			var selected;
			var select = document.getElementsByName("List_Selected");
			for (var i = 0; i < select.length; i++) {
				if (select[i].checked) {
					values.push(select[i].value);
					selected = true;
				}
			}
			if (selected) {
				seajs.use(['lui/dialog', 'lui/topic', 'lui/jquery', 'lui/util/env'],
						function(dialog, topic, $, env) {
							dialog.confirm("${lfn:message('page.comfirmDelete')}", function(flag) {
								if (flag) {
									var loading = dialog.loading();
									$.post(env.fn.formatUrl('/kms/expert/kms_expert_info/kmsExpertInfo.do?method=deleteall'),
											$.param({"List_Selected":values},true), function(data, textStatus,
															xhr) {
														if (data.status) {
															loading.hide();
															dialog.success("${lfn:message('kms-expert:kmsExpert.delete.success')}",
																	'#listview');
															topic.publish('list.refresh');
														} else {
															dialog.failure("${lfn:message('kms-expert:kmsExpert.delete.fail')}",
																	'#listview');
														}
													}, 'json');
								}
							});
						});
			} else {
				seajs.use(['lui/dialog'], function(dialog) {
							dialog.alert("${lfn:message('page.noSelect')}");
						});
			}
	}
	</script>
	<ui:button text="${lfn:message('button.delete') }" onclick="delExpert()"></ui:button>
</kmss:auth>

<kmss:auth requestURL="/kms/expert/kms_expert_info/kmsExpertInfo.do?method=introExpert" requestMethod="GET" >
	<script>
		//取消推荐
		function introduce_cancelIntroduce(){
			var values="";
			var selected;
			var select = document.getElementsByName("List_Selected");
			for(var i=0;i<select.length;i++) {
				if(select[i].checked){
					values+=select[i].value;
					values+=",";
					selected=true;
				}
			}
			if(selected) {
				values = values.substring(0,values.length-1);
				if(selected) {
					seajs.use(['lui/dialog','lui/topic'],function(dialog,topic){
						dialog.confirm("${lfn:message('kms-expert:kmsExpert.intro.cancelAll')}",function(val,dia){
							if(val){
								window.del_load = dialog.loading();
								var xurl = "<c:url value='/kms/expert/kms_expert_info/kmsExpertInfo.do?method=introExpert&type=cancel' />";
								var xdata = {};
								xdata.List_Selected = values;
								LUI.$.post(xurl,xdata,function(json){
									if(window.del_load!=null)
										window.del_load.hide();
									if(json){
										dialog.success("${lfn:message('return.optSuccess')}");
										topic.publish('list.refresh');
									}else{
										dialog.failure("${lfn:message('return.optFailure')}");									
									}
								},'json');
							}
						});
					});
				}
			}else{
				seajs.use(['lui/dialog'],function(dialog){
					dialog.alert("${lfn:message('page.noSelect')}");
				});
			}
		}
	</script>
		<ui:button id="cancelIntroduce"
			text="${ lfn:message('sys-introduce:sysIntroduceMain.cancel.button') }"
			onclick="introduce_cancelIntroduce();" order="4"></ui:button>
</kmss:auth>

<script>
	//向专家提问
	function askToExpert(fdId) {
		window.open('<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=add&fdPosterTypeListId=' + fdId);
	}

	//取消推荐按钮出现与否
 	seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/toolbar'], function($, dialog , topic,toolbar) {
 		LUI.ready(function(){
 			if(LUI('cancelIntroduce')) {
 	 			LUI('cancelIntroduce').setVisible(false);
 	 		}
 		});
 		topic.subscribe('criteria.changed',function(evt){
 			if(LUI('cancelIntroduce')){
 	 			LUI('cancelIntroduce').setVisible(false);
 	 		}
 			for(var i=0;i<evt['criterions'].length;i++){
 				if(evt['criterions'][i].key=="intro"){
 					if(evt['criterions'][i].value[0]=='true'||evt['criterions'][i].value[1]=='true'){
 						if(LUI('cancelIntroduce')) {
 	 						LUI('cancelIntroduce').setVisible(true); 
 	 					}
 					}
 				}
 			}
 		});
 	});
 	var SYS_SEARCH_MODEL_NAME = "com.landray.kmss.kms.expert.model.KmsExpertInfo";
</script>