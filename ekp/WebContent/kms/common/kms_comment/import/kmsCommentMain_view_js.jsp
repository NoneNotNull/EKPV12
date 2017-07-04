<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	seajs.use(['${KMSS_Parameter_ContextPath}kms/common/kms_comment/import/resource/comment.css']);
	Com_IncludeFile("comment.js","${KMSS_Parameter_ContextPath}kms/common/kms_comment/import/resource/","js",true);
	
	var commentAlert = {
			'comment_reply':'<bean:message key="kmsCommentMain.reply" bundle="kms-common" />',
			'comment_delete':'<bean:message key="button.delete"/>',
			'comment_publish':'<bean:message key="kmsCommentMain.publish" bundle="kms-common" />',
			'comment_r_s':'<bean:message key="kmsCommentMain.reply.success" bundle="kms-common" />',
			'comment_d_s':'<bean:message key="kmsCommentMain.delete.success" bundle="kms-common" />',
			'comment_c_write':'<bean:message key="kmsCommentMain.canwrite" bundle="kms-common" />',
			'comment_many':'<bean:message key="kmsCommentMain.toomany" bundle="kms-common" />',
			'comment_del_title': '<bean:message key="page.comfirmDelete"/>'
	};
</script>

<script type="text/javascript">

	function showComment(commentObj){
		var fdModelId = $(commentObj).find("input[name='commentModelId']").val();
		var fdModelName = $(commentObj).find("input[name='commentModelName']").val();
		var commentHtml = $("#comment_"+fdModelId+" #commentList").html();
		if($.trim(commentHtml) == ""){
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
							$("#comment_"+fdModelId+" #commentList").append(html);
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
		var __list = $("#comment_" + fdModelId);
		setTimeout(function(){
			if(__list.is(":hidden")){
				$(".kms_comment").hide();
				__list.slideDown('slow');
			}else{
				__list.slideUp("slow");
			}
		}, 300);
		var vt = "commentL_"+fdModelId;
		if(window[vt] == null)
			window[vt] = new Comment_opt("comment_"+fdModelId, "kms_comment_count_"+fdModelId, fdModelId, fdModelName);
		var positionId = 'kms_comment_box_' + fdModelId;
		setTimeout(function(){window[vt].__init__();}, 800);	
	}

	
</script>

<script type="text/template" id="kms_comment_templ">
var commentList = data['commentList'];
for(var i = 0;i<commentList.length;i++){
	{$
		<div height="100%">
			<dl class="comment_record_dl">
				<dd class="comment_record_msg" id="{%commentList[i].fdId%}">
					<img src="${KMSS_Parameter_ContextPath}sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId={%commentList[i].docCommentatorId%}">
					<div class="img">
					</div>
					<div class="txt" id="comment_txt_{%commentList[i].fdId%}">
						<div class="comment_record_content">
						<ui:person personId="{%commentList[i].docCommentatorId%}" personName="{%commentList[i].docCommentatorName%}"></ui:person>
						$}
						if(!!commentList[i].docParentReplyerId){
							{$
							{%commentAlert.comment_reply%}&nbsp;<ui:person personId="{%commentList[i].docParentReplyerId%}" personName="{%commentList[i].docParentReplyerName%}"></ui:person>
							$}
						}
					{$：{%commentList[i].commentContent%}</div>
						<div class="comment_info">
							{%commentAlert.comment_publish%}：{%commentList[i].docCreateTime%}
							<div class="comment_reply" data-commentator-id="{%commentList[i].docCommentatorId%}" data-commentator-name="{%commentList[i].docCommentatorName%}"></div>
							$}
							if(Com_Parameter.CurrentUserId == commentList[i].docCommentatorId || "${param.commentAuth}" == 'true'){
							{$
							<div class="del" data-comment-id="{%commentList[i].fdId%}"></div>
							$}
							}
							{$
						</div>
					</div>
				</dd>
			</dl>
		</div>
	$}
}
</script>