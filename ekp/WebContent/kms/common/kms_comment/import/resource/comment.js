Com_IncludeFile("jquery.js");
function Comment_opt(commentId, countId, modelId, modelName){
	this.commentId = commentId;
	this.countId = countId;
	this.fdModelId = modelId;
	this.fdModelName = modelName;
	this.parent = window; // 部署在iframe里面，校验输入字数的问题
	this.channel = "comment_channel_" + modelId;
	this.addUrl = Com_Parameter.ContextPath + "kms/common/kms_comment_main/kmsCommentMain.do?method=save";
	this.delUrl = Com_Parameter.ContextPath + "kms/common/kms_comment_main/kmsCommentMain.do?method=delete";
	var self = this;
	this.__init__ = function(){
		//回复某个指定回复人时
		$("#" + self.commentId).on('click', '.comment_reply', function(){
			var _$commentator = $(this);
			var _replyId = _$commentator.parents(".comment_record_msg").attr("id");
			
			var __div = $("#" + self.commentId);
			__div.find("input[name='docParentReplyerId']").val(_$commentator.attr("data-commentator-id"));
			__div.find("input[name='fdParentId']").val(_replyId);
			__div.find("input[name='hasParentReply']").val("true");
			__div.find("span.p_reply").html(commentAlert['comment_reply']+ "&nbsp;" +_$commentator.attr("data-commentator-name")+"：");
		});
		//直接评论，即“我也说一句”
		$("#" + self.commentId).on('click', '.i_reply', function(){
			var __div = $("#" + self.commentId);
			__div.find("input[name='docParentReplyerId']").val("");
			__div.find("input[name='fdParentId']").val("");
			__div.find("input[name='hasParentReply']").val("false");
			__div.find(".p_reply").html("");
		});
		// 弹出表情
		$("#" + self.commentId).on('click', '.comment_icons', function(){
			$("#" + self.commentId).find("div[class='comment_biaoqing']").empty();//关闭所有表情框
			var __iframe = $(this).parent().find("iframe[name='comment_textarea']");
			// 自适应宽度
			var doc = document.documentElement || document.body;
			var _bottom = doc.scrollHeight - ($(this).offset().top - doc.scrollTop) - $(this).outerHeight(true);
			var _pageYTop = "margin-top:25px;";
			var _arrowY = "top:-9px;";
			if(_bottom < 180){
				var _height = (180 + 25);
				_pageYTop = "margin-top:"+ (-_height - 9) +"px;";
				_arrowY = "top:" + (_height - (5-1) + 9) + "px;background-position: 0 -9px;";
			}
			var width = __iframe.outerWidth(true);
			width = parseInt((width-10)/32) * 32 ;
			var bqHTML = "<div class='comment_bq'><div style='margin:5px;'>";
			bqHTML += "<ul style='width: "+width+"px;";
			if(width < 512){
				bqHTML += "overflow-y:scroll;";
			}
			bqHTML += "height:180px;'>";
			for(var j=0;j<80;j++){
				bqHTML += '<li class="comment_bq_select"><a class="bq_select"><img src="' + Com_Parameter.ContextPath 
						+'kms/common/resource/img/bq/' + j 
						+ '.gif" style="padding: 4px;"></img></a></li>';
			}
			bqHTML += "</ul>";
			bqHTML += "</div><div class='comment_bq_arrow' style='" + _arrowY + "'></div></div>";			
			var bqDialog = "<div class='comment_biao_qing' style='" + _pageYTop + "'><div class='comment_bq_close'" +
							"id='comment_close_bq'></div>" + bqHTML +"</div>";
			$(this).parent().find("div[class='comment_biaoqing']").html(bqDialog);
			var _ul = $(this).parent().find('ul');
			if(width > _ul[0].clientWidth){
				_ul.css({"width": width + (width - _ul[0].clientWidth)});
			}
			_ul.delegate('.bq_select','click',function(){
				self.selectIcon(this, __iframe);
			});
		});
		$("#" + self.commentId).delegate('.inputText','focus',function(evt){
			$(".kms_comment").each(function(){
				$(this).find('.input_titleBox').show();
				$(this).find('.comment_content').attr("src", "");
				$(this).find('.comment_editDiv').hide();
				
			});
			$(this).parent().hide();
			$("#" + self.commentId).find(".comment_editDiv").show();
			$("#" + self.commentId).find(".comment_content").attr("src",Com_Parameter.ContextPath + "kms/common/kms_comment/import/kmsCommentMain_view_reply.jsp?fdModelId="+modelId+"&iframeId=cifr_" + modelId);
		});		
		//关闭表情框
		$("#" + self.commentId).on("click","#comment_close_bq", function (evt) { 
			$(this).parent().parent().empty();
		});
		// 删除
		$("#" + self.commentId).delegate('.del','click', function(){
			var __delBtn = $(this);
			var fdId = __delBtn.attr("data-comment-id");
			seajs.use(['sys/ui/js/dialog'], function(dialog) {
				// 部署所在的页面为当前页面的子页面，且 z-index 过大，dialog不能正常显示，删除操作受到影响
//				dialog.confirm(commentAlert['comment_del_title'], function(value){
//					if(value==true){
						seajs.use(['lui/dialog','lui/topic'], function(dialog,topic) {
							self.loading = dialog.loading(null,$("#" + self.commentId));
							$.post(self.delUrl, {"fdId": fdId}, function(data){
								if(data && data.success){
									self.loading.hide();
									dialog.success(commentAlert['comment_d_s']);
									$("#" + self.countId).text(self.__getCommentCount(-1));
									self.refreshComment(self.fdModelId,self.fdModelName);
									//topic.channel(self.channel).publish('comment.opt.success', {"data":{"commentCount": self.__getCommentCount(-1)}});
									//topic.channel(self.channel).publish('list.refresh');
								}
							}, 'json');
						});
						__delBtn.hide();
//					}
//				});
			});

		});		
	};
	
	//提交数据
	this.__submitData = function(obj){
		var data = self.__getUploadData();
		var replyContent = $(obj).closest('.comment_editDiv').find("iframe[name='comment_textarea']").contents()[0].activeElement.innerHTML;
		if(!$.trim(replyContent.replace(/&nbsp;/ig,""))){
			return;
		}
		seajs.use(['sys/ui/js/dialog'], function(dialog) {
			self.loading = dialog.loading(null,$("#" + self.commentId));
		});
		
		replyContent = self.filterExpress(replyContent);
		//replyContent = self.__addAtColor(replyContent);
		data.fdCommentContent = encodeURIComponent($.trim(replyContent));
		
		$.post(self.addUrl,data,self.__afterSubmit,'json');
	};
	
	//为@功能添加颜色
	this.__addAtColor = function(replyContent){
		var regx=/@[\u4e00-\u9fa5a-zA-Z0-9_-]{1,30}/g;
		var result =replyContent.match(regx);
		var replaceHTML = replyContent;
		for(var i=0;i<result.length;i++){
			var atText = result[i];
			replaceHTML = replaceHTML.replace(atText,"<a class='com_author' href=''>"+atText+"</a>");
		}
		return replaceHTML;
	}
	
	//获取需要提交的数据
	this.__getUploadData = function(){
		var dataObj = {};
		$("#"+ self.commentId).find(":input").each(function(){
			var domObj = $(this);
			var eName = domObj.attr("name");
			if(!!eName){
				dataObj[eName] = domObj.val();
			}
		});
		return dataObj;
	};
	this.__afterSubmit = function(){
		seajs.use(['lui/dialog','lui/topic'], function(dialog,topic) {
			self.loading.hide();
			dialog.success(commentAlert['comment_r_s']);
			var __comment = $("#" + self.commentId);
			__comment.find("input[name='docParentReplyerId']").val("");
			__comment.find(".p_reply").html("");
			__comment.find(".comment_content").contents()[0].activeElement.innerHTML = "";
			
			$("#" + self.countId).text(self.__getCommentCount(1));
			self.refreshComment(self.fdModelId,self.fdModelName);
			//topic.channel(self.channel).publish('comment.opt.success', {"data":{"commentCount": self.__getCommentCount(1)}});
			//topic.channel(self.channel).publish('list.refresh');
		});
	};
	
	this.__getCommentCount = function(increase){
		var countText = $.trim($("#" + self.countId).text());
		var count = parseInt(countText);
		if(!isNaN(count) && count >= 0){
			count += increase;
		}else{
			count = 0;
		}
		return count;
	};
	
	//对应提交成功后事件处理
	this.refreshCount = function(vt){
		var count = 0;
		if(vt.data && vt.data.commentCount){
			count = vt.data.commentCount;
		}
		$("#" + self.countId).text(count);
	};	
	
	//选中表情时，插入回复框中
    this.selectIcon = function(obj,__iframeObj){
		var imgSrc = $(obj).children(0).attr("src");//表情路径
		imgSrc += "face";
		var textArea = $(obj).closest(".comment_biaoqing").parent().find("iframe[name='comment_textarea']");
		if(navigator.userAgent.indexOf("MSIE")>0 && window.__range__) {//IE浏览器
			__range__.execCommand("insertimage",false,imgSrc);
			var iBody = __iframeObj[0].contentWindow.document.body;
			var r = iBody.createTextRange(); 
			r.collapse(false); 
			r.select(); 
			self.checkCommentContent($(iBody));
		}else{//其他浏览器
			var __ifrDoc = textArea[0].contentWindow.document;
			__ifrDoc.body.focus();
			__ifrDoc.execCommand("insertimage",false,imgSrc);
		}
		__iframeObj.parent().find("div[class='comment_biaoqing']").empty();//关闭当前表情框
	};
	
	// 校验输入的字数
	this.checkWordsNum = function(evt,iframeType,iframeId) {
		/*var shareTxt = $(evt)[0].innerHTML;
		shareTxt = shareTxt.replace(/<img[^>]*src[^>]*>/g,"[face]");
		if(shareTxt.length <= 6){
			//ie下：回删输入的内容时，输入框的字数无法清空的问题
			shareTxt = $.trim(shareTxt.replace(/&nbsp;/ig,""));
			if(!shareTxt){
				$(evt)[0].innerHTML = "";
			}
		}*/
		var reasonIframeBody = $(evt)[0];
		var shareTxt = reasonIframeBody.innerHTML;
		var angleReg = /<[^>]+>|<\/[^>]+>/g;
		shareTxt = shareTxt.replace(/<img[^>]*src[^>]*>/ig,"[face]");//过滤表情
		if(shareTxt.indexOf("[face]")<0){
			shareTxt = reasonIframeBody.innerText;
		}else{
			shareTxt = shareTxt.replace(angleReg,"").replace(/&nbsp;/ig,"");//过滤特殊字符
		}
		
		var l = 0;
		var tmpArr = shareTxt.split("");
		for (var i = 0; i < tmpArr.length; i++) {
			if (tmpArr[i].charCodeAt(0) < 299) {
				l++;
			} else {
				l += 2;
			}
		}
		var replyContent = $("#"+iframeId).parent();
		var __noticeDom = replyContent.find("span[class='comment_notice']");
		var __btnId = "comment_btn_"+ self.fdModelId;
		if (l <= 280) {
			__noticeDom.css({'color':''}).find(".notice_title").html(commentAlert.comment_c_write); 
			__noticeDom.find(".notice_count").html(Math.abs(parseInt((280 - l) / 2)));
			self.parent.LUI(__btnId).setDisabled(false);
		} else {
			__noticeDom.css({'color':'red'}).find(".notice_title").html(commentAlert.comment_many); 
			__noticeDom.find(".notice_count").html(Math.abs(parseInt((l - 280+1) / 2)));
			self.parent.LUI(__btnId).setDisabled(true);
		}
	}; 
    this.checkCommentContent = function(evt){
    	$(evt).find("img").each(function(){
			if(this.src.indexOf(".gifface")>-1 || $(this).attr("type") == "face"){
				var cutedSrc = Com_Parameter.ContextPath + 
								this.src.substring(this.src.lastIndexOf("kms"));
				var gifIndex = cutedSrc.indexOf(".gif");
				var lastSlash = cutedSrc.lastIndexOf("/");
				if(gifIndex>-1 && lastSlash>-1){
					var imgSrc = cutedSrc.replace("face","");
					$(this).attr("src",imgSrc);
					$(this).attr("type","face");
				}
			}
		}); 
    	
    };
    this.filterExpress = function(evalCont) {
    	var imgIndex = evalCont.indexOf("<img");
		var typeIndex = evalCont.indexOf('.gif" type="face"');
		if(imgIndex>-1 && typeIndex>0){
			var imgToNum = evalCont.substring(imgIndex,typeIndex);
			var imgToType = imgToNum.substring(0,imgToNum.lastIndexOf("/")+1);
			var reg=new RegExp(imgToType,"g");
			evalCont = evalCont.replace(reg,"[face").replace(/.gif[^>]+>/g,"]");
		}
		return evalCont;
    };
    //解决IE8下光标在表情图标后，光标自动跳到最前的问题
    this.adjustCursor = function(evt) {
    	var $this = $(evt);
		if (navigator.userAgent.indexOf("MSIE 8.0")>0) {
			var reg =/([.*])'gif">'$/g;
			var iframeCtn = $this[0].innerHTML;
			var endWidthGif = self.endWith(iframeCtn,'type="face">');
			if(endWidthGif){
				$this[0].innerHTML = iframeCtn+" ";
			}
		}
    };
    //过滤外部img
    this.filterOuterImg = function(evt) {
    	var $this = $(evt);
    	$this.find("img[type='face']").each(function(){
			$(this)[0].outerHTML = $(this)[0].outerHTML.replace(/<img/ig,"#!img").replace(">","-!");
		});
    	$this[0].innerText = $this[0].innerText.replace(/\#\!img/ig,"<img").replace(/-\!/g,">");
    	$this[0].innerHTML = $this[0].innerHTML.replace(/&lt;/ig,"<").replace(/&gt;/ig,">");
    };
    
    this.refreshComment = function(fdModelId,fdModelName){
    	$.ajax({
			url : Com_Parameter.ContextPath + "kms/common/kms_comment_main/kmsCommentMain.do",
			data : {"method": "data",
					"fdModelId":fdModelId,
					"fdModelName":fdModelName,
					"orderby":"docCreateTime"},
			type : 'post',
			cache : false,
			success : function(_data) { 
					seajs.use(['lui/view/Template', 'lui/jquery'], function(Template, $){
						html = new Template($('#kms_comment_templ').html()).render({
									data : _data
								}
						);
						//$("#comment_"+fdModelId+" #commentList").append(html);
						$("#comment_"+fdModelId+" #commentList")[0].innerHTML = html;
					});

					//回复按钮
					seajs.use(['lui/toolbar'],function(tool){
						var _cfg = {
								text: "回复",
								id: 'comment_btn_'+fdModelId,
								click: "window['commentL_"+fdModelId+"'].__submitData(this)"
							}; 
						var replyBtn = tool.buildButton(_cfg);
						var t1 = $("#_commentBtn_" + fdModelId)[0].innerHTML; 
						t1 = t1.replace(/(^\s*)|(\s*$)/g, "");
						//replyBtn.element.attr("data-eval-eid","eval-eid");
						if(t1== ''){
							$("#_commentBtn_" + fdModelId).append(replyBtn.element);
						}
						replyBtn.draw();
					});
				}
		});
    }
}
