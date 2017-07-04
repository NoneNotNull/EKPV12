<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.home">
	<template:replace name="title">${ lfn:message('km-imeeting:module.km.imeeting') }</template:replace>
	<template:replace name="content"> 
		<div style="width:100%">		
			<ui:tabpanel layout="sys.ui.tabpanel.light" >
				<%--我的会议--%>
				<ui:content title="${ lfn:message('km-imeeting:kmImeeting.porlet.meetings.my')}" style="padding:0;background-color:#f2f2f2;" >
					<list:criteria id="meetingCriteria" expand="true" channel="meetingChannel">
						<%-- 我的会议 --%>
						<list:cri-criterion title="${ lfn:message('km-imeeting:kmImeeting.tree.meetings.my') }" key="mymeeting" multi="false">
							<list:box-select>
								<list:item-select>
									<ui:source type="Static">
										[{text:'${ lfn:message('km-imeeting:kmImeeting.myAttend') }', value:'myAttend'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.myHaveAttend') }', value:'myHaveAttend'}
										,{text:'${lfn:message('km-imeeting:kmImeeting.Sum.my')}',value:'mySummary'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.myCreate') }', value:'myCreate'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.myApproval') }',value:'myApproval'}
										, {text:'${ lfn:message('km-imeeting:kmImeeting.myApproved') }', value: 'myApproved'}]
									</ui:source>
									<ui:event event="selectedChanged" args="evt">
											var vals = evt.values;
											LUI('status_for_myAttend').setEnable(false);
											LUI('status_for_myCreate').setEnable(false);
											LUI('status_for_myApproved').setEnable(false);
											if (vals.length > 0 && vals[0] != null) {
												var val = vals[0].value;
												if (val == 'myAttend' || val == 'myHaveAttend') {
													LUI('status_for_myAttend').setEnable(true);
												} else if (val == 'myCreate') {
													LUI('status_for_myCreate').setEnable(true);
												}else if (val == 'myApproved') {
													LUI('status_for_myApproved').setEnable(true);
												}
											}else{
												LUI('status_for_myCreate').setEnable(true);
											}
										</ui:event>
								</list:item-select>
							</list:box-select>
						</list:cri-criterion>
						<%-- 会议状态 --%>
						<list:cri-criterion title="${ lfn:message('km-imeeting:kmImeetingMain.docStatus') }" key="meetingStatus">
							<list:box-select>
								<list:item-select id="status_for_myAttend" cfg-enable="false">
									<ui:source type="Static">
										[{text:'${ lfn:message('km-imeeting:kmImeeting.status.publish.unHold') }', value:'unHold'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.status.publish.holding') }', value:'holding'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.status.publish.hold') }', value:'hold'}
										]
									</ui:source>
								</list:item-select>
							</list:box-select>
						</list:cri-criterion>
						<list:cri-criterion title="${ lfn:message('km-imeeting:kmImeetingMain.docStatus') }" key="meetingStatus">
							<list:box-select>
								<list:item-select id="status_for_myCreate" >
									<ui:source type="Static">
										[{text:'${ lfn:message('km-imeeting:kmImeeting.status.publish.unHold') }', value:'unHold'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.status.publish.holding') }', value:'holding'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.status.publish.hold') }', value:'hold'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.status.draft') }', value:'10'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.status.append') }', value:'20'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.status.reject') }', value:'11'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.status.abandom') }', value:'00'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.status.publish') }', value:'30'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.status.cancel') }', value:'41'}
										]
									</ui:source>
								</list:item-select>
							</list:box-select>
						</list:cri-criterion>
						<list:cri-criterion title="${ lfn:message('km-imeeting:kmImeetingMain.docStatus') }" key="meetingStatus">
							<list:box-select>
								<list:item-select id="status_for_myApproved" cfg-enable="false">
									<ui:source type="Static">
										[{text:'${ lfn:message('km-imeeting:kmImeeting.status.publish.unHold') }', value:'unHold'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.status.publish.holding') }', value:'holding'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.status.publish.hold') }', value:'hold'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.status.append') }', value:'20'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.status.reject') }', value:'11'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.status.abandom') }', value:'00'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.status.publish') }', value:'30'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.status.cancel') }', value:'41'}
										]
									</ui:source>
								</list:item-select>
							</list:box-select>
						</list:cri-criterion>
					</list:criteria>
					
					<%-- 操作栏 --%>
					<div class="lui_list_operation">
						<table width="100%">
							<tr>
								<td class="lui_sort">
									${ lfn:message('list.orderType') }：
								</td>
								<td>
									<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
										<list:sort property="docCreateTime" text="${lfn:message('km-imeeting:kmImeetingMain.docCreateTime') }" group="sort.list" value="down"></list:sort>
										<list:sort property="docPublishTime" text="${lfn:message('km-imeeting:kmImeetingMain.docPublishTime') }" group="sort.list"></list:sort>
										<list:sort property="fdHoldDate" text="${lfn:message('km-imeeting:kmImeetingMain.fdHoldDate') }" group="sort.list"></list:sort>
									</ui:toolbar>
								</td>
								<td align="right">
									<ui:toolbar count="3" id="btnToolbar">
									    <kmss:authShow roles="ROLE_KMIMEETING_CREATE">
										   <ui:button  text="${lfn:message('button.add')}" onclick="addMeeting()" order="2" ></ui:button>
										</kmss:authShow>
										<kmss:auth
											requestURL="/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=deleteall&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
											requestMethod="GET">
									    	<ui:button id="del" text="${lfn:message('button.delete')}" order="4" onclick="delMeeting()" ></ui:button>
										</kmss:auth>
										<%-- 收藏 --%>
										<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
											<c:param name="fdTitleProName" value="fdName" />
											<c:param name="fdModelName"  value="com.landray.kmss.km.imeeting.model.KmImeetingMain" />
										</c:import>
									</ui:toolbar>
								</td>
							</tr>
						</table>
					</div>
					
					<list:listview id="meetingListview" channel="meetingChannel">
						<ui:source type="AjaxJson">
							{url:'/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=listChildren'}
						</ui:source>
						<list:colTable isDefault="true" layout="sys.ui.listview.columntable" 
							rowHref="/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=view&fdId=!{fdId}" name="columntable">
							<list:col-checkbox name="List_Selected" headerStyle="width:5%"></list:col-checkbox>
							<list:col-serial title="${ lfn:message('page.serial')}" headerStyle="width:5%"></list:col-serial>
							<list:col-html  title="${ lfn:message('km-imeeting:kmImeetingMain.fdName') }" style="text-align:left">
					 			{$ <span class="com_subject" >{%row['fdName']%}</span> $}
							</list:col-html>
							<list:col-auto props="fdHost;fdPlace;fdHoldDate;fdFinishDate;docCreator.fdName;docDept.fdName"></list:col-auto>
						</list:colTable>
					</list:listview>
					<%-- 列表分页 --%>
			  		<list:paging channel="meetingChannel"></list:paging>
					<script type="text/javascript">
						seajs.use(['lui/jquery','lui/dialog'], function($, dialog ) {
							//新建会议
					 		window.addMeeting = function() {
					 			dialog.categoryForNewFile(
									'com.landray.kmss.km.imeeting.model.KmImeetingTemplate',
									'/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=add&fdTemplateId=!{id}',false,null,null,'${param.categoryId}');
						 	};
						 	//删除
					 		window.delMeeting = function(){
					 			var values = [];
								$("input[name='List_Selected']:checked").each(function(){
										values.push($(this).val());
									});
								if(values.length==0){
									dialog.alert('<bean:message key="page.noSelect"/>');
									return;
								}
								dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(value){
									if(value==true){
										window.del_load = dialog.loading();
										$.post('<c:url value="/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=deleteall"/>',
												$.param({"List_Selected":values},true),function(data){
											if(window.del_load!=null)
												window.del_load.hide();
											if(data!=null && data.status==true){
												topic.publish("list.refresh");
												dialog.success('<bean:message key="return.optSuccess" />');
											}else{
												dialog.failure('<bean:message key="return.optFailure" />');
											}
										},'json');
									}
								});
							};
							
						});
					</script>
				</ui:content>
				
				<%--我的纪要--%>
				<ui:content title="${ lfn:message('km-imeeting:kmImeetingSummary.summary.my') }" style="padding:0;background-color:#f2f2f2;" >
					<list:criteria id="summaryCriteria" expand="true" channel="summaryChannel">
						<%-- 我的纪要会议 --%>
						<list:cri-criterion title="${ lfn:message('km-imeeting:kmImeeting.tree.mySummary') }" key="mysummary" multi="false">
							<list:box-select>
								<list:item-select>
									<ui:source type="Static">
										[{text:'${ lfn:message('km-imeeting:kmImeeting.summary.myCreate') }', value:'myCreate'}
										,{text:'${ lfn:message('km-imeeting:kmImeeting.summary.myApproval') }',value:'myApproval'}
										, {text:'${ lfn:message('km-imeeting:kmImeeting.summary.myApproved') }', value: 'myApproved'}]
									</ui:source>
								</list:item-select>
							</list:box-select>
						</list:cri-criterion>
						<%-- 状态 --%>
						<list:cri-criterion title="${ lfn:message('km-imeeting:kmImeetingSummary.docStatus') }" key="docStatus">
							<list:box-select>
								<list:item-select>
									<ui:source type="Static">
											[{text:'${ lfn:message('status.draft')}', value:'10'},
											{text:'${ lfn:message('status.examine')}',value:'20'},
											{text:'${ lfn:message('status.refuse')}',value:'11'},
											{text:'${ lfn:message('status.discard')}',value:'00'},
											{text:'${ lfn:message('status.publish')}',value:'30'}]
									</ui:source>
								</list:item-select>
							</list:box-select>
						</list:cri-criterion>
					</list:criteria>
					
					<%-- 操作栏 --%>
					<div class="lui_list_operation">
						<table width="100%">
							<tr>
								<td class="lui_sort">
									${ lfn:message('list.orderType') }：
								</td>
								<td>
									<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
										<list:sort property="docCreateTime" text="${lfn:message('km-imeeting:kmImeetingSummary.docCreateTime') }" group="sort.list" value="down"></list:sort>
										<list:sort property="docPublishTime" text="${lfn:message('km-imeeting:kmImeetingSummary.docPublishTime') }" group="sort.list"></list:sort>
									</ui:toolbar>
								</td>
								<td align="right">
									<ui:toolbar count="3" id="btnToolbar2">
									    <kmss:authShow roles="ROLE_KMIMEETING_SUMMARY_CREATE">
										   <ui:button  text="${lfn:message('button.add')}" onclick="addSummary()" order="2" ></ui:button>
										</kmss:authShow>
										<kmss:auth
											requestURL="/km/meeting/km_imeeting_summary/kmImeetingSummary.do?method=deleteall&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
											requestMethod="GET">
									    	<ui:button id="del" text="${lfn:message('button.delete')}" order="4" onclick="delSummary()"></ui:button>
										</kmss:auth>
										<%-- 收藏 --%> 
										<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
											<c:param name="fdTitleProName" value="fdName" />
											<c:param name="fdModelName"	value="com.landray.kmss.km.imeeting.model.KmImeetingSummary" />
										</c:import>
									</ui:toolbar>
								</td>
							</tr>
						</table>
					</div>
					<ui:fixed elem=".lui_list_operation"></ui:fixed>
					
					<%-- 列表视图 --%>
					<list:listview id="listview" channel="summaryChannel">
						<ui:source type="AjaxJson">
									{url:'/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=listChildren'}
						</ui:source>
						<list:colTable isDefault="true" layout="sys.ui.listview.columntable" 
							rowHref="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=view&fdId=!{fdId}" name="columntable">
							<list:col-checkbox name="List_Selected" headerStyle="width:5%"></list:col-checkbox>
							<list:col-serial title="${ lfn:message('page.serial')}" headerStyle="width:5%"></list:col-serial>
							<list:col-html  title="${ lfn:message('km-imeeting:kmImeetingSummary.fdName') }" style="text-align:left">
							 {$ <span class="com_subject" >{%row['fdName']%}</span> $}
							</list:col-html>
							<list:col-auto props="fdHost;fdPlace;fdHoldDate;fdFinishDate;docCreator.fdName;docCreateTime"></list:col-auto>
						</list:colTable>
					</list:listview>
				 	<list:paging channel="summaryChannel"></list:paging>
				 	
				 	<script type="text/javascript">
					 	seajs.use(['lui/jquery', 'lui/dialog'], function($, dialog ) {
					 		//新建会议
					 		window.addSummary = function() {
									dialog.categoryForNewFile(
											'com.landray.kmss.km.imeeting.model.KmImeetingTemplate',
											'/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=add&fdTemplateId=!{id}',false,null,null,'${param.categoryId}');
						 	};
							//删除
					 		window.delSummary = function(){
					 			var values = [];
								$("input[name='List_Selected']:checked").each(function(){
										values.push($(this).val());
									});
								if(values.length==0){
									dialog.alert('<bean:message key="page.noSelect"/>');
									return;
								}
								dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(value){
									if(value==true){
										window.del_load = dialog.loading();
										$.post('<c:url value="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=deleteall"/>',
												$.param({"List_Selected":values},true),function(data){
											if(window.del_load!=null)
												window.del_load.hide();
											if(data!=null && data.status==true){
												topic.publish("list.refresh");
												dialog.success('<bean:message key="return.optSuccess" />');
											}else{
												dialog.failure('<bean:message key="return.optFailure" />');
											}
										},'json');
									}
								});
							};
					 	});
				 	</script>
				</ui:content>
			</ui:tabpanel>
		</div>	
	</template:replace>
</template:include>