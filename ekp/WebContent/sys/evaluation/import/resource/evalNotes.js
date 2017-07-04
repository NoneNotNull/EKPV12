Com_IncludeFile("selectAnchor.js",Com_Parameter.ContextPath+"sys/evaluation/import/resource/","js",true); 
Com_IncludeFile("sysEvaluationMessageInfo.jsp",Com_Parameter.ContextPath+"sys/evaluation/import/","js",true);

	seajs.use(['lui/jquery'],function($) {
		$( function() {	
				//是否有段落点评权限
				var hasNotesRight = $("input[name='hasNotesRight']").val();
				//是否启用段落点评
				var notesEnable = $("input[name='notesEnable']").val();
				if(notesEnable == '1' && hasNotesRight && hasNotesRight  == "true"){
					var shareDiv  = document.getElementById('share_div');
					var notesAreaName = $("input[name='notesAreaName']").val();//段落点评划圈区域
					if(shareDiv)
						selectAnchor(shareDiv, $("div[name='rtf_"+notesAreaName+"']").toArray(),share);
				}
				// 绑定段落点评事件
				bindEvaluationEvent();
			});
	});
	
	//段落点评
	var share = [{
		id: 'sinaShare',
		func: function() {
			var eleTitle = document.getElementsByTagName("title")[0];
			var txt = funGetSelectTxt(),
				title = (eleTitle && eleTitle.innerHTML) ? eleTitle.innerHTML : SysEval_MessageInfo["sysEvaluationNotes.unNamedPage"];
			if (txt) {
				window
					.open('http://v.t.sina.com.cn/share/share.php?title=' + txt + SysEval_MessageInfo["sysEvaluationNotes.fromPage"] + title +
							SysEval_MessageInfo["sysEvaluationNotes.words"]+'&url=' + encodeURIComponent(window.location.href));
			}
		}
	}, {
		id: "evaluationShare",
		func: function() {
			var fdEvalId = '${param.fdId}';
			var _docSubject = funGetSelectTxt();
			funGetSelect();
			if(_docSubject){
				//去掉弹出的点评分享框
				var shareDiv = document.getElementById('share_div');
				if (shareDiv.style.display == "block") {
					shareDiv.style.display = "none";
				}
				evaluationDialog(_docSubject); 
			}
		}
	  }
	];
	
	//绑定提示
	function bindEvaluationEvent() {
		seajs.use(['lui/jquery','sys/evaluation/import/resource/jquery.qtip'],function($, _qtip) {
			_qtip($);
			$('img[e_id]').each(function(index) {
				$(this).qtip({
					content: {
						url: Com_Parameter.ContextPath+"sys/evaluation/sys_evaluation_main/sysEvaluationNotes.do?method=view&e_id="+$(this).attr('e_id')
					},
						show: 'mouseover',
						hide: 'mouseout',
						style: {
							width : {
								min : 300,
								max : 500
							},
							name: 'cream'// Inherit from preset style,
						}
					});
				});
		}); 
	}
	
	//弹出段落点评
	function evaluationDialog(subject) {
			seajs.use( [ 'lui/dialog' ], function(dialog) {
				window.dialogDiv = dialog.build( {
						id : 'evaluationDiv',
						config : {
							width:602,
							lock : true,
							cahce : false,
							title : SysEval_MessageInfo["table.sysEvaluationNotes"],
							content : {
								type : "html",
								html : [
										'<div style="width:600px;height:250px;padding-bottom:10px">',
										'<div class="lui_eval_eva_title">'+SysEval_MessageInfo["sysEvaluationNotes.docSubject"],'</div>',
										'<div class="lui_form_summary_frame lui_eval_eva_object" ><p>',subject,'</p></div>',
										'<div class="lui_eval_eva_title ">'+SysEval_MessageInfo["sysEvaluationNotes.fdEvaluationContent"],'</div>',
										'<div class="lui_eval_eva_content"><textarea onkeyup="checkWordsCount(this)" id="eval_eva_content" style="width:98.5%"></textarea>','</div>',
										'<span class="eval_reply_tip">'+SysEval_MessageInfo["sysEvaluationNotes.alert1"]+'<font style="font-family: Constantia, Georgia; font-size: 20px;">300</font>'+
										SysEval_MessageInfo["sysEvaluationNotes.alert3"]+'</span>','</div><div style="clear:both"></div>'
									   ].join(" "),
							    iconType : "",
							    buttons : [ {
									name : SysEval_MessageInfo["button.ok"],
									value : true,
									focus : true,
									disabled:true,
									fn : function(value,_dialog) {
							    			var confirmBtnId = this.lui_id;
							    			var btnClass = $("#"+confirmBtnId).attr("class");
							    			if(btnClass.indexOf('lui_widget_btn_disabled') <= 0){
							    				var content = LUI.$('#eval_eva_content').val();
							    				confirmEva(subject,content,_dialog);
							    			}
										}
									}
								, {
									name : SysEval_MessageInfo["button.cancel"],
									value : false,
									styleClass: 'lui_toolbar_btn_gray',
									className : 'lui_toolbar_btn_cancel',
									fn : function(value, _dialog) {
										_dialog.hide();
									}
								} ]
							}
						},

						callback : function(value, dialog) {

						},
						actor : {
							type : "default"
						},
						trigger : {
							type : "default"
						}

					}).show();
		});
			dialogDiv.on("layoutDone",function () {
				LUI.$('#eval_eva_content').focus();
			});
	}
	//更新文档内容
	var updateDocContent = {func:function setContent(_data,fdModelId,fdModelName){
		
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
			editorDiv = $contentDiv[0];
			var  urlFlex = "http:\/\/" + location.hostname + ":" + location.port;
			var _docContent = encodeURIComponent(editorDiv.innerHTML.replace(urlFlex,''));
			//更新段落
			if (fdModelId) {
				LUI.$
					.post(
					Com_Parameter.ContextPath+'sys/evaluation/sys_evaluation_main/sysEvaluationNotes.do?method=updateContent', {
					docContent: _docContent,
					fdModelId: fdModelId,
					fdModelName: fdModelName
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
	};
	//段落点评确认
	function confirmEva(_docSubject, _content,_dialog) {
		var fdModelId = $("input[name='notesModelId']").val();
		var fdModelName = $("input[name='notesModelName']").val();
		_dialog.hide();
		document.getElementById('share_div').style.display = 'none';
		var _data;
		//提交段落点评
		LUI.$.ajax({
			url: Com_Parameter.ContextPath + 'sys/evaluation/sys_evaluation_main/sysEvaluationNotes.do?method=saveEvalNotes',
			type: 'POST',
			dataType: 'json',
			async : false,
			data: "docSubject=" +  encodeURIComponent(_docSubject)
			       + "&fdEvaluationContent=" + encodeURIComponent(_content)
			       +  "&fdModelId=" + fdModelId 
			       +  "&fdModelName=" + fdModelName,
			success: function(data, textStatus, xhr) {
					if (data && data['fdId']) {
						_data = data['fdId'];
					}
			},
			error: function(xhr, textStatus, errorThrown) {
				alert(errorThrown);
			}
		});
		if (_data) {
			updateDocContent.func(_data,fdModelId,fdModelName);
		}
	}
	
	//段落点评字数控制
	function checkWordsCount(obj){
		if(!obj)obj= "#eval_eva_content";
		var textArea = $(obj).val();
		var l = 0;
		var tmpArr = textArea.split("");
		for (var i = 0; i < tmpArr.length; i++) {				
			if (tmpArr[i].charCodeAt(0) < 299) {
				l++;
			} else {
				l += 2;
			}
		}
		var promptVar = $(obj).parent()[0].nextSibling.nextSibling;
		var confirmBtnId = $(".lui_dialog_buttons_container").children()[0].id;
		if(l<=600){
			$(promptVar).html(SysEval_MessageInfo["sysEvaluationNotes.alert1"]+'<font style="font-family: Constantia, Georgia; font-size: 20px;">'
							+ Math.abs(parseInt((600-l) / 2))+"</font>"+SysEval_MessageInfo["sysEvaluationNotes.alert3"]);
			$(promptVar).css({'color':''});
			if(l == 0||textArea.trim()==''){
				LUI(confirmBtnId).setDisabled(true);
				return false;
			}else{
				LUI(confirmBtnId).setDisabled(false);
				return true;
			}
		}else{
			$(promptVar).html(SysEval_MessageInfo["sysEvaluationNotes.alert2"]+'<font style="font-family: Constantia, Georgia; font-size: 20px;">'
							+ Math.abs(parseInt((l-600) / 2))+"</font>"+SysEval_MessageInfo["sysEvaluationNotes.alert3"]);
			$(promptVar).css({'color':'red'});
			LUI(confirmBtnId).setDisabled(true);
			return false;
		}
	}
	
	