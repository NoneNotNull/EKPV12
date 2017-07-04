<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="TA" value="${param.zone_TA}"/>
<template:include ref="zone.navlink">
	<template:replace name="title">
		<c:out value="${ lfn:message('km-imissive:kmImissive.tree.title') }"></c:out>
	</template:replace>
	<template:replace name="content">  
	<div style="width:100%">
	  <ui:tabpanel layout="sys.ui.tabpanel.light" >
	     <%--发文--%>
		 <ui:content title="${ lfn:message(lfn:concat('km-imissive:kmImissiveSendMain.Send.', TA)) }" style="padding:0;background-color:#f2f2f2;" >
		  <list:criteria id="sendCriteria" expand="true" channel="status1">
				<list:cri-criterion title="${ lfn:message(lfn:concat('km-imissive:kmImissiveSendMain.Send.', TA)) }" key="tasend" multi="false"> 
					<list:box-select>
						<list:item-select cfg-required="true" cfg-defaultValue="create">
							<ui:source type="Static">
								[{text:'${ lfn:message(lfn:concat('km-imissive:kmImissive.tree.create.', TA)) }', value:'create'}
								,{text:'${ lfn:message(lfn:concat('km-imissive:kmImissive.tree.sign.', TA)) }', value: 'sign'}]
							</ui:source>
							<ui:event event="selectedChanged" args="evt">
								var vals = evt.values;
								if (vals.length > 0 && vals[0] != null) {
									var val = vals[0].value;
									if (val == 'create') {
										LUI('tasend1').setEnable(true);
										LUI('tasend2').setEnable(false);
									} else{
									    LUI('tasend1').setEnable(false);
										LUI('tasend2').setEnable(true);
									}
								}
							</ui:event>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
				<list:cri-criterion title="${ lfn:message('km-imissive:kmImissiveSendMain.docStatus')}" key="docStatus"> 
					<list:box-select>
						<list:item-select id="tasend1" cfg-enable="true">
							<ui:source type="Static">
								[{text:'${ lfn:message('status.draft')}', value:'10'}
								,{text:'${ lfn:message('status.examine')}',value:'20'}
								,{text:'${ lfn:message('status.refuse')}',value:'11'}
								,{text:'${ lfn:message('status.discard')}',value:'00'}
								,{text:'${ lfn:message('status.publish')}',value:'30'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
				<list:cri-criterion title="${ lfn:message('km-imissive:kmImissiveSendMain.docStatus')}" key="docStatus"> 
					<list:box-select>
						<list:item-select id="tasend2" cfg-enable="false">
							<ui:source type="Static">
								[{text:'${ lfn:message('status.examine')}',value:'20'}
								,{text:'${ lfn:message('status.refuse')}',value:'11'}
								,{text:'${ lfn:message('status.discard')}',value:'00'}
								,{text:'${ lfn:message('status.publish')}',value:'30'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
			</list:criteria>
			<div class="lui_list_operation" id="lui_list_operation_send">
				<table width="100%">
					<tr>
						<td style='width: 70px;'>
							${ lfn:message('list.orderType') }：
						</td>
						<td>
							<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
								<list:sort property="docCreateTime" text="${lfn:message('km-imissive:kmImissiveSendMain.docCreateTime') }" group="sort.list" value="down"></list:sort>
								<list:sort property="docPublishTime" text="${lfn:message('km-imissive:kmImissiveSendMain.docPublishTime') }" group="sort.list"></list:sort>
							    <list:sort property="fdDocNum" text="${ lfn:message('km-imissive:kmImissiveSendMain.fdDocNum') }" group="sort.list"></list:sort>
							</ui:toolbar>
						</td>
						<td align="right">
							<ui:toolbar count="3">
								<%-- 收藏 --%>
								<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
									<c:param name="fdTitleProName" value="docSubject" />
									<c:param name="fdModelName"	value="com.landray.kmss.km.imissive.model.kmImissiveSendMain" />
								</c:import>
							</ui:toolbar>
						</td>
					</tr>
				</table>
			</div>
			<ui:fixed elem="#lui_list_operation_send"></ui:fixed>
			<list:listview id="listview1" channel="status1">
				<ui:source type="AjaxJson">
						{url:'/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=listChildren&userid=${zone_user.fdId}'}
				</ui:source>
				<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
					rowHref="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=view&fdId=!{fdId}"  name="columntable">
					<list:col-checkbox></list:col-checkbox>
					<list:col-serial></list:col-serial>
					<list:col-auto props=""></list:col-auto>
				</list:colTable>
			</list:listview>
		 	<list:paging channel="status1"></list:paging>	
		 </ui:content>
		  <%--收文--%>
		 <ui:content title="${ lfn:message(lfn:concat('km-imissive:kmImissiveReceiveMain.Receive.', TA)) }" style="padding:0;background-color:#f2f2f2;" >
			  <list:criteria id="receiveCriteria" expand="true" channel="status2">
		      <list:cri-criterion title="${ lfn:message(lfn:concat('km-imissive:kmImissiveReceiveMain.Receive.', TA)) }" key="taReceive" multi="false">
					<list:box-select>
						<list:item-select cfg-required="true" cfg-defaultValue="create">
							<ui:source type="Static">
							   [{text:'${ lfn:message(lfn:concat('km-imissive:kmImissive.tree.create.', TA)) }', value:'create'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
				<list:cri-criterion title="${ lfn:message('km-imissive:kmImissiveReceiveMain.docStatus')}" key="docStatus"> 
					<list:box-select>
						<list:item-select id="taReceive1" cfg-enable="true">
							<ui:source type="Static">
								[{text:'${ lfn:message('status.draft')}', value:'10'}
								,{text:'${ lfn:message('status.examine')}',value:'20'}
								,{text:'${ lfn:message('status.refuse')}',value:'11'}
								,{text:'${ lfn:message('status.discard')}',value:'00'}
								,{text:'${ lfn:message('status.publish')}',value:'30'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
		  </list:criteria>
			<div class="lui_list_operation" id="lui_list_operation_Receive">
				<table width="100%">
					<tr>
						<td style='width: 70px;'>
							${ lfn:message('list.orderType') }：
						</td>
						<td>
							<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
								<list:sort property="docCreateTime" text="${lfn:message('km-imissive:kmImissiveReceiveMain.docCreateTime') }" group="sort.list" value="down"></list:sort>
								<list:sort property="docPublishTime" text="${lfn:message('km-imissive:kmImissiveReceiveMain.docPublishTime') }" group="sort.list"></list:sort>
								<list:sort property="fdReceiveNum" text="${lfn:message('km-imissive:kmImissiveReceiveMain.fdReceiveNum') }" group="sort.list"></list:sort>
							</ui:toolbar>
						</td>
						<td align="right">
							<ui:toolbar count="3">
								<%-- 收藏 --%>
								<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
									<c:param name="fdTitleProName" value="docSubject" />
									<c:param name="fdModelName"	value="com.landray.kmss.km.imissive.model.kmImissiveReceiveMain" />
								</c:import>
							</ui:toolbar>
						</td>
					</tr>
				</table>
			</div>
			<ui:fixed elem="#lui_list_operation_Receive"></ui:fixed>
			<list:listview id="listview2" channel="status2">
				<ui:source type="AjaxJson">
						{url:'/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=listChildren&userid=${zone_user.fdId}'}
				</ui:source>
				<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
					rowHref="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=view&fdId=!{fdId}"  name="columntable">
					<list:col-checkbox></list:col-checkbox>
					<list:col-serial></list:col-serial>
					<list:col-auto props=""></list:col-auto>
				</list:colTable>
			</list:listview> 
		 	<list:paging channel="status2"></list:paging>	 
		 </ui:content>
		   <%--签报--%>
		 <ui:content title="${ lfn:message(lfn:concat('km-imissive:kmImissiveSignMain.Sign.', TA)) }" style="padding:0;background-color:#f2f2f2;" >
		  <list:criteria id="signCriteria" expand="true" channel="status3">
				<list:cri-criterion title="${ lfn:message(lfn:concat('km-imissive:kmImissiveSignMain.Sign.', TA)) }" key="tasign" multi="false">
					<list:box-select>
						<list:item-select cfg-required="true" cfg-defaultValue="create">
							<ui:source type="Static">
								[{text:'${ lfn:message(lfn:concat('km-imissive:kmImissive.tree.create.', TA)) }', value:'create'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
				<list:cri-criterion title="${ lfn:message('km-imissive:kmImissiveSignMain.docStatus')}" key="docStatus"> 
					<list:box-select>
						<list:item-select id="tasign1" cfg-enable="true">
							<ui:source type="Static">
								[{text:'${ lfn:message('status.draft')}', value:'10'}
								,{text:'${ lfn:message('status.examine')}',value:'20'}
								,{text:'${ lfn:message('status.refuse')}',value:'11'}
								,{text:'${ lfn:message('status.discard')}',value:'00'}
								,{text:'${ lfn:message('status.publish')}',value:'30'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
			</list:criteria>
			<div class="lui_list_operation" id="lui_list_operation_sign">
				<table width="100%">
					<tr>
						<td style='width: 70px;'>
							${ lfn:message('list.orderType') }：
						</td>
						<td>
							<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
								<list:sort property="docCreateTime" text="${lfn:message('km-imissive:kmImissiveSignMain.docCreateTime') }" group="sort.list" value="down"></list:sort>
								<list:sort property="docPublishTime" text="${lfn:message('km-imissive:kmImissiveSignMain.docPublishTime') }" group="sort.list"></list:sort>
							    <list:sort property="fdDocNum" text="${ lfn:message('km-imissive:kmImissiveSignMain.fdDocNum') }" group="sort.list"></list:sort>
							</ui:toolbar>
						</td>
						<td align="right">
							<ui:toolbar count="3">
								<%-- 收藏 --%>
								<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
									<c:param name="fdTitleProName" value="docSubject" />
									<c:param name="fdModelName"	value="com.landray.kmss.km.imissive.model.kmImissiveSignMain" />
								</c:import>
							</ui:toolbar>
						</td>
					</tr>
				</table>
			</div>
			<ui:fixed elem="#lui_list_operation_sign"></ui:fixed>
			<list:listview id="listview3" channel="status3">
				<ui:source type="AjaxJson">
						{url:'/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=listChildren&userid=${zone_user.fdId}'}
				</ui:source>
				<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
					rowHref="/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=view&fdId=!{fdId}"  name="columntable">
					<list:col-checkbox></list:col-checkbox>
					<list:col-serial></list:col-serial>
					<list:col-auto props=""></list:col-auto>
				</list:colTable>
			</list:listview>
		 	<list:paging channel="status3"></list:paging>	
		 </ui:content>
	  </ui:tabpanel>
     </div> 
	</template:replace>
</template:include>
