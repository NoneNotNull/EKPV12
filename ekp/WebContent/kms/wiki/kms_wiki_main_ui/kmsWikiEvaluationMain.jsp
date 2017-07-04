<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

	<c:import url="/sys/evaluation/import/sysEvaluationMain_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmsWikiMainForm" />
		<c:param name="areaName" value="docContent" />
		<c:param name="showReplyInfo" value="true" />
	</c:import>
	<!-- 段落点评js -->
	<script type="text/javascript">	
		//更新段落内容
		updateDocContent.func = function setInfo(_data){
			var cons = document.createElement('img');
			cons.src =Com_Parameter.ContextPath + "sys/evaluation/import/resource/images/icon_add.png";
			cons.width = '10';
			cons.height = '10';
			cons.setAttribute('contenteditable','false');
			cons.setAttribute('e_id', _data);
			//点评的段落的img
			var editorDiv = funSetSelectTxt(cons);
			bindEvaluationEvent();
			//点评的段落
			var notesAreaName = $("input[name='notesAreaName']").val();//段落点评划圈区域
			var $contentDiv = LUI.$(editorDiv).closest("div[name='rtf_"+notesAreaName+"']");
			var fdCatalogId = $contentDiv.attr('id');
			editorDiv = $contentDiv[0];
			var  urlFlex = "http:\/\/" + location.hostname + ":" + location.port;
			var _docContent = encodeURIComponent(editorDiv.innerHTML.replace(urlFlex,''));
			//更新段落
			if (fdCatalogId) {
				LUI.$
					.post(
					Com_Parameter.ContextPath+'sys/evaluation/sys_evaluation_main/sysEvaluationNotes.do?method=updateContent', {
					docContent: _docContent,
					fdModelId: fdCatalogId,
					fdModelName: 'com.landray.kmss.kms.wiki.model.KmsWikiCatelog',
					fdEvalNoteId: _data
				}, function(data, textStatus, xhr) {
						seajs.use(['lui/dialog','lui/topic'], function(dialog,topic) { 
							//点评成功
							if(data.flag && data.flag == true) {
								//更新点评总次数
								var count = eval_opt._eval_getEvalRecordNumber("add");
								topic.publish("evaluation.submit.success",{"data":{"recordCount": count}});
								topic.channel("eval_listview").publish("list.refresh");
								dialog.success(SysEval_MessageInfo['return.optSuccess']);
							}else{
								dialog.failure(SysEval_MessageInfo['return.optFailure']);
								//删除段落点评记录
								LUI.$.ajax({
									url: Com_Parameter.ContextPath + 'sys/evaluation/sys_evaluation_main/sysEvaluationNotes.do?method=delete',
									type: 'GET',
									dataType: 'json',
									async : false,
									data: "fdId="+_data,
									success: function(data, textStatus, xhr) {
									},
									error: function(xhr, textStatus, errorThrown) {
										
									}
								});
								
							}
						});
				});
			}
		}

		//维基库中删除段落点评中的dom节点和段落信息
		eval_opt.deleteNotesIcon.func = function(iconFdId){
			//移除img-dom和更新段落信息
			var $img = LUI.$('img[e_id="'+ iconFdId +'"]');
			var notesAreaName = $("input[name='notesAreaName']").val();//段落点评划圈区域
			var $contentDiv = $img.closest("div[name='rtf_"+notesAreaName+"']");
			
			//获取删除点评的段落id
			var notesModelId = $contentDiv.attr('id');
			var notesModelName = "com.landray.kmss.kms.wiki.model.KmsWikiCatelog";
			$img.remove();
			var  urlFlex = "http:\/\/" + location.hostname + ":" + location.port;
			//更新段落
			if (notesModelId) {
				LUI.$
					.post(
					Com_Parameter.ContextPath+'sys/evaluation/sys_evaluation_main/sysEvaluationNotes.do?method=updateContent', {
					docContent: $contentDiv[0].innerHTML.replace(urlFlex,''),
					fdModelId: notesModelId,
					fdModelName: notesModelName,
					fdEvalNoteId: iconFdId
				}, function(data, textStatus, xhr) {
				});
			}
		}
		
	</script>