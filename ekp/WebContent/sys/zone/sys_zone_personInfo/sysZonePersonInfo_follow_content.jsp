<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
{$
    <ul class="lui_zone_follow_list">
                    <li>
                        <div class="imgbox">
	                        <a  target="_blank" href="${LUI_ContextPath }/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=view&fdId={%grid['fdId']%}">
		                        <img src="${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId={%grid['fdId']%}&size=m" />
		                      </a>
	                      </div>
                        <div class="title">
                            <a  target="_blank" href="${LUI_ContextPath }/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=view&fdId={%grid['fdId']%}">
	                            <span class="name">{%grid['fdName']%}
	                             <span style="display:inline-block;"  class="lui_zone_msex_{%grid['fdSex']%}"/>
	                            $}
							{$
	                            </span>
                            </a>
                            <span class="dep">${lfn:message('sys-zone:sysZonePerson.dept') }：{%grid['fdDept']%}</span>
                             <div class="lui_zone_btn_p">$}	
                             	if(grid['fdId'] != "${KMSS_Parameter_CurrentUserId}") {
                             		if(grid['isAtt'] == 1&& grid['isFans'] == 1) {
                             			{$<a class="lui_zone_listfollow_btn" href="javascript:void(0)" data-action-id="{%grid['fdId']%}" data-action-type="cancelCared" >
				                                    <span class="lui_zone_btn_focused" title="${lfn:message('sys-zone:sysZonePerson.cancelCared') }">
				                                    - ${lfn:message('sys-zone:sysZonePerson.follow.each') }</span>
				                            </a>$}
                             		} else if(grid['isAtt'] == 1 && grid['isFans'] != 1) {
                             			{$  
	                           				 <a class="lui_zone_listfollow_btn" href="javascript:void(0)" data-action-id="{%grid['fdId']%}" data-action-type="cancelCared">
				                                    <span class="lui_zone_btn_focused" title="${lfn:message('sys-zone:sysZonePerson.cancelCared') }">
				                                    - ${lfn:message('sys-zone:sysZonePerson.followed') }</span>
				                            </a>
	                            		$}
                             		} else {
                             			{$  
	                          				  <a class="lui_zone_listfollow_btn" href="javascript:void(0)" data-action-id="{%grid['fdId']%}" data-action-type="cared">
				                                    <span class="lui_zone_btn_focus" title="${lfn:message('sys-zone:sysZonePerson.cared') }">
				                                     + ${lfn:message('sys-zone:sysZonePerson.cared') }</span>
				                            </a>
	                            		$}
                             		}
                             	}
							{$</div>
                        </div>
                        <div class="tip">
                            <span>${lfn:message('sys-zone:sysZonePerson.fdAttention') }：<em>{%grid['fdAttentionNum']%}</em></span>
                            <span class="lui_zone_fans_num_span">${lfn:message('sys-zone:sysZonePerson.fdFans') }：<em id="fansNumEm">{%grid['fdFansNum']%}</em></span>
                        </div>
                        <p class="txt">{%grid['fdSignature']%}</p>
				     </li>
                </ul>
$}