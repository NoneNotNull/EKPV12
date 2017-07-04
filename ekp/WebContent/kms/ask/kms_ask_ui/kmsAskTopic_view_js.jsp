<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
Com_IncludeFile("jquery.js");
var KMS = {};
KMS.kmsResourcePath = '${LUI_ContextPath}/kms/common/resource';
</script>
<script>
// ekpJS
Com_IncludeFile("optbar.js|validator.jsp|validation.jsp|doclist.js|dialog.js|data.js", null, "js");
</script>
<script>
// kmsJS
Com_IncludeFile('kms.js|jquery.form.js|template.js|kms_port.js',"${LUI_ContextPath }/kms/ask/kms_ask_ui/js/","js",true);
</script>
<script>
	var jsonUrl = '${LUI_ContextPath }/kms/ask/kms_ask_ui/jsp/get_json_feed.jsp';
	
	// --增加悬赏开始--
	
	// --增加悬赏之后剩余货币--
	function kmsAsk_validateMoeny(el,fdMoney){
		if(parseInt(el.value) > parseInt(fdMoney)){
			dialog.alert("<bean:message  bundle='kms-ask' key='error.kmsAskTopic.fdScore'/>");
			el.value = "0";
			el.focus();
		} 
		// 显示剩余货币
		$("#span_money").html(parseInt(fdMoney) - parseInt(el.value));
	}
	
	// --关闭增加悬赏div
	function kmsAsk_showAdd_close(){
		$("#div_addMoney").hide();
	}
	
	// --增加悬赏之提交--
	function kmsAsk_addMoney(){ 
		// 增加悬赏货币数量
		var test = document.getElementsByName('fdScoreAdd');
		var fdScoreAdd = $("select[name='fdScoreAdd']").val();
		// 原本剩余货币
		var fdMoney = $("#span_money").html();
		if(fdScoreAdd == null||fdScoreAdd == ""||fdScoreAdd == "0"){
			dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdScoreNum')}");
			$("input[name = 'fdScoreAdd']").focus();
			return false;
		}
		
		// ajax更新货币
		$.ajax({
			url : '<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />',
			data : {
				method : 'addScore',
				fdId : '${param.fdId}',
				fdScoreAdd :	fdScoreAdd
			},
			cache : false,
			error : function(){
				dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdScoreFai')}");
			},
			success : function(data) {
				LUI.$('.lui_ask_word_score').html(data);
				dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdScoreSucc')}");
				$('#div_addMoney').hide();
			}
		});
	}
	
	// --增加悬赏结束--
	
	// --提交回复开始--
	
	// 保存
	function replySubmit(){
		Com_Submit(document.kmsAskPostForm,'save');
	}
	
	// 获取RTF
	function RTF_GetContent(prop) {
		var instance = CKEDITOR.instances[prop];
		if(instance){
			return instance.getData();
		}
		return "";
	}

	// 回复验证
	var replyFlag = false;
	function authentication(){
		if(!replyFlag){
			replyFlag = true;
		    var docContents = RTF_GetContent("docContent");
			if(docContents == null||docContents == ""){
				dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdReContent')}");
				return false;
			}
			replySubmit();
		}
	}
	// --提交回复结束--
	
	// --删除回复开始--
	function delPost(postId){
		var cateId = "${kmsAskTopicForm.fdKmsAskCategoryId}";
		dialog.confirm("<bean:message key='page.comfirmDelete'/>",function(flag){
			if(flag){
				$.ajax({
					url : '<c:url value="/kms/ask/kms_ask_post/kmsAskPost.do?method=delete&fdTopicId=${param.fdId}" />',
					data : {
						method : 'delete',
						fdId : postId,
						categoryId:cateId
					},
					cache : false,
					success : function(data) {
							dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdDelSucc')}");
							getOtherPostsList();
						},
					error : function(){
							dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdDelFal')}");
						}
				});
			}else{
			}
		});
	}
	// --删除回复结束--
	
	// --置为最佳开始--
	
	function bestPost(postId){
		dialog.confirm("${ lfn:message('kms-ask:kmsAskTopic.fdSetBest')}",function(flag){
			if(flag){
				$.ajax({
					url : '<c:url value="/kms/ask/kms_ask_post/kmsAskPost.do?method=best&fdTopicId=${param.fdId}&categoryId=${kmsAskTopicForm.fdKmsAskCategoryId}" />',
					data : {
						fdPostId:postId
					},
					cache : false,
					success : function(data) {
						window.location.reload(); 
					}
				});
			}else{
			}
		});
	}
	// --置为最佳结束--
	
	// --回复赞成开始--
	
	function kmsAsk_agree(fdPostId){ 
		$.ajax({
			url : '<c:url value="/kms/ask/kms_ask_agree/kmsAskAgree.do" />',
			data : {
				method :'save',
				fdPostId : fdPostId
			},
			type : 'post',
			cache : false,
			success : function(data) {
					var num = $('#agree'+fdPostId).html();
					var curNum = parseInt(num) + 1;
					$("#agree"+fdPostId).html(curNum); 
					// 拒绝点击
					$('#agreeClick'+fdPostId)[0].onclick = function(){}
					dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdVoteSuc')}");
					//showAlert("投票成功");
				},
			error : function(){
					dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdVoteFal')}");
					//showAlert('赞成失败！');
				}
		});
	}
	
	// --回复赞成结束--
	
	Com_IncludeFile("post_new.css", "style/"+Com_Parameter.Style+"/answer/");
	
	// 进入个人中心
	function showUserInfo(userId){
		var url = "<c:url value='/sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId=' />" + userId;
		Com_OpenWindow(url);
	}
	
	// 回复评论
	
	// 获取评论列表更新
	function frashCommentListDiv(fdPostId){
		$.ajax({
			url : jsonUrl,
			data : {"s_bean": "kmsAskViewInfoService", "s_method": "getPosterCommentInfo","fdPostIds":fdPostId},
			cache : false,
			success : function(data) { 
				var tmpl = $("#commentInfo-tmp").html();
				if(data.commentArray){
					var html = $.getTemplate(tmpl).render(data);
					$("#record"+fdPostId).html(html);
				}
			}
		});
	}

	// 打开其他回复评论 
	function openSectionOther(tid){
		var sectionDescObj = $("#comment" + tid );
		if (sectionDescObj.css('display') == "none"){
			seajs.use(['lui/toolbar'],function(tool){
				var _cfg = {
					text:"${ lfn:message('kms-ask:kmsAskComment.publish.title')}",
					click:"return submitComment(this,'"+tid+"')"
				}; 
				var _cfgCancel = {
					text:"${ lfn:message('kms-ask:kmsAskComment.cancel')}",
					click:"cancelCommnet('"+tid+"')"
				}
				var button = tool.buildButton(_cfg);
				var buttonC = tool.buildButton(_cfgCancel);
				var t1 = $("#btn1" + tid).html(); 
				if(t1){
					t1 = t1.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
				}
				if(t1== ''){
					button.element.appendTo($("#btn1" + tid));
				}
				var t2 = $("#btn2" + tid).html(); 
				if(t2){
					t2 = t2.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
				}
				if(t2== ''){
					buttonC.element.appendTo($("#btn2" + tid));
				}
				button.draw();
				buttonC.draw(); 
			})
			sectionDescObj.slideDown('slow');
			frashCommentListDiv(tid);//加载评论信息
		}else if(sectionDescObj.css('display') == "block"){
			sectionDescObj.slideUp('slow');
		} 
	}
	
	// 打开最佳答案评论
	function openSectionBest(tid){
		var imgObj = $("#img" + tid )[0]; 
		var imgObjName = imgObj.src.substring(imgObj.src.lastIndexOf('\/') + 1,imgObj.src.length); 
		imgObjName === "ic_cocl.gif"?imgObj.src='${KMSS_Parameter_StylePath}answer/ic_coop.gif':imgObj.src='${KMSS_Parameter_StylePath}answer/ic_cocl.gif';
		openSectionOther(tid);
	}  

	// 检查输入字数
	function checkOverInput(obj,max){
		var docContent = obj.value;
		if(docContent.length > max){
			dialog.alert('<bean:message bundle='kms-ask' key='kmsAskComment.overInput'/>');
			//showAlert('<bean:message bundle='kms-ask' key='kmsAskComment.overInput'/>');
			obj.value = docContent.substring(0,max);
			return false;
		}
	}
	
	// 添加评论
	function submitComment(obj,fdPostId){
		var docContent = document.getElementsByName("docContent" + fdPostId)[0].value; 
		docContent=docContent.replace(/\n/g,'<br />'); 
		docContent = replaceFilter(docContent);//过滤非法对象
		
		if(docContent == ""){	
			dialog.alert("<bean:message bundle='kms-ask' key='kmsAskComment.needInput'/>");
			//showAlert("<bean:message bundle='kms-ask' key='kmsAskComment.needInput'/>"); // 请输入评论内容
			document.getElementsByName("docContent" + fdPostId)[0].focus();
			return false;
		}
		obj.disabled=true;// 防止重复评论
		$.ajax({
			url : '<c:url value="/kms/ask/kms_ask_comment/kmsAskComment.do" />',
			data : {"method": "save","fdPostId":fdPostId,'docContent':docContent},
			type : 'post',
			cache : false,
			error : function(){dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdCommentFal')}");},
			success : function(data) { 
						var numObj = document.getElementById("num" + fdPostId);
						var num = numObj.innerHTML;
						numObj.innerHTML = parseInt(num) + 1;
						clearComment(fdPostId);// 清空文本框
						obj.disabled = false;
						frashCommentListDiv(fdPostId);// 更新评论列表
				}
			});
	}

	//过滤非法对象
	function replaceFilter(docContent){
		docContent = docContent.replace(/<(script|link|iframe|object)[\s|\S]*?<\/\1>/ig,"");// 过滤非法html对象
		docContent = docContent.replace(/<form[^>]*>/ig, "").replace(/<\/form>/ig, "");// 过滤form
		docContent = docContent.replace(
				/<([a-z][^>]*)\son[a-z]+\s*=\s*("[^"]+"|'[^']+'|[^\s]+)([^>]*)>/ig,
				"<$1$3>");// 过滤触发脚本

		docContent = docContent.replace(
				/<([a-z][^>]*)\s(href|src)\s*=\s*("\s*(javascript|vbscript):[^"]+"|'\s*(javascript|vbscript):[^']+'|(javascript|vbscript):[^\s]+)([^>]*)>/ig,
				'<$1 $2=""$7>');// 过滤链接脚本
		docContent = docContent.replace(
				/<([a-z][^>]*)\stype\s*=\s*("hidden"|'hidden'|hidden)([^>]*)>/gi,
				"");// 去除隐藏域
		docContent = docContent.replace(
				/<([b-z][^>]*)\sname\s*=\s*("[^"]+"|'[^']+'|[^\s]+)([^>]*)>/gi,
				"<$1$3>");// 去除表单名称
		docContent = docContent.replace(/<!--[\s\S]*?-->/g, '');// 去除注释
		return docContent;
	}
	
	// 删除评论
	function delComment(fdPostId,kmsAskCommentId){
		dialog.confirm("<bean:message key='page.comfirmDelete'/>",function(flag){
			if(flag){
				$.ajax({
					url : '<c:url value="/kms/ask/kms_ask_comment/kmsAskComment.do" />',
					data : {"method": "delete","fdPostId":fdPostId,'fdCommentId':kmsAskCommentId},
					cache : false,
					error : function(){dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdDelFal')}");},
					success : function(data) { 
								var numObj = document.getElementById("num"+fdPostId);
								var num = numObj.innerHTML;
								numObj.innerHTML = parseInt(num) - 1;
								frashCommentListDiv(fdPostId);// 更新评论列表
						}
					});
			}else{
			}
		});
	}
	
	// 评论取消
	function clearComment(fdPostId){
		document.getElementsByName("docContent"+fdPostId)[0].value = "";
		document.getElementsByName("docContent"+fdPostId)[0].focus();
	}

	function cancelCommnet(fdPostId){
		// 清空内容
		clearComment(fdPostId);
		// 收起评论框
		openSectionOther(fdPostId);
	}

	
	// --补充回复|提问开始--
	// 显示补充回复框
	function showPostAddition(fdId,divId){
		if($('#'+divId).css('display') == 'none'){
			$('#'+divId).slideDown("slow");
			$('#'+divId).focus();
			document.getElementsByName('fdKmsAskPostId')[0].value = fdId;
		}else if($('#'+divId).css('display') == 'block'){
			$('#'+divId).slideUp("slow");;
			document.getElementsByName('fdKmsAskPostId')[0].value = '';
		}
		return true;
	}

	// 验证内容,flag为区分提问|回复标识
	function checkAddition(divId,flag){
		var docContents = RTF_GetContent("docContent");
		if(docContents == null||docContents == ""){
			seajs.use(['lui/dialog'],function(dialog){
				dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdFillContent')}");
			});
			return false;
		}
		submitAddition(divId,flag);
	}

	// 提交后台
	function submitAddition(divId,flag){
		var formObj = document.getElementsByName('kmsAskAdditionForm')[0];
		// 对内容进行过滤
		CKEDITOR.instances['docContent'].element.fire('updateEditorElement');
		document.getElementsByName('docContent')[0].value = RTF_GetContent('docContent');
		$(formObj).ajaxSubmit({
			success : function(){
				// 补充回复
			//	seajs.use(['lui/dialog'],function(dialog){
			//		dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdSubmitSuc')}");
			//	});
				RTF_SetContent('docContent','');
				$('#'+divId).hide();
				if(flag){
					getOtherPostsList();
				}else{
					loadAdditionInfo('additionAsk_div');
				}
				dialog.success("${lfn:message('kms-ask:kmsAskTopic.fdSubmitSuc')}"); 
			},
			error : function(){
				seajs.use(['lui/dialog'],function(dialog){
					dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdReplyFal')}");
				});
			}
		});
	}

	// 删除补充回复|提问，flag区分提问和回复
	function delAddition(fdId,flag){
		var cateId = "${kmsAskTopicForm.fdKmsAskCategoryId}";
		seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
			dialog.confirm("<bean:message key='page.comfirmDelete'/>", function(f,d) {
				if(f){
					if(flag){
						$.ajax({
							url : '<c:url value="/kms/ask/kms_ask_addition/kmsAskAddition.do" />',
							data : {
								method:'delete',
								fdId:fdId,
								categoryId:cateId,
								type:'ask'
							},
							cache : false,
							error : function(){
								dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdDelFal')}");
							},
							success : function(data) { 
								loadAdditionInfo('additionAsk_div');
							}
						});
					}else{
						$.ajax({
							url : '<c:url value="/kms/ask/kms_ask_addition/kmsAskAddition.do" />',
							data : {
								method:'delete',
								fdId:fdId,
								categoryId:cateId,
								type:'post'
							},
							cache : false,
							error : function(){
								dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdDelFal')}");
							},
							success : function(data) { 
								getOtherPostsList();
							}
						});
					}
				}
			});
		});
	}

	// 加载补充问题|回复
	function loadAdditionInfo(divId){
		$.ajax({
			url : jsonUrl,
			data : {"s_bean": "kmsAskViewInfoService", "s_method": "getAdditionAsk","fdId":"${param.fdId}"},
			cache : false,
			success : function(data){
						var tmpl = document.getElementById("kms_addition_ask-tmp").innerHTML;
						var html = $.getTemplate(tmpl).render(data);
						$("#"+divId).html(html);
					}
		});

	}
	
	// --补充回复|提问结束 --
	
	// --加载其他回复列表开始--
	var otherPostsDataSource = null,
	setPageTo = null,	// 设置当前页
	jump = null; // 跳转到某页
	
	function getOtherPostsList(){
		$.ajax({
			url : jsonUrl,
			data : otherPostsDataSource.data,
			cache : false,
			success : function(data) {
				dataTmpl = $("#otherPostsList-tmp").html();//获取列表模板
				pageTmpl = $("#kms-page-tmp").html();//获取分页模板
				$("#otherPostsListDiv").html($.getTemplate(dataTmpl).render(data));
				$("#otherPostsPageDiv").html($.getTemplate(pageTmpl).render(data));
			},
			error:function(data) {
				$("#otherPostsListDiv").html('');
				$("#otherPostsPageDiv").html('');
				}
				
		});
	}
	// --加载其他回复列表结束--
	
	// 按回复时间排序
	function viewOtherPostsByTime(){
		var fdIsOrderByTime = "true";
		$.extend(otherPostsDataSource.data,{fdIsOrderByTime:fdIsOrderByTime,fdIsOrderByAgree:"false"});
		getOtherPostsList();
	}

	// 按赞成数排序
	function viewOtherPostsByAgree(){ 
		var fdIsOrderByAgree = "true";
		$.extend(otherPostsDataSource.data,{fdIsOrderByAgree:fdIsOrderByAgree,fdIsOrderByTime:"false"});
		getOtherPostsList();
	}

	// 页面主要port集合
	var portletSet = {
			
			// 获取当前路径
			'location' : {
				dataSource : {
					url : jsonUrl,
					data : {
						s_bean : 'kmsAskViewInfoService',
						s_method : 'getSPath',
						fdId : '${param.fdId}'
					}
				},
				use : 'kms_current_path-tmp'
			},
			// 加载最佳答案信息
			'bestPost' : {
				dataSource : {
					url : jsonUrl,
					data : {
						s_bean : 'kmsAskViewInfoService',
						s_method : 'getViewBestPost',
						fdTopicId : '${param.fdId}'
					}
				},
				use : 'bestPost-tmp'
			}
	}



	function askHomePage(){
		window.location.href = "<c:url value='/kms/home/kms_home_main/kmsHomeMain.do?method=index&ask=true' />";
	}
	
	$(document).ready(function(){
		//设置全局diglog
		seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
			window.dialog = dialog;
		});
		// JS模板缓存map
		var js_template = {};
		
		// 初始化js模板
		(function() {
			var jsTmplNodes =$('.js_tmpl');
			for (var c = 0, len = jsTmplNodes.length; c < len; c++) {
				var node = jsTmplNodes[c];
				if (node.id) {
					js_template[node.id] = node.innerHTML;
				}
			}
		}());
		
		// 加载补充提问
		loadAdditionInfo('additionAsk_div');

		for ( var k in portletSet ) {
			var portlet = portletSet[k];
			portlet.use = js_template[portlet.use];
			var port = new KMS.Port('#' + k, portlet);
		}
		

		// 其他回复数据源
		otherPostsDataSource = {
				viewDiv : $('#otherPostsListDiv'),
				tmpl : 'otherPostsList-tmp',
				url : jsonUrl,
				data : {
					s_bean : 'kmsAskViewInfoService',
					s_method : 'listOtherPosts',
					fdTopicId : '${param.fdId}',
					pageno : '1'
				}
		};
	
		// 加载其他回复页面
		getOtherPostsList();
	
		// 翻页
		setPageTo = function(pageno, rowsize) {
			$.extend(otherPostsDataSource.data, 
				{ pageno: pageno, rowsize: rowsize}
			);
			getOtherPostsList();
		};
	
		// 跳转
		jump = function() {
			var para = {
				pageno : $("#_page_pageno").val(),
				rowsize : $("#_page_rowsize").val()
			};
			$.extend(otherPostsDataSource.data, para);
			getOtherPostsList();
		};

		// 问题模块事件代理
		(function(){
 
			// 显示补充提问框
			function showAskAddition(divId){
				if($('#'+divId).css('display') == 'none'){
					$('#'+divId).slideDown("slow");
					$('#focusDiv').focus();
				}else if($('#'+divId).css('display') == 'block'){
					$('#'+divId).slideUp("slow");;
				}
				return true;
			}


			// 求助专家
			function help_expert(){
				var val = $("input[name='fdPosterType']").val();
				if(val == 1){
					Dialog_TreeList(true, 'fdPosterTypeListIds', 'fdPosterTypeListNames', ';', 'kmsExpertTypeTreeService&expertTypeId=!{value}', '<bean:message key="dialog.tree.title" bundle="kms-ask"/>', 'kmsExpertByTypeDatabean&expertTypeId=!{value}&type=getExpert',afterPersonSelect);  
				}else if(val == 2){
					Dialog_Tree(true, 'fdPosterTypeListIds', 'fdPosterTypeListNames', ';', 'kmsAskCategoryTreeService&selectId=!{value}', '<bean:message key="dialog.tree.title" bundle="kms-ask"/>', null, afterExpertSelect, null, null, null, '<bean:message key="dialog.tree.title" bundle="kms-ask"/>');
				}
			}

			// 求助专家基础数据源
			var updateExpertDataSource = {
					url : '<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=updateExpertTypeHelp&fdId=${param.fdId}"/>',
					data : {},
					success : function(){
								dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdUpdateSuc')}");
								window.location.reload();
							},
					error : function(){dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdUpdateFal')}");}
			}

			// 选择求助领域专家
			function afterExpertSelect(rtnVal){
				if(rtnVal != null){
					dialog.confirm("${ lfn:message('kms-ask:kmsAskTopic.fdUpdExptSel')}",function(flag){
						if(flag){
							$.ajax({
								url : updateExpertDataSource.url,
								data : $.extend(updateExpertDataSource.data,{"fdPosterTypeListIds":getHashStr(rtnVal,'id'),'fdPosterType':'2'}),
								cache : false,
								success : updateExpertDataSource.success,
								error : updateExpertDataSource.error
							});
						}else{
							updateExpertDataSource.error
						}
					});
				}
			}

			// 选择求助专家个人
			function afterPersonSelect(rtnVal){
				if(rtnVal != null){
					dialog.confirm("${ lfn:message('kms-ask:kmsAskTopic.fdUpdExptSel')}",function(flag){
						if(flag){
							$.ajax({
								url : updateExpertDataSource.url,
								data : $.extend(updateExpertDataSource.data,{"fdPosterTypeListIds":getHashStr(rtnVal,'id'),'fdPosterType':'1'}),
								cache : false,
								success : updateExpertDataSource.success,
								error : updateExpertDataSource.error
							});
						}else{
							updateExpertDataSource.error
						}
					});
				}
			}

			// 组装hash数组中的信息	
			function getHashStr(rtnVal,field){
				var itemList = rtnVal.GetHashMapArray();
				var value = "";
				var str = "";
				for(j=0; j<itemList.length; j++){
					value = itemList[j] == null ? "" : itemList[j][field];
					str = j == 0 ? value : (str + ";" + value);
				}
				return str;
			}

			// 求助专家个人
			function help_expert_person(){
				Dialog_TreeList(true, 'fdPosterTypeListIds', 'fdPosterTypeListNames', ';', 'kmsExpertTypeTreeService&expertTypeId=!{value}', '<bean:message key="dialog.tree.title" bundle="kms-ask"/>', 'kmsExpertByTypeDatabean&expertTypeId=!{value}&type=getExpert',afterPerson);
			}

			// 求助专家领域
			function help_expert_area(){
				Dialog_Tree(true, 'fdPosterTypeListIds', 'fdPosterTypeListNames', ';', 'kmsAskCategoryTreeService&selectId=!{value}', '<bean:message key="dialog.tree.title" bundle="kms-ask"/>', null, afterArea, null, null, null, '<bean:message key="dialog.tree.title" bundle="kms-ask"/>')
			}

			function afterPerson(rtnVal){
				if(rtnVal!=null){
					dialog.confirm("${ lfn:message('kms-ask:kmsAskTopic.fdUpdExptSel')}",function(flag){
						if(flag){
							$.ajax({
								url : updateExpertDataSource.url,
								data : $.extend(updateExpertDataSource.data,{"fdPosterTypeListIds":getHashStr(rtnVal,'id'),'fdPosterType':'1'}),
								cache : false,
								success : function(data) {
											window.location.reload();
										},
								error : updateExpertDataSource.error
							});
						}else{
							document.getElementsByName("fdPosterTypeListNames")[0].value = "";
							document.getElementsByName("fdPosterTypeListIds")[0].value = "";
						}
					});
					
				}
			}

			
			function afterArea(rtnVal){
				if(rtnVal != null){
					dialog.confirm("${ lfn:message('kms-ask:kmsAskTopic.fdUpdAreaSel')}",function(flag){
						if(flag){
							$.ajax({
								url : updateExpertDataSource.url,
								data : $.extend(updateExpertDataSource.data,{"fdPosterTypeListIds":getHashStr(rtnVal,'id'),'fdPosterType':'2'}),
								cache : false,
								success: function(data) {
											window.location.reload();
										},
								error : updateExpertDataSource.error
							});
						}else{
							//清空已选
							document.getElementsByName("fdPosterTypeListNames")[0].value = "";
							document.getElementsByName("fdPosterTypeListIds")[0].value = "";
						}
					});
				}
			}

			function kmsAsk_showAdd(event) {
				
				// ajax获取剩余货币
				$.ajax({
					url: jsonUrl,
					data: {
						"s_bean": "kmsAskViewInfoService",
						"s_method": "getKmsAddScore"
					},
					cache: false,
					success: function(data) {
						seajs.use(['lui/dialog','lang!sys-ui'],function(dialog,lang){
							var _data = {
									config : {
										width : 436,
										lock : true,
										cahce : false,
										title : lang['ui.dialog.operation.title'],
										content : {
											type : "common",
											html : " <table style='margin-left:60px;'><tr><td><bean:message key='kmsAskMoneyAlter.fdMoneyAlter' bundle='kms-ask' />&nbsp;&nbsp;"+
											"<select name='fdScoreAdd' onChange='kmsAsk_validateMoeny(this,"+data["fdMoneyTotal"]+");' style='width:50'>"+
											"<option value='0'>0</option>"+
											"<option value='5'>5</option>"+
											"<option value='10'>10</option>"+
											"<option value='15'>15</option>"+
											"<option value='20'>20</option>"+
											"<option value='30'>30</option>"+
											"<option value='50'>50</option>"+
											"<option value='80'>80</option>"+
											"<option value='100'>100</option>"+
										"</select></td></tr>"+
										"<tr><td>${lfn:message('kms-ask:kmsAskTopic.fdMoneyTotal') }<span id='span_money'>"+data["fdMoneyTotal"]+"</span></td></tr>"+
										"<tr><td></table>",
											iconType : 'dollar',// warn,question,success,failure
											buttons :  [{
														name : lang['ui.dialog.button.ok'],
														value : true,
														focus : true,
														fn : function(value, dialog) {
															var f = kmsAsk_addMoney();
															if(f==null){
																dialog.hide(value);
															}
														}
													}, {
														name : lang['ui.dialog.button.cancel'],
														value : false,
														styleClass:"lui_toolbar_btn_gray",
														fn : function(value, dialog) {
															dialog.hide(value);
														}
													}]
										}
									}
								}
								dialog.build(_data).show();});

						/*
						dialog.confirm(" <table style='margin-left:60px;'><tr><td><bean:message key='kmsAskMoneyAlter.fdMoneyAlter' bundle='kms-ask' />&nbsp;&nbsp;"+
								"<select name='fdScoreAdd' onChange='kmsAsk_validateMoeny(this,"+data["fdMoneyTotal"]+");' style='width:50'>"+
								"<option value='0'>0</option>"+
								"<option value='5'>5</option>"+
								"<option value='10'>10</option>"+
								"<option value='15'>15</option>"+
								"<option value='20'>20</option>"+
								"<option value='30'>30</option>"+
								"<option value='50'>50</option>"+
								"<option value='80'>80</option>"+
								"<option value='100'>100</option>"+
							"</select></td></tr>"+
							"<tr><td>${lfn:message('kms-ask:kmsAskTopic.fdMoneyTotal') }<span id='span_money'>"+data["fdMoneyTotal"]+"</span></td></tr>"+
							"<tr><td></table>"
							,null,null,[{name :'确定',
								value : true,
								fn : function(value, dialog) {
								var f = kmsAsk_addMoney();
									if(f==null){
										dialog.hide(value);
									}
								}}, {
									name : "取消",
									value : false,
									fn : function(value, dialog) {
										dialog.hide(value);
									}
								}]);
							*/
					}
				});
			};

			
			// --删除问题验证--
			function delAskConfirm(){
				dialog.confirm("<bean:message key='page.comfirmDelete'/>",function(flag){
					if(flag){
						Com_OpenWindow('kmsAskTopic.do?method=delete&fdId=${param.fdId}','_self');
					}else{
					}
				});
			}

			// 跳转到推荐,推荐完隐藏按钮
			function kmsAsk_introduce_after(){ 
				var fdTopicId = '${param.fdId}';  
				var urlPrix = "<c:url value='/kms/ask/kms_ask_introduce/kmsAskIntroduce.do?method=add&fdTopicId=${param.fdId}'/>"; 
				var url = urlPrix + "&fdId=" + fdTopicId; 
				Dialog_PopupWindow(Com_Parameter.ContextPath+"resource/jsp/frame.jsp?url=" + encodeURIComponent(url),'500','300',null);
			} 
			
			// --推荐开始--
			function kmsAsk_introduce(){  
				var data = new KMSSData();  
				var url = "kmsAskIntroduceXMLService&fdTopicId=${param.fdId}";
				data.SendToBean(url,function kmsAsk_introduce_rtnData(rtnData){
					if(rtnData.GetHashMapArray().length >= 1){  
				   		var obj = rtnData.GetHashMapArray()[0];
				   		var status = obj["fdIsIntroduce"];
				   		status === "false"?kmsAsk_introduce_after():dialog.alert("${ lfn:message('kms-ask:kmsAskTopic.fdLimitIntro')}"); 		   			
					} 
				})		 
			}
			// --推荐结束--
			
			// --调整分类开始--
			function kmsAsk_editCategory() {
				var fdCateModelName = "com.landray.kmss.kms.ask.model.KmsAskCategory";
				var fdMmodelName = "com.landray.kmss.kms.ask.model.KmsAskTopic";
				var url = '/sys/sc/cateChg.do?method=cateChgEdit&cateModelName='+fdCateModelName+'&modelName='+fdMmodelName+'&categoryId=${kmsAskTopicForm.fdKmsAskCategoryId}&docFkName=fdKmsAskCategory&fdIds=${param.fdId}';
				seajs
						.use(
								[ 'lui/dialog' ],
								function(dialog) {
									dialog
											.iframe(
													url,
													"${ lfn:message('sys-simplecategory:sysSimpleCategory.chg.button') }",
													function() {
													}, {
														"width" : 600,
														"height" : 300
													});
								});
			}

			// --调整分类结束--
			
			// 结束问题
			function closeTopic(){
				dialog.confirm("${ lfn:message('kms-ask:kmsAskTopic.fdEndQuest')}",function(flag){
					if(flag){
						Com_OpenWindow('<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=close&fdId=${param.fdId}','_self');
					}else{
					}
				});
			}

			$('#reply_addition').dblclick(function(){
				$('#reply_addition').slideUp('slow');
			});

			$('#ask_addition').dblclick(function(){
				$('#ask_addition').slideUp('slow');
			});
			
			$('#spanId').click(
					function(event){
						var $target = $(event.target);
						if($target.is('#askAddition')){ // 补充提问
							showAskAddition('ask_addition');
						}else if($target.is('#help_expert')){ // 求助专家
							help_expert();
						}else if($target.is('#help_expert_person')){ // 求助专家个人
							help_expert_person();
						}else if($target.is('#help_expert_area')){ // 求助专家领域
							help_expert_area();
						}else if($target.is('#kmsAsk_showAdd')){ // 增加悬赏
							kmsAsk_showAdd(event);
						}else if($target.is('#setTop')){ // 置顶
							setTop();
						}else if($target.is('#setTopCancel')){ // 取消置顶
							cancelTop();
						}else if($target.is('#deleteTopic')){ // 删除问题
							delAskConfirm();
						}else if($target.is('#objIntroduece')){ // 问题推荐
							kmsAsk_introduce();
						}else if($target.is('#editCategory')){ // 修改分类
							kmsAsk_editCategory();
						}else if($target.is('#endTopic')){ // 结束问题
							closeTopic();
						}
						event.preventDefault();
					});
			}())

			//处理补充提问内容带的图片长度太长的问题
			$(".lui_ask_content").find('img').each(function(i){
				var imgWidth = $(this).width();
				var borderW = $(".lui_ask_content").width();
				if(borderW < imgWidth){
					$(this).css("width","auto");
					$(this).css("height","auto");
					$(this).css("max-width",borderW);
				}
			});
		
	});


	//置顶
	function setTop(){
		seajs.use(['lui/dialog'],function(dialog){
						dialog.iframe("/kms/ask/kms_ask_ui/kmsAskTopic_index_setTop.jsp?docIds=${param.fdId}", 
										"${lfn:message('kms-ask:kmsAskTopic.setTop')}",
										 null, 
										 {	
											width:720,
											height:370,
											buttons:[
														{
															name : "${lfn:message('button.ok')}",
															value : true,
															focus : true,
															fn : function(value,_dialog) {
																commitForm(_dialog);
															}
														}, {
															name : "${lfn:message('button.cancel')}",
															styleClass:"lui_toolbar_btn_gray",
															value : false,
															fn : function(value, _dialog) {
																_dialog.hide();
															}
														} 
													]
										}
						); 
			});
	}

	function commitForm(_dialog){
		var fdSetTopReason = LUI.$('#dialog_iframe').find('iframe')[0].contentDocument.getElementsByName('fdSetTopReason')[0].value;
		if (fdSetTopReason == "") {
			seajs.use(['lui/dialog'],function(dialog){
				dialog.alert("${lfn:message('kms-ask:kmsAskTopic.setTopReason')}");
			});
	 		return false;
	 	}
		var fdSetTopLevel = LUI.$('#dialog_iframe').find('iframe')[0].contentDocument.getElementsByName('fdSetTopLevel');
		for(var i = 0; i < fdSetTopLevel.length; i++){
			if(fdSetTopLevel[i].checked){
				fdSetTopLevel=fdSetTopLevel[i].value;
				break;
			}
		}
	 	fdSetTopReason = encodeURIComponent(fdSetTopReason);
	 	LUI.$.ajax({
                url: '<c:url value="/kms/ask/kms_ask_index/kmsAskTopicIndex.do" />?method=setTop&'+
	 						'docIds=${param.fdId}&fdSetTopLevel='+fdSetTopLevel+'&fdSetTopReason='+fdSetTopReason,
                type: 'post',
                success: function(data){
                	if(data["hasRight"]== true){
	                	var topWinHref =  top.location.href; 
	                	if(topWinHref.indexOf("method=view") < 0){
	                		_dialog.hide();
	                		seajs.use(['lui/dialog'],function(dialog){
	            				dialog.success("${lfn:message('kms-ask:kmsAskTopic.executeSucc')}",
											'#listview');
	            			});
	                		setTimeout(function(){window.location.reload();}, 500);	
	                	}else{
	                		_dialog.hide();
	                		seajs.use(['lui/dialog'],function(dialog){
	                			dialog.success("${lfn:message('kms-ask:kmsAskTopic.executeSucc')}",
											'#listview');
	            			});
	                		setTimeout(function(){window.location.reload();}, 500);	
	                	}
                	}else{
                		setTopFail(_dialog);
                	}
                }
   		 }); 
	}

	function setTopFail(_dialog){
		_dialog.hide();
		seajs.use(['lui/dialog'],function(dialog){
			dialog.alert("${lfn:message('kms-ask:kmsAskTopic.noRight')}");
		});
	}
	
	//取消置顶
	function cancelTop(){
		seajs.use(['lui/dialog', 'lui/topic', 'lui/jquery', 'lui/util/env'],
				function(dialog, topic, $, env) {
					dialog.confirm("${lfn:message('kms-ask:kmsAskTopic.cancelTop')}", function(flag, d) {
						if (flag) {
							var loading = dialog.loading();
							$.post(env.fn.formatUrl('/kms/ask/kms_ask_index/kmsAskTopicIndex.do?method=cancelTop&templateId=${param.categoryId}&docIds=${param.fdId}'),
									null, function(data, textStatus,
													xhr) {
												if (data["hasRight"]== true) {
													loading.hide();
													dialog.success("${lfn:message('kms-ask:kmsAskTopic.executeSucc')}",
															'#listview');
													setTimeout(function(){window.location.reload();}, 500);	
												} else {
													loading.hide();
							                		dialog.alert("${lfn:message('kms-ask:kmsAskTopic.noRight')}");
												}
											}, 'json');
						}
					});
				}
		);
	}
</script>