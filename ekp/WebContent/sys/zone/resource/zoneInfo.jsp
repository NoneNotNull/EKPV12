<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<script>
	seajs.use(['theme!zone','sys/fans/sys_fans_main/style/view.css']);
</script>
<div class="lui_zone_popup">
	<ui:dataview>
		<ui:source type="AjaxJson">
			{url:"/sys/person/sys_person_zone/sysPersonZone.do?method=info&fdId=${param.fdId}"}
		</ui:source>
		<ui:render type="Template">
			{$
			<div class="lui_zone_popup_content person_brief">
			    <div class="person_basicInfo">
			        <div class="cover">
			        </div>
			        <a href="#">
			            <img alt="" class="photo" 
			            src="${LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${param.fdId}&size=b" />
			         </a>
			        <div class="p1">
			            <a class="com_author" target="_blank" href="${LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId=${param.fdId}">
			           	 {%data.fdName%}
			            </a>
			 $}			
			 		if(data.fdSex == "F") {
			 {$
			            <div class="lui_icon_s gender_female">
			            </div>
			 $}    
			 		} else {
			  {$
			 			<div class="lui_icon_s gender_male">
			            </div>
			  $}
			 	   }
			 if(data.isSelf == false) {
			 	{$ <div data-lui-mark="follow_btn" class="btn">$}
		 	   if(data.rela == 2 || data.rela == 0){
					{$
					<div class="sys_fans_btn"  attent-model-name="com.landray.kmss.sys.zone.model.SysZonePersonInfo"
						fans-model-name="com.landray.kmss.sys.zone.model.SysZonePersonInfo" is-follow-person="true">
							<a class="lui_fans_btn_follow_l" fans-action-type="unfollowed" fans-action-id="${param.fdId}"
								href="javascript:void(0);" id="set_fans" title="${lfn:message('sys-fans:sysFansMain.follow') }" 
								onclick="_layer_zone_follow_action(this);">
								<span class="lui_fans_btn_follow_r">
									<span class="lui_fans_btn_follow_c">
										<em> + </em>
										 ${lfn:message('sys-fans:sysFansMain.follow1') }
									</span>
								</span>
							</a>
					</div>
					$} 
				} else if(data.rela == 1 || data.rela == 3){ 
					var text = data.rela == 1 ? "${lfn:message('sys-fans:sysFansMain.cancelFollow1') }" : "${lfn:message('sys-fans:sysFansMain.follow.each') }" ;
					{$
						<div class="lui_fans_followed" >
							<span class="lui_fans_btn_followc_l">
								<span class="lui_zone_btn_followc_r">
									<span class="lui_fans_btn_followc_c" attent-model-name="com.landray.kmss.sys.zone.model.SysZonePersonInfo"
											 fans-model-name="com.landray.kmss.sys.zone.model.SysZonePersonInfo" 
											 is-follow-person="true">
										<em></em>
										{%text%} |
										<a  href="javascript:void(0);" 
											onclick="_layer_zone_follow_action(this);"
											title="${lfn:message('sys-fans:sysFansMain.cancelCared') }"
												id="cancel_fans" fans-action-type="followed" fans-action-id="${param.fdId}">
												${lfn:message('button.cancel') }</a>
									</span>
								</span>
							</span>
						</div>
					$}
				}
				{$</div>$}
			}
			  {$          
			         </div>
			        <div class="p2">
			            <em>来自：</em>{%data.fdDeptName%}</div>
			    </div>
			    <div class="person_postInfo">
			        <ul class="clrfix">
			            <li class="textEllipsis" title="{%data.fdPostName%}"><em>员工岗位：</em>{%data.fdPostName%}</li>
			            <li class="textEllipsis" title="{%data.fdSignature%}"><em>个人签名：</em>{%data.fdSignature%}</li>
			            <li class="textEllipsis" title="{%data.fdTags%}"><em>个人标签：</em>{%data.fdTags%}</li>
			        </ul>
			    </div>
			</div>
							
			$}		
	 		</ui:render>
		</ui:dataview>
</div>
<div class="lui_zone_info_arrow_box">
	<i class="lui_zone_info_arrow_block lui_zone_info_arrow_border"></i>
	<i class="lui_zone_info_arrow_block lui_zone_info_arrow_cover"></i>
</div>
<script>
	if(!window._layer_zone_follow_after) {
		window._layer_zone_follow_after =  function (data, fdUserId, isFollowed,
				 $element, config, isFollowPerson, attentModelName, fansModelName) {
			var outer = $element.parents("[data-lui-mark='follow_btn']")[0];
			if(outer &&  data.result == "success") {
				 if(data.relation == 2 || data.relation == 0){
					var htm =   '<div class="sys_fans_btn"  attent-model-name="com.landray.kmss.sys.zone.model.SysZonePersonInfo"' +
							'fans-model-name="com.landray.kmss.sys.zone.model.SysZonePersonInfo" is-follow-person="true">'+
								'<a class="lui_fans_btn_follow_l" fans-action-type="unfollowed" fans-action-id="' + fdUserId +'"'+
									'href="javascript:void(0);" id="set_fans" title="${lfn:message("sys-fans:sysFansMain.follow")}"'+
									'onclick="_layer_zone_follow_action(this);">'+
									'<span class="lui_fans_btn_follow_r">'+
										'<span class="lui_fans_btn_follow_c">'+
											'<em> + </em>'+
											 "${lfn:message('sys-fans:sysFansMain.follow1')}"+
										'</span>'+
									'</span>'+
								'</a>'+
						'</div>';
					$(outer).html(htm);
				 } else if(data.relation == 1 || data.relation == 3){
					 var text = data.relation == 1 ? "${lfn:message('sys-fans:sysFansMain.cancelFollow1') }" : "${lfn:message('sys-fans:sysFansMain.follow.each') }" ;
					 var htm = '<div class="lui_fans_followed" >' +
								'<span class="lui_fans_btn_followc_l">'+
									'<span class="lui_zone_btn_followc_r">'+
										'<span class="lui_fans_btn_followc_c" attent-model-name="com.landray.kmss.sys.zone.model.SysZonePersonInfo"'+
												 'fans-model-name="com.landray.kmss.sys.zone.model.SysZonePersonInfo" '+
												' is-follow-person="true">'+
											'<em></em>'+ text + " | " +
											'<a  href="javascript:void(0);" '+
												'onclick="_layer_zone_follow_action(this);"'+
												'title="${lfn:message("sys-fans:sysFansMain.cancelCared")}"'+
													'id="cancel_fans" fans-action-type="followed" fans-action-id="' + fdUserId +'">'+
													'${lfn:message('button.cancel') }</a>'+
										'</span>'+
									'</span>'+
								'</span>'+
							'</div>';
					  $(outer).html(htm);
				 }
			}
		}; 
	}
	if(!window._layer_zone_follow_action) {
		window._layer_zone_follow_action =  function (target) {
			seajs.use(['sys/fans/resource/sys_fans','lui/jquery'], function(follow, $) {
				var $this = $(target);
				var isFollowed = $this.attr("fans-action-type");
				var isFollowPerson = $this.parent().attr("is-follow-person");
				var attentModelName = $this.parent().attr("attent-model-name");
				var fansModelName = $this.parent().attr("fans-model-name");
				if(isFollowed) {
					var userId = $this.attr("fans-action-id");
					follow.fansFollow(userId , isFollowed, isFollowPerson, attentModelName, fansModelName, 
							$this, _layer_zone_follow_after,window);
				}
			});
		};
	}
</script>