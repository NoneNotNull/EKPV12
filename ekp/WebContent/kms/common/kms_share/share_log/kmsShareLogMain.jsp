<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/resource/jsp/common.jsp"%>
<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/common/kms_share/share_log/style/shareLog.css" />


<div class="share_log_main">
	<div class="share_log_title_div" id="share_log_title_div">
		<span class="share_log_title">${lfn:message('kms-common:kmsShareMain.share')}</span>
		<span class="share_log_count" id="share_log_count"></span>
	</div>
	<div class="share_log_content">
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{"url":"/kms/common/kms_share/kmsShareMain.do?method=viewAll&orderby=fdShareTime&ordertype=down&rowsize=8&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}"}
			</ui:source>
			<list:rowTable channel="rowtable" isDefault="true" target="_blank" cfg-norecodeLayout="simple">
				<ui:layout type="Template">
					{$<div data-lui-mark='table.content.inside'>
					</div>$}
				</ui:layout>
				<list:row-template>
					{$
						<ul>
							<li class="share_li">
								<img class="share_person" src="${ LUI_ContextPath}/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId={%row['fdSharePerson.fdId']%}">
								<p class="share_info">
									<span class="share_to_person">
										{%row['fdSharePerson']%}
										<span class="share_p_to_p">${lfn:message('kms-common:kmsShareMain.share2')}</span>
										<span style="color: #F19703;font-size: 14px;">{%row['goalPersonNames']%}：</span>
									</span>
									<span style="color:black;">{%row['fdShareReason']%}</span>
								</p>
								<p class="share_time">
									{%row['fdShareTime']%}
								</p>
							</li>
						</ul>
					$}
				</list:row-template>
			</list:rowTable>	
			<list:paging layout="sys.ui.paging.default"></list:paging>
			<ui:event topic="list.loaded" args="vt"> 
				var shareCount = vt.listview._data.page.totalSize;
				$(".share_log_count").html("（"+shareCount+"）");
			</ui:event>
		</list:listview>
	</div>
</div>
			