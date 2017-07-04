<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
var rela = data.relation;
var userId = data.userId;
var attentModelName = data.attentModelName;
var fansModelName = data.fansModelName;
var isFollowPerson = data.isFollowPerson;
if(rela == 0 || rela == 2) {
	{$
		<div class="sys_fans_btn" id="sys_fans_btn" attent-model-name="{%attentModelName%}"
						fans-model-name="{%fansModelName%}" is-follow-person="{%isFollowPerson%}">
			<a class="lui_fans_btn_follow_l" fans-action-type="unfollowed" fans-action-id="{%userId%}"
				href="javascript:void(0);" id="set_fans" title="${lfn:message('sys-fans:sysFansMain.follow') }" >
				<span class="lui_fans_btn_follow_r">
					<span class="lui_fans_btn_follow_c">
						<em> + </em>
						 ${lfn:message('sys-fans:sysFansMain.follow1') }
					</span>
				</span>
			</a>
		</div>
	$}
} else if(rela == 1 || rela == 3) {
	var text = rela == 1 ? "${lfn:message('sys-fans:sysFansMain.cancelFollow1') }" : "${lfn:message('sys-fans:sysFansMain.follow.each') }" ;
	{$
		<div class="lui_fans_followed" id="sys_fans_btn">
			<span class="lui_fans_btn_followc_l">
				<span class="lui_zone_btn_followc_r">
					<span class="lui_fans_btn_followc_c" attent-model-name="{%attentModelName%}"
							 fans-model-name="{%fansModelName%}" is-follow-person="{%isFollowPerson%}">
						<em></em>
						{%text%} |
						<a title="取消关注" href="javascript:void(0);" title="${lfn:message('sys-fans:sysFansMain.cancelCared') }"
								id="cancel_fans" fans-action-type="followed" fans-action-id="{%userId%}">${lfn:message('button.cancel') }</a>
					</span>
				</span>
			</span>
		</div>
	$}
}
