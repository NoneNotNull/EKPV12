<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<template:include ref="default.view" sidebar="no" width="980px">
	<template:replace name="title">
		<c:out value="${lfn:message('km-forum:module.km.forum')}"></c:out>
	</template:replace>
	<template:replace name="head">  
	    <script type="text/javascript">
			seajs.use(['theme!list', 'theme!portal']);	
		</script>
		<portal:header var-width="980px" />
	</template:replace>
	<template:replace name="path">
			<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;">
				<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
				</ui:menu-item>
				<ui:menu-item text="${ lfn:message('km-forum:module.km.forum') }" href="/km/forum/" target="_self">
				</ui:menu-item>
			</ui:menu>
	</template:replace>
	<template:replace name="content">  
	    <style>
	       /*二级页面列表操作条*/
				.lui_list_operation{background-color:#e3f4fe;margin-top:-4px;border-top: 1px #b9d4e7 solid;border-bottom: 1px #b9d4e7 solid;padding:0px 10px; height:40px; line-height:40px;}
				.lui_list_nav_text{color:#f19703}
				.lui_sort{width: 65px;}
	    </style>
		<list:criteria id="criteria1">	
		   <%--主题--%>
		   <list:cri-ref key="docSubject" ref="criterion.sys.docSubject">
		   </list:cri-ref>
		   <%--板块--%>  
		   <list:cri-ref ref="criterion.sys.simpleCategory" key="categoryId" multi="false" title="${lfn:message('km-forum:menu.kmForum.manage.nav')}" expand="true">
			  <list:varParams modelName="com.landray.kmss.km.forum.model.KmForumCategory"/>
			</list:cri-ref>
		   <%--我的帖子--%>  
		   <list:cri-criterion title="${lfn:message('km-forum:kmForumIndex.myTopic')}" key="myTopic" multi="false">
				<list:box-select>
					<list:item-select cfg-defaultValue="${param.myTopic==null?'':param.myTopic}">
						<ui:source type="Static">
						    [{text:'${lfn:message('km-forum:menu.kmForum.Create.my')}', value:'create'},
							 {text:'${lfn:message('km-forum:menu.kmForum.Attend.my')}', value:'attend'}]
						</ui:source>
						<ui:event event="selectedChanged" args="evt">
								var vals = evt.values;
								if (vals.length > 0 && vals[0] != null) {
									var val = vals[0].value;
									if (val == 'create') {
										LUI('fdStatus').setEnable(true);
									} else{
										LUI('fdStatus').setEnable(false);
									}
								}else{
								        LUI('fdStatus').setEnable(false);
								}
					 </ui:event>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<%--状态--%>  
			<list:cri-criterion title="${lfn:message('km-forum:kmForumTopic.status')}" key="fdStatus" multi="false"> 
				<list:box-select>
					<list:item-select id="fdStatus" cfg-enable="false">
						<ui:source type="Static">
							  [ {text:'${ lfn:message('km-forum:kmForumTopic.status.draft') }',value:'10'},
								{text:'${ lfn:message('km-forum:kmForumTopic.status.publish') }',value:'30'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<!--作者、创建时间、更新时间 -->
			<list:cri-auto modelName="com.landray.kmss.km.forum.model.KmForumTopic" property="fdPoster;docCreateTime;docAlterTime" expand="false"/>
		    <!-- 其他查询 -->
			<list:cri-criterion title="${lfn:message('km-forum:kmForumTopic.otherSearch') }" key="fdOther" multi="false" expand="false">
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
							[{text:'${ lfn:message('km-forum:kmForumTopic.otherSearch.top') }',value:'top'},
						     {text:'${ lfn:message('km-forum:kmForumTopic.otherSearch.end') }',value:'end'},
							 {text:'${ lfn:message('km-forum:kmForumTopic.otherSearch.hot') }',value:'hot'},
							 {text:'${ lfn:message('km-forum:kmForumTopic.otherSearch.pink') }',value:'pink'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>	
		</list:criteria> 
       <%--板块信息--%>
    <c:if test="${not empty param.categoryId}">   
	    <iframe src="${LUI_ContextPath}/km/forum/km_forum_cate/kmForumCategory.do?method=main&type=criteria&categoryId=${param.categoryId}" id="forumCategory" width="100%" frameborder="0" scrolling="no"> 
        </iframe>
    </c:if>   
       <div class="lui_list_operation">
			<div style='color: #979797;float: left;padding-top:1px;'>
				${ lfn:message('list.orderType') }：
			</div>
			<div style="float:left">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="6" >
						<list:sort property="fdLastPostTime" text="${lfn:message('km-forum:kmForumTopic.order.fdLastPostTime')}" group="sort.list" value="down"></list:sort>
						<list:sort property="docCreateTime" text="${lfn:message('km-forum:kmForumTopic.order.docCreateTime')}" group="sort.list"></list:sort>
						<list:sort property="fdReplyCount;fdHitCount" text="${lfn:message('km-forum:kmForumTopic.order.replyAndHit')}" group="sort.list"></list:sort>
					</ui:toolbar>
				</div>
			</div>
			<div style="float:left;">	
				<list:paging layout="sys.ui.paging.top" > 		
				</list:paging>
			</div>
			<div style="float:right">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar count="3" >
						<%-- 发帖 --%>
						 <kmss:auth requestURL="/km/forum/km_forum/kmForumPost.do?method=add&owner=true" requestMethod="GET">	
							<ui:button id="add" text="${lfn:message('km-forum:kmForum.button.publish')}" onclick="addDoc()" order="2"></ui:button>	
						 </kmss:auth>	
						<%-- 删除 --%>
						 <ui:button id="delete" text="${lfn:message('button.delete')}" onclick="delDoc()" order="3"></ui:button>
					    <%--转移--%>		
					     <ui:button id="move" text="${lfn:message('km-forum:kmForumCategory.button.changeDirectory')}" onclick="showMove()" order="3"></ui:button>
					</ui:toolbar>
				</div>
			</div>
		</div>
	    <ui:fixed elem=".lui_list_operation"></ui:fixed>
     	<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/km/forum/km_forum/kmForumTopicIndex.do?method=listChildren'}
			</ui:source>
			<list:colTable isDefault="true" layout="sys.ui.listview.columntable" 
				rowHref="/km/forum/km_forum/kmForumPost.do?method=!{method}&fdTopicId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props=""></list:col-auto>
			</list:colTable>
		</list:listview> 
		<list:paging></list:paging>	 
		<br>
        <%--快速发帖--%>
	    <kmss:auth requestURL="/km/forum/km_forum/kmForumPost.do?method=add&owner=true" requestMethod="GET">
			<div class="forum_quickPost" id="forum_quickPost">
			    <iframe style="margin-bottom: -4px" src="${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=add&forward=quickPostEdit" id="forumPost" width="100%" height="500px" frameborder="0" scrolling="no">
			    </iframe>
			</div>
		</kmss:auth>
		<script type="text/javascript"><!--
	    var SYS_SEARCH_MODEL_NAME ="com.landray.kmss.km.forum.model.KmForumTopic";
	    var hasCategory = true;
	    var canAdd = true;
	 	    
			seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog , topic) {

				// 监听新建更新等成功后刷新
				topic.subscribe('successReloadPage', function() {
					topic.publish('list.refresh');
				});
				
				//根据地址获取板块
                window.getCategoryIdByHash = function(){
                	var hash = window.location.hash;
                	if(hash.indexOf("categoryId")<0){
                        return "";
                      }
                	var url = hash.split("cri.q=")[1];
				    var reg = new RegExp("(^|;)"+ "categoryId" +":([^;]*)(;|$)");
				    var r=url.match(reg);
					    if(r!=null){
					    	 return unescape(r[2]);
					    }
					    return "";
                    };
				
				//新建
				window.addDoc = function() {
				    var fdForumId = getCategoryIdByHash();
				    if(fdForumId!="" && canAdd){
				    	Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumPost.do" />?method=add&fdForumId='+fdForumId);
				    }else{
				    	Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumPost.do" />?method=add');
				     
				    }
				};
				//删除
				window.delDoc = function(){
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
							$.post('${LUI_ContextPath}/km/forum/km_forum/kmForumTopic.do?method=deleteall&fdForumId='+getCategoryIdByHash(),
									$.param({"List_Selected":values},true),delCallback,'json');
						}
					});
				};
                //板块转移
				window.showMove = function() {
					var values = [];
					$("input[name='List_Selected']:checked").each(function(){
							values.push($(this).val());
						});
					if(values.length==0){
						dialog.alert('<bean:message key="page.noSelect"/>');
						return;
					}
	                dialog.iframe("/km/forum/km_forum/kmForumTopic.do?method=showMove&fdId="+values+"&fdForumId="+getCategoryIdByHash()+"&type=moveAll",
											"${lfn:message('km-forum:kmForumCategory.button.changeDirectory')}",
										function(value){
											    if(value==""||value==null){
										    		   return;
										    	 }
												window.location.reload();}, {
												width : 600,
												height : 300
									});
			      };


			      //检验删除按钮权限
				  window.showButtons = function(forumId) {
					    var url = "${LUI_ContextPath}/km/forum/km_forum/kmForumTopicIndex.do?method=checkAuth";
						var data ={forumId:forumId};
						LUI.$.ajax({
							url: url,
							type: 'get',
							dataType: 'json',
							async: false,
							data: data,
							success: function(data, textStatus, xhr) {
								if(data.canDelete==true){
									 if(LUI('delete')){LUI('delete').setVisible(true);	}
								}else{
									 if(LUI('delete')){LUI('delete').setVisible(false);	}
								}

								if(data.canMove==true){
									 if(LUI('move')){LUI('move').setVisible(true);	}
								}else{
									 if(LUI('move')){LUI('move').setVisible(false);	}
								}
								//该板块无添加权限
								if(data.canAdd ==true){
									 canAdd = true;
							        $("#forumPost").attr("src","${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=add&forward=quickPostEdit&fdForumId="+forumId);
							     }else{
							    	 canAdd = false;
							        $("#forumPost").attr("src","${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=add&forward=quickPostEdit");
							     }
							}
						});
					};
								      
			      
			  	LUI.ready(function(){
			  		 if(LUI('delete')){LUI('delete').setVisible(true);}
			  		 var forumId = '${param.categoryId}';
			  		 showButtons(forumId);
			  		 //初始化进入
			  		 if(forumId!=""){
			  			 window.location.hash="#cri.q=categoryId:"+forumId;
				  		}
				});
				
				topic.subscribe('criteria.changed',function(evt) {
					var hasCategory = false; 
				    if (evt['criterions'].length > 0) {
					   for ( var i = 0; i < evt['criterions'].length; i++) {
						   //板块
                           if(evt['criterions'][i].key=="categoryId"){
                                  //由于要加载路径信息和删除按钮
                        	      hasCategory = true;
     							  var categoryId = evt['criterions'][i].value[0];
     							  //检查按钮权限
     							  showButtons(categoryId);
     							  //刷新板块信息
     							  if( $("#forumCategory").is(":hidden")){
     							      $("#forumCategory").show();
     							  }
     							  $("#forumCategory").attr("src","${LUI_ContextPath}/km/forum/km_forum_cate/kmForumCategory.do?method=main&type=criteria&categoryId="+categoryId);
     	     				 }
					     }
				     }
				    //筛选器去掉板块选择
				    if(hasCategory == false){
					      //检查按钮权限
					      showButtons("");
				         // $("#forumCategory").attr("src","${LUI_ContextPath}/km/forum/km_forum_cate/kmForumCategory.do?method=main&type=criteria");
				         //隐藏
						  if($("#forumCategory").is(":visible")){
						       $("#forumCategory").hide();
						  }
				    }
				  });

				window.delCallback = function(data) {
					if (window.del_load != null)
						window.del_load.hide();
					if (data != null && data.status == true) {
						topic.publish("list.refresh");
						dialog.success('<bean:message key="return.optSuccess" />');
						} else {
						dialog.failure('<bean:message key="return.optFailure" />');
						}
					  };
					});
    </script>	 
	</template:replace>
</template:include>
