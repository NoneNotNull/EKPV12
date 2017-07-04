/*压缩类型：标准*/
Com_IncludeFile("jquery.js|calendar.js");
	
	function loadDialogInfo(obj){
		var replyDialogs = obj.replyDialogsInfo;
		var evalId = obj.evalId;
		var evalModelName = obj.evalModelName;
		var currUserId = obj.currUserId;
		$("#reply_dialogs").attr({"evalid":evalId,"eval_model_name":evalModelName});
		var html ="";
		for(var i=replyDialogs.length-1;i>=0;i--){
			var replyId = replyDialogs[i].replyId;
			var replyerId = replyDialogs[i].replyerId;
			var replyerName = replyDialogs[i].replyerName;
			var parentReplyerId = replyDialogs[i].parentReplyerId;
			var parentReplyerName = replyDialogs[i].parentReplyerName;
			var replyContent = replyDialogs[i].replyContent;
			replyContent = replyContent.replace(/\[face/g,'<img src="' + 
					Com_Parameter.ContextPath + 'sys/evaluation/import/resource/images/bq/').replace(/\]/g,'.gif" type="face"></img>');
			
			var replyTime = replyDialogs[i].replyTime;
			html += "<div class='reply_infos' replyid='" + replyId + "'><span class='reply_time_d'>" + replyTime + 
					"</span>";
			if(i==0){
				//当前回复，蓝色背景显示
				html += "<div class='bottom_line bg_color'>";
			}else{
				html += "<div class='bottom_line'>";
			}

			html += "<img class='rtnPerson' src='"+Com_Parameter.ContextPath+"sys/person/sys_person_zone/sysPersonZone.do?" +
					"method=img&fdId=" + replyerId + "'><p class='eval_re_cont'><span class='eval_reply_author'>" + 
					"<a class='com_author' href='"+Com_Parameter.ContextPath+"sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId="+
					replyerId+"' target='_blank'>"+replyerName+"</a>";

			if(parentReplyerId && parentReplyerName)
				html += "<span class='eval_reply_p'>"+reply_lang['sysEvaluation.reply.ct']+"</span>" + 
						"<a class='com_author' href='"+Com_Parameter.ContextPath+"sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId=" +
						parentReplyerId + "' target='_blank'>" + parentReplyerName + "</a>" ;
			
			html += "<span class='replyers_dot'>：</span></span>" + replyContent + "</p><div id='dialog_rep_btn' class='dialog_rep_btn'>" +
					"<div style='float: right;height:23px;'>";
			
			//是否有删除回复权限
			var delReplyRight = parent.$("input[name='delReplyRight']").val();
			if(delReplyRight && delReplyRight  == "true"){
				html += "<a class='dialog_reply_del' onclick='delReply(this)'>"+reply_lang['reply_prompt_delete']+"</a>";
			}
			//权限过滤，当前用户不能回复自己的回复
			if(replyerId != currUserId){
				html += "<a onclick='addReply(this)' class='eval_re_reply'>" +
						reply_lang['sysEvaluation.reply.ct'] + "</a>";
			}
			
			html += "</div></div></div></div>";
			
		}
		$("#reply_dialogs").append(html);
		
		//表情
		$("#reply_dialogs").delegate('.eval_icons','click',function(){
			parent.eval_opt.openBqBox($(this));
		});
		
		//表情选择
		$("#reply_dialogs").delegate('#bqIcon_select','click',function(){
			var iframeId = $(this).attr("lui-eval-iframe-id");
			var iframeObj = $("#"+iframeId);
			parent.eval_opt.selectIcon(this,iframeObj);
		});
		
		//关闭表情框
		$("#reply_dialogs").on("click","#eval_close_bq", function (evt) {
			$(this).parents(".eval_biaoqing").empty();
		});
	}
	function addReply(evt){
		var replyId = $(evt).parents(".reply_infos").attr("replyid");
		var evalId = $(evt).parents("div[id='reply_dialogs']").attr("evalid");
		var  textArea = $(evt).parents("#dialog_rep_btn").find("div[class='reply_expend']");
		if(textArea.length <= 0){
			$(".reply_expend").hide();//隐藏其他回复框
			$(evt).parents("#dialog_rep_btn").append("<div class='reply_expend'><span class='trig'></span><div class='dialog_reply_cont'><iframe name='reply_textarea' id='dia_rep_" + replyId + 
							"' class='reply_textarea' frameborder='0' src='" + Com_Parameter.ContextPath + "sys/evaluation/import/sysEvaluationMain_content_area.jsp?" + 
							"iframeType=dialogReply&iframeId=dia_rep_"+replyId+"'></iframe></div><div class='reply_fix'><div class='eval_btn_submit' id='eBtn_" + replyId + 
							"' class='reply_btn_style'></div><span class='eval_reply_tip'>" + reply_lang['reply_prompt_words_alert1'] + 
							"<font style='font-family: Constantia, Georgia; font-size: 20px;'>140</font>" + 
							reply_lang['reply_prompt_words_alert3']+"</span><span class='eval_icons' data-iframe-uid='dia_rep_" + replyId + 
							"'>" + reply_lang['reply_prompt_icon_smile'] + "</span><div class='eval_biaoqing'></div></div></div>");

			//回复按钮
			seajs.use(['lui/toolbar'],function(tool){
				var _cfg = {
						text: reply_lang['sysEvaluation.reply.ct'],
						id: 'replyBtn_'+replyId,
						click: "replySubmit(this)"
					}; 
				var replyBtn = tool.buildButton(_cfg);
				var t1 = $("#eBtn_" + replyId).html(); 
				t1 = t1.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
				replyBtn.element.attr("data-eval-eid","eval-eid");
				if(t1== ''){
					$("#eBtn_" + replyId).append(replyBtn.element.css({
						width : '70px',
						height: '27px',
						float : 'right',
						margin: '0px 20px'
					}));
				}
				replyBtn.draw();
			});
			
			$(evt).parents("#dialog_rep_btn").find("div[class='reply_expend']").show();
		}else{
			if(textArea.is(":hidden")){
				$(".reply_expend").hide();//隐藏其他回复框
				textArea.show();
			}else{
				textArea.hide();;
			}
		}
	}

	function replySubmit(obj){
		var replyId = $(obj).parents(".reply_infos").attr("replyid");
		var evalId = $(obj).parents("div[id='reply_dialogs']").attr("evalid");
		var evalModelName = $(obj).parents("div[id='reply_dialogs']").attr("eval_model_name");//全文点评或段落点评modelName
		var replyBody = $(obj).parents("div[class='reply_expend']").
							find("iframe[name='reply_textarea']").contents().find("body");
		var replyContent = parent.eval_opt.filterExpress(replyBody);//过滤表情
		replyContent = encodeURIComponent(replyContent);
		seajs.use(['lui/dialog'],
				function(dialog) {
					var loading = dialog.loading();
					$.ajax({
						url : Com_Parameter.ContextPath + "sys/evaluation/sys_evaluation_main/sysEvaluationReply.do",
						data : {"method": "save","fdEvaluationId":evalId,
								'replyContent':replyContent,'evalMark':"1",
								'modelName':evalModelName,'replyId':replyId,
								'mainModelId':parent.eval_opt.modelId,
								'mainModelName':parent.eval_opt.modelName},
						type : 'post',
						cache : false,
						success : function(data) { 
									if(data.replyId){
										parent.eval_opt.getReplyInfo(evalId);//刷新回复记录 
										loading.hide();
										$dialog.hide();
									}
							}
						});
			}
		);
	}
	//回复字数校验
	function checkWordsNum(evt,iframeType,iframeId){
		var replyIframeParent = $("#"+iframeId).parents("div[class='reply_expend']");
		var __repltBtnId  = replyIframeParent.find("div[class='eval_btn_submit']")
								.attr("id").replace("eBtn","replyBtn");
		parent.eval_opt._eval_prompInfo($(evt),true,iframeType,replyIframeParent,LUI(__repltBtnId));
	}
	
	function checkEvalContent(evt){
		parent.eval_opt.checkEvalContent(evt);
	}
	function filterOuterImg(evt){
		parent.eval_opt.filterOuterImg(evt);
	}
	function endWith(proStr,endStr){
		parent.eval_opt.endWith(proStr,endStr);
	}
	function adjustCursor(_this){
		parent.eval_opt.adjustCursor(_this);
	}
	function delImgForIE(evt){
		parent.eval_opt.delImgForIE(evt);
	}
	//删除回复
	function delReply(evt){
		var evalId = $(evt).parents("#reply_dialogs").attr("evalid");//点评id
		var replyId = $(evt).parents(".reply_infos").attr("replyid");//回复id
		var modelName = parent.$("#eval_txt_"+evalId+" .eval_praise_reply").attr("eval-view-modelname");
		seajs.use(['sys/ui/js/dialog'], function(dialog,LUI) {
			dialog.confirm(reply_lang['reply_prompt_del_confirm'],function(value){
				if(value==true){
					$.ajax({
						url : Com_Parameter.ContextPath + "sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=delete",
						type : 'post',
						cache : false,
						data: "fdModelName=" +  parent.eval_opt.modelName 
						   + "&fdModelId=" + parent.eval_opt.modelId //fdModelName和fdModelId是权限校验需要
						   + "&evalModelName=" + modelName
					       + "&replyId=" + replyId
					       +  "&evalId=" + evalId
					       + "&isDelReply=true",
						success : function(data) { 
								parent.eval_opt.getReplyInfo(evalId);//刷新回复记录 
								$dialog.hide();
								dialog.success(reply_lang['reply_prompt_sucess_del']);
							},
						error: function() {
							dialog.failure(reply_lang['reply_prompt_fail_del']);
						}
					});
				}
			});
		});
	}