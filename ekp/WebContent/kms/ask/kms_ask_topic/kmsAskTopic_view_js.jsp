<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<link href="${kmsResourcePath }/favicon.ico" rel="shortcut icon">
<link href="${kmsThemePath }/public.css" rel="stylesheet"
	type="text/css" />
<script type="text/javascript"
	src="<%=request.getContextPath()%>/resource/js/common.js"></script>
<script>
Com_IncludeFile("jquery.js");
</script>
<script>
// ekpJS
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("optbar.js|validator.jsp|validation.jsp|doclist.js|dialog.js|data.js", null, "js");
</script>
<script src="${kmsResourcePath }/js/artdialog/artdialog.js?skin=blue"></script>
<script src="${kmsResourcePath }/js/artdialog/artdialog.iframe.js"></script>
<script>
// kmsJS
Com_IncludeFile('json2.js|jquery.form.js|kms.js',"${kmsResourcePath }/js/lib/","js",true);
Com_IncludeFile('template.js|kms_portlet.js|kms_common.js|kms_utils.js|kms_port.js',"${kmsResourcePath }/js/","js",true);
</script>
<script>
	var jsonUrl = '${kmsResourcePath}/jsp/get_json_feed.jsp';
	
	// --增加悬赏开始--
	
	// --增加悬赏之后剩余货币--
	function kmsAsk_validateMoeny(el){
		var fdMoney = $("#span_money").html(); 
		if(parseInt(el.value) > parseInt(fdMoney)){
			showAlert("<bean:message  bundle='kms-ask' key='error.kmsAskTopic.fdScore'/>");
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
		var fdScoreAdd = $("select[name = 'fdScoreAdd']").val();
		// 原本剩余货币
		var fdMoney = $("#span_money").html();
		if(fdScoreAdd == null||fdScoreAdd == ""||fdScoreAdd == "0"){
			showAlert("请选择悬赏货币数！");
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
				showAlert('增加悬赏失败！');
			},
			success : function(data) {
				$('#span_fdScore').html(data);
				showAlert('增加悬赏成功！');
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
		 var cframeName = prop + "___Frame",frame = window.frames[cframeName];
		 var fck = frame.contentDocument?frame.contentWindow.FCK:frame.FCK;
		 // 更新相关联字段
		 fck.UpdateLinkedField(); 
		 return document.getElementsByName(prop)[0].value;
	}

	// 设置RTF
	function _RTF_SetContent(prop, content) {
		var cframeName = prop + "___Frame";
		var cframe = window.frames[cframeName];
		document.getElementsByName(prop)[0].value = content;
		if(cframe.contentWindow){
			cframe.contentWindow.frames[0].document.body.innerHTML = content;
		}else{
			cframe.frames[0].document.body.innerHTML = content;
		}
	}
	
	// 回复验证
	function authentication(){
	    var docContents = RTF_GetContent("docContent");
		if(docContents == null||docContents == ""){
			showAlert("请填写回复内容！");
			return false;
		}
		replySubmit();
	}
	// --提交回复结束--
	
	// --删除回复开始--
	function delPost(postId){
		showConfirm("<bean:message key='page.comfirmDelete'/>",function(){
			$.ajax({
				url : '<c:url value="/kms/ask/kms_ask_post/kmsAskPost.do?method=delete&fdTopicId=${param.fdId}" />',
				data : {
					method : 'delete',
					fdId : postId	
				},
				cache : false,
				success : function(data) {
						showAlert('删除成功！');
						getOtherPostsList();
					},
				error : function(){
						showAlert('删除失败！');
					}
			});
			},function(){});
	}
	// --删除回复结束--
	
	// --置为最佳开始--
	
	function bestPost(postId){
		showConfirm("确定将本回复置为最佳？",function(){
			$.ajax({
				url : '<c:url value="/kms/ask/kms_ask_post/kmsAskPost.do?method=best&fdTopicId=${param.fdId}" />',
				data : {
					fdPostId:postId
				},
				cache : false,
				success : function(data) {
					window.location.reload(); 
				}
			});
			},function(){});
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
					showAlert("投票成功");
				},
			error : function(){
					showAlert('赞成失败！');
				}
		});
	}
	
	// --回复赞成结束--
	
	Com_IncludeFile("post_new.css", "style/"+Com_Parameter.Style+"/answer/");
	
	// 进入个人中心
	function showUserInfo(userId){
		var url = "<c:url value='/kms/common/kms_person_info/kmsPersonInfo.do?method=index&fdId=' />" + userId;
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
			showAlert('<bean:message bundle='kms-ask' key='kmsAskComment.overInput'/>');
			obj.value = docContent.substring(0,max);
			return false;
		}
	}
	
	// 添加评论
	function submitComment(obj,fdPostId){
		var docContent = document.getElementsByName("docContent" + fdPostId)[0].value; 
		if(docContent == ""){	
			showAlert("<bean:message bundle='kms-ask' key='kmsAskComment.needInput'/>"); // 请输入评论内容
			document.getElementsByName("docContent" + fdPostId)[0].focus();
			return false;
		}
		obj.disabled=true;// 防止重复评论
		$.ajax({
			url : '<c:url value="/kms/ask/kms_ask_comment/kmsAskComment.do" />',
			data : {"method": "save","fdPostId":fdPostId,'docContent':docContent},
			type : 'post',
			cache : false,
			error : function(){showAlert('评论失败！');},
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
	
	// 删除评论
	function delComment(fdPostId,kmsAskCommentId){  
		showConfirm("<bean:message key='page.comfirmDelete'/>",function(){
			$.ajax({
				url : '<c:url value="/kms/ask/kms_ask_comment/kmsAskComment.do" />',
				data : {"method": "delete","fdPostId":fdPostId,'fdCommentId':kmsAskCommentId},
				cache : false,
				error : function(){showAlert('删除评论失败！');},
				success : function(data) { 
							var numObj = document.getElementById("num"+fdPostId);
							var num = numObj.innerHTML;
							numObj.innerHTML = parseInt(num) - 1;
							frashCommentListDiv(fdPostId);// 更新评论列表
					}
				});
			},function(){});
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
			showAlert("请填写内容！");
			return false;
		}
		submitAddition(divId,flag);
	}

	// 提交后台
	function submitAddition(divId,flag){
		var formObj = document.getElementsByName('kmsAskAdditionForm')[0];
		$(formObj).ajaxSubmit({
			success : function(){
				// 补充回复
				showAlert("提交成功！");
				_RTF_SetContent('docContent','');
				$('#'+divId).hide();
				if(flag){
					getOtherPostsList();
				}else{
					loadAdditionInfo('additionAsk_div');
				}
			},
			error : function(){
				showAlert("回复失败！");
			}
		});
	}

	// 删除补充回复|提问，flag区分提问和回复
	function delAddition(fdId,flag){
		showConfirm("<bean:message key='page.comfirmDelete'/>",function(){
			$.ajax({
				url : '<c:url value="/kms/ask/kms_ask_addition/kmsAskAddition.do" />',
				data : {
					method:'delete',
					fdId:fdId	
				},
				cache : false,
				error : function(){
					showAlert('删除失败');
				},
				success : function(data) { 
					if(flag){
						loadAdditionInfo('additionAsk_div');
					}else{
						getOtherPostsList();
					}
				}
			});
			},function(){});
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
			}
		});
	}
	// --加载其他回复列表结束--
	
	// 按回复时间排序
	function viewOtherPostsByTime(){
		var fdIsOrderByTime = "true";
		$.extend(otherPostsDataSource.data,{fdIsOrderByTime:fdIsOrderByTime});
		getOtherPostsList();
	}

	// 页面主要port集合
	var portletSet = {
			// 加载当前用户信息
			'posterInfoDiv' : {
				dataSource : {
					url : jsonUrl,
					data : {
						s_bean : 'kmsAskViewInfoService',
						s_method : 'getMyInfo'
					}
				},
				use : 'myInfo-tmp',
				onRenderComplete : function(){
					// 加载其他未解决问题
					unsolvedQu();
				}
			},
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

	// 加载未解决问题
	function unsolvedQu(){
		$.getJSON(
				jsonUrl, 
				{
					"s_bean" : "kmsAskViewInfoService", 
					"s_method" : "getUnsolvedAsk",
					"fdCategoyrId" : "${kmsAskTopicForm.fdKmsAskCategoryId}",
					"fdId" : "${param.fdId}"
				}, 
				function(json){
					var tmpl = document.getElementById("unsolved-tmp").innerHTML;
					var html = $.getTemplate(tmpl).render(json);
					$("#unsolvedDiv").html(html);
				});
	}


	function askHomePage(){
		window.location.href = "<c:url value='/kms/home/kms_home_main/kmsHomeMain.do?method=index&ask=true' />";
	}
	
	$(document).ready(function(){

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
					Dialog_TreeList(true, 'fdPosterTypeListIds', 'fdPosterTypeListNames', ';', 'kmsExpertTypeTreeService&expertTypeId=!{value}', '<bean:message key="dialog.tree.title" bundle="kms-ask"/>', 'kmsExpertByTypeDatabean&expertTypeId=!{value}',afterPersonSelect);
				}else if(val == 2){
					Dialog_Tree(true, 'fdPosterTypeListIds', 'fdPosterTypeListNames', ';', 'kmsAskCategoryTreeService&selectId=!{value}', '<bean:message key="dialog.tree.title" bundle="kms-ask"/>', null, afterExpertSelect, null, null, null, '<bean:message key="dialog.tree.title" bundle="kms-ask"/>');
				}
			}

			// 求助专家基础数据源
			var updateExpertDataSource = {
					url : '<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=updateExpertTypeHelp&fdId=${param.fdId}"/>',
					data : {},
					success : function(){
								showAlert("修改成功！");
								window.location.reload();
							},
					error : function(){showAlert('修改失败！');}
			}

			// 选择求助领域专家
			function afterExpertSelect(rtnVal){
				if(rtnVal != null){
					if(showConfirm('是否修改确定向专家提问？',function(){
						$.ajax({
							url : updateExpertDataSource.url,
							data : $.extend(updateExpertDataSource.data,{"fdPosterTypeListIds":getHashStr(rtnVal,'id'),'fdPosterType':'2'}),
							cache : false,
							success : updateExpertDataSource.success,
							error : updateExpertDataSource.error
						});
						},function(){
							updateExpertDataSource.error;
							})){
					}
				}
			}

			// 选择求助专家个人
			function afterPersonSelect(rtnVal){
				if(rtnVal != null){
					if(showConfirm('是否修改确定向专家提问？',function(){
						$.ajax({
							url : updateExpertDataSource.url,
							data : $.extend(updateExpertDataSource.data,{"fdPosterTypeListIds":getHashStr(rtnVal,'id'),'fdPosterType':'1'}),
							cache : false,
							success : updateExpertDataSource.success,
							error : updateExpertDataSource.error
						});

						},function(){
							updateExpertDataSource.error
							})){
						
					}
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
				Dialog_TreeList(true, 'fdPosterTypeListIds', 'fdPosterTypeListNames', ';', 'kmsExpertTypeTreeService&expertTypeId=!{value}', '<bean:message key="dialog.tree.title" bundle="kms-ask"/>', 'kmsExpertByTypeDatabean&expertTypeId=!{value}',afterPerson);
			}

			// 求助专家领域
			function help_expert_area(){
				Dialog_Tree(true, 'fdPosterTypeListIds', 'fdPosterTypeListNames', ';', 'kmsAskCategoryTreeService&selectId=!{value}', '<bean:message key="dialog.tree.title" bundle="kms-ask"/>', null, afterArea, null, null, null, '<bean:message key="dialog.tree.title" bundle="kms-ask"/>')
			}

			function afterPerson(rtnVal){
				if(rtnVal!=null){
					showConfirm('是否修改确定向专家提问？',function(){
						$.ajax({
							url : updateExpertDataSource.url,
							data : $.extend(updateExpertDataSource.data,{"fdPosterTypeListIds":getHashStr(rtnVal,'id'),'fdPosterType':'1'}),
							cache : false,
							success : function(data) {
										window.location.reload();
									},
							error : updateExpertDataSource.error
						});
						},function(){});
				}
			}

			function afterArea(rtnVal){
				if(rtnVal != null){
					showConfirm('是否修改确定向专家提问？',function(){
						$.ajax({
							url : updateExpertDataSource.url,
							data : $.extend(updateExpertDataSource.data,{"fdPosterTypeListIds":getHashStr(rtnVal,'id'),'fdPosterType':'2'}),
							cache : false,
							success: function(data) {
										window.location.reload();
									},
							error : updateExpertDataSource.error
						});
						},function(){});
				}
			}

			function kmsAsk_showAdd(event) {
				event = event || window.event;
				// 定位层
				var objA = document.getElementById('div_addMoney');
				// firefox下document.body.scrollTop获取的是0
				objA.style.top = $(window).scrollTop() + event.clientY + 20 + "px";
				objA.style.left = $(window).scrollLeft() + event.clientX - 20 + "px";
				$("#div_addMoney").show();
				// ajax获取剩余货币
				$.ajax({
					url: jsonUrl,
					data: {
						"s_bean": "kmsAskViewInfoService",
						"s_method": "getKmsAddScore"
					},
					cache: false,
					success: function(data) {
						var tmpl = $("#kms-addscore-tmp").html();
						var html = $.getTemplate(tmpl).render(data);
						$("#div_addMoney").html(html);
					}
				});
			};

			// --问题置顶开始--
			function setTop(confirm,opera){
				showConfirm(confirm,function(){
					Com_OpenWindow('<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=askSetTop&operation='+opera+'&fdId=${param.fdId}','_self');
					},function(){});
			}
			// --问题置顶结束--
			
			// --删除问题验证--
			function delAskConfirm(){
				showConfirm("<bean:message key='page.comfirmDelete'/>",function(){
					Com_OpenWindow('kmsAskTopic.do?method=delete&fdId=${param.fdId}','_self');
					},function(){});
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
				   		status === "false"?kmsAsk_introduce_after():showAlert("一周内不能够多次推荐！"); 		   			
					} 
				})		 
			}
			// --推荐结束--
			
			// --调整分类开始--
			function kmsAsk_editCategory(fdTopicId){
				var urlPrix = "<c:url value='/kms/ask/kms_ask_topic/kmsAskTopic.do?method=editCategory'/>"; 
				var url = urlPrix+"&fdId="+fdTopicId; 
				var rtnVal = Dialog_PopupWindow(Com_Parameter.ContextPath+"resource/jsp/frame.jsp?url=" + encodeURIComponent(url),'500','300',null);
			}
			// --调整分类结束--
			
			// 结束问题
			function closeTopic(){
				showConfirm('您是否确定结束问题？',function(){
					Com_OpenWindow('<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=close&fdId=${param.fdId}','_self');
					},function(){});
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
							setTop('您是否确定置顶？','setTop');
						}else if($target.is('#setTopCancel')){ // 取消置顶
							setTop('您是否确定取消置顶？','cancel');
						}else if($target.is('#deleteTopic')){ // 删除问题
							delAskConfirm();
						}else if($target.is('#objIntroduece')){ // 问题推荐
							kmsAsk_introduce();
						}else if($target.is('#editCategory')){ // 修改分类
							kmsAsk_editCategory('${param.fdId}');
						}else if($target.is('#endTopic')){ // 结束问题
							closeTopic();
						}
						event.preventDefault();
					});
			}())
		
	});

</script>