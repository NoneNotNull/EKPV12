<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
{$
	<div class="lui_zone_similar_data">
		<a class="imgbox" target="_blank" href="${LUI_ContextPath}/sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId={%grid['fdId']%}"> 
			<img style="width: 55px; height: 55px;" src="${LUI_ContextPath}/sys/person/sys_person_zone/sysPersonZone.do?method=img&size=m&fdId={%grid['fdId']%}">
		</a>
		<h4>
			<a class="com_author" target="_blank" href="${LUI_ContextPath}/sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId={%grid['fdId']%}">
		  		{%grid['fdName']%}
		   </a>
		   <div class="lui_zone_btn_tag">
			$}
			if(grid['isLoad']!='true'){
				{$
				<c:import
					url="/sys/fans/sys_fans_temp/sysFansMain_list_tmpl.jsp"
					charEncoding="UTF-8">
					<c:param name="fdId" value="{%grid['fdId']%}"></c:param>
                      					<c:param name="actionType" value="unfollowed"></c:param>
                      					<c:param name="userModelName" value="com.landray.kmss.sys.zone.model.SysZonePersonInfo"></c:param>
				</c:import>
				$}
				
			}
			{$	</div>	
		</h4>
		<p>{%grid['tags']%}</p>
	</div>
$}