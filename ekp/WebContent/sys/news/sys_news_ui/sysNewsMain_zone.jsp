<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="TA" value="${param.zone_TA}"/>
<c:set var="userId" value="${empty param.userId ? KMSS_Parameter_CurrentUserId : param.userId}"/>
<template:include ref="zone.navlink">
	<template:replace name="title">${lfn:message('sys-news:table.sysNewsMain')}</template:replace>
	<template:replace name="content">
		<list:criteria id="criteria1" expand="true">
		    <list:cri-criterion title="${lfn:message(lfn:concat('sys-news:sysNews.sysNewsMain.',TA))}" key="taNews" multi="false">
				<list:box-select>
					<list:item-select cfg-defaultValue="create" cfg-required="true">
						<ui:source type="Static">
						    [{text:'${lfn:message(lfn:concat('sys-news:sysNews.sysNewsMain.create.',TA))}', value:'create'},
							 {text:'${lfn:message(lfn:concat('sys-news:sysNews.sysNewsMain.ev.',TA))}', value:'ev'}]
						</ui:source>
						<ui:event event="selectedChanged" args="evt">
								var vals = evt.values;
								if (vals.length > 0 && vals[0] != null) {
									var val = vals[0].value;
									if (val == 'create') {
										LUI('docStatus').setEnable(true);
									} else{
									  	LUI('docStatus').setEnable(false);
									}
								}
							</ui:event>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-criterion title="${lfn:message('sys-news:sysNews.sysNewsMain.status')}" key="docStatus" > 
				<list:box-select>
					<list:item-select id="docStatus" cfg-enable="false">
						<ui:source type="Static">
							   [{text:'${ lfn:message('sys-news:status.draft') }',value:'10'},
							    {text:'${ lfn:message('sys-news:status.examine') }',value:'20'},
								{text:'${ lfn:message('sys-news:status.refuse') }', value: '11'},
								{text:'${ lfn:message('sys-news:status.discard') }',value:'00'},
								{text:'${ lfn:message('sys-news:status.publish') }',value:'30'},
								{text:'${ lfn:message('sys-news:status.cancle') }',value:'40'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
		</list:criteria>
		
		<!-- 排序 -->
		<div class="lui_list_operation">
			<table width="100%">
				<tr>
					<td  class="lui_sort">
						${ lfn:message('list.orderType') }：
					</td>
					<td>
						<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="6" >
							<list:sort property="fdIsTop;fdTopTime;docAlterTime" text="${lfn:message('sys-news:sysNewsMain.new') }" group="sort.list" value="down"></list:sort>
							<list:sort property="docPublishTime" text="${lfn:message('sys-news:sysNewsMain.docPublishTime') }" group="sort.list" ></list:sort>
							<list:sort property="docReadCount" text="${lfn:message('sys-news:sysNewsMain.docHits') }" group="sort.list"></list:sort>
						</ui:toolbar>
					</td>
					<td align="right">
						<ui:toolbar count="3" id="btnToolBar">
							<%-- 视图切换 --%>
							<ui:togglegroup order="0">
									 <ui:toggle icon="lui_icon_s_zaiyao" title="${ lfn:message('list.rowTable') }" 
										selected="true"  group="tg_1" text="${ lfn:message('list.rowTable') }" value="rowtable"
										onclick="LUI('listview').switchType(this.value);">
									</ui:toggle>
									<ui:toggle icon="lui_icon_s_liebiao" title="${ lfn:message('list.columnTable') }" 
										value="columntable"	group="tg_1" text="${ lfn:message('list.columnTable') }" 
										onclick="LUI('listview').switchType(this.value);">
									</ui:toggle>
							 </ui:togglegroup>
						
							<%-- 收藏 --%>
							<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
								<c:param name="fdTitleProName" value="docSubject" />
								<c:param name="fdModelName"	value="com.landray.kmss.sys.news.model.SysNewsMain" />
							</c:import>
						</ui:toolbar>
					</td>
				</tr>
			</table>
		</div>
		
	    <ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/sys/news/sys_news_main/sysNewsMainIndex.do?method=listChildren&categoryId=${param.categoryId}&type=zone&userId=${userId}'}
			</ui:source>
			
			<list:rowTable isDefault="true"
				rowHref="/sys/news/sys_news_main/sysNewsMain.do?method=view&fdId=!{fdId}" name="rowtable" >
				<list:row-template>
				 {$
					 <div class="clearfloat lui_listview_rowtable_summary_content_box">
						<dl>
							<dt>
								<input type="checkbox" data-lui-mark="table.content.checkbox" value="{%row.fdId%}" name="List_Selected"/>
								<span class="lui_listview_rowtable_summary_content_serial">{%row.index%}</span>
							</dt>	
						</dl>
					 <dl>	 
					  	<dt>
			                <a href="${KMSS_Parameter_ContextPath}sys/news/sys_news_main/sysNewsMain.do?method=view&fdId={%row.fdId%}" target="_blank" data-lui-mark-id="{%row.rowId%}">{%row.docSubject_row%}</a>
			             </dt>			
						<dd>
						    <span>{%str.textEllipsis(row['fdDescription_row'],150)%}</span>
						</dd>
						<dd class="lui_listview_rowtable_summary_content_box_foot_info">
				         	${lfn:message('sys-news:sysNewsMain.fdAuthorId') }：<em style="font-style: normal" class="com_author">{%row['fdWriterName_row']%}</em>
							<span>${lfn:message('sys-news:sysNewsMain.fdDepartmentIdBy') }：{%row['fdDepartment.fdName']%}</span>
							<span>{%row['docPublishTime_row']%}</span>
							<span>${lfn:message('sys-news:sysNewsPublishMain.fdImportance') }：{%row['fdImportance']%}</span>
							<span>{%row['docHits_row']%}</span>
							<span>{%row['sysTagMain_row']%}</span>
						</dd>
					</dl>
					</div>
				    $}		      
				</list:row-template>
			</list:rowTable>
			
			<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
				rowHref="/sys/news/sys_news_main/sysNewsMain.do?method=view&fdId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props="docSubject;fdImportance;docCreator.fdName;docPublishTime;docAlterTime;docHits;fdTopDays"></list:col-auto>
			</list:colTable>
		</list:listview> 
	 	<list:paging></list:paging>	 
	</template:replace>
</template:include>
