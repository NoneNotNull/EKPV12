<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	function ShareOpt(){
		this.onload = function(){
			//提交按钮事件初始化
			$("#share_button").click(function(){
				var  S_Valudator = $GetKMSSDefaultValidation(null);
				LUI.$("input[name='goalPersonNames']").each(function(){
					 S_Valudator.addElements(this);
				 });
				 
				if(!S_Valudator.validate()){
					return ;
				}
				var fdIsNotify = $("#fdIsNotify")[0].checked;
				var contentObj = $('iframe[name="fdShareReason"]')[0].contentDocument.body.innerHTML;
				contentObj = filterExpress(contentObj);
				var contentVal = encodeURIComponent($.trim(contentObj));
				var introducTo = $("input[name='goalPersonIds']")[0].value;
				var fdNotifyType = $("input[name='fdNotifyType']")[0].value;
				seajs.use(['lui/dialog'],
						function(dialog) {
							var loading = dialog.loading();
							LUI.$.ajax({
								type : "POST",
								url :  "<c:url value='/kms/common/kms_share/kmsShareMain.do?method=shareToPerson'/>",
								data: {fdShareReason: contentVal,
									   fdIsNotify: fdIsNotify,
									   goalPersonIds: introducTo,
									   fdShareType: fdNotifyType,
									   fdId: '${param.fdModelId}',
									   fdModelName:'${param.fdModelName}'},
								dataType : 'json',
								async: false,
								success : function(data) {
									if (data && data['flag'] === true) {
										var shareCount = parent.$("#share_count_${param.fdModelId}")[0].innerText;
										parent.$("#share_count_${param.fdModelId}").html(parseInt(shareCount)+1);
										loading.hide();
										$dialog.hide();
										dialog.success("${ lfn:message('kms-common:kmsShareMain.shareSuccess') }");	
									}
								},
								error: function() {
									
								}		
							});
						}
				);
			});
		};

		//表情
		$("#share_person_main").delegate('.share_icons','click',function(){
			var bqHtml = $(this).next("div")[0].innerHTML;
			var showBq = true;
			if(bqHtml != ''){
				showBq = false;
			}
			
			var bodyHeight = document.body.clientHeight;
			var setHeight = $(this).offset().top;
			var bottomHegiht = bodyHeight - setHeight;
			
			if(showBq){
				var textId = $(this).attr("data-iframe-uid");//文本框id
				var bqHTML = "<div class='share_bq' style='height:100%'><table style='margin:5px'>"
				var num = 0;
				for(var i=0;i<4;i++){
					bqHTML += "<tr>";
					for(var j=0;j<20;j++){
						bqHTML += '<td class="lui_share_biaoqing" style="padding:0px 0px !important;">' +
								'<a onclick="share_opt.selectIcon(this)"><img src="' + Com_Parameter.ContextPath 
								+'kms/common/resource/img/bq/' + num 
								+ '.gif" style="padding: 4px;"></img></a></td>';
						num++;
					}
					bqHTML += "</tr>";
				}
				if(bottomHegiht < 170){
					$("#share_person_main").find("div[class='share_biaoqing']").css({"position":"absolute","top":"-105px"});
					bqHTML += "</table><div></div></div>";
				}else{
					$("#share_person_main").find("div[class='share_biaoqing']").css({"position":"static","top":"0px"});
					bqHTML += "</table><div class='share_bq_arrow'></div></div>";
				}
				var bqDialog = "<div class='share_biao_qing'><div class='share_bq_close'" +
								"id='share_close_bq'></div>" + bqHTML +"</div>";
				$(this).parent().find("div[class='share_biaoqing']").html(bqDialog);
			}
		});

		window.__range = null;
		this.selectIcon = function(obj){
			var imgSrc = $(obj).children(0).attr("src");//表情路径
			
			var shareCtn = $('iframe[name="fdShareReason"]');
			if(!!window.ActiveXObject || "ActiveXObject" in window)  {//IE浏览器
				if(__range!=null){
					imgSrc += "face";
					__range.execCommand("insertimage",false,imgSrc);

					var iBody = shareCtn[0].contentWindow.document.body;
					//var r = iBody.createTextRange(); 
					//r.collapse(false); 
					//r.select(); 
					checkShareContent($(iBody));
				}else{
					var __innerHtml = shareCtn[0].contentWindow.document.activeElement.innerHTML;
					shareCtn[0].contentWindow.document.activeElement.innerHTML = __innerHtml + '<img src="'+imgSrc+'">';
				}
			}else{//其他浏览器
				imgSrc += "face";
				var ifrmaeBody = shareCtn[0].contentWindow.document;
				ifrmaeBody.execCommand("insertimage",false,imgSrc);
			}
			$(obj).parents(".share_biaoqing").empty();//关闭当前表情框
		}

		//关闭表情框
		$("#share_person_main").on("click","#share_close_bq", function (evt) { 
			$(this).parents(".share_biaoqing").empty();
		});
	}
	//字数校验
	function checkWordsNum(){
		var reasonIframeBody = $('iframe[name="fdShareReason"]')[0].contentDocument.body;
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
		var promptVar = $(".share_prompt");
		if(l<=280){
			promptVar.html("${lfn:message('kms-common:kmsShareMain.moreWords')}" + 
							'<font style="font-family: Constantia, Georgia; font-size: 20px;color:#F19703">' +
							Math.abs(parseInt((280-l) / 2))+"</font>"+"${lfn:message('kms-common:kmsShareMain.word')}");
			promptVar.css({'color':''});
			enabledBtn(true);
		}else{
			promptVar.html("${lfn:message('kms-common:kmsShareMain.exceed.words')}"+'<font style="font-family: Constantia, Georgia; font-size: 20px;">'
							+ Math.abs(parseInt((l-280) / 2)+1)+"</font>"+"${lfn:message('kms-common:kmsShareMain.word')}");
			promptVar.css({'color':'#F19703'});
			enabledBtn(false);
		}
	}
	//button事件处理
	function enabledBtn(enable){
		var buttonVar = $("#share_button");
		if(enable==true){
			buttonVar.removeAttr("disabled");
			buttonVar.removeClass("share_button_disable");
		}else{
			buttonVar.attr("disabled","disabled");
			buttonVar.addClass("share_button_disable");
		}
	};
	
	function checkShareContent(evt){
    	$(evt).find("img").each(function(){
			if(this.src.indexOf(".gifface")>-1 || $(this).attr("type") == "face"){
				var cutedSrc = Com_Parameter.ContextPath + 
								this.src.substring(this.src.indexOf("kms/common"));
				var gifIndex = cutedSrc.indexOf(".gif");
				var lastSlash = cutedSrc.lastIndexOf("/");
				if(gifIndex>-1 && lastSlash>-1){
					var imgName = cutedSrc.substring(lastSlash+1,gifIndex);
					var originImg = $(this)[0].outerHTML;
					
					var imgSrc = cutedSrc.replace("face","");
					$(this).attr("src",imgSrc);
					$(this).attr("type","face");
				}
			}
		});
    };

    function filterExpress(evalCont){
		var imgIndex = evalCont.indexOf("<img");
		var typeIndex = evalCont.indexOf('.gif" type="face"');
		if(imgIndex>-1 && typeIndex>0){
			var imgToNum = evalCont.substring(imgIndex,typeIndex);
			var imgToType = imgToNum.substring(0,imgToNum.lastIndexOf("/")+1);
			var reg=new RegExp(imgToType,"g");
			evalCont = evalCont.replace(reg,"[face").replace(/.gif[^>]+>/g,"]");
		}
		return evalCont;
	}
  	//解决IE8下光标在表情图标后，光标自动跳到最前的问题
    function adjustCursor(evt){
    	var $this = $(evt);
		if (navigator.userAgent.indexOf("MSIE 8.0")>0) {
			var reg =/([.*])'gif">'$/g;
			var iframeCtn = $this[0].innerHTML;
			var endWidthGif = endWith(iframeCtn,'type="face">');
			if(endWidthGif){
				$this[0].innerHTML = iframeCtn+" ";
			}
		}
    }

    function endWith(proStr,endStr){
    	 proStr = proStr.replace(/<p>|<\/p>/ig,"");
		 var d = proStr.length - endStr.length;
		 return (d>=0 && proStr.lastIndexOf(endStr)==d);
	}
	
  //过滤外部img
   function filterOuterImg(evt){
    	var $this = $(evt);
    	$this.find("img[type='face']").each(function(){
			$(this)[0].outerHTML = $(this)[0].outerHTML.replace(/<img/ig,"#!img").replace(">","-!");
		});
    	$this[0].innerText = $this[0].innerText.replace(/\#\!img/ig,"<img").replace(/-\!/g,">");
    	$this[0].innerHTML = $this[0].innerHTML.replace(/&lt;/ig,"<").replace(/&gt;/ig,">");
    }

 	//解决IE8下按Backspace无法删除表情的问题
   function delImgForIE(evt){
   	if (navigator.userAgent.indexOf("MSIE 8.0")>0) {
   		var $this = $(evt);
       	var html = $this[0].innerHTML;
   		var endWidthGif = endWith(html,'type="face">');
   		if(endWidthGif){
   			var childrenNum = $this.children().length;
   			$this.children()[childrenNum-1].outerHTML = "";
   		}
   	}
   }
    
	window.onload = function() {
		$('iframe[name="fdShareReason"]').contents().find("body").bind({
			"keyup":function(e){
				var keyCode = e.keyCode;
				if(keyCode == 8){
					//解决IE8下按Backspace无法删除表情的问题
					delImgForIE(this);
				}
				checkWordsNum();
			},
			"focus mouseup":function(){
				checkWordsNum();
				//解决IE8下光标在表情图标后，光标自动跳到最前的问题
				
				adjustCursor(this);
			},
			// 兼容右键粘贴字数限制
			"input":function(){
				checkShareContent(this);
				checkWordsNum();
			},
			//兼容ie浏览器右键粘贴
			"paste cut":function(){
				var $this = $(this);
				var _this = this;
				setTimeout(function(){
					checkShareContent(this);
					filterOuterImg(_this);
					checkWordsNum();
				},2); 
				
			}
		});
	}
</script>