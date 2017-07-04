<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

{$
    <ul class="lui_zone_search_list">
                    <li>
                        <div class="imgbox">
	                        <a  target="_blank" href="${LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId={%grid['fdId']%}">
		                        <img src="${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId={%grid['fdId']%}&size=b" />
		                      </a>
	                      </div>
                        <div class="title">
                            <a  target="_blank" href="${LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId={%grid['fdId']%}">
	                            <span class="name">{%grid['fdName']%} <span style="display:inline-block;"  class="lui_zone_msex_{%grid['fdSex']%}"></span></span> 
                            </a>
                            <span class="dep">${lfn:message('sys-zone:sysZonePerson.dept') }：{%grid['fdDept']%}</span>
                          $}
                          if(grid['isSelf']=='false') {
                          {$
                           <div style="display:inline-block;"  class="lui_zone_contact_list"
                            	  id="person_zone_{%grid['fdId']%}"
                            	  data-person-role="contact"
                            	  data-person-param="&fdId={%grid['fdId']%}&fdName={%grid['fdName']%}&fdLoginName={%grid['fdLoginName']%}&fdEmail={%grid['fdEmail']%}&fdMobileNo={%grid['fdMobileNo']%}"></div>
      							<div class="lui_zone_btn_p">
      								<c:import
										url="/sys/fans/sys_fans_temp/sysFansMain_list_tmpl.jsp"
										charEncoding="UTF-8">
										<c:param name="fdId" value="{%grid['fdId']%}"></c:param>
                           					<c:param name="actionType" value="unfollowed"></c:param>
                           					<c:param name="userModelName" value="com.landray.kmss.sys.zone.model.SysZonePersonInfo"></c:param>
									</c:import>
								</div>
							</div>
                                  $}
                             	}
							{$
                        <div class="tip">
                            <span>${lfn:message('sys-zone:sysZonePerson.fdAttention') }：<em>{%grid['fdAttentionNum']%}</em></span>
                            <span class="lui_zone_fans_num_span">${lfn:message('sys-zone:sysZonePerson.fdFans') }：<em id="fansNumEm">{%grid['fdFansNum']%}</em></span>
                        </div>
                        <p class="txt">{%grid['fdSignature']%}</p>
                        <div class="tags">
                            {%grid['fdTags']%}
                        </div>
				     </li>
                </ul>
$}