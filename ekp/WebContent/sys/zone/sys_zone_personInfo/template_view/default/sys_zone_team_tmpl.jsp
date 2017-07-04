<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
{$<ul class="lui_zone_relation_team" id="con_teamTab_2">$}
	if(data && data.length > 0) {
		 for(var i = 0; i < data.length; i ++ ) {
			{$
			<li>
				<div class="lui_zone_relation_team_img">
					<a target="_blank"
						href="${LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId={%data[i].fdId%}">
					<img
						src="${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId={%data[i].fdId%}&size=m" />
					</a>
				</div>
				<h4 class="textEllipsis">
					<a target="_blank" title="{%data[i].fdName%}" class="com_author"
						href="${LUI_ContextPath }/sys/zone/index.do?userid={%data[i].fdId%}">
						{%data[i].fdName%} </a>
				</h4>
			</li>									
			$}
		}
	}	
{$</ul>$}