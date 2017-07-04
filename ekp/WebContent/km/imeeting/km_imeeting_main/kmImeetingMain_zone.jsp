<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="TA" value="${param.zone_TA}"/>
<template:include ref="zone.navlink"> 
	<template:replace name="title">${ lfn:message('km-imeeting:module.km.imeeting') }</template:replace>
	<template:replace name="content"> 
		<div style="width:100%">		
			<ui:tabpanel layout="sys.ui.tabpanel.light" >
				<%--TA的会议--%>
				<ui:content title="${ lfn:message(lfn:concat('km-imeeting:kmImeeting.tree.meetings.',TA))}" style="padding:0;background-color:#f2f2f2;" >
					<%--会议类型--%>
					<list:criteria id="meetingCriteria" expand="true" channel="meetingChannel">
						<list:cri-criterion title="${ lfn:message(lfn:concat('km-imeeting:kmImeeting.tree.meetings.',TA))}" key="tameeting" multi="false">
							<list:box-select>
								<list:item-select cfg-defaultValue="attend" cfg-required="true">
									<ui:source type="Static">
										[{text:'${ lfn:message(lfn:concat('km-imeeting:kmImeeting.Attend.', TA)) }', value:'attend'}
										,{text:'${ lfn:message(lfn:concat('km-imeeting:kmImeeting.Create.', TA)) }', value:'create'}
										,{text:'${ lfn:message(lfn:concat('km-imeeting:kmImeeting.Host.', TA)) }', value:'host'}
										,{text:'${ lfn:message(lfn:concat('km-imeeting:kmImeeting.Emcc.', TA)) }', value:'emcc'}
										,{text:'${ lfn:message(lfn:concat('km-imeeting:kmImeeting.Sum.', TA)) }', value:'sum'}]
									</ui:source>
									<ui:event event="selectedChanged" args="evt">
										var vals = evt.values;
										if (vals.length > 0 && vals[0] != null) {
											var val = vals[0].value;
											if (val == 'attend'||val == 'host'||val == 'emcc'||val == 'sum') {
												LUI('meetingStatusCri1').setEnable(true);
												LUI('meetingStatusCri2').setEnable(false);
											} else if (val == 'create') {
											    LUI('meetingStatusCri1').setEnable(false);
												LUI('meetingStatusCri2').setEnable(true);
											}
										}
									</ui:event>
								</list:item-select>
							</list:box-select>
						</list:cri-criterion>
						<%--会议状态--%>
						<list:cri-criterion title="${ lfn:message('km-imeeting:kmImeetingMain.docStatus') }" key="meetingStatus">
							<list:box-select>
								<list:item-select id="meetingStatusCri1" cfg-enable="true">
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
								<list:item-select id="meetingStatusCri2" cfg-enable="false">
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
					
					
					<div class="lui_list_operation">
						<table width="100%">
							<tr>
								<td class="lui_sort">${ lfn:message('list.orderType') }：</td>
								<td>
									<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
										<list:sort property="docCreateTime" text="${lfn:message('km-imeeting:kmImeetingMain.docCreateTime') }" group="sort.list" value="down"></list:sort>
										<list:sort property="docPublishTime" text="${lfn:message('km-imeeting:kmImeetingMain.docPublishTime') }" group="sort.list"></list:sort>
										<list:sort property="fdHoldDate" text="${lfn:message('km-imeeting:kmImeetingMain.fdHoldDate') }" group="sort.list"></list:sort>
									</ui:toolbar>
								</td>
								<td align="right">
									<ui:toolbar >
										<%-- 收藏 --%>
										<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
											<c:param name="fdTitleProName" value="fdName" />
											<c:param name="fdModelName"	value="com.landray.kmss.km.imeeting.model.KmImeetingMain" />
										</c:import>
									</ui:toolbar>						
								</td>
							</tr>
						</table>
					</div>
					<list:listview id="meetingListview" channel="meetingChannel">
						<ui:source type="AjaxJson">
							{url:'/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=listChildren&userid=${zone_user.fdId}'}
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
				</ui:content>
				
				<%--TA的纪要--%>
				<ui:content title="${ lfn:message(lfn:concat('km-imeeting:kmImeetingSummary.summary.', TA)) }" style="padding:0;background-color:#f2f2f2;" >
					<list:criteria id="summaryCriteria" expand="true" channel="summaryChannel">
						<list:cri-criterion title="${ lfn:message(lfn:concat('km-imeeting:kmImeetingSummary.summary.', TA)) }" key="tasummary" multi="false">
							<list:box-select>
								<list:item-select  cfg-required="true" cfg-defaultValue="create">
									<ui:source type="Static">
										[{text:'${ lfn:message(lfn:concat('km-imeeting:kmImeetingSummary.Summary.create.', TA)) }', value:'create'}]
									</ui:source>
								</list:item-select>
							</list:box-select>
						</list:cri-criterion> 
						<list:cri-criterion title="${ lfn:message('km-imeeting:kmImeetingSummary.docStatus')}" key="docStatus"> 
							<list:box-select>
								<list:item-select>
									<ui:source type="Static">
										[{text:'${ lfn:message('status.examine')}',value:'20'},
										{text:'${ lfn:message('status.refuse')}',value:'11'},
										{text:'${ lfn:message('status.discard')}',value:'00'},
										{text:'${ lfn:message('status.publish')}',value:'30'}]
									</ui:source>
								</list:item-select>
							</list:box-select>
						</list:cri-criterion>
					</list:criteria>
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
									<ui:toolbar >
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
					<list:listview id="summaryListview" channel="summaryChannel">
						<ui:source type="AjaxJson">
								{url:'/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=listChildren&userid=${zone_user.fdId}'}
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
					<%-- 列表分页 --%>
			  		<list:paging channel="summaryChannel"></list:paging>
				</ui:content>
			</ui:tabpanel>
		</div>
	</template:replace>
</template:include>