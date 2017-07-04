<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="zone.navlink">
	<template:replace name="content">
		<script>
		seajs.use(['lui/jquery', 'lui/topic'], function($, topic) {
			$("#following").on('click', function(){
				if($(this).hasClass("btn_clicked")){
					return;
				}
				topic.channel("follow").publish('criteria.changed', { criterions:[{key:'type', value:['following']}]});
				$(this).attr("class", "btn_clicked");
				$("#follower").attr("class", "btn_unclick");
			});
			$("#follower").on('click', function(){
				if($(this).hasClass("btn_clicked")){
					return;
				}
				topic.channel("follow").publish('criteria.changed', { criterions:[{key:'type', value:['follower']}]});
				$(this).attr("class", "btn_clicked");
				$("#following").attr("class", "btn_unclick");
			});	
			LUI.ready(function() {
				if("${param.type}" == 'following'){
					$("#following").trigger("click");
				}else{
					$("#follower").trigger("click");
				}
			});
		});
		</script>
		<div class="lui_zone_follow_div">
			<c:set var="TA" value="${param.zone_TA}"/>
			<div class="btn_unclick" id="following">${lfn:message(lfn:concat('sys-zone:sysZonePerson.fdAttention.', TA)) }</div>
			<div class="btn_unclick" id="follower">${lfn:message(lfn:concat('sys-zone:sysZonePerson.fdFans.',TA)) }</div>
		</div>
		<div id="followInfo">
            <list:listview channel="follow" cfg-criteriaInit="true">
            	
				<ui:source type="AjaxJson">
					{"url":"/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=dataFollow&fdId=${param.fdId}&rowsize=8"}
				</ui:source>
			  	<list:gridTable name="gridtable" columnNum="1" id="_gridtable">
			  		<%--防止数据加载完的时候layout还未加载完  --%>
			  		<ui:layout type="Template">
	            		{$
							 <div class="lui_listview_gridtable_main_body">
								<div class="lui_listview_gridtable_centerL">
									<div class="lui_listview_gridtable_centerR">
										<div class="lui_listview_gridtable_centerC">
											<div class="lui_listview_gridtable_summary_box" data-lui-mark='table.content.inside'>
						                            
											</div>
										</div>
									</div>
								</div>
								<div class="lui_listview_gridtable_footL">
									<div class="lui_listview_gridtable_footR">
										<div class="lui_listview_gridtable_footC">
										</div>
									</div>
								</div>
							</div>
						$}
	            	</ui:layout>
					<list:row-template >	
						<%@ include file="/sys/zone/sys_zone_personInfo/sysZonePersonInfo_follow_content.jsp"%>
					</list:row-template>
				</list:gridTable>
				<ui:event event="load">
					seajs.use(['sys/zone/resource/zone_follow'], function(follow){
						follow.bindButton(".lui_zone_btn_p");
					});
				</ui:event>
			</list:listview>
			<list:paging channel="follow"></list:paging>
		</div>
	</template:replace>
</template:include>