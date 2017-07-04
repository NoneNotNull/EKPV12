<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
{$
	<div height="100%">
		<dl class="comment_record_dl">
			<dd class="comment_record_msg" id="{%row['fdId']%}">
				<img src="${KMSS_Parameter_ContextPath}sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId={%row['docCommentator.fdId']%}">
				<div class="img">
				</div>
				<div class="txt" id="comment_txt_{%row['fdId']%}">
					<div class="comment_record_content">
					<ui:person personId="{%row['docCommentator.fdId']%}" personName="{%env.fn.formatText(row['docCommentator.fdName'])%}"></ui:person>
					$}
					if(!!row['docParentReplyer.fdId']){
						{$
						{%commentAlert.comment_reply%}&nbsp;<ui:person personId="{%row['docParentReplyer.fdId']%}" personName="{%env.fn.formatText(row['docParentReplyer.fdName'])%}"></ui:person>
						$}
					}
				{$：{%row['fdCommentContent']%}</div>
					<div class="comment_info">
						{%commentAlert.comment_publish%}：{%row['docCreateTime']%}
						<div class="comment_reply" data-commentator-id="{%row['docCommentator.fdId']%}" data-commentator-name="{%row['docCommentator.fdName']%}"></div>
						$}
						if(Com_Parameter.CurrentUserId == row['docCommentator.fdId'] || "${param.commentAuth}" == 'true'){
						{$
						<div class="del" data-comment-id="{%row['fdId']%}"></div>
						$}
						}
						{$
					</div>
				</div>
			</dd>
		</dl>
	</div>
$}