<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="TA" value="${param.zone_TA}"/>
<c:set var="userId" value="${empty param.userId ? KMSS_Parameter_CurrentUserId : param.userId}"/>
<template:include ref="zone.navlink">
	<template:replace name="title">
		<c:out value="${ lfn:message('km-doc:module.km.doc') }"></c:out>
	</template:replace>
	<template:replace name="content">
		
		<list:criteria id="criteria1" expand="true">
			<list:cri-criterion title="${lfn:message(lfn:concat('km-doc:kmDoc.zone.doc.', TA)) }" key="tadoc"> 
				<list:box-select>
					<list:item-select id="tadoc1" cfg-required="true" cfg-defaultValue="create">
						<ui:source type="Static">
						    [{text:'${lfn:message(lfn:concat('km-doc:kmDoc.zone.doc.create.', TA)) }', value:'create'},
						    {text:'${lfn:message(lfn:concat('km-doc:kmDoc.zone.doc.author.', TA)) }', value:'author'},
						    {text:'${lfn:message(lfn:concat('km-doc:kmDoc.zone.doc.evaluation.', TA)) }', value:'evaluation'},
						    {text:'${lfn:message(lfn:concat('km-doc:kmDoc.zone.doc.introduce.', TA)) }', value:'introduce'}]
						</ui:source>
						<ui:event event="selectedChanged" args="evt">
							var vals = evt.values;
							if (vals.length > 0 && vals[0] != null) {
								var val = vals[0].value;
								if (val == 'create' || val == 'author') {
									LUI('status1').setEnable(true);
								} else {
									LUI('status1').setEnable(false);
								}
							}
						</ui:event>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
				<list:cri-criterion title="${ lfn:message('sys-doc:sysDocBaseInfo.docStatus')}" key="docStatus"> 
				<list:box-select>
					<list:item-select id="status1">
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
		<div class="lui_list_operation">
			<table width="100%">
				<tr>
					<td style='width: 70px;'>
						${ lfn:message('list.orderType') }：
					</td>
					<td>
						<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
							<list:sort property="docCreateTime" text="${lfn:message('sys-doc:sysDocBaseInfo.docCreateTime') }" group="sort.list" value="down"></list:sort>
							<list:sort property="docPublishTime" text="${lfn:message('km-doc:kmDoc.kmDocKnowledge.docPublishTime') }" group="sort.list"></list:sort>
						</ui:toolbar>
					</td>
					<td align="right">
						<ui:toolbar count="3">
							<ui:togglegroup order="0">
							    <ui:toggle icon="lui_icon_s_zaiyao" title="${ lfn:message('list.rowTable') }" 
									selected="true"group="tg_1" text="${ lfn:message('list.rowTable') }" value="rowtable"
									onclick="LUI('listview').switchType(this.value);">
								</ui:toggle>
								<ui:toggle icon="lui_icon_s_liebiao" title="${ lfn:message('list.columnTable') }" 
									value="columntable"  group="tg_1" text="${ lfn:message('list.columnTable') }" 
									onclick="LUI('listview').switchType(this.value);">
								</ui:toggle>
							</ui:togglegroup>
							<%-- 收藏 --%>
							<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
								<c:param name="fdTitleProName" value="docSubject" />
								<c:param name="fdModelName"	value="com.landray.kmss.km.doc.model.KmDocKnowledge" />
							</c:import>
						</ui:toolbar>
					</td>
				</tr>
			</table>
		</div>
		
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		
		<c:set var="moreParam" value="&userid=${userId}" />
		<%@ include file="/km/doc/km_doc_ui/kmDocKnowledge_listtable.jsp" %>
	</template:replace>
</template:include>
