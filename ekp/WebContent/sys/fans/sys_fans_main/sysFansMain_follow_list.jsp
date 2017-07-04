<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/sys/fans/sys_fans_main/style/view.css" />
<template:include ref="zone.navlink">
	<template:replace name="content">
		<script>
		seajs.use(['lui/jquery', 'lui/topic'], function($, topic) {
			$("#attention").on('click', function(){
				var attentModelName = "${param.attentModelName}";
				var fansModelName = "${param.fansModelName}";
				if($(this).hasClass("btn_clicked")){
					return;
				}
				topic.channel("follow").publish('criteria.changed', { criterions:[{key:'type', value:['attention']}]});
				$(this).attr("class", "btn_clicked");
				$("#fans").attr("class", "btn_unclick");
			});
			$("#fans").on('click', function(){
				if($(this).hasClass("btn_clicked")){
					return;
				}
				topic.channel("follow").publish('criteria.changed', { criterions:[{key:'type', value:['fans']}]});
				$(this).attr("class", "btn_clicked");
				$("#attention").attr("class", "btn_unclick");
			});	
			LUI.ready(function() {
				if("${param.type}" == 'attention'){
					$("#attention").trigger("click");
				}else{
					$("#fans").trigger("click");
				}
			});
		});
		</script>
		<div class="lui_fans_follow_div" id="lui_fans_follow_div" 
					<c:if test="${param.showTabPanel ne 'true'}">style="display:none;"</c:if>>
			<c:set var="TA" value="${param.fans_TA}"/>
			<div class="btn_unclick" id="attention">${param.fans_TA}${lfn:message('sys-fans:sysFansMain.fdAttention') }</div>
			<div class="btn_unclick" id="fans">${param.fans_TA}${lfn:message('sys-fans:sysFansMain.fdFans') }</div>
		</div>
		<div id="followInfo">
            <list:listview channel="follow" cfg-criteriaInit="true">
            	
				<ui:source type="AjaxJson">
					{"url":"/sys/fans/sys_fans_main/sysFansMain.do?method=dataFollow&fdId=${param.fdId}&orderby=fdFollowTime&ordertype=down&rowsize=8&attentModelName=${param.attentModelName }&fansModelName=${param.fansModelName }"}
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
						<%@ include file="/sys/fans/sys_fans_list/sysFansMain_list_content.jsp"%>
					</list:row-template>
				</list:gridTable>
				<ui:event event="load">
					seajs.use(['sys/fans/resource/sys_fans'], function(follow){
						follow.bindButton(".lui_fans_btn_p");
					});
				</ui:event>
			</list:listview>
			<list:paging channel="follow"></list:paging>
		</div>
	</template:replace>
</template:include>