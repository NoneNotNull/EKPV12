<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
var orgId = data.orgId2;
var rela = data.relation;

if(rela == 0 || rela == 2) {
	{$
		<a class="lui_zone_btn_follow_l" 
			data-action-id="{%orgId%}" 
			 data-action-type="cared"
			title="${lfn:message('sys-zone:sysZonePerson.cared') }"
			href="javascript:void(0);">
			<span class="lui_zone_btn_follow_r"> 
		    <span class="lui_zone_btn_follow_c">
		     <em> + </em>
		     ${lfn:message('sys-zone:sysZonePerson.fdAttention') }
		    </span>
	    	</span>
		</a>
	$}
} else if(rela == 1 || rela == 3) {
	var text = rela == 1 ? "${lfn:message('sys-zone:sysZonePerson.cancelCared1') }" : "${lfn:message('sys-zone:sysZonePerson.follow.each') }" ;
	{$
		<span class="lui_zone_btn_followc_l" >
			<span class="lui_zone_btn_followc_r"> 
			    <span class="lui_zone_btn_followc_c">
			     <em></em>
				 {%text%} |
			     <a data-action-id="{%orgId%}"  href="javascript:void(0);"
				     data-action-type="cancelCared"
				     title="${lfn:message('sys-zone:sysZonePerson.cancelCared') }">
					${lfn:message('button.cancel') }</a>
			    </span>
		    </span>
		</span>
	$}
}
