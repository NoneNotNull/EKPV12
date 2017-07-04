<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.home">
	<template:replace name="title">
		<c:out value="${lfn:message('sys-follow:sysFollow.person.my') }"/>
	</template:replace>
	<template:replace name="content">
		<list:criteria id="criteria1" expand="true">
			<list:cri-criterion title="${lfn:message('sys-follow:sysFollow.list.type') }" key="selfdoc" multi="false"> 
				<list:box-select>
					<list:item-select id="mydoc" cfg-required="true" cfg-defaultValue="new">
						<ui:source type="Static">
						    [{text:'${lfn:message('sys-follow:sysFollow.portlet.new') }', value:'new'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-criterion title="${lfn:message('sys-follow:sysFollow.list.byStatus') }" key="read" multi="false"> 
				<list:box-select>
					<list:item-select id="read" >
						<ui:source type="Static">
						    [{text:"${lfn:message('sys-follow:sysFollowRelatedDoc.fdStatus.yes') }", value:'1'},
						     {text:"${lfn:message('sys-follow:sysFollowRelatedDoc.fdStatus.no') }", value:'0'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<%--类型筛选 --%>
			<list:cri-criterion
				title="${lfn:message('sys-follow:sysFollow.list.type.criteria')}" expand="false"
				key="followtype">
				<list:box-select>
					<list:item-select type="lui/criteria!CriterionHierarchyDatas">
						<ui:source type="AjaxJson">
							{url: "/sys/follow/sys_follow_person_doc_related/sysFollowPersonDocRelated.do?method=criteria&parentId=!{value}&orgType=3&__hierarchy=true"}
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
		</list:criteria>
		<div class="lui_list_operation">
				<table width="100%">
					<tr>
						<td style='width: 60px;'>${ lfn:message('list.orderType') }：</td>
						<td>
							<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
								<list:sort property="sysFollowDoc.docCreateTime" 
										   text="${lfn:message('sys-follow:sysFollowPersonDocRelated.readTime') }" 
										   group="sort.list" value="down"></list:sort>
							</ui:toolbar>
						</td>
						
						<td align="right">
							<ui:toolbar count="4">
								<ui:button 
									text="${lfn:message('sys-follow:sysFoloow.list.button.config')}"  
									href="/sys/person/setting.do?setting=sys_follow_person_config"
									target="_blank"/>
							</ui:toolbar>
						</td>
					</tr>
				</table>
		</div>	
		<ui:fixed elem=".lui_list_operation"></ui:fixed>	
		<%--list视图--%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/sys/follow/sys_follow_person_doc_related/sysFollowPersonDocRelated.do?method=listPerson&rowsize=16'}
			</ui:source>
			<%--列表形式--%>
			<list:colTable layout="sys.ui.listview.columntable" name="columntable"
			rowHref="/sys/follow/sys_follow_doc/sysFollowDoc.do?method=view&fdId=!{fdId}">
					<list:col-serial title="${ lfn:message('page.serial') }" headerStyle="width:5%"/> 
					<list:col-html title="${ lfn:message('sys-follow:sysFollowDoc.docSubject') }" style="width:45%;text-align:left;padding:0 8px" headerStyle="width:45%">
					 {$	 
						<span class="com_subject">{% row['docSubject']%}</span>
					 $}
					</list:col-html>
					<list:col-html title="${lfn:message('sys-follow:sysFollow.list.from') }" style="width:25%" headerStyle="width:25%">
					 {$	 
						{% row['from']%}
					 $}
					</list:col-html>
					<list:col-html title="${lfn:message('sys-follow:sysFollow.list.status') }" style="width:10%" headerStyle="width:10%">
					 {$	 
						{% row['status']%}
					 $}
					</list:col-html>
					<list:col-html title="${lfn:message('sys-follow:sysFollow.list.time') }" style="width:15%" headerStyle="width:15%">
					 {$	 
						{% row['docCreateTime']%}
					 $}
					</list:col-html>
			</list:colTable>
		</list:listview> 
	 	<list:paging></list:paging>
	</template:replace>
</template:include>