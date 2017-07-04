<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.home"> 
	<template:replace name="title">${ lfn:message('km-forum:home.nav.kmForum') }</template:replace>
	<template:replace name="content">
		<list:criteria id="criteria1" expand="true">
		    <list:cri-criterion title="${lfn:message('km-forum:menu.kmForum.my')}" key="topic" multi="false">
				<list:box-select>
					<list:item-select cfg-defaultValue="create" cfg-required="true">
						<ui:source type="Static">
						    [{text:'${lfn:message('km-forum:menu.kmForum.Create.my')}', value:'create'},
							 {text:'${lfn:message('km-forum:menu.kmForum.Attend.my')}', value:'attend'}]
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
							<%-- 发帖 --%>
							<kmss:auth requestURL="/km/coproject/km_coproject_main/kmCoprojectMain.do?method=add" requestMethod="GET">
								   <ui:button text="${lfn:message('km-forum:kmForum.button.publish')}" onclick="addDoc();"></ui:button>
							</kmss:auth>
						</ui:toolbar>
					</td>
				</tr>
			</table>
		</div>
    	<list:listview id="listview">
			<ui:source type="AjaxJson">
						{url:'/km/forum/km_forum/kmForumTopic.do?method=listPersonOrZone&type=person'}
			</ui:source>
			<list:colTable isDefault="true" layout="sys.ui.listview.columntable" 
				rowHref="/km/forum/km_forum/kmForumPost.do?method=view&fdForumId=!{kmForumCategory.fdId}&fdTopicId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props=""></list:col-auto>
			</list:colTable>
		</list:listview> 
	 	<list:paging></list:paging>	
	 	 <script type="text/javascript">
	  		    Com_IncludeFile("dialog.js");
				seajs.use(['lui/topic'], function(topic) {

					// 监听新建更新等成功后刷新
					topic.subscribe('successReloadPage', function() {
						topic.publish('list.refresh');
					});
					
					//新建
					var forumId;
					window.addDoc = function() {
						if(forumId==null||forumId==''){
						    Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumPost.do" />?method=add');
						}else{
							Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumPost.do" />?method=add&fdForumId='+forumId);
						}
					};
					
					 topic.subscribe('criteria.changed',function(evt){
							if(evt['criterions'].length>0){
	                          for(var i=0;i<evt['criterions'].length;i++){
	                              //类型change
	                        	  if(evt['criterions'][i].key=="category"){
	      							if(evt['criterions'][i].value.length==1){
	      								forumId=evt['criterions'][i].value[0];
	      							}
	      					       }
	                           }					
						     }
						});


				});
		 </script>	 
	</template:replace>
</template:include>
