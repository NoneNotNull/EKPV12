<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link href="${kmsResourcePath }/favicon.ico" rel="shortcut icon">
<!--<script type="text/javascript"
	src="<%=request.getContextPath()%>/resource/js/common.js"></script>
-->
<!--<link href="${kmsThemePath }/public.css" rel="stylesheet"
	type="text/css" />
-->

<script type="text/javascript"
	src="<%=request.getContextPath()%>/kms/common/resource/js/lib/jquery.js"></script>
<script>
// ekpJS
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("docutil.js|optbar.js|validator.jsp|validation.jsp|doclist.js|dialog.js|data.js", null, "js");
</script>
<script src="${kmsResourcePath }/js/artdialog/artdialog.js?skin=blue"></script>
<script src="${kmsResourcePath }/js/artdialog/artdialog.iframe.js"></script>
<script>
// kmsJS
Com_IncludeFile('json2.js|jquery.form.js|kms.js',"${kmsResourcePath }/js/lib/","js",true);
Com_IncludeFile('template.js|kms_portlet.js|kms_common.js|kms_utils.js',"${kmsResourcePath }/js/","js",true);
</script>

<script src="${kmsResourcePath }/js/kms_opera.js"></script>
<script src="${kmsResourcePath }/js/kms_navi_selector.js"></script>

<script>
	var jsonUrl = '${kmsResourcePath}/jsp/get_json_feed.jsp';
	//选择爱问分类
	function openExpertWindow(fdIds,fdNames){
	  Dialog_Tree(false, fdIds, fdNames, ';', 'kmsAskCategoryTreeService&selectId=!{value}', '<bean:message key="dialog.tree.title" bundle="kms-ask"/>', null, null, '${param.fdId}', null, null, '<bean:message key="dialog.tree.title" bundle="kms-ask"/>');
	}
	
	function validateScore(el){
		if(parseInt(el.value)>${fdScore}){
			showAlert("<bean:message bundle='kms-ask' key='error.kmsAskTopic.fdScore'/>");
			el.value="0";
			el.focus();
		}  
	}


	// 超过最大可提问数自动关闭窗口
	<c:if test="${isPermit eq false}">
		showAlert("<bean:message bundle='kms-ask' key='kmsAskTopic.kmsAsk.isPermit'/>");
		window.opener=null;
		window.open("","_self");
		window.close();
	</c:if>

	// 提交非空校验
	function kmsAsk_Com_Submit(type) {
		var fdCategoryIds = $("input[name = 'fdKmsAskCategoryId']").val();
		if (!fdCategoryIds) {
			showAlert("<bean:message bundle='kms-ask' key='kmsAskTopic.fdCategoryIds.null'/>");
			return false;
		}
		var fdPosterType = $("input[name='fdPosterType']:checked").val();
		if (fdPosterType == '1' || fdPosterType == '2') {
			var fdPosterTypeListIds = $("input[name = 'fdPosterTypeListIds']").val();
			if (!fdPosterTypeListIds) {
				showAlert('请选择求助专家');
				return false;
			}
		}
		// 标题字数转为前台校验
		var docSubject = $('textarea[name="docSubject"]').val();
		if (docSubject) {
			var len = (function(
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
			if (len > 100) {
				showAlert('问题标题过长，请保持在50字以内！');
				return false;
			}
		} else {
			showAlert('问题标题不能为空！');
			return false;
		}
		Com_Submit(document.kmsAskTopicForm, type);
		return true;
	};

	// 随可回答者动态创建节点
	function postTypeChange(type) {
		$("input[name = 'fdPosterTypeListNames']").val('');
		$("input[name = 'fdPosterTypeListIds']").val('');
		switch (type) {
			case '0':
				return function() {
					$('#posterTr').hide();
				}();
			case '1':
				return function() {
					$('#posterTr').show();
				}();
			case '2':
				return function() {
					$('#posterTr').show();
				}();
		}
	};

	// 选择专家个人或领域专家
	function openPosterTypeListWindow(){
		var val = $("input[name='fdPosterType']:checked").val()||$("kmsAskTopicForm.fdPostType");
		if(val==1){
			Dialog_TreeList(true, 'fdPosterTypeListIds', 'fdPosterTypeListNames', ';', 'kmsExpertTypeTreeService&expertTypeId=!{value}', '<bean:message key="dialog.tree.title" bundle="kms-ask"/>', 'kmsExpertByTypeDatabean&expertTypeId=!{value}');
		}else if(val==2){
			Dialog_Tree(true, 'fdPosterTypeListIds', 'fdPosterTypeListNames', ';', 'kmsAskCategoryTreeService&selectId=!{value}', '<bean:message key="dialog.tree.title" bundle="kms-ask"/>', null, null, '${param.fdId}', null, null, '<bean:message key="dialog.tree.title" bundle="kms-ask"/>');
		}
	};
	

	$(document).ready(function(){
		$('#attClick').bind('click',attClick);

		// 向专家提问
		<c:if test="${kmsAskTopicForm.fdPosterTypeListIds!=null&&kmsAskTopicForm.fdPosterTypeListIds!=''}">
			$('#posterTr').show();
		</c:if>
		
		var expandOptions = {
			s_modelName:'com.landray.kmss.kms.ask.model.KmsAskCategory',
			s_bean : 'kmsHomeAskService',
			s_method : 'getCategoryList',
			yesFn : function(naviSelector){
				var selectedCache = naviSelector.selectedCache;
				// 未选择分类~
				if (selectedCache.length == 0) {
					art.artDialog.alert("请选择分类！");
					return;
				}
				if(selectedCache.last()._data["isShowCheckBox"]=="0"){
					art.artDialog.alert("您没有当前目录使用权限！");
					return;
				}
				var fdCategoryId = selectedCache.last()._data["value"];
				ajaxCategoryPath(fdCategoryId);
			}
		};
		var selectCate = new KMS.opera(expandOptions, $('#selectAreaNames'));
		selectCate.bind_expand();

		var fdSelectCategoryId = '${param.fdCategoryId}'||'${kmsAskTopicForm.fdKmsAskCategoryId}';
		if(fdSelectCategoryId){
			ajaxCategoryPath(fdSelectCategoryId);
		}

		// 问题补充
		$('#detail_href').toggle(function(){
			$('#detail-content').slideDown('slow');
			$('#detail_span').html('展开');
			},function(){
				$("#detail-content").slideUp("slow");
				$('#detail_span').html('收起');
			});
		// 爱问标题字数限制显示
	(function(maxN) {
		$('textarea[name="docSubject"]').bind('keyup', function(event) {
			var $target = $(event.target),
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
			var warn = [aS, 0, aE, '字'];
			if (len == 0) {
				warn[1] = 50;
				warn.unshift("还可以输入");
			} else {
				if (len <= maxN) {
					warn[1] = Math.abs(parseInt((maxN - len) / 2));
					warn.unshift("还可以输入");
				} else {
					warn[1] = Math.abs(parseInt((maxN - len) / 2)) + 1;
					warn.unshift("已经超过");
				}
			}
			$('.lui_ask_word').html(warn.join(''));
		})
	})(100);
	});

	// 异步请求分类路径
	function ajaxCategoryPath(fdCategoryId){
		$.ajax({
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
				$.each(data,function(i,n){
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


</script>