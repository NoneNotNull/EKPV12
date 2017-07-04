<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="TA" value="${param.zone_TA}"/>
<template:include ref="zone.navlink"> 
	<template:replace name="title">${ lfn:message('km-forum:home.nav.kmForum') }</template:replace>
	<template:replace name="content">
		<list:criteria id="criteria1" expand="true">
		    <list:cri-criterion title="${lfn:message(lfn:concat('km-forum:menu.kmForum.',TA))}" key="topic" multi="false">
				<list:box-select>
					<list:item-select cfg-defaultValue="create" cfg-required="true">
						<ui:source type="Static">
						    [{text:'${lfn:message(lfn:concat('km-forum:menu.kmForum.Create.',TA))}', value:'create'},
							 {text:'${lfn:message(lfn:concat('km-forum:menu.kmForum.Attend.',TA))}', value:'attend'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<%--板块--%>  
		    <list:cri-ref ref="criterion.sys.simpleCategory" key="category" multi="false" title="${lfn:message('km-forum:menu.kmForum.manage.nav')}" expand="true">
			  <list:varParams modelName="com.landray.kmss.km.forum.model.KmForumCategory"/>
			</list:cri-ref>
		</list:criteria>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		   <!-- 排序 -->
		<div class="lui_list_operation">
			<table width="100%">
				<tr>
					<td  class="lui_sort">
						${ lfn:message('list.orderType') }：
					</td>
					<td>
						<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="6" >
							<list:sort property="fdLastPostTime" text="${lfn:message('km-forum:kmForumTopic.order.fdLastPostTime')}" group="sort.list" value="down"></list:sort>
							<list:sort property="docCreateTime" text="${lfn:message('km-forum:kmForumTopic.order.docCreateTime')}" group="sort.list"></list:sort>
							<list:sort property="fdReplyCount;fdHitCount" text="${lfn:message('km-forum:kmForumTopic.order.replyAndHit')}" group="sort.list"></list:sort>
						</ui:toolbar>
					</td>
					<td align="right">
						<ui:toolbar count="3" id="btnToolBar">
							<%-- 收藏 --%>
							<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
								<c:param name="fdTitleProName" value="docSubject" />
								<c:param name="fdModelName"	value="com.landray.kmss.km.forum.model.KmForumTopic" />
							</c:import>
						</ui:toolbar>
					</td>
				</tr>
			</table>
		</div>
    	<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/km/forum/km_forum/kmForumTopic.do?method=listPersonOrZone&type=zone&userId=${zone_user.fdId}'}
			</ui:source>
			<list:colTable isDefault="true" layout="sys.ui.listview.columntable" 
			    rowHref="/km/forum/km_forum/kmForumPost.do?method=view&fdForumId=!{kmForumCategory.fdId}&fdTopicId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props=""></list:col-auto>
			</list:colTable>
		</list:listview> 
	 	<list:paging></list:paging>	 
	</template:replace>
</template:include>
