<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
	Com_IncludeFile("jquery.js");
</script>
<script>
	$(document).ready(function(){
		$('#attClick').bind('click',attClick);
	
		//设置全局diglog
		seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
			window.dialog = dialog;
		});
	
		// 向专家提问
		<c:if test="${kmsAskTopicForm.fdPosterTypeListIds!=null&&kmsAskTopicForm.fdPosterTypeListIds!=''}">
			$('#posterTr').show();
		</c:if>
	
		// 爱问标题字数限制显示
	(function(maxN) {
		$('textarea[name="docSubject"]').bind('keyup', function(event) {
			var $target = LUI.$(event.target),
				docSubject = $target.val(),
				len = (function(
				s) {
					var l = 0;
					var a = s.split("");
					for (var i = 0; i < a.length; i++) {
						if (a[i].charCodeAt(0) < 299) {
							l++;
						} else {
							l += 2;
						}
					}
					return l;
				})(docSubject);
			var aS = '<a style="font-family: Constantia, Georgia;font-size: 24px;">';
			var aE = '</a>';
			var warn = [aS, 0, aE, '${lfn:message('kms-ask:kmsAskTopic.word')}'];
			if (len == 0) {
				warn[1] = 50;
				warn.unshift("${lfn:message('kms-ask:kmsAskTopic.moreWord')}");
			} else {
				if (len <= maxN) {
					warn[1] = Math.abs(parseInt((maxN - len) / 2));
					warn.unshift("${lfn:message('kms-ask:kmsAskTopic.moreWord')}");
				} else {
					warn[1] = Math.abs(parseInt((maxN - len) / 2)) + 1;
					warn.unshift("${lfn:message('kms-ask:kmsAskTopic.exceed')}");
				}
			}
			LUI.$('.lui_ask_word').html(warn.join(''));
		})
	})(100);
	});

	var jsonUrl = '${kmsResourcePath}/jsp/get_json_feed.jsp';
	//选择爱问分类
	function openExpertWindow(fdIds,fdNames){
	  Dialog_Tree(false, fdIds, fdNames, ';', 'kmsAskCategoryTreeService&selectId=!{value}', '<bean:message key="dialog.tree.title" bundle="kms-ask"/>', null, null, '${param.fdId}', null, null, '<bean:message key="dialog.tree.title" bundle="kms-ask"/>');
	}
	
	function validateScore(el){
		if(parseInt(el.value)>${fdScore}){
			dialog.alert("<bean:message bundle='kms-ask' key='error.kmsAskTopic.fdScore'/>");
			el.value="0";
			el.focus();
		}  
	}


	// 超过最大可提问数自动关闭窗口
	<c:if test="${isPermit eq false}">
		seajs.use("lui/dialog", function(dialog) {
			dialog.alert("<bean:message bundle='kms-ask' key='kmsAskTopic.kmsAsk.isPermit'/>");
		});
		window.opener=null;
		window.open("","_self");
		window.close();
	</c:if>

	// 提交非空校验
	function kmsAsk_Com_Submit(type) {
		var fdCategoryIds = $("input[name = 'fdKmsAskCategoryId']").val();
		if (!fdCategoryIds) {
			dialog.alert("<bean:message bundle='kms-ask' key='kmsAskTopic.fdCategoryIds.null'/>");
			return false;
		}
		var fdPosterType = $("input[name='fdPosterType']:checked").val();
		if (fdPosterType == '1' || fdPosterType == '2') {
			var fdPosterTypeListIds = $("input[name = 'fdPosterTypeListIds']").val();
			if (!fdPosterTypeListIds) {
				dialog.alert('${lfn:message('kms-ask:kmsAskTopic.askExpert')}');
				return false;
			}
		}
		// 标题字数转为前台校验
		var docSubject = $('textarea[name="docSubject"]').val();
		if (docSubject) {
			var len = (function(s) {
				var l = 0;
				var a = s.split("");
				for (var i = 0; i < a.length; i++) {
					if (a[i].charCodeAt(0) < 299) {
						l++;
					} else {
						l += 2;
					}
				}
				return l;
			})(docSubject);
			if (len > 100) {
				dialog.alert("${lfn:message('kms-ask:kmsAskTopic.explain')}");
				return false;
			}
		} else {
			dialog.alert("${lfn:message('kms-ask:kmsAskTopic.notNull')}");
			return false;
		}
		Com_Submit(document.kmsAskTopicForm, type);
		return true;
	};

	// 随可回答者动态创建节点
	function postTypeChange(type) {
		$("input[name = 'fdPosterTypeListNames']").val('');
		$("input[name = 'fdPosterTypeListIds']").val('');
		$("input[name = 'fdIsLimit']").val('1');
		$("input[name = 'fdIsLimit']").attr("checked","true");
		switch (type) {
			case '0':
				return function() {
					$('#posterTr').hide();
					$("input[name = 'fdIsLimit']").val(null);
				}();
				break;
			case '1':
				return function() {
					$('#posterTr').show();
				}();
				break;
			case '2':
				return function() {
					$("input[name = 'fdPosterTypeListNames']").val('${kmsAskTopicForm.fdKmsAskCategoryName}');
					$("input[name = 'fdPosterTypeListIds']").val('${kmsAskTopicForm.fdKmsAskCategoryId}');
					$('#posterTr').show();
				}();
				break;
			case '3':
				return function() {
					$('#posterTr').show();
				}();
				break;
		}
	};

	// 选择专家个人或领域专家
	function openPosterTypeListWindow(){
		var val = $("input[name='fdPosterType']:checked").val()||$("kmsAskTopicForm.fdPostType");
		if(val==1){
			Dialog_TreeList(true, 'fdPosterTypeListIds', 'fdPosterTypeListNames', ';', 'kmsExpertTypeTreeService&expertTypeId=!{value}', '<bean:message key="dialog.tree.title" bundle="kms-ask"/>', 'kmsExpertByTypeDatabean&expertTypeId=!{value}&type=getExpert',null, 'kmsExpertByTypeDatabean&key=!{keyword}&type=search');
		}else if(val==2){
			Dialog_Tree(true, 'fdPosterTypeListIds', 'fdPosterTypeListNames', ';', 'kmsAskCategoryTreeService&selectId=!{value}', '<bean:message key="dialog.tree.title" bundle="kms-ask"/>', null, null, '${param.fdId}', null, null, '<bean:message key="dialog.tree.title" bundle="kms-ask"/>');
		} else if(val==3) {
			Dialog_Address(true, 'fdPosterTypeListIds', 'fdPosterTypeListNames', ';', ORG_TYPE_ALL, null, 
					null, false, false, null, Com_Parameter.CurrentUserId);
		}
	};


	

	/*修改分类*/
	function modifyCate(unClose, isModify) {
		seajs
			.use(
				['lui/dialog'],
				function(dialog) {
					if(isModify) {
						//修改分类，弹出确认框
						dialog.confirm("${lfn:message('kms-ask:kmsAskTopic.confirmCategory')}", 
								function(flag) {
									if(flag)
										dialogForNewAsk();
								}
					    );
					}else dialogForNewAsk();
					
					
					function dialogForNewAsk(){
						dialog
						.simpleCategory(
							'com.landray.kmss.kms.ask.model.KmsAskCategory',
							'fdKmsAskCategoryId',
							'fdKmsAskCategoryName',
							false,
							function(val) {
								if (!unClose && !val)
									window.close();
								if (val && val.id) {
									var url  = window.location.href;
									window
											.open(
													Com_SetUrlParameter(url,"fdCategoryId", val.id),
													'_self');
								}
							}, 
							
							null, true);
					}
					
				});
	}

	// 异步请求分类路径
	function ajaxCategoryPath(fdCategoryId){
		LUI.$.ajax({
			type: "GET",
			url: jsonUrl,
			dataType: "json",
			data: {
				s_bean : 'kmsHomeAskService',
				s_method : 'getCategoryNamePath',	
				fdCategoryId : fdCategoryId
			},
			cache: false,
			success: function(data){
				var arrayPath = new Array();
				var len  = data.length;
				LUI.$.each(data,function(i,n){
					arrayPath[len-i-1] = n;
				});
				var path = arrayPath.join('>>');
				$('input[name="fdKmsAskCategoryId"]').val(
						fdCategoryId);
				$('#fdKmsAskCategoryName').html(
						path);
			},
			error: function(){}
		});
	}

	// 是否求助专家
	function help_expert(){
		$('#help_expert').show();
	};


	// 是否显示标签选择框
	function sys_tag(){
		$('#sys_tag').show();
	}

	// 附件上传显示
	function attClick(){
		if($('#att').css('display')=='none'){
			$('#att').css('display','block');
			$('#attFocus').focus();
		}else if($('#att').css('display')=='block'){
			$('#att').css('display','none');
		}
	}
	
	<c:if test="${askToSelf == true}">
		
		seajs.use(['lui/dialog', 'lui/jquery'], function(dialog, $) {
			function closeAction(value) {
					window.open(
						"<c:url value='/kms/ask/kms_ask_topic/kmsAskTopic.do' />?method=add",
						'_self');
			}
			$(function() {
				dialog.alert("${lfn:message('kms-ask:kmsAsk.cannotask')}", closeAction, null, 
					[{
						name : "${lfn:message('button.ok')}",
						value : true,
						focus : true,
						fn : closeAction
					}
					]
				);}
			);
		});
	</c:if>
	
	//无分类情况下进入新建页面，自动弹框选择类别
	<c:if test="${kmsAskTopicForm.method_GET=='add' && askToSelf != true}">
		$(function() {
				if('${param.fdCategoryId}'==''){
					window.modifyCate(false);
				}
			}	
		);
	</c:if>

	// 问题补充
	function addAsk(){
		if($("#detail-content").is(":hidden")){
			$('#detail-content').slideDown('slow');
			$('#detail_span').html('${lfn:message('kms-ask:kmsAskTopic.slideUp')}');
	    }else{
	    	$("#detail-content").slideUp("slow");
			$('#detail_span').html('${lfn:message('kms-ask:kmsAskTopic.open')}');
	    }
	}
</script>