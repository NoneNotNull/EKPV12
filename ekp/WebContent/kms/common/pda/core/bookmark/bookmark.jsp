<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<link rel="stylesheet" href="${LUI_ContextPath }/kms/common/pda/core/bookmark/style/bookmark.css" />

<a data-lui-role="button" id="bookmark_button">
	<script type="text/config">
		{
			currentClass : 'lui-bookmark-icon-view',
			onclick : "saveBookmark()",
			group : 'group1',
			text : '收藏'
		}
	</script>	
</a>
<div style="position: relative;">
	<div id="success_dialog" class="lui-bookmark-success-dialog">
		<div id="success_dialog_box" class="lui-bookmark-success-dialog-box">
		</div>
		<div class="lui-bookmark-tri">
		</div>
	</div>
</div>
<div>
	<form id="kms_bookmark_form" name="kms_bookmark_form">
		<input type="hidden" name="docSubject"/>
		<input type="hidden" name="fdUrl"/>
		<input type="hidden" name="fdModelId" value="${param.fdId}"/>
		<input type="hidden" name="fdModelName" value="${param.fdModelName}"/>
	</form>
</div>
<script>
	function GetBookmarkSubject() {
		var subject = "${lfn:escapeJs(param.fdSubject)}";
		if (subject.length < 1) {
			var title = document.getElementsByTagName("title");
			if (title != null && title.length > 0) {
				subject = title[0].text;
				if (subject == null) {
					subject = "";
				} else {
					subject = subject.replace(/(^\s*)|(\s*$)/g, "");
				}
			}
		}
		return subject;
	}
	function GetBookmarkUrl() {
		var url = "${lfn:escapeJs(param.fdUrl)}";
		var context = "<%=request.getContextPath() %>";
		if (url.length < 1) {
			url = window.location.href;
			url = url.substring(url.indexOf('//') + 2, url.length);
			url = url.substring(url.indexOf('/'), url.length);
			if (context.length > 1) {
				url = url.substring(context.length, url.length);
			}
		}
		return url;
	}
	function dialogSuccess(text) {
		$("#success_dialog_box").text(text);
		$("#success_dialog").css({"bottom":$("#bookmark_button").height() , "opacity":"0.9"}).show();
		$("#success_dialog").animate({"opacity" : "0"}, 3000 ,
				function(){
			      $("#success_dialog").hide();
		   		});
	}
	function disableButton() {
		Pda.Element("bookmark_button").disabled();
		setTimeout(function() {Pda.Element("bookmark_button").enabled();}, 5000);
	}
	function saveBookmark() {
		var $showd = $("#success_dialog");
		if($showd.isAnimating()) { 
			var tran = 'opacity 0s linear';
			$showd.css('-webkit-transition', tran);
			$showd.css('transition', tran);
			$showd.css('opacity', $showd.css('opacity'));
			$showd.hide();
		}
		$("[name=docSubject]").val(GetBookmarkSubject());
		$("[name=fdUrl]").val(GetBookmarkUrl());
		if($("[name=fdModelId]").val() && $("[name=fdModelName]").val()) {
			$.ajax({
				    url:"${LUI_ContextPath}/kms/common/kms_common_bookmark_main/KmsCommonBookmarkMain.do?method=save",
				    data :$("#kms_bookmark_form").serialize(), 
				    type : "POST",
				    dataType : "json",
					success:function(json){
						if(json != null && json.flag == true){
							if(json.noCate) {
								dialogSuccess("请新建收藏类别！");
							}
							else if(json.exsit) { 
								dialogSuccess("文档已收藏过！");
							} else dialogSuccess("文档收藏成功！");
						} 
						disableButton();
					},
					error:function(json){
								dialogSuccess("文档收藏失败！");
								disableButton();
							} 
					});
		}
		
	}

</script>