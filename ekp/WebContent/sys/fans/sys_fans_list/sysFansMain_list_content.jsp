<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>

{$
    <ul class="lui_fans_follow_list">
                    <li>
                        <div class="imgbox">
                        	$}
                            if(grid['isFollowPerson']=="true"){
                            	{$
			                       <a  target="_blank" href="${LUI_ContextPath }/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=view&fdId={%grid['fdModelId']%}">
			                        	<img src="${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId={%grid['fdModelId']%}&size=m" />
			                       </a>
			                    </div>
                        	<div class="title">
                            	<a  target="_blank" href="${LUI_ContextPath }/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=view&fdId={%grid['fdModelId']%}">
                            	$}
                            }else {
                            	{$
                            	  <a  target="_blank" href="${LUI_ContextPath }/sns/ispace/sns_ispace_public_account/snsIspacePublicAccount.do?method=view&fdId={%grid['fdModelId']%}">
			                        <img src="${ LUI_ContextPath }/sns/ispace/sns_ispace_public_account/snsIspacePublicAccount.do?method=docThumb&modelName=com.landray.kmss.sns.ispace.model.SnsIspacePublicAccount&fdId={%grid['fdModelId']%}&size=m" />
			                      </a> </div>
                        	<div class="title">
                            	<a  target="_blank" href="${LUI_ContextPath }/sns/ispace/sns_ispace_public_account/snsIspacePublicAccount.do?method=view&fdId={%grid['fdModelId']%}">
                            	$}
                            }
                            {$
	                            <span class="name">{%grid['fdName']%}</span>
	                             <span style="display:inline-block;"  class="lui_fans_msex_{%grid['fdSex']%}"/></span>
                            </a>
                            $}
                            if(grid['fdDept'] != null && grid['fdDept']!=""){
                            	{$
                            		<span class="dep">${lfn:message('sys-fans:sysFansMain.dept') }：{%grid['fdDept']%}</span>
                            	$}
                            }
                            {$
                             <div class="lui_fans_btn_p">$}	
                             	if(grid['fdModelId'] != "${KMSS_Parameter_CurrentUserId}") {
                             		if(grid['isAtt'] == 1&& grid['isFans'] == 1) {
                             			{$<a class="lui_fans_listfollow_btn" href="javascript:void(0)" 
                             				attent-model-name="{%grid['attentModelName']%}" 
                             				fans-model-name="{%grid['fansModelName']%}" 
                             				is-follow-person="{%grid['isFollowPerson']%}" 
                             				data-action-id="{%grid['fdModelId']%}" 
                             				data-action-type="followed" >
				                                    <span class="lui_fans_btn_focused" title="${lfn:message('sys-fans:sysFansMain.cancelFollow') }">
				                                    - ${lfn:message('sys-fans:sysFansMain.follow.each') }</span>
				                            </a>$}
                             		} else if(grid['isAtt'] == 1 && grid['isFans'] != 1) {
                             			{$  
	                           				 <a class="lui_fans_listfollow_btn" href="javascript:void(0)" 
	                           				 	attent-model-name="{%grid['attentModelName']%}" 
	                           				 	fans-model-name="{%grid['fansModelName']%}" 
	                           				 	is-follow-person="{%grid['isFollowPerson']%}" 
	                           				 	data-action-id="{%grid['fdModelId']%}" 
	                           				 	data-action-type="followed">
				                                    <span class="lui_fans_btn_focused" title="${lfn:message('sys-fans:sysFansMain.cancelFollow') }">
				                                    - ${lfn:message('sys-fans:sysFansMain.followed') }</span>
				                            </a>
	                            		$}
                             		} else {
                             			{$  
	                          				  <a class="lui_fans_listfollow_btn" href="javascript:void(0)" 
	                          				  		attent-model-name="{%grid['attentModelName']%}" 
	                          				  		fans-model-name="{%grid['fansModelName']%}" 
	                          				  		is-follow-person="{%grid['isFollowPerson']%}" 
	                          				  		data-action-id="{%grid['fdModelId']%}" 
	                          				  		data-action-type="unfollowed">
				                                    <span class="lui_fans_btn_focus" title="${lfn:message('sys-fans:sysFansMain.follow') }">
				                                     + ${lfn:message('sys-fans:sysFansMain.follow') }</span>
				                            </a>
	                            		$}
                             		}
                             	}
							{$</div>
                        </div>
                        <div class="tip">
                        	$}
                            if(grid['fdAttentionNum'] != null && grid['fdAttentionNum']!=""){
                            	{$
                            		<span>${lfn:message('sys-fans:sysFansMain.fdAttention') }：<em>{%grid['fdAttentionNum']%}</em></span>
                            	$}
                            }
                            {$
                            <span class="lui_fans_fans_num_span">${lfn:message('sys-fans:sysFansMain.fdFans') }：<em id="fansNumEm">{%grid['fdFansNum']%}</em></span>
                        </div>
                        <p class="txt">{%grid['fdSignature']%}</p>
				     </li>
                </ul>
$}